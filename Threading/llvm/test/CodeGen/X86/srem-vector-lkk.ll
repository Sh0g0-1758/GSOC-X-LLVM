; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=SSE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx  | FileCheck %s --check-prefixes=AVX,AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefixes=AVX,AVX2

define <4 x i16> @fold_srem_vec_1(<4 x i16> %x) {
; SSE-LABEL: fold_srem_vec_1:
; SSE:       # %bb.0:
; SSE-NEXT:    pextrw $3, %xmm0, %eax
; SSE-NEXT:    movswl %ax, %ecx
; SSE-NEXT:    imull $32081, %ecx, %ecx # imm = 0x7D51
; SSE-NEXT:    shrl $16, %ecx
; SSE-NEXT:    subl %eax, %ecx
; SSE-NEXT:    movzwl %cx, %ecx
; SSE-NEXT:    movswl %cx, %edx
; SSE-NEXT:    shrl $15, %ecx
; SSE-NEXT:    sarl $9, %edx
; SSE-NEXT:    addl %ecx, %edx
; SSE-NEXT:    imull $-1003, %edx, %ecx # imm = 0xFC15
; SSE-NEXT:    subl %ecx, %eax
; SSE-NEXT:    movd %xmm0, %ecx
; SSE-NEXT:    movswl %cx, %edx
; SSE-NEXT:    imull $-21385, %edx, %edx # imm = 0xAC77
; SSE-NEXT:    shrl $16, %edx
; SSE-NEXT:    addl %ecx, %edx
; SSE-NEXT:    movzwl %dx, %edx
; SSE-NEXT:    movswl %dx, %esi
; SSE-NEXT:    shrl $15, %edx
; SSE-NEXT:    sarl $6, %esi
; SSE-NEXT:    addl %edx, %esi
; SSE-NEXT:    imull $95, %esi, %edx
; SSE-NEXT:    subl %edx, %ecx
; SSE-NEXT:    movd %ecx, %xmm1
; SSE-NEXT:    pextrw $1, %xmm0, %ecx
; SSE-NEXT:    movswl %cx, %edx
; SSE-NEXT:    imull $-16913, %edx, %edx # imm = 0xBDEF
; SSE-NEXT:    movl %edx, %esi
; SSE-NEXT:    shrl $31, %esi
; SSE-NEXT:    sarl $21, %edx
; SSE-NEXT:    addl %esi, %edx
; SSE-NEXT:    imull $-124, %edx, %edx
; SSE-NEXT:    subl %edx, %ecx
; SSE-NEXT:    pinsrw $1, %ecx, %xmm1
; SSE-NEXT:    pextrw $2, %xmm0, %ecx
; SSE-NEXT:    movswl %cx, %edx
; SSE-NEXT:    imull $2675, %edx, %edx # imm = 0xA73
; SSE-NEXT:    movl %edx, %esi
; SSE-NEXT:    shrl $31, %esi
; SSE-NEXT:    sarl $18, %edx
; SSE-NEXT:    addl %esi, %edx
; SSE-NEXT:    imull $98, %edx, %edx
; SSE-NEXT:    subl %edx, %ecx
; SSE-NEXT:    pinsrw $2, %ecx, %xmm1
; SSE-NEXT:    pinsrw $3, %eax, %xmm1
; SSE-NEXT:    movdqa %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fold_srem_vec_1:
; AVX:       # %bb.0:
; AVX-NEXT:    vpextrw $3, %xmm0, %eax
; AVX-NEXT:    movswl %ax, %ecx
; AVX-NEXT:    imull $32081, %ecx, %ecx # imm = 0x7D51
; AVX-NEXT:    shrl $16, %ecx
; AVX-NEXT:    subl %eax, %ecx
; AVX-NEXT:    movzwl %cx, %ecx
; AVX-NEXT:    movswl %cx, %edx
; AVX-NEXT:    shrl $15, %ecx
; AVX-NEXT:    sarl $9, %edx
; AVX-NEXT:    addl %ecx, %edx
; AVX-NEXT:    imull $-1003, %edx, %ecx # imm = 0xFC15
; AVX-NEXT:    subl %ecx, %eax
; AVX-NEXT:    vmovd %xmm0, %ecx
; AVX-NEXT:    movswl %cx, %edx
; AVX-NEXT:    imull $-21385, %edx, %edx # imm = 0xAC77
; AVX-NEXT:    shrl $16, %edx
; AVX-NEXT:    addl %ecx, %edx
; AVX-NEXT:    movzwl %dx, %edx
; AVX-NEXT:    movswl %dx, %esi
; AVX-NEXT:    shrl $15, %edx
; AVX-NEXT:    sarl $6, %esi
; AVX-NEXT:    addl %edx, %esi
; AVX-NEXT:    imull $95, %esi, %edx
; AVX-NEXT:    subl %edx, %ecx
; AVX-NEXT:    vmovd %ecx, %xmm1
; AVX-NEXT:    vpextrw $1, %xmm0, %ecx
; AVX-NEXT:    movswl %cx, %edx
; AVX-NEXT:    imull $-16913, %edx, %edx # imm = 0xBDEF
; AVX-NEXT:    movl %edx, %esi
; AVX-NEXT:    shrl $31, %esi
; AVX-NEXT:    sarl $21, %edx
; AVX-NEXT:    addl %esi, %edx
; AVX-NEXT:    imull $-124, %edx, %edx
; AVX-NEXT:    subl %edx, %ecx
; AVX-NEXT:    vpinsrw $1, %ecx, %xmm1, %xmm1
; AVX-NEXT:    vpextrw $2, %xmm0, %ecx
; AVX-NEXT:    movswl %cx, %edx
; AVX-NEXT:    imull $2675, %edx, %edx # imm = 0xA73
; AVX-NEXT:    movl %edx, %esi
; AVX-NEXT:    shrl $31, %esi
; AVX-NEXT:    sarl $18, %edx
; AVX-NEXT:    addl %esi, %edx
; AVX-NEXT:    imull $98, %edx, %edx
; AVX-NEXT:    subl %edx, %ecx
; AVX-NEXT:    vpinsrw $2, %ecx, %xmm1, %xmm0
; AVX-NEXT:    vpinsrw $3, %eax, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = srem <4 x i16> %x, <i16 95, i16 -124, i16 98, i16 -1003>
  ret <4 x i16> %1
}

define <4 x i16> @fold_srem_vec_2(<4 x i16> %x) {
; SSE-LABEL: fold_srem_vec_2:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa {{.*#+}} xmm1 = [44151,44151,44151,44151,44151,44151,44151,44151]
; SSE-NEXT:    pmulhw %xmm0, %xmm1
; SSE-NEXT:    paddw %xmm0, %xmm1
; SSE-NEXT:    movdqa %xmm1, %xmm2
; SSE-NEXT:    psrlw $15, %xmm2
; SSE-NEXT:    psraw $6, %xmm1
; SSE-NEXT:    paddw %xmm2, %xmm1
; SSE-NEXT:    pmullw {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1
; SSE-NEXT:    psubw %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fold_srem_vec_2:
; AVX:       # %bb.0:
; AVX-NEXT:    vpmulhw {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm1
; AVX-NEXT:    vpaddw %xmm0, %xmm1, %xmm1
; AVX-NEXT:    vpsrlw $15, %xmm1, %xmm2
; AVX-NEXT:    vpsraw $6, %xmm1, %xmm1
; AVX-NEXT:    vpaddw %xmm2, %xmm1, %xmm1
; AVX-NEXT:    vpmullw {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1, %xmm1
; AVX-NEXT:    vpsubw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = srem <4 x i16> %x, <i16 95, i16 95, i16 95, i16 95>
  ret <4 x i16> %1
}


; Don't fold if we can combine srem with sdiv.
define <4 x i16> @combine_srem_sdiv(<4 x i16> %x) {
; SSE-LABEL: combine_srem_sdiv:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa {{.*#+}} xmm1 = [44151,44151,44151,44151,44151,44151,44151,44151]
; SSE-NEXT:    pmulhw %xmm0, %xmm1
; SSE-NEXT:    paddw %xmm0, %xmm1
; SSE-NEXT:    movdqa %xmm1, %xmm2
; SSE-NEXT:    psrlw $15, %xmm2
; SSE-NEXT:    psraw $6, %xmm1
; SSE-NEXT:    paddw %xmm2, %xmm1
; SSE-NEXT:    pmovsxbw {{.*#+}} xmm2 = [95,95,95,95,95,95,95,95]
; SSE-NEXT:    pmullw %xmm1, %xmm2
; SSE-NEXT:    psubw %xmm2, %xmm0
; SSE-NEXT:    paddw %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_srem_sdiv:
; AVX:       # %bb.0:
; AVX-NEXT:    vpmulhw {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm1
; AVX-NEXT:    vpaddw %xmm0, %xmm1, %xmm1
; AVX-NEXT:    vpsrlw $15, %xmm1, %xmm2
; AVX-NEXT:    vpsraw $6, %xmm1, %xmm1
; AVX-NEXT:    vpaddw %xmm2, %xmm1, %xmm1
; AVX-NEXT:    vpmullw {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1, %xmm2
; AVX-NEXT:    vpsubw %xmm2, %xmm0, %xmm0
; AVX-NEXT:    vpaddw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = srem <4 x i16> %x, <i16 95, i16 95, i16 95, i16 95>
  %2 = sdiv <4 x i16> %x, <i16 95, i16 95, i16 95, i16 95>
  %3 = add <4 x i16> %1, %2
  ret <4 x i16> %3
}

; Don't fold for divisors that are a power of two.
define <4 x i16> @dont_fold_srem_power_of_two(<4 x i16> %x) {
; SSE-LABEL: dont_fold_srem_power_of_two:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa %xmm0, %xmm1
; SSE-NEXT:    pextrw $1, %xmm0, %eax
; SSE-NEXT:    leal 31(%rax), %ecx
; SSE-NEXT:    testw %ax, %ax
; SSE-NEXT:    cmovnsl %eax, %ecx
; SSE-NEXT:    andl $-32, %ecx
; SSE-NEXT:    subl %ecx, %eax
; SSE-NEXT:    movd %xmm0, %ecx
; SSE-NEXT:    leal 63(%rcx), %edx
; SSE-NEXT:    testw %cx, %cx
; SSE-NEXT:    cmovnsl %ecx, %edx
; SSE-NEXT:    andl $-64, %edx
; SSE-NEXT:    subl %edx, %ecx
; SSE-NEXT:    movd %ecx, %xmm0
; SSE-NEXT:    pinsrw $1, %eax, %xmm0
; SSE-NEXT:    pextrw $2, %xmm1, %eax
; SSE-NEXT:    leal 7(%rax), %ecx
; SSE-NEXT:    testw %ax, %ax
; SSE-NEXT:    cmovnsl %eax, %ecx
; SSE-NEXT:    andl $-8, %ecx
; SSE-NEXT:    subl %ecx, %eax
; SSE-NEXT:    pinsrw $2, %eax, %xmm0
; SSE-NEXT:    pextrw $3, %xmm1, %eax
; SSE-NEXT:    movswl %ax, %ecx
; SSE-NEXT:    imull $-21385, %ecx, %ecx # imm = 0xAC77
; SSE-NEXT:    shrl $16, %ecx
; SSE-NEXT:    addl %eax, %ecx
; SSE-NEXT:    movzwl %cx, %ecx
; SSE-NEXT:    movswl %cx, %edx
; SSE-NEXT:    shrl $15, %ecx
; SSE-NEXT:    sarl $6, %edx
; SSE-NEXT:    addl %ecx, %edx
; SSE-NEXT:    imull $95, %edx, %ecx
; SSE-NEXT:    subl %ecx, %eax
; SSE-NEXT:    pinsrw $3, %eax, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: dont_fold_srem_power_of_two:
; AVX:       # %bb.0:
; AVX-NEXT:    vpextrw $1, %xmm0, %eax
; AVX-NEXT:    leal 31(%rax), %ecx
; AVX-NEXT:    testw %ax, %ax
; AVX-NEXT:    cmovnsl %eax, %ecx
; AVX-NEXT:    andl $-32, %ecx
; AVX-NEXT:    subl %ecx, %eax
; AVX-NEXT:    vmovd %xmm0, %ecx
; AVX-NEXT:    leal 63(%rcx), %edx
; AVX-NEXT:    testw %cx, %cx
; AVX-NEXT:    cmovnsl %ecx, %edx
; AVX-NEXT:    andl $-64, %edx
; AVX-NEXT:    subl %edx, %ecx
; AVX-NEXT:    vmovd %ecx, %xmm1
; AVX-NEXT:    vpinsrw $1, %eax, %xmm1, %xmm1
; AVX-NEXT:    vpextrw $2, %xmm0, %eax
; AVX-NEXT:    leal 7(%rax), %ecx
; AVX-NEXT:    testw %ax, %ax
; AVX-NEXT:    cmovnsl %eax, %ecx
; AVX-NEXT:    andl $-8, %ecx
; AVX-NEXT:    subl %ecx, %eax
; AVX-NEXT:    vpinsrw $2, %eax, %xmm1, %xmm1
; AVX-NEXT:    vpextrw $3, %xmm0, %eax
; AVX-NEXT:    movswl %ax, %ecx
; AVX-NEXT:    imull $-21385, %ecx, %ecx # imm = 0xAC77
; AVX-NEXT:    shrl $16, %ecx
; AVX-NEXT:    addl %eax, %ecx
; AVX-NEXT:    movzwl %cx, %ecx
; AVX-NEXT:    movswl %cx, %edx
; AVX-NEXT:    shrl $15, %ecx
; AVX-NEXT:    sarl $6, %edx
; AVX-NEXT:    addl %ecx, %edx
; AVX-NEXT:    imull $95, %edx, %ecx
; AVX-NEXT:    subl %ecx, %eax
; AVX-NEXT:    vpinsrw $3, %eax, %xmm1, %xmm0
; AVX-NEXT:    retq
  %1 = srem <4 x i16> %x, <i16 64, i16 32, i16 8, i16 95>
  ret <4 x i16> %1
}

; Don't fold if the divisor is one.
define <4 x i16> @dont_fold_srem_one(<4 x i16> %x) {
; SSE-LABEL: dont_fold_srem_one:
; SSE:       # %bb.0:
; SSE-NEXT:    pextrw $2, %xmm0, %ecx
; SSE-NEXT:    movswl %cx, %eax
; SSE-NEXT:    imull $-19945, %eax, %eax # imm = 0xB217
; SSE-NEXT:    shrl $16, %eax
; SSE-NEXT:    addl %ecx, %eax
; SSE-NEXT:    movzwl %ax, %edx
; SSE-NEXT:    movswl %dx, %eax
; SSE-NEXT:    shrl $15, %edx
; SSE-NEXT:    sarl $4, %eax
; SSE-NEXT:    addl %edx, %eax
; SSE-NEXT:    leal (%rax,%rax,2), %edx
; SSE-NEXT:    shll $3, %edx
; SSE-NEXT:    subl %edx, %eax
; SSE-NEXT:    addl %ecx, %eax
; SSE-NEXT:    pextrw $1, %xmm0, %ecx
; SSE-NEXT:    movswl %cx, %edx
; SSE-NEXT:    imull $12827, %edx, %edx # imm = 0x321B
; SSE-NEXT:    movl %edx, %esi
; SSE-NEXT:    shrl $31, %esi
; SSE-NEXT:    sarl $23, %edx
; SSE-NEXT:    addl %esi, %edx
; SSE-NEXT:    imull $654, %edx, %edx # imm = 0x28E
; SSE-NEXT:    subl %edx, %ecx
; SSE-NEXT:    pxor %xmm1, %xmm1
; SSE-NEXT:    pinsrw $1, %ecx, %xmm1
; SSE-NEXT:    pinsrw $2, %eax, %xmm1
; SSE-NEXT:    pextrw $3, %xmm0, %eax
; SSE-NEXT:    movswl %ax, %ecx
; SSE-NEXT:    imull $12375, %ecx, %ecx # imm = 0x3057
; SSE-NEXT:    movl %ecx, %edx
; SSE-NEXT:    shrl $31, %edx
; SSE-NEXT:    sarl $26, %ecx
; SSE-NEXT:    addl %edx, %ecx
; SSE-NEXT:    imull $5423, %ecx, %ecx # imm = 0x152F
; SSE-NEXT:    subl %ecx, %eax
; SSE-NEXT:    pinsrw $3, %eax, %xmm1
; SSE-NEXT:    movdqa %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: dont_fold_srem_one:
; AVX:       # %bb.0:
; AVX-NEXT:    vpextrw $2, %xmm0, %eax
; AVX-NEXT:    movswl %ax, %ecx
; AVX-NEXT:    imull $-19945, %ecx, %ecx # imm = 0xB217
; AVX-NEXT:    shrl $16, %ecx
; AVX-NEXT:    addl %eax, %ecx
; AVX-NEXT:    movzwl %cx, %ecx
; AVX-NEXT:    movswl %cx, %edx
; AVX-NEXT:    shrl $15, %ecx
; AVX-NEXT:    sarl $4, %edx
; AVX-NEXT:    addl %ecx, %edx
; AVX-NEXT:    leal (%rdx,%rdx,2), %ecx
; AVX-NEXT:    shll $3, %ecx
; AVX-NEXT:    subl %ecx, %edx
; AVX-NEXT:    addl %eax, %edx
; AVX-NEXT:    vpextrw $1, %xmm0, %eax
; AVX-NEXT:    movswl %ax, %ecx
; AVX-NEXT:    imull $12827, %ecx, %ecx # imm = 0x321B
; AVX-NEXT:    movl %ecx, %esi
; AVX-NEXT:    shrl $31, %esi
; AVX-NEXT:    sarl $23, %ecx
; AVX-NEXT:    addl %esi, %ecx
; AVX-NEXT:    imull $654, %ecx, %ecx # imm = 0x28E
; AVX-NEXT:    subl %ecx, %eax
; AVX-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vpinsrw $1, %eax, %xmm1, %xmm1
; AVX-NEXT:    vpinsrw $2, %edx, %xmm1, %xmm1
; AVX-NEXT:    vpextrw $3, %xmm0, %eax
; AVX-NEXT:    movswl %ax, %ecx
; AVX-NEXT:    imull $12375, %ecx, %ecx # imm = 0x3057
; AVX-NEXT:    movl %ecx, %edx
; AVX-NEXT:    shrl $31, %edx
; AVX-NEXT:    sarl $26, %ecx
; AVX-NEXT:    addl %edx, %ecx
; AVX-NEXT:    imull $5423, %ecx, %ecx # imm = 0x152F
; AVX-NEXT:    subl %ecx, %eax
; AVX-NEXT:    vpinsrw $3, %eax, %xmm1, %xmm0
; AVX-NEXT:    retq
  %1 = srem <4 x i16> %x, <i16 1, i16 654, i16 23, i16 5423>
  ret <4 x i16> %1
}

; Don't fold if the divisor is 2^15.
define <4 x i16> @dont_fold_urem_i16_smax(<4 x i16> %x) {
; SSE-LABEL: dont_fold_urem_i16_smax:
; SSE:       # %bb.0:
; SSE-NEXT:    pextrw $2, %xmm0, %eax
; SSE-NEXT:    movswl %ax, %ecx
; SSE-NEXT:    imull $-19945, %ecx, %ecx # imm = 0xB217
; SSE-NEXT:    shrl $16, %ecx
; SSE-NEXT:    addl %eax, %ecx
; SSE-NEXT:    movzwl %cx, %ecx
; SSE-NEXT:    movswl %cx, %edx
; SSE-NEXT:    shrl $15, %ecx
; SSE-NEXT:    sarl $4, %edx
; SSE-NEXT:    addl %ecx, %edx
; SSE-NEXT:    leal (%rdx,%rdx,2), %ecx
; SSE-NEXT:    shll $3, %ecx
; SSE-NEXT:    subl %ecx, %edx
; SSE-NEXT:    addl %eax, %edx
; SSE-NEXT:    pextrw $1, %xmm0, %eax
; SSE-NEXT:    leal 32767(%rax), %ecx
; SSE-NEXT:    testw %ax, %ax
; SSE-NEXT:    cmovnsl %eax, %ecx
; SSE-NEXT:    andl $-32768, %ecx # imm = 0x8000
; SSE-NEXT:    addl %eax, %ecx
; SSE-NEXT:    pxor %xmm1, %xmm1
; SSE-NEXT:    pinsrw $1, %ecx, %xmm1
; SSE-NEXT:    pinsrw $2, %edx, %xmm1
; SSE-NEXT:    pextrw $3, %xmm0, %eax
; SSE-NEXT:    movswl %ax, %ecx
; SSE-NEXT:    imull $12375, %ecx, %ecx # imm = 0x3057
; SSE-NEXT:    movl %ecx, %edx
; SSE-NEXT:    shrl $31, %edx
; SSE-NEXT:    sarl $26, %ecx
; SSE-NEXT:    addl %edx, %ecx
; SSE-NEXT:    imull $5423, %ecx, %ecx # imm = 0x152F
; SSE-NEXT:    subl %ecx, %eax
; SSE-NEXT:    pinsrw $3, %eax, %xmm1
; SSE-NEXT:    movdqa %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: dont_fold_urem_i16_smax:
; AVX:       # %bb.0:
; AVX-NEXT:    vpextrw $2, %xmm0, %eax
; AVX-NEXT:    movswl %ax, %ecx
; AVX-NEXT:    imull $-19945, %ecx, %ecx # imm = 0xB217
; AVX-NEXT:    shrl $16, %ecx
; AVX-NEXT:    addl %eax, %ecx
; AVX-NEXT:    movzwl %cx, %ecx
; AVX-NEXT:    movswl %cx, %edx
; AVX-NEXT:    shrl $15, %ecx
; AVX-NEXT:    sarl $4, %edx
; AVX-NEXT:    addl %ecx, %edx
; AVX-NEXT:    leal (%rdx,%rdx,2), %ecx
; AVX-NEXT:    shll $3, %ecx
; AVX-NEXT:    subl %ecx, %edx
; AVX-NEXT:    addl %eax, %edx
; AVX-NEXT:    vpextrw $1, %xmm0, %eax
; AVX-NEXT:    leal 32767(%rax), %ecx
; AVX-NEXT:    testw %ax, %ax
; AVX-NEXT:    cmovnsl %eax, %ecx
; AVX-NEXT:    andl $-32768, %ecx # imm = 0x8000
; AVX-NEXT:    addl %eax, %ecx
; AVX-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vpinsrw $1, %ecx, %xmm1, %xmm1
; AVX-NEXT:    vpinsrw $2, %edx, %xmm1, %xmm1
; AVX-NEXT:    vpextrw $3, %xmm0, %eax
; AVX-NEXT:    movswl %ax, %ecx
; AVX-NEXT:    imull $12375, %ecx, %ecx # imm = 0x3057
; AVX-NEXT:    movl %ecx, %edx
; AVX-NEXT:    shrl $31, %edx
; AVX-NEXT:    sarl $26, %ecx
; AVX-NEXT:    addl %edx, %ecx
; AVX-NEXT:    imull $5423, %ecx, %ecx # imm = 0x152F
; AVX-NEXT:    subl %ecx, %eax
; AVX-NEXT:    vpinsrw $3, %eax, %xmm1, %xmm0
; AVX-NEXT:    retq
  %1 = srem <4 x i16> %x, <i16 1, i16 32768, i16 23, i16 5423>
  ret <4 x i16> %1
}

; Don't fold i64 srem.
define <4 x i64> @dont_fold_srem_i64(<4 x i64> %x) {
; SSE-LABEL: dont_fold_srem_i64:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa %xmm1, %xmm2
; SSE-NEXT:    movq %xmm1, %rcx
; SSE-NEXT:    movabsq $-5614226457215950491, %rdx # imm = 0xB21642C8590B2165
; SSE-NEXT:    movq %rcx, %rax
; SSE-NEXT:    imulq %rdx
; SSE-NEXT:    addq %rcx, %rdx
; SSE-NEXT:    movq %rdx, %rax
; SSE-NEXT:    shrq $63, %rax
; SSE-NEXT:    sarq $4, %rdx
; SSE-NEXT:    addq %rax, %rdx
; SSE-NEXT:    leaq (%rdx,%rdx,2), %rax
; SSE-NEXT:    shlq $3, %rax
; SSE-NEXT:    subq %rax, %rdx
; SSE-NEXT:    addq %rcx, %rdx
; SSE-NEXT:    movq %rdx, %xmm1
; SSE-NEXT:    pextrq $1, %xmm2, %rcx
; SSE-NEXT:    movabsq $6966426675817289639, %rdx # imm = 0x60ADB826E5E517A7
; SSE-NEXT:    movq %rcx, %rax
; SSE-NEXT:    imulq %rdx
; SSE-NEXT:    movq %rdx, %rax
; SSE-NEXT:    shrq $63, %rax
; SSE-NEXT:    sarq $11, %rdx
; SSE-NEXT:    addq %rax, %rdx
; SSE-NEXT:    imulq $5423, %rdx, %rax # imm = 0x152F
; SSE-NEXT:    subq %rax, %rcx
; SSE-NEXT:    movq %rcx, %xmm2
; SSE-NEXT:    punpcklqdq {{.*#+}} xmm1 = xmm1[0],xmm2[0]
; SSE-NEXT:    pextrq $1, %xmm0, %rcx
; SSE-NEXT:    movabsq $7220743857598845893, %rdx # imm = 0x64353C48064353C5
; SSE-NEXT:    movq %rcx, %rax
; SSE-NEXT:    imulq %rdx
; SSE-NEXT:    movq %rdx, %rax
; SSE-NEXT:    shrq $63, %rax
; SSE-NEXT:    sarq $8, %rdx
; SSE-NEXT:    addq %rax, %rdx
; SSE-NEXT:    imulq $654, %rdx, %rax # imm = 0x28E
; SSE-NEXT:    subq %rax, %rcx
; SSE-NEXT:    movq %rcx, %xmm0
; SSE-NEXT:    pslldq {{.*#+}} xmm0 = zero,zero,zero,zero,zero,zero,zero,zero,xmm0[0,1,2,3,4,5,6,7]
; SSE-NEXT:    retq
;
; AVX1-LABEL: dont_fold_srem_i64:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vmovq %xmm1, %rcx
; AVX1-NEXT:    movabsq $-5614226457215950491, %rdx # imm = 0xB21642C8590B2165
; AVX1-NEXT:    movq %rcx, %rax
; AVX1-NEXT:    imulq %rdx
; AVX1-NEXT:    addq %rcx, %rdx
; AVX1-NEXT:    movq %rdx, %rax
; AVX1-NEXT:    shrq $63, %rax
; AVX1-NEXT:    sarq $4, %rdx
; AVX1-NEXT:    addq %rax, %rdx
; AVX1-NEXT:    leaq (%rdx,%rdx,2), %rax
; AVX1-NEXT:    shlq $3, %rax
; AVX1-NEXT:    subq %rax, %rdx
; AVX1-NEXT:    addq %rcx, %rdx
; AVX1-NEXT:    vmovq %rdx, %xmm2
; AVX1-NEXT:    vpextrq $1, %xmm1, %rcx
; AVX1-NEXT:    movabsq $6966426675817289639, %rdx # imm = 0x60ADB826E5E517A7
; AVX1-NEXT:    movq %rcx, %rax
; AVX1-NEXT:    imulq %rdx
; AVX1-NEXT:    movq %rdx, %rax
; AVX1-NEXT:    shrq $63, %rax
; AVX1-NEXT:    sarq $11, %rdx
; AVX1-NEXT:    addq %rax, %rdx
; AVX1-NEXT:    imulq $5423, %rdx, %rax # imm = 0x152F
; AVX1-NEXT:    subq %rax, %rcx
; AVX1-NEXT:    vmovq %rcx, %xmm1
; AVX1-NEXT:    vpunpcklqdq {{.*#+}} xmm1 = xmm2[0],xmm1[0]
; AVX1-NEXT:    vpextrq $1, %xmm0, %rcx
; AVX1-NEXT:    movabsq $7220743857598845893, %rdx # imm = 0x64353C48064353C5
; AVX1-NEXT:    movq %rcx, %rax
; AVX1-NEXT:    imulq %rdx
; AVX1-NEXT:    movq %rdx, %rax
; AVX1-NEXT:    shrq $63, %rax
; AVX1-NEXT:    sarq $8, %rdx
; AVX1-NEXT:    addq %rax, %rdx
; AVX1-NEXT:    imulq $654, %rdx, %rax # imm = 0x28E
; AVX1-NEXT:    subq %rax, %rcx
; AVX1-NEXT:    vmovq %rcx, %xmm0
; AVX1-NEXT:    vpslldq {{.*#+}} xmm0 = zero,zero,zero,zero,zero,zero,zero,zero,xmm0[0,1,2,3,4,5,6,7]
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: dont_fold_srem_i64:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vmovq %xmm1, %rcx
; AVX2-NEXT:    movabsq $-5614226457215950491, %rdx # imm = 0xB21642C8590B2165
; AVX2-NEXT:    movq %rcx, %rax
; AVX2-NEXT:    imulq %rdx
; AVX2-NEXT:    addq %rcx, %rdx
; AVX2-NEXT:    movq %rdx, %rax
; AVX2-NEXT:    shrq $63, %rax
; AVX2-NEXT:    sarq $4, %rdx
; AVX2-NEXT:    addq %rax, %rdx
; AVX2-NEXT:    leaq (%rdx,%rdx,2), %rax
; AVX2-NEXT:    shlq $3, %rax
; AVX2-NEXT:    subq %rax, %rdx
; AVX2-NEXT:    addq %rcx, %rdx
; AVX2-NEXT:    vmovq %rdx, %xmm2
; AVX2-NEXT:    vpextrq $1, %xmm1, %rcx
; AVX2-NEXT:    movabsq $6966426675817289639, %rdx # imm = 0x60ADB826E5E517A7
; AVX2-NEXT:    movq %rcx, %rax
; AVX2-NEXT:    imulq %rdx
; AVX2-NEXT:    movq %rdx, %rax
; AVX2-NEXT:    shrq $63, %rax
; AVX2-NEXT:    sarq $11, %rdx
; AVX2-NEXT:    addq %rax, %rdx
; AVX2-NEXT:    imulq $5423, %rdx, %rax # imm = 0x152F
; AVX2-NEXT:    subq %rax, %rcx
; AVX2-NEXT:    vmovq %rcx, %xmm1
; AVX2-NEXT:    vpunpcklqdq {{.*#+}} xmm1 = xmm2[0],xmm1[0]
; AVX2-NEXT:    vpextrq $1, %xmm0, %rcx
; AVX2-NEXT:    movabsq $7220743857598845893, %rdx # imm = 0x64353C48064353C5
; AVX2-NEXT:    movq %rcx, %rax
; AVX2-NEXT:    imulq %rdx
; AVX2-NEXT:    movq %rdx, %rax
; AVX2-NEXT:    shrq $63, %rax
; AVX2-NEXT:    sarq $8, %rdx
; AVX2-NEXT:    addq %rax, %rdx
; AVX2-NEXT:    imulq $654, %rdx, %rax # imm = 0x28E
; AVX2-NEXT:    subq %rax, %rcx
; AVX2-NEXT:    vmovq %rcx, %xmm0
; AVX2-NEXT:    vpslldq {{.*#+}} xmm0 = zero,zero,zero,zero,zero,zero,zero,zero,xmm0[0,1,2,3,4,5,6,7]
; AVX2-NEXT:    vinserti128 $1, %xmm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %1 = srem <4 x i64> %x, <i64 1, i64 654, i64 23, i64 5423>
  ret <4 x i64> %1
}
