; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -O2 -mtriple=x86_64-linux-android -mattr=+sse \
; RUN:     -enable-legalize-types-checking | FileCheck %s --check-prefix=SSE
; RUN: llc < %s -O2 -mtriple=x86_64-linux-gnu -mattr=+sse \
; RUN:     -enable-legalize-types-checking | FileCheck %s --check-prefix=SSE
; RUN: llc < %s -O2 -mtriple=x86_64-linux-android -mattr=-sse \
; RUN:     -enable-legalize-types-checking | FileCheck %s --check-prefix=NOSSE
; RUN: llc < %s -O2 -mtriple=x86_64-linux-gnu -mattr=-sse \
; RUN:     -enable-legalize-types-checking | FileCheck %s --check-prefix=NOSSE

define void @test_select(ptr %p, ptr %q, i1 zeroext %c) {
; SSE-LABEL: test_select:
; SSE:       # %bb.0:
; SSE-NEXT:    testl %edx, %edx
; SSE-NEXT:    jne .LBB0_1
; SSE-NEXT:  # %bb.3:
; SSE-NEXT:    movaps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE-NEXT:    movaps %xmm0, (%rsi)
; SSE-NEXT:    retq
; SSE-NEXT:  .LBB0_1:
; SSE-NEXT:    movups (%rdi), %xmm0
; SSE-NEXT:    movaps %xmm0, (%rsi)
; SSE-NEXT:    retq
;
; NOSSE-LABEL: test_select:
; NOSSE:       # %bb.0:
; NOSSE-NEXT:    xorl %eax, %eax
; NOSSE-NEXT:    testl %edx, %edx
; NOSSE-NEXT:    cmovneq (%rdi), %rax
; NOSSE-NEXT:    movabsq $9223231299366420480, %rcx # imm = 0x7FFF800000000000
; NOSSE-NEXT:    cmovneq 8(%rdi), %rcx
; NOSSE-NEXT:    movq %rcx, 8(%rsi)
; NOSSE-NEXT:    movq %rax, (%rsi)
; NOSSE-NEXT:    retq
  %a = load fp128, ptr %p, align 2
  %r = select i1 %c, fp128 %a, fp128 0xL00000000000000007FFF800000000000
  store fp128 %r, ptr %q
  ret void
}

; The uitofp will become a select_cc. This used to crash during type
; legalization because we didn't expect the operands to need to be softened.
define fp128 @test_select_cc(fp128, fp128) {
; SSE-LABEL: test_select_cc:
; SSE:       # %bb.0: # %BB0
; SSE-NEXT:    pushq %rbx
; SSE-NEXT:    .cfi_def_cfa_offset 16
; SSE-NEXT:    subq $32, %rsp
; SSE-NEXT:    .cfi_def_cfa_offset 48
; SSE-NEXT:    .cfi_offset %rbx, -16
; SSE-NEXT:    movaps %xmm1, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; SSE-NEXT:    movaps %xmm0, (%rsp) # 16-byte Spill
; SSE-NEXT:    callq __netf2@PLT
; SSE-NEXT:    movl %eax, %ebx
; SSE-NEXT:    movaps (%rsp), %xmm0 # 16-byte Reload
; SSE-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm1 # 16-byte Reload
; SSE-NEXT:    callq __eqtf2@PLT
; SSE-NEXT:    testl %eax, %eax
; SSE-NEXT:    je .LBB1_1
; SSE-NEXT:  # %bb.2: # %BB0
; SSE-NEXT:    xorps %xmm1, %xmm1
; SSE-NEXT:    jmp .LBB1_3
; SSE-NEXT:  .LBB1_1:
; SSE-NEXT:    movaps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1
; SSE-NEXT:  .LBB1_3: # %BB0
; SSE-NEXT:    testl %ebx, %ebx
; SSE-NEXT:    movaps (%rsp), %xmm0 # 16-byte Reload
; SSE-NEXT:    jne .LBB1_5
; SSE-NEXT:  # %bb.4: # %BB1
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:  .LBB1_5: # %BB2
; SSE-NEXT:    addq $32, %rsp
; SSE-NEXT:    .cfi_def_cfa_offset 16
; SSE-NEXT:    popq %rbx
; SSE-NEXT:    .cfi_def_cfa_offset 8
; SSE-NEXT:    retq
;
; NOSSE-LABEL: test_select_cc:
; NOSSE:       # %bb.0: # %BB0
; NOSSE-NEXT:    pushq %rbp
; NOSSE-NEXT:    .cfi_def_cfa_offset 16
; NOSSE-NEXT:    pushq %r15
; NOSSE-NEXT:    .cfi_def_cfa_offset 24
; NOSSE-NEXT:    pushq %r14
; NOSSE-NEXT:    .cfi_def_cfa_offset 32
; NOSSE-NEXT:    pushq %r12
; NOSSE-NEXT:    .cfi_def_cfa_offset 40
; NOSSE-NEXT:    pushq %rbx
; NOSSE-NEXT:    .cfi_def_cfa_offset 48
; NOSSE-NEXT:    .cfi_offset %rbx, -48
; NOSSE-NEXT:    .cfi_offset %r12, -40
; NOSSE-NEXT:    .cfi_offset %r14, -32
; NOSSE-NEXT:    .cfi_offset %r15, -24
; NOSSE-NEXT:    .cfi_offset %rbp, -16
; NOSSE-NEXT:    movq %rcx, %r15
; NOSSE-NEXT:    movq %rdx, %r12
; NOSSE-NEXT:    movq %rsi, %rbx
; NOSSE-NEXT:    movq %rdi, %r14
; NOSSE-NEXT:    callq __netf2@PLT
; NOSSE-NEXT:    movl %eax, %ebp
; NOSSE-NEXT:    movq %r14, %rdi
; NOSSE-NEXT:    movq %rbx, %rsi
; NOSSE-NEXT:    movq %r12, %rdx
; NOSSE-NEXT:    movq %r15, %rcx
; NOSSE-NEXT:    callq __eqtf2@PLT
; NOSSE-NEXT:    movl %eax, %ecx
; NOSSE-NEXT:    xorl %eax, %eax
; NOSSE-NEXT:    testl %ecx, %ecx
; NOSSE-NEXT:    movabsq $4611404543450677248, %rdx # imm = 0x3FFF000000000000
; NOSSE-NEXT:    cmovneq %rax, %rdx
; NOSSE-NEXT:    testl %ebp, %ebp
; NOSSE-NEXT:    je .LBB1_2
; NOSSE-NEXT:  # %bb.1:
; NOSSE-NEXT:    movq %r14, %rax
; NOSSE-NEXT:    movq %rbx, %rdx
; NOSSE-NEXT:  .LBB1_2: # %BB2
; NOSSE-NEXT:    popq %rbx
; NOSSE-NEXT:    .cfi_def_cfa_offset 40
; NOSSE-NEXT:    popq %r12
; NOSSE-NEXT:    .cfi_def_cfa_offset 32
; NOSSE-NEXT:    popq %r14
; NOSSE-NEXT:    .cfi_def_cfa_offset 24
; NOSSE-NEXT:    popq %r15
; NOSSE-NEXT:    .cfi_def_cfa_offset 16
; NOSSE-NEXT:    popq %rbp
; NOSSE-NEXT:    .cfi_def_cfa_offset 8
; NOSSE-NEXT:    retq
BB0:
  %a = fcmp oeq fp128 %0, %1
  %b = uitofp i1 %a to fp128
  br i1 %a, label %BB1, label %BB2
BB1:
  br label %BB2
BB2:
  %c = phi fp128 [ %0, %BB0 ], [ %b, %BB1 ]
  ret fp128 %c
}
