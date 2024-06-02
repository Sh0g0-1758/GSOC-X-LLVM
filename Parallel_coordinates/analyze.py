from colorama import init, Fore, Back, Style
init()
import os
import re
from collections import defaultdict
from yellowbrick.features import ParallelCoordinates
import numpy as np
import matplotlib.pyplot as plt

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

directories = [
    '../data/plain',
    '../data/recursion_limit',
    '../data/cl_limit',
]

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

print(Style.RESET_ALL + "Successfully merged dictionaries:")

mean_dict = {key: np.mean(values) for key, values in merged_dict.items()}
threshold = 100
filtered_dict = {key: values for key, values in merged_dict.items() 
                 if not all(abs(value - mean_dict[key]) <= threshold for value in values)}

X = [[] for _ in range(num_directories)]
features = []
for inst in filtered_dict:
    features.append(inst)
    for idx in range(num_directories):
        X[idx].append(filtered_dict[inst][idx])
X = np.array(X)

y = np.array([i for i in range(num_directories)])
classes = ["Normal Compiler", "Compiler with recursion limit=6", "Compiler with cl_limit=500"]
visualizer = ParallelCoordinates(classes=classes, features=features, normalize='standard', size=(1600, 1600))

visualizer.fit_transform(X,y)
plt.xticks(rotation=90)
plt.subplots_adjust(bottom=0.35)
visualizer.show(outpath="parallel_coordinates.pdf", dpi=300)
