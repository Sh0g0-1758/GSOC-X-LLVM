import sys
from tabulate import tabulate
import matplotlib.pyplot as plt
import numpy as np

import re

tabulate_array = []
data = {}

def add_numbers_in_strings(str1, str2):
    # Extract the numeric parts and suffix parts from the strings
    num1, suffix1 = str1.split(maxsplit=1)
    num2, suffix2 = str2.split(maxsplit=1)
    
    # Check if the suffixes are the same
    if suffix1 != suffix2:
        print(suffix1, suffix2)
        # return f"{num1} {suffix1}"
        raise ValueError("Suffixes do not match.")
    
    # Convert the numeric parts to integers
    num1 = int(num1)
    num2 = int(num2)
    
    # Add the numbers
    result = num1 + num2
    
    # Format the result
    result_str = f"{result} {suffix1}"
    
    return result_str

def replace_number_with_zero(input_string):
    pattern = r'\d+'
    replaced_string = re.sub(pattern, '0', input_string)
    return replaced_string

file_contents = None

try:
    if len(sys.argv) != 2:
        print("Usage: python analyze.py <file_path>")
    else:
        file_path = sys.argv[1]
        with open(file_path, 'r') as file:
            file_contents = file.read()
            
except FileNotFoundError:
    print("File not found.")
    exit(1)
except Exception as e:
    print("An error occurred:", e)
    exit(1)

file_contents = file_contents.split("\n")

diff_values_plain = []
diff_values_alter = []

remove_counter = 0

flag = True

for line in file_contents:
    if line.startswith('<'):
        if(not(flag)):
            if(remove_counter != 0):
                for i in range(len(diff_values_alter),len(diff_values_plain)):
                    diff_values_alter.append([diff_values_plain[i][0], replace_number_with_zero(diff_values_plain[i][1]).strip()])
            flag = True
            remove_counter = 0
        parts = line.strip().split(' - ')
        diff_values_plain.append([parts[1].strip(), parts[0][2:].strip()])
        remove_counter += 1
    elif line.startswith('>'):
        if(flag):
            flag = False
        parts = line.strip().split(' - ')
        diff_values_alter.append([parts[1].strip(), parts[0][2:].strip()])
        if(remove_counter == 0):
            diff_values_plain.append([parts[1].strip(), replace_number_with_zero(parts[0][2:]).strip()])
        else:
            remove_counter -= 1

# print(len(diff_values_plain), len(diff_values_alter))

for i in range(len(diff_values_alter)):
    num1, suffix1 = diff_values_plain[i][1].split(maxsplit=1)
    num2, suffix2 = diff_values_alter[i][1].split(maxsplit=1)
    if(suffix1 != suffix2):
        continue
    if(diff_values_alter[i][0] != diff_values_plain[i][0]):
        continue
    key = diff_values_alter[i][0] + " (" + suffix1 + ")"
    if(key in data):
        data[key] = [add_numbers_in_strings(data[key][0] , diff_values_plain[i][1]), add_numbers_in_strings(data[key][1] , diff_values_alter[i][1])]
    else:
        data[key] = [diff_values_plain[i][1], diff_values_alter[i][1]]

for inst in data:
    tabulate_array.append([inst, data[inst][0], data[inst][1]])

comparison_table = tabulate(tabulate_array, headers=["Description", "Normal Compiler", "Compiler with recursion limit=6"], tablefmt="grid")
# print(len(diff_values_alter))
# print(counter)
print("#### Comparison Table ####")
print(comparison_table)
