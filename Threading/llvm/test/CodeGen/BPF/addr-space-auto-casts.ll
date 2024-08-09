; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 4
; RUN: opt --bpf-check-and-opt-ir -S -mtriple=bpf-pc-linux < %s | FileCheck %s

define void @simple_store(ptr addrspace(272) %foo) {
; CHECK-LABEL: define void @simple_store(
; CHECK-SAME: ptr addrspace(272) [[FOO:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[FOO1:%.*]] = addrspacecast ptr addrspace(272) [[FOO]] to ptr
; CHECK-NEXT:    [[ADD_PTR2:%.*]] = getelementptr inbounds i8, ptr [[FOO1]], i64 16
; CHECK-NEXT:    store volatile i32 57005, ptr [[ADD_PTR2]], align 4
; CHECK-NEXT:    [[ADD_PTR13:%.*]] = getelementptr inbounds i8, ptr [[FOO1]], i64 12
; CHECK-NEXT:    store volatile i32 48879, ptr [[ADD_PTR13]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %add.ptr = getelementptr inbounds i8, ptr addrspace(272) %foo, i64 16
  store volatile i32 57005, ptr addrspace(272) %add.ptr, align 4
  %add.ptr1 = getelementptr inbounds i8, ptr addrspace(272) %foo, i64 12
  store volatile i32 48879, ptr addrspace(272) %add.ptr1, align 4
  ret void
}

define void @separate_addr_store(ptr addrspace(272) %foo, ptr addrspace(272) %bar) {
; CHECK-LABEL: define void @separate_addr_store(
; CHECK-SAME: ptr addrspace(272) [[FOO:%.*]], ptr addrspace(272) [[BAR:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[BAR3:%.*]] = addrspacecast ptr addrspace(272) [[BAR]] to ptr
; CHECK-NEXT:    [[FOO1:%.*]] = addrspacecast ptr addrspace(272) [[FOO]] to ptr
; CHECK-NEXT:    [[ADD_PTR2:%.*]] = getelementptr inbounds i8, ptr [[FOO1]], i64 16
; CHECK-NEXT:    store volatile i32 57005, ptr [[ADD_PTR2]], align 4
; CHECK-NEXT:    [[ADD_PTR14:%.*]] = getelementptr inbounds i8, ptr [[BAR3]], i64 12
; CHECK-NEXT:    store volatile i32 48879, ptr [[ADD_PTR14]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %add.ptr = getelementptr inbounds i8, ptr addrspace(272) %foo, i64 16
  store volatile i32 57005, ptr addrspace(272) %add.ptr, align 4
  %add.ptr1 = getelementptr inbounds i8, ptr addrspace(272) %bar, i64 12
  store volatile i32 48879, ptr addrspace(272) %add.ptr1, align 4
  ret void
}

define i32 @simple_load(ptr addrspace(272) %foo) {
; CHECK-LABEL: define i32 @simple_load(
; CHECK-SAME: ptr addrspace(272) [[FOO:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[FOO1:%.*]] = addrspacecast ptr addrspace(272) [[FOO]] to ptr
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, ptr [[FOO1]], align 4
; CHECK-NEXT:    ret i32 [[TMP0]]
;
entry:
  %0 = load i32, ptr addrspace(272) %foo, align 4
  ret i32 %0
}

define { i32, i1 } @simple_cmpxchg(ptr addrspace(1) %i) {
; CHECK-LABEL: define { i32, i1 } @simple_cmpxchg(
; CHECK-SAME: ptr addrspace(1) [[I:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[I1:%.*]] = addrspacecast ptr addrspace(1) [[I]] to ptr
; CHECK-NEXT:    [[A:%.*]] = cmpxchg ptr [[I1]], i32 7, i32 42 monotonic monotonic, align 4
; CHECK-NEXT:    ret { i32, i1 } [[A]]
;
entry:
  %a = cmpxchg ptr addrspace(1) %i, i32 7, i32 42 monotonic monotonic, align 4
  ret { i32, i1 } %a
}

define void @simple_atomicrmw(ptr addrspace(1) %p) {
; CHECK-LABEL: define void @simple_atomicrmw(
; CHECK-SAME: ptr addrspace(1) [[P:%.*]]) {
; CHECK-NEXT:    [[P1:%.*]] = addrspacecast ptr addrspace(1) [[P]] to ptr
; CHECK-NEXT:    [[A:%.*]] = atomicrmw add ptr [[P1]], i64 42 monotonic, align 8
; CHECK-NEXT:    ret void
;
  %a = atomicrmw add ptr addrspace(1) %p, i64 42 monotonic, align 8
  ret void
}