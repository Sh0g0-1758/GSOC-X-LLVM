from colorama import init, Fore, Back, Style
init()
import re
import sys
import os

def generate_values(number):
    # Some Exceptional Values
    if number == 18446744073709551615 or number == 65535 or number == 4294967295 or number == 8388608:
        values = []
        step = round(number * 0.1)
        count = 1
        values.append(number * 0.2)
        values.append(number * 0.3)
        while(count <= 11):
            values.append(number)
            number-=step
            count+=1
        values = sorted(values)
        return values

    # Handling of Floating Point Numbers
    if(type(number) == float):
        step = number * 0.1
        count = 1
        values = []
        temp = number

        while count <= 6:
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
        values.append(2 * number)
        values.append(10 * number)
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
        values.append(2 * number)
        values.append(10 * number)

    values = sorted(values)
    return values

def convert_to_appropriate_type(data):
    s = data['init_value']
    if s is None or s == '':
        return None
    
    try:
        return int(s)
    except ValueError:
        pass
    try:
        if(s[-1] == 'f'):
            return float(s[:-1])
        return float(s)
    except ValueError:
        pass

    
    print(Fore.RED + f"Invalid value: {data}" + Fore.RESET)
    exit(0)

# This Function reads a given set of lines from the cpp file
# The starting line and 10 lines ahead of it
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
    snippet = snippet.replace(';',';\n')
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
    result_dict= {}

    for entry in extracted_data:
        file_path = "./../../dev/llvm-project/" + entry['file_path']
        line_number = int(entry['line_number'])
        function_name = entry['function_name']
        data = process_multiline_from_file(file_path, line_number, function_name)
        if data:
            result_dict[data['string_identifier']] = (data['init_value'])
        else:
            print(Fore.RED + f"File Path : {file_path} =!= Function Name : {function_name}" + Fore.RESET)
            sys.exit(1)
    
    return result_dict


if __name__ == "__main__":
    extracted_data = process_file('knobs.txt')

    print(Fore.GREEN + "Successfully extracted Location and function name from knobs" + Fore.RESET)

    result_dict = get_identifier_and_init_val(extracted_data)

    print(Fore.GREEN + "Extracted string identifier and init val of the command line knobs" + Fore.RESET)

    for result in result_dict:
        print(Fore.BLUE + f"##  Analyzing {result}" + Fore.RESET)

        os.environ['KNOB_NAME'] = result
        values = generate_values(convert_to_appropriate_type({'string_identifier': result,'init_value': result_dict[result]}))

        for val in values:
            os.environ['KNOB_VAL'] = str(val)
            os.system("python get_data.py")
            print(Fore.GREEN + f"Successfully updated knob value to {val} and generated data for {result}_{val} directory." + Fore.RESET)
    
        print(Fore.BLUE + f"Successfully generated data for all {result} directories." + Fore.RESET)

        os.system("python analyze.py")

        print(Fore.GREEN + f"##  Successfully analyzed {result}" + Fore.RESET)
    
