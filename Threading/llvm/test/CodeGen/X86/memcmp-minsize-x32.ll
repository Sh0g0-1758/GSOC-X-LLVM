; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=cmov | FileCheck %s --check-prefix=X86 --check-prefix=X86-NOSSE
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefix=X86 --check-prefix=X86-SSE2

; This tests codegen time inlining/optimization of memcmp
; rdar://6480398

@.str = private constant [65 x i8] c"0123456789012345678901234567890123456789012345678901234567890123\00", align 1

declare dso_local i32 @memcmp(ptr, ptr, i32)

define i32 @length2(ptr %X, ptr %Y) nounwind minsize {
; X86-LABEL: length2:
; X86:       # %bb.0:
; X86-NEXT:    pushl $2
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $12, %esp
; X86-NEXT:    retl
  %m = tail call i32 @memcmp(ptr %X, ptr %Y, i32 2) nounwind
  ret i32 %m
}

define i1 @length2_eq(ptr %X, ptr %Y) nounwind minsize {
; X86-LABEL: length2_eq:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movzwl (%ecx), %ecx
; X86-NEXT:    cmpw (%eax), %cx
; X86-NEXT:    sete %al
; X86-NEXT:    retl
  %m = tail call i32 @memcmp(ptr %X, ptr %Y, i32 2) nounwind
  %c = icmp eq i32 %m, 0
  ret i1 %c
}

define i1 @length2_eq_const(ptr %X) nounwind minsize {
; X86-LABEL: length2_eq_const:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    cmpw $12849, (%eax) # imm = 0x3231
; X86-NEXT:    setne %al
; X86-NEXT:    retl
  %m = tail call i32 @memcmp(ptr %X, ptr getelementptr inbounds ([65 x i8], ptr @.str, i32 0, i32 1), i32 2) nounwind
  %c = icmp ne i32 %m, 0
  ret i1 %c
}

define i1 @length2_eq_nobuiltin_attr(ptr %X, ptr %Y) nounwind minsize {
; X86-LABEL: length2_eq_nobuiltin_attr:
; X86:       # %bb.0:
; X86-NEXT:    pushl $2
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $12, %esp
; X86-NEXT:    testl %eax, %eax
; X86-NEXT:    sete %al
; X86-NEXT:    retl
  %m = tail call i32 @memcmp(ptr %X, ptr %Y, i32 2) nounwind nobuiltin
  %c = icmp eq i32 %m, 0
  ret i1 %c
}

define i32 @length3(ptr %X, ptr %Y) nounwind minsize {
; X86-LABEL: length3:
; X86:       # %bb.0:
; X86-NEXT:    pushl $3
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $12, %esp
; X86-NEXT:    retl
  %m = tail call i32 @memcmp(ptr %X, ptr %Y, i32 3) nounwind
  ret i32 %m
}

define i1 @length3_eq(ptr %X, ptr %Y) nounwind minsize {
; X86-LABEL: length3_eq:
; X86:       # %bb.0:
; X86-NEXT:    pushl $3
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $12, %esp
; X86-NEXT:    testl %eax, %eax
; X86-NEXT:    setne %al
; X86-NEXT:    retl
  %m = tail call i32 @memcmp(ptr %X, ptr %Y, i32 3) nounwind
  %c = icmp ne i32 %m, 0
  ret i1 %c
}

define i32 @length4(ptr %X, ptr %Y) nounwind minsize {
; X86-LABEL: length4:
; X86:       # %bb.0:
; X86-NEXT:    pushl $4
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $12, %esp
; X86-NEXT:    retl
  %m = tail call i32 @memcmp(ptr %X, ptr %Y, i32 4) nounwind
  ret i32 %m
}

define i1 @length4_eq(ptr %X, ptr %Y) nounwind minsize {
; X86-LABEL: length4_eq:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl (%ecx), %ecx
; X86-NEXT:    cmpl (%eax), %ecx
; X86-NEXT:    setne %al
; X86-NEXT:    retl
  %m = tail call i32 @memcmp(ptr %X, ptr %Y, i32 4) nounwind
  %c = icmp ne i32 %m, 0
  ret i1 %c
}

define i1 @length4_eq_const(ptr %X) nounwind minsize {
; X86-LABEL: length4_eq_const:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    cmpl $875770417, (%eax) # imm = 0x34333231
; X86-NEXT:    sete %al
; X86-NEXT:    retl
  %m = tail call i32 @memcmp(ptr %X, ptr getelementptr inbounds ([65 x i8], ptr @.str, i32 0, i32 1), i32 4) nounwind
  %c = icmp eq i32 %m, 0
  ret i1 %c
}

define i32 @length5(ptr %X, ptr %Y) nounwind minsize {
; X86-LABEL: length5:
; X86:       # %bb.0:
; X86-NEXT:    pushl $5
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $12, %esp
; X86-NEXT:    retl
  %m = tail call i32 @memcmp(ptr %X, ptr %Y, i32 5) nounwind
  ret i32 %m
}

define i1 @length5_eq(ptr %X, ptr %Y) nounwind minsize {
; X86-LABEL: length5_eq:
; X86:       # %bb.0:
; X86-NEXT:    pushl $5
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $12, %esp
; X86-NEXT:    testl %eax, %eax
; X86-NEXT:    setne %al
; X86-NEXT:    retl
  %m = tail call i32 @memcmp(ptr %X, ptr %Y, i32 5) nounwind
  %c = icmp ne i32 %m, 0
  ret i1 %c
}

define i32 @length8(ptr %X, ptr %Y) nounwind minsize {
; X86-LABEL: length8:
; X86:       # %bb.0:
; X86-NEXT:    pushl $8
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $12, %esp
; X86-NEXT:    retl
  %m = tail call i32 @memcmp(ptr %X, ptr %Y, i32 8) nounwind
  ret i32 %m
}

define i1 @length8_eq(ptr %X, ptr %Y) nounwind minsize {
; X86-LABEL: length8_eq:
; X86:       # %bb.0:
; X86-NEXT:    pushl $8
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $12, %esp
; X86-NEXT:    testl %eax, %eax
; X86-NEXT:    sete %al
; X86-NEXT:    retl
  %m = tail call i32 @memcmp(ptr %X, ptr %Y, i32 8) nounwind
  %c = icmp eq i32 %m, 0
  ret i1 %c
}

define i1 @length8_eq_const(ptr %X) nounwind minsize {
; X86-LABEL: length8_eq_const:
; X86:       # %bb.0:
; X86-NEXT:    pushl $8
; X86-NEXT:    pushl $.L.str
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $12, %esp
; X86-NEXT:    testl %eax, %eax
; X86-NEXT:    setne %al
; X86-NEXT:    retl
  %m = tail call i32 @memcmp(ptr %X, ptr @.str, i32 8) nounwind
  %c = icmp ne i32 %m, 0
  ret i1 %c
}

define i1 @length12_eq(ptr %X, ptr %Y) nounwind minsize {
; X86-LABEL: length12_eq:
; X86:       # %bb.0:
; X86-NEXT:    pushl $12
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $12, %esp
; X86-NEXT:    testl %eax, %eax
; X86-NEXT:    setne %al
; X86-NEXT:    retl
  %m = tail call i32 @memcmp(ptr %X, ptr %Y, i32 12) nounwind
  %c = icmp ne i32 %m, 0
  ret i1 %c
}

define i32 @length12(ptr %X, ptr %Y) nounwind minsize {
; X86-LABEL: length12:
; X86:       # %bb.0:
; X86-NEXT:    pushl $12
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $12, %esp
; X86-NEXT:    retl
  %m = tail call i32 @memcmp(ptr %X, ptr %Y, i32 12) nounwind
  ret i32 %m
}

; PR33329 - https://bugs.llvm.org/show_bug.cgi?id=33329

define i32 @length16(ptr %X, ptr %Y) nounwind minsize {
; X86-LABEL: length16:
; X86:       # %bb.0:
; X86-NEXT:    pushl $16
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $12, %esp
; X86-NEXT:    retl
  %m = tail call i32 @memcmp(ptr %X, ptr %Y, i32 16) nounwind
  ret i32 %m
}

define i1 @length16_eq(ptr %x, ptr %y) nounwind minsize {
; X86-NOSSE-LABEL: length16_eq:
; X86-NOSSE:       # %bb.0:
; X86-NOSSE-NEXT:    pushl $16
; X86-NOSSE-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NOSSE-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NOSSE-NEXT:    calll memcmp
; X86-NOSSE-NEXT:    addl $12, %esp
; X86-NOSSE-NEXT:    testl %eax, %eax
; X86-NOSSE-NEXT:    setne %al
; X86-NOSSE-NEXT:    retl
;
; X86-SSE2-LABEL: length16_eq:
; X86-SSE2:       # %bb.0:
; X86-SSE2-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SSE2-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-SSE2-NEXT:    movdqu (%ecx), %xmm0
; X86-SSE2-NEXT:    movdqu (%eax), %xmm1
; X86-SSE2-NEXT:    pcmpeqb %xmm0, %xmm1
; X86-SSE2-NEXT:    pmovmskb %xmm1, %eax
; X86-SSE2-NEXT:    cmpl $65535, %eax # imm = 0xFFFF
; X86-SSE2-NEXT:    setne %al
; X86-SSE2-NEXT:    retl
  %call = tail call i32 @memcmp(ptr %x, ptr %y, i32 16) nounwind
  %cmp = icmp ne i32 %call, 0
  ret i1 %cmp
}

define i1 @length16_eq_const(ptr %X) nounwind minsize {
; X86-NOSSE-LABEL: length16_eq_const:
; X86-NOSSE:       # %bb.0:
; X86-NOSSE-NEXT:    pushl $16
; X86-NOSSE-NEXT:    pushl $.L.str
; X86-NOSSE-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NOSSE-NEXT:    calll memcmp
; X86-NOSSE-NEXT:    addl $12, %esp
; X86-NOSSE-NEXT:    testl %eax, %eax
; X86-NOSSE-NEXT:    sete %al
; X86-NOSSE-NEXT:    retl
;
; X86-SSE2-LABEL: length16_eq_const:
; X86-SSE2:       # %bb.0:
; X86-SSE2-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SSE2-NEXT:    movdqu (%eax), %xmm0
; X86-SSE2-NEXT:    pcmpeqb {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0
; X86-SSE2-NEXT:    pmovmskb %xmm0, %eax
; X86-SSE2-NEXT:    cmpl $65535, %eax # imm = 0xFFFF
; X86-SSE2-NEXT:    sete %al
; X86-SSE2-NEXT:    retl
  %m = tail call i32 @memcmp(ptr %X, ptr @.str, i32 16) nounwind
  %c = icmp eq i32 %m, 0
  ret i1 %c
}

; PR33914 - https://bugs.llvm.org/show_bug.cgi?id=33914

define i32 @length24(ptr %X, ptr %Y) nounwind minsize {
; X86-LABEL: length24:
; X86:       # %bb.0:
; X86-NEXT:    pushl $24
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $12, %esp
; X86-NEXT:    retl
  %m = tail call i32 @memcmp(ptr %X, ptr %Y, i32 24) nounwind
  ret i32 %m
}

define i1 @length24_eq(ptr %x, ptr %y) nounwind minsize {
; X86-LABEL: length24_eq:
; X86:       # %bb.0:
; X86-NEXT:    pushl $24
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $12, %esp
; X86-NEXT:    testl %eax, %eax
; X86-NEXT:    sete %al
; X86-NEXT:    retl
  %call = tail call i32 @memcmp(ptr %x, ptr %y, i32 24) nounwind
  %cmp = icmp eq i32 %call, 0
  ret i1 %cmp
}

define i1 @length24_eq_const(ptr %X) nounwind minsize {
; X86-LABEL: length24_eq_const:
; X86:       # %bb.0:
; X86-NEXT:    pushl $24
; X86-NEXT:    pushl $.L.str
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $12, %esp
; X86-NEXT:    testl %eax, %eax
; X86-NEXT:    setne %al
; X86-NEXT:    retl
  %m = tail call i32 @memcmp(ptr %X, ptr @.str, i32 24) nounwind
  %c = icmp ne i32 %m, 0
  ret i1 %c
}

define i32 @length32(ptr %X, ptr %Y) nounwind minsize {
; X86-LABEL: length32:
; X86:       # %bb.0:
; X86-NEXT:    pushl $32
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $12, %esp
; X86-NEXT:    retl
  %m = tail call i32 @memcmp(ptr %X, ptr %Y, i32 32) nounwind
  ret i32 %m
}

; PR33325 - https://bugs.llvm.org/show_bug.cgi?id=33325

define i1 @length32_eq(ptr %x, ptr %y) nounwind minsize {
; X86-LABEL: length32_eq:
; X86:       # %bb.0:
; X86-NEXT:    pushl $32
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $12, %esp
; X86-NEXT:    testl %eax, %eax
; X86-NEXT:    sete %al
; X86-NEXT:    retl
  %call = tail call i32 @memcmp(ptr %x, ptr %y, i32 32) nounwind
  %cmp = icmp eq i32 %call, 0
  ret i1 %cmp
}

define i1 @length32_eq_const(ptr %X) nounwind minsize {
; X86-LABEL: length32_eq_const:
; X86:       # %bb.0:
; X86-NEXT:    pushl $32
; X86-NEXT:    pushl $.L.str
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $12, %esp
; X86-NEXT:    testl %eax, %eax
; X86-NEXT:    setne %al
; X86-NEXT:    retl
  %m = tail call i32 @memcmp(ptr %X, ptr @.str, i32 32) nounwind
  %c = icmp ne i32 %m, 0
  ret i1 %c
}

define i32 @length64(ptr %X, ptr %Y) nounwind minsize {
; X86-LABEL: length64:
; X86:       # %bb.0:
; X86-NEXT:    pushl $64
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $12, %esp
; X86-NEXT:    retl
  %m = tail call i32 @memcmp(ptr %X, ptr %Y, i32 64) nounwind
  ret i32 %m
}

define i1 @length64_eq(ptr %x, ptr %y) nounwind minsize {
; X86-LABEL: length64_eq:
; X86:       # %bb.0:
; X86-NEXT:    pushl $64
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $12, %esp
; X86-NEXT:    testl %eax, %eax
; X86-NEXT:    setne %al
; X86-NEXT:    retl
  %call = tail call i32 @memcmp(ptr %x, ptr %y, i32 64) nounwind
  %cmp = icmp ne i32 %call, 0
  ret i1 %cmp
}

define i1 @length64_eq_const(ptr %X) nounwind minsize {
; X86-LABEL: length64_eq_const:
; X86:       # %bb.0:
; X86-NEXT:    pushl $64
; X86-NEXT:    pushl $.L.str
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $12, %esp
; X86-NEXT:    testl %eax, %eax
; X86-NEXT:    sete %al
; X86-NEXT:    retl
  %m = tail call i32 @memcmp(ptr %X, ptr @.str, i32 64) nounwind
  %c = icmp eq i32 %m, 0
  ret i1 %c
}

