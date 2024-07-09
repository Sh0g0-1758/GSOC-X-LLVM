; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=slp-vectorizer,instcombine -S -o - -mtriple=x86_64-unknown-linux -mcpu=bdver2 | FileCheck %s

define <2 x i8> @g(<2 x i8> %x, <2 x i8> %y) {
; CHECK-LABEL: @g(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <2 x i8> [[X:%.*]], <2 x i8> [[Y:%.*]], <2 x i32> <i32 0, i32 3>
; CHECK-NEXT:    [[TMP2:%.*]] = mul <2 x i8> [[TMP1]], [[TMP1]]
; CHECK-NEXT:    ret <2 x i8> [[TMP2]]
;
  %x0 = extractelement <2 x i8> %x, i32 0
  %y1 = extractelement <2 x i8> %y, i32 1
  %x0x0 = mul i8 %x0, %x0
  %y1y1 = mul i8 %y1, %y1
  %ins1 = insertelement <2 x i8> poison, i8 %x0x0, i32 0
  %ins2 = insertelement <2 x i8> %ins1, i8 %y1y1, i32 1
  ret <2 x i8> %ins2
}

define <4 x i8> @h(<4 x i8> %x, <4 x i8> %y) {
; CHECK-LABEL: @h(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <4 x i8> [[X:%.*]], <4 x i8> [[Y:%.*]], <4 x i32> <i32 0, i32 3, i32 5, i32 6>
; CHECK-NEXT:    [[TMP2:%.*]] = mul <4 x i8> [[TMP1]], [[TMP1]]
; CHECK-NEXT:    ret <4 x i8> [[TMP2]]
;
  %x0 = extractelement <4 x i8> %x, i32 0
  %x3 = extractelement <4 x i8> %x, i32 3
  %y1 = extractelement <4 x i8> %y, i32 1
  %y2 = extractelement <4 x i8> %y, i32 2
  %x0x0 = mul i8 %x0, %x0
  %x3x3 = mul i8 %x3, %x3
  %y1y1 = mul i8 %y1, %y1
  %y2y2 = mul i8 %y2, %y2
  %ins1 = insertelement <4 x i8> poison, i8 %x0x0, i32 0
  %ins2 = insertelement <4 x i8> %ins1, i8 %x3x3, i32 1
  %ins3 = insertelement <4 x i8> %ins2, i8 %y1y1, i32 2
  %ins4 = insertelement <4 x i8> %ins3, i8 %y2y2, i32 3
  ret <4 x i8> %ins4
}

define <4 x i8> @h_undef(<4 x i8> %x, <4 x i8> %y) {
; CHECK-LABEL: @h_undef(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <4 x i8> [[X:%.*]], <4 x i8> [[Y:%.*]], <4 x i32> <i32 poison, i32 3, i32 5, i32 6>
; CHECK-NEXT:    [[TMP2:%.*]] = mul <4 x i8> [[TMP1]], [[TMP1]]
; CHECK-NEXT:    ret <4 x i8> [[TMP2]]
;
  %x0 = extractelement <4 x i8> poison, i32 0
  %x3 = extractelement <4 x i8> %x, i32 3
  %y1 = extractelement <4 x i8> %y, i32 1
  %y2 = extractelement <4 x i8> %y, i32 2
  %x0x0 = mul i8 %x0, %x0
  %x3x3 = mul i8 %x3, %x3
  %y1y1 = mul i8 %y1, %y1
  %y2y2 = mul i8 %y2, %y2
  %ins1 = insertelement <4 x i8> poison, i8 %x0x0, i32 0
  %ins2 = insertelement <4 x i8> %ins1, i8 %x3x3, i32 1
  %ins3 = insertelement <4 x i8> %ins2, i8 %y1y1, i32 2
  %ins4 = insertelement <4 x i8> %ins3, i8 %y2y2, i32 3
  ret <4 x i8> %ins4
}

define i8 @i(<4 x i8> %x, <4 x i8> %y) {
; CHECK-LABEL: @i(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <4 x i8> [[Y:%.*]], <4 x i8> [[X:%.*]], <4 x i32> <i32 2, i32 1, i32 7, i32 4>
; CHECK-NEXT:    [[TMP2:%.*]] = mul <4 x i8> [[TMP1]], [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = call i8 @llvm.vector.reduce.add.v4i8(<4 x i8> [[TMP2]])
; CHECK-NEXT:    ret i8 [[TMP3]]
;
  %x0 = extractelement <4 x i8> %x, i32 0
  %x3 = extractelement <4 x i8> %x, i32 3
  %y1 = extractelement <4 x i8> %y, i32 1
  %y2 = extractelement <4 x i8> %y, i32 2
  %x0x0 = mul i8 %x0, %x0
  %x3x3 = mul i8 %x3, %x3
  %y1y1 = mul i8 %y1, %y1
  %y2y2 = mul i8 %y2, %y2
  %1 = add i8 %x0x0, %x3x3
  %2 = add i8 %y1y1, %y2y2
  %3 = add i8 %1, %2
  ret i8 %3
}

define i8 @j(<4 x i8> %x, <4 x i8> %y) {
; CHECK-LABEL: @j(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <4 x i8> [[X:%.*]], <4 x i8> [[Y:%.*]], <2 x i32> <i32 0, i32 5>
; CHECK-NEXT:    [[TMP2:%.*]] = mul <2 x i8> [[TMP1]], [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = shufflevector <4 x i8> [[X]], <4 x i8> [[Y]], <2 x i32> <i32 3, i32 6>
; CHECK-NEXT:    [[TMP4:%.*]] = mul <2 x i8> [[TMP3]], [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = add <2 x i8> [[TMP2]], [[TMP4]]
; CHECK-NEXT:    [[TMP6:%.*]] = extractelement <2 x i8> [[TMP5]], i64 0
; CHECK-NEXT:    [[TMP7:%.*]] = extractelement <2 x i8> [[TMP5]], i64 1
; CHECK-NEXT:    [[TMP8:%.*]] = sdiv i8 [[TMP6]], [[TMP7]]
; CHECK-NEXT:    ret i8 [[TMP8]]
;
  %x0 = extractelement <4 x i8> %x, i32 0
  %x3 = extractelement <4 x i8> %x, i32 3
  %y1 = extractelement <4 x i8> %y, i32 1
  %y2 = extractelement <4 x i8> %y, i32 2
  %x0x0 = mul i8 %x0, %x0
  %x3x3 = mul i8 %x3, %x3
  %y1y1 = mul i8 %y1, %y1
  %y2y2 = mul i8 %y2, %y2
  %1 = add i8 %x0x0, %x3x3
  %2 = add i8 %y1y1, %y2y2
  %3 = sdiv i8 %1, %2
  ret i8 %3
}

define i8 @k(<4 x i8> %x) {
; CHECK-LABEL: @k(
; CHECK-NEXT:    [[TMP1:%.*]] = mul <4 x i8> [[X:%.*]], [[X]]
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <4 x i8> [[TMP1]], <4 x i8> poison, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[TMP3:%.*]] = mul <4 x i8> [[X]], [[X]]
; CHECK-NEXT:    [[TMP4:%.*]] = shufflevector <4 x i8> [[TMP3]], <4 x i8> poison, <2 x i32> <i32 2, i32 3>
; CHECK-NEXT:    [[TMP5:%.*]] = shufflevector <2 x i8> [[TMP4]], <2 x i8> poison, <2 x i32> <i32 1, i32 0>
; CHECK-NEXT:    [[TMP6:%.*]] = add <2 x i8> [[TMP2]], [[TMP5]]
; CHECK-NEXT:    [[TMP7:%.*]] = extractelement <2 x i8> [[TMP6]], i64 0
; CHECK-NEXT:    [[TMP8:%.*]] = extractelement <2 x i8> [[TMP6]], i64 1
; CHECK-NEXT:    [[TMP9:%.*]] = sdiv i8 [[TMP7]], [[TMP8]]
; CHECK-NEXT:    ret i8 [[TMP9]]
;
  %x0 = extractelement <4 x i8> %x, i32 0
  %x3 = extractelement <4 x i8> %x, i32 3
  %x1 = extractelement <4 x i8> %x, i32 1
  %x2 = extractelement <4 x i8> %x, i32 2
  %x0x0 = mul i8 %x0, %x0
  %x3x3 = mul i8 %x3, %x3
  %x1x1 = mul i8 %x1, %x1
  %x2x2 = mul i8 %x2, %x2
  %1 = add i8 %x0x0, %x3x3
  %2 = add i8 %x1x1, %x2x2
  %3 = sdiv i8 %1, %2
  ret i8 %3
}

define i8 @k_bb(<4 x i8> %x) {
; CHECK-LABEL: @k_bb(
; CHECK-NEXT:    br label [[BB1:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[TMP1:%.*]] = mul <4 x i8> [[X:%.*]], [[X]]
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <4 x i8> [[TMP1]], <4 x i8> poison, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[TMP3:%.*]] = mul <4 x i8> [[X]], [[X]]
; CHECK-NEXT:    [[TMP4:%.*]] = shufflevector <4 x i8> [[TMP3]], <4 x i8> poison, <2 x i32> <i32 2, i32 3>
; CHECK-NEXT:    [[TMP5:%.*]] = shufflevector <2 x i8> [[TMP4]], <2 x i8> poison, <2 x i32> <i32 1, i32 0>
; CHECK-NEXT:    [[TMP6:%.*]] = add <2 x i8> [[TMP2]], [[TMP5]]
; CHECK-NEXT:    [[TMP7:%.*]] = extractelement <2 x i8> [[TMP6]], i64 0
; CHECK-NEXT:    [[TMP8:%.*]] = extractelement <2 x i8> [[TMP6]], i64 1
; CHECK-NEXT:    [[TMP9:%.*]] = sdiv i8 [[TMP7]], [[TMP8]]
; CHECK-NEXT:    ret i8 [[TMP9]]
;
  %x0 = extractelement <4 x i8> %x, i32 0
  br label %bb1
bb1:
  %x3 = extractelement <4 x i8> %x, i32 3
  %x1 = extractelement <4 x i8> %x, i32 1
  %x2 = extractelement <4 x i8> %x, i32 2
  %x0x0 = mul i8 %x0, %x0
  %x3x3 = mul i8 %x3, %x3
  %x1x1 = mul i8 %x1, %x1
  %x2x2 = mul i8 %x2, %x2
  %1 = add i8 %x0x0, %x3x3
  %2 = add i8 %x1x1, %x2x2
  %3 = sdiv i8 %1, %2
  ret i8 %3
}
