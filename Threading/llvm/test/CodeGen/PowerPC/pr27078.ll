; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-linux-gnu -mcpu=pwr8 -mattr=+vsx < %s | FileCheck %s

define <4 x float> @bar(ptr %p, ptr %q) {
; CHECK-LABEL: bar:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li 5, 16
; CHECK-NEXT:    lxvw4x 1, 0, 3
; CHECK-NEXT:    lxvw4x 3, 0, 4
; CHECK-NEXT:    xvsubsp 35, 3, 1
; CHECK-NEXT:    lxvw4x 0, 3, 5
; CHECK-NEXT:    lxvw4x 2, 4, 5
; CHECK-NEXT:    addis 5, 2, .LCPI0_0@toc@ha
; CHECK-NEXT:    addi 5, 5, .LCPI0_0@toc@l
; CHECK-NEXT:    lxvw4x 36, 0, 5
; CHECK-NEXT:    li 5, 32
; CHECK-NEXT:    xvsubsp 34, 2, 0
; CHECK-NEXT:    lxvw4x 0, 3, 5
; CHECK-NEXT:    lxvw4x 1, 4, 5
; CHECK-NEXT:    addis 3, 2, .LCPI0_1@toc@ha
; CHECK-NEXT:    addi 3, 3, .LCPI0_1@toc@l
; CHECK-NEXT:    vperm 2, 3, 2, 4
; CHECK-NEXT:    xvsubsp 35, 1, 0
; CHECK-NEXT:    lxvw4x 36, 0, 3
; CHECK-NEXT:    vperm 2, 2, 3, 4
; CHECK-NEXT:    blr
  %1 = load <12 x float>, ptr %p, align 16
  %2 = load <12 x float>, ptr %q, align 16
  %3 = fsub <12 x float> %2, %1
  %4 = shufflevector <12 x float> %3, <12 x float> undef, <4 x i32> <i32 0, i32 3, i32 6, i32 9>
  ret <4 x float>  %4
}
