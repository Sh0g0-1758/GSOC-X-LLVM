from colorama import init, Fore, Back, Style
init()
from datasets import load_dataset
import subprocess
import os
import sys

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
        max_val = max(values)
        mult = max_val / number
        mult+=1
        values.append(number * mult)
        mult+=9
        values.append(number * mult)
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
        max_val = max(values)
        mult = round(max_val / number)
        mult+=1
        values.append(number * mult)
        mult+=9
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
        if(s[-1] == 'f'):
            return float(s[:-1])
        return float(s)
    except ValueError:
        pass

    
    print(Fore.RED + f"Invalid value: {data} set to {s}" + Fore.RESET)
    exit(0)

if __name__ == "__main__":

    if not os.path.exists("bitcode"):
        os.mkdir("bitcode")

    if not os.path.exists("stats"):
        os.mkdir("stats")

    ds = load_dataset('llvm-ml/ComPile', split='train', streaming=True)

    knob_name = os.environ.get('KNOB_NAME')

    value = os.environ.get('KNOB_VAL')

    if value is not None:
        value = convert_to_appropriate_type(knob_name, value)
        print(Fore.GREEN + f"Value Set: {value}" + Fore.RESET)
    else:
        print(Fore.RED + "Environment variable not set." + Fore.RESET)
        sys.exit(1)

    iteration = 0
    index = 1

    dataset_iterator = iter(ds)

    values = generate_values(value)

    for val in values:
        with open('directory_name.txt', 'a') as file:
            file.write(f"./stats/{knob_name}_{val}\n")
        
        directory_name = f"{knob_name}_{val}"

        if not os.path.exists(f"./stats/{directory_name}"):
            os.mkdir(f"./stats/{directory_name}")

    for i in range(1000):
        iteration = iteration + 1
        bitcode_module = next(dataset_iterator)['content']
        IR_module = None
        dis_command_vector = [
            './build/bin/llvm-dis', '-']
        with subprocess.Popen(
                dis_command_vector,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                stdin=subprocess.PIPE) as dis_process:
            IR_module = dis_process.communicate(
                input=bitcode_module)[0].decode('utf-8')

        as_command_vector = ['./build/bin/llvm-as',
                            '-', '--o', f'./bitcode/test_{knob_name}.bc']

        with subprocess.Popen(
                as_command_vector,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                stdin=subprocess.PIPE) as as_process:
            as_process.communicate(
                input=IR_module.encode('utf-8'))
        
        for val in values:

            opt_command_vector = [
                './build/bin/opt', f'-{knob_name}={val}', '-stats', f'./bitcode/test_{knob_name}.bc']
            opt_O1_command_vector = [
                './build/bin/opt', f'-{knob_name}={val}', '-O1', '-stats', f'./bitcode/test_{knob_name}.bc']
            opt_O2_command_vector = [
                './build/bin/opt', f'-{knob_name}={val}', '-O2', '-stats', f'./bitcode/test_{knob_name}.bc']
            opt_O3_command_vector = [
                './build/bin/opt', f'-{knob_name}={val}', '-O3', '-stats', f'./bitcode/test_{knob_name}.bc']
            opt_Os_command_vector = [
                './build/bin/opt', f'-{knob_name}={val}', '-Os', '-stats', f'./bitcode/test_{knob_name}.bc']
            opt_Oz_command_vector = [
                './build/bin/opt', f'-{knob_name}={val}', '-Oz', '-stats', f'./bitcode/test_{knob_name}.bc']

            output_string = ""
            output_string += "PLAIN STATS> \n"
            with subprocess.Popen(opt_command_vector, stdout=subprocess.PIPE, stderr=subprocess.PIPE) as opt_process:
                stdout_data, stderr_data = opt_process.communicate()
                stderr_str = stderr_data.decode('utf-8')
                output_string += str(stderr_data)[222:-1]

            output_string += "O1 STATS> \n"
            with subprocess.Popen(opt_O1_command_vector, stdout=subprocess.PIPE, stderr=subprocess.PIPE) as opt_O1_process:
                stdout_data, stderr_data = opt_O1_process.communicate()
                stderr_str = stderr_data.decode('utf-8')
                output_string += str(stderr_data)[222:-1]

            output_string += "O2 STATS> \n"
            with subprocess.Popen(opt_O2_command_vector, stdout=subprocess.PIPE, stderr=subprocess.PIPE) as opt_O2_process:
                stdout_data, stderr_data = opt_O2_process.communicate()
                stderr_str = stderr_data.decode('utf-8')
                output_string += str(stderr_data)[222:-1]

            output_string += "O3 STATS> \n"
            with subprocess.Popen(opt_O3_command_vector, stdout=subprocess.PIPE, stderr=subprocess.PIPE) as opt_O3_process:
                stdout_data, stderr_data = opt_O3_process.communicate()
                stderr_str = stderr_data.decode('utf-8')
                output_string += str(stderr_data)[222:-1]

            output_string += "Os STATS> \n"
            with subprocess.Popen(opt_Os_command_vector, stdout=subprocess.PIPE, stderr=subprocess.PIPE) as opt_Os_process:
                stdout_data, stderr_data = opt_Os_process.communicate()
                stderr_str = stderr_data.decode('utf-8')
                output_string += str(stderr_data)[222:-1]

            output_string += "Oz STATS> \n"
            with subprocess.Popen(opt_Oz_command_vector, stdout=subprocess.PIPE, stderr=subprocess.PIPE) as opt_Oz_process:
                stdout_data, stderr_data = opt_Oz_process.communicate()
                stderr_str = stderr_data.decode('utf-8')
                output_string += str(stderr_data)[222:-1]

            output_string = output_string.replace('\\n', '\n')
            
            print(iteration, index)

            with open(f'./stats/{knob_name}_{val}/stats_{index}.txt', 'a') as f:
                f.write(f"====================================  STATS FOR FILE : {i} ====================================\n")
                f.write(output_string)

            print(Fore.CYAN + f"Wrote Stats for knob {knob_name} with value {val} for Iteration {i}" + Fore.RESET)

        if (iteration % 10 == 0):
            index += 1