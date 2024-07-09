; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 4
; RUN: opt -passes=loop-vectorize -mcpu=neoverse-v1 -force-vector-interleave=2 -force-vector-width=1 -S %s | FileCheck %s

target triple = "aarch64-unknown-linux-gnu"

define i32 @pr70988() {
; CHECK-LABEL: define i32 @pr70988(
; CHECK-SAME: ) #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, ptr null, align 4
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[TMP0]], 15
; CHECK-NEXT:    [[TMP2:%.*]] = call i32 @llvm.umax.i32(i32 [[TMP1]], i32 1)
; CHECK-NEXT:    [[UMAX:%.*]] = zext i32 [[TMP2]] to i64
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_RND_UP:%.*]] = add i64 [[UMAX]], 1
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[N_RND_UP]], 2
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 [[N_RND_UP]], [[N_MOD_VF]]
; CHECK-NEXT:    [[ACTIVE_LANE_MASK_ENTRY:%.*]] = icmp ult i64 0, [[UMAX]]
; CHECK-NEXT:    [[ACTIVE_LANE_MASK_ENTRY1:%.*]] = icmp ult i64 1, [[UMAX]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT6:%.*]], [[PRED_LOAD_CONTINUE5:%.*]] ]
; CHECK-NEXT:    [[ACTIVE_LANE_MASK:%.*]] = phi i1 [ [[ACTIVE_LANE_MASK_ENTRY]], [[VECTOR_PH]] ], [ [[ACTIVE_LANE_MASK_NEXT:%.*]], [[PRED_LOAD_CONTINUE5]] ]
; CHECK-NEXT:    [[ACTIVE_LANE_MASK2:%.*]] = phi i1 [ [[ACTIVE_LANE_MASK_ENTRY1]], [[VECTOR_PH]] ], [ [[ACTIVE_LANE_MASK_NEXT7:%.*]], [[PRED_LOAD_CONTINUE5]] ]
; CHECK-NEXT:    [[VEC_PHI:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[TMP17:%.*]], [[PRED_LOAD_CONTINUE5]] ]
; CHECK-NEXT:    [[VEC_PHI3:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[TMP18:%.*]], [[PRED_LOAD_CONTINUE5]] ]
; CHECK-NEXT:    br i1 [[ACTIVE_LANE_MASK]], label [[PRED_LOAD_IF:%.*]], label [[PRED_LOAD_CONTINUE:%.*]]
; CHECK:       pred.load.if:
; CHECK-NEXT:    [[TMP3:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr i32, ptr null, i64 [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = load ptr, ptr [[TMP4]], align 8
; CHECK-NEXT:    [[TMP6:%.*]] = load i32, ptr [[TMP5]], align 4
; CHECK-NEXT:    br label [[PRED_LOAD_CONTINUE]]
; CHECK:       pred.load.continue:
; CHECK-NEXT:    [[TMP7:%.*]] = phi ptr [ poison, [[VECTOR_BODY]] ], [ [[TMP5]], [[PRED_LOAD_IF]] ]
; CHECK-NEXT:    [[TMP8:%.*]] = phi i32 [ poison, [[VECTOR_BODY]] ], [ [[TMP6]], [[PRED_LOAD_IF]] ]
; CHECK-NEXT:    br i1 [[ACTIVE_LANE_MASK2]], label [[PRED_LOAD_IF4:%.*]], label [[PRED_LOAD_CONTINUE5]]
; CHECK:       pred.load.if4:
; CHECK-NEXT:    [[TMP9:%.*]] = add i64 [[INDEX]], 1
; CHECK-NEXT:    [[TMP10:%.*]] = getelementptr i32, ptr null, i64 [[TMP9]]
; CHECK-NEXT:    [[TMP11:%.*]] = load ptr, ptr [[TMP10]], align 8
; CHECK-NEXT:    [[TMP12:%.*]] = load i32, ptr [[TMP11]], align 4
; CHECK-NEXT:    br label [[PRED_LOAD_CONTINUE5]]
; CHECK:       pred.load.continue5:
; CHECK-NEXT:    [[TMP13:%.*]] = phi ptr [ poison, [[PRED_LOAD_CONTINUE]] ], [ [[TMP11]], [[PRED_LOAD_IF4]] ]
; CHECK-NEXT:    [[TMP14:%.*]] = phi i32 [ poison, [[PRED_LOAD_CONTINUE]] ], [ [[TMP12]], [[PRED_LOAD_IF4]] ]
; CHECK-NEXT:    [[TMP15:%.*]] = tail call i32 @llvm.smax.i32(i32 [[TMP8]], i32 [[VEC_PHI]])
; CHECK-NEXT:    [[TMP16:%.*]] = tail call i32 @llvm.smax.i32(i32 [[TMP14]], i32 [[VEC_PHI3]])
; CHECK-NEXT:    [[TMP17]] = select i1 [[ACTIVE_LANE_MASK]], i32 [[TMP15]], i32 [[VEC_PHI]]
; CHECK-NEXT:    [[TMP18]] = select i1 [[ACTIVE_LANE_MASK2]], i32 [[TMP16]], i32 [[VEC_PHI3]]
; CHECK-NEXT:    [[INDEX_NEXT:%.*]] = add i64 [[INDEX]], 2
; CHECK-NEXT:    [[INDEX_NEXT6]] = add i64 [[INDEX]], 2
; CHECK-NEXT:    [[TMP19:%.*]] = add i64 [[INDEX_NEXT]], 1
; CHECK-NEXT:    [[ACTIVE_LANE_MASK_NEXT]] = icmp ult i64 [[INDEX_NEXT]], [[UMAX]]
; CHECK-NEXT:    [[ACTIVE_LANE_MASK_NEXT7]] = icmp ult i64 [[TMP19]], [[UMAX]]
; CHECK-NEXT:    [[TMP20:%.*]] = xor i1 [[ACTIVE_LANE_MASK_NEXT]], true
; CHECK-NEXT:    [[TMP21:%.*]] = xor i1 [[ACTIVE_LANE_MASK_NEXT7]], true
; CHECK-NEXT:    br i1 [[TMP20]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[RDX_MINMAX:%.*]] = call i32 @llvm.smax.i32(i32 [[TMP17]], i32 [[TMP18]])
; CHECK-NEXT:    br i1 true, label [[EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[BC_MERGE_RDX:%.*]] = phi i32 [ 0, [[ENTRY]] ], [ [[RDX_MINMAX]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[INDUC:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[INDUC_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[MAX:%.*]] = phi i32 [ [[BC_MERGE_RDX]], [[SCALAR_PH]] ], [ [[TMP24:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr i32, ptr null, i64 [[INDUC]]
; CHECK-NEXT:    [[TMP22:%.*]] = load ptr, ptr [[GEP]], align 8
; CHECK-NEXT:    [[TMP23:%.*]] = load i32, ptr [[TMP22]], align 4
; CHECK-NEXT:    [[TMP24]] = tail call i32 @llvm.smax.i32(i32 [[TMP23]], i32 [[MAX]])
; CHECK-NEXT:    [[INDUC_NEXT]] = add nuw nsw i64 [[INDUC]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[INDUC_NEXT]], [[UMAX]]
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[EXIT]], label [[LOOP]], !llvm.loop [[LOOP3:![0-9]+]]
; CHECK:       exit:
; CHECK-NEXT:    [[RES:%.*]] = phi i32 [ [[TMP24]], [[LOOP]] ], [ [[RDX_MINMAX]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    ret i32 [[RES]]
;
entry:
  %0 = load i32, ptr null
  %1 = and i32 %0, 15
  %2 = call i32 @llvm.umax.i32(i32 %1, i32 1)
  %umax = zext i32 %2 to i64
  br label %loop

loop:
  %induc = phi i64 [ 0, %entry ], [ %induc.next, %loop ]
  %max = phi i32 [ 0, %entry ], [ %5, %loop ]
  %gep = getelementptr i32, ptr null, i64 %induc
  %3 = load ptr, ptr %gep
  %4 = load i32, ptr %3
  %5 = tail call i32 @llvm.smax.i32(i32 %4, i32 %max)
  %induc.next = add nuw nsw i64 %induc, 1
  %exitcond.not = icmp eq i64 %induc.next, %umax
  br i1 %exitcond.not, label %exit, label %loop

exit:
  %res = phi i32 [ %5, %loop ]
  ret i32 %res
}

declare i32 @llvm.smax.i32(i32, i32)
declare i32 @llvm.umax.i32(i32, i32)
;.
; CHECK: [[LOOP0]] = distinct !{[[LOOP0]], [[META1:![0-9]+]], [[META2:![0-9]+]]}
; CHECK: [[META1]] = !{!"llvm.loop.isvectorized", i32 1}
; CHECK: [[META2]] = !{!"llvm.loop.unroll.runtime.disable"}
; CHECK: [[LOOP3]] = distinct !{[[LOOP3]], [[META1]]}
;.
