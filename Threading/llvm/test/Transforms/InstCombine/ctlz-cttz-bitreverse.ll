; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=instcombine -S < %s | FileCheck %s

define i32 @ctlz_true_bitreverse(i32 %x) {
; CHECK-LABEL: @ctlz_true_bitreverse(
; CHECK-NEXT:    [[B:%.*]] = call i32 @llvm.cttz.i32(i32 [[X:%.*]], i1 true), !range [[RNG0:![0-9]+]]
; CHECK-NEXT:    ret i32 [[B]]
;
  %a = tail call i32 @llvm.bitreverse.i32(i32 %x)
  %b = tail call i32 @llvm.ctlz.i32(i32 %a, i1 true)
  ret i32 %b
}

define <2 x i64> @ctlz_true_bitreverse_vec(<2 x i64> %x) {
; CHECK-LABEL: @ctlz_true_bitreverse_vec(
; CHECK-NEXT:    [[B:%.*]] = call <2 x i64> @llvm.cttz.v2i64(<2 x i64> [[X:%.*]], i1 true), !range [[RNG1:![0-9]+]]
; CHECK-NEXT:    ret <2 x i64> [[B]]
;
  %a = tail call <2 x i64> @llvm.bitreverse.v2i64(<2 x i64> %x)
  %b = tail call <2 x i64> @llvm.ctlz.v2i64(<2 x i64> %a, i1 true)
  ret <2 x i64> %b
}

define i32 @ctlz_false_bitreverse(i32 %x) {
; CHECK-LABEL: @ctlz_false_bitreverse(
; CHECK-NEXT:    [[B:%.*]] = call i32 @llvm.cttz.i32(i32 [[X:%.*]], i1 false), !range [[RNG0]]
; CHECK-NEXT:    ret i32 [[B]]
;
  %a = tail call i32 @llvm.bitreverse.i32(i32 %x)
  %b = tail call i32 @llvm.ctlz.i32(i32 %a, i1 false)
  ret i32 %b
}

define i32 @cttz_true_bitreverse(i32 %x) {
; CHECK-LABEL: @cttz_true_bitreverse(
; CHECK-NEXT:    [[B:%.*]] = call i32 @llvm.ctlz.i32(i32 [[X:%.*]], i1 true), !range [[RNG0]]
; CHECK-NEXT:    ret i32 [[B]]
;
  %a = tail call i32 @llvm.bitreverse.i32(i32 %x)
  %b = tail call i32 @llvm.cttz.i32(i32 %a, i1 true)
  ret i32 %b
}

define <2 x i64> @cttz_true_bitreverse_vec(<2 x i64> %x) {
; CHECK-LABEL: @cttz_true_bitreverse_vec(
; CHECK-NEXT:    [[B:%.*]] = call <2 x i64> @llvm.ctlz.v2i64(<2 x i64> [[X:%.*]], i1 true), !range [[RNG1]]
; CHECK-NEXT:    ret <2 x i64> [[B]]
;
  %a = tail call <2 x i64> @llvm.bitreverse.v2i64(<2 x i64> %x)
  %b = tail call <2 x i64> @llvm.cttz.v2i64(<2 x i64> %a, i1 true)
  ret <2 x i64> %b
}

define i32 @cttz_false_bitreverse(i32 %x) {
; CHECK-LABEL: @cttz_false_bitreverse(
; CHECK-NEXT:    [[B:%.*]] = call i32 @llvm.ctlz.i32(i32 [[X:%.*]], i1 false), !range [[RNG0]]
; CHECK-NEXT:    ret i32 [[B]]
;
  %a = tail call i32 @llvm.bitreverse.i32(i32 %x)
  %b = tail call i32 @llvm.cttz.i32(i32 %a, i1 false)
  ret i32 %b
}

declare i32 @llvm.bitreverse.i32(i32)
declare <2 x i64> @llvm.bitreverse.v2i64(<2 x i64>)
declare i32 @llvm.ctlz.i32(i32, i1)
declare i32 @llvm.cttz.i32(i32, i1)
declare <2 x i64> @llvm.ctlz.v2i64(<2 x i64>, i1)
declare <2 x i64> @llvm.cttz.v2i64(<2 x i64>, i1)
