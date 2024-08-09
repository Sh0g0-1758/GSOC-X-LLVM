; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=loop-vectorize -force-vector-width=2 -force-vector-interleave=1 -S %s | FileCheck %s

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128-ni:1"

declare void @init(ptr nocapture nofree)

; Test case where the predicated load in the loop has an access size of 2 but
; has an alignment of 4.
define i16 @test_access_size_not_multiple_of_align(i64 %len, ptr %test_base) {
; CHECK-LABEL: @test_access_size_not_multiple_of_align(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ALLOCA:%.*]] = alloca [163840 x i16], align 4
; CHECK-NEXT:    call void @init(ptr [[ALLOCA]])
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[PRED_LOAD_CONTINUE2:%.*]] ]
; CHECK-NEXT:    [[VEC_PHI:%.*]] = phi <2 x i16> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP16:%.*]], [[PRED_LOAD_CONTINUE2]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i8, ptr [[TEST_BASE:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i8, ptr [[TMP1]], i32 0
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <2 x i8>, ptr [[TMP2]], align 1
; CHECK-NEXT:    [[TMP3:%.*]] = icmp sge <2 x i8> [[WIDE_LOAD]], zeroinitializer
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <2 x i1> [[TMP3]], i32 0
; CHECK-NEXT:    br i1 [[TMP4]], label [[PRED_LOAD_IF:%.*]], label [[PRED_LOAD_CONTINUE:%.*]]
; CHECK:       pred.load.if:
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds i16, ptr [[ALLOCA]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP6:%.*]] = load i16, ptr [[TMP5]], align 4
; CHECK-NEXT:    [[TMP7:%.*]] = insertelement <2 x i16> poison, i16 [[TMP6]], i32 0
; CHECK-NEXT:    br label [[PRED_LOAD_CONTINUE]]
; CHECK:       pred.load.continue:
; CHECK-NEXT:    [[TMP8:%.*]] = phi <2 x i16> [ poison, [[VECTOR_BODY]] ], [ [[TMP7]], [[PRED_LOAD_IF]] ]
; CHECK-NEXT:    [[TMP9:%.*]] = extractelement <2 x i1> [[TMP3]], i32 1
; CHECK-NEXT:    br i1 [[TMP9]], label [[PRED_LOAD_IF1:%.*]], label [[PRED_LOAD_CONTINUE2]]
; CHECK:       pred.load.if1:
; CHECK-NEXT:    [[TMP10:%.*]] = add i64 [[INDEX]], 1
; CHECK-NEXT:    [[TMP11:%.*]] = getelementptr inbounds i16, ptr [[ALLOCA]], i64 [[TMP10]]
; CHECK-NEXT:    [[TMP12:%.*]] = load i16, ptr [[TMP11]], align 4
; CHECK-NEXT:    [[TMP13:%.*]] = insertelement <2 x i16> [[TMP8]], i16 [[TMP12]], i32 1
; CHECK-NEXT:    br label [[PRED_LOAD_CONTINUE2]]
; CHECK:       pred.load.continue2:
; CHECK-NEXT:    [[TMP14:%.*]] = phi <2 x i16> [ [[TMP8]], [[PRED_LOAD_CONTINUE]] ], [ [[TMP13]], [[PRED_LOAD_IF1]] ]
; CHECK-NEXT:    [[TMP15:%.*]] = xor <2 x i1> [[TMP3]], <i1 true, i1 true>
; CHECK-NEXT:    [[PREDPHI:%.*]] = select <2 x i1> [[TMP3]], <2 x i16> [[TMP14]], <2 x i16> zeroinitializer
; CHECK-NEXT:    [[TMP16]] = add <2 x i16> [[VEC_PHI]], [[PREDPHI]]
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 2
; CHECK-NEXT:    [[TMP17:%.*]] = icmp eq i64 [[INDEX_NEXT]], 4096
; CHECK-NEXT:    br i1 [[TMP17]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[TMP18:%.*]] = call i16 @llvm.vector.reduce.add.v2i16(<2 x i16> [[TMP16]])
; CHECK-NEXT:    br i1 true, label [[LOOP_EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 4096, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[BC_MERGE_RDX:%.*]] = phi i16 [ 0, [[ENTRY]] ], [ [[TMP18]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[LATCH:%.*]] ]
; CHECK-NEXT:    [[ACCUM:%.*]] = phi i16 [ [[BC_MERGE_RDX]], [[SCALAR_PH]] ], [ [[ACCUM_NEXT:%.*]], [[LATCH]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add i64 [[IV]], 1
; CHECK-NEXT:    [[TEST_ADDR:%.*]] = getelementptr inbounds i8, ptr [[TEST_BASE]], i64 [[IV]]
; CHECK-NEXT:    [[L_T:%.*]] = load i8, ptr [[TEST_ADDR]], align 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp sge i8 [[L_T]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[PRED:%.*]], label [[LATCH]]
; CHECK:       pred:
; CHECK-NEXT:    [[ADDR:%.*]] = getelementptr inbounds i16, ptr [[ALLOCA]], i64 [[IV]]
; CHECK-NEXT:    [[VAL:%.*]] = load i16, ptr [[ADDR]], align 4
; CHECK-NEXT:    br label [[LATCH]]
; CHECK:       latch:
; CHECK-NEXT:    [[VAL_PHI:%.*]] = phi i16 [ 0, [[LOOP]] ], [ [[VAL]], [[PRED]] ]
; CHECK-NEXT:    [[ACCUM_NEXT]] = add i16 [[ACCUM]], [[VAL_PHI]]
; CHECK-NEXT:    [[EXIT:%.*]] = icmp eq i64 [[IV]], 4095
; CHECK-NEXT:    br i1 [[EXIT]], label [[LOOP_EXIT]], label [[LOOP]], !llvm.loop [[LOOP3:![0-9]+]]
; CHECK:       loop_exit:
; CHECK-NEXT:    [[ACCUM_NEXT_LCSSA:%.*]] = phi i16 [ [[ACCUM_NEXT]], [[LATCH]] ], [ [[TMP18]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    ret i16 [[ACCUM_NEXT_LCSSA]]
;
entry:
  %alloca = alloca [163840 x i16], align 4
  call void @init(ptr %alloca)
  br label %loop
loop:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %latch ]
  %accum = phi i16 [ 0, %entry ], [ %accum.next, %latch ]
  %iv.next = add i64 %iv, 1
  %test_addr = getelementptr inbounds i8, ptr %test_base, i64 %iv
  %l.t = load i8, ptr %test_addr
  %cmp = icmp sge i8 %l.t, 0
  br i1 %cmp, label %pred, label %latch
pred:
  %addr = getelementptr inbounds i16, ptr %alloca, i64 %iv
  %val = load i16, ptr %addr, align 4
  br label %latch
latch:
  %val.phi = phi i16 [0, %loop], [%val, %pred]
  %accum.next = add i16 %accum, %val.phi
  %exit = icmp eq i64 %iv, 4095
  br i1 %exit, label %loop_exit, label %loop

loop_exit:
  ret i16 %accum.next
}

; Test case where the predicated load in the loop has an access size of 4 and
; an alignment of 4, but the start pointer is offset by 1.
define i32 @test_access_size_multiple_of_align_but_offset_by_1(i64 %len, ptr %test_base) {
; CHECK-LABEL: @test_access_size_multiple_of_align_but_offset_by_1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ALLOCA:%.*]] = alloca [163840 x i32], align 4
; CHECK-NEXT:    call void @init(ptr [[ALLOCA]])
; CHECK-NEXT:    [[START:%.*]] = getelementptr i8, ptr [[ALLOCA]], i64 2
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[PRED_LOAD_CONTINUE2:%.*]] ]
; CHECK-NEXT:    [[VEC_PHI:%.*]] = phi <2 x i32> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP16:%.*]], [[PRED_LOAD_CONTINUE2]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i8, ptr [[TEST_BASE:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i8, ptr [[TMP1]], i32 0
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <2 x i8>, ptr [[TMP2]], align 1
; CHECK-NEXT:    [[TMP3:%.*]] = icmp sge <2 x i8> [[WIDE_LOAD]], zeroinitializer
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <2 x i1> [[TMP3]], i32 0
; CHECK-NEXT:    br i1 [[TMP4]], label [[PRED_LOAD_IF:%.*]], label [[PRED_LOAD_CONTINUE:%.*]]
; CHECK:       pred.load.if:
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds i32, ptr [[START]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP6:%.*]] = load i32, ptr [[TMP5]], align 4
; CHECK-NEXT:    [[TMP7:%.*]] = insertelement <2 x i32> poison, i32 [[TMP6]], i32 0
; CHECK-NEXT:    br label [[PRED_LOAD_CONTINUE]]
; CHECK:       pred.load.continue:
; CHECK-NEXT:    [[TMP8:%.*]] = phi <2 x i32> [ poison, [[VECTOR_BODY]] ], [ [[TMP7]], [[PRED_LOAD_IF]] ]
; CHECK-NEXT:    [[TMP9:%.*]] = extractelement <2 x i1> [[TMP3]], i32 1
; CHECK-NEXT:    br i1 [[TMP9]], label [[PRED_LOAD_IF1:%.*]], label [[PRED_LOAD_CONTINUE2]]
; CHECK:       pred.load.if1:
; CHECK-NEXT:    [[TMP10:%.*]] = add i64 [[INDEX]], 1
; CHECK-NEXT:    [[TMP11:%.*]] = getelementptr inbounds i32, ptr [[START]], i64 [[TMP10]]
; CHECK-NEXT:    [[TMP12:%.*]] = load i32, ptr [[TMP11]], align 4
; CHECK-NEXT:    [[TMP13:%.*]] = insertelement <2 x i32> [[TMP8]], i32 [[TMP12]], i32 1
; CHECK-NEXT:    br label [[PRED_LOAD_CONTINUE2]]
; CHECK:       pred.load.continue2:
; CHECK-NEXT:    [[TMP14:%.*]] = phi <2 x i32> [ [[TMP8]], [[PRED_LOAD_CONTINUE]] ], [ [[TMP13]], [[PRED_LOAD_IF1]] ]
; CHECK-NEXT:    [[TMP15:%.*]] = xor <2 x i1> [[TMP3]], <i1 true, i1 true>
; CHECK-NEXT:    [[PREDPHI:%.*]] = select <2 x i1> [[TMP3]], <2 x i32> [[TMP14]], <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP16]] = add <2 x i32> [[VEC_PHI]], [[PREDPHI]]
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 2
; CHECK-NEXT:    [[TMP17:%.*]] = icmp eq i64 [[INDEX_NEXT]], 4096
; CHECK-NEXT:    br i1 [[TMP17]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP4:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[TMP18:%.*]] = call i32 @llvm.vector.reduce.add.v2i32(<2 x i32> [[TMP16]])
; CHECK-NEXT:    br i1 true, label [[LOOP_EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 4096, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[BC_MERGE_RDX:%.*]] = phi i32 [ 0, [[ENTRY]] ], [ [[TMP18]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[LATCH:%.*]] ]
; CHECK-NEXT:    [[ACCUM:%.*]] = phi i32 [ [[BC_MERGE_RDX]], [[SCALAR_PH]] ], [ [[ACCUM_NEXT:%.*]], [[LATCH]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add i64 [[IV]], 1
; CHECK-NEXT:    [[TEST_ADDR:%.*]] = getelementptr inbounds i8, ptr [[TEST_BASE]], i64 [[IV]]
; CHECK-NEXT:    [[L_T:%.*]] = load i8, ptr [[TEST_ADDR]], align 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp sge i8 [[L_T]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[PRED:%.*]], label [[LATCH]]
; CHECK:       pred:
; CHECK-NEXT:    [[ADDR:%.*]] = getelementptr inbounds i32, ptr [[START]], i64 [[IV]]
; CHECK-NEXT:    [[VAL:%.*]] = load i32, ptr [[ADDR]], align 4
; CHECK-NEXT:    br label [[LATCH]]
; CHECK:       latch:
; CHECK-NEXT:    [[VAL_PHI:%.*]] = phi i32 [ 0, [[LOOP]] ], [ [[VAL]], [[PRED]] ]
; CHECK-NEXT:    [[ACCUM_NEXT]] = add i32 [[ACCUM]], [[VAL_PHI]]
; CHECK-NEXT:    [[EXIT:%.*]] = icmp eq i64 [[IV]], 4095
; CHECK-NEXT:    br i1 [[EXIT]], label [[LOOP_EXIT]], label [[LOOP]], !llvm.loop [[LOOP5:![0-9]+]]
; CHECK:       loop_exit:
; CHECK-NEXT:    [[ACCUM_NEXT_LCSSA:%.*]] = phi i32 [ [[ACCUM_NEXT]], [[LATCH]] ], [ [[TMP18]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    ret i32 [[ACCUM_NEXT_LCSSA]]
;
entry:
  %alloca = alloca [163840 x i32], align 4
  call void @init(ptr %alloca)
  %start = getelementptr i8, ptr %alloca, i64 2
  br label %loop
loop:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %latch ]
  %accum = phi i32 [ 0, %entry ], [ %accum.next, %latch ]
  %iv.next = add i64 %iv, 1
  %test_addr = getelementptr inbounds i8, ptr %test_base, i64 %iv
  %l.t = load i8, ptr %test_addr
  %cmp = icmp sge i8 %l.t, 0
  br i1 %cmp, label %pred, label %latch
pred:
  %addr = getelementptr inbounds i32, ptr %start, i64 %iv
  %val = load i32, ptr %addr, align 4
  br label %latch
latch:
  %val.phi = phi i32 [0, %loop], [%val, %pred]
  %accum.next = add i32 %accum, %val.phi
  %exit = icmp eq i64 %iv, 4095
  br i1 %exit, label %loop_exit, label %loop

loop_exit:
  ret i32 %accum.next
}