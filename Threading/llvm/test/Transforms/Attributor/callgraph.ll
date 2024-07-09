; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --check-globals
; RUN: opt -passes=attributor -S < %s | FileCheck %s --check-prefixes=CHECK,OWRDL,UPTO2,UNLIM,OUNLM
; RUN: opt -passes=attributor -attributor-print-call-graph -S -disable-output < %s | FileCheck %s --check-prefixes=DOT
; RUN: opt -passes=attributor --attributor-max-specializations-per-call-base=2 -S < %s | FileCheck %s --check-prefixes=CHECK,OWRDL,UPTO2,LIMI2
; RUN: opt -passes=attributor --attributor-max-specializations-per-call-base=0 -S < %s | FileCheck %s --check-prefixes=CHECK,OWRDL,LIMI0
; RUN: opt -passes=attributor --attributor-assume-closed-world -S < %s | FileCheck %s --check-prefixes=CHECK,UPTO2,UNLIM,CWRLD

;.
; CHECK: @[[G:[a-zA-Z0-9_$"\\.-]+]] = global ptr @usedByGlobal
;.
define dso_local void @func1() {
; CHECK-LABEL: @func1(
; CHECK-NEXT:    br label [[TMP2:%.*]]
; CHECK:       1:
; CHECK-NEXT:    unreachable
; CHECK:       2:
; CHECK-NEXT:    call void @func3()
; CHECK-NEXT:    ret void
;
  %1 = icmp ne i32 0, 0
  br i1 %1, label %2, label %3

2:                                                ; preds = %0
  call void @func2(i1 false)
  br label %3

3:                                                ; preds = %2, %0
  call void () @func3()
  ret void
}

declare void @func3()
define internal void @func4() {
; CHECK-LABEL: @func4(
; CHECK-NEXT:    call void @func3()
; CHECK-NEXT:    ret void
;
  call void @func3()
  ret void
}
define internal void @internal_good() {
; CHECK-LABEL: @internal_good(
; CHECK-NEXT:    call void @void(ptr @func4)
; CHECK-NEXT:    ret void
;
  call void @void(ptr @func4)
  ret void
}

define dso_local void @func2(i1 %c) {
; UPTO2-LABEL: @func2(
; UPTO2-NEXT:    [[F:%.*]] = select i1 [[C:%.*]], ptr @internal_good, ptr @func4
; UPTO2-NEXT:    [[TMP1:%.*]] = icmp eq ptr [[F]], @func4
; UPTO2-NEXT:    br i1 [[TMP1]], label [[TMP2:%.*]], label [[TMP3:%.*]]
; UPTO2:       2:
; UPTO2-NEXT:    call void @func4()
; UPTO2-NEXT:    br label [[TMP6:%.*]]
; UPTO2:       3:
; UPTO2-NEXT:    br i1 true, label [[TMP4:%.*]], label [[TMP5:%.*]]
; UPTO2:       4:
; UPTO2-NEXT:    call void @internal_good()
; UPTO2-NEXT:    br label [[TMP6]]
; UPTO2:       5:
; UPTO2-NEXT:    unreachable
; UPTO2:       6:
; UPTO2-NEXT:    ret void
;
; LIMI0-LABEL: @func2(
; LIMI0-NEXT:    [[F:%.*]] = select i1 [[C:%.*]], ptr @internal_good, ptr @func4
; LIMI0-NEXT:    call void [[F]](), !callees !0
; LIMI0-NEXT:    ret void
;
  %f = select i1 %c, ptr @internal_good, ptr @func4
  call void %f()
  ret void
}


define void @func5(i32 %0) {
; UPTO2-LABEL: @func5(
; UPTO2-NEXT:    [[TMP2:%.*]] = icmp ne i32 [[TMP0:%.*]], 0
; UPTO2-NEXT:    [[TMP3:%.*]] = select i1 [[TMP2]], ptr @func4, ptr @func3
; UPTO2-NEXT:    [[TMP4:%.*]] = icmp eq ptr [[TMP3]], @func3
; UPTO2-NEXT:    br i1 [[TMP4]], label [[TMP5:%.*]], label [[TMP6:%.*]]
; UPTO2:       5:
; UPTO2-NEXT:    call void @func3()
; UPTO2-NEXT:    br label [[TMP9:%.*]]
; UPTO2:       6:
; UPTO2-NEXT:    br i1 true, label [[TMP7:%.*]], label [[TMP8:%.*]]
; UPTO2:       7:
; UPTO2-NEXT:    call void @func4()
; UPTO2-NEXT:    br label [[TMP9]]
; UPTO2:       8:
; UPTO2-NEXT:    unreachable
; UPTO2:       9:
; UPTO2-NEXT:    ret void
;
; LIMI0-LABEL: @func5(
; LIMI0-NEXT:    [[TMP2:%.*]] = icmp ne i32 [[TMP0:%.*]], 0
; LIMI0-NEXT:    [[TMP3:%.*]] = select i1 [[TMP2]], ptr @func4, ptr @func3
; LIMI0-NEXT:    call void [[TMP3]](), !callees !1
; LIMI0-NEXT:    ret void
;
  %2 = icmp ne i32 %0, 0
  %3 = select i1 %2, ptr @func4, ptr @func3
  call void () %3()
  ret void
}

define i32 @musttailCall(i32 %0) {
; CHECK-LABEL: @musttailCall(
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ne i32 [[TMP0:%.*]], 0
; CHECK-NEXT:    [[TMP3:%.*]] = select i1 [[TMP2]], ptr @func4, ptr @func3
; CHECK-NEXT:    [[C:%.*]] = musttail call i32 [[TMP3]](i32 0)
; CHECK-NEXT:    ret i32 [[C]]
;
  %2 = icmp ne i32 %0, 0
  %3 = select i1 %2, ptr @func4, ptr @func3
  %c = musttail call i32 (i32) %3(i32 0)
  ret i32 %c
}

declare i32 @retI32()
declare void @takeI32(i32)
declare float @retFloatTakeFloat(float)
; This callee is always filtered out because of the noundef argument
declare float @retFloatTakeFloatFloatNoundef(float, float noundef)
declare void @void()

define i32 @non_matching_fp1(i1 %c1, i1 %c2, i1 %c) {
; UNLIM-LABEL: @non_matching_fp1(
; UNLIM-NEXT:    [[FP1:%.*]] = select i1 [[C1:%.*]], ptr @retI32, ptr @takeI32
; UNLIM-NEXT:    [[FP2:%.*]] = select i1 [[C2:%.*]], ptr @retFloatTakeFloat, ptr @void
; UNLIM-NEXT:    [[FP:%.*]] = select i1 [[C:%.*]], ptr [[FP1]], ptr [[FP2]]
; UNLIM-NEXT:    [[TMP1:%.*]] = icmp eq ptr [[FP]], @takeI32
; UNLIM-NEXT:    br i1 [[TMP1]], label [[TMP2:%.*]], label [[TMP3:%.*]]
; UNLIM:       2:
; UNLIM-NEXT:    [[CALL1:%.*]] = call i32 @takeI32(i32 42)
; UNLIM-NEXT:    br label [[TMP15:%.*]]
; UNLIM:       3:
; UNLIM-NEXT:    [[TMP4:%.*]] = icmp eq ptr [[FP]], @retI32
; UNLIM-NEXT:    br i1 [[TMP4]], label [[TMP5:%.*]], label [[TMP6:%.*]]
; UNLIM:       5:
; UNLIM-NEXT:    [[CALL2:%.*]] = call i32 @retI32(i32 42)
; UNLIM-NEXT:    br label [[TMP15]]
; UNLIM:       6:
; UNLIM-NEXT:    [[TMP7:%.*]] = icmp eq ptr [[FP]], @void
; UNLIM-NEXT:    br i1 [[TMP7]], label [[TMP8:%.*]], label [[TMP9:%.*]]
; UNLIM:       8:
; UNLIM-NEXT:    [[CALL3:%.*]] = call i32 @void(i32 42)
; UNLIM-NEXT:    br label [[TMP15]]
; UNLIM:       9:
; UNLIM-NEXT:    br i1 true, label [[TMP10:%.*]], label [[TMP14:%.*]]
; UNLIM:       10:
; UNLIM-NEXT:    [[TMP11:%.*]] = bitcast i32 42 to float
; UNLIM-NEXT:    [[TMP12:%.*]] = call float @retFloatTakeFloat(float [[TMP11]])
; UNLIM-NEXT:    [[TMP13:%.*]] = bitcast float [[TMP12]] to i32
; UNLIM-NEXT:    br label [[TMP15]]
; UNLIM:       14:
; UNLIM-NEXT:    unreachable
; UNLIM:       15:
; UNLIM-NEXT:    [[CALL_PHI:%.*]] = phi i32 [ [[CALL1]], [[TMP2]] ], [ [[CALL2]], [[TMP5]] ], [ [[CALL3]], [[TMP8]] ], [ [[TMP13]], [[TMP10]] ]
; UNLIM-NEXT:    ret i32 [[CALL_PHI]]
;
; LIMI2-LABEL: @non_matching_fp1(
; LIMI2-NEXT:    [[FP1:%.*]] = select i1 [[C1:%.*]], ptr @retI32, ptr @takeI32
; LIMI2-NEXT:    [[FP2:%.*]] = select i1 [[C2:%.*]], ptr @retFloatTakeFloat, ptr @void
; LIMI2-NEXT:    [[FP:%.*]] = select i1 [[C:%.*]], ptr [[FP1]], ptr [[FP2]]
; LIMI2-NEXT:    [[TMP1:%.*]] = icmp eq ptr [[FP]], @takeI32
; LIMI2-NEXT:    br i1 [[TMP1]], label [[TMP2:%.*]], label [[TMP3:%.*]]
; LIMI2:       2:
; LIMI2-NEXT:    [[CALL1:%.*]] = call i32 @takeI32(i32 42)
; LIMI2-NEXT:    br label [[TMP7:%.*]]
; LIMI2:       3:
; LIMI2-NEXT:    [[TMP4:%.*]] = icmp eq ptr [[FP]], @retI32
; LIMI2-NEXT:    br i1 [[TMP4]], label [[TMP5:%.*]], label [[TMP6:%.*]]
; LIMI2:       5:
; LIMI2-NEXT:    [[CALL2:%.*]] = call i32 @retI32(i32 42)
; LIMI2-NEXT:    br label [[TMP7]]
; LIMI2:       6:
; LIMI2-NEXT:    [[CALL3:%.*]] = call i32 [[FP]](i32 42), !callees !0
; LIMI2-NEXT:    br label [[TMP7]]
; LIMI2:       7:
; LIMI2-NEXT:    [[CALL_PHI:%.*]] = phi i32 [ [[CALL1]], [[TMP2]] ], [ [[CALL2]], [[TMP5]] ], [ [[CALL3]], [[TMP6]] ]
; LIMI2-NEXT:    ret i32 [[CALL_PHI]]
;
; LIMI0-LABEL: @non_matching_fp1(
; LIMI0-NEXT:    [[FP1:%.*]] = select i1 [[C1:%.*]], ptr @retI32, ptr @takeI32
; LIMI0-NEXT:    [[FP2:%.*]] = select i1 [[C2:%.*]], ptr @retFloatTakeFloat, ptr @void
; LIMI0-NEXT:    [[FP:%.*]] = select i1 [[C:%.*]], ptr [[FP1]], ptr [[FP2]]
; LIMI0-NEXT:    [[CALL:%.*]] = call i32 [[FP]](i32 42), !callees !2
; LIMI0-NEXT:    ret i32 [[CALL]]
;
  %fp1 = select i1 %c1, ptr @retI32, ptr @takeI32
  %fp2 = select i1 %c2, ptr @retFloatTakeFloat, ptr @void
  %fp = select i1 %c, ptr %fp1, ptr %fp2
  %call = call i32 %fp(i32 42)
  ret i32 %call
}

define i32 @non_matching_fp1_noundef(i1 %c1, i1 %c2, i1 %c) {
; UNLIM-LABEL: @non_matching_fp1_noundef(
; UNLIM-NEXT:    [[FP1:%.*]] = select i1 [[C1:%.*]], ptr @retI32, ptr @takeI32
; UNLIM-NEXT:    [[FP2:%.*]] = select i1 [[C2:%.*]], ptr @retFloatTakeFloatFloatNoundef, ptr @void
; UNLIM-NEXT:    [[FP:%.*]] = select i1 [[C:%.*]], ptr [[FP1]], ptr [[FP2]]
; UNLIM-NEXT:    [[TMP1:%.*]] = icmp eq ptr [[FP]], @takeI32
; UNLIM-NEXT:    br i1 [[TMP1]], label [[TMP2:%.*]], label [[TMP3:%.*]]
; UNLIM:       2:
; UNLIM-NEXT:    [[CALL1:%.*]] = call i32 @takeI32(i32 42)
; UNLIM-NEXT:    br label [[TMP9:%.*]]
; UNLIM:       3:
; UNLIM-NEXT:    [[TMP4:%.*]] = icmp eq ptr [[FP]], @retI32
; UNLIM-NEXT:    br i1 [[TMP4]], label [[TMP5:%.*]], label [[TMP6:%.*]]
; UNLIM:       5:
; UNLIM-NEXT:    [[CALL2:%.*]] = call i32 @retI32(i32 42)
; UNLIM-NEXT:    br label [[TMP9]]
; UNLIM:       6:
; UNLIM-NEXT:    br i1 true, label [[TMP7:%.*]], label [[TMP8:%.*]]
; UNLIM:       7:
; UNLIM-NEXT:    [[CALL3:%.*]] = call i32 @void(i32 42)
; UNLIM-NEXT:    br label [[TMP9]]
; UNLIM:       8:
; UNLIM-NEXT:    unreachable
; UNLIM:       9:
; UNLIM-NEXT:    [[CALL_PHI:%.*]] = phi i32 [ [[CALL1]], [[TMP2]] ], [ [[CALL2]], [[TMP5]] ], [ [[CALL3]], [[TMP7]] ]
; UNLIM-NEXT:    ret i32 [[CALL_PHI]]
;
; LIMI2-LABEL: @non_matching_fp1_noundef(
; LIMI2-NEXT:    [[FP1:%.*]] = select i1 [[C1:%.*]], ptr @retI32, ptr @takeI32
; LIMI2-NEXT:    [[FP2:%.*]] = select i1 [[C2:%.*]], ptr @retFloatTakeFloatFloatNoundef, ptr @void
; LIMI2-NEXT:    [[FP:%.*]] = select i1 [[C:%.*]], ptr [[FP1]], ptr [[FP2]]
; LIMI2-NEXT:    [[TMP1:%.*]] = icmp eq ptr [[FP]], @takeI32
; LIMI2-NEXT:    br i1 [[TMP1]], label [[TMP2:%.*]], label [[TMP3:%.*]]
; LIMI2:       2:
; LIMI2-NEXT:    [[CALL1:%.*]] = call i32 @takeI32(i32 42)
; LIMI2-NEXT:    br label [[TMP7:%.*]]
; LIMI2:       3:
; LIMI2-NEXT:    [[TMP4:%.*]] = icmp eq ptr [[FP]], @retI32
; LIMI2-NEXT:    br i1 [[TMP4]], label [[TMP5:%.*]], label [[TMP6:%.*]]
; LIMI2:       5:
; LIMI2-NEXT:    [[CALL2:%.*]] = call i32 @retI32(i32 42)
; LIMI2-NEXT:    br label [[TMP7]]
; LIMI2:       6:
; LIMI2-NEXT:    [[CALL3:%.*]] = call i32 [[FP]](i32 42), !callees !1
; LIMI2-NEXT:    br label [[TMP7]]
; LIMI2:       7:
; LIMI2-NEXT:    [[CALL_PHI:%.*]] = phi i32 [ [[CALL1]], [[TMP2]] ], [ [[CALL2]], [[TMP5]] ], [ [[CALL3]], [[TMP6]] ]
; LIMI2-NEXT:    ret i32 [[CALL_PHI]]
;
; LIMI0-LABEL: @non_matching_fp1_noundef(
; LIMI0-NEXT:    [[FP1:%.*]] = select i1 [[C1:%.*]], ptr @retI32, ptr @takeI32
; LIMI0-NEXT:    [[FP2:%.*]] = select i1 [[C2:%.*]], ptr @retFloatTakeFloatFloatNoundef, ptr @void
; LIMI0-NEXT:    [[FP:%.*]] = select i1 [[C:%.*]], ptr [[FP1]], ptr [[FP2]]
; LIMI0-NEXT:    [[CALL:%.*]] = call i32 [[FP]](i32 42), !callees !3
; LIMI0-NEXT:    ret i32 [[CALL]]
;
  %fp1 = select i1 %c1, ptr @retI32, ptr @takeI32
  %fp2 = select i1 %c2, ptr @retFloatTakeFloatFloatNoundef, ptr @void
  %fp = select i1 %c, ptr %fp1, ptr %fp2
  %call = call i32 %fp(i32 42)
  ret i32 %call
}

define void @non_matching_fp2(i1 %c1, i1 %c2, i1 %c, ptr %unknown) {
; OUNLM-LABEL: @non_matching_fp2(
; OUNLM-NEXT:    [[FP1:%.*]] = select i1 [[C1:%.*]], ptr @retI32, ptr @takeI32
; OUNLM-NEXT:    [[FP2:%.*]] = select i1 [[C2:%.*]], ptr @retFloatTakeFloat, ptr [[UNKNOWN:%.*]]
; OUNLM-NEXT:    [[FP:%.*]] = select i1 [[C:%.*]], ptr [[FP1]], ptr [[FP2]]
; OUNLM-NEXT:    [[TMP1:%.*]] = icmp eq ptr [[FP]], @takeI32
; OUNLM-NEXT:    br i1 [[TMP1]], label [[TMP2:%.*]], label [[TMP3:%.*]]
; OUNLM:       2:
; OUNLM-NEXT:    call void @takeI32()
; OUNLM-NEXT:    br label [[TMP10:%.*]]
; OUNLM:       3:
; OUNLM-NEXT:    [[TMP4:%.*]] = icmp eq ptr [[FP]], @retI32
; OUNLM-NEXT:    br i1 [[TMP4]], label [[TMP5:%.*]], label [[TMP6:%.*]]
; OUNLM:       5:
; OUNLM-NEXT:    call void @retI32()
; OUNLM-NEXT:    br label [[TMP10]]
; OUNLM:       6:
; OUNLM-NEXT:    [[TMP7:%.*]] = icmp eq ptr [[FP]], @retFloatTakeFloat
; OUNLM-NEXT:    br i1 [[TMP7]], label [[TMP8:%.*]], label [[TMP9:%.*]]
; OUNLM:       8:
; OUNLM-NEXT:    call void @retFloatTakeFloat()
; OUNLM-NEXT:    br label [[TMP10]]
; OUNLM:       9:
; OUNLM-NEXT:    call void [[FP]]()
; OUNLM-NEXT:    br label [[TMP10]]
; OUNLM:       10:
; OUNLM-NEXT:    ret void
;
; LIMI2-LABEL: @non_matching_fp2(
; LIMI2-NEXT:    [[FP1:%.*]] = select i1 [[C1:%.*]], ptr @retI32, ptr @takeI32
; LIMI2-NEXT:    [[FP2:%.*]] = select i1 [[C2:%.*]], ptr @retFloatTakeFloat, ptr [[UNKNOWN:%.*]]
; LIMI2-NEXT:    [[FP:%.*]] = select i1 [[C:%.*]], ptr [[FP1]], ptr [[FP2]]
; LIMI2-NEXT:    [[TMP1:%.*]] = icmp eq ptr [[FP]], @takeI32
; LIMI2-NEXT:    br i1 [[TMP1]], label [[TMP2:%.*]], label [[TMP3:%.*]]
; LIMI2:       2:
; LIMI2-NEXT:    call void @takeI32()
; LIMI2-NEXT:    br label [[TMP7:%.*]]
; LIMI2:       3:
; LIMI2-NEXT:    [[TMP4:%.*]] = icmp eq ptr [[FP]], @retI32
; LIMI2-NEXT:    br i1 [[TMP4]], label [[TMP5:%.*]], label [[TMP6:%.*]]
; LIMI2:       5:
; LIMI2-NEXT:    call void @retI32()
; LIMI2-NEXT:    br label [[TMP7]]
; LIMI2:       6:
; LIMI2-NEXT:    call void [[FP]]()
; LIMI2-NEXT:    br label [[TMP7]]
; LIMI2:       7:
; LIMI2-NEXT:    ret void
;
; LIMI0-LABEL: @non_matching_fp2(
; LIMI0-NEXT:    [[FP1:%.*]] = select i1 [[C1:%.*]], ptr @retI32, ptr @takeI32
; LIMI0-NEXT:    [[FP2:%.*]] = select i1 [[C2:%.*]], ptr @retFloatTakeFloat, ptr [[UNKNOWN:%.*]]
; LIMI0-NEXT:    [[FP:%.*]] = select i1 [[C:%.*]], ptr [[FP1]], ptr [[FP2]]
; LIMI0-NEXT:    call void [[FP]]()
; LIMI0-NEXT:    ret void
;
; CWRLD-LABEL: @non_matching_fp2(
; CWRLD-NEXT:    [[FP1:%.*]] = select i1 [[C1:%.*]], ptr @retI32, ptr @takeI32
; CWRLD-NEXT:    [[FP2:%.*]] = select i1 [[C2:%.*]], ptr @retFloatTakeFloat, ptr [[UNKNOWN:%.*]]
; CWRLD-NEXT:    [[FP:%.*]] = select i1 [[C:%.*]], ptr [[FP1]], ptr [[FP2]]
; CWRLD-NEXT:    [[TMP1:%.*]] = icmp eq ptr [[FP]], @takeI32
; CWRLD-NEXT:    br i1 [[TMP1]], label [[TMP2:%.*]], label [[TMP3:%.*]]
; CWRLD:       2:
; CWRLD-NEXT:    call void @takeI32()
; CWRLD-NEXT:    br label [[TMP21:%.*]]
; CWRLD:       3:
; CWRLD-NEXT:    [[TMP4:%.*]] = icmp eq ptr [[FP]], @retI32
; CWRLD-NEXT:    br i1 [[TMP4]], label [[TMP5:%.*]], label [[TMP6:%.*]]
; CWRLD:       5:
; CWRLD-NEXT:    call void @retI32()
; CWRLD-NEXT:    br label [[TMP21]]
; CWRLD:       6:
; CWRLD-NEXT:    [[TMP7:%.*]] = icmp eq ptr [[FP]], @func3
; CWRLD-NEXT:    br i1 [[TMP7]], label [[TMP8:%.*]], label [[TMP9:%.*]]
; CWRLD:       8:
; CWRLD-NEXT:    call void @func3()
; CWRLD-NEXT:    br label [[TMP21]]
; CWRLD:       9:
; CWRLD-NEXT:    [[TMP10:%.*]] = icmp eq ptr [[FP]], @func4
; CWRLD-NEXT:    br i1 [[TMP10]], label [[TMP11:%.*]], label [[TMP12:%.*]]
; CWRLD:       11:
; CWRLD-NEXT:    call void @func4()
; CWRLD-NEXT:    br label [[TMP21]]
; CWRLD:       12:
; CWRLD-NEXT:    [[TMP13:%.*]] = icmp eq ptr [[FP]], @retFloatTakeFloat
; CWRLD-NEXT:    br i1 [[TMP13]], label [[TMP14:%.*]], label [[TMP15:%.*]]
; CWRLD:       14:
; CWRLD-NEXT:    call void @retFloatTakeFloat()
; CWRLD-NEXT:    br label [[TMP21]]
; CWRLD:       15:
; CWRLD-NEXT:    [[TMP16:%.*]] = icmp eq ptr [[FP]], @retFloatTakeFloatFloatNoundef
; CWRLD-NEXT:    br i1 [[TMP16]], label [[TMP17:%.*]], label [[TMP18:%.*]]
; CWRLD:       17:
; CWRLD-NEXT:    call void @retFloatTakeFloatFloatNoundef()
; CWRLD-NEXT:    br label [[TMP21]]
; CWRLD:       18:
; CWRLD-NEXT:    br i1 true, label [[TMP19:%.*]], label [[TMP20:%.*]]
; CWRLD:       19:
; CWRLD-NEXT:    call void @void()
; CWRLD-NEXT:    br label [[TMP21]]
; CWRLD:       20:
; CWRLD-NEXT:    unreachable
; CWRLD:       21:
; CWRLD-NEXT:    ret void
;
  %fp1 = select i1 %c1, ptr @retI32, ptr @takeI32
  %fp2 = select i1 %c2, ptr @retFloatTakeFloat, ptr %unknown
  %fp = select i1 %c, ptr %fp1, ptr %fp2
  call void %fp()
  ret void
}

define i32 @non_matching_unknown(i1 %c, ptr %fn) {
; OUNLM-LABEL: @non_matching_unknown(
; OUNLM-NEXT:    [[FP:%.*]] = select i1 [[C:%.*]], ptr @retI32, ptr [[FN:%.*]]
; OUNLM-NEXT:    [[TMP1:%.*]] = icmp eq ptr [[FP]], @retI32
; OUNLM-NEXT:    br i1 [[TMP1]], label [[TMP2:%.*]], label [[TMP3:%.*]]
; OUNLM:       2:
; OUNLM-NEXT:    [[CALL1:%.*]] = call i32 @retI32(i32 42)
; OUNLM-NEXT:    br label [[TMP4:%.*]]
; OUNLM:       3:
; OUNLM-NEXT:    [[CALL2:%.*]] = call i32 [[FP]](i32 42)
; OUNLM-NEXT:    br label [[TMP4]]
; OUNLM:       4:
; OUNLM-NEXT:    [[CALL_PHI:%.*]] = phi i32 [ [[CALL1]], [[TMP2]] ], [ [[CALL2]], [[TMP3]] ]
; OUNLM-NEXT:    ret i32 [[CALL_PHI]]
;
; LIMI2-LABEL: @non_matching_unknown(
; LIMI2-NEXT:    [[FP:%.*]] = select i1 [[C:%.*]], ptr @retI32, ptr [[FN:%.*]]
; LIMI2-NEXT:    [[TMP1:%.*]] = icmp eq ptr [[FP]], @retI32
; LIMI2-NEXT:    br i1 [[TMP1]], label [[TMP2:%.*]], label [[TMP3:%.*]]
; LIMI2:       2:
; LIMI2-NEXT:    [[CALL1:%.*]] = call i32 @retI32(i32 42)
; LIMI2-NEXT:    br label [[TMP4:%.*]]
; LIMI2:       3:
; LIMI2-NEXT:    [[CALL2:%.*]] = call i32 [[FP]](i32 42)
; LIMI2-NEXT:    br label [[TMP4]]
; LIMI2:       4:
; LIMI2-NEXT:    [[CALL_PHI:%.*]] = phi i32 [ [[CALL1]], [[TMP2]] ], [ [[CALL2]], [[TMP3]] ]
; LIMI2-NEXT:    ret i32 [[CALL_PHI]]
;
; LIMI0-LABEL: @non_matching_unknown(
; LIMI0-NEXT:    [[FP:%.*]] = select i1 [[C:%.*]], ptr @retI32, ptr [[FN:%.*]]
; LIMI0-NEXT:    [[CALL:%.*]] = call i32 [[FP]](i32 42)
; LIMI0-NEXT:    ret i32 [[CALL]]
;
; CWRLD-LABEL: @non_matching_unknown(
; CWRLD-NEXT:    [[FP:%.*]] = select i1 [[C:%.*]], ptr @retI32, ptr [[FN:%.*]]
; CWRLD-NEXT:    [[TMP1:%.*]] = icmp eq ptr [[FP]], @func3
; CWRLD-NEXT:    br i1 [[TMP1]], label [[TMP2:%.*]], label [[TMP3:%.*]]
; CWRLD:       2:
; CWRLD-NEXT:    [[CALL1:%.*]] = call i32 @func3(i32 42)
; CWRLD-NEXT:    br label [[TMP24:%.*]]
; CWRLD:       3:
; CWRLD-NEXT:    [[TMP4:%.*]] = icmp eq ptr [[FP]], @func4
; CWRLD-NEXT:    br i1 [[TMP4]], label [[TMP5:%.*]], label [[TMP6:%.*]]
; CWRLD:       5:
; CWRLD-NEXT:    [[CALL2:%.*]] = call i32 @func4(i32 42)
; CWRLD-NEXT:    br label [[TMP24]]
; CWRLD:       6:
; CWRLD-NEXT:    [[TMP7:%.*]] = icmp eq ptr [[FP]], @retI32
; CWRLD-NEXT:    br i1 [[TMP7]], label [[TMP8:%.*]], label [[TMP9:%.*]]
; CWRLD:       8:
; CWRLD-NEXT:    [[CALL3:%.*]] = call i32 @retI32(i32 42)
; CWRLD-NEXT:    br label [[TMP24]]
; CWRLD:       9:
; CWRLD-NEXT:    [[TMP10:%.*]] = icmp eq ptr [[FP]], @takeI32
; CWRLD-NEXT:    br i1 [[TMP10]], label [[TMP11:%.*]], label [[TMP12:%.*]]
; CWRLD:       11:
; CWRLD-NEXT:    [[CALL4:%.*]] = call i32 @takeI32(i32 42)
; CWRLD-NEXT:    br label [[TMP24]]
; CWRLD:       12:
; CWRLD-NEXT:    [[TMP13:%.*]] = icmp eq ptr [[FP]], @retFloatTakeFloat
; CWRLD-NEXT:    br i1 [[TMP13]], label [[TMP14:%.*]], label [[TMP18:%.*]]
; CWRLD:       14:
; CWRLD-NEXT:    [[TMP15:%.*]] = bitcast i32 42 to float
; CWRLD-NEXT:    [[TMP16:%.*]] = call float @retFloatTakeFloat(float [[TMP15]])
; CWRLD-NEXT:    [[TMP17:%.*]] = bitcast float [[TMP16]] to i32
; CWRLD-NEXT:    br label [[TMP24]]
; CWRLD:       18:
; CWRLD-NEXT:    [[TMP19:%.*]] = icmp eq ptr [[FP]], @retFloatTakeFloatFloatNoundef
; CWRLD-NEXT:    br i1 [[TMP19]], label [[TMP20:%.*]], label [[TMP21:%.*]]
; CWRLD:       20:
; CWRLD-NEXT:    [[CALL5:%.*]] = call i32 @retFloatTakeFloatFloatNoundef(i32 42)
; CWRLD-NEXT:    br label [[TMP24]]
; CWRLD:       21:
; CWRLD-NEXT:    br i1 true, label [[TMP22:%.*]], label [[TMP23:%.*]]
; CWRLD:       22:
; CWRLD-NEXT:    [[CALL6:%.*]] = call i32 @void(i32 42)
; CWRLD-NEXT:    br label [[TMP24]]
; CWRLD:       23:
; CWRLD-NEXT:    unreachable
; CWRLD:       24:
; CWRLD-NEXT:    [[CALL_PHI:%.*]] = phi i32 [ [[CALL1]], [[TMP2]] ], [ [[CALL2]], [[TMP5]] ], [ [[CALL3]], [[TMP8]] ], [ [[CALL4]], [[TMP11]] ], [ [[TMP17]], [[TMP14]] ], [ [[CALL5]], [[TMP20]] ], [ [[CALL6]], [[TMP22]] ]
; CWRLD-NEXT:    ret i32 [[CALL_PHI]]
;
  %fp = select i1 %c, ptr @retI32, ptr %fn
  %call = call i32 %fp(i32 42)
  ret i32 %call
}

; This function is used in a "direct" call but with a different signature.
; We check that it does not show up above in any of the if-cascades because
; the address is not actually taken.
declare void @usedOnlyInCastedDirectCall(i32)
define void @usedOnlyInCastedDirectCallCaller() {
; CHECK-LABEL: @usedOnlyInCastedDirectCallCaller(
; CHECK-NEXT:    call void @usedOnlyInCastedDirectCall()
; CHECK-NEXT:    ret void
;
  call void @usedOnlyInCastedDirectCall()
  ret void
}

define internal void @usedByGlobal() {
; CHECK-LABEL: @usedByGlobal(
; CHECK-NEXT:    ret void
;
  ret void
}
@G = global ptr @usedByGlobal

define void @broker(ptr %unknown) !callback !0 {
; OWRDL-LABEL: @broker(
; OWRDL-NEXT:    call void [[UNKNOWN:%.*]]()
; OWRDL-NEXT:    ret void
;
; CWRLD-LABEL: @broker(
; CWRLD-NEXT:    [[TMP1:%.*]] = icmp eq ptr [[UNKNOWN:%.*]], @func3
; CWRLD-NEXT:    br i1 [[TMP1]], label [[TMP2:%.*]], label [[TMP3:%.*]]
; CWRLD:       2:
; CWRLD-NEXT:    call void @func3()
; CWRLD-NEXT:    br label [[TMP21:%.*]]
; CWRLD:       3:
; CWRLD-NEXT:    [[TMP4:%.*]] = icmp eq ptr [[UNKNOWN]], @func4
; CWRLD-NEXT:    br i1 [[TMP4]], label [[TMP5:%.*]], label [[TMP6:%.*]]
; CWRLD:       5:
; CWRLD-NEXT:    call void @func4()
; CWRLD-NEXT:    br label [[TMP21]]
; CWRLD:       6:
; CWRLD-NEXT:    [[TMP7:%.*]] = icmp eq ptr [[UNKNOWN]], @retI32
; CWRLD-NEXT:    br i1 [[TMP7]], label [[TMP8:%.*]], label [[TMP9:%.*]]
; CWRLD:       8:
; CWRLD-NEXT:    call void @retI32()
; CWRLD-NEXT:    br label [[TMP21]]
; CWRLD:       9:
; CWRLD-NEXT:    [[TMP10:%.*]] = icmp eq ptr [[UNKNOWN]], @takeI32
; CWRLD-NEXT:    br i1 [[TMP10]], label [[TMP11:%.*]], label [[TMP12:%.*]]
; CWRLD:       11:
; CWRLD-NEXT:    call void @takeI32()
; CWRLD-NEXT:    br label [[TMP21]]
; CWRLD:       12:
; CWRLD-NEXT:    [[TMP13:%.*]] = icmp eq ptr [[UNKNOWN]], @retFloatTakeFloat
; CWRLD-NEXT:    br i1 [[TMP13]], label [[TMP14:%.*]], label [[TMP15:%.*]]
; CWRLD:       14:
; CWRLD-NEXT:    call void @retFloatTakeFloat()
; CWRLD-NEXT:    br label [[TMP21]]
; CWRLD:       15:
; CWRLD-NEXT:    [[TMP16:%.*]] = icmp eq ptr [[UNKNOWN]], @retFloatTakeFloatFloatNoundef
; CWRLD-NEXT:    br i1 [[TMP16]], label [[TMP17:%.*]], label [[TMP18:%.*]]
; CWRLD:       17:
; CWRLD-NEXT:    call void @retFloatTakeFloatFloatNoundef()
; CWRLD-NEXT:    br label [[TMP21]]
; CWRLD:       18:
; CWRLD-NEXT:    br i1 true, label [[TMP19:%.*]], label [[TMP20:%.*]]
; CWRLD:       19:
; CWRLD-NEXT:    call void @void()
; CWRLD-NEXT:    br label [[TMP21]]
; CWRLD:       20:
; CWRLD-NEXT:    unreachable
; CWRLD:       21:
; CWRLD-NEXT:    ret void
;
  call void %unknown()
  ret void
}

define void @func6() {
; CHECK-LABEL: @func6(
; CHECK-NEXT:    call void @broker(ptr nocapture nofree noundef nonnull @func3)
; CHECK-NEXT:    ret void
;
  call void @broker(ptr @func3)
  ret void
}

; Cannot be internal_good as it is internal and we see all uses.
; Can be func4 since it escapes.
define void @func7(ptr %unknown) {
; UPTO2-LABEL: @func7(
; UPTO2-NEXT:    [[TMP1:%.*]] = icmp eq ptr [[UNKNOWN:%.*]], @func3
; UPTO2-NEXT:    br i1 [[TMP1]], label [[TMP2:%.*]], label [[TMP3:%.*]]
; UPTO2:       2:
; UPTO2-NEXT:    call void @func3()
; UPTO2-NEXT:    br label [[TMP6:%.*]]
; UPTO2:       3:
; UPTO2-NEXT:    br i1 true, label [[TMP4:%.*]], label [[TMP5:%.*]]
; UPTO2:       4:
; UPTO2-NEXT:    call void @func4()
; UPTO2-NEXT:    br label [[TMP6]]
; UPTO2:       5:
; UPTO2-NEXT:    unreachable
; UPTO2:       6:
; UPTO2-NEXT:    ret void
;
; LIMI0-LABEL: @func7(
; LIMI0-NEXT:    call void [[UNKNOWN:%.*]](), !callees !1
; LIMI0-NEXT:    ret void
;
  call void %unknown(), !callees !2
  ret void
}

; Check there's no crash if something that isn't a function appears in !callees
define void @undef_in_callees() {
; UNLIM-LABEL: @undef_in_callees(
; UNLIM-NEXT:  cond.end.i:
; UNLIM-NEXT:    call void undef(ptr undef, i32 undef, ptr undef), !callees !2
; UNLIM-NEXT:    ret void
;
; LIMI2-LABEL: @undef_in_callees(
; LIMI2-NEXT:  cond.end.i:
; LIMI2-NEXT:    call void undef(ptr undef, i32 undef, ptr undef), !callees !4
; LIMI2-NEXT:    ret void
;
; LIMI0-LABEL: @undef_in_callees(
; LIMI0-NEXT:  cond.end.i:
; LIMI0-NEXT:    call void undef(ptr undef, i32 undef, ptr undef), !callees !6
; LIMI0-NEXT:    ret void
;
cond.end.i:
  call void undef(ptr undef, i32 undef, ptr undef), !callees !3
  ret void
}

define void @as_cast(ptr %arg) {
; OWRDL-LABEL: @as_cast(
; OWRDL-NEXT:    [[FP:%.*]] = load ptr addrspace(1), ptr [[ARG:%.*]], align 8
; OWRDL-NEXT:    tail call addrspace(1) void [[FP]]()
; OWRDL-NEXT:    ret void
;
; CWRLD-LABEL: @as_cast(
; CWRLD-NEXT:    [[FP:%.*]] = load ptr addrspace(1), ptr [[ARG:%.*]], align 8
; CWRLD-NEXT:    [[FP_AS0:%.*]] = addrspacecast ptr addrspace(1) [[FP]] to ptr
; CWRLD-NEXT:    [[TMP1:%.*]] = icmp eq ptr [[FP_AS0]], @func3
; CWRLD-NEXT:    br i1 [[TMP1]], label [[TMP2:%.*]], label [[TMP3:%.*]]
; CWRLD:       2:
; CWRLD-NEXT:    tail call void @func3()
; CWRLD-NEXT:    br label [[TMP21:%.*]]
; CWRLD:       3:
; CWRLD-NEXT:    [[TMP4:%.*]] = icmp eq ptr [[FP_AS0]], @func4
; CWRLD-NEXT:    br i1 [[TMP4]], label [[TMP5:%.*]], label [[TMP6:%.*]]
; CWRLD:       5:
; CWRLD-NEXT:    tail call void @func4()
; CWRLD-NEXT:    br label [[TMP21]]
; CWRLD:       6:
; CWRLD-NEXT:    [[TMP7:%.*]] = icmp eq ptr [[FP_AS0]], @retI32
; CWRLD-NEXT:    br i1 [[TMP7]], label [[TMP8:%.*]], label [[TMP9:%.*]]
; CWRLD:       8:
; CWRLD-NEXT:    call void @retI32()
; CWRLD-NEXT:    br label [[TMP21]]
; CWRLD:       9:
; CWRLD-NEXT:    [[TMP10:%.*]] = icmp eq ptr [[FP_AS0]], @takeI32
; CWRLD-NEXT:    br i1 [[TMP10]], label [[TMP11:%.*]], label [[TMP12:%.*]]
; CWRLD:       11:
; CWRLD-NEXT:    call void @takeI32()
; CWRLD-NEXT:    br label [[TMP21]]
; CWRLD:       12:
; CWRLD-NEXT:    [[TMP13:%.*]] = icmp eq ptr [[FP_AS0]], @retFloatTakeFloat
; CWRLD-NEXT:    br i1 [[TMP13]], label [[TMP14:%.*]], label [[TMP15:%.*]]
; CWRLD:       14:
; CWRLD-NEXT:    call void @retFloatTakeFloat()
; CWRLD-NEXT:    br label [[TMP21]]
; CWRLD:       15:
; CWRLD-NEXT:    [[TMP16:%.*]] = icmp eq ptr [[FP_AS0]], @retFloatTakeFloatFloatNoundef
; CWRLD-NEXT:    br i1 [[TMP16]], label [[TMP17:%.*]], label [[TMP18:%.*]]
; CWRLD:       17:
; CWRLD-NEXT:    call void @retFloatTakeFloatFloatNoundef()
; CWRLD-NEXT:    br label [[TMP21]]
; CWRLD:       18:
; CWRLD-NEXT:    br i1 true, label [[TMP19:%.*]], label [[TMP20:%.*]]
; CWRLD:       19:
; CWRLD-NEXT:    tail call void @void()
; CWRLD-NEXT:    br label [[TMP21]]
; CWRLD:       20:
; CWRLD-NEXT:    unreachable
; CWRLD:       21:
; CWRLD-NEXT:    ret void
;
  %fp = load ptr addrspace(1), ptr %arg, align 8
  tail call addrspace(1) void %fp()
  ret void
}

!0 = !{!1}
!1 = !{i64 0, i1 false}
!2 = !{ptr @func3, ptr @func4}
!3 = distinct !{ptr undef, ptr null}

; UTC_ARGS: --disable

; DOT-DAG: Node[[FUNC1:0x[a-z0-9]+]] [shape=record,label="{func1}"];
; DOT-DAG: Node[[FUNC2:0x[a-z0-9]+]] [shape=record,label="{func2}"];
; DOT-DAG: Node[[FUNC3:0x[a-z0-9]+]] [shape=record,label="{func3}"];
; DOT-DAG: Node[[FUNC4:0x[a-z0-9]+]] [shape=record,label="{func4}"];
; DOT-DAG: Node[[FUNC5:0x[a-z0-9]+]] [shape=record,label="{func5}"];
; DOT-DAG: Node[[FUNC6:0x[a-z0-9]+]] [shape=record,label="{func6}"];
; DOT-DAG: Node[[FUNC7:0x[a-z0-9]+]] [shape=record,label="{func7}"];

; DOT-DAG: Node[[BROKER:0x[a-z0-9]+]] [shape=record,label="{broker}"];

; DOT-DAG: Node[[FUNC1]] -> Node[[FUNC3]];
; DOT-DAG: Node[[FUNC2]] -> Node[[FUNC4]];
; DOT-DAG: Node[[FUNC5]] -> Node[[FUNC3]];
; DOT-DAG: Node[[FUNC5]] -> Node[[FUNC4]];

; DOT-DAG: Node[[FUNC6]] -> Node[[BROKER]];

; This one gets added because of the callback metadata.
; DOT-DAG: Node[[FUNC6]] -> Node[[FUNC3]];

; These ones are added because of the callees metadata.
; DOT-DAG: Node[[FUNC7]] -> Node[[FUNC3]];
; DOT-DAG: Node[[FUNC7]] -> Node[[FUNC4]];

; UTC_ARGS: --enable

;.
; CHECK: attributes #[[ATTR0:[0-9]+]] = { mustprogress nofree norecurse nosync nounwind willreturn memory(none) }
;.
; UNLIM: [[META0:![0-9]+]] = !{!1}
; UNLIM: [[META1:![0-9]+]] = !{i64 0, i1 false}
; UNLIM: [[META2:![0-9]+]] = distinct !{ptr undef, ptr null}
;.
; LIMI2: [[META0:![0-9]+]] = !{ptr @void, ptr @retFloatTakeFloat}
; LIMI2: [[META1:![0-9]+]] = !{ptr @void}
; LIMI2: [[META2:![0-9]+]] = !{!3}
; LIMI2: [[META3:![0-9]+]] = !{i64 0, i1 false}
; LIMI2: [[META4:![0-9]+]] = distinct !{ptr undef, ptr null}
;.
; LIMI0: [[META0:![0-9]+]] = !{ptr @func4, ptr @internal_good}
; LIMI0: [[META1:![0-9]+]] = !{ptr @func3, ptr @func4}
; LIMI0: [[META2:![0-9]+]] = !{ptr @takeI32, ptr @retI32, ptr @void, ptr @retFloatTakeFloat}
; LIMI0: [[META3:![0-9]+]] = !{ptr @takeI32, ptr @retI32, ptr @void}
; LIMI0: [[META4:![0-9]+]] = !{!5}
; LIMI0: [[META5:![0-9]+]] = !{i64 0, i1 false}
; LIMI0: [[META6:![0-9]+]] = distinct !{ptr undef, ptr null}
;.
;; NOTE: These prefixes are unused and the list is autogenerated. Do not add tests below this line:
; DOT: {{.*}}
