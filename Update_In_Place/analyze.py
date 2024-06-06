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

imp_stats_dict = process_imp_stats_file_to_dict("stats_imp.txt")
amb_stats_dict = process_rest_stats_file_to_dict("stats_amb.txt")
ignore_stats_dict = process_rest_stats_file_to_dict("stats_ignore.txt")

line_pattern = re.compile(r'^\s*(\d+)\s+(\S+)\s+-\s+(.*)$')

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

def process_directory(directory_path):
    directory_stats_dict = defaultdict(int)
    for root, dirs, files in os.walk(directory_path):
        for file in files:
            file_path = os.path.join(root, file)
            process_file(file_path, directory_stats_dict)
    return dict(directory_stats_dict)

directories = []

for i in range(50,1050,50):
    directories.append(f"cl_limit_{i}")

director_dict = []

for directory in directories:
    directory_stats_dict = process_directory(directory)
    print(Fore.GREEN + f"Successfully collected stats for directory {directory}:")
    director_dict.append(directory_stats_dict)

merged_dict = {}

for idx, directory_stats_dict in enumerate(director_dict):
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

num_directories = len(director_dict)
for key in merged_dict.keys():
    while len(merged_dict[key]) < num_directories:
        merged_dict[key].append(0)

print(Fore.BLUE + "Successfully merged dictionaries:")

filtered_dict = {key: values for key, values in merged_dict.items() 
                 if len(set(values)) > 1}

final_dict = {}

for key, values in filtered_dict.items():
    if(key in imp_stats_dict):
        final_dict[key] = values
        # print(Fore.GREEN + f"{key}: {values} - {imp_stats_dict[key]}" + Fore.RESET)
    elif(not key in amb_stats_dict and not key in ignore_stats_dict):
        print(key)
        # print(Fore.RED + f"ERROR: Key {key} not found in any of the dictionaries" + Fore.RESET)

print(Fore.BLUE + "Successfully generated final dictionary." + Fore.RESET)

file_path = 'stats_result.json'

with open(file_path, 'w') as file:
    json.dump(final_dict, file)

print(Fore.BLUE + f"Successfully saved final dictionary to {file_path}." + Fore.RESET)