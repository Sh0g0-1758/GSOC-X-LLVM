; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

; OSS-Fuzz: https://bugs.chromium.org/p/oss-fuzz/issues/detail?id=5223
define void @test_bigalloc(ptr %dst) {
; CHECK-LABEL: @test_bigalloc(
; CHECK-NEXT:    [[TMP1:%.*]] = alloca [18446744069414584320 x i8], align 1
; CHECK-NEXT:    store ptr [[TMP1]], ptr [[DST:%.*]], align 8
; CHECK-NEXT:    ret void
;
  %1 = alloca i8, i864 -4294967296
  store ptr %1, ptr %dst
  ret void
}