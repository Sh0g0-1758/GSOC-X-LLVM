from datasets import load_dataset
import os

if __name__ == '__main__':

    if not os.path.exists("bitcode"):
        os.mkdir("bitcode")

    ds = load_dataset('llvm-ml/ComPile', split='train', streaming=True)
    dataset_iterator = iter(ds)

    for i in range(200):
        bitcode_module = next(dataset_iterator)['content']
        with open(f'./bitcode/test_{(i+1)}.bc', 'wb') as module_file:
            module_file.write(bitcode_module)
            module_file.flush()
