; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 4
; RUN: opt -passes=slp-vectorizer -S -slp-threshold=-6 -mtriple=x86_64-unknown-linux-gnu < %s | FileCheck %s

define void @test(i64 %d.promoted.i) {
; CHECK-LABEL: define void @test(
; CHECK-SAME: i64 [[D_PROMOTED_I:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[AND_1_I:%.*]] = and i64 0, [[D_PROMOTED_I]]
; CHECK-NEXT:    [[TMP0:%.*]] = insertelement <8 x i64> <i64 0, i64 poison, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0>, i64 [[AND_1_I]], i32 1
; CHECK-NEXT:    [[TMP1:%.*]] = trunc <8 x i64> [[TMP0]] to <8 x i1>
; CHECK-NEXT:    [[TMP2:%.*]] = mul <8 x i1> [[TMP1]], zeroinitializer
; CHECK-NEXT:    [[AND_1_I_1:%.*]] = and i64 0, 0
; CHECK-NEXT:    [[TMP3:%.*]] = insertelement <8 x i64> <i64 0, i64 poison, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0>, i64 [[AND_1_I_1]], i32 1
; CHECK-NEXT:    [[TMP4:%.*]] = trunc <8 x i64> [[TMP3]] to <8 x i1>
; CHECK-NEXT:    [[TMP5:%.*]] = mul <8 x i1> [[TMP4]], zeroinitializer
; CHECK-NEXT:    [[TMP6:%.*]] = call i1 @llvm.vector.reduce.or.v8i1(<8 x i1> [[TMP5]])
; CHECK-NEXT:    [[TMP7:%.*]] = zext i1 [[TMP6]] to i32
; CHECK-NEXT:    [[TMP8:%.*]] = call i1 @llvm.vector.reduce.or.v8i1(<8 x i1> [[TMP2]])
; CHECK-NEXT:    [[TMP9:%.*]] = zext i1 [[TMP8]] to i32
; CHECK-NEXT:    [[OP_RDX:%.*]] = or i32 [[TMP7]], [[TMP9]]
; CHECK-NEXT:    [[TMP10:%.*]] = and i32 [[OP_RDX]], 0
; CHECK-NEXT:    store i32 [[TMP10]], ptr null, align 4
; CHECK-NEXT:    ret void
;
entry:
  %add.1.i = add i64 0, 0
  %and.1.i = and i64 %add.1.i, %d.promoted.i
  %conv12.1.i = trunc i64 %and.1.i to i32
  %mul.i.1.i = mul i32 %conv12.1.i, 0
  %conv12.i = trunc i64 0 to i32
  %mul.i.i = mul i32 %conv12.i, 0
  %conv14104.i = or i32 %mul.i.1.i, %mul.i.i
  %conv12.2.i = trunc i64 0 to i32
  %mul.i.2.i = mul i32 %conv12.2.i, 0
  %0 = or i32 %conv14104.i, %mul.i.2.i
  %conv12.182.i = trunc i64 0 to i32
  %mul.i.183.i = mul i32 %conv12.182.i, 0
  %1 = or i32 %0, %mul.i.183.i
  %conv12.1.1.i = trunc i64 0 to i32
  %mul.i.1.1.i = mul i32 %conv12.1.1.i, 0
  %2 = or i32 %1, %mul.i.1.1.i
  %conv12.2.1.i = trunc i64 0 to i32
  %mul.i.2.1.i = mul i32 %conv12.2.1.i, 0
  %3 = or i32 %2, %mul.i.2.1.i
  %conv12.297.i = trunc i64 0 to i32
  %mul.i.298.i = mul i32 %conv12.297.i, 0
  %4 = or i32 %3, %mul.i.298.i
  %conv12.1.2.i = trunc i64 0 to i32
  %mul.i.1.2.i = mul i32 %conv12.1.2.i, 0
  %5 = or i32 %4, %mul.i.1.2.i
  %add.1.i.1 = add i64 0, 0
  %and.1.i.1 = and i64 %add.1.i.1, 0
  %conv12.1.i.1 = trunc i64 %and.1.i.1 to i32
  %mul.i.1.i.1 = mul i32 %conv12.1.i.1, 0
  %conv12.i.1 = trunc i64 0 to i32
  %mul.i.i.1 = mul i32 %conv12.i.1, 0
  %conv14104.i.1 = or i32 %mul.i.1.i.1, %mul.i.i.1
  %conv12.2.i.1 = trunc i64 0 to i32
  %mul.i.2.i.1 = mul i32 %conv12.2.i.1, 0
  %6 = or i32 %conv14104.i.1, %mul.i.2.i.1
  %conv12.182.i.1 = trunc i64 0 to i32
  %mul.i.183.i.1 = mul i32 %conv12.182.i.1, 0
  %7 = or i32 %6, %mul.i.183.i.1
  %conv12.1.1.i.1 = trunc i64 0 to i32
  %mul.i.1.1.i.1 = mul i32 %conv12.1.1.i.1, 0
  %8 = or i32 %7, %mul.i.1.1.i.1
  %conv12.2.1.i.1 = trunc i64 0 to i32
  %mul.i.2.1.i.1 = mul i32 %conv12.2.1.i.1, 0
  %9 = or i32 %8, %mul.i.2.1.i.1
  %conv12.297.i.1 = trunc i64 0 to i32
  %mul.i.298.i.1 = mul i32 %conv12.297.i.1, 0
  %10 = or i32 %9, %mul.i.298.i.1
  %conv12.1.2.i.1 = trunc i64 0 to i32
  %mul.i.1.2.i.1 = mul i32 %conv12.1.2.i.1, 0
  %11 = or i32 %10, %mul.i.1.2.i.1
  %12 = or i32 %5, %11
  %13 = and i32 %12, 0
  store i32 %13, ptr null, align 4
  ret void
}
