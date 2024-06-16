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

    if not os.path.exists("results"):
        os.mkdir("results")

    imp_stats_dict = process_imp_stats_file_to_dict("stats_imp.txt")
    amb_stats_dict = process_rest_stats_file_to_dict("stats_amb.txt")
    ignore_stats_dict = process_rest_stats_file_to_dict("stats_ignore.txt")

    stats_dict = process_directory("./stats")

    final_dict = {}

    for key, values in stats_dict.items():
        if(key in imp_stats_dict):
            final_dict[key] = values
        elif(not key in amb_stats_dict and not key in ignore_stats_dict):
            print(Fore.RED + f"ERROR: STAT {key} not found in any of the known STATS" + Fore.RESET)
            sys.exit(1)

    print(Fore.BLUE + "Successfully generated final dictionary." + Fore.RESET)

    file_path = f"./results/result.json"

    with open(file_path, 'w') as file:
        json.dump(final_dict, file)

    print(Fore.BLUE + f"Successfully saved final dictionary to {file_path}." + Fore.RESET)
