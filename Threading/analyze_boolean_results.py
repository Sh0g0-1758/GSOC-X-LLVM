from colorama import init, Fore, Back, Style
init()
import os
import glob
import json
import numpy as np
import sys
from scipy.stats import pearsonr
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches

def generate_values(number):
    # Some Exceptional Values
    if number == 18446744073709551615 or number == 65535 or number == 4294967295 or number == 8388608:
        values = []
        step = round(number * 0.1)
        count = 1
        values.append(number * 0.2)
        values.append(number * 0.3)
        while (count <= 11):
            values.append(number)
            number -= step
            count += 1
        values = sorted(values)
        return values

    # Handling of Floating Point Numbers
    if (type(number) == float):
        step = number * 0.1
        count = 1
        values = []
        temp = number

        while count <= 6:
            values.append(temp)
            temp -= step
            count += 1

        temp = number + step
        while count <= 11:
            values.append(temp)
            temp += step
            count += 1

        # Exceptional values for experimentation.
        # 200% and 1000%
        if number == 0.0:
            values.append(20.0)
            values.append(100.0)
        else:
            max_val = max(values)
            mult = max_val / number
            mult += 1
            values.append(number * mult)
            mult += 9
            values.append(number * mult)

        values = sorted(values)
        return values

    # Handling of negative numbers
    if number < 0:
        step = round(number * 0.1)
        if(step == 0):
            step = 1
        if(step < 0):
            step = -step
        count = 1
        values = []
        temp = number
        while count <= 6:
            values.append(temp)
            temp -= step
            count += 1
        temp = number + step
        while count <= 11:
            values.append(temp)
            temp += step
            count += 1
        max_val = max(values)
        min_val = min(values)
        values.append(max_val * 2)
        values.append(min_val * 2)
        values = sorted(values)
        return values

    # Standard Values ranging from 50% to 150% of the original number
    # with gaps of 10%
    step = round(number * 0.1)

    if step == 0:
        step = 1

    count = 1
    values = []
    temp = number

    while temp >= 0 and count <= 6:
        values.append(temp)
        temp -= step
        count += 1

    temp = number + step
    while count <= 11:
        values.append(temp)
        temp += step
        count += 1

    # Exceptional values for experimentation.
    # 200% and 1000%
    # Take care that number is not zero
    if number == 0:
        values.append(20)
        values.append(100)
    else:
        max_val = max(values)
        mult = round(max_val / number)
        mult += 1
        values.append(number * mult)
        mult += 9
        values.append(number * mult)

    values = sorted(values)
    return values

# Helper function to convert data to appropriate type
def convert_to_appropriate_type(data, s):
    if s is None or s == '':
        return None

    try:
        return int(s)
    except ValueError:
        pass

    try:
        if (s[-1] == 'f'):
            return float(s[:-1])
        return float(s)
    except ValueError:
        pass

    print(Fore.RED + f"Invalid value: {data} set to {s}" + Fore.RESET)
    exit(0)

# Helper function to read knob names and their values from a file
def read_key_value_file(file_path):
    config_dict = {}

    with open(file_path, 'r') as file:
        for line in file:
            line = line.strip()
            if ':' in line:
                key, value = line.split(':', 1)
                key = key.strip()
                value = value.strip()
                config_dict[key] = value

    return config_dict

# Helper function to convert JSON to a dictionary with arrays
def json_to_dict_with_arrays(file_path):
    with open(file_path, 'r') as file:
        data = json.load(file)
    
    result = {}
    for key, value in data.items():
        result[key] = value
    return result

# Helper function to run the correlation analysis
def run_analyzer(knob_name):
    file_path = f'./Batch5_Results/{knob_name}_result.json'
    data = json_to_dict_with_arrays(file_path)

    # Extract keys (categories) and values
    relative_differece_dict = {}
    for key, values in data.items():
        relative_differece_dict[key] = ((data[key][1] - data[key][0]) / data[key][0]) * 100

    
    keys = list(relative_differece_dict.keys())
    values = list(relative_differece_dict.values())

    fig, ax = plt.subplots()

    bars = ax.bar(keys, values)

    ax.set_xlabel('Knobs')
    ax.set_ylabel('Values')
    ax.set_title(f'comparing stats value obtained from boolean knob {knob_name}')

    # Set the positions and width for the bars
    positions = np.arange(len(keys))
    width = 0.35

    # Add some text for labels, title, and axes ticks
    ax.set_xticks(positions)
    ax.set_xticklabels(keys, rotation=45, ha='right')
    ax.legend(["Relative difference on changing knob from false to true"])  # Default legend
    
    bar_width = 0.35
    # Adding vertical lines
    for i in range(len(keys)):
        plt.axvline(x=i + bar_width / 2, color='gray', linestyle='--', linewidth=0.5)

    ax.yaxis.grid(True, color='gray', linestyle='--', linewidth=0.5)

    plt.subplots_adjust(bottom=0.30)
    # Capture the current figure size in inches
    fig_width, fig_height = fig.get_size_inches()

    # Set a new size if needed
    new_width, new_height = 22, 18  # New size in inches
    fig.set_size_inches(new_width, new_height)

    # plt.show()
    # Save the figure as a PNG with adjusted size
    plt.savefig(f'./correlation_analysis/{knob_name}.png', format='png', dpi=fig.dpi, bbox_inches='tight')


def read_json_files(directory):
    empty_files = []
    processed_files_data = {}

    json_files = glob.glob(os.path.join(directory, '*.json'))

    for json_file in json_files:
        file_name = os.path.basename(json_file)[:-12]
        
        try:
            with open(json_file, 'r') as file:
                data = json.load(file)
                
                if not data:
                    empty_files.append(file_name)
                else:
                    processed_files_data[file_name] = data
        
        except json.JSONDecodeError:
            print(Fore.RED + f"Error decoding JSON from file: {json_file}" + Fore.RESET)

    return empty_files, processed_files_data

if __name__ == '__main__':
    file_path = 'knobs_decoded.txt'
    master_stats_dict = read_key_value_file(file_path)

    directory_path = './Batch5_Results'
    empty_files, processed_files_data = read_json_files(directory_path)

    useless_knobs = ""

    print(Fore.RED + "Knobs that brought no change in STATS on modifying them : " + Fore.RESET)
    print(Fore.RED + "#################" + Fore.RESET)
    for file in empty_files:
        useless_knobs += file + "\n"
        print(Fore.BLUE + f"{file}" + Fore.RESET)
    print(Fore.RED + "#################" + Fore.RESET)

    # with open('useless_knobs.txt', 'a') as file:
    #     file.write(useless_knobs)

    useful_knobs = ""
    for key, value in processed_files_data.items():
        useful_knobs += key + "\n"
        print(key)
        # Only for boolean knobs
        run_analyzer(key)
    
    # with open('useful_knobs.txt', 'a') as file:
    #     file.write(useful_knobs)
