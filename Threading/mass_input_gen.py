#!/usr/bin/env python3

import json
import subprocess
import argparse
import os
import sys
import threading
import functools
from datasets import load_dataset
import copy

import input_gen_module as igm

def precompile_runtimes(args):
    print('Precompiling runtimes...')
    args.input_gen_runtime = precompile_runtime(args.input_gen_runtime, args.g, args.verbose)
    args.input_run_runtime = precompile_runtime(args.input_run_runtime, args.g, args.verbose)
    print('Done.')

def precompile_runtime(fname, debug, verbose):
    if (fname.endswith('.c') or
        fname.endswith('.cpp') or
        fname.endswith('.cxx')):

        obj = fname + '.o'
        compargs = 'clang++ -Wall -std=c++17 -c'.split(' ') + [fname, '-o', obj]
        if debug:
            compargs.append('-O0')
            compargs.append('-g')
        else:
            compargs.append('-O3')
            compargs.append('-DNDEBUG')

        if verbose:
            print('Comp args:', ' '.join(compargs))

        subprocess.run(
            compargs,
            check=True)
        return obj
    else:
        return fname

def add_option_args(parser):
    parser.add_argument('--dataset', default='llvm-ml/ComPile')
    parser.add_argument('--language', required=True)
    parser.add_argument('--outdir', required=True)
    parser.add_argument('--data_dir', required=True)
    parser.add_argument('--start', type=int, default=0)
    parser.add_argument('--end', type=int, default=10)
    # Number of cores available by default
    parser.add_argument('--num-procs', type=int, default=None)

    parser.add_argument('--precompile-rts', action='store_true')
    parser.add_argument('--no-precompile-rts',
                        dest='precompile_rts', action='store_false')
    parser.set_defaults(precompile_rts=True)

    igm.add_option_args(parser)

if __name__ == '__main__':
    parser = argparse.ArgumentParser('MassInputGen')
    add_option_args(parser)
    args = parser.parse_args()

    if args.precompile_rts:
        precompile_runtimes(args)

    # ds = load_dataset('llvm-ml/ComPile', split='train', streaming=True)
    # dataset_iterator = iter(ds)
    os.makedirs(args.outdir, exist_ok=True)
    print('Will input gen for dataset {} in {}'.format(args.dataset, args.outdir))
    global_outdir = args.outdir
    igm_args = vars(args)

    data_dir = args.data_dir

    igm.handle_single_module(data_dir, args)
