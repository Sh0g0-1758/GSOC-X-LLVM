; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-apple-macosx10.7.0 -verify-machineinstrs | FileCheck %s
; RUN: llc < %s -mtriple=x86_64-apple-macosx10.7.0 -verify-machineinstrs -O0 | FileCheck %s

define void @test1(ptr %ptr, i32 %val1) {
; CHECK-LABEL: test1:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    xchgl %esi, (%rdi)
; CHECK-NEXT:    retq
  store atomic i32 %val1, ptr %ptr seq_cst, align 4
  ret void
}

define void @test2(ptr %ptr, i32 %val1) {
; CHECK-LABEL: test2:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    movl %esi, (%rdi)
; CHECK-NEXT:    retq
  store atomic i32 %val1, ptr %ptr release, align 4
  ret void
}

define i32 @test3(ptr %ptr) {
; CHECK-LABEL: test3:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    movl (%rdi), %eax
; CHECK-NEXT:    retq
  %val = load atomic i32, ptr %ptr seq_cst, align 4
  ret i32 %val
}
