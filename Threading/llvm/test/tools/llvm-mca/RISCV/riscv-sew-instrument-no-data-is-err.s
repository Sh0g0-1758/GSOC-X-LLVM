# RUN: not llvm-mca -mtriple=riscv64 -mcpu=sifive-x280 -iterations=1 < %s 2>&1 | FileCheck %s

vsetvli zero, a0, e8, m1, tu, mu
# LLVM-MCA-RISCV-SEW
vdiv.vv v8, v8, v12

# CHECK: error: Failed to create RISCV-SEW instrument with no data
# CHECK: # LLVM-MCA-RISCV-SEW
# CHECK:  ^
# CHECK: error: There was an error parsing comments.
