import sys
import os
import subprocess
import re
import threading
import queue
import json
# from datasets import load_dataset
from colorama import init, Fore, Back, Style
init()

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

def generate_values(number):
    # Some Exceptional Values
    if number == 18446744073709551615 or number == 65535 or number == 4294967295 or number == 8388608 or number == 2147483647:
        values = []
        step = round(number * 0.10)
        count = 1
        values.append(round(number * 0.05))
        values.append(round(number * 0.65))
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

def divide_into_chunks(a, b):
    numbers = list(range(1, a + 1))

    chunks = []

    for i in range(0, len(numbers), b):
        chunks.append(numbers[i:i + b])
    
    return chunks

def thread_function(queue, data_chunk, knob_name, knob_value):
    result = {}

    for data in data_chunk:
        value = convert_to_appropriate_type(knob_name, knob_value)
        values = generate_values(value)

        for val in values:

            opt_command_vector = [
                './../../dev/llvm-project/build/bin/opt', f'-{knob_name}={val}', '-stats', f'./../MAIN_CL/bitcode/test_{data}.bc']
            opt_O1_command_vector = [
                './../../dev/llvm-project/build/bin/opt', f'-{knob_name}={val}', '-O1', '-stats', f'./../MAIN_CL/bitcode/test_{data}.bc']
            opt_O2_command_vector = [
                './../../dev/llvm-project/build/bin/opt', f'-{knob_name}={val}', '-O2', '-stats', f'./../MAIN_CL/bitcode/test_{data}.bc']
            opt_O3_command_vector = [
                './../../dev/llvm-project/build/bin/opt', f'-{knob_name}={val}', '-O3', '-stats', f'./../MAIN_CL/bitcode/test_{data}.bc']
            opt_Os_command_vector = [
                './../../dev/llvm-project/build/bin/opt', f'-{knob_name}={val}', '-Os', '-stats', f'./../MAIN_CL/bitcode/test_{data}.bc']
            opt_Oz_command_vector = [
                './../../dev/llvm-project/build/bin/opt', f'-{knob_name}={val}', '-Oz', '-stats', f'./../MAIN_CL/bitcode/test_{data}.bc']

            with subprocess.Popen(opt_command_vector, stdout=subprocess.PIPE, stderr=subprocess.PIPE) as opt_process:
                _, stderr_data = opt_process.communicate()
                output_string = str(stderr_data)[222:-1]

            with subprocess.Popen(opt_O1_command_vector, stdout=subprocess.PIPE, stderr=subprocess.PIPE) as opt_O1_process:
                _, stderr_data = opt_O1_process.communicate()
                output_string = str(stderr_data)[222:-1]

            with subprocess.Popen(opt_O2_command_vector, stdout=subprocess.PIPE, stderr=subprocess.PIPE) as opt_O2_process:
                _, stderr_data = opt_O2_process.communicate()
                output_string = str(stderr_data)[222:-1]

            with subprocess.Popen(opt_O3_command_vector, stdout=subprocess.PIPE, stderr=subprocess.PIPE) as opt_O3_process:
                _, stderr_data = opt_O3_process.communicate()
                output_string = str(stderr_data)[222:-1]

            with subprocess.Popen(opt_Os_command_vector, stdout=subprocess.PIPE, stderr=subprocess.PIPE) as opt_Os_process:
                _, stderr_data = opt_Os_process.communicate()
                output_string = str(stderr_data)[222:-1]

            with subprocess.Popen(opt_Oz_command_vector, stdout=subprocess.PIPE, stderr=subprocess.PIPE) as opt_Oz_process:
                _, stderr_data = opt_Oz_process.communicate()
                output_string = str(stderr_data)[222:-1]
    
    queue.put(result)

if __name__ == "__main__":

    # This is after the initial study on 100 bitcode files where we found the knobs that are useful
    file_path = 'knobs_decoded.txt'
    master_stats_dict = read_key_value_file(file_path)

    to_process_stats_dict = {}

    with open('useful_knobs.txt', 'r') as file:
        for line in file:
            to_process_stats_dict[line.strip()] = master_stats_dict[line.strip()]

    # The change in design is that now we are going to send knobs sequentially and doing the data processing 
    # in parallel for each knob. This will help in reducing the time taken to process the data.
    for knob, knob_val in to_process_stats_dict.items():
        # These Figures need to be changed according to the number of bitcode files
        chunk_size = 10
        total_files = 100
        data_chunks = divide_into_chunks(total_files, chunk_size)

        Thread_array = []

        q = queue.Queue()

        # This returns a dictionary which contains stat as key and value as summation over all the stats
        for i, d in enumerate(data_chunks):
            thread = threading.Thread(target=thread_function, args=(q,d,knob,knob_val))
            thread.start()
            Thread_array.append(thread)
        
        for i in range(len(Thread_array)):
            Thread_array[i].join()
        
        stats_dict_array = []

        while True:
            try:
                stat_dict = q.get(block=False)
                stats_dict_array.append(stat_dict)
            except queue.Empty:
                break

        # Here we merge the results obtained over all the threads
        all_stats_dict = {}
        for stat_dict in stats_dict_array:
            for key, value in stat_dict.items():
                if key in all_stats_dict:
                    all_stats_dict[key] += value
                else:
                    all_stats_dict[key] = value
        
        for key, val in all_stats_dict.items():
            all_stats_dict[key] = val / total_files

        # And finally store them in a json file
        with open(f'./results/{knob}.json', 'w') as file:
            json.dump(all_stats_dict, file)

        print(Fore.GREEN + f"##  Successfully collected all stats for {knob}" + Fore.RESET)

    print(Fore.GREEN + "##  Successfully collected stats for all knobs" + Fore.RESET)
