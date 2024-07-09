; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -simplify-mir -verify-machineinstrs < %s | FileCheck %s

target datalayout = "e-m:e-i64:64-n32:64"
target triple = "powerpc64le-grtev4-linux-gnu"

define void @foo(ptr %p1, i64 %v1, i8 %v2, i64 %v3) {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li 7, 0
; CHECK-NEXT:    std 7, 0(3)
; CHECK-NEXT:    mr 7, 5
; CHECK-NEXT:    rldimi. 7, 4, 8, 0
; CHECK-NEXT:    crnot 20, 2
; CHECK-NEXT:    andi. 5, 5, 1
; CHECK-NEXT:    bc 4, 1, .LBB0_2
; CHECK-NEXT:  # %bb.1: # %bb1
; CHECK-NEXT:    std 4, 0(3)
; CHECK-NEXT:  .LBB0_2: # %bb2
; CHECK-NEXT:    bclr 12, 20, 0
; CHECK-NEXT:  # %bb.3: # %bb3
; CHECK-NEXT:    std 6, 0(3)
; CHECK-NEXT:    blr
  store i64 0, ptr %p1, align 8
  %ext = zext i8 %v2 to i64
  %shift = shl nuw i64 %v1, 8
  %merge = or i64 %shift, %ext
  %not0 = icmp ne i64 %merge, 0
  %bit0 = and i64 %ext, 1                 ; and & icmp instructions can be combined
  %cond1 = icmp eq i64 %bit0, 0           ; to and. and generates condition code to
  br i1 %cond1, label %bb2, label %bb1    ; be used by this conditional branch

bb1:
  store i64 %v1, ptr %p1, align 8
  br label %bb2

bb2:
  br i1 %not0, label %exit, label %bb3

bb3:
  store i64 %v3, ptr %p1, align 8
  br label %exit

exit:
  ret void
}
