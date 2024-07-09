; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i386-unknown-unknown   | FileCheck %s --check-prefixes=X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s --check-prefixes=X64
; RUN: llc < %s -mtriple=x86_64-unknown-gnux32 | FileCheck %s --check-prefixes=X64

define i32 @shift30_and2_i32(i32 %x) {
; X86-LABEL: shift30_and2_i32:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    shrl $30, %eax
; X86-NEXT:    andl $-2, %eax
; X86-NEXT:    retl
;
; X64-LABEL: shift30_and2_i32:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shrl $30, %eax
; X64-NEXT:    andl $-2, %eax
; X64-NEXT:    retq
  %shr = lshr i32 %x, 30
  %and = and i32 %shr, 2
  ret i32 %and
}

define i64 @shift62_and2_i64(i64 %x) {
; X86-LABEL: shift62_and2_i64:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    shrl $30, %eax
; X86-NEXT:    andl $-2, %eax
; X86-NEXT:    xorl %edx, %edx
; X86-NEXT:    retl
;
; X64-LABEL: shift62_and2_i64:
; X64:       # %bb.0:
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    shrq $62, %rax
; X64-NEXT:    andl $-2, %eax
; X64-NEXT:    retq
  %shr = lshr i64 %x, 62
  %and = and i64 %shr, 2
  ret i64 %and
}

define i64 @shift30_and2_i64(i64 %x) {
; X86-LABEL: shift30_and2_i64:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    shrl $30, %eax
; X86-NEXT:    andl $-2, %eax
; X86-NEXT:    xorl %edx, %edx
; X86-NEXT:    retl
;
; X64-LABEL: shift30_and2_i64:
; X64:       # %bb.0:
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    shrl $30, %eax
; X64-NEXT:    andl $-2, %eax
; X64-NEXT:    retq
  %shr = lshr i64 %x, 30
  %and = and i64 %shr, 2
  ret i64 %and
}
