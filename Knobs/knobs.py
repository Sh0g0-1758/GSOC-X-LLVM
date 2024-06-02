import os
import sys
import subprocess

def run_binary_on_files(binary_path, target_dir):
    if not os.path.isfile(binary_path):
        print(f"Error: Binary '{binary_path}' not found.")
        return
    
    if not os.path.isdir(target_dir):
        print(f"Error: Directory '{target_dir}' not found.")
        return

    file_extensions = ['.cpp', '.hpp', '.h', '.c']

    for root, _, files in os.walk(target_dir):
        for file in files:
            if any(file.endswith(ext) for ext in file_extensions):
                file_path = os.path.join(root, file)
                result = subprocess.run([binary_path] + [file_path] + ["--", "-I", "/usr/lib/gcc/x86_64-linux-gnu/13/include", "-I", "/home/shogo/master/dev/llvm-project/build/inst/include"], capture_output=True, text=True)
                if result.returncode == 0:
                    print(f"Processing {file_path}")
                    print(result.stdout)
                    print(result.stderr)

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python3 script.py /path/to/binary /path/to/directory [additional_args...]")
        sys.exit(1)

    binary_path = sys.argv[1]
    target_dir = sys.argv[2]
    
    run_binary_on_files(binary_path, target_dir)
