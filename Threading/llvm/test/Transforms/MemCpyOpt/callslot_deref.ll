; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -passes=memcpyopt -verify-memoryssa | FileCheck %s
target datalayout = "e-i64:64-f80:128-n8:16:32:64-S128"

declare void @llvm.memcpy.p0.p0.i64(ptr nocapture, ptr nocapture readonly, i64, i1) unnamed_addr nounwind
declare void @llvm.memset.p0.i64(ptr nocapture, i8, i64, i1) nounwind

; all bytes of %dst that are touch by the memset are dereferenceable
define void @must_remove_memcpy(ptr noalias nocapture writable dereferenceable(4096) %dst) nofree nosync {
; CHECK-LABEL: @must_remove_memcpy(
; CHECK-NEXT:    [[SRC:%.*]] = alloca [4096 x i8], align 1
; CHECK-NEXT:    call void @llvm.memset.p0.i64(ptr [[DST:%.*]], i8 0, i64 4096, i1 false)
; CHECK-NEXT:    ret void
;
  %src = alloca [4096 x i8], align 1
  call void @llvm.memset.p0.i64(ptr %src, i8 0, i64 4096, i1 false)
  call void @llvm.memcpy.p0.p0.i64(ptr %dst, ptr %src, i64 4096, i1 false) #2
  ret void
}

; memset touch more bytes than those guaranteed to be dereferenceable
; We can't remove the memcpy, but we can turn it into an independent memset.
define void @must_not_remove_memcpy(ptr noalias nocapture writable dereferenceable(1024) %dst) nofree nosync {
; CHECK-LABEL: @must_not_remove_memcpy(
; CHECK-NEXT:    [[SRC:%.*]] = alloca [4096 x i8], align 1
; CHECK-NEXT:    call void @llvm.memset.p0.i64(ptr [[SRC]], i8 0, i64 4096, i1 false)
; CHECK-NEXT:    call void @llvm.memset.p0.i64(ptr [[DST:%.*]], i8 0, i64 4096, i1 false)
; CHECK-NEXT:    ret void
;
  %src = alloca [4096 x i8], align 1
  call void @llvm.memset.p0.i64(ptr %src, i8 0, i64 4096, i1 false)
  call void @llvm.memcpy.p0.p0.i64(ptr %dst, ptr %src, i64 4096, i1 false) #2
  ret void
}
