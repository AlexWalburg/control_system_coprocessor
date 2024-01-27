import csv
import re

def generate_system_params_mapping(f):
    """
    Generates dictionary to a list of tuples, eg
    {"Order1": [('MSB','$INTERNAL_MSB')...]}

    @param f: csv file to read
    """
    reader = csv.reader(f)
    retdict = {}
    for i, row in enumerate(reader):
        row = list(filter(lambda x: x,row))
        size = len(row)
        if(size % 2 == 0):
            raise ValueError(f"Row {i+1} does not have an odd number of values!")
        name = row[0]
        
        tuplelist = [(row[i],row[i+1]) for i in range(1,size,2)]
        retdict[name] = tuplelist
    return retdict

def generate_port_synth_params(f):
    """
    Wrapper around csvdictreader for main floor plan read
    """
    reader = csv.DictReader(f,delimiter=',', quotechar='"')
    expected_keys = {"Type","PortName","ID","AddrID","ParamID","DefaultParam","ReadPort","ReadID","ExtraData","ExtraID","ExtraAddrID"}
    ret_list = []
    for i, row in enumerate(reader):
        if(i == 0 and set(row.keys()) != expected_keys):
            raise ValueError(f"""Floorplan csv not as expected.
            Make sure you have the following fields:\n {expected_keys}
            Instead found:\n {set(row)}""")
        new_dict = {}
        for key,value in row.items():
            new_dict[key] = None if value=='' else value
        ret_list.append(new_dict)
    return ret_list

def generate_params_list_string(port_synth_list,param_list_size=32,param_size=25):
    """
    Creates system params additionas after pasing the params
    """
    systemParams = {}
    paramOffset = 0
    retString = "{"
    # put the initial readid's
    for element in port_synth_list:
        for idname in ["ReadID","ExtraID"]:
            Id = element[idname]
            if Id is not None:
                Id = int(Id)
                retString+=(f"{param_list_size}'h{hex(Id)[2:]},\n")
                paramOffset+=1
    justaddrscpy = retString[:-2] + "}"
    systemParams["NUM_UNITS"] = paramOffset
    # now add params
    for element in port_synth_list:
        defparam = element["DefaultParam"]
        if defparam is not None:
            defparam = int(defparam)
            sign_extended_param = format(defparam, f'0{param_size}b')
            retString+=(f"{param_list_size}'h{sign_extended_param},\n")
            paramOffset+=1
    systemParams["AXI_SIZE"] = paramOffset*param_list_size
    systemParams["INITIAL_ADDRS"] = justaddrscpy
    systemParams["INITIAL_AXIUNITS"] = retString + "}"
    return systemParams

def load_templates(names):
    retDict = {}
    for n in names:
        with open(f"{n}.vtemplate") as f:
            retDict[n] = f.read()
    return retDict

def multireplace(string, replacements):
    """
    Given a string and a replacement map, it returns the replaced string.
    :param str string: string to execute replacements on
    :param dict replacements: replacement dictionary {value to find: value to replace}
    :param bool ignore_case: whether the match should be case insensitive
    :rtype: str
    """
    if not replacements:
        # Edge case that'd produce a funny regex and cause a KeyError
        return string
    rep_sorted = sorted(replacements, key=len, reverse=True)
    rep_escaped = map(re.escape, rep_sorted)
    
    # Create a big OR regex that matches any of the substrings to replace
    pattern = re.compile("\\$(" + "|".join(rep_escaped) + ")")
    
    # For each match, look up the new string in the replacements, being the key the normalized old string
    return pattern.sub(lambda match: str(replacements[match.group(1)]), string)

def write_with_replacement(w,text,params):
    newtext = multireplace(text,params)
    w.write(newtext)

def write_board(floorplan_file,sysparams_file,w,system_params):
    floorplan = generate_port_synth_params(floorplan_file)
    mapping = generate_system_params_mapping(sysparams_file)
    all_types = set((i["Type"] for i in floorplan))
    all_types.update(["interconnect","footer"])
    templates = load_templates(all_types)
    system_params.update(generate_params_list_string(floorplan))
    # first write the top level template
    write_with_replacement(w,templates["interconnect"],system_params)
    for entry in floorplan:
        type = entry["Type"]
        entry_replace_dict = system_params.copy()
        entry_replace_dict.update(entry)
        entry_replace_dict.update(mapping[entry["PortName"]])
        write_with_replacement(w,templates[type],entry_replace_dict)

    write_with_replacement(w,templates["footer"],system_params)
    
    
    
