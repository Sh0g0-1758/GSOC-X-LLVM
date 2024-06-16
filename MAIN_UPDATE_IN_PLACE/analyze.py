from colorama import init, Fore, Back, Style
init()
import os
import re
import sys
from collections import defaultdict
from yellowbrick.features import ParallelCoordinates
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import json

# Constant for the pattern of the line
line_pattern = re.compile(r'^\s*(\d+)\s+(\S+)\s+-\s+(.*)$')

# Making a dict of important stats
def process_imp_stats_file_to_dict(file_path):
    result_dict = {}

    with open(file_path, 'r') as file:
        lines = file.readlines()
    
    for line in lines:
        parts = line.strip().split('#')
        first_value = parts[0].strip()
        second_value = parts[1].strip()
        third_value = parts[2].strip()
        
        key = f"{first_value} ({second_value})"
        
        value = 1 if third_value == "More is Better" else 0
        
        result_dict[key] = value
    
    return result_dict

# Making a dict of ambiguous and ignore stats
def process_rest_stats_file_to_dict(file_path):
    result_dict = {}

    with open(file_path, 'r') as file:
        lines = file.readlines()
    
    for line in lines:
        parts = line.strip().split('#')
        first_value = parts[0].strip()
        second_value = parts[1].strip()
        
        key = f"{first_value} ({second_value})"
        
        value = -1
        
        result_dict[key] = value
    
    return result_dict

# Process a single file and update the stats dictionary
def process_file(file_path, stats_dict):
    with open(file_path, 'r') as file:
        for line in file:
            match = line_pattern.match(line)
            if match:
                value = int(match.group(1))
                component = match.group(2)
                description = match.group(3)
                key = f"{description} ({component})"
                stats_dict[key] += value

# Collect stats for all files present in one directory
def process_directory(directory_path):
    directory_stats_dict = defaultdict(int)
    for root, dirs, files in os.walk(directory_path):
        for file in files:
            file_path = os.path.join(root, file)
            process_file(file_path, directory_stats_dict)
    return dict(directory_stats_dict)



if __name__ == "__main__":

    knob_name = os.environ.get('KNOB_NAME')

    if not os.path.exists("results"):
        os.mkdir("results")

    imp_stats_dict = process_imp_stats_file_to_dict("stats_imp.txt")
    amb_stats_dict = process_rest_stats_file_to_dict("stats_amb.txt")
    ignore_stats_dict = process_rest_stats_file_to_dict("stats_ignore.txt")

    directories = []
    directory_path = "directory_name.txt"
    try:
        with open(directory_path, 'r') as file:
            for line in file:
                if(line == '\n'):
                    continue
                directories.append(line.rstrip('\n'))
    except FileNotFoundError:
        print(f"Error: The file '{directory_path}' was not found.")
    except IOError:
        print(f"Error: Could not read the file '{directory_path}'.")

    directory_dict = []

    for directory in directories:
        directory_stats_dict = process_directory(directory)
        print(Fore.GREEN + f"Successfully collected stats for directory {directory}:" + Fore.RESET)
        directory_dict.append(directory_stats_dict)

    merged_dict = {}

    for idx, directory_stats_dict in enumerate(directory_dict):
        for key, value in directory_stats_dict.items():
            if key in merged_dict:
                while len(merged_dict[key]) < idx:
                    merged_dict[key].append(0)
                merged_dict[key].append(value)
            else:
                merged_dict[key] = []
                for _ in range(idx):
                    merged_dict[key].append(0)
                merged_dict[key].append(value)

    num_directories = len(directory_dict)

    for key in merged_dict.keys():
        while len(merged_dict[key]) < num_directories:
            merged_dict[key].append(0)

    print(Fore.BLUE + f"Successfully merged dictionaries for the knob : {knob_name} " + Fore.RESET)

    filtered_dict = {key: values for key, values in merged_dict.items() 
                    if len(set(values)) > 1}

    final_dict = {}

    for key, values in filtered_dict.items():
        if(key in imp_stats_dict):
            final_dict[key] = values
        elif(not key in amb_stats_dict and not key in ignore_stats_dict):
            print(Fore.RED + f"ERROR: STAT {key} not found in any of the known STATS" + Fore.RESET)
            sys.exit(1)

    print(Fore.BLUE + "Successfully generated final dictionary." + Fore.RESET)

    file_path = f"./results/{knob_name}_result.json"

    with open(file_path, 'w') as file:
        json.dump(final_dict, file)

    print(Fore.BLUE + f"Successfully saved final dictionary to {file_path}." + Fore.RESET)
