import sys
import time
import os
import subprocess
import re
import threading
import queue
import json
# from datasets import load_dataset
from colorama import init, Fore, Back, Style
init()

def read_lines_around(file_path, start_line, num_lines=10):
    lines = []
    with open(file_path, 'r') as file:
        for i, line in enumerate(file):
            if start_line - 1 <= i <= start_line + num_lines:
                lines.append(line)
            if i > start_line + num_lines:
                break
    return lines

# This Function extracts the string identifier and the init value
# from the snippet
def extract_init_value_and_string(snippet, function_name):
    pattern = rf'{function_name}\s*\(\s*"([^"]+)"(?:.*?)cl::init\s*\(\s*([^)]+)\s*\)'

    match = re.search(pattern, snippet, re.DOTALL)
    if match:
        return {
            'string_identifier': match.group(1),
            'init_value': match.group(2)
        }
    else:
        return None

# This Function processes the input lines, ie. take care of newlines
def process_multiline_from_file(file_path, line_number, function_name):
    lines = read_lines_around(file_path, line_number)
    snippet = ''.join(line.strip() for line in lines)
    snippet = snippet.replace(';', ';\n')
    return extract_init_value_and_string(snippet, function_name)

# this function converts the knob information from the sheet
# Into useful information that can be used to study them
def extract_info(line):
    pattern = r'(.+?):(\d+):(\d+)\s+(\w+)'
    match = re.match(pattern, line.strip())
    if match:
        return {
            'file_path': match.group(1),
            'line_number': int(match.group(2)),
            'function_name': match.group(4)
        }
    else:
        print(Fore.RED + f"Invalid line: {line.strip()}" + Fore.RESET)
        sys.exit(1)

# This Function is an extension of the above function
# It just helps in reading the lines
def process_file(file_path):
    extracted_data = []
    with open(file_path, 'r') as file:
        for line in file:
            info = extract_info(line)
            if info:
                extracted_data.append(info)
    return extracted_data

# Function to get init val and its identifier from the cpp file
def get_identifier_and_init_val(extracted_data):
    result_dict = {}

    for entry in extracted_data:
        file_path = "./../../dev/llvm-project/" + entry['file_path']
        line_number = int(entry['line_number'])
        function_name = entry['function_name']
        data = process_multiline_from_file(
            file_path, line_number, function_name)
        if data:
            result_dict[data['string_identifier']] = data['init_value']
        else:
            print(
                Fore.RED + f"File Path : {file_path} =!= Function Name : {function_name}" + Fore.RESET)
            sys.exit(1)

    return result_dict

# Making a dict of ambiguous and ignore stats
def process_stats_file_to_dict(file_path):
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

def generate_values(knob,number):
    # Handling three special knobs which although unsigned
    # have a range of 0 to 255
    if(knob == 'cold-new-hint-value' or knob == 'notcold-new-hint-value' or knob == 'hot-new-hint-value'):
        step = 25
        number = 25
        values = []
        while number <= 250:
            values.append(number)
            number += step
        values.append(254)
        values.append(128)
        values.append(1)
        values = sorted(values)
        return values
    # Boolean Knobs
    if number == 'true':
        return [0,1]
    # Some Exceptional Values
    if number == 18446744073709551615 or number == 65535 or number == 4294967295 or number == 8388608 or number == 2147483647:
        values = []
        step = round(number * 0.10)
        count = 1
        values.append(round(number * 0.05))
        values.append(round(number * 0.95))
        while (count <= 11):
            values.append(number)
            number -= step
            if(number < 0):
                values.append(0)
                break
            count += 1
        values = sorted(values)
        return values

    # Handling of Floating Point Numbers
    if (type(number) == float):
        step = number * 0.1
        if step == 0.0:
            step = 1.0
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


def convert_to_appropriate_type(data, s):
    if s == 'true':
        return 'true'
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

# Function to divide data files into chunks that 
# can be processed
def divide_into_chunks(a, b):
    numbers = list(range(1, a + 1))

    chunks = []

    for i in range(0, len(numbers), b):
        chunks.append(numbers[i:i + b])
    
    return chunks

# Constant for the pattern of the line
line_pattern = re.compile(r'^\s*(\d+)\s+(\S+)\s+-\s+(.*)$')

# Process a single file and update the stats dictionary
def process_stat(stat_blob,stats_dict):
    for line in stat_blob:
        match = line_pattern.match(line)
        if match:
            value = int(match.group(1))
            component = match.group(2)
            description = match.group(3)
            key = f"{description} ({component})"
            if key not in stats_dict:
                stats_dict[key] = value
            else:
                stats_dict[key] += value

def thread_function(queue, data_chunk, knob_name, values):
    result = []

    for _ in range(len(values)):
        result.append({})

    for data in data_chunk:
        for i,val in enumerate(values):
            opt_command_vectors = [
                ['./../../dev/llvm-project/build/bin/opt', f'-{knob_name}={val}', '-O1', '-stats', f'./bitcode/test_{data}.bc'],
                ['./../../dev/llvm-project/build/bin/opt', f'-{knob_name}={val}', '-O2', '-stats', f'./bitcode/test_{data}.bc'],
                ['./../../dev/llvm-project/build/bin/opt', f'-{knob_name}={val}', '-O3', '-stats', f'./bitcode/test_{data}.bc'],
                ['./../../dev/llvm-project/build/bin/opt', f'-{knob_name}={val}', '-Os', '-stats', f'./bitcode/test_{data}.bc'],
                ['./../../dev/llvm-project/build/bin/opt', f'-{knob_name}={val}', '-Oz', '-stats', f'./bitcode/test_{data}.bc']]

            for opt_command_vector in opt_command_vectors:
                t1 = time.perf_counter(), time.process_time()
                bitcode_size = 0
                with subprocess.Popen(opt_command_vector, stdout=subprocess.PIPE, stderr=subprocess.PIPE) as opt_process:
                    stdout_data, stderr_data = opt_process.communicate()
                    bitcode_size = len(stdout_data)
                    if "value invalid for" in stderr_data.decode('utf-8'):
                        with open('invalid_knobs.txt', 'a') as file:
                            file.write(f'{knob_name}\n')
                    output_string = stderr_data.decode('utf-8')[216:-2]
                    process_stat(output_string.split('\n'), result[i])
                t2 = time.perf_counter(), time.process_time()
                compile_time = t2[1] - t1[1]
                key = 'compile-time (seconds)'
                if key in result[i]:
                    result[i][key] += float(compile_time)
                else:
                    result[i][key] = float(compile_time)
                key = 'bitcode-size (bytes)'
                if key in result[i]:
                    result[i][key] += bitcode_size
                else:
                    result[i][key] = bitcode_size
            print(Fore.LIGHTYELLOW_EX + f"##  Successfully collected stats for {knob_name} with value {val} for data chunk {data}" + Fore.RESET)
            
    queue.put(result)

def convert_to_percentage(stat_values, iter, range):
    val = stat_values[iter]
    if val == 0:
        for i, stat in enumerate(stat_values):
            stat_values[i] = stat + 1.0
        val = 1.0
    # Converting other stats as a percentage of the original value
    for i, stat in enumerate(stat_values):
        stat_values[i] = ((stat - val) / val) * 100
        if stat_values[i] < range[0]:
            range[0] = stat_values[i]
        if stat_values[i] > range[1]:
            range[1] = stat_values[i]
    
    return stat_values


def generate_step_function_graph(knob_name, knob_val, stats_values_dict):
    knob_val = convert_to_appropriate_type(knob_name, knob_val)
    x = generate_values(knob, knob_val)

    iter = 0
    for i, val in enumerate(x):
        print(val, knob_val)
        if val == knob_val:
            iter = i
            break

    keys = []
    # To store the min and max values across the y axis
    # First represents the min value and second represents the max value
    range = [0,0]

    for key, value in stats_values_dict.items():
        y = convert_to_percentage(value, iter,range)
        # To remove redundant statistics
        if key == 'compile-time (seconds)' or key == 'bitcode-size (bytes)':
            keys.append(key)
            stats_values_dict[key] = y
            continue
        if len(set(y)) == 1:
            continue
        keys.append(key)
        stats_values_dict[key] = y

    keys = list(keys)

    json_data = {
        "knob_name": knob_name,
        "original_val": knob_val,
        "y_min": range[0],
        "y_max": range[1],
        "knob_values": x,
        "stats": keys,
        "stats_val": stats_values_dict,
    }

    with open(f'./results/{knob_name}.json', 'w') as file:
        json.dump(json_data, file, indent=4)

if __name__ == "__main__":
    if not os.path.exists("results"):
        os.mkdir("results")

    to_process_stats_dict = {}

    ### ============================================================================================== ###
    # When we have the location of the knob but not its name
    ### ============================================================================================== ###

    # knob_data = process_file('prelim_knobs.txt')
    # to_process_stats_dict = get_identifier_and_init_val(knob_data)

    ### ============================================================================================== ###
    # When we have the knob name
    ### ============================================================================================== ###

    master_stats_dict = read_key_value_file('knobs_decoded.txt')
    with open('run_knobs_with_new_arch.txt', 'r') as file:
        for line in file:
            to_process_stats_dict[line.strip()] = master_stats_dict[line.strip()]

    ignore_stats_dict = process_stats_file_to_dict("stats_ignore.txt")

    # The change in design is that now we are going to send knobs sequentially and doing the data processing 
    # in parallel for each knob. This will help in reducing the time taken to process the data.

    t1 = time.perf_counter(), time.process_time()

    for knob, knob_val in to_process_stats_dict.items():
        # These Figures need to be changed according to the number of bitcode files
        chunk_size = 10
        total_files = 100
        data_chunks = divide_into_chunks(total_files, chunk_size)

        corrected_value = convert_to_appropriate_type(knob, knob_val)
        values = generate_values(knob, corrected_value)

        Thread_array = []

        q = queue.Queue()

        # This returns a dictionary which contains stat as key and value as summation over all the stats
        for i, d in enumerate(data_chunks):
            thread = threading.Thread(target=thread_function, args=(q,d,knob,values))
            thread.start()
            Thread_array.append(thread)
        
        for i in range(len(Thread_array)):
            Thread_array[i].join()
        
        stats_dict_array = []

        for _ in range(len(values)):
            stats_dict_array.append({})

        while True:
            try:
                stat_dict = q.get(block=False)
                for i, stat in enumerate(stat_dict):
                    for key, value in stat.items():
                        if key in stats_dict_array[i]:
                            stats_dict_array[i][key] += value
                        else:
                            stats_dict_array[i][key] = value
            except queue.Empty:
                break

        # Here we merge the results obtained over all the threads
        all_stats_dict = {}
        for idx, stats_dict in enumerate(stats_dict_array):
            for key, value in stats_dict.items():
                if key in all_stats_dict:
                    while len(all_stats_dict[key]) < idx:
                        all_stats_dict[key].append(0)
                    all_stats_dict[key].append(value)
                else:
                    all_stats_dict[key] = []
                    for _ in range(idx):
                        all_stats_dict[key].append(0)
                    all_stats_dict[key].append(value)

        # Taking care of the case where some stats are not present in some files
        for key in all_stats_dict.keys():
            while len(all_stats_dict[key]) < len(values):
                all_stats_dict[key].append(0)
        
        # Filter the dict and remove the stats that have the same value for all the files
        filtered_all_stats_dict = {key: all_stats_values for key, all_stats_values in all_stats_dict.items() if len(set(all_stats_values)) > 1}

        # If compile-time is not present in the stats, then add it
        # Though this is not necessary since compile-time is most likely to change across 
        # changes in knob value
        time_key = 'compile-time (seconds)'
        if time_key not in filtered_all_stats_dict:
            filtered_all_stats_dict[time_key] = all_stats_dict[time_key]

        final_all_stats_dict = {}
        for key, filtered_all_stats_values in filtered_all_stats_dict.items():
            if (key in ignore_stats_dict):
                continue
            else:
                final_all_stats_dict[key] = filtered_all_stats_values

        # Converting into appropriate format for plotting the graph
        generate_step_function_graph(knob, knob_val, final_all_stats_dict)

        print(Fore.GREEN + f"##  Successfully collected all stats for {knob}" + Fore.RESET)

    t2 = time.perf_counter(), time.process_time()
    print(Fore.GREEN + "##  Successfully collected stats for all knobs" + Fore.RESET)

    print(Fore.YELLOW + f" Real time: {t2[0] - t1[0]:.2f} seconds" + Fore.RESET)
    print(Fore.YELLOW + f" CPU time: {t2[1] - t1[1]:.2f} seconds" + Fore.RESET)
