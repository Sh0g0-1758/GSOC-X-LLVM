; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 4
; RUN: opt -passes=instcombine -S < %s | FileCheck %s

declare i32 @llvm.ctlz.i32(i32, i1)
declare i32 @llvm.cttz.i32(i32, i1)
declare <2 x i32> @llvm.ctlz.v2i32(<2 x i32>, i1)
declare <2 x i32> @llvm.cttz.v2i32(<2 x i32>, i1)

define i32 @lshr_ctlz_true(i32) {
; CHECK-LABEL: define i32 @lshr_ctlz_true(
; CHECK-SAME: i32 [[TMP0:%.*]]) {
; CHECK-NEXT:    [[CTLZ:%.*]] = add i32 [[TMP0]], 9
; CHECK-NEXT:    ret i32 [[CTLZ]]
;
  %lshr = lshr i32 8387584, %0
  %ctlz = call i32 @llvm.ctlz.i32(i32 %lshr, i1 true)
  ret i32 %ctlz
}

define i32 @shl_nuw_ctlz_true(i32) {
; CHECK-LABEL: define i32 @shl_nuw_ctlz_true(
; CHECK-SAME: i32 [[TMP0:%.*]]) {
; CHECK-NEXT:    [[CTLZ:%.*]] = sub i32 9, [[TMP0]]
; CHECK-NEXT:    ret i32 [[CTLZ]]
;
  %shl = shl nuw i32 8387584, %0
  %ctlz = call i32 @llvm.ctlz.i32(i32 %shl, i1 true)
  ret i32 %ctlz
}

define i32 @shl_nuw_nsw_ctlz_true(i32) {
; CHECK-LABEL: define i32 @shl_nuw_nsw_ctlz_true(
; CHECK-SAME: i32 [[TMP0:%.*]]) {
; CHECK-NEXT:    [[CTLZ:%.*]] = sub i32 9, [[TMP0]]
; CHECK-NEXT:    ret i32 [[CTLZ]]
;
  %shl = shl nuw nsw i32 8387584, %0
  %ctlz = call i32 @llvm.ctlz.i32(i32 %shl, i1 true)
  ret i32 %ctlz
}

define i32 @lshr_exact_cttz_true(i32) {
; CHECK-LABEL: define i32 @lshr_exact_cttz_true(
; CHECK-SAME: i32 [[TMP0:%.*]]) {
; CHECK-NEXT:    [[CTTZ:%.*]] = sub i32 10, [[TMP0]]
; CHECK-NEXT:    ret i32 [[CTTZ]]
;
  %lshr = lshr exact i32 8387584, %0
  %cttz = call i32 @llvm.cttz.i32(i32 %lshr, i1 true)
  ret i32 %cttz
}

define i32 @shl_cttz_true(i32) {
; CHECK-LABEL: define i32 @shl_cttz_true(
; CHECK-SAME: i32 [[TMP0:%.*]]) {
; CHECK-NEXT:    [[CTTZ:%.*]] = add i32 [[TMP0]], 10
; CHECK-NEXT:    ret i32 [[CTTZ]]
;
  %shl = shl i32 8387584, %0
  %cttz = call i32 @llvm.cttz.i32(i32 %shl, i1 true)
  ret i32 %cttz
}

define <2 x i32> @vec2_lshr_ctlz_true(<2 x i32>) {
; CHECK-LABEL: define <2 x i32> @vec2_lshr_ctlz_true(
; CHECK-SAME: <2 x i32> [[TMP0:%.*]]) {
; CHECK-NEXT:    [[CTLZ:%.*]] = add <2 x i32> [[TMP0]], <i32 9, i32 9>
; CHECK-NEXT:    ret <2 x i32> [[CTLZ]]
;
  %div = lshr <2 x i32> <i32 8387584, i32 4276440>, %0
  %ctlz = call <2 x i32> @llvm.ctlz.v2i32(<2 x i32> %div, i1 true)
  ret <2 x i32> %ctlz
}

define <2 x i32> @vec2_shl_nuw_ctlz_true(<2 x i32>) {
; CHECK-LABEL: define <2 x i32> @vec2_shl_nuw_ctlz_true(
; CHECK-SAME: <2 x i32> [[TMP0:%.*]]) {
; CHECK-NEXT:    [[CTLZ:%.*]] = sub <2 x i32> <i32 9, i32 9>, [[TMP0]]
; CHECK-NEXT:    ret <2 x i32> [[CTLZ]]
;
  %shl = shl nuw <2 x i32> <i32 8387584, i32 4276440>, %0
  %ctlz = call <2 x i32> @llvm.ctlz.v2i32(<2 x i32> %shl, i1 true)
  ret <2 x i32> %ctlz
}

define <2 x i32> @vec2_shl_nuw_nsw_ctlz_true(<2 x i32>) {
; CHECK-LABEL: define <2 x i32> @vec2_shl_nuw_nsw_ctlz_true(
; CHECK-SAME: <2 x i32> [[TMP0:%.*]]) {
; CHECK-NEXT:    [[CTLZ:%.*]] = sub <2 x i32> <i32 9, i32 9>, [[TMP0]]
; CHECK-NEXT:    ret <2 x i32> [[CTLZ]]
;
  %shl = shl nuw nsw <2 x i32> <i32 8387584, i32 4276440>, %0
  %ctlz = call <2 x i32> @llvm.ctlz.v2i32(<2 x i32> %shl, i1 true)
  ret <2 x i32> %ctlz
}

define <2 x i32> @vec2_lshr_exact_cttz_true(<2 x i32>) {
; CHECK-LABEL: define <2 x i32> @vec2_lshr_exact_cttz_true(
; CHECK-SAME: <2 x i32> [[TMP0:%.*]]) {
; CHECK-NEXT:    [[CTTZ:%.*]] = sub <2 x i32> <i32 10, i32 3>, [[TMP0]]
; CHECK-NEXT:    ret <2 x i32> [[CTTZ]]
;
  %lshr = lshr exact <2 x i32> <i32 8387584, i32 4276440>, %0
  %cttz = call <2 x i32> @llvm.cttz.v2i32(<2 x i32> %lshr, i1 true)
  ret <2 x i32> %cttz
}

define <2 x i32> @vec2_shl_cttz_true(<2 x i32>) {
; CHECK-LABEL: define <2 x i32> @vec2_shl_cttz_true(
; CHECK-SAME: <2 x i32> [[TMP0:%.*]]) {
; CHECK-NEXT:    [[CTTZ:%.*]] = add <2 x i32> [[TMP0]], <i32 10, i32 3>
; CHECK-NEXT:    ret <2 x i32> [[CTTZ]]
;
  %shl = shl <2 x i32> <i32 8387584, i32 4276440>, %0
  %cttz = call <2 x i32> @llvm.cttz.v2i32(<2 x i32> %shl, i1 true)
  ret <2 x i32> %cttz
}

; negative tests:

define <2 x i32> @vec2_shl_nsw_ctlz_true_neg(<2 x i32>) {
; CHECK-LABEL: define <2 x i32> @vec2_shl_nsw_ctlz_true_neg(
; CHECK-SAME: <2 x i32> [[TMP0:%.*]]) {
; CHECK-NEXT:    [[SHL:%.*]] = shl nsw <2 x i32> <i32 8387584, i32 4276440>, [[TMP0]]
; CHECK-NEXT:    [[CTLZ:%.*]] = call <2 x i32> @llvm.ctlz.v2i32(<2 x i32> [[SHL]], i1 true), !range [[RNG0:![0-9]+]]
; CHECK-NEXT:    ret <2 x i32> [[CTLZ]]
;
  %shl = shl nsw <2 x i32> <i32 8387584, i32 4276440>, %0
  %ctlz = call <2 x i32> @llvm.ctlz.v2i32(<2 x i32> %shl, i1 true)
  ret <2 x i32> %ctlz
}

define <2 x i32> @vec2_lshr_ctlz_false_neg(<2 x i32>) {
; CHECK-LABEL: define <2 x i32> @vec2_lshr_ctlz_false_neg(
; CHECK-SAME: <2 x i32> [[TMP0:%.*]]) {
; CHECK-NEXT:    [[DIV:%.*]] = lshr <2 x i32> <i32 8387584, i32 4276440>, [[TMP0]]
; CHECK-NEXT:    [[CTLZ:%.*]] = call <2 x i32> @llvm.ctlz.v2i32(<2 x i32> [[DIV]], i1 false), !range [[RNG1:![0-9]+]]
; CHECK-NEXT:    ret <2 x i32> [[CTLZ]]
;
  %div = lshr <2 x i32> <i32 8387584, i32 4276440>, %0
  %ctlz = call <2 x i32> @llvm.ctlz.v2i32(<2 x i32> %div, i1 false)
  ret <2 x i32> %ctlz
}

define <2 x i32> @vec2_shl_ctlz_false_neg(<2 x i32>) {
; CHECK-LABEL: define <2 x i32> @vec2_shl_ctlz_false_neg(
; CHECK-SAME: <2 x i32> [[TMP0:%.*]]) {
; CHECK-NEXT:    [[SHL:%.*]] = shl <2 x i32> <i32 8387584, i32 4276440>, [[TMP0]]
; CHECK-NEXT:    [[CTLZ:%.*]] = call <2 x i32> @llvm.ctlz.v2i32(<2 x i32> [[SHL]], i1 false), !range [[RNG2:![0-9]+]]
; CHECK-NEXT:    ret <2 x i32> [[CTLZ]]
;
  %shl = shl <2 x i32> <i32 8387584, i32 4276440>, %0
  %ctlz = call <2 x i32> @llvm.ctlz.v2i32(<2 x i32> %shl, i1 false)
  ret <2 x i32> %ctlz
}

define <2 x i32> @vec2_lshr_cttz_false_neg(<2 x i32>) {
; CHECK-LABEL: define <2 x i32> @vec2_lshr_cttz_false_neg(
; CHECK-SAME: <2 x i32> [[TMP0:%.*]]) {
; CHECK-NEXT:    [[LSHR:%.*]] = lshr <2 x i32> <i32 8387584, i32 4276440>, [[TMP0]]
; CHECK-NEXT:    [[CTTZ:%.*]] = call <2 x i32> @llvm.cttz.v2i32(<2 x i32> [[LSHR]], i1 false), !range [[RNG2]]
; CHECK-NEXT:    ret <2 x i32> [[CTTZ]]
;
  %lshr = lshr <2 x i32> <i32 8387584, i32 4276440>, %0
  %cttz = call <2 x i32> @llvm.cttz.v2i32(<2 x i32> %lshr, i1 false)
  ret <2 x i32> %cttz
}

define <2 x i32> @vec2_shl_cttz_false_neg(<2 x i32>) {
; CHECK-LABEL: define <2 x i32> @vec2_shl_cttz_false_neg(
; CHECK-SAME: <2 x i32> [[TMP0:%.*]]) {
; CHECK-NEXT:    [[SHL:%.*]] = shl <2 x i32> <i32 8387584, i32 4276440>, [[TMP0]]
; CHECK-NEXT:    [[CTTZ:%.*]] = call <2 x i32> @llvm.cttz.v2i32(<2 x i32> [[SHL]], i1 false), !range [[RNG3:![0-9]+]]
; CHECK-NEXT:    ret <2 x i32> [[CTTZ]]
;
  %shl = shl <2 x i32> <i32 8387584, i32 4276440>, %0
  %cttz = call <2 x i32> @llvm.cttz.v2i32(<2 x i32> %shl, i1 false)
  ret <2 x i32> %cttz
}

define i32 @lshr_ctlz_faslse_neg(i32) {
; CHECK-LABEL: define i32 @lshr_ctlz_faslse_neg(
; CHECK-SAME: i32 [[TMP0:%.*]]) {
; CHECK-NEXT:    [[LSHR:%.*]] = lshr i32 8387584, [[TMP0]]
; CHECK-NEXT:    [[CTLZ:%.*]] = call i32 @llvm.ctlz.i32(i32 [[LSHR]], i1 false), !range [[RNG1]]
; CHECK-NEXT:    ret i32 [[CTLZ]]
;
  %lshr = lshr i32 8387584, %0
  %ctlz = call i32 @llvm.ctlz.i32(i32 %lshr, i1 false)
  ret i32 %ctlz
}

define i32 @shl_ctlz_false_neg(i32) {
; CHECK-LABEL: define i32 @shl_ctlz_false_neg(
; CHECK-SAME: i32 [[TMP0:%.*]]) {
; CHECK-NEXT:    [[SHL:%.*]] = shl i32 8387584, [[TMP0]]
; CHECK-NEXT:    [[CTLZ:%.*]] = call i32 @llvm.ctlz.i32(i32 [[SHL]], i1 false), !range [[RNG2]]
; CHECK-NEXT:    ret i32 [[CTLZ]]
;
  %shl = shl i32 8387584, %0
  %ctlz = call i32 @llvm.ctlz.i32(i32 %shl, i1 false)
  ret i32 %ctlz
}

define i32 @lshr_cttz_false_neg(i32) {
; CHECK-LABEL: define i32 @lshr_cttz_false_neg(
; CHECK-SAME: i32 [[TMP0:%.*]]) {
; CHECK-NEXT:    [[LSHR:%.*]] = lshr i32 8387584, [[TMP0]]
; CHECK-NEXT:    [[CTTZ:%.*]] = call i32 @llvm.cttz.i32(i32 [[LSHR]], i1 false), !range [[RNG2]]
; CHECK-NEXT:    ret i32 [[CTTZ]]
;
  %lshr = lshr i32 8387584, %0
  %cttz = call i32 @llvm.cttz.i32(i32 %lshr, i1 false)
  ret i32 %cttz
}

define i32 @shl_cttz_false_neg(i32) {
; CHECK-LABEL: define i32 @shl_cttz_false_neg(
; CHECK-SAME: i32 [[TMP0:%.*]]) {
; CHECK-NEXT:    [[SHL:%.*]] = shl i32 8387584, [[TMP0]]
; CHECK-NEXT:    [[CTTZ:%.*]] = call i32 @llvm.cttz.i32(i32 [[SHL]], i1 false), !range [[RNG4:![0-9]+]]
; CHECK-NEXT:    ret i32 [[CTTZ]]
;
  %shl = shl i32 8387584, %0
  %cttz = call i32 @llvm.cttz.i32(i32 %shl, i1 false)
  ret i32 %cttz
}
;.
; CHECK: [[RNG0]] = !{i32 1, i32 33}
; CHECK: [[RNG1]] = !{i32 9, i32 33}
; CHECK: [[RNG2]] = !{i32 0, i32 33}
; CHECK: [[RNG3]] = !{i32 3, i32 33}
; CHECK: [[RNG4]] = !{i32 10, i32 33}
;.
