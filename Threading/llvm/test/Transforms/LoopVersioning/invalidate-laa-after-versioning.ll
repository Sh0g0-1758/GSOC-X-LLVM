; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes='loop-vectorize,loop-versioning' -S %s | FileCheck %s

@glob.1 = external global [100 x double]
@glob.2 = external global [100 x double]

; Test for PR57825 to make sure LAA is properly invalidated after versioning
; loops.
define void @test(ptr %arg, i64 %arg1) {
; CHECK-LABEL: @test(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    br label [[INNER_1_LVER_CHECK:%.*]]
; CHECK:       inner.1.lver.check:
; CHECK-NEXT:    [[PTR_PHI:%.*]] = phi ptr [ [[ARG:%.*]], [[BB:%.*]] ], [ @glob.1, [[OUTER_LATCH:%.*]] ]
; CHECK-NEXT:    [[GEP_1:%.*]] = getelementptr double, ptr [[PTR_PHI]], i64 3
; CHECK-NEXT:    [[IDENT_CHECK:%.*]] = icmp ne i64 [[ARG1:%.*]], 1
; CHECK-NEXT:    br i1 [[IDENT_CHECK]], label [[INNER_1_PH_LVER_ORIG:%.*]], label [[INNER_1_PH:%.*]]
; CHECK:       inner.1.ph.lver.orig:
; CHECK-NEXT:    br label [[INNER_1_LVER_ORIG:%.*]]
; CHECK:       inner.1.lver.orig:
; CHECK-NEXT:    [[IV_1_LVER_ORIG:%.*]] = phi i64 [ 0, [[INNER_1_PH_LVER_ORIG]] ], [ [[IV_NEXT_LVER_ORIG:%.*]], [[INNER_1_LVER_ORIG]] ]
; CHECK-NEXT:    [[PTR_IV_1_LVER_ORIG:%.*]] = phi ptr [ @glob.2, [[INNER_1_PH_LVER_ORIG]] ], [ [[PTR_IV_1_NEXT_LVER_ORIG:%.*]], [[INNER_1_LVER_ORIG]] ]
; CHECK-NEXT:    [[TMP25_LVER_ORIG:%.*]] = mul nuw nsw i64 [[IV_1_LVER_ORIG]], [[ARG1]]
; CHECK-NEXT:    [[GEP_2_LVER_ORIG:%.*]] = getelementptr inbounds double, ptr [[GEP_1]], i64 [[TMP25_LVER_ORIG]]
; CHECK-NEXT:    store double 0.000000e+00, ptr [[GEP_2_LVER_ORIG]], align 8
; CHECK-NEXT:    [[GEP_3_LVER_ORIG:%.*]] = getelementptr double, ptr [[PTR_PHI]], i64 [[TMP25_LVER_ORIG]]
; CHECK-NEXT:    [[GEP_4_LVER_ORIG:%.*]] = getelementptr double, ptr [[GEP_3_LVER_ORIG]], i64 2
; CHECK-NEXT:    [[TMP29_LVER_ORIG:%.*]] = load double, ptr [[GEP_4_LVER_ORIG]], align 8
; CHECK-NEXT:    [[PTR_IV_1_NEXT_LVER_ORIG]] = getelementptr inbounds double, ptr [[PTR_IV_1_LVER_ORIG]], i64 1
; CHECK-NEXT:    [[IV_NEXT_LVER_ORIG]] = add nuw nsw i64 [[IV_1_LVER_ORIG]], 1
; CHECK-NEXT:    [[C_1_LVER_ORIG:%.*]] = icmp eq i64 [[IV_1_LVER_ORIG]], 1
; CHECK-NEXT:    br i1 [[C_1_LVER_ORIG]], label [[INNER_1_EXIT_LOOPEXIT:%.*]], label [[INNER_1_LVER_ORIG]]
; CHECK:       inner.1.ph:
; CHECK-NEXT:    br label [[INNER_1:%.*]]
; CHECK:       inner.1:
; CHECK-NEXT:    [[IV_1:%.*]] = phi i64 [ 0, [[INNER_1_PH]] ], [ [[IV_NEXT:%.*]], [[INNER_1]] ]
; CHECK-NEXT:    [[PTR_IV_1:%.*]] = phi ptr [ @glob.2, [[INNER_1_PH]] ], [ [[PTR_IV_1_NEXT:%.*]], [[INNER_1]] ]
; CHECK-NEXT:    [[TMP25:%.*]] = mul nuw nsw i64 [[IV_1]], [[ARG1]]
; CHECK-NEXT:    [[GEP_2:%.*]] = getelementptr inbounds double, ptr [[GEP_1]], i64 [[TMP25]]
; CHECK-NEXT:    store double 0.000000e+00, ptr [[GEP_2]], align 8
; CHECK-NEXT:    [[GEP_3:%.*]] = getelementptr double, ptr [[PTR_PHI]], i64 [[TMP25]]
; CHECK-NEXT:    [[GEP_4:%.*]] = getelementptr double, ptr [[GEP_3]], i64 2
; CHECK-NEXT:    [[TMP29:%.*]] = load double, ptr [[GEP_4]], align 8
; CHECK-NEXT:    [[PTR_IV_1_NEXT]] = getelementptr inbounds double, ptr [[PTR_IV_1]], i64 1
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV_1]], 1
; CHECK-NEXT:    [[C_1:%.*]] = icmp eq i64 [[IV_1]], 1
; CHECK-NEXT:    br i1 [[C_1]], label [[INNER_1_EXIT_LOOPEXIT1:%.*]], label [[INNER_1]]
; CHECK:       inner.1.exit.loopexit:
; CHECK-NEXT:    [[LCSSA_PTR_IV_1_PH:%.*]] = phi ptr [ [[PTR_IV_1_LVER_ORIG]], [[INNER_1_LVER_ORIG]] ]
; CHECK-NEXT:    br label [[INNER_1_EXIT:%.*]]
; CHECK:       inner.1.exit.loopexit1:
; CHECK-NEXT:    [[LCSSA_PTR_IV_1_PH2:%.*]] = phi ptr [ [[PTR_IV_1]], [[INNER_1]] ]
; CHECK-NEXT:    br label [[INNER_1_EXIT]]
; CHECK:       inner.1.exit:
; CHECK-NEXT:    [[LCSSA_PTR_IV_1:%.*]] = phi ptr [ [[LCSSA_PTR_IV_1_PH]], [[INNER_1_EXIT_LOOPEXIT]] ], [ [[LCSSA_PTR_IV_1_PH2]], [[INNER_1_EXIT_LOOPEXIT1]] ]
; CHECK-NEXT:    [[GEP_5:%.*]] = getelementptr inbounds double, ptr [[LCSSA_PTR_IV_1]], i64 1
; CHECK-NEXT:    br label [[INNER_2:%.*]]
; CHECK:       inner.2:
; CHECK-NEXT:    [[INDVAR:%.*]] = phi i64 [ [[INDVAR_NEXT:%.*]], [[INNER_2]] ], [ 0, [[INNER_1_EXIT]] ]
; CHECK-NEXT:    [[PTR_IV_2:%.*]] = phi ptr [ [[GEP_5]], [[INNER_1_EXIT]] ], [ [[PTR_IV_2_NEXT:%.*]], [[INNER_2]] ]
; CHECK-NEXT:    [[PTR_IV_2_NEXT]] = getelementptr inbounds double, ptr [[PTR_IV_2]], i64 1
; CHECK-NEXT:    [[INDVAR_NEXT]] = add i64 [[INDVAR]], 1
; CHECK-NEXT:    br i1 false, label [[INNER_3_LVER_CHECK:%.*]], label [[INNER_2]]
; CHECK:       inner.3.lver.check:
; CHECK-NEXT:    [[INDVAR_LCSSA:%.*]] = phi i64 [ [[INDVAR]], [[INNER_2]] ]
; CHECK-NEXT:    [[LCSSA_PTR_IV_2:%.*]] = phi ptr [ [[PTR_IV_2]], [[INNER_2]] ]
; CHECK-NEXT:    [[GEP_6:%.*]] = getelementptr inbounds double, ptr [[PTR_PHI]], i64 1
; CHECK-NEXT:    [[GEP_7:%.*]] = getelementptr inbounds double, ptr [[LCSSA_PTR_IV_2]], i64 1
; CHECK-NEXT:    [[TMP0:%.*]] = shl i64 [[INDVAR_LCSSA]], 3
; CHECK-NEXT:    [[TMP1:%.*]] = add i64 [[TMP0]], 24
; CHECK-NEXT:    [[SCEVGEP:%.*]] = getelementptr i8, ptr [[LCSSA_PTR_IV_1]], i64 [[TMP1]]
; CHECK-NEXT:    [[BOUND0:%.*]] = icmp ult ptr [[GEP_7]], [[GEP_1]]
; CHECK-NEXT:    [[BOUND1:%.*]] = icmp ult ptr [[PTR_PHI]], [[SCEVGEP]]
; CHECK-NEXT:    [[FOUND_CONFLICT:%.*]] = and i1 [[BOUND0]], [[BOUND1]]
; CHECK-NEXT:    br i1 [[FOUND_CONFLICT]], label [[INNER_3_PH_LVER_ORIG:%.*]], label [[INNER_3_PH:%.*]]
; CHECK:       inner.3.ph.lver.orig:
; CHECK-NEXT:    br label [[INNER_3_LVER_ORIG:%.*]]
; CHECK:       inner.3.lver.orig:
; CHECK-NEXT:    [[IV_2_LVER_ORIG:%.*]] = phi i64 [ 0, [[INNER_3_PH_LVER_ORIG]] ], [ [[IV_2_NEXT_LVER_ORIG:%.*]], [[INNER_3_LVER_ORIG]] ]
; CHECK-NEXT:    [[GEP_8_LVER_ORIG:%.*]] = getelementptr inbounds double, ptr [[GEP_6]], i64 [[IV_2_LVER_ORIG]]
; CHECK-NEXT:    store double 0.000000e+00, ptr [[GEP_7]], align 8
; CHECK-NEXT:    store double 0.000000e+00, ptr [[GEP_8_LVER_ORIG]], align 8
; CHECK-NEXT:    [[GEP_9_LVER_ORIG:%.*]] = getelementptr double, ptr [[PTR_PHI]], i64 [[IV_2_LVER_ORIG]]
; CHECK-NEXT:    [[TMP18_LVER_ORIG:%.*]] = load double, ptr [[GEP_9_LVER_ORIG]], align 8
; CHECK-NEXT:    [[IV_2_NEXT_LVER_ORIG]] = add nuw nsw i64 [[IV_2_LVER_ORIG]], 1
; CHECK-NEXT:    [[C_2_LVER_ORIG:%.*]] = icmp eq i64 [[IV_2_LVER_ORIG]], 1
; CHECK-NEXT:    br i1 [[C_2_LVER_ORIG]], label [[OUTER_LATCH_LOOPEXIT:%.*]], label [[INNER_3_LVER_ORIG]]
; CHECK:       inner.3.ph:
; CHECK-NEXT:    br label [[INNER_3:%.*]]
; CHECK:       inner.3:
; CHECK-NEXT:    [[IV_2:%.*]] = phi i64 [ 0, [[INNER_3_PH]] ], [ [[IV_2_NEXT:%.*]], [[INNER_3]] ]
; CHECK-NEXT:    [[GEP_8:%.*]] = getelementptr inbounds double, ptr [[GEP_6]], i64 [[IV_2]]
; CHECK-NEXT:    store double 0.000000e+00, ptr [[GEP_7]], align 8, !alias.scope !0, !noalias !3
; CHECK-NEXT:    store double 0.000000e+00, ptr [[GEP_8]], align 8, !alias.scope !3
; CHECK-NEXT:    [[GEP_9:%.*]] = getelementptr double, ptr [[PTR_PHI]], i64 [[IV_2]]
; CHECK-NEXT:    [[TMP18:%.*]] = load double, ptr [[GEP_9]], align 8, !alias.scope !3
; CHECK-NEXT:    [[IV_2_NEXT]] = add nuw nsw i64 [[IV_2]], 1
; CHECK-NEXT:    [[C_2:%.*]] = icmp eq i64 [[IV_2]], 1
; CHECK-NEXT:    br i1 [[C_2]], label [[OUTER_LATCH_LOOPEXIT3:%.*]], label [[INNER_3]]
; CHECK:       outer.latch.loopexit:
; CHECK-NEXT:    br label [[OUTER_LATCH]]
; CHECK:       outer.latch.loopexit3:
; CHECK-NEXT:    br label [[OUTER_LATCH]]
; CHECK:       outer.latch:
; CHECK-NEXT:    br label [[INNER_1_LVER_CHECK]]
;
bb:
  br label %outer.header

outer.header:                                              ; preds = %bb21, %bb
  %ptr.phi = phi ptr [ %arg, %bb ], [ @glob.1, %outer.latch ]
  %gep.1 = getelementptr inbounds double, ptr %ptr.phi, i64 3
  br label %inner.1

inner.1:
  %iv.1 = phi i64 [ 0, %outer.header ], [ %iv.next, %inner.1 ]
  %ptr.iv.1 = phi ptr [ @glob.2, %outer.header ], [ %ptr.iv.1.next, %inner.1 ]
  %tmp25 = mul nuw nsw i64 %iv.1, %arg1
  %gep.2 = getelementptr inbounds double, ptr %gep.1, i64 %tmp25
  store double 0.000000e+00, ptr %gep.2, align 8
  %gep.3 = getelementptr double, ptr %ptr.phi, i64 %tmp25
  %gep.4 = getelementptr double, ptr %gep.3, i64 2
  %tmp29 = load double, ptr %gep.4, align 8
  %ptr.iv.1.next = getelementptr inbounds double, ptr %ptr.iv.1, i64 1
  %iv.next = add nuw nsw i64 %iv.1, 1
  %c.1 = icmp eq i64 %iv.1, 1
  br i1 %c.1, label %inner.1.exit, label %inner.1

inner.1.exit:                                              ; preds = %bb22
  %lcssa.ptr.iv.1 = phi ptr [ %ptr.iv.1, %inner.1 ]
  %gep.5 = getelementptr inbounds double, ptr %lcssa.ptr.iv.1, i64 1
  br label %inner.2

inner.2:
  %ptr.iv.2 = phi ptr [ %gep.5, %inner.1.exit ], [ %ptr.iv.2.next, %inner.2 ]
  %ptr.iv.2.next = getelementptr inbounds double, ptr %ptr.iv.2, i64 1
  br i1 false, label %inner.2.exit, label %inner.2

inner.2.exit:
  %lcssa.ptr.iv.2 = phi ptr [ %ptr.iv.2, %inner.2 ]
  %gep.6 = getelementptr inbounds double, ptr %ptr.phi, i64 1
  %gep.7 = getelementptr inbounds double, ptr %lcssa.ptr.iv.2, i64 1
  br label %inner.3

inner.3:                                             ; preds = %bb14, %bb10
  %iv.2 = phi i64 [ 0, %inner.2.exit ], [ %iv.2.next, %inner.3 ]
  %gep.8 = getelementptr inbounds double, ptr %gep.6, i64 %iv.2
  store double 0.000000e+00, ptr %gep.7, align 8
  store double 0.000000e+00, ptr %gep.8, align 8
  %gep.9 = getelementptr double, ptr %ptr.phi, i64 %iv.2
  %tmp18 = load double, ptr %gep.9, align 8
  %iv.2.next = add nuw nsw i64 %iv.2, 1
  %c.2 = icmp eq i64 %iv.2, 1
  br i1 %c.2, label %outer.latch, label %inner.3

outer.latch:
  br label %outer.header
}
