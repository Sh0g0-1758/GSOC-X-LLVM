; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=loop-vectorize -riscv-v-vector-bits-min=128 -scalable-vectorization=on -force-target-instruction-cost=1 -S < %s | FileCheck %s

target triple = "riscv64"

define void @trip1_i8(ptr noalias nocapture noundef %dst, ptr noalias nocapture noundef readonly %src) #0 {
; CHECK-LABEL: @trip1_i8(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_08:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[INC:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i8, ptr [[SRC:%.*]], i64 [[I_08]]
; CHECK-NEXT:    [[TMP0:%.*]] = load i8, ptr [[ARRAYIDX]], align 1
; CHECK-NEXT:    [[MUL:%.*]] = shl i8 [[TMP0]], 1
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds i8, ptr [[DST:%.*]], i64 [[I_08]]
; CHECK-NEXT:    [[TMP1:%.*]] = load i8, ptr [[ARRAYIDX1]], align 1
; CHECK-NEXT:    [[ADD:%.*]] = add i8 [[MUL]], [[TMP1]]
; CHECK-NEXT:    store i8 [[ADD]], ptr [[ARRAYIDX1]], align 1
; CHECK-NEXT:    [[INC]] = add nuw nsw i64 [[I_08]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[INC]], 1
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[FOR_END:%.*]], label [[FOR_BODY]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %i.08 = phi i64 [ 0, %entry ], [ %inc, %for.body ]
  %arrayidx = getelementptr inbounds i8, ptr %src, i64 %i.08
  %0 = load i8, ptr %arrayidx, align 1
  %mul = shl i8 %0, 1
  %arrayidx1 = getelementptr inbounds i8, ptr %dst, i64 %i.08
  %1 = load i8, ptr %arrayidx1, align 1
  %add = add i8 %mul, %1
  store i8 %add, ptr %arrayidx1, align 1
  %inc = add nuw nsw i64 %i.08, 1
  %exitcond.not = icmp eq i64 %inc, 1
  br i1 %exitcond.not, label %for.end, label %for.body

for.end:                                          ; preds = %for.body
  ret void
}

define void @trip3_i8(ptr noalias nocapture noundef %dst, ptr noalias nocapture noundef readonly %src) #0 {
; CHECK-LABEL: @trip3_i8(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[TMP0:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP1:%.*]] = mul i64 [[TMP0]], 16
; CHECK-NEXT:    [[TMP2:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP3:%.*]] = mul i64 [[TMP2]], 16
; CHECK-NEXT:    [[TMP4:%.*]] = sub i64 [[TMP3]], 1
; CHECK-NEXT:    [[N_RND_UP:%.*]] = add i64 3, [[TMP4]]
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[N_RND_UP]], [[TMP1]]
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 [[N_RND_UP]], [[N_MOD_VF]]
; CHECK-NEXT:    [[TMP5:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP6:%.*]] = mul i64 [[TMP5]], 16
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP7:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[ACTIVE_LANE_MASK:%.*]] = call <vscale x 16 x i1> @llvm.get.active.lane.mask.nxv16i1.i64(i64 [[TMP7]], i64 3)
; CHECK-NEXT:    [[TMP8:%.*]] = getelementptr inbounds i8, ptr [[SRC:%.*]], i64 [[TMP7]]
; CHECK-NEXT:    [[TMP9:%.*]] = getelementptr inbounds i8, ptr [[TMP8]], i32 0
; CHECK-NEXT:    [[WIDE_MASKED_LOAD:%.*]] = call <vscale x 16 x i8> @llvm.masked.load.nxv16i8.p0(ptr [[TMP9]], i32 1, <vscale x 16 x i1> [[ACTIVE_LANE_MASK]], <vscale x 16 x i8> poison)
; CHECK-NEXT:    [[TMP10:%.*]] = shl <vscale x 16 x i8> [[WIDE_MASKED_LOAD]], shufflevector (<vscale x 16 x i8> insertelement (<vscale x 16 x i8> poison, i8 1, i64 0), <vscale x 16 x i8> poison, <vscale x 16 x i32> zeroinitializer)
; CHECK-NEXT:    [[TMP11:%.*]] = getelementptr inbounds i8, ptr [[DST:%.*]], i64 [[TMP7]]
; CHECK-NEXT:    [[TMP12:%.*]] = getelementptr inbounds i8, ptr [[TMP11]], i32 0
; CHECK-NEXT:    [[WIDE_MASKED_LOAD1:%.*]] = call <vscale x 16 x i8> @llvm.masked.load.nxv16i8.p0(ptr [[TMP12]], i32 1, <vscale x 16 x i1> [[ACTIVE_LANE_MASK]], <vscale x 16 x i8> poison)
; CHECK-NEXT:    [[TMP13:%.*]] = add <vscale x 16 x i8> [[TMP10]], [[WIDE_MASKED_LOAD1]]
; CHECK-NEXT:    call void @llvm.masked.store.nxv16i8.p0(<vscale x 16 x i8> [[TMP13]], ptr [[TMP12]], i32 1, <vscale x 16 x i1> [[ACTIVE_LANE_MASK]])
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], [[TMP6]]
; CHECK-NEXT:    br i1 true, label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    br i1 true, label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_08:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[INC:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i8, ptr [[SRC]], i64 [[I_08]]
; CHECK-NEXT:    [[TMP14:%.*]] = load i8, ptr [[ARRAYIDX]], align 1
; CHECK-NEXT:    [[MUL:%.*]] = shl i8 [[TMP14]], 1
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds i8, ptr [[DST]], i64 [[I_08]]
; CHECK-NEXT:    [[TMP15:%.*]] = load i8, ptr [[ARRAYIDX1]], align 1
; CHECK-NEXT:    [[ADD:%.*]] = add i8 [[MUL]], [[TMP15]]
; CHECK-NEXT:    store i8 [[ADD]], ptr [[ARRAYIDX1]], align 1
; CHECK-NEXT:    [[INC]] = add nuw nsw i64 [[I_08]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[INC]], 3
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[FOR_END]], label [[FOR_BODY]], !llvm.loop [[LOOP3:![0-9]+]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %i.08 = phi i64 [ 0, %entry ], [ %inc, %for.body ]
  %arrayidx = getelementptr inbounds i8, ptr %src, i64 %i.08
  %0 = load i8, ptr %arrayidx, align 1
  %mul = shl i8 %0, 1
  %arrayidx1 = getelementptr inbounds i8, ptr %dst, i64 %i.08
  %1 = load i8, ptr %arrayidx1, align 1
  %add = add i8 %mul, %1
  store i8 %add, ptr %arrayidx1, align 1
  %inc = add nuw nsw i64 %i.08, 1
  %exitcond.not = icmp eq i64 %inc, 3
  br i1 %exitcond.not, label %for.end, label %for.body

for.end:                                          ; preds = %for.body
  ret void
}

define void @trip5_i8(ptr noalias nocapture noundef %dst, ptr noalias nocapture noundef readonly %src) #0 {
; CHECK-LABEL: @trip5_i8(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[TMP0:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP1:%.*]] = mul i64 [[TMP0]], 16
; CHECK-NEXT:    [[TMP2:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP3:%.*]] = mul i64 [[TMP2]], 16
; CHECK-NEXT:    [[TMP4:%.*]] = sub i64 [[TMP3]], 1
; CHECK-NEXT:    [[N_RND_UP:%.*]] = add i64 5, [[TMP4]]
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[N_RND_UP]], [[TMP1]]
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 [[N_RND_UP]], [[N_MOD_VF]]
; CHECK-NEXT:    [[TMP5:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP6:%.*]] = mul i64 [[TMP5]], 16
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP7:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[ACTIVE_LANE_MASK:%.*]] = call <vscale x 16 x i1> @llvm.get.active.lane.mask.nxv16i1.i64(i64 [[TMP7]], i64 5)
; CHECK-NEXT:    [[TMP8:%.*]] = getelementptr inbounds i8, ptr [[SRC:%.*]], i64 [[TMP7]]
; CHECK-NEXT:    [[TMP9:%.*]] = getelementptr inbounds i8, ptr [[TMP8]], i32 0
; CHECK-NEXT:    [[WIDE_MASKED_LOAD:%.*]] = call <vscale x 16 x i8> @llvm.masked.load.nxv16i8.p0(ptr [[TMP9]], i32 1, <vscale x 16 x i1> [[ACTIVE_LANE_MASK]], <vscale x 16 x i8> poison)
; CHECK-NEXT:    [[TMP10:%.*]] = shl <vscale x 16 x i8> [[WIDE_MASKED_LOAD]], shufflevector (<vscale x 16 x i8> insertelement (<vscale x 16 x i8> poison, i8 1, i64 0), <vscale x 16 x i8> poison, <vscale x 16 x i32> zeroinitializer)
; CHECK-NEXT:    [[TMP11:%.*]] = getelementptr inbounds i8, ptr [[DST:%.*]], i64 [[TMP7]]
; CHECK-NEXT:    [[TMP12:%.*]] = getelementptr inbounds i8, ptr [[TMP11]], i32 0
; CHECK-NEXT:    [[WIDE_MASKED_LOAD1:%.*]] = call <vscale x 16 x i8> @llvm.masked.load.nxv16i8.p0(ptr [[TMP12]], i32 1, <vscale x 16 x i1> [[ACTIVE_LANE_MASK]], <vscale x 16 x i8> poison)
; CHECK-NEXT:    [[TMP13:%.*]] = add <vscale x 16 x i8> [[TMP10]], [[WIDE_MASKED_LOAD1]]
; CHECK-NEXT:    call void @llvm.masked.store.nxv16i8.p0(<vscale x 16 x i8> [[TMP13]], ptr [[TMP12]], i32 1, <vscale x 16 x i1> [[ACTIVE_LANE_MASK]])
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], [[TMP6]]
; CHECK-NEXT:    br i1 true, label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP4:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    br i1 true, label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_08:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[INC:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i8, ptr [[SRC]], i64 [[I_08]]
; CHECK-NEXT:    [[TMP14:%.*]] = load i8, ptr [[ARRAYIDX]], align 1
; CHECK-NEXT:    [[MUL:%.*]] = shl i8 [[TMP14]], 1
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds i8, ptr [[DST]], i64 [[I_08]]
; CHECK-NEXT:    [[TMP15:%.*]] = load i8, ptr [[ARRAYIDX1]], align 1
; CHECK-NEXT:    [[ADD:%.*]] = add i8 [[MUL]], [[TMP15]]
; CHECK-NEXT:    store i8 [[ADD]], ptr [[ARRAYIDX1]], align 1
; CHECK-NEXT:    [[INC]] = add nuw nsw i64 [[I_08]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[INC]], 5
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[FOR_END]], label [[FOR_BODY]], !llvm.loop [[LOOP5:![0-9]+]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %i.08 = phi i64 [ 0, %entry ], [ %inc, %for.body ]
  %arrayidx = getelementptr inbounds i8, ptr %src, i64 %i.08
  %0 = load i8, ptr %arrayidx, align 1
  %mul = shl i8 %0, 1
  %arrayidx1 = getelementptr inbounds i8, ptr %dst, i64 %i.08
  %1 = load i8, ptr %arrayidx1, align 1
  %add = add i8 %mul, %1
  store i8 %add, ptr %arrayidx1, align 1
  %inc = add nuw nsw i64 %i.08, 1
  %exitcond.not = icmp eq i64 %inc, 5
  br i1 %exitcond.not, label %for.end, label %for.body

for.end:                                          ; preds = %for.body
  ret void
}

define void @trip8_i8(ptr noalias nocapture noundef %dst, ptr noalias nocapture noundef readonly %src) #0 {
; CHECK-LABEL: @trip8_i8(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[TMP0:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP1:%.*]] = mul i64 [[TMP0]], 8
; CHECK-NEXT:    [[TMP2:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP3:%.*]] = mul i64 [[TMP2]], 8
; CHECK-NEXT:    [[TMP4:%.*]] = sub i64 [[TMP3]], 1
; CHECK-NEXT:    [[N_RND_UP:%.*]] = add i64 8, [[TMP4]]
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[N_RND_UP]], [[TMP1]]
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 [[N_RND_UP]], [[N_MOD_VF]]
; CHECK-NEXT:    [[TMP5:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP6:%.*]] = mul i64 [[TMP5]], 8
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP7:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[ACTIVE_LANE_MASK:%.*]] = call <vscale x 8 x i1> @llvm.get.active.lane.mask.nxv8i1.i64(i64 [[TMP7]], i64 8)
; CHECK-NEXT:    [[TMP8:%.*]] = getelementptr inbounds i8, ptr [[SRC:%.*]], i64 [[TMP7]]
; CHECK-NEXT:    [[TMP9:%.*]] = getelementptr inbounds i8, ptr [[TMP8]], i32 0
; CHECK-NEXT:    [[WIDE_MASKED_LOAD:%.*]] = call <vscale x 8 x i8> @llvm.masked.load.nxv8i8.p0(ptr [[TMP9]], i32 1, <vscale x 8 x i1> [[ACTIVE_LANE_MASK]], <vscale x 8 x i8> poison)
; CHECK-NEXT:    [[TMP10:%.*]] = shl <vscale x 8 x i8> [[WIDE_MASKED_LOAD]], shufflevector (<vscale x 8 x i8> insertelement (<vscale x 8 x i8> poison, i8 1, i64 0), <vscale x 8 x i8> poison, <vscale x 8 x i32> zeroinitializer)
; CHECK-NEXT:    [[TMP11:%.*]] = getelementptr inbounds i8, ptr [[DST:%.*]], i64 [[TMP7]]
; CHECK-NEXT:    [[TMP12:%.*]] = getelementptr inbounds i8, ptr [[TMP11]], i32 0
; CHECK-NEXT:    [[WIDE_MASKED_LOAD1:%.*]] = call <vscale x 8 x i8> @llvm.masked.load.nxv8i8.p0(ptr [[TMP12]], i32 1, <vscale x 8 x i1> [[ACTIVE_LANE_MASK]], <vscale x 8 x i8> poison)
; CHECK-NEXT:    [[TMP13:%.*]] = add <vscale x 8 x i8> [[TMP10]], [[WIDE_MASKED_LOAD1]]
; CHECK-NEXT:    call void @llvm.masked.store.nxv8i8.p0(<vscale x 8 x i8> [[TMP13]], ptr [[TMP12]], i32 1, <vscale x 8 x i1> [[ACTIVE_LANE_MASK]])
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], [[TMP6]]
; CHECK-NEXT:    br i1 true, label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP6:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    br i1 true, label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_08:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[INC:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i8, ptr [[SRC]], i64 [[I_08]]
; CHECK-NEXT:    [[TMP14:%.*]] = load i8, ptr [[ARRAYIDX]], align 1
; CHECK-NEXT:    [[MUL:%.*]] = shl i8 [[TMP14]], 1
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds i8, ptr [[DST]], i64 [[I_08]]
; CHECK-NEXT:    [[TMP15:%.*]] = load i8, ptr [[ARRAYIDX1]], align 1
; CHECK-NEXT:    [[ADD:%.*]] = add i8 [[MUL]], [[TMP15]]
; CHECK-NEXT:    store i8 [[ADD]], ptr [[ARRAYIDX1]], align 1
; CHECK-NEXT:    [[INC]] = add nuw nsw i64 [[I_08]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[INC]], 8
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[FOR_END]], label [[FOR_BODY]], !llvm.loop [[LOOP7:![0-9]+]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %i.08 = phi i64 [ 0, %entry ], [ %inc, %for.body ]
  %arrayidx = getelementptr inbounds i8, ptr %src, i64 %i.08
  %0 = load i8, ptr %arrayidx, align 1
  %mul = shl i8 %0, 1
  %arrayidx1 = getelementptr inbounds i8, ptr %dst, i64 %i.08
  %1 = load i8, ptr %arrayidx1, align 1
  %add = add i8 %mul, %1
  store i8 %add, ptr %arrayidx1, align 1
  %inc = add nuw nsw i64 %i.08, 1
  %exitcond.not = icmp eq i64 %inc, 8
  br i1 %exitcond.not, label %for.end, label %for.body

for.end:                                          ; preds = %for.body
  ret void
}

define void @trip16_i8(ptr noalias nocapture noundef %dst, ptr noalias nocapture noundef readonly %src) #0 {
; CHECK-LABEL: @trip16_i8(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i8, ptr [[SRC:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i8, ptr [[TMP1]], i32 0
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <16 x i8>, ptr [[TMP2]], align 1
; CHECK-NEXT:    [[TMP3:%.*]] = shl <16 x i8> [[WIDE_LOAD]], <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i8, ptr [[DST:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds i8, ptr [[TMP4]], i32 0
; CHECK-NEXT:    [[WIDE_LOAD1:%.*]] = load <16 x i8>, ptr [[TMP5]], align 1
; CHECK-NEXT:    [[TMP6:%.*]] = add <16 x i8> [[TMP3]], [[WIDE_LOAD1]]
; CHECK-NEXT:    store <16 x i8> [[TMP6]], ptr [[TMP5]], align 1
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 16
; CHECK-NEXT:    br i1 true, label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP8:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    br i1 true, label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 16, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_08:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[INC:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i8, ptr [[SRC]], i64 [[I_08]]
; CHECK-NEXT:    [[TMP7:%.*]] = load i8, ptr [[ARRAYIDX]], align 1
; CHECK-NEXT:    [[MUL:%.*]] = shl i8 [[TMP7]], 1
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds i8, ptr [[DST]], i64 [[I_08]]
; CHECK-NEXT:    [[TMP8:%.*]] = load i8, ptr [[ARRAYIDX1]], align 1
; CHECK-NEXT:    [[ADD:%.*]] = add i8 [[MUL]], [[TMP8]]
; CHECK-NEXT:    store i8 [[ADD]], ptr [[ARRAYIDX1]], align 1
; CHECK-NEXT:    [[INC]] = add nuw nsw i64 [[I_08]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[INC]], 16
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[FOR_END]], label [[FOR_BODY]], !llvm.loop [[LOOP9:![0-9]+]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %i.08 = phi i64 [ 0, %entry ], [ %inc, %for.body ]
  %arrayidx = getelementptr inbounds i8, ptr %src, i64 %i.08
  %0 = load i8, ptr %arrayidx, align 1
  %mul = shl i8 %0, 1
  %arrayidx1 = getelementptr inbounds i8, ptr %dst, i64 %i.08
  %1 = load i8, ptr %arrayidx1, align 1
  %add = add i8 %mul, %1
  store i8 %add, ptr %arrayidx1, align 1
  %inc = add nuw nsw i64 %i.08, 1
  %exitcond.not = icmp eq i64 %inc, 16
  br i1 %exitcond.not, label %for.end, label %for.body

for.end:                                          ; preds = %for.body
  ret void
}


define void @trip32_i8(ptr noalias nocapture noundef %dst, ptr noalias nocapture noundef readonly %src) #0 {
; CHECK-LABEL: @trip32_i8(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i8, ptr [[SRC:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i8, ptr [[TMP1]], i32 0
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <32 x i8>, ptr [[TMP2]], align 1
; CHECK-NEXT:    [[TMP3:%.*]] = shl <32 x i8> [[WIDE_LOAD]], <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i8, ptr [[DST:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds i8, ptr [[TMP4]], i32 0
; CHECK-NEXT:    [[WIDE_LOAD1:%.*]] = load <32 x i8>, ptr [[TMP5]], align 1
; CHECK-NEXT:    [[TMP6:%.*]] = add <32 x i8> [[TMP3]], [[WIDE_LOAD1]]
; CHECK-NEXT:    store <32 x i8> [[TMP6]], ptr [[TMP5]], align 1
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 32
; CHECK-NEXT:    br i1 true, label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP10:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    br i1 true, label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 32, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_08:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[INC:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i8, ptr [[SRC]], i64 [[I_08]]
; CHECK-NEXT:    [[TMP7:%.*]] = load i8, ptr [[ARRAYIDX]], align 1
; CHECK-NEXT:    [[MUL:%.*]] = shl i8 [[TMP7]], 1
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds i8, ptr [[DST]], i64 [[I_08]]
; CHECK-NEXT:    [[TMP8:%.*]] = load i8, ptr [[ARRAYIDX1]], align 1
; CHECK-NEXT:    [[ADD:%.*]] = add i8 [[MUL]], [[TMP8]]
; CHECK-NEXT:    store i8 [[ADD]], ptr [[ARRAYIDX1]], align 1
; CHECK-NEXT:    [[INC]] = add nuw nsw i64 [[I_08]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[INC]], 32
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[FOR_END]], label [[FOR_BODY]], !llvm.loop [[LOOP11:![0-9]+]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %i.08 = phi i64 [ 0, %entry ], [ %inc, %for.body ]
  %arrayidx = getelementptr inbounds i8, ptr %src, i64 %i.08
  %0 = load i8, ptr %arrayidx, align 1
  %mul = shl i8 %0, 1
  %arrayidx1 = getelementptr inbounds i8, ptr %dst, i64 %i.08
  %1 = load i8, ptr %arrayidx1, align 1
  %add = add i8 %mul, %1
  store i8 %add, ptr %arrayidx1, align 1
  %inc = add nuw nsw i64 %i.08, 1
  %exitcond.not = icmp eq i64 %inc, 32
  br i1 %exitcond.not, label %for.end, label %for.body

for.end:                                          ; preds = %for.body
  ret void
}

define void @trip24_i8(ptr noalias nocapture noundef %dst, ptr noalias nocapture noundef readonly %src) #0 {
; CHECK-LABEL: @trip24_i8(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i8, ptr [[SRC:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i8, ptr [[TMP1]], i32 0
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <8 x i8>, ptr [[TMP2]], align 1
; CHECK-NEXT:    [[TMP3:%.*]] = shl <8 x i8> [[WIDE_LOAD]], <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i8, ptr [[DST:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds i8, ptr [[TMP4]], i32 0
; CHECK-NEXT:    [[WIDE_LOAD1:%.*]] = load <8 x i8>, ptr [[TMP5]], align 1
; CHECK-NEXT:    [[TMP6:%.*]] = add <8 x i8> [[TMP3]], [[WIDE_LOAD1]]
; CHECK-NEXT:    store <8 x i8> [[TMP6]], ptr [[TMP5]], align 1
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 8
; CHECK-NEXT:    [[TMP7:%.*]] = icmp eq i64 [[INDEX_NEXT]], 24
; CHECK-NEXT:    br i1 [[TMP7]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP12:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    br i1 true, label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 24, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_08:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[INC:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i8, ptr [[SRC]], i64 [[I_08]]
; CHECK-NEXT:    [[TMP8:%.*]] = load i8, ptr [[ARRAYIDX]], align 1
; CHECK-NEXT:    [[MUL:%.*]] = shl i8 [[TMP8]], 1
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds i8, ptr [[DST]], i64 [[I_08]]
; CHECK-NEXT:    [[TMP9:%.*]] = load i8, ptr [[ARRAYIDX1]], align 1
; CHECK-NEXT:    [[ADD:%.*]] = add i8 [[MUL]], [[TMP9]]
; CHECK-NEXT:    store i8 [[ADD]], ptr [[ARRAYIDX1]], align 1
; CHECK-NEXT:    [[INC]] = add nuw nsw i64 [[I_08]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[INC]], 24
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[FOR_END]], label [[FOR_BODY]], !llvm.loop [[LOOP13:![0-9]+]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %i.08 = phi i64 [ 0, %entry ], [ %inc, %for.body ]
  %arrayidx = getelementptr inbounds i8, ptr %src, i64 %i.08
  %0 = load i8, ptr %arrayidx, align 1
  %mul = shl i8 %0, 1
  %arrayidx1 = getelementptr inbounds i8, ptr %dst, i64 %i.08
  %1 = load i8, ptr %arrayidx1, align 1
  %add = add i8 %mul, %1
  store i8 %add, ptr %arrayidx1, align 1
  %inc = add nuw nsw i64 %i.08, 1
  %exitcond.not = icmp eq i64 %inc, 24
  br i1 %exitcond.not, label %for.end, label %for.body

for.end:                                          ; preds = %for.body
  ret void
}

attributes #0 = { "target-features"="+v,+d" vscale_range(2, 1024) }

