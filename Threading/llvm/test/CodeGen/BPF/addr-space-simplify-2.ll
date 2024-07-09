; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 4
; RUN: opt -passes=bpf-aspace-simplify -mtriple=bpf-pc-linux -S < %s | FileCheck %s

; Check that bpf-aspace-simplify pass does not change
; chain 'cast M->N -> GEP -> cast N->K'.

define dso_local ptr addrspace(2) @test (ptr addrspace(1) %p) {
; CHECK-LABEL: define dso_local ptr addrspace(2) @test(
; CHECK-SAME: ptr addrspace(1) [[P:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = addrspacecast ptr addrspace(1) [[P]] to ptr
; CHECK-NEXT:    [[B:%.*]] = getelementptr inbounds i8, ptr [[A]], i64 8
; CHECK-NEXT:    [[C:%.*]] = addrspacecast ptr [[B]] to ptr addrspace(2)
; CHECK-NEXT:    ret ptr addrspace(2) [[C]]
;
  entry:
  %a = addrspacecast ptr addrspace(1) %p to ptr
  %b = getelementptr inbounds i8, ptr %a, i64 8
  %c = addrspacecast ptr %b to ptr addrspace(2)
  ret ptr addrspace(2) %c
}
