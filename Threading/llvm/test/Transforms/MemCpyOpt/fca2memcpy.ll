; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=memcpyopt -S < %s -verify-memoryssa | FileCheck %s

target datalayout = "e-i64:64-f80:128-n8:16:32:64"
target triple = "x86_64-unknown-linux-gnu"

%S = type { ptr, i8, i32 }

define void @copy(ptr %src, ptr %dst) {
; CHECK-LABEL: @copy(
; CHECK-NEXT:    call void @llvm.memmove.p0.p0.i64(ptr align 8 [[DST:%.*]], ptr align 8 [[SRC:%.*]], i64 16, i1 false)
; CHECK-NEXT:    ret void
;
  %1 = load %S, ptr %src
  store %S %1, ptr %dst
  ret void
}

define void @noaliassrc(ptr noalias %src, ptr %dst) {
; CHECK-LABEL: @noaliassrc(
; CHECK-NEXT:    call void @llvm.memcpy.p0.p0.i64(ptr align 8 [[DST:%.*]], ptr align 8 [[SRC:%.*]], i64 16, i1 false)
; CHECK-NEXT:    ret void
;
  %1 = load %S, ptr %src
  store %S %1, ptr %dst
  ret void
}

define void @noaliasdst(ptr %src, ptr noalias %dst) {
; CHECK-LABEL: @noaliasdst(
; CHECK-NEXT:    call void @llvm.memcpy.p0.p0.i64(ptr align 8 [[DST:%.*]], ptr align 8 [[SRC:%.*]], i64 16, i1 false)
; CHECK-NEXT:    ret void
;
  %1 = load %S, ptr %src
  store %S %1, ptr %dst
  ret void
}

define void @destroysrc(ptr %src, ptr %dst) {
; CHECK-LABEL: @destroysrc(
; CHECK-NEXT:    [[TMP1:%.*]] = load [[S:%.*]], ptr [[SRC:%.*]], align 8
; CHECK-NEXT:    call void @llvm.memset.p0.i64(ptr align 8 [[SRC]], i8 0, i64 16, i1 false)
; CHECK-NEXT:    store [[S]] [[TMP1]], ptr [[DST:%.*]], align 8
; CHECK-NEXT:    ret void
;
  %1 = load %S, ptr %src
  store %S zeroinitializer, ptr %src
  store %S %1, ptr %dst
  ret void
}

define void @destroynoaliassrc(ptr noalias %src, ptr %dst) {
; CHECK-LABEL: @destroynoaliassrc(
; CHECK-NEXT:    call void @llvm.memcpy.p0.p0.i64(ptr align 8 [[DST:%.*]], ptr align 8 [[SRC]], i64 16, i1 false)
; CHECK-NEXT:    call void @llvm.memset.p0.i64(ptr align 8 [[SRC:%.*]], i8 0, i64 16, i1 false)
; CHECK-NEXT:    ret void
;
  %1 = load %S, ptr %src
  store %S zeroinitializer, ptr %src
  store %S %1, ptr %dst
  ret void
}

define void @copyalias(ptr %src, ptr %dst) {
; CHECK-LABEL: @copyalias(
; CHECK-NEXT:    [[TMP1:%.*]] = load [[S:%.*]], ptr [[SRC:%.*]], align 8
; CHECK-NEXT:    call void @llvm.memmove.p0.p0.i64(ptr align 8 [[DST:%.*]], ptr align 8 [[SRC]], i64 16, i1 false)
; CHECK-NEXT:    store [[S]] [[TMP1]], ptr [[DST]], align 8
; CHECK-NEXT:    ret void
;
  %1 = load %S, ptr %src
  %2 = load %S, ptr %src
  store %S %1, ptr %dst
  store %S %2, ptr %dst
  ret void
}

; If the store address is computed in a complex manner, make
; sure we lift the computation as well if needed and possible.
define void @addrproducer(ptr %src, ptr %dst) {
; CHECK-LABEL: @addrproducer(
; CHECK-NEXT:    [[DST2:%.*]] = getelementptr [[S:%.*]], ptr [[DST]], i64 1
; CHECK-NEXT:    call void @llvm.memmove.p0.p0.i64(ptr align 8 [[DST2]], ptr align 8 [[SRC:%.*]], i64 16, i1 false)
; CHECK-NEXT:    call void @llvm.memset.p0.i64(ptr align 8 [[DST:%.*]], i8 undef, i64 16, i1 false)
; CHECK-NEXT:    ret void
;
  %1 = load %S, ptr %src
  store %S undef, ptr %dst
  %dst2 = getelementptr %S , ptr %dst, i64 1
  store %S %1, ptr %dst2
  ret void
}

define void @aliasaddrproducer(ptr %src, ptr %dst, ptr %dstidptr) {
; CHECK-LABEL: @aliasaddrproducer(
; CHECK-NEXT:    [[TMP1:%.*]] = load [[S:%.*]], ptr [[SRC:%.*]], align 8
; CHECK-NEXT:    call void @llvm.memset.p0.i64(ptr align 8 [[DST:%.*]], i8 undef, i64 16, i1 false)
; CHECK-NEXT:    [[DSTINDEX:%.*]] = load i32, ptr [[DSTIDPTR:%.*]], align 4
; CHECK-NEXT:    [[DST2:%.*]] = getelementptr [[S]], ptr [[DST]], i32 [[DSTINDEX]]
; CHECK-NEXT:    store [[S]] [[TMP1]], ptr [[DST2]], align 8
; CHECK-NEXT:    ret void
;
  %1 = load %S, ptr %src
  store %S undef, ptr %dst
  %dstindex = load i32, ptr %dstidptr
  %dst2 = getelementptr %S , ptr %dst, i32 %dstindex
  store %S %1, ptr %dst2
  ret void
}

define void @noaliasaddrproducer(ptr %src, ptr noalias %dst, ptr noalias %dstidptr) {
; CHECK-LABEL: @noaliasaddrproducer(
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, ptr [[DSTIDPTR:%.*]], align 4
; CHECK-NEXT:    [[DSTINDEX:%.*]] = or i32 [[TMP2]], 1
; CHECK-NEXT:    [[DST2:%.*]] = getelementptr [[S:%.*]], ptr [[DST:%.*]], i32 [[DSTINDEX]]
; CHECK-NEXT:    call void @llvm.memcpy.p0.p0.i64(ptr align 8 [[DST2]], ptr align 8 [[SRC]], i64 16, i1 false)
; CHECK-NEXT:    call void @llvm.memset.p0.i64(ptr align 8 [[SRC:%.*]], i8 undef, i64 16, i1 false)
; CHECK-NEXT:    ret void
;
  %1 = load %S, ptr %src
  store %S undef, ptr %src
  %2 = load i32, ptr %dstidptr
  %dstindex = or i32 %2, 1
  %dst2 = getelementptr %S , ptr %dst, i32 %dstindex
  store %S %1, ptr %dst2
  ret void
}

define void @throwing_call(ptr noalias %src, ptr %dst) {
; CHECK-LABEL: @throwing_call(
; CHECK-NEXT:    [[TMP1:%.*]] = load [[S:%.*]], ptr [[SRC:%.*]], align 8
; CHECK-NEXT:    call void @llvm.memset.p0.i64(ptr align 8 [[SRC]], i8 0, i64 16, i1 false)
; CHECK-NEXT:    call void @call() [[ATTR2:#.*]]
; CHECK-NEXT:    store [[S]] [[TMP1]], ptr [[DST:%.*]], align 8
; CHECK-NEXT:    ret void
;
  %1 = load %S, ptr %src
  store %S zeroinitializer, ptr %src
  call void @call() readnone
  store %S %1, ptr %dst
  ret void
}

declare void @call()
