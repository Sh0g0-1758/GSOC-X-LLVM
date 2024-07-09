; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

; Verify that memchr calls with constant arrays, or constant characters,
; or constant bounds are folded (or not) as expected.

declare ptr @memchr(ptr, i32, i64)

@ax = external global [0 x i8]
@a12345 = constant [5 x i8] c"\01\02\03\04\05"
@a123f45 = constant [5 x i8] c"\01\02\03\f4\05"


; Fold memchr(a12345, '\06', n) to null.

define ptr @fold_memchr_a12345_6_n(i64 %n) {
; CHECK-LABEL: @fold_memchr_a12345_6_n(
; CHECK-NEXT:    ret ptr null
;

  %res = call ptr @memchr(ptr @a12345, i32 6, i64 %n)
  ret ptr %res
}


; Fold memchr(a12345, '\04', 2) to null.

define ptr @fold_memchr_a12345_4_2() {
; CHECK-LABEL: @fold_memchr_a12345_4_2(
; CHECK-NEXT:    ret ptr null
;

  %res = call ptr @memchr(ptr @a12345, i32 4, i64 2)
  ret ptr %res
}


; Fold memchr(a12345, '\04', 3) to null.

define ptr @fold_memchr_a12345_4_3() {
; CHECK-LABEL: @fold_memchr_a12345_4_3(
; CHECK-NEXT:    ret ptr null
;

  %res = call ptr @memchr(ptr @a12345, i32 4, i64 3)
  ret ptr %res
}


; Fold memchr(a12345, '\03', 3) to a12345 + 2.

define ptr @fold_memchr_a12345_3_3() {
; CHECK-LABEL: @fold_memchr_a12345_3_3(
; CHECK-NEXT:    ret ptr getelementptr inbounds ([5 x i8], ptr @a12345, i64 0, i64 2)
;

  %res = call ptr @memchr(ptr @a12345, i32 3, i64 3)
  ret ptr %res
}


; Fold memchr(a12345, '\03', 9) to a12345 + 2.

define ptr @fold_memchr_a12345_3_9() {
; CHECK-LABEL: @fold_memchr_a12345_3_9(
; CHECK-NEXT:    ret ptr getelementptr inbounds ([5 x i8], ptr @a12345, i64 0, i64 2)
;

  %res = call ptr @memchr(ptr @a12345, i32 3, i64 9)
  ret ptr %res
}


; Fold memchr(a123f45, 500, 9) to a123f45 + 3 (verify that 500 is
; truncated to (unsigned char)500 == '\xf4')

define ptr @fold_memchr_a123f45_500_9() {
; CHECK-LABEL: @fold_memchr_a123f45_500_9(
; CHECK-NEXT:    ret ptr getelementptr inbounds ([5 x i8], ptr @a123f45, i64 0, i64 3)
;

  %res = call ptr @memchr(ptr @a123f45, i32 500, i64 9)
  ret ptr %res
}


; Fold memchr(a12345, '\03', n) to n < 3 ? null : a12345 + 2.

define ptr @fold_a12345_3_n(i64 %n) {
; CHECK-LABEL: @fold_a12345_3_n(
; CHECK-NEXT:    [[MEMCHR_CMP:%.*]] = icmp ult i64 [[N:%.*]], 3
; CHECK-NEXT:    [[RES:%.*]] = select i1 [[MEMCHR_CMP]], ptr null, ptr getelementptr inbounds ([5 x i8], ptr @a12345, i64 0, i64 2)
; CHECK-NEXT:    ret ptr [[RES]]
;

  %res = call ptr @memchr(ptr @a12345, i32 3, i64 %n)
  ret ptr %res
}


; Fold memchr(a12345, 259, n) to n < 3 ? null : a12345 + 2
; to verify the constant 259 is converted to unsigned char (yielding 3).

define ptr @fold_a12345_259_n(i64 %n) {
; CHECK-LABEL: @fold_a12345_259_n(
; CHECK-NEXT:    [[MEMCHR_CMP:%.*]] = icmp ult i64 [[N:%.*]], 3
; CHECK-NEXT:    [[RES:%.*]] = select i1 [[MEMCHR_CMP]], ptr null, ptr getelementptr inbounds ([5 x i8], ptr @a12345, i64 0, i64 2)
; CHECK-NEXT:    ret ptr [[RES]]
;

  %res = call ptr @memchr(ptr @a12345, i32 259, i64 %n)
  ret ptr %res
}


; Do no fold memchr(ax, 1, n).

define ptr @call_ax_1_n(i64 %n) {
; CHECK-LABEL: @call_ax_1_n(
; CHECK-NEXT:    [[RES:%.*]] = call ptr @memchr(ptr nonnull @ax, i32 1, i64 [[N:%.*]])
; CHECK-NEXT:    ret ptr [[RES]]
;

  %res = call ptr @memchr(ptr @ax, i32 1, i64 %n)
  ret ptr %res
}
