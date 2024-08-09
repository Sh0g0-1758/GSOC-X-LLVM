import os
import json

directory_path = './results'


def process_data(data):
    # Do something with the data
    compile_time = data['stats_val']['compile-time (instructions)']
    bitcode_size = data['stats_val']['bitcode-size (bytes)']
    flag = False
    for val in compile_time:
        if val < -7.0:
            flag = True
    for val in bitcode_size:
        if val < -7.0:
            flag = True
    return flag

for filename in os.listdir(directory_path):
    if filename.endswith('.json'):
        file_path = os.path.join(directory_path, filename)
        
        # Open and read the JSON file
        with open(file_path, 'r') as file:
            data = json.load(file)
            if process_data(data):
                print(filename.replace('.json', ''))

print("###########################################################")

directory_path = './extended_results'
for filename in os.listdir(directory_path):
    if filename.endswith('.json'):
        file_path = os.path.join(directory_path, filename)
        
        # Open and read the JSON file
        with open(file_path, 'r') as file:
            data = json.load(file)
            if process_data(data):
                print(filename.replace('.json', ''))