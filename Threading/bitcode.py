from datasets import load_dataset
import os
import subprocess

if __name__ == '__main__':

    if not os.path.exists("bitcode"):
        os.mkdir("bitcode")

    ds = load_dataset('llvm-ml/ComPile', split='train', streaming=True)
    dataset_iterator = iter(ds)

    for i in range(200):
        bitcode_module = next(dataset_iterator)['content']
        IR_module = None
        dis_command_vector = [
            './../../dev/llvm-project/build/bin/llvm-dis', '-']
        with subprocess.Popen(
                dis_command_vector,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                stdin=subprocess.PIPE) as dis_process:
            IR_module = dis_process.communicate(
                input=bitcode_module)[0].decode('utf-8')

        as_command_vector = ['./../../dev/llvm-project/build/bin/llvm-as',
                             '-', '--o', f'./bitcode/test_{(i+1)}.bc']

        with subprocess.Popen(
                as_command_vector,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                stdin=subprocess.PIPE) as as_process:
            as_process.communicate(
                input=IR_module.encode('utf-8'))
