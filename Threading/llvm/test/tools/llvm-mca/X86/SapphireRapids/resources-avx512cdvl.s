# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=sapphirerapids -instruction-tables < %s | FileCheck %s

vpbroadcastmb2q   %k0, %xmm16
vpbroadcastmb2q   %k0, %ymm16

vpbroadcastmw2d   %k0, %xmm16
vpbroadcastmw2d   %k0, %ymm16

vpconflictd       %xmm16, %xmm19
vpconflictd       (%rax), %xmm19
vpconflictd       (%rax){1to4}, %xmm19
vpconflictd       %xmm16, %xmm19 {k1}
vpconflictd       (%rax), %xmm19 {k1}
vpconflictd       (%rax){1to4}, %xmm19 {k1}
vpconflictd       %xmm16, %xmm19 {z}{k1}
vpconflictd       (%rax), %xmm19 {z}{k1}
vpconflictd       (%rax){1to4}, %xmm19 {z}{k1}

vpconflictd       %ymm16, %ymm19
vpconflictd       (%rax), %ymm19
vpconflictd       (%rax){1to8}, %ymm19
vpconflictd       %ymm16, %ymm19 {k1}
vpconflictd       (%rax), %ymm19 {k1}
vpconflictd       (%rax){1to8}, %ymm19 {k1}
vpconflictd       %ymm16, %ymm19 {z}{k1}
vpconflictd       (%rax), %ymm19 {z}{k1}
vpconflictd       (%rax){1to8}, %ymm19 {z}{k1}

vpconflictq       %xmm16, %xmm19
vpconflictq       (%rax), %xmm19
vpconflictq       (%rax){1to2}, %xmm19
vpconflictq       %xmm16, %xmm19 {k1}
vpconflictq       (%rax), %xmm19 {k1}
vpconflictq       (%rax){1to2}, %xmm19 {k1}
vpconflictq       %xmm16, %xmm19 {z}{k1}
vpconflictq       (%rax), %xmm19 {z}{k1}
vpconflictq       (%rax){1to2}, %xmm19 {z}{k1}

vpconflictq       %ymm16, %ymm19
vpconflictq       (%rax), %ymm19
vpconflictq       (%rax){1to4}, %ymm19
vpconflictq       %ymm16, %ymm19 {k1}
vpconflictq       (%rax), %ymm19 {k1}
vpconflictq       (%rax){1to4}, %ymm19 {k1}
vpconflictq       %ymm16, %ymm19 {z}{k1}
vpconflictq       (%rax), %ymm19 {z}{k1}
vpconflictq       (%rax){1to4}, %ymm19 {z}{k1}

vplzcntd          %xmm16, %xmm19
vplzcntd          (%rax), %xmm19
vplzcntd          (%rax){1to4}, %xmm19
vplzcntd          %xmm16, %xmm19 {k1}
vplzcntd          (%rax), %xmm19 {k1}
vplzcntd          (%rax){1to4}, %xmm19 {k1}
vplzcntd          %xmm16, %xmm19 {z}{k1}
vplzcntd          (%rax), %xmm19 {z}{k1}
vplzcntd          (%rax){1to4}, %xmm19 {z}{k1}

vplzcntd          %ymm16, %ymm19
vplzcntd          (%rax), %ymm19
vplzcntd          (%rax){1to8}, %ymm19
vplzcntd          %ymm16, %ymm19 {k1}
vplzcntd          (%rax), %ymm19 {k1}
vplzcntd          (%rax){1to8}, %ymm19 {k1}
vplzcntd          %ymm16, %ymm19 {z}{k1}
vplzcntd          (%rax), %ymm19 {z}{k1}
vplzcntd          (%rax){1to8}, %ymm19 {z}{k1}

vplzcntq          %xmm16, %xmm19
vplzcntq          (%rax), %xmm19
vplzcntq          (%rax){1to2}, %xmm19
vplzcntq          %xmm16, %xmm19 {k1}
vplzcntq          (%rax), %xmm19 {k1}
vplzcntq          (%rax){1to2}, %xmm19 {k1}
vplzcntq          %xmm16, %xmm19 {z}{k1}
vplzcntq          (%rax), %xmm19 {z}{k1}
vplzcntq          (%rax){1to2}, %xmm19 {z}{k1}

vplzcntq          %ymm16, %ymm19
vplzcntq          (%rax), %ymm19
vplzcntq          (%rax){1to4}, %ymm19
vplzcntq          %ymm16, %ymm19 {k1}
vplzcntq          (%rax), %ymm19 {k1}
vplzcntq          (%rax){1to4}, %ymm19 {k1}
vplzcntq          %ymm16, %ymm19 {z}{k1}
vplzcntq          (%rax), %ymm19 {z}{k1}
vplzcntq          (%rax){1to4}, %ymm19 {z}{k1}

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  2      6     1.00                        vpbroadcastmb2q	%k0, %xmm16
# CHECK-NEXT:  2      6     1.00                        vpbroadcastmb2q	%k0, %ymm16
# CHECK-NEXT:  2      6     1.00                        vpbroadcastmw2d	%k0, %xmm16
# CHECK-NEXT:  2      6     1.00                        vpbroadcastmw2d	%k0, %ymm16
# CHECK-NEXT:  15     12    5.00                        vpconflictd	%xmm16, %xmm19
# CHECK-NEXT:  15     17    5.00    *                   vpconflictd	(%rax), %xmm19
# CHECK-NEXT:  15     17    5.00    *                   vpconflictd	(%rax){1to4}, %xmm19
# CHECK-NEXT:  15     12    5.00                        vpconflictd	%xmm16, %xmm19 {%k1}
# CHECK-NEXT:  15     17    5.00    *                   vpconflictd	(%rax), %xmm19 {%k1}
# CHECK-NEXT:  15     17    5.00    *                   vpconflictd	(%rax){1to4}, %xmm19 {%k1}
# CHECK-NEXT:  15     12    5.00                        vpconflictd	%xmm16, %xmm19 {%k1} {z}
# CHECK-NEXT:  15     17    5.00    *                   vpconflictd	(%rax), %xmm19 {%k1} {z}
# CHECK-NEXT:  15     17    5.00    *                   vpconflictd	(%rax){1to4}, %xmm19 {%k1} {z}
# CHECK-NEXT:  23     17    9.00                        vpconflictd	%ymm16, %ymm19
# CHECK-NEXT:  23     24    9.00    *                   vpconflictd	(%rax), %ymm19
# CHECK-NEXT:  23     24    9.00    *                   vpconflictd	(%rax){1to8}, %ymm19
# CHECK-NEXT:  23     17    9.00                        vpconflictd	%ymm16, %ymm19 {%k1}
# CHECK-NEXT:  23     24    9.00    *                   vpconflictd	(%rax), %ymm19 {%k1}
# CHECK-NEXT:  23     24    9.00    *                   vpconflictd	(%rax){1to8}, %ymm19 {%k1}
# CHECK-NEXT:  23     17    9.00                        vpconflictd	%ymm16, %ymm19 {%k1} {z}
# CHECK-NEXT:  23     24    9.00    *                   vpconflictd	(%rax), %ymm19 {%k1} {z}
# CHECK-NEXT:  23     24    9.00    *                   vpconflictd	(%rax){1to8}, %ymm19 {%k1} {z}
# CHECK-NEXT:  3      4     2.00                        vpconflictq	%xmm16, %xmm19
# CHECK-NEXT:  4      11    2.00    *                   vpconflictq	(%rax), %xmm19
# CHECK-NEXT:  4      11    2.00    *                   vpconflictq	(%rax){1to2}, %xmm19
# CHECK-NEXT:  3      4     2.00                        vpconflictq	%xmm16, %xmm19 {%k1}
# CHECK-NEXT:  4      11    2.00    *                   vpconflictq	(%rax), %xmm19 {%k1}
# CHECK-NEXT:  4      11    2.00    *                   vpconflictq	(%rax){1to2}, %xmm19 {%k1}
# CHECK-NEXT:  3      4     2.00                        vpconflictq	%xmm16, %xmm19 {%k1} {z}
# CHECK-NEXT:  4      11    2.00    *                   vpconflictq	(%rax), %xmm19 {%k1} {z}
# CHECK-NEXT:  4      11    2.00    *                   vpconflictq	(%rax){1to2}, %xmm19 {%k1} {z}
# CHECK-NEXT:  15     13    5.00                        vpconflictq	%ymm16, %ymm19
# CHECK-NEXT:  15     20    5.00    *                   vpconflictq	(%rax), %ymm19
# CHECK-NEXT:  15     20    5.00    *                   vpconflictq	(%rax){1to4}, %ymm19
# CHECK-NEXT:  15     13    5.00                        vpconflictq	%ymm16, %ymm19 {%k1}
# CHECK-NEXT:  15     20    5.00    *                   vpconflictq	(%rax), %ymm19 {%k1}
# CHECK-NEXT:  15     20    5.00    *                   vpconflictq	(%rax){1to4}, %ymm19 {%k1}
# CHECK-NEXT:  15     13    5.00                        vpconflictq	%ymm16, %ymm19 {%k1} {z}
# CHECK-NEXT:  15     20    5.00    *                   vpconflictq	(%rax), %ymm19 {%k1} {z}
# CHECK-NEXT:  15     20    5.00    *                   vpconflictq	(%rax){1to4}, %ymm19 {%k1} {z}
# CHECK-NEXT:  1      4     0.50                        vplzcntd	%xmm16, %xmm19
# CHECK-NEXT:  2      11    0.50    *                   vplzcntd	(%rax), %xmm19
# CHECK-NEXT:  2      11    0.50    *                   vplzcntd	(%rax){1to4}, %xmm19
# CHECK-NEXT:  1      4     0.50                        vplzcntd	%xmm16, %xmm19 {%k1}
# CHECK-NEXT:  2      11    0.50    *                   vplzcntd	(%rax), %xmm19 {%k1}
# CHECK-NEXT:  2      11    0.50    *                   vplzcntd	(%rax){1to4}, %xmm19 {%k1}
# CHECK-NEXT:  1      4     0.50                        vplzcntd	%xmm16, %xmm19 {%k1} {z}
# CHECK-NEXT:  2      11    0.50    *                   vplzcntd	(%rax), %xmm19 {%k1} {z}
# CHECK-NEXT:  2      11    0.50    *                   vplzcntd	(%rax){1to4}, %xmm19 {%k1} {z}
# CHECK-NEXT:  1      4     0.50                        vplzcntd	%ymm16, %ymm19
# CHECK-NEXT:  2      12    0.50    *                   vplzcntd	(%rax), %ymm19
# CHECK-NEXT:  2      12    0.50    *                   vplzcntd	(%rax){1to8}, %ymm19
# CHECK-NEXT:  1      4     0.50                        vplzcntd	%ymm16, %ymm19 {%k1}
# CHECK-NEXT:  2      12    0.50    *                   vplzcntd	(%rax), %ymm19 {%k1}
# CHECK-NEXT:  2      12    0.50    *                   vplzcntd	(%rax){1to8}, %ymm19 {%k1}
# CHECK-NEXT:  1      4     0.50                        vplzcntd	%ymm16, %ymm19 {%k1} {z}
# CHECK-NEXT:  2      12    0.50    *                   vplzcntd	(%rax), %ymm19 {%k1} {z}
# CHECK-NEXT:  2      12    0.50    *                   vplzcntd	(%rax){1to8}, %ymm19 {%k1} {z}
# CHECK-NEXT:  1      4     0.50                        vplzcntq	%xmm16, %xmm19
# CHECK-NEXT:  2      11    0.50    *                   vplzcntq	(%rax), %xmm19
# CHECK-NEXT:  2      11    0.50    *                   vplzcntq	(%rax){1to2}, %xmm19
# CHECK-NEXT:  1      4     0.50                        vplzcntq	%xmm16, %xmm19 {%k1}
# CHECK-NEXT:  2      11    0.50    *                   vplzcntq	(%rax), %xmm19 {%k1}
# CHECK-NEXT:  2      11    0.50    *                   vplzcntq	(%rax){1to2}, %xmm19 {%k1}
# CHECK-NEXT:  1      4     0.50                        vplzcntq	%xmm16, %xmm19 {%k1} {z}
# CHECK-NEXT:  2      11    0.50    *                   vplzcntq	(%rax), %xmm19 {%k1} {z}
# CHECK-NEXT:  2      11    0.50    *                   vplzcntq	(%rax){1to2}, %xmm19 {%k1} {z}
# CHECK-NEXT:  1      4     0.50                        vplzcntq	%ymm16, %ymm19
# CHECK-NEXT:  2      12    0.50    *                   vplzcntq	(%rax), %ymm19
# CHECK-NEXT:  2      12    0.50    *                   vplzcntq	(%rax){1to4}, %ymm19
# CHECK-NEXT:  1      4     0.50                        vplzcntq	%ymm16, %ymm19 {%k1}
# CHECK-NEXT:  2      12    0.50    *                   vplzcntq	(%rax), %ymm19 {%k1}
# CHECK-NEXT:  2      12    0.50    *                   vplzcntq	(%rax){1to4}, %ymm19 {%k1}
# CHECK-NEXT:  1      4     0.50                        vplzcntq	%ymm16, %ymm19 {%k1} {z}
# CHECK-NEXT:  2      12    0.50    *                   vplzcntq	(%rax), %ymm19 {%k1} {z}
# CHECK-NEXT:  2      12    0.50    *                   vplzcntq	(%rax){1to4}, %ymm19 {%k1} {z}

# CHECK:      Resources:
# CHECK-NEXT: [0]   - SPRPort00
# CHECK-NEXT: [1]   - SPRPort01
# CHECK-NEXT: [2]   - SPRPort02
# CHECK-NEXT: [3]   - SPRPort03
# CHECK-NEXT: [4]   - SPRPort04
# CHECK-NEXT: [5]   - SPRPort05
# CHECK-NEXT: [6]   - SPRPort06
# CHECK-NEXT: [7]   - SPRPort07
# CHECK-NEXT: [8]   - SPRPort08
# CHECK-NEXT: [9]   - SPRPort09
# CHECK-NEXT: [10]  - SPRPort10
# CHECK-NEXT: [11]  - SPRPort11
# CHECK-NEXT: [12]  - SPRPortInvalid

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]
# CHECK-NEXT: 148.00 139.50 16.00  16.00   -     238.00 4.50    -      -      -      -     16.00   -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   Instructions:
# CHECK-NEXT: 1.00    -      -      -      -     1.00    -      -      -      -      -      -      -     vpbroadcastmb2q	%k0, %xmm16
# CHECK-NEXT: 1.00    -      -      -      -     1.00    -      -      -      -      -      -      -     vpbroadcastmb2q	%k0, %ymm16
# CHECK-NEXT: 1.00    -      -      -      -     1.00    -      -      -      -      -      -      -     vpbroadcastmw2d	%k0, %xmm16
# CHECK-NEXT: 1.00    -      -      -      -     1.00    -      -      -      -      -      -      -     vpbroadcastmw2d	%k0, %ymm16
# CHECK-NEXT: 4.17   4.17    -      -      -     6.67    -      -      -      -      -      -      -     vpconflictd	%xmm16, %xmm19
# CHECK-NEXT: 3.83   3.83   0.33   0.33    -     6.33    -      -      -      -      -     0.33    -     vpconflictd	(%rax), %xmm19
# CHECK-NEXT: 3.83   3.83   0.33   0.33    -     6.33    -      -      -      -      -     0.33    -     vpconflictd	(%rax){1to4}, %xmm19
# CHECK-NEXT: 4.17   4.17    -      -      -     6.67    -      -      -      -      -      -      -     vpconflictd	%xmm16, %xmm19 {%k1}
# CHECK-NEXT: 3.83   3.83   0.33   0.33    -     6.33    -      -      -      -      -     0.33    -     vpconflictd	(%rax), %xmm19 {%k1}
# CHECK-NEXT: 3.83   3.83   0.33   0.33    -     6.33    -      -      -      -      -     0.33    -     vpconflictd	(%rax){1to4}, %xmm19 {%k1}
# CHECK-NEXT: 4.17   4.17    -      -      -     6.67    -      -      -      -      -      -      -     vpconflictd	%xmm16, %xmm19 {%k1} {z}
# CHECK-NEXT: 3.83   3.83   0.33   0.33    -     6.33    -      -      -      -      -     0.33    -     vpconflictd	(%rax), %xmm19 {%k1} {z}
# CHECK-NEXT: 3.83   3.83   0.33   0.33    -     6.33    -      -      -      -      -     0.33    -     vpconflictd	(%rax){1to4}, %xmm19 {%k1} {z}
# CHECK-NEXT: 6.00   5.50    -      -      -     11.00  0.50    -      -      -      -      -      -     vpconflictd	%ymm16, %ymm19
# CHECK-NEXT: 5.67   5.17   0.33   0.33    -     10.67  0.50    -      -      -      -     0.33    -     vpconflictd	(%rax), %ymm19
# CHECK-NEXT: 5.67   5.17   0.33   0.33    -     10.67  0.50    -      -      -      -     0.33    -     vpconflictd	(%rax){1to8}, %ymm19
# CHECK-NEXT: 6.00   5.50    -      -      -     11.00  0.50    -      -      -      -      -      -     vpconflictd	%ymm16, %ymm19 {%k1}
# CHECK-NEXT: 5.67   5.17   0.33   0.33    -     10.67  0.50    -      -      -      -     0.33    -     vpconflictd	(%rax), %ymm19 {%k1}
# CHECK-NEXT: 5.67   5.17   0.33   0.33    -     10.67  0.50    -      -      -      -     0.33    -     vpconflictd	(%rax){1to8}, %ymm19 {%k1}
# CHECK-NEXT: 6.00   5.50    -      -      -     11.00  0.50    -      -      -      -      -      -     vpconflictd	%ymm16, %ymm19 {%k1} {z}
# CHECK-NEXT: 5.67   5.17   0.33   0.33    -     10.67  0.50    -      -      -      -     0.33    -     vpconflictd	(%rax), %ymm19 {%k1} {z}
# CHECK-NEXT: 5.67   5.17   0.33   0.33    -     10.67  0.50    -      -      -      -     0.33    -     vpconflictd	(%rax){1to8}, %ymm19 {%k1} {z}
# CHECK-NEXT: 0.33   0.33    -      -      -     2.33    -      -      -      -      -      -      -     vpconflictq	%xmm16, %xmm19
# CHECK-NEXT: 0.33   0.33   0.33   0.33    -     2.33    -      -      -      -      -     0.33    -     vpconflictq	(%rax), %xmm19
# CHECK-NEXT: 0.33   0.33   0.33   0.33    -     2.33    -      -      -      -      -     0.33    -     vpconflictq	(%rax){1to2}, %xmm19
# CHECK-NEXT: 0.33   0.33    -      -      -     2.33    -      -      -      -      -      -      -     vpconflictq	%xmm16, %xmm19 {%k1}
# CHECK-NEXT: 0.33   0.33   0.33   0.33    -     2.33    -      -      -      -      -     0.33    -     vpconflictq	(%rax), %xmm19 {%k1}
# CHECK-NEXT: 0.33   0.33   0.33   0.33    -     2.33    -      -      -      -      -     0.33    -     vpconflictq	(%rax){1to2}, %xmm19 {%k1}
# CHECK-NEXT: 0.33   0.33    -      -      -     2.33    -      -      -      -      -      -      -     vpconflictq	%xmm16, %xmm19 {%k1} {z}
# CHECK-NEXT: 0.33   0.33   0.33   0.33    -     2.33    -      -      -      -      -     0.33    -     vpconflictq	(%rax), %xmm19 {%k1} {z}
# CHECK-NEXT: 0.33   0.33   0.33   0.33    -     2.33    -      -      -      -      -     0.33    -     vpconflictq	(%rax){1to2}, %xmm19 {%k1} {z}
# CHECK-NEXT: 4.17   4.17    -      -      -     6.67    -      -      -      -      -      -      -     vpconflictq	%ymm16, %ymm19
# CHECK-NEXT: 3.83   3.83   0.33   0.33    -     6.33    -      -      -      -      -     0.33    -     vpconflictq	(%rax), %ymm19
# CHECK-NEXT: 3.83   3.83   0.33   0.33    -     6.33    -      -      -      -      -     0.33    -     vpconflictq	(%rax){1to4}, %ymm19
# CHECK-NEXT: 4.17   4.17    -      -      -     6.67    -      -      -      -      -      -      -     vpconflictq	%ymm16, %ymm19 {%k1}
# CHECK-NEXT: 3.83   3.83   0.33   0.33    -     6.33    -      -      -      -      -     0.33    -     vpconflictq	(%rax), %ymm19 {%k1}
# CHECK-NEXT: 3.83   3.83   0.33   0.33    -     6.33    -      -      -      -      -     0.33    -     vpconflictq	(%rax){1to4}, %ymm19 {%k1}
# CHECK-NEXT: 4.17   4.17    -      -      -     6.67    -      -      -      -      -      -      -     vpconflictq	%ymm16, %ymm19 {%k1} {z}
# CHECK-NEXT: 3.83   3.83   0.33   0.33    -     6.33    -      -      -      -      -     0.33    -     vpconflictq	(%rax), %ymm19 {%k1} {z}
# CHECK-NEXT: 3.83   3.83   0.33   0.33    -     6.33    -      -      -      -      -     0.33    -     vpconflictq	(%rax){1to4}, %ymm19 {%k1} {z}
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -      -     vplzcntd	%xmm16, %xmm19
# CHECK-NEXT: 0.50   0.50   0.33   0.33    -      -      -      -      -      -      -     0.33    -     vplzcntd	(%rax), %xmm19
# CHECK-NEXT: 0.50   0.50   0.33   0.33    -      -      -      -      -      -      -     0.33    -     vplzcntd	(%rax){1to4}, %xmm19
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -      -     vplzcntd	%xmm16, %xmm19 {%k1}
# CHECK-NEXT: 0.50   0.50   0.33   0.33    -      -      -      -      -      -      -     0.33    -     vplzcntd	(%rax), %xmm19 {%k1}
# CHECK-NEXT: 0.50   0.50   0.33   0.33    -      -      -      -      -      -      -     0.33    -     vplzcntd	(%rax){1to4}, %xmm19 {%k1}
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -      -     vplzcntd	%xmm16, %xmm19 {%k1} {z}
# CHECK-NEXT: 0.50   0.50   0.33   0.33    -      -      -      -      -      -      -     0.33    -     vplzcntd	(%rax), %xmm19 {%k1} {z}
# CHECK-NEXT: 0.50   0.50   0.33   0.33    -      -      -      -      -      -      -     0.33    -     vplzcntd	(%rax){1to4}, %xmm19 {%k1} {z}
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -      -     vplzcntd	%ymm16, %ymm19
# CHECK-NEXT: 0.50   0.50   0.33   0.33    -      -      -      -      -      -      -     0.33    -     vplzcntd	(%rax), %ymm19
# CHECK-NEXT: 0.50   0.50   0.33   0.33    -      -      -      -      -      -      -     0.33    -     vplzcntd	(%rax){1to8}, %ymm19
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -      -     vplzcntd	%ymm16, %ymm19 {%k1}
# CHECK-NEXT: 0.50   0.50   0.33   0.33    -      -      -      -      -      -      -     0.33    -     vplzcntd	(%rax), %ymm19 {%k1}
# CHECK-NEXT: 0.50   0.50   0.33   0.33    -      -      -      -      -      -      -     0.33    -     vplzcntd	(%rax){1to8}, %ymm19 {%k1}
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -      -     vplzcntd	%ymm16, %ymm19 {%k1} {z}
# CHECK-NEXT: 0.50   0.50   0.33   0.33    -      -      -      -      -      -      -     0.33    -     vplzcntd	(%rax), %ymm19 {%k1} {z}
# CHECK-NEXT: 0.50   0.50   0.33   0.33    -      -      -      -      -      -      -     0.33    -     vplzcntd	(%rax){1to8}, %ymm19 {%k1} {z}
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -      -     vplzcntq	%xmm16, %xmm19
# CHECK-NEXT: 0.50   0.50   0.33   0.33    -      -      -      -      -      -      -     0.33    -     vplzcntq	(%rax), %xmm19
# CHECK-NEXT: 0.50   0.50   0.33   0.33    -      -      -      -      -      -      -     0.33    -     vplzcntq	(%rax){1to2}, %xmm19
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -      -     vplzcntq	%xmm16, %xmm19 {%k1}
# CHECK-NEXT: 0.50   0.50   0.33   0.33    -      -      -      -      -      -      -     0.33    -     vplzcntq	(%rax), %xmm19 {%k1}
# CHECK-NEXT: 0.50   0.50   0.33   0.33    -      -      -      -      -      -      -     0.33    -     vplzcntq	(%rax){1to2}, %xmm19 {%k1}
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -      -     vplzcntq	%xmm16, %xmm19 {%k1} {z}
# CHECK-NEXT: 0.50   0.50   0.33   0.33    -      -      -      -      -      -      -     0.33    -     vplzcntq	(%rax), %xmm19 {%k1} {z}
# CHECK-NEXT: 0.50   0.50   0.33   0.33    -      -      -      -      -      -      -     0.33    -     vplzcntq	(%rax){1to2}, %xmm19 {%k1} {z}
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -      -     vplzcntq	%ymm16, %ymm19
# CHECK-NEXT: 0.50   0.50   0.33   0.33    -      -      -      -      -      -      -     0.33    -     vplzcntq	(%rax), %ymm19
# CHECK-NEXT: 0.50   0.50   0.33   0.33    -      -      -      -      -      -      -     0.33    -     vplzcntq	(%rax){1to4}, %ymm19
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -      -     vplzcntq	%ymm16, %ymm19 {%k1}
# CHECK-NEXT: 0.50   0.50   0.33   0.33    -      -      -      -      -      -      -     0.33    -     vplzcntq	(%rax), %ymm19 {%k1}
# CHECK-NEXT: 0.50   0.50   0.33   0.33    -      -      -      -      -      -      -     0.33    -     vplzcntq	(%rax){1to4}, %ymm19 {%k1}
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -      -     vplzcntq	%ymm16, %ymm19 {%k1} {z}
# CHECK-NEXT: 0.50   0.50   0.33   0.33    -      -      -      -      -      -      -     0.33    -     vplzcntq	(%rax), %ymm19 {%k1} {z}
# CHECK-NEXT: 0.50   0.50   0.33   0.33    -      -      -      -      -      -      -     0.33    -     vplzcntq	(%rax){1to4}, %ymm19 {%k1} {z}
