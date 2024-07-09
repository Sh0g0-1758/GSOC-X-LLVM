; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=loop-vectorize -force-vector-interleave=4 -force-vector-width=1 -S | FileCheck --check-prefixes=CHECK,DEFAULT %s
; RUN: opt < %s -passes=loop-vectorize -force-vector-interleave=4 -force-vector-width=1 -lv-strided-pointer-ivs=true -S | FileCheck --check-prefixes=CHECK,STRIDED %s
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

; Test the scalar expansion of a non-constant stride pointer IV
define void @non_constant_scalar_expansion(i32 %0, ptr %call) {
; DEFAULT-LABEL: @non_constant_scalar_expansion(
; DEFAULT-NEXT:  entry:
; DEFAULT-NEXT:    [[MUL:%.*]] = shl i32 [[TMP0:%.*]], 1
; DEFAULT-NEXT:    br label [[FOR_COND:%.*]]
; DEFAULT:       for.cond:
; DEFAULT-NEXT:    [[TMP1:%.*]] = phi i32 [ 30, [[ENTRY:%.*]] ], [ [[INC:%.*]], [[FOR_COND]] ]
; DEFAULT-NEXT:    [[P_0:%.*]] = phi ptr [ null, [[ENTRY]] ], [ [[ADD_PTR:%.*]], [[FOR_COND]] ]
; DEFAULT-NEXT:    [[ADD_PTR]] = getelementptr i8, ptr [[P_0]], i32 [[MUL]]
; DEFAULT-NEXT:    [[ARRAYIDX:%.*]] = getelementptr ptr, ptr [[CALL:%.*]], i32 [[TMP1]]
; DEFAULT-NEXT:    store ptr [[P_0]], ptr [[ARRAYIDX]], align 4
; DEFAULT-NEXT:    [[INC]] = add i32 [[TMP1]], 1
; DEFAULT-NEXT:    [[TOBOOL_NOT:%.*]] = icmp eq i32 [[TMP1]], 0
; DEFAULT-NEXT:    br i1 [[TOBOOL_NOT]], label [[FOR_END:%.*]], label [[FOR_COND]]
; DEFAULT:       for.end:
; DEFAULT-NEXT:    ret void
;
; STRIDED-LABEL: @non_constant_scalar_expansion(
; STRIDED-NEXT:  entry:
; STRIDED-NEXT:    [[MUL:%.*]] = shl i32 [[TMP0:%.*]], 1
; STRIDED-NEXT:    [[TMP1:%.*]] = sext i32 [[MUL]] to i64
; STRIDED-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; STRIDED:       vector.ph:
; STRIDED-NEXT:    [[TMP2:%.*]] = mul i64 4294967264, [[TMP1]]
; STRIDED-NEXT:    [[IND_END:%.*]] = getelementptr i8, ptr null, i64 [[TMP2]]
; STRIDED-NEXT:    br label [[VECTOR_BODY:%.*]]
; STRIDED:       vector.body:
; STRIDED-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; STRIDED-NEXT:    [[TMP4:%.*]] = add i64 [[INDEX]], 0
; STRIDED-NEXT:    [[TMP5:%.*]] = mul i64 [[TMP4]], [[TMP1]]
; STRIDED-NEXT:    [[NEXT_GEP:%.*]] = getelementptr i8, ptr null, i64 [[TMP5]]
; STRIDED-NEXT:    [[TMP6:%.*]] = add i64 [[INDEX]], 1
; STRIDED-NEXT:    [[TMP7:%.*]] = mul i64 [[TMP6]], [[TMP1]]
; STRIDED-NEXT:    [[NEXT_GEP2:%.*]] = getelementptr i8, ptr null, i64 [[TMP7]]
; STRIDED-NEXT:    [[TMP8:%.*]] = add i64 [[INDEX]], 2
; STRIDED-NEXT:    [[TMP9:%.*]] = mul i64 [[TMP8]], [[TMP1]]
; STRIDED-NEXT:    [[NEXT_GEP3:%.*]] = getelementptr i8, ptr null, i64 [[TMP9]]
; STRIDED-NEXT:    [[TMP10:%.*]] = add i64 [[INDEX]], 3
; STRIDED-NEXT:    [[TMP11:%.*]] = mul i64 [[TMP10]], [[TMP1]]
; STRIDED-NEXT:    [[NEXT_GEP4:%.*]] = getelementptr i8, ptr null, i64 [[TMP11]]
; STRIDED-NEXT:    [[DOTCAST:%.*]] = trunc i64 [[INDEX]] to i32
; STRIDED-NEXT:    [[OFFSET_IDX:%.*]] = add i32 30, [[DOTCAST]]
; STRIDED-NEXT:    [[TMP12:%.*]] = add i32 [[OFFSET_IDX]], 0
; STRIDED-NEXT:    [[TMP13:%.*]] = add i32 [[OFFSET_IDX]], 1
; STRIDED-NEXT:    [[TMP14:%.*]] = add i32 [[OFFSET_IDX]], 2
; STRIDED-NEXT:    [[TMP15:%.*]] = add i32 [[OFFSET_IDX]], 3
; STRIDED-NEXT:    [[TMP16:%.*]] = getelementptr ptr, ptr [[CALL:%.*]], i32 [[TMP12]]
; STRIDED-NEXT:    [[TMP17:%.*]] = getelementptr ptr, ptr [[CALL]], i32 [[TMP13]]
; STRIDED-NEXT:    [[TMP18:%.*]] = getelementptr ptr, ptr [[CALL]], i32 [[TMP14]]
; STRIDED-NEXT:    [[TMP19:%.*]] = getelementptr ptr, ptr [[CALL]], i32 [[TMP15]]
; STRIDED-NEXT:    store ptr [[NEXT_GEP]], ptr [[TMP16]], align 4
; STRIDED-NEXT:    store ptr [[NEXT_GEP2]], ptr [[TMP17]], align 4
; STRIDED-NEXT:    store ptr [[NEXT_GEP3]], ptr [[TMP18]], align 4
; STRIDED-NEXT:    store ptr [[NEXT_GEP4]], ptr [[TMP19]], align 4
; STRIDED-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 4
; STRIDED-NEXT:    [[TMP20:%.*]] = icmp eq i64 [[INDEX_NEXT]], 4294967264
; STRIDED-NEXT:    br i1 [[TMP20]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; STRIDED:       middle.block:
; STRIDED-NEXT:    br i1 false, label [[FOR_END:%.*]], label [[SCALAR_PH]]
; STRIDED:       scalar.ph:
; STRIDED-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i32 [ -2, [[MIDDLE_BLOCK]] ], [ 30, [[ENTRY:%.*]] ]
; STRIDED-NEXT:    [[BC_RESUME_VAL1:%.*]] = phi ptr [ [[IND_END]], [[MIDDLE_BLOCK]] ], [ null, [[ENTRY]] ]
; STRIDED-NEXT:    br label [[FOR_COND:%.*]]
; STRIDED:       for.cond:
; STRIDED-NEXT:    [[TMP21:%.*]] = phi i32 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[INC:%.*]], [[FOR_COND]] ]
; STRIDED-NEXT:    [[P_0:%.*]] = phi ptr [ [[BC_RESUME_VAL1]], [[SCALAR_PH]] ], [ [[ADD_PTR:%.*]], [[FOR_COND]] ]
; STRIDED-NEXT:    [[ADD_PTR]] = getelementptr i8, ptr [[P_0]], i32 [[MUL]]
; STRIDED-NEXT:    [[ARRAYIDX:%.*]] = getelementptr ptr, ptr [[CALL]], i32 [[TMP21]]
; STRIDED-NEXT:    store ptr [[P_0]], ptr [[ARRAYIDX]], align 4
; STRIDED-NEXT:    [[INC]] = add i32 [[TMP21]], 1
; STRIDED-NEXT:    [[TOBOOL_NOT:%.*]] = icmp eq i32 [[TMP21]], 0
; STRIDED-NEXT:    br i1 [[TOBOOL_NOT]], label [[FOR_END]], label [[FOR_COND]], !llvm.loop [[LOOP3:![0-9]+]]
; STRIDED:       for.end:
; STRIDED-NEXT:    ret void
;
entry:
  %mul = shl i32 %0, 1
  br label %for.cond

for.cond:                                         ; preds = %for.body, %entry
  %1 = phi i32 [ 30, %entry ], [ %inc, %for.cond ]
  %p.0 = phi ptr [ null, %entry ], [ %add.ptr, %for.cond ]
  %add.ptr = getelementptr i8, ptr %p.0, i32 %mul
  %arrayidx = getelementptr ptr, ptr %call, i32 %1
  store ptr %p.0, ptr %arrayidx, align 4
  %inc = add i32 %1, 1
  %tobool.not = icmp eq i32 %1, 0
  br i1 %tobool.not, label %for.end, label %for.cond


for.end:                                          ; preds = %for.cond
  ret void
}
;; NOTE: These prefixes are unused and the list is autogenerated. Do not add tests below this line:
; CHECK: {{.*}}
