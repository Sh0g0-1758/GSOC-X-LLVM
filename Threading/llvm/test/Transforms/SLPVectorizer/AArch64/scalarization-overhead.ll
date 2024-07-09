; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -mtriple=arm64-apple-macosx11.0.0 -passes=slp-vectorizer -S < %s | FileCheck %s

; Test case reported on D134605 where the vectorization was causing a slowdown due to an underestimation in the cost of the extractions.

define fastcc i64 @zot(float %arg, float %arg1, float %arg2, float %arg3, float %arg4, ptr %arg5, i1 %arg6, i1 %arg7, i1 %arg8) {
; CHECK-LABEL: @zot(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[TMP0:%.*]] = insertelement <4 x float> <float 0.000000e+00, float poison, float poison, float poison>, float [[ARG:%.*]], i32 1
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <4 x float> [[TMP0]], float [[ARG3:%.*]], i32 2
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <4 x float> [[TMP1]], <4 x float> poison, <4 x i32> <i32 0, i32 1, i32 2, i32 2>
; CHECK-NEXT:    [[TMP3:%.*]] = fmul fast <4 x float> <float 0.000000e+00, float 0.000000e+00, float 1.000000e+00, float 1.000000e+00>, [[TMP2]]
; CHECK-NEXT:    [[VAL12:%.*]] = fadd fast float [[ARG3]], 1.000000e+00
; CHECK-NEXT:    [[TMP4:%.*]] = insertelement <4 x float> [[TMP2]], float [[VAL12]], i32 0
; CHECK-NEXT:    [[TMP5:%.*]] = insertelement <4 x float> [[TMP4]], float 0.000000e+00, i32 1
; CHECK-NEXT:    [[TMP6:%.*]] = fadd fast <4 x float> [[TMP5]], <float 2.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>
; CHECK-NEXT:    br i1 [[ARG6:%.*]], label [[BB18:%.*]], label [[BB57:%.*]]
; CHECK:       bb18:
; CHECK-NEXT:    [[TMP7:%.*]] = phi <4 x float> [ [[TMP6]], [[BB:%.*]] ]
; CHECK-NEXT:    [[TMP8:%.*]] = extractelement <4 x float> [[TMP6]], i32 2
; CHECK-NEXT:    [[VAL23:%.*]] = fmul fast float [[TMP8]], 2.000000e+00
; CHECK-NEXT:    [[TMP9:%.*]] = extractelement <4 x float> [[TMP6]], i32 3
; CHECK-NEXT:    [[VAL24:%.*]] = fmul fast float [[TMP9]], 3.000000e+00
; CHECK-NEXT:    br i1 [[ARG7:%.*]], label [[BB25:%.*]], label [[BB57]]
; CHECK:       bb25:
; CHECK-NEXT:    [[TMP10:%.*]] = phi <4 x float> [ [[TMP7]], [[BB18]] ]
; CHECK-NEXT:    [[TMP11:%.*]] = extractelement <4 x float> [[TMP3]], i32 1
; CHECK-NEXT:    br label [[BB30:%.*]]
; CHECK:       bb30:
; CHECK-NEXT:    [[VAL31:%.*]] = phi float [ [[VAL55:%.*]], [[BB30]] ], [ 0.000000e+00, [[BB25]] ]
; CHECK-NEXT:    [[VAL32:%.*]] = phi float [ [[TMP11]], [[BB30]] ], [ 0.000000e+00, [[BB25]] ]
; CHECK-NEXT:    [[TMP12:%.*]] = load <4 x i8>, ptr [[ARG5:%.*]], align 1
; CHECK-NEXT:    [[TMP13:%.*]] = uitofp <4 x i8> [[TMP12]] to <4 x float>
; CHECK-NEXT:    [[TMP14:%.*]] = fsub fast <4 x float> [[TMP13]], [[TMP3]]
; CHECK-NEXT:    [[TMP15:%.*]] = fmul fast <4 x float> [[TMP14]], [[TMP10]]
; CHECK-NEXT:    [[TMP16:%.*]] = call fast float @llvm.vector.reduce.fadd.v4f32(float -0.000000e+00, <4 x float> [[TMP15]])
; CHECK-NEXT:    [[VAL55]] = tail call fast float @llvm.minnum.f32(float [[VAL31]], float [[ARG1:%.*]])
; CHECK-NEXT:    [[VAL56:%.*]] = tail call fast float @llvm.maxnum.f32(float [[ARG2:%.*]], float [[TMP16]])
; CHECK-NEXT:    call void @ham(float [[VAL55]], float [[VAL56]])
; CHECK-NEXT:    br i1 [[ARG8:%.*]], label [[BB30]], label [[BB57]]
; CHECK:       bb57:
; CHECK-NEXT:    ret i64 0
;
bb:
  %val = fmul fast float 0.000000e+00, 0.000000e+00
  %val9 = fmul fast float 0.000000e+00, %arg
  %val10 = fmul fast float %arg3, 1.000000e+00
  %val11 = fmul fast float %arg3, 1.000000e+00
  %val12 = fadd fast float %arg3, 1.000000e+00
  %val13 = fadd fast float %val12, 2.000000e+00
  %val14 = fadd fast float 0.000000e+00, 0.000000e+00
  %val15 = fadd fast float %val14, 1.000000e+00
  %val16 = fadd fast float %arg3, 1.000000e+00
  %val17 = fadd fast float %arg3, 1.000000e+00
  br i1 %arg6, label %bb18, label %bb57

bb18:                                             ; preds = %bb
  %val19 = phi float [ %val13, %bb ]
  %val20 = phi float [ %val15, %bb ]
  %val21 = phi float [ %val16, %bb ]
  %val22 = phi float [ %val17, %bb ]
  %val23 = fmul fast float %val16, 2.000000e+00
  %val24 = fmul fast float %val17, 3.000000e+00
  br i1 %arg7, label %bb25, label %bb57

bb25:                                             ; preds = %bb18
  %val26 = phi float [ %val19, %bb18 ]
  %val27 = phi float [ %val20, %bb18 ]
  %val28 = phi float [ %val21, %bb18 ]
  %val29 = phi float [ %val22, %bb18 ]
  br label %bb30

bb30:                                             ; preds = %bb30, %bb25
  %val31 = phi float [ %val55, %bb30 ], [ 0.000000e+00, %bb25 ]
  %val32 = phi float [ %val9, %bb30 ], [ 0.000000e+00, %bb25 ]
  %val33 = load i8, ptr %arg5, align 1
  %val34 = uitofp i8 %val33 to float
  %val35 = getelementptr inbounds i8, ptr %arg5, i64 1
  %val36 = load i8, ptr %val35, align 1
  %val37 = uitofp i8 %val36 to float
  %val38 = getelementptr inbounds i8, ptr %arg5, i64 2
  %val39 = load i8, ptr %val38, align 1
  %val40 = uitofp i8 %val39 to float
  %val41 = getelementptr inbounds i8, ptr %arg5, i64 3
  %val42 = load i8, ptr %val41, align 1
  %val43 = uitofp i8 %val42 to float
  %val44 = fsub fast float %val34, %val
  %val45 = fsub fast float %val37, %val9
  %val46 = fsub fast float %val40, %val10
  %val47 = fsub fast float %val43, %val11
  %val48 = fmul fast float %val44, %val26
  %val49 = fmul fast float %val45, %val27
  %val50 = fadd fast float %val49, %val48
  %val51 = fmul fast float %val46, %val28
  %val52 = fadd fast float %val50, %val51
  %val53 = fmul fast float %val47, %val29
  %val54 = fadd fast float %val52, %val53
  %val55 = tail call fast float @llvm.minnum.f32(float %val31, float %arg1)
  %val56 = tail call fast float @llvm.maxnum.f32(float %arg2, float %val54)
  call void @ham(float %val55, float %val56)
  br i1 %arg8, label %bb30, label %bb57

bb57:                                             ; preds = %bb30, %bb18, %bb
  ret i64 0
}

declare float @llvm.maxnum.f32(float, float)
declare float @llvm.minnum.f32(float, float)
declare void @ham(float, float)
