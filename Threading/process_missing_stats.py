def process_file(file_path):
    missing_stats = []
    metadata_dict = {}

    with open(file_path, 'r') as file:
        for line in file:
            line = line.strip()
            if line.startswith("Missing"):
                value = line.split("Missing stats for knob")[-1].split(":")[0].strip()
                missing_stats.append(value)
            else:
                parts = line.split("(", 1)
                if len(parts) == 2:
                    key = parts[0].strip()
                    value = parts[1].rstrip(")").strip()
                    metadata_dict[key] = value

    return missing_stats, metadata_dict

file_path = 'missing_stats.txt'
missing_stats, metadata_dict = process_file(file_path)

print("Missing Stats:", missing_stats)

for key, value in metadata_dict.items():
    print(key, ":", value)
