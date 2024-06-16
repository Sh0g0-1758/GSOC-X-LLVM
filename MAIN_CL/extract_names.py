import re

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
    print(snippet)
    return extract_init_value_and_string(snippet, function_name)


# Path to the input file and line number
input_file = './../../dev/llvm-project/llvm/lib/ProfileData/ProfileSummaryBuilder.cpp'  # Replace with the actual file path
line_number = 33  # Example line number where the declaration starts
function_name = 'ProfileSummaryCutoffHot'  # Function name to search for

# Process the file and extract information
extracted_data = process_multiline_from_file(input_file, line_number, function_name)

# Output the extracted data
if extracted_data:
    print(f"String Identifier: {extracted_data['string_identifier']}, "
          f"Init Value: {extracted_data['init_value']}")
else:
    print("No match found.")
