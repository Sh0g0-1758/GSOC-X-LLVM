; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 4
; RUN: opt -S --passes=slp-vectorizer -mtriple=x86_64-linux-gnu < %s | FileCheck %s

define void @test(ptr noalias %arg, ptr noalias %arg1, ptr %arg2) {
; CHECK-LABEL: define void @test(
; CHECK-SAME: ptr noalias [[ARG:%.*]], ptr noalias [[ARG1:%.*]], ptr [[ARG2:%.*]]) {
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[TMP_I_I:%.*]] = getelementptr i8, ptr [[ARG1]], i64 24
; CHECK-NEXT:    [[TMP_I_I4:%.*]] = getelementptr i8, ptr [[ARG]], i64 24
; CHECK-NEXT:    [[TMP0:%.*]] = load <4 x float>, ptr [[TMP_I_I]], align 8
; CHECK-NEXT:    [[TMP1:%.*]] = extractelement <4 x float> [[TMP0]], i32 1
; CHECK-NEXT:    store float [[TMP1]], ptr [[ARG2]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = fcmp olt <4 x float> [[TMP0]], zeroinitializer
; CHECK-NEXT:    [[TMP3:%.*]] = shufflevector <4 x float> [[TMP0]], <4 x float> poison, <4 x i32> <i32 2, i32 3, i32 2, i32 3>
; CHECK-NEXT:    [[TMP4:%.*]] = shufflevector <4 x float> [[TMP0]], <4 x float> poison, <4 x i32> <i32 0, i32 1, i32 0, i32 1>
; CHECK-NEXT:    [[TMP5:%.*]] = select <4 x i1> [[TMP2]], <4 x float> [[TMP3]], <4 x float> [[TMP4]]
; CHECK-NEXT:    [[TMP6:%.*]] = shufflevector <4 x float> [[TMP5]], <4 x float> poison, <4 x i32> <i32 2, i32 0, i32 3, i32 1>
; CHECK-NEXT:    store <4 x float> [[TMP6]], ptr [[TMP_I_I4]], align 8
; CHECK-NEXT:    ret void
;
bb:
  %tmp.i.i = getelementptr i8, ptr %arg1, i64 24
  %tmp1.i.i = load float, ptr %tmp.i.i, align 8
  %tmp.i.i2 = getelementptr i8, ptr %arg1, i64 32
  %tmp1.i.i3 = load float, ptr %tmp.i.i2, align 8
  %tmp1.i.i.i = fcmp olt float %tmp1.i.i3, 0.000000e+00
  %tmp9 = select i1 %tmp1.i.i.i, float %tmp1.i.i3, float %tmp1.i.i
  %tmp.i.i4 = getelementptr i8, ptr %arg, i64 24
  store float %tmp9, ptr %tmp.i.i4, align 8
  %tmp1.i.i.i10 = fcmp olt float %tmp1.i.i, 0.000000e+00
  %tmp13 = select i1 %tmp1.i.i.i10, float %tmp1.i.i3, float %tmp1.i.i
  %tmp.i.i12 = getelementptr i8, ptr %arg, i64 28
  store float %tmp13, ptr %tmp.i.i12, align 4
  %tmp.i.i13 = getelementptr i8, ptr %arg1, i64 28
  %tmp1.i.i14 = load float, ptr %tmp.i.i13, align 4
  %tmp.i.i15 = getelementptr i8, ptr %arg1, i64 36
  %tmp1.i.i16 = load float, ptr %tmp.i.i15, align 4
  %tmp1.i.i.i18 = fcmp olt float %tmp1.i.i16, 0.000000e+00
  %tmp17 = select i1 %tmp1.i.i.i18, float %tmp1.i.i16, float %tmp1.i.i14
  %tmp.i.i20 = getelementptr i8, ptr %arg, i64 32
  store float %tmp17, ptr %tmp.i.i20, align 8
  store float %tmp1.i.i14, ptr %arg2, align 4
  %tmp1.i.i.i24 = fcmp olt float %tmp1.i.i14, 0.000000e+00
  %tmp20 = select i1 %tmp1.i.i.i24, float %tmp1.i.i16, float %tmp1.i.i14
  %tmp.i.i26 = getelementptr i8, ptr %arg, i64 36
  store float %tmp20, ptr %tmp.i.i26, align 4
  ret void
}
