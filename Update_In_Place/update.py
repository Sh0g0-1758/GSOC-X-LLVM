def update_knob(file_path, new_value):
    with open(file_path, 'r') as file:
        lines = file.readlines()

    # Find and update the variable value
    for i, line in enumerate(lines):
        if 'cl::init' in line:
            print(line)
            lines[i] = f' cl::init({new_value}));\n'

    with open(file_path, 'w') as file:
        file.writelines(lines)

cpp_file_path = 'example.cpp'
new_value = 600

update_knob(cpp_file_path, new_value)
