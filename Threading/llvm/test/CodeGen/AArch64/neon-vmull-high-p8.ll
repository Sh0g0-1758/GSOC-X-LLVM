; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-none-linux-gnu -mattr=+neon | FileCheck %s

; Check that pmull2 instruction is used for vmull_high_p8 intrinsic
; even if shufflevector instructions are located in different basic blocks,
; which can happen when vmull_high_p8 is used inside a loop body.
;

define <8 x i16> @test_pmull2_sink(<16 x i8> %a, <16 x i8> %b, <8 x i16> %c, i1 %t) {
; CHECK-LABEL: test_pmull2_sink:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    tbz w0, #0, .LBB0_2
; CHECK-NEXT:  // %bb.1: // %if.then
; CHECK-NEXT:    pmull2 v0.8h, v0.16b, v1.16b
; CHECK-NEXT:    ret
; CHECK-NEXT:  .LBB0_2: // %cleanup
; CHECK-NEXT:    mov v0.16b, v2.16b
; CHECK-NEXT:    ret
entry:
  %0 = shufflevector <16 x i8> %a, <16 x i8> poison, <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  br i1 %t, label %if.then, label %cleanup

if.then:
  %1 = shufflevector <16 x i8> %b, <16 x i8> poison, <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %res = tail call <8 x i16> @llvm.aarch64.neon.pmull.v8i16(<8 x i8> %0, <8 x i8> %1)
  br label %cleanup

cleanup:
  %retval = phi <8 x i16> [ %res, %if.then ], [ %c, %entry ]
  ret <8 x i16> %retval
}

define <8 x i16> @test_pmull2_sink2(<16 x i8> %a, <16 x i8> %b, <8 x i16> %c, i1 %t) {
; CHECK-LABEL: test_pmull2_sink2:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    tbz w0, #0, .LBB1_2
; CHECK-NEXT:  // %bb.1: // %if.then
; CHECK-NEXT:    pmull2 v0.8h, v0.16b, v0.16b
; CHECK-NEXT:    ret
; CHECK-NEXT:  .LBB1_2: // %cleanup
; CHECK-NEXT:    mov v0.16b, v2.16b
; CHECK-NEXT:    ret
entry:
  %0 = shufflevector <16 x i8> %a, <16 x i8> poison, <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %1 = shufflevector <16 x i8> %a, <16 x i8> poison, <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  br i1 %t, label %if.then, label %cleanup

if.then:
  %res = tail call <8 x i16> @llvm.aarch64.neon.pmull.v8i16(<8 x i8> %0, <8 x i8> %1)
  br label %cleanup

cleanup:
  %retval = phi <8 x i16> [ %res, %if.then ], [ %c, %entry ]
  ret <8 x i16> %retval
}

define <8 x i16> @test_pmull2_sink3(<16 x i8> %a, <16 x i8> %b, <8 x i16> %c, i1 %t, i1 %t2) {
; CHECK-LABEL: test_pmull2_sink3:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    tbz w0, #0, .LBB2_2
; CHECK-NEXT:  // %bb.1: // %if.then
; CHECK-NEXT:    tbz w1, #0, .LBB2_3
; CHECK-NEXT:  .LBB2_2: // %if.then.2
; CHECK-NEXT:    pmull2 v0.8h, v0.16b, v1.16b
; CHECK-NEXT:    ret
; CHECK-NEXT:  .LBB2_3: // %cleanup
; CHECK-NEXT:    pmull2 v0.8h, v0.16b, v0.16b
; CHECK-NEXT:    ret
entry:
  %0 = shufflevector <16 x i8> %a, <16 x i8> poison, <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  br i1 %t, label %if.then, label %if.then.2

if.then:
  %res = tail call <8 x i16> @llvm.aarch64.neon.pmull.v8i16(<8 x i8> %0, <8 x i8> %0)
  br i1 %t2, label %if.then.2, label %cleanup

if.then.2:
  %1 = shufflevector <16 x i8> %b, <16 x i8> poison, <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %res2 = tail call <8 x i16> @llvm.aarch64.neon.pmull.v8i16(<8 x i8> %0, <8 x i8> %1)
  br label %cleanup

cleanup:
  %retval = phi <8 x i16> [ %res2, %if.then.2 ], [ %res, %if.then ]
  ret <8 x i16> %retval
}

declare <8 x i16> @llvm.aarch64.neon.pmull.v8i16(<8 x i8>, <8 x i8>)
