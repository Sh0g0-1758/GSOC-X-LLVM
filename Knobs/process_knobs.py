import re
from tabulate import tabulate

def discover_potential_knobs(file_path):
    pattern_one = r"Potential knob discovered at (.+)"
    pattern_two = r"Name: (.+)"
    pattern_three = r"Type: (.+)"
    locations = []
    Names = []
    Types = []

    with open(file_path, 'r') as file:
        for line in file:
            match_one = re.search(pattern_one, line)
            match_two = re.search(pattern_two, line)
            match_three = re.search(pattern_three, line)
            if match_one:
                location = match_one.group(1)
                locations.append(location.strip())
            elif match_two:
                name = match_two.group(1)
                Names.append(name.strip())
            elif match_three:
                type = match_three.group(1)
                Types.append(type.strip())
    return (locations, Names, Types)

def remove_substring_from_locations(locations, substring):
    cleaned_locations = [location.replace(substring, '') for location in locations]
    return cleaned_locations

file_path = 'all_knobs.txt'
locations,names,types = discover_potential_knobs(file_path)
locations = remove_substring_from_locations(locations, '/home/shogo/master/gsoc/../dev/llvm-project/')
tabulate_array = []

# print(len(locations), len(names), len(types))
for i in range(len(types)):
    if(types[i] == "const char" or types[i] == "cl::opt<_Bool>" or types[i] == "cl::opt<std::string>" or types[i] == "const char32_t"):
        continue
    tabulate_array.append([locations[i], names[i], types[i]])
#     tabulate_array.append([locations[i], names[i], types[i]])

for i in range(len(tabulate_array)):
    print(tabulate_array[i][2])


# knobs_table = tabulate(
#     tabulate_array,
#     headers=["Location", "Name",
#              "Type"],
#     tablefmt="grid",
# )

# print("### KNOBS TABLE ###")
# print(knobs_table)
# print(locations)
# print(names)
# print(types)
