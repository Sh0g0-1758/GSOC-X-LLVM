from colorama import init, Fore, Back, Style
init()
import json
import numpy as np
from scipy.stats import pearsonr
import matplotlib.pyplot as plt

def generate_values(number):
    # Some Exceptional Values
    if number == 18446744073709551615 or number == 65535 or number == 4294967295 or number == 8388608:
        values = []
        step = round(number * 0.1)
        count = 1
        values.append(round(number * 0.2))
        values.append(round(number * 0.3))
        while (count <= 11):
            values.append(number)
            number -= step
            if(number < 0):
                break
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

def normalize(array):
    min_val = np.min(array)
    max_val = np.max(array)
    return (array - min_val) / (max_val - min_val) , min_val, max_val

def generate_step_function_graph(knob_name, knob_val, stats_values_dict):
    x = generate_values(convert_to_appropriate_type(knob_name, knob_val))
    x = np.array(x)

    file_path = './perf_time.json'
    with open(file_path, 'r') as file:
        data = json.load(file)
    time_arr = []
    for _, value in data[knob_name].items():
        time_arr.append(value)

    keys = []
    normalized_values_dict = {}

    for key, value in stats_values_dict.items():
        y = np.array(value)
        if len(set(y)) == 1 or len(set(y)) == 2:
            continue
        y_normalized, y_min, y_max = normalize(y)
        # Change these values when studying overall performance, these represent the number of bitcode files
        # That we are performing our experiments on
        y_max = y_max / 100
        y_min = y_min / 100
        keys.append(key)
        normalized_values_dict[key] = {"normalized_values" : list(y_normalized), "min" : y_min, "max" : y_max}
    
    keys = list(keys)

    time_arr = np.array(time_arr)
    time_arr, time_min, time_max = normalize(time_arr)

    json_data = {
        "knob_name": knob_name,
        "original_val": knob_val,
        "knob_values": x.tolist(),
        "stats": keys,
        "stats_val": normalized_values_dict,
        "time_arr": list(time_arr),
        "time_min": time_min,
        "time_max": time_max,
    }

    with open('plot.json', 'w') as file:
        json.dump(json_data, file, indent=4)

if __name__ == '__main__':
    file_path = 'knobs_decoded.txt'
    master_stats_dict = read_key_value_file(file_path)

    file_path = "./bonus-inst-threshold_result.json"

    stats_values_dict = json_to_dict_with_arrays(file_path)

    knob = "bonus-inst-threshold"

    generate_step_function_graph(knob, master_stats_dict[knob], stats_values_dict)
