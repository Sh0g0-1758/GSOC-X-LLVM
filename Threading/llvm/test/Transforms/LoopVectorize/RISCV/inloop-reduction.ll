; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -mtriple riscv64-linux-gnu -mattr=+v,+d -passes=loop-vectorize < %s -S -o - | FileCheck %s -check-prefix=OUTLOOP
; RUN: opt -mtriple riscv64-linux-gnu -mattr=+v,+d -passes=loop-vectorize -prefer-inloop-reductions < %s -S -o - | FileCheck %s -check-prefix=INLOOP


target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n64-S128"
target triple = "riscv64"

define i32 @add_i16_i32(ptr nocapture readonly %x, i32 %n) {
; OUTLOOP-LABEL: @add_i16_i32(
; OUTLOOP-NEXT:  entry:
; OUTLOOP-NEXT:    [[CMP6:%.*]] = icmp sgt i32 [[N:%.*]], 0
; OUTLOOP-NEXT:    br i1 [[CMP6]], label [[FOR_BODY_PREHEADER:%.*]], label [[FOR_COND_CLEANUP:%.*]]
; OUTLOOP:       for.body.preheader:
; OUTLOOP-NEXT:    [[TMP0:%.*]] = call i32 @llvm.vscale.i32()
; OUTLOOP-NEXT:    [[TMP1:%.*]] = mul i32 [[TMP0]], 4
; OUTLOOP-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i32 [[N]], [[TMP1]]
; OUTLOOP-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; OUTLOOP:       vector.ph:
; OUTLOOP-NEXT:    [[TMP2:%.*]] = call i32 @llvm.vscale.i32()
; OUTLOOP-NEXT:    [[TMP3:%.*]] = mul i32 [[TMP2]], 4
; OUTLOOP-NEXT:    [[N_MOD_VF:%.*]] = urem i32 [[N]], [[TMP3]]
; OUTLOOP-NEXT:    [[N_VEC:%.*]] = sub i32 [[N]], [[N_MOD_VF]]
; OUTLOOP-NEXT:    [[TMP4:%.*]] = call i32 @llvm.vscale.i32()
; OUTLOOP-NEXT:    [[TMP5:%.*]] = mul i32 [[TMP4]], 4
; OUTLOOP-NEXT:    br label [[VECTOR_BODY:%.*]]
; OUTLOOP:       vector.body:
; OUTLOOP-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; OUTLOOP-NEXT:    [[VEC_PHI:%.*]] = phi <vscale x 4 x i32> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP10:%.*]], [[VECTOR_BODY]] ]
; OUTLOOP-NEXT:    [[TMP6:%.*]] = add i32 [[INDEX]], 0
; OUTLOOP-NEXT:    [[TMP7:%.*]] = getelementptr inbounds i16, ptr [[X:%.*]], i32 [[TMP6]]
; OUTLOOP-NEXT:    [[TMP8:%.*]] = getelementptr inbounds i16, ptr [[TMP7]], i32 0
; OUTLOOP-NEXT:    [[WIDE_LOAD:%.*]] = load <vscale x 4 x i16>, ptr [[TMP8]], align 2
; OUTLOOP-NEXT:    [[TMP9:%.*]] = sext <vscale x 4 x i16> [[WIDE_LOAD]] to <vscale x 4 x i32>
; OUTLOOP-NEXT:    [[TMP10]] = add <vscale x 4 x i32> [[VEC_PHI]], [[TMP9]]
; OUTLOOP-NEXT:    [[INDEX_NEXT]] = add nuw i32 [[INDEX]], [[TMP5]]
; OUTLOOP-NEXT:    [[TMP11:%.*]] = icmp eq i32 [[INDEX_NEXT]], [[N_VEC]]
; OUTLOOP-NEXT:    br i1 [[TMP11]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; OUTLOOP:       middle.block:
; OUTLOOP-NEXT:    [[TMP12:%.*]] = call i32 @llvm.vector.reduce.add.nxv4i32(<vscale x 4 x i32> [[TMP10]])
; OUTLOOP-NEXT:    [[CMP_N:%.*]] = icmp eq i32 [[N]], [[N_VEC]]
; OUTLOOP-NEXT:    br i1 [[CMP_N]], label [[FOR_COND_CLEANUP_LOOPEXIT:%.*]], label [[SCALAR_PH]]
; OUTLOOP:       scalar.ph:
; OUTLOOP-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i32 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[FOR_BODY_PREHEADER]] ]
; OUTLOOP-NEXT:    [[BC_MERGE_RDX:%.*]] = phi i32 [ 0, [[FOR_BODY_PREHEADER]] ], [ [[TMP12]], [[MIDDLE_BLOCK]] ]
; OUTLOOP-NEXT:    br label [[FOR_BODY:%.*]]
; OUTLOOP:       for.body:
; OUTLOOP-NEXT:    [[I_08:%.*]] = phi i32 [ [[INC:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; OUTLOOP-NEXT:    [[R_07:%.*]] = phi i32 [ [[ADD:%.*]], [[FOR_BODY]] ], [ [[BC_MERGE_RDX]], [[SCALAR_PH]] ]
; OUTLOOP-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i16, ptr [[X]], i32 [[I_08]]
; OUTLOOP-NEXT:    [[TMP13:%.*]] = load i16, ptr [[ARRAYIDX]], align 2
; OUTLOOP-NEXT:    [[CONV:%.*]] = sext i16 [[TMP13]] to i32
; OUTLOOP-NEXT:    [[ADD]] = add nsw i32 [[R_07]], [[CONV]]
; OUTLOOP-NEXT:    [[INC]] = add nuw nsw i32 [[I_08]], 1
; OUTLOOP-NEXT:    [[EXITCOND:%.*]] = icmp eq i32 [[INC]], [[N]]
; OUTLOOP-NEXT:    br i1 [[EXITCOND]], label [[FOR_COND_CLEANUP_LOOPEXIT]], label [[FOR_BODY]], !llvm.loop [[LOOP3:![0-9]+]]
; OUTLOOP:       for.cond.cleanup.loopexit:
; OUTLOOP-NEXT:    [[ADD_LCSSA:%.*]] = phi i32 [ [[ADD]], [[FOR_BODY]] ], [ [[TMP12]], [[MIDDLE_BLOCK]] ]
; OUTLOOP-NEXT:    br label [[FOR_COND_CLEANUP]]
; OUTLOOP:       for.cond.cleanup:
; OUTLOOP-NEXT:    [[R_0_LCSSA:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[ADD_LCSSA]], [[FOR_COND_CLEANUP_LOOPEXIT]] ]
; OUTLOOP-NEXT:    ret i32 [[R_0_LCSSA]]
;
; INLOOP-LABEL: @add_i16_i32(
; INLOOP-NEXT:  entry:
; INLOOP-NEXT:    [[CMP6:%.*]] = icmp sgt i32 [[N:%.*]], 0
; INLOOP-NEXT:    br i1 [[CMP6]], label [[FOR_BODY_PREHEADER:%.*]], label [[FOR_COND_CLEANUP:%.*]]
; INLOOP:       for.body.preheader:
; INLOOP-NEXT:    [[TMP0:%.*]] = call i32 @llvm.vscale.i32()
; INLOOP-NEXT:    [[TMP1:%.*]] = mul i32 [[TMP0]], 8
; INLOOP-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i32 [[N]], [[TMP1]]
; INLOOP-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; INLOOP:       vector.ph:
; INLOOP-NEXT:    [[TMP2:%.*]] = call i32 @llvm.vscale.i32()
; INLOOP-NEXT:    [[TMP3:%.*]] = mul i32 [[TMP2]], 8
; INLOOP-NEXT:    [[N_MOD_VF:%.*]] = urem i32 [[N]], [[TMP3]]
; INLOOP-NEXT:    [[N_VEC:%.*]] = sub i32 [[N]], [[N_MOD_VF]]
; INLOOP-NEXT:    [[TMP4:%.*]] = call i32 @llvm.vscale.i32()
; INLOOP-NEXT:    [[TMP5:%.*]] = mul i32 [[TMP4]], 8
; INLOOP-NEXT:    br label [[VECTOR_BODY:%.*]]
; INLOOP:       vector.body:
; INLOOP-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; INLOOP-NEXT:    [[VEC_PHI:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[TMP11:%.*]], [[VECTOR_BODY]] ]
; INLOOP-NEXT:    [[TMP6:%.*]] = add i32 [[INDEX]], 0
; INLOOP-NEXT:    [[TMP7:%.*]] = getelementptr inbounds i16, ptr [[X:%.*]], i32 [[TMP6]]
; INLOOP-NEXT:    [[TMP8:%.*]] = getelementptr inbounds i16, ptr [[TMP7]], i32 0
; INLOOP-NEXT:    [[WIDE_LOAD:%.*]] = load <vscale x 8 x i16>, ptr [[TMP8]], align 2
; INLOOP-NEXT:    [[TMP9:%.*]] = sext <vscale x 8 x i16> [[WIDE_LOAD]] to <vscale x 8 x i32>
; INLOOP-NEXT:    [[TMP10:%.*]] = call i32 @llvm.vector.reduce.add.nxv8i32(<vscale x 8 x i32> [[TMP9]])
; INLOOP-NEXT:    [[TMP11]] = add i32 [[TMP10]], [[VEC_PHI]]
; INLOOP-NEXT:    [[INDEX_NEXT]] = add nuw i32 [[INDEX]], [[TMP5]]
; INLOOP-NEXT:    [[TMP12:%.*]] = icmp eq i32 [[INDEX_NEXT]], [[N_VEC]]
; INLOOP-NEXT:    br i1 [[TMP12]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; INLOOP:       middle.block:
; INLOOP-NEXT:    [[CMP_N:%.*]] = icmp eq i32 [[N]], [[N_VEC]]
; INLOOP-NEXT:    br i1 [[CMP_N]], label [[FOR_COND_CLEANUP_LOOPEXIT:%.*]], label [[SCALAR_PH]]
; INLOOP:       scalar.ph:
; INLOOP-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i32 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[FOR_BODY_PREHEADER]] ]
; INLOOP-NEXT:    [[BC_MERGE_RDX:%.*]] = phi i32 [ 0, [[FOR_BODY_PREHEADER]] ], [ [[TMP11]], [[MIDDLE_BLOCK]] ]
; INLOOP-NEXT:    br label [[FOR_BODY:%.*]]
; INLOOP:       for.body:
; INLOOP-NEXT:    [[I_08:%.*]] = phi i32 [ [[INC:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; INLOOP-NEXT:    [[R_07:%.*]] = phi i32 [ [[ADD:%.*]], [[FOR_BODY]] ], [ [[BC_MERGE_RDX]], [[SCALAR_PH]] ]
; INLOOP-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i16, ptr [[X]], i32 [[I_08]]
; INLOOP-NEXT:    [[TMP13:%.*]] = load i16, ptr [[ARRAYIDX]], align 2
; INLOOP-NEXT:    [[CONV:%.*]] = sext i16 [[TMP13]] to i32
; INLOOP-NEXT:    [[ADD]] = add nsw i32 [[R_07]], [[CONV]]
; INLOOP-NEXT:    [[INC]] = add nuw nsw i32 [[I_08]], 1
; INLOOP-NEXT:    [[EXITCOND:%.*]] = icmp eq i32 [[INC]], [[N]]
; INLOOP-NEXT:    br i1 [[EXITCOND]], label [[FOR_COND_CLEANUP_LOOPEXIT]], label [[FOR_BODY]], !llvm.loop [[LOOP3:![0-9]+]]
; INLOOP:       for.cond.cleanup.loopexit:
; INLOOP-NEXT:    [[ADD_LCSSA:%.*]] = phi i32 [ [[ADD]], [[FOR_BODY]] ], [ [[TMP11]], [[MIDDLE_BLOCK]] ]
; INLOOP-NEXT:    br label [[FOR_COND_CLEANUP]]
; INLOOP:       for.cond.cleanup:
; INLOOP-NEXT:    [[R_0_LCSSA:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[ADD_LCSSA]], [[FOR_COND_CLEANUP_LOOPEXIT]] ]
; INLOOP-NEXT:    ret i32 [[R_0_LCSSA]]
;
entry:
  %cmp6 = icmp sgt i32 %n, 0
  br i1 %cmp6, label %for.body, label %for.cond.cleanup

for.body:                                         ; preds = %entry, %for.body
  %i.08 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %r.07 = phi i32 [ %add, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds i16, ptr %x, i32 %i.08
  %0 = load i16, ptr %arrayidx, align 2
  %conv = sext i16 %0 to i32
  %add = add nsw i32 %r.07, %conv
  %inc = add nuw nsw i32 %i.08, 1
  %exitcond = icmp eq i32 %inc, %n
  br i1 %exitcond, label %for.cond.cleanup, label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %entry
  %r.0.lcssa = phi i32 [ 0, %entry ], [ %add, %for.body ]
  ret i32 %r.0.lcssa
}
