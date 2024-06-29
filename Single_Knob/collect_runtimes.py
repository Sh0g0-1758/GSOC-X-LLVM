from colorama import init, Fore, Back, Style
init()
import subprocess
import sys
import re
import json

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

def get_variable_name(value, scope):
    return [name for name in scope if scope[name] is value]

if __name__ == "__main__":

    with open("study_knob.txt", "r") as f:
        knobs = f.read().splitlines()
    
    file_path = 'knobs_decoded.txt'
    master_stats_dict = read_key_value_file(file_path)

    perf_time_dict = {}

    for knob in knobs:
        knob_val = master_stats_dict[knob]

        values = generate_values(convert_to_appropriate_type(knob, knob_val))

        perf_time_dict[knob] = {}

        for val in values:
            print(Fore.BLUE + f"Running for {knob} with {val}" + Fore.RESET)

            perf_time_dict[knob][val] = []
            for i in range(100):
                perf_command_vector = ['sudo', 'perf', 'stat', './../../dev/llvm-project/build/bin/opt', f'-attributor-max-specializations-per-call-base={val}', f'./../MAIN_CL/bitcode/test_{i}.bc']

                perf_O1_command_vector = ['sudo', 'perf', 'stat', './../../dev/llvm-project/build/bin/opt', f'-attributor-max-specializations-per-call-base={val}', '-O1', f'./../MAIN_CL/bitcode/test_{i}.bc']

                perf_O2_command_vector = ['sudo', 'perf', 'stat', './../../dev/llvm-project/build/bin/opt', f'-attributor-max-specializations-per-call-base={val}', '-O2', f'./../MAIN_CL/bitcode/test_{i}.bc']

                perf_O3_command_vector = ['sudo', 'perf', 'stat', './../../dev/llvm-project/build/bin/opt', f'-attributor-max-specializations-per-call-base={val}', '-O3', f'./../MAIN_CL/bitcode/test_{i}.bc']

                perf_Os_command_vector = ['sudo', 'perf', 'stat', './../../dev/llvm-project/build/bin/opt', f'-attributor-max-specializations-per-call-base={val}', '-Os', f'./../MAIN_CL/bitcode/test_{i}.bc']

                perf_Oz_command_vector = ['sudo', 'perf', 'stat', './../../dev/llvm-project/build/bin/opt', f'-attributor-max-specializations-per-call-base={val}', '-Oz', f'./../MAIN_CL/bitcode/test_{i}.bc']

                commands = [perf_command_vector, perf_O1_command_vector, perf_O2_command_vector, perf_O3_command_vector, perf_Os_command_vector, perf_Oz_command_vector]

                for command_vector in commands:
                    output_string = ""
                    with subprocess.Popen(command_vector, stdout=subprocess.PIPE, stderr=subprocess.PIPE) as opt_process:
                        _, stderr_data = opt_process.communicate()

                        output_string += stderr_data.decode('utf-8')

                    elapsed_time_match = re.search(r'\s+(\d+\.\d+) seconds time elapsed', output_string)
                    
                    if elapsed_time_match:
                        elapsed_time = elapsed_time_match.group(1)
                        perf_time_dict[knob][val].append(float(elapsed_time))
                    else:
                        print(Fore.RED + "Elapsed time not found in the output." + Fore.RESET)
                        sys.exit(1)
                    
                    print(Fore.GREEN + f"done with {get_variable_name(command_vector, locals())[0]}" + Fore.RESET)
                
                print(Fore.YELLOW + f"done with bitcode file {i}" + Fore.RESET)
            
            perf_time_dict[knob][val] = sum(perf_time_dict[knob][val]) / len(perf_time_dict[knob][val])
    
    with open("perf_time.json", "w") as f:
        json.dump(perf_time_dict, f)