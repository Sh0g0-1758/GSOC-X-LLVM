from colorama import init, Fore, Back, Style
init()
import re
import sys

# Function to read a block of lines from a file
def read_lines_around(file_path, start_line, num_lines=10):
    lines = []
    with open(file_path, 'r') as file:
        for i, line in enumerate(file):
            if start_line - 1 <= i <= start_line + num_lines:
                lines.append(line)
            if i > start_line + num_lines:
                break
    return lines

# Function to extract the init value and string identifier from a snippet
def extract_init_value_and_string(snippet, function_name):
    # Regex pattern to capture the string identifier and init value
    pattern = rf'{function_name}\s*\(\s*"([^"]+)"(?:.*?)cl::init\s*\(\s*([^)]+)\s*\)'
    
    # Search for the pattern in the snippet
    match = re.search(pattern, snippet, re.DOTALL)
    if match:
        return {
            'string_identifier': match.group(1),
            'init_value': match.group(2)
        }
    else:
        return None

# Function to process a file and extract information based on line number and function name
def process_multiline_from_file(file_path, line_number, function_name):
    lines = read_lines_around(file_path, line_number)
    snippet = ''.join(line.strip() for line in lines)
    snippet = snippet.replace(';',';\n')
    return extract_init_value_and_string(snippet, function_name)

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

def process_file(file_path):
    extracted_data = []
    with open(file_path, 'r') as file:
        for line in file:
            info = extract_info(line)
            if info:
                extracted_data.append(info)
    return extracted_data

input_file = 'knobs.txt'

extracted_data = process_file(input_file)
print(Fore.GREEN + "Successfully extracted Location and function name from knobs" + Fore.RESET)

result_dict= {}
count = 0

for entry in extracted_data:
    # Define the file path and line number
    file_path = "./../../dev/llvm-project/" + entry['file_path']
    line_number = int(entry['line_number'])
    function_name = entry['function_name']
    data = process_multiline_from_file(file_path, line_number, function_name)
    if data:
        result_dict[data['string_identifier']] = data['init_value']
        count+=1
    else:
        print(Fore.RED + f"File Path : {file_path} =!= Function Name : {function_name}" + Fore.RESET)

print(Fore.GREEN + "Extracted real names and initial values of the cl knobs" + Fore.RESET)
print(count)
