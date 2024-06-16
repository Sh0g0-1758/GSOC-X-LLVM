import os
import re
import sys
from colorama import init, Fore, Back, Style
init()

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

# This Function reads a given set of lines from the cpp file
# The starting line and 10 lines ahead of it
def read_lines_around(file_path, start_line, num_lines=0):
    lines = []
    with open(file_path, 'r') as file:
        for i, line in enumerate(file):
            if start_line - 1 == i:
                lines.append(line)
            if i > start_line + num_lines:
                break
    return lines

# This Function processes the input lines, ie. take care of newlines
def process_multiline_from_file(file_path, line_number):
    lines = read_lines_around(file_path, line_number)
    snippet = ''.join(line.strip() for line in lines)
    return snippet

# This Function extracts the knob value from the string
def get_knob_val(line):
    match = re.search(r'\d+', line)
    if match:
        return int(match.group())
    else:
        print(Fore.RED + "No knob value found in the line" + Fore.RESET)

# This Function updates the knob value in the cpp file
def update_knob_val(file_path, line_number, new_val):
    with open(file_path, 'r') as file:
        lines = file.readlines()

    target_line = lines[line_number - 1]

    new_line = re.sub(r'(?<![\w\d])\d+(?![\w\d])', str(new_val), target_line)

    lines[line_number - 1] = new_line

    with open(file_path, 'w') as file:
        file.writelines(lines)

def generate_values(number):
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
        temp-=step
        count+=1
    
    temp = number + step
    while count <= 11:
        values.append(temp)
        temp+=step
        count+=1
    
    # Exceptional values for experimentation.
    # 200% and 1000% 
    # Take care that number is not zero
    if number == 0:
        values.append(20)
        values.append(100)
    else:
        max_val = max(values)
        mult = round(max_val / number)
        mult+=1
        values.append(number * mult)
        mult+=9
        values.append(number * mult)

    values = sorted(values)
    return values

if __name__ == "__main__":
    knob_data = process_file('knobs.txt')

    print(Fore.GREEN + "Successfully extracted Location and name from knobs" + Fore.RESET)
    
    for knob in knob_data:
        print(Fore.BLUE + f"##  Analyzing {knob['function_name']}" + Fore.RESET)

        os.environ['KNOB_NAME'] = knob['function_name']

        with open('directory_name.txt', 'w') as file:
            pass

        knob_val = get_knob_val(process_multiline_from_file( "./../../dev/llvm-project/" + knob['file_path'], knob['line_number']))

        values = generate_values(knob_val)

        for val in values:
            with open('directory_name.txt', 'a') as file:
                file.write(f"./stats/{knob['function_name']}_{val}\n")
            update_knob_val("./../../dev/llvm-project/" + knob['file_path'], knob['line_number'], val)
            os.environ['KNOB_VAL'] = str(val)
            os.system("cd build && make -j 8")
            os.system("python get_data.py")
            print(Fore.GREEN + f"Successfully updated knob value to {val} and generated data for {knob['function_name']}_{val} directory." + Fore.RESET)

        print(Fore.BLUE + f"Successfully generated data for all {knob['function_name']} directories." + Fore.RESET)

        os.system("python analyze.py")

        print(Fore.GREEN + f"##  Successfully analyzed {knob['function_name']}" + Fore.RESET)
