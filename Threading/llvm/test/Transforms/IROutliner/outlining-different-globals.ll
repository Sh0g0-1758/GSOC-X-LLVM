; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes=verify,iroutliner -ir-outlining-no-cost < %s | FileCheck %s

; This test looks at the globals in the regions, and makes sure they are not
; outlined if they are different values.

@global1 = global i32 1, align 4
@global2 = global i32 2, align 4
@global3 = global i32 3, align 4
@global4 = global i32 4, align 4

define void @outline_globals1() {
; CHECK-LABEL: @outline_globals1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @outlined_ir_func_0(ptr @global1, ptr @global2)
; CHECK-NEXT:    ret void
;
entry:
  %0 = load i32, ptr @global1
  %1 = load i32, ptr @global2
  %2 = add i32 %0, %1
  ret void
}

define void @outline_globals2() {
; CHECK-LABEL: @outline_globals2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @outlined_ir_func_0(ptr @global3, ptr @global4)
; CHECK-NEXT:    ret void
;
entry:
  %0 = load i32, ptr @global3
  %1 = load i32, ptr @global4
  %2 = add i32 %0, %1
  ret void
}

; CHECK: define internal void @outlined_ir_func_0(ptr [[ARG0:%.*]], ptr [[ARG1:%.*]])
; CHECK: entry_to_outline:
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, ptr [[ARG0]]
; CHECK-NEXT:    [[TMP1:%.*]] = load i32, ptr [[ARG1]]
; CHECK-NEXT:    [[TMP2:%.*]] = add i32 [[TMP0]], [[TMP1]]
