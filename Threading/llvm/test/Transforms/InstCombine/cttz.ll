; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -passes=instcombine | FileCheck %s

declare i32 @llvm.cttz.i32(i32, i1)
declare i32 @llvm.ctlz.i32(i32, i1)
declare <2 x i64> @llvm.cttz.v2i64(<2 x i64>, i1)
declare void @use(i32)

define i32 @cttz_zext_zero_undef(i16 %x) {
; CHECK-LABEL: @cttz_zext_zero_undef(
; CHECK-NEXT:    [[TMP1:%.*]] = call i16 @llvm.cttz.i16(i16 [[X:%.*]], i1 true), !range [[RNG0:![0-9]+]]
; CHECK-NEXT:    [[TZ:%.*]] = zext nneg i16 [[TMP1]] to i32
; CHECK-NEXT:    ret i32 [[TZ]]
;
  %z = zext i16 %x to i32
  %tz = call i32 @llvm.cttz.i32(i32 %z, i1 true)
  ret i32 %tz
}

define i32 @cttz_zext_zero_def(i16 %x) {
; CHECK-LABEL: @cttz_zext_zero_def(
; CHECK-NEXT:    [[Z:%.*]] = zext i16 [[X:%.*]] to i32
; CHECK-NEXT:    [[TZ:%.*]] = call i32 @llvm.cttz.i32(i32 [[Z]], i1 false), !range [[RNG1:![0-9]+]]
; CHECK-NEXT:    ret i32 [[TZ]]
;
  %z = zext i16 %x to i32
  %tz = call i32 @llvm.cttz.i32(i32 %z, i1 false)
  ret i32 %tz
}

define i32 @cttz_zext_zero_undef_extra_use(i16 %x) {
; CHECK-LABEL: @cttz_zext_zero_undef_extra_use(
; CHECK-NEXT:    [[Z:%.*]] = zext i16 [[X:%.*]] to i32
; CHECK-NEXT:    call void @use(i32 [[Z]])
; CHECK-NEXT:    [[TZ:%.*]] = call i32 @llvm.cttz.i32(i32 [[Z]], i1 true), !range [[RNG1]]
; CHECK-NEXT:    ret i32 [[TZ]]
;
  %z = zext i16 %x to i32
  call void @use(i32 %z)
  %tz = call i32 @llvm.cttz.i32(i32 %z, i1 true)
  ret i32 %tz
}

define <2 x i64> @cttz_zext_zero_undef_vec(<2 x i32> %x) {
; CHECK-LABEL: @cttz_zext_zero_undef_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x i32> @llvm.cttz.v2i32(<2 x i32> [[X:%.*]], i1 true), !range [[RNG1]]
; CHECK-NEXT:    [[TZ:%.*]] = zext nneg <2 x i32> [[TMP1]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[TZ]]
;
  %z = zext <2 x i32> %x to <2 x i64>
  %tz = tail call <2 x i64> @llvm.cttz.v2i64(<2 x i64> %z, i1 true)
  ret <2 x i64> %tz
}

define <2 x i64> @cttz_zext_zero_def_vec(<2 x i32> %x) {
; CHECK-LABEL: @cttz_zext_zero_def_vec(
; CHECK-NEXT:    [[Z:%.*]] = zext <2 x i32> [[X:%.*]] to <2 x i64>
; CHECK-NEXT:    [[TZ:%.*]] = tail call <2 x i64> @llvm.cttz.v2i64(<2 x i64> [[Z]], i1 false), !range [[RNG2:![0-9]+]]
; CHECK-NEXT:    ret <2 x i64> [[TZ]]
;
  %z = zext <2 x i32> %x to <2 x i64>
  %tz = tail call <2 x i64> @llvm.cttz.v2i64(<2 x i64> %z, i1 false)
  ret <2 x i64> %tz
}

define i32 @cttz_sext_zero_undef(i16 %x) {
; CHECK-LABEL: @cttz_sext_zero_undef(
; CHECK-NEXT:    [[TMP1:%.*]] = call i16 @llvm.cttz.i16(i16 [[X:%.*]], i1 true), !range [[RNG0]]
; CHECK-NEXT:    [[TZ:%.*]] = zext nneg i16 [[TMP1]] to i32
; CHECK-NEXT:    ret i32 [[TZ]]
;
  %s = sext i16 %x to i32
  %tz = call i32 @llvm.cttz.i32(i32 %s, i1 true)
  ret i32 %tz
}

define i32 @cttz_sext_zero_def(i16 %x) {
; CHECK-LABEL: @cttz_sext_zero_def(
; CHECK-NEXT:    [[TMP1:%.*]] = zext i16 [[X:%.*]] to i32
; CHECK-NEXT:    [[TZ:%.*]] = call i32 @llvm.cttz.i32(i32 [[TMP1]], i1 false), !range [[RNG1]]
; CHECK-NEXT:    ret i32 [[TZ]]
;
  %s = sext i16 %x to i32
  %tz = call i32 @llvm.cttz.i32(i32 %s, i1 false)
  ret i32 %tz
}

define i32 @cttz_sext_zero_undef_extra_use(i16 %x) {
; CHECK-LABEL: @cttz_sext_zero_undef_extra_use(
; CHECK-NEXT:    [[S:%.*]] = sext i16 [[X:%.*]] to i32
; CHECK-NEXT:    call void @use(i32 [[S]])
; CHECK-NEXT:    [[TZ:%.*]] = call i32 @llvm.cttz.i32(i32 [[S]], i1 true), !range [[RNG1]]
; CHECK-NEXT:    ret i32 [[TZ]]
;
  %s = sext i16 %x to i32
  call void @use(i32 %s)
  %tz = call i32 @llvm.cttz.i32(i32 %s, i1 true)
  ret i32 %tz
}

define <2 x i64> @cttz_sext_zero_undef_vec(<2 x i32> %x) {
; CHECK-LABEL: @cttz_sext_zero_undef_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x i32> @llvm.cttz.v2i32(<2 x i32> [[X:%.*]], i1 true), !range [[RNG1]]
; CHECK-NEXT:    [[TZ:%.*]] = zext nneg <2 x i32> [[TMP1]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[TZ]]
;
  %s = sext <2 x i32> %x to <2 x i64>
  %tz = tail call <2 x i64> @llvm.cttz.v2i64(<2 x i64> %s, i1 true)
  ret <2 x i64> %tz
}

define <2 x i64> @cttz_sext_zero_def_vec(<2 x i32> %x) {
; CHECK-LABEL: @cttz_sext_zero_def_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = zext <2 x i32> [[X:%.*]] to <2 x i64>
; CHECK-NEXT:    [[TZ:%.*]] = call <2 x i64> @llvm.cttz.v2i64(<2 x i64> [[TMP1]], i1 false), !range [[RNG2]]
; CHECK-NEXT:    ret <2 x i64> [[TZ]]
;
  %s = sext <2 x i32> %x to <2 x i64>
  %tz = tail call <2 x i64> @llvm.cttz.v2i64(<2 x i64> %s, i1 false)
  ret <2 x i64> %tz
}

define i32 @cttz_of_lowest_set_bit(i32 %x) {
; CHECK-LABEL: @cttz_of_lowest_set_bit(
; CHECK-NEXT:    [[TZ:%.*]] = call i32 @llvm.cttz.i32(i32 [[X:%.*]], i1 false), !range [[RNG1]]
; CHECK-NEXT:    ret i32 [[TZ]]
;
  %sub = sub i32 0, %x
  %and = and i32 %sub, %x
  %tz = call i32 @llvm.cttz.i32(i32 %and, i1 false)
  ret i32 %tz
}

define i32 @cttz_of_lowest_set_bit_commuted(i32 %xx) {
; CHECK-LABEL: @cttz_of_lowest_set_bit_commuted(
; CHECK-NEXT:    [[X:%.*]] = udiv i32 42, [[XX:%.*]]
; CHECK-NEXT:    [[TZ:%.*]] = call i32 @llvm.cttz.i32(i32 [[X]], i1 false), !range [[RNG1]]
; CHECK-NEXT:    ret i32 [[TZ]]
;
  %x = udiv i32 42, %xx ; thwart complexity-based canonicalization
  %sub = sub i32 0, %x
  %and = and i32 %x, %sub
  %tz = call i32 @llvm.cttz.i32(i32 %and, i1 false)
  ret i32 %tz
}

define i32 @cttz_of_lowest_set_bit_poison_flag(i32 %x) {
; CHECK-LABEL: @cttz_of_lowest_set_bit_poison_flag(
; CHECK-NEXT:    [[TZ:%.*]] = call i32 @llvm.cttz.i32(i32 [[X:%.*]], i1 true), !range [[RNG1]]
; CHECK-NEXT:    ret i32 [[TZ]]
;
  %sub = sub i32 0, %x
  %and = and i32 %sub, %x
  %tz = call i32 @llvm.cttz.i32(i32 %and, i1 true)
  ret i32 %tz
}

define <2 x i64> @cttz_of_lowest_set_bit_vec(<2 x i64> %x) {
; CHECK-LABEL: @cttz_of_lowest_set_bit_vec(
; CHECK-NEXT:    [[TZ:%.*]] = call <2 x i64> @llvm.cttz.v2i64(<2 x i64> [[X:%.*]], i1 false), !range [[RNG2]]
; CHECK-NEXT:    ret <2 x i64> [[TZ]]
;
  %sub = sub <2 x i64> zeroinitializer, %x
  %and = and <2 x i64> %sub, %x
  %tz = call <2 x i64> @llvm.cttz.v2i64(<2 x i64> %and, i1 false)
  ret <2 x i64> %tz
}

define <2 x i64> @cttz_of_lowest_set_bit_vec_undef(<2 x i64> %x) {
; CHECK-LABEL: @cttz_of_lowest_set_bit_vec_undef(
; CHECK-NEXT:    [[TZ:%.*]] = call <2 x i64> @llvm.cttz.v2i64(<2 x i64> [[X:%.*]], i1 false), !range [[RNG2]]
; CHECK-NEXT:    ret <2 x i64> [[TZ]]
;
  %sub = sub <2 x i64> zeroinitializer, %x
  %and = and <2 x i64> %sub, %x
  %tz = call <2 x i64> @llvm.cttz.v2i64(<2 x i64> %and, i1 false)
  ret <2 x i64> %tz
}

define i32 @cttz_of_lowest_set_bit_wrong_const(i32 %x) {
; CHECK-LABEL: @cttz_of_lowest_set_bit_wrong_const(
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 1, [[X:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[SUB]], [[X]]
; CHECK-NEXT:    [[TZ:%.*]] = call i32 @llvm.cttz.i32(i32 [[AND]], i1 false), !range [[RNG3:![0-9]+]]
; CHECK-NEXT:    ret i32 [[TZ]]
;
  %sub = sub i32 1, %x
  %and = and i32 %sub, %x
  %tz = call i32 @llvm.cttz.i32(i32 %and, i1 false)
  ret i32 %tz
}

define i32 @cttz_of_lowest_set_bit_wrong_operand(i32 %x, i32 %y) {
; CHECK-LABEL: @cttz_of_lowest_set_bit_wrong_operand(
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 0, [[Y:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[SUB]], [[X:%.*]]
; CHECK-NEXT:    [[TZ:%.*]] = call i32 @llvm.cttz.i32(i32 [[AND]], i1 false), !range [[RNG1]]
; CHECK-NEXT:    ret i32 [[TZ]]
;
  %sub = sub i32 0, %y
  %and = and i32 %sub, %x
  %tz = call i32 @llvm.cttz.i32(i32 %and, i1 false)
  ret i32 %tz
}

define i32 @cttz_of_lowest_set_bit_wrong_intrinsic(i32 %x) {
; CHECK-LABEL: @cttz_of_lowest_set_bit_wrong_intrinsic(
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 0, [[X:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[SUB]], [[X]]
; CHECK-NEXT:    [[TZ:%.*]] = call i32 @llvm.ctlz.i32(i32 [[AND]], i1 false), !range [[RNG1]]
; CHECK-NEXT:    ret i32 [[TZ]]
;
  %sub = sub i32 0, %x
  %and = and i32 %sub, %x
  %tz = call i32 @llvm.ctlz.i32(i32 %and, i1 false)
  ret i32 %tz
}
