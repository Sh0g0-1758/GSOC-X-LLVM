from colorama import init, Fore, Back, Style
init()
import os
os.system("cd build && make -j 8")
os.system("python get_data.py")
os.system("python analyze.py")

print(Fore.GREEN + f"##  Successfully analyzed Normal Compiler" + Fore.RESET)
