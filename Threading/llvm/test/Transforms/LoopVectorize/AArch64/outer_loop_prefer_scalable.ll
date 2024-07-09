; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 2
; RUN: opt -S -mtriple aarch64 -mattr=+sve -passes=loop-vectorize -enable-vplan-native-path < %s | FileCheck %s

@A = external local_unnamed_addr global [1024 x float], align 4
@B = external local_unnamed_addr global [512 x float], align 4

; Test if the vplan-native-path successfully vectorizes a loop using scalable vectors if the target preferes scalable vectors.
define void @foo() {
; CHECK-LABEL: define void @foo
; CHECK-SAME: () #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP1:%.*]] = mul i64 [[TMP0]], 4
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 1024, [[TMP1]]
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[TMP2:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP3:%.*]] = mul i64 [[TMP2]], 4
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 1024, [[TMP3]]
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 1024, [[N_MOD_VF]]
; CHECK-NEXT:    [[TMP18:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP19:%.*]] = mul i64 [[TMP18]], 4
; CHECK-NEXT:    [[TMP4:%.*]] = call <vscale x 4 x i64> @llvm.experimental.stepvector.nxv4i64()
; CHECK-NEXT:    [[TMP5:%.*]] = add <vscale x 4 x i64> [[TMP4]], zeroinitializer
; CHECK-NEXT:    [[TMP6:%.*]] = mul <vscale x 4 x i64> [[TMP5]], shufflevector (<vscale x 4 x i64> insertelement (<vscale x 4 x i64> poison, i64 1, i64 0), <vscale x 4 x i64> poison, <vscale x 4 x i32> zeroinitializer)
; CHECK-NEXT:    [[INDUCTION:%.*]] = add <vscale x 4 x i64> zeroinitializer, [[TMP6]]
; CHECK-NEXT:    [[TMP7:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP8:%.*]] = mul i64 [[TMP7]], 4
; CHECK-NEXT:    [[TMP9:%.*]] = mul i64 1, [[TMP8]]
; CHECK-NEXT:    [[DOTSPLATINSERT:%.*]] = insertelement <vscale x 4 x i64> poison, i64 [[TMP9]], i64 0
; CHECK-NEXT:    [[DOTSPLAT:%.*]] = shufflevector <vscale x 4 x i64> [[DOTSPLATINSERT]], <vscale x 4 x i64> poison, <vscale x 4 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[OUTER_LOOP_LATCH4:%.*]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <vscale x 4 x i64> [ [[INDUCTION]], [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[OUTER_LOOP_LATCH4]] ]
; CHECK-NEXT:    [[TMP10:%.*]] = getelementptr inbounds [1024 x float], ptr @A, i64 0, <vscale x 4 x i64> [[VEC_IND]]
; CHECK-NEXT:    [[WIDE_MASKED_GATHER:%.*]] = call <vscale x 4 x float> @llvm.masked.gather.nxv4f32.nxv4p0(<vscale x 4 x ptr> [[TMP10]], i32 4, <vscale x 4 x i1> shufflevector (<vscale x 4 x i1> insertelement (<vscale x 4 x i1> poison, i1 true, i64 0), <vscale x 4 x i1> poison, <vscale x 4 x i32> zeroinitializer), <vscale x 4 x float> poison)
; CHECK-NEXT:    br label [[INNER_LOOP1:%.*]]
; CHECK:       inner_loop1:
; CHECK-NEXT:    [[VEC_PHI:%.*]] = phi <vscale x 4 x i64> [ zeroinitializer, [[VECTOR_BODY]] ], [ [[TMP13:%.*]], [[INNER_LOOP1]] ]
; CHECK-NEXT:    [[VEC_PHI2:%.*]] = phi <vscale x 4 x float> [ [[WIDE_MASKED_GATHER]], [[VECTOR_BODY]] ], [ [[TMP12:%.*]], [[INNER_LOOP1]] ]
; CHECK-NEXT:    [[TMP11:%.*]] = getelementptr inbounds [512 x float], ptr @B, i64 0, <vscale x 4 x i64> [[VEC_PHI]]
; CHECK-NEXT:    [[WIDE_MASKED_GATHER3:%.*]] = call <vscale x 4 x float> @llvm.masked.gather.nxv4f32.nxv4p0(<vscale x 4 x ptr> [[TMP11]], i32 4, <vscale x 4 x i1> shufflevector (<vscale x 4 x i1> insertelement (<vscale x 4 x i1> poison, i1 true, i64 0), <vscale x 4 x i1> poison, <vscale x 4 x i32> zeroinitializer), <vscale x 4 x float> poison)
; CHECK-NEXT:    [[TMP12]] = fmul <vscale x 4 x float> [[VEC_PHI2]], [[WIDE_MASKED_GATHER3]]
; CHECK-NEXT:    [[TMP13]] = add nuw nsw <vscale x 4 x i64> [[VEC_PHI]], shufflevector (<vscale x 4 x i64> insertelement (<vscale x 4 x i64> poison, i64 1, i64 0), <vscale x 4 x i64> poison, <vscale x 4 x i32> zeroinitializer)
; CHECK-NEXT:    [[TMP14:%.*]] = icmp eq <vscale x 4 x i64> [[TMP13]], shufflevector (<vscale x 4 x i64> insertelement (<vscale x 4 x i64> poison, i64 512, i64 0), <vscale x 4 x i64> poison, <vscale x 4 x i32> zeroinitializer)
; CHECK-NEXT:    [[TMP15:%.*]] = extractelement <vscale x 4 x i1> [[TMP14]], i32 0
; CHECK-NEXT:    br i1 [[TMP15]], label [[OUTER_LOOP_LATCH4]], label [[INNER_LOOP1]]
; CHECK:       outer_loop_latch4:
; CHECK-NEXT:    [[VEC_PHI5:%.*]] = phi <vscale x 4 x float> [ [[TMP12]], [[INNER_LOOP1]] ]
; CHECK-NEXT:    call void @llvm.masked.scatter.nxv4f32.nxv4p0(<vscale x 4 x float> [[VEC_PHI5]], <vscale x 4 x ptr> [[TMP10]], i32 4, <vscale x 4 x i1> shufflevector (<vscale x 4 x i1> insertelement (<vscale x 4 x i1> poison, i1 true, i64 0), <vscale x 4 x i1> poison, <vscale x 4 x i32> zeroinitializer))
; CHECK-NEXT:    [[TMP16:%.*]] = add nuw nsw <vscale x 4 x i64> [[VEC_IND]], shufflevector (<vscale x 4 x i64> insertelement (<vscale x 4 x i64> poison, i64 1, i64 0), <vscale x 4 x i64> poison, <vscale x 4 x i32> zeroinitializer)
; CHECK-NEXT:    [[TMP17:%.*]] = icmp eq <vscale x 4 x i64> [[TMP16]], shufflevector (<vscale x 4 x i64> insertelement (<vscale x 4 x i64> poison, i64 1024, i64 0), <vscale x 4 x i64> poison, <vscale x 4 x i32> zeroinitializer)
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], [[TMP19]]
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <vscale x 4 x i64> [[VEC_IND]], [[DOTSPLAT]]
; CHECK-NEXT:    [[TMP20:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP20]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 1024, [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[OUTER_LOOP:%.*]]
; CHECK:       outer_loop:
; CHECK-NEXT:    [[I:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[I_NEXT:%.*]], [[OUTER_LOOP_LATCH:%.*]] ]
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds [1024 x float], ptr @A, i64 0, i64 [[I]]
; CHECK-NEXT:    [[X_START:%.*]] = load float, ptr [[ARRAYIDX1]], align 4
; CHECK-NEXT:    br label [[INNER_LOOP:%.*]]
; CHECK:       inner_loop:
; CHECK-NEXT:    [[J:%.*]] = phi i64 [ 0, [[OUTER_LOOP]] ], [ [[J_NEXT:%.*]], [[INNER_LOOP]] ]
; CHECK-NEXT:    [[X:%.*]] = phi float [ [[X_START]], [[OUTER_LOOP]] ], [ [[X_NEXT:%.*]], [[INNER_LOOP]] ]
; CHECK-NEXT:    [[ARRAYIDX2:%.*]] = getelementptr inbounds [512 x float], ptr @B, i64 0, i64 [[J]]
; CHECK-NEXT:    [[B:%.*]] = load float, ptr [[ARRAYIDX2]], align 4
; CHECK-NEXT:    [[X_NEXT]] = fmul float [[X]], [[B]]
; CHECK-NEXT:    [[J_NEXT]] = add nuw nsw i64 [[J]], 1
; CHECK-NEXT:    [[INNER_EXITCOND:%.*]] = icmp eq i64 [[J_NEXT]], 512
; CHECK-NEXT:    br i1 [[INNER_EXITCOND]], label [[OUTER_LOOP_LATCH]], label [[INNER_LOOP]]
; CHECK:       outer_loop_latch:
; CHECK-NEXT:    [[X_NEXT_LCSSA:%.*]] = phi float [ [[X_NEXT]], [[INNER_LOOP]] ]
; CHECK-NEXT:    store float [[X_NEXT_LCSSA]], ptr [[ARRAYIDX1]], align 4
; CHECK-NEXT:    [[I_NEXT]] = add nuw nsw i64 [[I]], 1
; CHECK-NEXT:    [[OUTER_EXITCOND:%.*]] = icmp eq i64 [[I_NEXT]], 1024
; CHECK-NEXT:    br i1 [[OUTER_EXITCOND]], label [[EXIT]], label [[OUTER_LOOP]], !llvm.loop [[LOOP3:![0-9]+]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %outer_loop

outer_loop:
  %i = phi i64 [ 0, %entry ], [ %i.next, %outer_loop_latch ]
  %arrayidx1 = getelementptr inbounds [1024 x float], ptr @A, i64 0, i64 %i
  %x.start = load float, ptr %arrayidx1, align 4
  br label %inner_loop

inner_loop:
  %j = phi i64 [ 0, %outer_loop ], [ %j.next, %inner_loop ]
  %x = phi float [ %x.start, %outer_loop ], [ %x.next, %inner_loop ]
  %arrayidx2 = getelementptr inbounds [512 x float], ptr @B, i64 0, i64 %j
  %b = load float, ptr %arrayidx2, align 4
  %x.next = fmul float %x, %b
  %j.next = add nuw nsw i64 %j, 1
  %inner_exitcond = icmp eq i64 %j.next, 512
  br i1 %inner_exitcond, label %outer_loop_latch, label %inner_loop

outer_loop_latch:
  store float %x.next, ptr %arrayidx1, align 4
  %i.next = add nuw nsw i64 %i, 1
  %outer_exitcond = icmp eq i64 %i.next, 1024
  br i1 %outer_exitcond, label %exit, label %outer_loop, !llvm.loop !1

exit:
  ret void
}

!1 = distinct !{!1, !2}
!2 = !{!"llvm.loop.vectorize.enable", i1 true}
