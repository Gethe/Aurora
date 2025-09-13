import os
import glob
from git import Repo

version = '0.1.0'
author = 'Hanshi/arnvid'

aurora_path = './Skin/Interface/AddOns'
wou_ui_sources_git = '../../wow-ui-source'
wou_ui_sources = '../../wow-ui-source/Interface/AddOns'

aurora_specials = []
aurora_addons = ['Blizzard_FrameXML', 'Blizzard_FrameXMLBase', 'Blizzard_SharedXML', 'Blizzard_SharedXMLBase',
                 'Blizzard_UIPanels_Game', 'Blizzard_UnitPopup', 'Blizzard_UIParent', 'Blizzard_StaticPopup_Frame',
                 'Blizzard_PlayerSpells', 'Blizzard_GroupFinder', 'Blizzard_QuickJoin', 'Blizzard_ActionBar',
                 'Blizzard_MoneyFrame','Blizzard_UIPanelTemplates','Blizzard_GarrisonBase', 'Blizzard_ChatFrame',
                 'Blizzard_StaticPopup_Game', 'Blizzard_ActionBar', 'Blizzard_Menu','Blizzard_ChatFrameBase',
                 'Blizzard_UIMenu'
                ]

isLive = False
isPTR = False
isClassic = False
isBeta = False

isRetail = False
isVanilla = False
isTBC = False
isWrath = False
isCata = False
isMists = False

ADP_Retail = 0
ADP_Vanilla = 10
ADP_TBC = 20
ADP_Wrath = 30
ADP_Cata = 40
ADP_Mists = 40
ADP_WoWLabs= 99

xml_header = "<Ui xmlns=\"http://www.blizzard.com/wow/ui/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.blizzard.com/wow/ui/\nhttps://raw.githubusercontent.com/Meorawr/wow-ui-schema/main/UI.xsd\">\n"
xml_script_header = "    <Script>\n        _G.AURORA_DEBUG_PROJECT = %s\n    </Script>\n" 
xml_info_addons = "    <!-- This section is added for %s by the Aurora XML Updater -->\n"
xml_info_addons_end = "    <!-- End of section added for %s by the Aurora XML Updater -->\n"
xml_include_lua = "    <Script file=\"%s\"/>\n"
xml_no_include_lua = "    <!--Script file=\"%s\"/-->\n"
xml_space = "\n"
xml_footer = "</Ui>"
dontupdate_toc_types = ['WowLabs']
replace_family_with = "Mainline"

def _app_intro():
    global version
    print(f"Aurora XML Updater v{version} by {author} - (c) 2024\n")
    
def check_git_branch():
    global isLive, isClassic, dontupdate_toc_types
    repo = Repo(wou_ui_sources_git)
    branch = repo.active_branch
    print(f"Current branch: {branch}")
    if branch.name == 'live':
        dontupdate_toc_types.append('TBC')
        dontupdate_toc_types.append('Cata')
        dontupdate_toc_types.append('Wrath')
        dontupdate_toc_types.append('Vanilla')
        dontupdate_toc_types.append('Classic')
        isLive = True
    elif branch.name == 'ptr2':
        dontupdate_toc_types.append('TBC')
        dontupdate_toc_types.append('Cata')
        dontupdate_toc_types.append('Wrath')
        dontupdate_toc_types.append('Vanilla')
        dontupdate_toc_types.append('Classic')
        dontupdate_toc_types.append('Mists')
    elif branch.name == 'classic':
        dontupdate_toc_types.append('Mainline')
        isClassic = True

def init_xml_file(file_path, adp):
    print(f"Creating {file_path} - {adp}")
    with open(file_path, 'w+') as file:
        file.write(xml_header)
        file.write(xml_space)
        file.write(xml_script_header % adp)
        file.write(xml_space)
        file.close()

def write_xml_file(file_path, lua_file, found):
    with open(file_path, 'a+') as file:
        if found:
            file.write(xml_include_lua % lua_file)
        else:
            file.write(xml_no_include_lua % lua_file)
        file.close()

def write_xml_file_line(file_path, line):
    with open(file_path, 'a+') as file:
        file.write(line)
        file.close()


def close_xml_file(file_path):
    with open(file_path, 'a+') as file:
        file.write(xml_space)
        file.write(xml_footer)
        file.close()
       
def determine_adp(toc_type):
    if toc_type == 'Mainline':
        return ADP_Retail
    elif toc_type == 'Classic':
        return ADP_Vanilla
    elif toc_type == 'Vanilla':
        return ADP_Vanilla
    elif toc_type == 'TBC':
        return ADP_TBC
    elif toc_type == 'Wrath':
        return ADP_Wrath
    elif toc_type == 'Cata':
        return ADP_Cata
    elif toc_type == 'Mists':
        return ADP_Mists
    elif toc_type == 'WowLabs':
        return ADP_WoWLabs
    else:
        return ADP_Retail  # Default to Retail if type is unknown
    
def determine_toc_type(toc_file):
    global isTBC, isWrath, isCata, isVanilla, isRetail
    filename = os.path.basename(toc_file).lower()
    if 'wowlabs' in filename:
        return 'WowLabs'
    elif 'classic' in filename:
        isVanilla = True
        return 'Classic'    
    elif 'vanilla' in filename:
        isVanilla = True
        return 'Vanilla'    
    elif 'tbc' in filename:
        isTBC = True
        return 'TBC'
    elif 'wrath' in filename:
        isWrath = True
        return 'Wrath'
    elif 'cata' in filename:
        isCata = True
        return 'Cata'
    elif 'mists' in filename:
        isMists = True
        return 'Mists'    
    elif 'mainline' in filename:
        isRetail = True
        return 'Mainline'
    elif 'standard' in filename:
        return 'Mainline'
    else:
        return 'Mainline'

def process_aurora_specials(table_data, aurora_specials):
    global dontupdate_toc_types
    for entry in table_data:
        directory, toc_file, toc_type = entry
        if directory in aurora_specials and not toc_type in dontupdate_toc_types:
            adp = determine_adp(toc_type)
            toc_file_name = format(f"_{toc_type}.xml")
            xml_file_path = os.path.join(aurora_path, directory, directory + toc_file_name)
            init_xml_file(xml_file_path, adp)
            # print(f"Directory: {directory}, TOC File: {toc_file}, TOC Type: {toc_type}")    
            read_toc_for_aurora_specials(toc_file, directory, xml_file_path)
            close_xml_file(xml_file_path)


def read_toc_for_aurora_specials(toc_file, directory, xml_file_path):
    processed_lines = {}  # Dictionary to store previously found lines
    with open(toc_file, 'r') as file:
        content = file.read()
        lines = content.splitlines()
        for line in lines:
            if not line.startswith('#'):
                filename = os.path.splitext(line)[0]
                filename = filename.replace('[Family]', replace_family_with)
                toc_file_entry = format(f"{filename}.lua")
                lua_file_path = os.path.join(aurora_path, directory, filename) + '.lua'
                if not toc_file_entry in processed_lines:
                    processed_lines[toc_file_entry] = True
                    write_xml_file(xml_file_path, toc_file_entry, os.path.exists(lua_file_path))       

def read_toc_for_aurora_addons(toc_file, directory, xml_file_path):
    processed_lines = {}  # Dictionary to store previously found lines
    write_xml_file_line(xml_file_path, xml_info_addons % directory)    
    with open(toc_file, 'r') as file:
        content = file.read()
        lines = content.splitlines()
        for line in lines:
            if not line.startswith('#'):
                filename = os.path.splitext(line)[0]
                filename = filename.replace('[Family]', replace_family_with)  # Replace spaces with underscores
                toc_file_entry = format(f"{directory}\{filename}.lua")
                lua_file_path = os.path.join(aurora_path, directory, filename) + '.lua'
                if not toc_file_entry in processed_lines:
                    processed_lines[toc_file_entry] = True
                    write_xml_file(xml_file_path, toc_file_entry, os.path.exists(lua_file_path)) 
    write_xml_file_line(xml_file_path, xml_info_addons_end % directory)    


def process_aurora_addons(table_data, aurora_addons, aurora_specials):
    global dontupdate_toc_types    
    created_tocs = {}
    processed_lines = {}
    for entry in table_data:
        directory, toc_file, toc_type = entry
        if directory in aurora_specials:
            continue
        if not toc_type in dontupdate_toc_types:
            toc_file_name = format(f"AddOns_{toc_type}.xml")
            xml_file_path = os.path.join(aurora_path, toc_file_name)            
            if not toc_type in created_tocs:
                adp = determine_adp(toc_type)
                init_xml_file(xml_file_path, adp)
                created_tocs[toc_type] = True
            if directory in aurora_addons:
                read_toc_for_aurora_addons(toc_file, directory, xml_file_path)
            else:
                toc_file_entry = format(f"{directory}\{directory}.lua")
                lua_file_path = os.path.join(aurora_path, toc_file_entry)
                if not toc_file_entry in processed_lines:
                    processed_lines[toc_file_entry] = True
                    write_xml_file(xml_file_path, toc_file_entry, os.path.exists(lua_file_path))       

    for toc_type in created_tocs:
        toc_file_name = format(f"AddOns_{toc_type}.xml")
        xml_file_path = os.path.join(aurora_path, toc_file_name)             
        close_xml_file(xml_file_path)   


def find_and_list_toc_files(base_folder):
    toc_files_dict = {}
    directories = [d for d in os.listdir(base_folder) if os.path.isdir(os.path.join(base_folder, d))]
    for directory in directories:
        search_path = os.path.join(base_folder, directory, '*.toc')
        toc_files = glob.glob(search_path)
        toc_files_dict[directory] = toc_files
    return toc_files_dict
 
def read_toc_files(table_data):
    global dontupdate_toc_types
    for entry in table_data:
        directory, toc_file, toc_type = entry
        if toc_type in dontupdate_toc_types:
            continue
        with open(toc_file, 'r') as file:
            content = file.read()
            print(f"Directory: {directory}, TOC File: {toc_file}, TOC Type: {toc_type}")
            print(f"Content of {toc_file}:\n{content}\n")

def find_and_list_unusued_files():
    print("Searching for unused .lua files in the Aurora path...")

    # Collect all .lua files in aurora_path subfolders
    all_lua_files = set()
    for root, dirs, files in os.walk(aurora_path):
        for file in files:
            if file.endswith('.lua'):
                rel_path = os.path.relpath(os.path.join(root, file), aurora_path)
                all_lua_files.add(rel_path.replace("\\", "/"))

    # Use processed_lines from process_aurora_addons for referenced .lua files
    # If not available globally, collect here as fallback
    global processed_lines
    processed_lua_files = set()
    if 'processed_lines' in globals() and isinstance(processed_lines, dict):
        processed_lua_files = set(k.replace("\\", "/") for k in processed_lines.keys())
    else:
        for root, dirs, files in os.walk(aurora_path):
            for file in files:
                if file.endswith('.xml'):
                    xml_path = os.path.join(root, file)
                    with open(xml_path, 'r', encoding='utf-8') as f:
                        for line in f:
                            if 'Script file="' in line:
                                start = line.find('Script file="') + len('Script file="')
                                end = line.find('"', start)
                                lua_file = line[start:end]
                                lua_file = lua_file.lstrip("./\\")
                                processed_lua_files.add(lua_file.replace("\\", "/"))

    unused_files = all_lua_files - processed_lua_files
    if unused_files:
        print("Unused .lua files found:")
        for file in sorted(unused_files):
            print(f"- {file}")
    else:
        print("No unused .lua files found.")

# Example usage
# find_and_read_toc_files(wou_ui_sources)
_app_intro()
check_git_branch()
print(f"Ignoring updates for the following TOC types: {dontupdate_toc_types}\n")
toc_files_dict = find_and_list_toc_files(wou_ui_sources)
table_data = []
for directory, toc_files in toc_files_dict.items():
    for toc_file in toc_files:
        toc_type = determine_toc_type(toc_file)
        table_data.append([directory, toc_file, toc_type])

# # read_toc_for_aurora_specials(table_data)
process_aurora_specials(table_data, aurora_specials)
process_aurora_addons(table_data, aurora_addons, aurora_specials)
find_and_list_unusued_files()

print(f"\nExpansions Detected in this run:")
print(f"Retail {isRetail}, Classic {isVanilla}, Classic/Wrath {isWrath}, Classic/Cata {isCata}, Classic/Mists {isMists}, Classic/TBC {isTBC}\n")
