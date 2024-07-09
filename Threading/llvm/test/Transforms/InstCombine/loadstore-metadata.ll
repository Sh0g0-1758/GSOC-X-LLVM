; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=instcombine -S < %s | FileCheck %s

target datalayout = "e-m:e-p:64:64:64-i64:64-f80:128-n8:16:32:64-S128"

define i32 @test_load_cast_combine_tbaa(ptr %ptr) {
; Ensure (cast (load (...))) -> (load (cast (...))) preserves TBAA.
; CHECK-LABEL: @test_load_cast_combine_tbaa(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[L1:%.*]] = load i32, ptr [[PTR:%.*]], align 4, !tbaa [[TBAA0:![0-9]+]]
; CHECK-NEXT:    ret i32 [[L1]]
;
entry:
  %l = load float, ptr %ptr, !tbaa !0
  %c = bitcast float %l to i32
  ret i32 %c
}

define i32 @test_load_cast_combine_noalias(ptr %ptr) {
; Ensure (cast (load (...))) -> (load (cast (...))) preserves no-alias metadata.
; CHECK-LABEL: @test_load_cast_combine_noalias(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[L1:%.*]] = load i32, ptr [[PTR:%.*]], align 4, !alias.scope !3, !noalias !3
; CHECK-NEXT:    ret i32 [[L1]]
;
entry:
  %l = load float, ptr %ptr, !alias.scope !3, !noalias !3
  %c = bitcast float %l to i32
  ret i32 %c
}

define float @test_load_cast_combine_range(ptr %ptr) {
; Ensure (cast (load (...))) -> (load (cast (...))) drops range metadata. It
; would be nice to preserve or update it somehow but this is hard when moving
; between types.
; CHECK-LABEL: @test_load_cast_combine_range(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[L1:%.*]] = load float, ptr [[PTR:%.*]], align 4
; CHECK-NEXT:    ret float [[L1]]
;
entry:
  %l = load i32, ptr %ptr, !range !6
  %c = bitcast i32 %l to float
  ret float %c
}

define i32 @test_load_cast_combine_invariant(ptr %ptr) {
; Ensure (cast (load (...))) -> (load (cast (...))) preserves invariant metadata.
; CHECK-LABEL: @test_load_cast_combine_invariant(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[L1:%.*]] = load i32, ptr [[PTR:%.*]], align 4, !invariant.load !6
; CHECK-NEXT:    ret i32 [[L1]]
;
entry:
  %l = load float, ptr %ptr, !invariant.load !7
  %c = bitcast float %l to i32
  ret i32 %c
}

define i32 @test_load_cast_combine_nontemporal(ptr %ptr) {
; Ensure (cast (load (...))) -> (load (cast (...))) preserves nontemporal
; metadata.
; CHECK-LABEL: @test_load_cast_combine_nontemporal(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[L1:%.*]] = load i32, ptr [[PTR:%.*]], align 4, !nontemporal !7
; CHECK-NEXT:    ret i32 [[L1]]
;
entry:
  %l = load float, ptr %ptr, !nontemporal !8
  %c = bitcast float %l to i32
  ret i32 %c
}

define ptr @test_load_cast_combine_align(ptr %ptr) {
; Ensure (cast (load (...))) -> (load (cast (...))) preserves align
; metadata.
; CHECK-LABEL: @test_load_cast_combine_align(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[L:%.*]] = load ptr, ptr [[PTR:%.*]], align 8, !align !8
; CHECK-NEXT:    ret ptr [[L]]
;
entry:
  %l = load ptr, ptr %ptr, !align !9
  ret ptr %l
}

define ptr @test_load_cast_combine_deref(ptr %ptr) {
; Ensure (cast (load (...))) -> (load (cast (...))) preserves dereferenceable
; metadata.
; CHECK-LABEL: @test_load_cast_combine_deref(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[L:%.*]] = load ptr, ptr [[PTR:%.*]], align 8, !dereferenceable !8
; CHECK-NEXT:    ret ptr [[L]]
;
entry:
  %l = load ptr, ptr %ptr, !dereferenceable !9
  ret ptr %l
}

define ptr @test_load_cast_combine_deref_or_null(ptr %ptr) {
; Ensure (cast (load (...))) -> (load (cast (...))) preserves
; dereferenceable_or_null metadata.
; CHECK-LABEL: @test_load_cast_combine_deref_or_null(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[L:%.*]] = load ptr, ptr [[PTR:%.*]], align 8, !dereferenceable_or_null !8
; CHECK-NEXT:    ret ptr [[L]]
;
entry:
  %l = load ptr, ptr %ptr, !dereferenceable_or_null !9
  ret ptr %l
}

define void @test_load_cast_combine_loop(ptr %src, ptr %dst, i32 %n) {
; Ensure (cast (load (...))) -> (load (cast (...))) preserves loop access
; metadata.
; CHECK-LABEL: @test_load_cast_combine_loop(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[I:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[I_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = sext i32 [[I]] to i64
; CHECK-NEXT:    [[SRC_GEP:%.*]] = getelementptr inbounds float, ptr [[SRC:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP1:%.*]] = sext i32 [[I]] to i64
; CHECK-NEXT:    [[DST_GEP:%.*]] = getelementptr inbounds i32, ptr [[DST:%.*]], i64 [[TMP1]]
; CHECK-NEXT:    [[L1:%.*]] = load i32, ptr [[SRC_GEP]], align 4, !llvm.access.group [[ACC_GRP9:![0-9]+]]
; CHECK-NEXT:    store i32 [[L1]], ptr [[DST_GEP]], align 4
; CHECK-NEXT:    [[I_NEXT]] = add i32 [[I]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[I_NEXT]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[LOOP]], label [[EXIT:%.*]], !llvm.loop [[LOOP1:![0-9]+]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop ]
  %src.gep = getelementptr inbounds float, ptr %src, i32 %i
  %dst.gep = getelementptr inbounds i32, ptr %dst, i32 %i
  %l = load float, ptr %src.gep, !llvm.access.group !10
  %c = bitcast float %l to i32
  store i32 %c, ptr %dst.gep
  %i.next = add i32 %i, 1
  %cmp = icmp slt i32 %i.next, %n
  br i1 %cmp, label %loop, label %exit, !llvm.loop !1

exit:
  ret void
}

define void @test_load_cast_combine_nonnull(ptr %ptr) {
; CHECK-LABEL: @test_load_cast_combine_nonnull(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[P:%.*]] = load ptr, ptr [[PTR:%.*]], align 8, !nonnull !6
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr i8, ptr [[PTR]], i64 336
; CHECK-NEXT:    store ptr [[P]], ptr [[GEP]], align 8
; CHECK-NEXT:    ret void
;
entry:
  %p = load ptr, ptr %ptr, !nonnull !{}
  %gep = getelementptr ptr, ptr %ptr, i32 42
  store ptr %p, ptr %gep
  ret void
}

define i32 @test_load_cast_combine_noundef(ptr %ptr) {
; CHECK-LABEL: @test_load_cast_combine_noundef(
; CHECK-NEXT:    [[L1:%.*]] = load i32, ptr [[PTR:%.*]], align 4, !noundef !6
; CHECK-NEXT:    ret i32 [[L1]]
;
  %l = load float, ptr %ptr, !noundef !{}
  %c = bitcast float %l to i32
  ret i32 %c
}

!0 = !{!1, !1, i64 0}
!1 = !{!"scalar type", !2}
!2 = !{!"root"}
!3 = !{!4}
!4 = distinct !{!4, !5}
!5 = distinct !{!5}
!6 = !{i32 0, i32 42}
!7 = !{}
!8 = !{i32 1}
!9 = !{i64 8}
!10 = distinct !{}