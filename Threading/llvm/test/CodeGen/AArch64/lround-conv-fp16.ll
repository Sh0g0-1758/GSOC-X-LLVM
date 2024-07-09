; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 2
; RUN: llc < %s -mtriple=aarch64 | FileCheck %s --check-prefixes=CHECK-NOFP16
; RUN: llc < %s -mtriple=aarch64 -mattr=+fullfp16 | FileCheck %s --check-prefixes=CHECK-FP16

define i16 @testmhhs(half %x) {
; CHECK-NOFP16-LABEL: testmhhs:
; CHECK-NOFP16:       // %bb.0: // %entry
; CHECK-NOFP16-NEXT:    fcvt s0, h0
; CHECK-NOFP16-NEXT:    fcvtas x0, s0
; CHECK-NOFP16-NEXT:    // kill: def $w0 killed $w0 killed $x0
; CHECK-NOFP16-NEXT:    ret
;
; CHECK-FP16-LABEL: testmhhs:
; CHECK-FP16:       // %bb.0: // %entry
; CHECK-FP16-NEXT:    fcvtas x0, h0
; CHECK-FP16-NEXT:    // kill: def $w0 killed $w0 killed $x0
; CHECK-FP16-NEXT:    ret
entry:
  %0 = tail call i64 @llvm.lround.i64.f16(half %x)
  %conv = trunc i64 %0 to i16
  ret i16 %conv
}

define i32 @testmhws(half %x) {
; CHECK-NOFP16-LABEL: testmhws:
; CHECK-NOFP16:       // %bb.0: // %entry
; CHECK-NOFP16-NEXT:    fcvt s0, h0
; CHECK-NOFP16-NEXT:    fcvtas x0, s0
; CHECK-NOFP16-NEXT:    // kill: def $w0 killed $w0 killed $x0
; CHECK-NOFP16-NEXT:    ret
;
; CHECK-FP16-LABEL: testmhws:
; CHECK-FP16:       // %bb.0: // %entry
; CHECK-FP16-NEXT:    fcvtas x0, h0
; CHECK-FP16-NEXT:    // kill: def $w0 killed $w0 killed $x0
; CHECK-FP16-NEXT:    ret
entry:
  %0 = tail call i64 @llvm.lround.i64.f16(half %x)
  %conv = trunc i64 %0 to i32
  ret i32 %conv
}

define i64 @testmhxs(half %x) {
; CHECK-NOFP16-LABEL: testmhxs:
; CHECK-NOFP16:       // %bb.0: // %entry
; CHECK-NOFP16-NEXT:    fcvt s0, h0
; CHECK-NOFP16-NEXT:    fcvtas x0, s0
; CHECK-NOFP16-NEXT:    ret
;
; CHECK-FP16-LABEL: testmhxs:
; CHECK-FP16:       // %bb.0: // %entry
; CHECK-FP16-NEXT:    fcvtas x0, h0
; CHECK-FP16-NEXT:    ret
entry:
  %0 = tail call i64 @llvm.lround.i64.f16(half %x)
  ret i64 %0
}

declare i64 @llvm.lround.i64.f16(half) nounwind readnone
