import os
from colorama import init, Fore, Back, Style
init()

def update_knob(file_path, new_value):
    with open(file_path, 'r') as file:
        lines = file.readlines()

    for i, line in enumerate(lines):
        if 'cl::init' in line:
            print(line)
            lines[i] = f' cl::init({new_value}));\n'

    with open(file_path, 'w') as file:
        file.writelines(lines)

cpp_file_path = './../../dev/llvm-project/llvm/lib/Analysis/CaptureTracking.cpp'

for i in range(50,1050,50):
    os.environ['KNOB_VAL'] = str(i)
    update_knob(cpp_file_path, i)
    os.system("cd build && make -j 8")
    os.system("python get_data_cl_limit.py")
    print(Fore.GREEN + f"Successfully updated knob value to {i} and generated data for cl_limit_{i} directory." + Fore.RESET)

print(Fore.BLUE + "Successfully updated knob values and generated data for all directories." + Fore.RESET)

os.system("python analyze.py")
print(Fore.BLUE + "Successfully analyzed the generated data." + Fore.RESET)
