import re

def separate_knob_value(line):
    # Use regular expression to match the last value in parentheses
    match = re.search(r'\(([^)]+)\)$', line)
    if match:
        value = match.group(1)  # Extract the value
        knob_name = line[:match.start()].strip()  # Get the rest of the string
        return knob_name, value
    else:
        # If no match found, return the line and None
        return line.strip(), None

def process_file(file_path):
    missing_stats = {}
    metadata_dict = {}

    with open(file_path, 'r') as file:
        for line in file:
            line = line.strip()
            if line.startswith("Missing"):
                value = line.split("Missing stats for knob")[-1].split(":")[0].strip()
                missing_stats[value] = True
            else:
                key, value = separate_knob_value(line)
                metadata_dict[key] = value

    return missing_stats, metadata_dict

file_path = 'missing_stats.txt'
missing_stats, metadata_dict = process_file(file_path)

# print("Missing Stats:", missing_stats)

# for k in missing_stats:
#     print(k)

for key, value in metadata_dict.items():
    print(value)
