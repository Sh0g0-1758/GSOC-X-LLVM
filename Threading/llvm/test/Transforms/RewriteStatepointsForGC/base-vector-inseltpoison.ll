; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=rewrite-statepoints-for-gc -S | FileCheck  %s


define ptr addrspace(1) @test(<2 x ptr addrspace(1)> %vec, i32 %idx) gc "statepoint-example" {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[OBJ:%.*]] = extractelement <2 x ptr addrspace(1)> [[VEC:%.*]], i32 [[IDX:%.*]]
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, ptr, i32, i32, ...) @llvm.experimental.gc.statepoint.p0(i64 2882400000, i32 0, ptr elementtype(void ()) @do_safepoint, i32 0, i32 0, i32 0, i32 0) [ "deopt"(), "gc-live"(ptr addrspace(1) [[OBJ]]) ]
; CHECK-NEXT:    [[OBJ_RELOCATED:%.*]] = call coldcc ptr addrspace(1) @llvm.experimental.gc.relocate.p1(token [[STATEPOINT_TOKEN]], i32 0, i32 0)
; CHECK-NEXT:    ret ptr addrspace(1) [[OBJ_RELOCATED]]
;
; Note that the second extractelement is actually redundant here.  A correct output would
; be to reuse the existing obj as a base since it is actually a base pointer.
entry:
  %obj = extractelement <2 x ptr addrspace(1)> %vec, i32 %idx
  call void @do_safepoint() [ "deopt"() ]
  ret ptr addrspace(1) %obj
}

define ptr addrspace(1) @test2(ptr %ptr, i1 %cnd, i32 %idx1, i32 %idx2) gc "statepoint-example" {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[CND:%.*]], label [[TAKEN:%.*]], label [[UNTAKEN:%.*]]
; CHECK:       taken:
; CHECK-NEXT:    [[OBJA:%.*]] = load <2 x ptr addrspace(1)>, ptr [[PTR:%.*]], align 16
; CHECK-NEXT:    br label [[MERGE:%.*]]
; CHECK:       untaken:
; CHECK-NEXT:    [[OBJB:%.*]] = load <2 x ptr addrspace(1)>, ptr [[PTR]], align 16
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       merge:
; CHECK-NEXT:    [[VEC:%.*]] = phi <2 x ptr addrspace(1)> [ [[OBJA]], [[TAKEN]] ], [ [[OBJB]], [[UNTAKEN]] ]
; CHECK-NEXT:    br i1 [[CND]], label [[TAKEN2:%.*]], label [[UNTAKEN2:%.*]]
; CHECK:       taken2:
; CHECK-NEXT:    [[OBJ0:%.*]] = extractelement <2 x ptr addrspace(1)> [[VEC]], i32 [[IDX1:%.*]]
; CHECK-NEXT:    br label [[MERGE2:%.*]]
; CHECK:       untaken2:
; CHECK-NEXT:    [[OBJ1:%.*]] = extractelement <2 x ptr addrspace(1)> [[VEC]], i32 [[IDX2:%.*]]
; CHECK-NEXT:    br label [[MERGE2]]
; CHECK:       merge2:
; CHECK-NEXT:    [[OBJ:%.*]] = phi ptr addrspace(1) [ [[OBJ0]], [[TAKEN2]] ], [ [[OBJ1]], [[UNTAKEN2]] ]
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, ptr, i32, i32, ...) @llvm.experimental.gc.statepoint.p0(i64 2882400000, i32 0, ptr elementtype(void ()) @do_safepoint, i32 0, i32 0, i32 0, i32 0) [ "deopt"(), "gc-live"(ptr addrspace(1) [[OBJ]]) ]
; CHECK-NEXT:    [[OBJ_RELOCATED:%.*]] = call coldcc ptr addrspace(1) @llvm.experimental.gc.relocate.p1(token [[STATEPOINT_TOKEN]], i32 0, i32 0)
; CHECK-NEXT:    ret ptr addrspace(1) [[OBJ_RELOCATED]]
;
entry:
  br i1 %cnd, label %taken, label %untaken

taken:                                            ; preds = %entry
  %obja = load <2 x ptr addrspace(1)>, ptr %ptr
  br label %merge

untaken:                                          ; preds = %entry
  %objb = load <2 x ptr addrspace(1)>, ptr %ptr
  br label %merge

merge:                                            ; preds = %untaken, %taken
  %vec = phi <2 x ptr addrspace(1)> [ %obja, %taken ], [ %objb, %untaken ]
  br i1 %cnd, label %taken2, label %untaken2

taken2:                                           ; preds = %merge
  %obj0 = extractelement <2 x ptr addrspace(1)> %vec, i32 %idx1
  br label %merge2

untaken2:                                         ; preds = %merge
  %obj1 = extractelement <2 x ptr addrspace(1)> %vec, i32 %idx2
  br label %merge2

merge2:                                           ; preds = %untaken2, %taken2
  %obj = phi ptr addrspace(1) [ %obj0, %taken2 ], [ %obj1, %untaken2 ]
  call void @do_safepoint() [ "deopt"() ]
  ret ptr addrspace(1) %obj
}

define ptr addrspace(1) @test3(ptr addrspace(1) %ptr) gc "statepoint-example" {
; CHECK-LABEL: @test3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VEC_BASE:%.*]] = insertelement <2 x ptr addrspace(1)> zeroinitializer, ptr addrspace(1) [[PTR:%.*]], i32 0, !is_base_value !0
; CHECK-NEXT:    [[VEC:%.*]] = insertelement <2 x ptr addrspace(1)> poison, ptr addrspace(1) [[PTR]], i32 0
; CHECK-NEXT:    [[OBJ_BASE:%.*]] = extractelement <2 x ptr addrspace(1)> [[VEC_BASE]], i32 0, !is_base_value !0
; CHECK-NEXT:    [[OBJ:%.*]] = extractelement <2 x ptr addrspace(1)> [[VEC]], i32 0
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, ptr, i32, i32, ...) @llvm.experimental.gc.statepoint.p0(i64 2882400000, i32 0, ptr elementtype(void ()) @do_safepoint, i32 0, i32 0, i32 0, i32 0) [ "deopt"(), "gc-live"(ptr addrspace(1) [[OBJ]], ptr addrspace(1) [[OBJ_BASE]]) ]
; CHECK-NEXT:    [[OBJ_RELOCATED:%.*]] = call coldcc ptr addrspace(1) @llvm.experimental.gc.relocate.p1(token [[STATEPOINT_TOKEN]], i32 1, i32 0)
; CHECK-NEXT:    [[OBJ_BASE_RELOCATED:%.*]] = call coldcc ptr addrspace(1) @llvm.experimental.gc.relocate.p1(token [[STATEPOINT_TOKEN]], i32 1, i32 1)
; CHECK-NEXT:    ret ptr addrspace(1) [[OBJ_RELOCATED]]
;
entry:
  %vec = insertelement <2 x ptr addrspace(1)> poison, ptr addrspace(1) %ptr, i32 0
  %obj = extractelement <2 x ptr addrspace(1)> %vec, i32 0
  call void @do_safepoint() [ "deopt"() ]
  ret ptr addrspace(1) %obj
}

define ptr addrspace(1) @test4(ptr addrspace(1) %ptr) gc "statepoint-example" {
; CHECK-LABEL: @test4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[DERIVED:%.*]] = getelementptr i64, ptr addrspace(1) [[PTR:%.*]], i64 16
; CHECK-NEXT:    [[VECA_BASE:%.*]] = insertelement <2 x ptr addrspace(1)> zeroinitializer, ptr addrspace(1) [[PTR]], i32 0, !is_base_value !0
; CHECK-NEXT:    [[VECA:%.*]] = insertelement <2 x ptr addrspace(1)> poison, ptr addrspace(1) [[DERIVED]], i32 0
; CHECK-NEXT:    [[VEC_BASE:%.*]] = insertelement <2 x ptr addrspace(1)> [[VECA_BASE]], ptr addrspace(1) [[PTR]], i32 1, !is_base_value !0
; CHECK-NEXT:    [[VEC:%.*]] = insertelement <2 x ptr addrspace(1)> [[VECA]], ptr addrspace(1) [[PTR]], i32 1
; CHECK-NEXT:    [[OBJ_BASE:%.*]] = extractelement <2 x ptr addrspace(1)> [[VEC_BASE]], i32 0, !is_base_value !0
; CHECK-NEXT:    [[OBJ:%.*]] = extractelement <2 x ptr addrspace(1)> [[VEC]], i32 0
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, ptr, i32, i32, ...) @llvm.experimental.gc.statepoint.p0(i64 2882400000, i32 0, ptr elementtype(void ()) @do_safepoint, i32 0, i32 0, i32 0, i32 0) [ "deopt"(), "gc-live"(ptr addrspace(1) [[OBJ]], ptr addrspace(1) [[OBJ_BASE]]) ]
; CHECK-NEXT:    [[OBJ_RELOCATED:%.*]] = call coldcc ptr addrspace(1) @llvm.experimental.gc.relocate.p1(token [[STATEPOINT_TOKEN]], i32 1, i32 0)
; CHECK-NEXT:    [[OBJ_BASE_RELOCATED:%.*]] = call coldcc ptr addrspace(1) @llvm.experimental.gc.relocate.p1(token [[STATEPOINT_TOKEN]], i32 1, i32 1)
; CHECK-NEXT:    ret ptr addrspace(1) [[OBJ_RELOCATED]]
;
; When we can optimize an extractelement from a known
; index and avoid introducing new base pointer instructions
entry:
  %derived = getelementptr i64, ptr addrspace(1) %ptr, i64 16
  %veca = insertelement <2 x ptr addrspace(1)> poison, ptr addrspace(1) %derived, i32 0
  %vec = insertelement <2 x ptr addrspace(1)> %veca, ptr addrspace(1) %ptr, i32 1
  %obj = extractelement <2 x ptr addrspace(1)> %vec, i32 0
  call void @do_safepoint() [ "deopt"() ]
  ret ptr addrspace(1) %obj
}

declare void @use(ptr addrspace(1)) "gc-leaf-function"
declare void @use_vec(<4 x ptr addrspace(1)>) "gc-leaf-function"

define void @test5(i1 %cnd, ptr addrspace(1) %obj) gc "statepoint-example" {
; CHECK-LABEL: @test5(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr i64, ptr addrspace(1) [[OBJ:%.*]], i64 1
; CHECK-NEXT:    [[VEC_BASE:%.*]] = insertelement <2 x ptr addrspace(1)> zeroinitializer, ptr addrspace(1) [[OBJ]], i32 0, !is_base_value !0
; CHECK-NEXT:    [[VEC:%.*]] = insertelement <2 x ptr addrspace(1)> poison, ptr addrspace(1) [[GEP]], i32 0
; CHECK-NEXT:    [[BDV_BASE:%.*]] = extractelement <2 x ptr addrspace(1)> [[VEC_BASE]], i32 0, !is_base_value !0
; CHECK-NEXT:    [[BDV:%.*]] = extractelement <2 x ptr addrspace(1)> [[VEC]], i32 0
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, ptr, i32, i32, ...) @llvm.experimental.gc.statepoint.p0(i64 2882400000, i32 0, ptr elementtype(void ()) @do_safepoint, i32 0, i32 0, i32 0, i32 0) [ "deopt"(i32 0, i32 -1, i32 0, i32 0, i32 0), "gc-live"(ptr addrspace(1) [[BDV]], ptr addrspace(1) [[BDV_BASE]]) ]
; CHECK-NEXT:    [[BDV_RELOCATED:%.*]] = call coldcc ptr addrspace(1) @llvm.experimental.gc.relocate.p1(token [[STATEPOINT_TOKEN]], i32 1, i32 0)
; CHECK-NEXT:    [[BDV_BASE_RELOCATED:%.*]] = call coldcc ptr addrspace(1) @llvm.experimental.gc.relocate.p1(token [[STATEPOINT_TOKEN]], i32 1, i32 1)
; CHECK-NEXT:    call void @use(ptr addrspace(1) [[BDV_RELOCATED]])
; CHECK-NEXT:    ret void
;
; When we fundementally have to duplicate
entry:
  %gep = getelementptr i64, ptr addrspace(1) %obj, i64 1
  %vec = insertelement <2 x ptr addrspace(1)> poison, ptr addrspace(1) %gep, i32 0
  %bdv = extractelement <2 x ptr addrspace(1)> %vec, i32 0
  call void @do_safepoint() [ "deopt"(i32 0, i32 -1, i32 0, i32 0, i32 0) ]
  call void @use(ptr addrspace(1) %bdv)
  ret void
}

define void @test6(i1 %cnd, ptr addrspace(1) %obj, i64 %idx) gc "statepoint-example" {
; CHECK-LABEL: @test6(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr i64, ptr addrspace(1) [[OBJ:%.*]], i64 1
; CHECK-NEXT:    [[VEC_BASE:%.*]] = insertelement <2 x ptr addrspace(1)> zeroinitializer, ptr addrspace(1) [[OBJ]], i32 0, !is_base_value !0
; CHECK-NEXT:    [[VEC:%.*]] = insertelement <2 x ptr addrspace(1)> poison, ptr addrspace(1) [[GEP]], i32 0
; CHECK-NEXT:    [[BDV_BASE:%.*]] = extractelement <2 x ptr addrspace(1)> [[VEC_BASE]], i64 [[IDX:%.*]], !is_base_value !0
; CHECK-NEXT:    [[BDV:%.*]] = extractelement <2 x ptr addrspace(1)> [[VEC]], i64 [[IDX]]
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, ptr, i32, i32, ...) @llvm.experimental.gc.statepoint.p0(i64 2882400000, i32 0, ptr elementtype(void ()) @do_safepoint, i32 0, i32 0, i32 0, i32 0) [ "deopt"(i32 0, i32 -1, i32 0, i32 0, i32 0), "gc-live"(ptr addrspace(1) [[BDV]], ptr addrspace(1) [[BDV_BASE]]) ]
; CHECK-NEXT:    [[BDV_RELOCATED:%.*]] = call coldcc ptr addrspace(1) @llvm.experimental.gc.relocate.p1(token [[STATEPOINT_TOKEN]], i32 1, i32 0)
; CHECK-NEXT:    [[BDV_BASE_RELOCATED:%.*]] = call coldcc ptr addrspace(1) @llvm.experimental.gc.relocate.p1(token [[STATEPOINT_TOKEN]], i32 1, i32 1)
; CHECK-NEXT:    call void @use(ptr addrspace(1) [[BDV_RELOCATED]])
; CHECK-NEXT:    ret void
;
; A more complicated example involving vector and scalar bases.
; This is derived from a failing test case when we didn't have correct
; insertelement handling.
entry:
  %gep = getelementptr i64, ptr addrspace(1) %obj, i64 1
  %vec = insertelement <2 x ptr addrspace(1)> poison, ptr addrspace(1) %gep, i32 0
  %bdv = extractelement <2 x ptr addrspace(1)> %vec, i64 %idx
  call void @do_safepoint() [ "deopt"(i32 0, i32 -1, i32 0, i32 0, i32 0) ]
  call void @use(ptr addrspace(1) %bdv)
  ret void
}

define ptr addrspace(1) @test7(i1 %cnd, ptr addrspace(1) %obj, ptr addrspace(1) %obj2) gc "statepoint-example" {
; CHECK-LABEL: @test7(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VEC_BASE:%.*]] = insertelement <2 x ptr addrspace(1)> zeroinitializer, ptr addrspace(1) [[OBJ2:%.*]], i32 0, !is_base_value !0
; CHECK-NEXT:    [[VEC:%.*]] = insertelement <2 x ptr addrspace(1)> poison, ptr addrspace(1) [[OBJ2]], i32 0
; CHECK-NEXT:    br label [[MERGE1:%.*]]
; CHECK:       merge1:
; CHECK-NEXT:    [[VEC2_BASE:%.*]] = phi <2 x ptr addrspace(1)> [ [[VEC_BASE]], [[ENTRY:%.*]] ], [ [[VEC3_BASE:%.*]], [[MERGE1]] ], !is_base_value !0
; CHECK-NEXT:    [[VEC2:%.*]] = phi <2 x ptr addrspace(1)> [ [[VEC]], [[ENTRY]] ], [ [[VEC3:%.*]], [[MERGE1]] ]
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr i64, ptr addrspace(1) [[OBJ2]], i64 1
; CHECK-NEXT:    [[VEC3_BASE]] = insertelement <2 x ptr addrspace(1)> zeroinitializer, ptr addrspace(1) [[OBJ2]], i32 0, !is_base_value !0
; CHECK-NEXT:    [[VEC3]] = insertelement <2 x ptr addrspace(1)> poison, ptr addrspace(1) [[GEP]], i32 0
; CHECK-NEXT:    br i1 [[CND:%.*]], label [[MERGE1]], label [[NEXT1:%.*]]
; CHECK:       next1:
; CHECK-NEXT:    [[BDV_BASE:%.*]] = extractelement <2 x ptr addrspace(1)> [[VEC2_BASE]], i32 0, !is_base_value !0
; CHECK-NEXT:    [[BDV:%.*]] = extractelement <2 x ptr addrspace(1)> [[VEC2]], i32 0
; CHECK-NEXT:    br label [[MERGE:%.*]]
; CHECK:       merge:
; CHECK-NEXT:    [[OBJB_BASE:%.*]] = phi ptr addrspace(1) [ [[OBJ:%.*]], [[NEXT1]] ], [ [[BDV_BASE]], [[MERGE]] ], !is_base_value !0
; CHECK-NEXT:    [[OBJB:%.*]] = phi ptr addrspace(1) [ [[OBJ]], [[NEXT1]] ], [ [[BDV]], [[MERGE]] ]
; CHECK-NEXT:    br i1 [[CND]], label [[MERGE]], label [[NEXT:%.*]]
; CHECK:       next:
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, ptr, i32, i32, ...) @llvm.experimental.gc.statepoint.p0(i64 2882400000, i32 0, ptr elementtype(void ()) @do_safepoint, i32 0, i32 0, i32 0, i32 0) [ "deopt"(i32 0, i32 -1, i32 0, i32 0, i32 0), "gc-live"(ptr addrspace(1) [[OBJB]], ptr addrspace(1) [[OBJB_BASE]]) ]
; CHECK-NEXT:    [[OBJB_RELOCATED:%.*]] = call coldcc ptr addrspace(1) @llvm.experimental.gc.relocate.p1(token [[STATEPOINT_TOKEN]], i32 1, i32 0)
; CHECK-NEXT:    [[OBJB_BASE_RELOCATED:%.*]] = call coldcc ptr addrspace(1) @llvm.experimental.gc.relocate.p1(token [[STATEPOINT_TOKEN]], i32 1, i32 1)
; CHECK-NEXT:    ret ptr addrspace(1) [[OBJB_RELOCATED]]
;
entry:
  %vec = insertelement <2 x ptr addrspace(1)> poison, ptr addrspace(1) %obj2, i32 0
  br label %merge1

merge1:                                           ; preds = %merge1, %entry
  %vec2 = phi <2 x ptr addrspace(1)> [ %vec, %entry ], [ %vec3, %merge1 ]
  %gep = getelementptr i64, ptr addrspace(1) %obj2, i64 1
  %vec3 = insertelement <2 x ptr addrspace(1)> poison, ptr addrspace(1) %gep, i32 0
  br i1 %cnd, label %merge1, label %next1

next1:                                            ; preds = %merge1
  %bdv = extractelement <2 x ptr addrspace(1)> %vec2, i32 0
  br label %merge

merge:                                            ; preds = %merge, %next1
  %objb = phi ptr addrspace(1) [ %obj, %next1 ], [ %bdv, %merge ]
  br i1 %cnd, label %merge, label %next

next:                                             ; preds = %merge
  call void @do_safepoint() [ "deopt"(i32 0, i32 -1, i32 0, i32 0, i32 0) ]
  ret ptr addrspace(1) %objb
}

; identify base for shufflevector
define void @test8(ptr addrspace(1) %obj, i64 %idx) gc "statepoint-example" {
; CHECK-LABEL: @test8(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr i64, ptr addrspace(1) [[OBJ:%.*]], i64 1
; CHECK-NEXT:    [[GEP2:%.*]] = getelementptr i64, ptr addrspace(1) [[OBJ]], i64 2
; CHECK-NEXT:    [[VEC1_BASE:%.*]] = insertelement <4 x ptr addrspace(1)> zeroinitializer, ptr addrspace(1) [[OBJ]], i32 0, !is_base_value !0
; CHECK-NEXT:    [[VEC1:%.*]] = insertelement <4 x ptr addrspace(1)> poison, ptr addrspace(1) [[GEP]], i32 0
; CHECK-NEXT:    [[VEC2_BASE:%.*]] = insertelement <4 x ptr addrspace(1)> zeroinitializer, ptr addrspace(1) [[OBJ]], i32 2, !is_base_value !0
; CHECK-NEXT:    [[VEC2:%.*]] = insertelement <4 x ptr addrspace(1)> poison, ptr addrspace(1) [[GEP2]], i32 2
; CHECK-NEXT:    [[VEC_BASE:%.*]] = shufflevector <4 x ptr addrspace(1)> [[VEC1_BASE]], <4 x ptr addrspace(1)> [[VEC2_BASE]], <2 x i32> <i32 0, i32 2>, !is_base_value !0
; CHECK-NEXT:    [[VEC:%.*]] = shufflevector <4 x ptr addrspace(1)> [[VEC1]], <4 x ptr addrspace(1)> [[VEC2]], <2 x i32> <i32 0, i32 2>
; CHECK-NEXT:    [[BDV_BASE:%.*]] = extractelement <2 x ptr addrspace(1)> [[VEC_BASE]], i64 [[IDX:%.*]], !is_base_value !0
; CHECK-NEXT:    [[BDV:%.*]] = extractelement <2 x ptr addrspace(1)> [[VEC]], i64 [[IDX]]
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, ptr, i32, i32, ...) @llvm.experimental.gc.statepoint.p0(i64 2882400000, i32 0, ptr elementtype(void ()) @do_safepoint, i32 0, i32 0, i32 0, i32 0) [ "deopt"(i32 0, i32 -1, i32 0, i32 0, i32 0), "gc-live"(ptr addrspace(1) [[BDV]], ptr addrspace(1) [[BDV_BASE]]) ]
; CHECK-NEXT:    [[BDV_RELOCATED:%.*]] = call coldcc ptr addrspace(1) @llvm.experimental.gc.relocate.p1(token [[STATEPOINT_TOKEN]], i32 1, i32 0)
; CHECK-NEXT:    [[BDV_BASE_RELOCATED:%.*]] = call coldcc ptr addrspace(1) @llvm.experimental.gc.relocate.p1(token [[STATEPOINT_TOKEN]], i32 1, i32 1)
; CHECK-NEXT:    call void @use(ptr addrspace(1) [[BDV_RELOCATED]])
; CHECK-NEXT:    ret void
;
entry:
  %gep = getelementptr i64, ptr addrspace(1) %obj, i64 1
  %gep2 = getelementptr i64, ptr addrspace(1) %obj, i64 2
  %vec1 = insertelement <4 x ptr addrspace(1)> poison, ptr addrspace(1) %gep, i32 0
  %vec2 = insertelement <4 x ptr addrspace(1)> poison, ptr addrspace(1) %gep2, i32 2
  %vec = shufflevector <4 x ptr addrspace(1)> %vec1, <4 x ptr addrspace(1)> %vec2, <2 x i32> <i32 0, i32 2>
  %bdv = extractelement <2 x ptr addrspace(1)> %vec, i64 %idx
  call void @do_safepoint() [ "deopt"(i32 0, i32 -1, i32 0, i32 0, i32 0) ]
  call void @use(ptr addrspace(1) %bdv)
  ret void
}

; Since the same 'base' vector is used in the shuffle operands, we do not need
; create a shufflevector base.
define void @test9(<4 x ptr addrspace(1)> %vec1, i64 %idx) gc "statepoint-example" {
; CHECK-LABEL: @test9(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VEC:%.*]] = shufflevector <4 x ptr addrspace(1)> [[VEC1:%.*]], <4 x ptr addrspace(1)> [[VEC1]], <2 x i32> <i32 0, i32 2>
; CHECK-NEXT:    [[BDV:%.*]] = extractelement <2 x ptr addrspace(1)> [[VEC]], i64 [[IDX:%.*]]
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, ptr, i32, i32, ...) @llvm.experimental.gc.statepoint.p0(i64 2882400000, i32 0, ptr elementtype(void ()) @do_safepoint, i32 0, i32 0, i32 0, i32 0) [ "deopt"(i32 0, i32 -1, i32 0, i32 0, i32 0), "gc-live"(ptr addrspace(1) [[BDV]]) ]
; CHECK-NEXT:    [[BDV_RELOCATED:%.*]] = call coldcc ptr addrspace(1) @llvm.experimental.gc.relocate.p1(token [[STATEPOINT_TOKEN]], i32 0, i32 0)
; CHECK-NEXT:    call void @use(ptr addrspace(1) [[BDV_RELOCATED]])
; CHECK-NEXT:    ret void
;
entry:
  ; shrinking vec1 into vec
  %vec = shufflevector <4 x ptr addrspace(1)> %vec1, <4 x ptr addrspace(1)> %vec1, <2 x i32> <i32 0, i32 2>
  %bdv = extractelement <2 x ptr addrspace(1)> %vec, i64 %idx
  call void @do_safepoint() [ "deopt"(i32 0, i32 -1, i32 0, i32 0, i32 0) ]
  call void @use(ptr addrspace(1) %bdv)
  ret void
}

; vector operand of shufflevector is a phi
define ptr addrspace(1) @test10(i1 %cnd, ptr addrspace(1) %obj, ptr addrspace(1) %obj2) gc "statepoint-example" {
; CHECK-LABEL: @test10(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VEC1_BASE:%.*]] = insertelement <4 x ptr addrspace(1)> zeroinitializer, ptr addrspace(1) [[OBJ:%.*]], i32 0, !is_base_value !0
; CHECK-NEXT:    [[VEC1:%.*]] = insertelement <4 x ptr addrspace(1)> poison, ptr addrspace(1) [[OBJ]], i32 0
; CHECK-NEXT:    br i1 [[CND:%.*]], label [[HERE:%.*]], label [[MERGE:%.*]]
; CHECK:       here:
; CHECK-NEXT:    [[VEC2_BASE:%.*]] = insertelement <4 x ptr addrspace(1)> zeroinitializer, ptr addrspace(1) [[OBJ2:%.*]], i32 2, !is_base_value !0
; CHECK-NEXT:    [[VEC2:%.*]] = insertelement <4 x ptr addrspace(1)> poison, ptr addrspace(1) [[OBJ2]], i32 2
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       merge:
; CHECK-NEXT:    [[VEC_BASE:%.*]] = phi <4 x ptr addrspace(1)> [ [[VEC1_BASE]], [[ENTRY:%.*]] ], [ [[VEC2_BASE]], [[HERE]] ], [ [[VEC3_BASE:%.*]], [[MERGE]] ], !is_base_value !0
; CHECK-NEXT:    [[VEC:%.*]] = phi <4 x ptr addrspace(1)> [ [[VEC1]], [[ENTRY]] ], [ [[VEC2]], [[HERE]] ], [ [[VEC3:%.*]], [[MERGE]] ]
; CHECK-NEXT:    [[VEC3_BASE]] = shufflevector <4 x ptr addrspace(1)> [[VEC_BASE]], <4 x ptr addrspace(1)> [[VEC_BASE]], <4 x i32> <i32 2, i32 0, i32 1, i32 3>, !is_base_value !0
; CHECK-NEXT:    [[VEC3]] = shufflevector <4 x ptr addrspace(1)> [[VEC]], <4 x ptr addrspace(1)> [[VEC]], <4 x i32> <i32 2, i32 0, i32 1, i32 3>
; CHECK-NEXT:    [[BDV_BASE:%.*]] = extractelement <4 x ptr addrspace(1)> [[VEC3_BASE]], i32 0, !is_base_value !0
; CHECK-NEXT:    [[BDV:%.*]] = extractelement <4 x ptr addrspace(1)> [[VEC3]], i32 0
; CHECK-NEXT:    br i1 [[CND]], label [[MERGE]], label [[NEXT:%.*]]
; CHECK:       next:
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, ptr, i32, i32, ...) @llvm.experimental.gc.statepoint.p0(i64 2882400000, i32 0, ptr elementtype(void ()) @do_safepoint, i32 0, i32 0, i32 0, i32 0) [ "deopt"(i32 0, i32 -1, i32 0, i32 0, i32 0), "gc-live"(ptr addrspace(1) [[BDV]], ptr addrspace(1) [[BDV_BASE]]) ]
; CHECK-NEXT:    [[BDV_RELOCATED:%.*]] = call coldcc ptr addrspace(1) @llvm.experimental.gc.relocate.p1(token [[STATEPOINT_TOKEN]], i32 1, i32 0)
; CHECK-NEXT:    [[BDV_BASE_RELOCATED:%.*]] = call coldcc ptr addrspace(1) @llvm.experimental.gc.relocate.p1(token [[STATEPOINT_TOKEN]], i32 1, i32 1)
; CHECK-NEXT:    ret ptr addrspace(1) [[BDV_RELOCATED]]
;
entry:
  %vec1 = insertelement <4 x ptr addrspace(1)> poison, ptr addrspace(1) %obj, i32 0
  br i1 %cnd, label %here, label %merge

here:
  %vec2 = insertelement <4 x ptr addrspace(1)> poison, ptr addrspace(1) %obj2, i32 2
  br label %merge

merge:                                           ; preds = %merge, %entry, %here
  %vec = phi <4 x ptr addrspace(1)> [ %vec1, %entry ], [ %vec2, %here], [ %vec3, %merge]
  %vec3 = shufflevector <4 x ptr addrspace(1)> %vec, <4 x ptr addrspace(1)> %vec, <4 x i32> <i32 2, i32 0, i32 1, i32 3>
  %bdv = extractelement <4 x ptr addrspace(1)> %vec3, i32 0
  br i1 %cnd, label %merge, label %next

next:
  call void @do_safepoint() [ "deopt"(i32 0, i32 -1, i32 0, i32 0, i32 0) ]
  ret ptr addrspace(1) %bdv
}
declare void @do_safepoint()

define void @test11(<4 x ptr addrspace(1)> %vec1) gc "statepoint-example" {
; CHECK-LABEL: @test11(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VEC2:%.*]] = getelementptr i64, <4 x ptr addrspace(1)> [[VEC1:%.*]], i32 1024
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, ptr, i32, i32, ...) @llvm.experimental.gc.statepoint.p0(i64 2882400000, i32 0, ptr elementtype(void ()) @do_safepoint, i32 0, i32 0, i32 0, i32 0) [ "deopt"(i32 0, i32 -1, i32 0, i32 0, i32 0), "gc-live"(<4 x ptr addrspace(1)> [[VEC1]]) ]
; CHECK-NEXT:    [[VEC1_RELOCATED:%.*]] = call coldcc <4 x ptr addrspace(1)> @llvm.experimental.gc.relocate.v4p1(token [[STATEPOINT_TOKEN]], i32 0, i32 0)
; CHECK-NEXT:    [[VEC2_REMAT:%.*]] = getelementptr i64, <4 x ptr addrspace(1)> [[VEC1_RELOCATED]], i32 1024
; CHECK-NEXT:    call void @use_vec(<4 x ptr addrspace(1)> [[VEC2_REMAT]])
; CHECK-NEXT:    ret void
;
entry:
  %vec2 = getelementptr i64, <4 x ptr addrspace(1)> %vec1, i32 1024
  call void @do_safepoint() [ "deopt"(i32 0, i32 -1, i32 0, i32 0, i32 0) ]
  call void @use_vec(<4 x ptr addrspace(1)> %vec2)
  ret void
}

declare <4 x ptr addrspace(1)> @def_vec() "gc-leaf-function"

define void @test12(<4 x ptr addrspace(1)> %vec1) gc "statepoint-example" {
; CHECK-LABEL: @test12(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VEC:%.*]] = call <4 x ptr addrspace(1)> @def_vec()
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, ptr, i32, i32, ...) @llvm.experimental.gc.statepoint.p0(i64 2882400000, i32 0, ptr elementtype(void ()) @do_safepoint, i32 0, i32 0, i32 0, i32 0) [ "deopt"(), "gc-live"(<4 x ptr addrspace(1)> [[VEC]]) ]
; CHECK-NEXT:    [[VEC_RELOCATED:%.*]] = call coldcc <4 x ptr addrspace(1)> @llvm.experimental.gc.relocate.v4p1(token [[STATEPOINT_TOKEN]], i32 0, i32 0)
; CHECK-NEXT:    call void @use_vec(<4 x ptr addrspace(1)> [[VEC_RELOCATED]])
; CHECK-NEXT:    ret void
;
entry:
  %vec = call <4 x ptr addrspace(1)> @def_vec()
  call void @do_safepoint() [ "deopt"() ]
  call void @use_vec(<4 x ptr addrspace(1)> %vec)
  ret void
}
