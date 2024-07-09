; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=avr -mcpu=atmega328p | FileCheck %s

define i32 @testmsws_builtin(float %x) {
; CHECK-LABEL: testmsws_builtin:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    call lrintf
; CHECK-NEXT:    ret
entry:
  %0 = tail call i32 @llvm.lrint.i32.f32(float %x)
  ret i32 %0
}

define i32 @testmswd_builtin(double %x) {
; CHECK-LABEL: testmswd_builtin:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    call lrint
; CHECK-NEXT:    ret
entry:
  %0 = tail call i32 @llvm.lrint.i32.f64(double %x)
  ret i32 %0
}

declare i32 @llvm.lrint.i32.f32(float) nounwind readnone
declare i32 @llvm.lrint.i32.f64(double) nounwind readnone
