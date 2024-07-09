; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 3
; RUN: opt -passes=loop-vectorize -force-vector-width=4 -force-vector-interleave=1 -S %s | FileCheck %s

target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"

define void @test_pr47927_lshr_const_shift_ops(ptr %dst, i32 %f) {
; CHECK-LABEL: define void @test_pr47927_lshr_const_shift_ops
; CHECK-SAME: (ptr [[DST:%.*]], i32 [[F:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <4 x i32> poison, i32 [[F]], i64 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <4 x i32> [[BROADCAST_SPLATINSERT]], <4 x i32> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[OFFSET_IDX:%.*]] = trunc i32 [[INDEX]] to i8
; CHECK-NEXT:    [[TMP0:%.*]] = add i8 [[OFFSET_IDX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = lshr <4 x i32> [[BROADCAST_SPLAT]], <i32 18, i32 18, i32 18, i32 18>
; CHECK-NEXT:    [[TMP2:%.*]] = trunc <4 x i32> [[TMP1]] to <4 x i8>
; CHECK-NEXT:    [[TMP3:%.*]] = zext i8 [[TMP0]] to i64
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i8, ptr [[DST]], i64 [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds i8, ptr [[TMP4]], i32 0
; CHECK-NEXT:    store <4 x i8> [[TMP2]], ptr [[TMP5]], align 8
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i32 [[INDEX]], 4
; CHECK-NEXT:    [[TMP6:%.*]] = icmp eq i32 [[INDEX_NEXT]], 100
; CHECK-NEXT:    br i1 [[TMP6]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    br i1 true, label [[EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i8 [ 100, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[L:%.*]] = lshr i32 [[F]], 18
; CHECK-NEXT:    [[L_T:%.*]] = trunc i32 [[L]] to i8
; CHECK-NEXT:    [[IV_EXT:%.*]] = zext i8 [[IV]] to i64
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds i8, ptr [[DST]], i64 [[IV_EXT]]
; CHECK-NEXT:    store i8 [[L_T]], ptr [[GEP]], align 8
; CHECK-NEXT:    [[IV_NEXT]] = add i8 [[IV]], 1
; CHECK-NEXT:    [[CONV:%.*]] = zext i8 [[IV_NEXT]] to i32
; CHECK-NEXT:    [[C:%.*]] = icmp ne i32 [[CONV]], 100
; CHECK-NEXT:    br i1 [[C]], label [[LOOP]], label [[EXIT]], !llvm.loop [[LOOP3:![0-9]+]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop

loop:
  %iv = phi i8 [ 0, %entry ], [ %iv.next, %loop ]
  %l = lshr i32 %f, 18
  %l.t = trunc i32 %l to i8
  %iv.ext = zext i8 %iv to i64
  %gep = getelementptr inbounds i8, ptr %dst, i64 %iv.ext
  store i8 %l.t, ptr %gep, align 8
  %iv.next = add i8 %iv, 1
  %conv = zext i8 %iv.next to i32
  %c = icmp ne i32 %conv, 100
  br i1 %c, label %loop, label %exit

exit:
  ret void
}

define void @test_shl_const_shift_ops(ptr %dst, i32 %f) {
; CHECK-LABEL: define void @test_shl_const_shift_ops
; CHECK-SAME: (ptr [[DST:%.*]], i32 [[F:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <4 x i32> poison, i32 [[F]], i64 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <4 x i32> [[BROADCAST_SPLATINSERT]], <4 x i32> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[OFFSET_IDX:%.*]] = trunc i32 [[INDEX]] to i8
; CHECK-NEXT:    [[TMP0:%.*]] = add i8 [[OFFSET_IDX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = shl <4 x i32> [[BROADCAST_SPLAT]], <i32 18, i32 18, i32 18, i32 18>
; CHECK-NEXT:    [[TMP2:%.*]] = trunc <4 x i32> [[TMP1]] to <4 x i8>
; CHECK-NEXT:    [[TMP3:%.*]] = zext i8 [[TMP0]] to i64
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i8, ptr [[DST]], i64 [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds i8, ptr [[TMP4]], i32 0
; CHECK-NEXT:    store <4 x i8> [[TMP2]], ptr [[TMP5]], align 8
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i32 [[INDEX]], 4
; CHECK-NEXT:    [[TMP6:%.*]] = icmp eq i32 [[INDEX_NEXT]], 100
; CHECK-NEXT:    br i1 [[TMP6]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP4:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    br i1 true, label [[EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i8 [ 100, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[L:%.*]] = shl i32 [[F]], 18
; CHECK-NEXT:    [[L_T:%.*]] = trunc i32 [[L]] to i8
; CHECK-NEXT:    [[IV_EXT:%.*]] = zext i8 [[IV]] to i64
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds i8, ptr [[DST]], i64 [[IV_EXT]]
; CHECK-NEXT:    store i8 [[L_T]], ptr [[GEP]], align 8
; CHECK-NEXT:    [[IV_NEXT]] = add i8 [[IV]], 1
; CHECK-NEXT:    [[CONV:%.*]] = zext i8 [[IV_NEXT]] to i32
; CHECK-NEXT:    [[C:%.*]] = icmp ne i32 [[CONV]], 100
; CHECK-NEXT:    br i1 [[C]], label [[LOOP]], label [[EXIT]], !llvm.loop [[LOOP5:![0-9]+]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop

loop:
  %iv = phi i8 [ 0, %entry ], [ %iv.next, %loop ]
  %l = shl i32 %f, 18
  %l.t = trunc i32 %l to i8
  %iv.ext = zext i8 %iv to i64
  %gep = getelementptr inbounds i8, ptr %dst, i64 %iv.ext
  store i8 %l.t, ptr %gep, align 8
  %iv.next = add i8 %iv, 1
  %conv = zext i8 %iv.next to i32
  %c = icmp ne i32 %conv, 100
  br i1 %c, label %loop, label %exit

exit:
  ret void
}

define void @test_ashr_const_shift_ops(ptr %dst, i32 %f) {
; CHECK-LABEL: define void @test_ashr_const_shift_ops
; CHECK-SAME: (ptr [[DST:%.*]], i32 [[F:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <4 x i32> poison, i32 [[F]], i64 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <4 x i32> [[BROADCAST_SPLATINSERT]], <4 x i32> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[OFFSET_IDX:%.*]] = trunc i32 [[INDEX]] to i8
; CHECK-NEXT:    [[TMP0:%.*]] = add i8 [[OFFSET_IDX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = ashr <4 x i32> [[BROADCAST_SPLAT]], <i32 18, i32 18, i32 18, i32 18>
; CHECK-NEXT:    [[TMP2:%.*]] = trunc <4 x i32> [[TMP1]] to <4 x i8>
; CHECK-NEXT:    [[TMP3:%.*]] = zext i8 [[TMP0]] to i64
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i8, ptr [[DST]], i64 [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds i8, ptr [[TMP4]], i32 0
; CHECK-NEXT:    store <4 x i8> [[TMP2]], ptr [[TMP5]], align 8
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i32 [[INDEX]], 4
; CHECK-NEXT:    [[TMP6:%.*]] = icmp eq i32 [[INDEX_NEXT]], 100
; CHECK-NEXT:    br i1 [[TMP6]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP6:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    br i1 true, label [[EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i8 [ 100, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[L:%.*]] = ashr i32 [[F]], 18
; CHECK-NEXT:    [[L_T:%.*]] = trunc i32 [[L]] to i8
; CHECK-NEXT:    [[IV_EXT:%.*]] = zext i8 [[IV]] to i64
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds i8, ptr [[DST]], i64 [[IV_EXT]]
; CHECK-NEXT:    store i8 [[L_T]], ptr [[GEP]], align 8
; CHECK-NEXT:    [[IV_NEXT]] = add i8 [[IV]], 1
; CHECK-NEXT:    [[CONV:%.*]] = zext i8 [[IV_NEXT]] to i32
; CHECK-NEXT:    [[C:%.*]] = icmp ne i32 [[CONV]], 100
; CHECK-NEXT:    br i1 [[C]], label [[LOOP]], label [[EXIT]], !llvm.loop [[LOOP7:![0-9]+]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop

loop:
  %iv = phi i8 [ 0, %entry ], [ %iv.next, %loop ]
  %l = ashr i32 %f, 18
  %l.t = trunc i32 %l to i8
  %iv.ext = zext i8 %iv to i64
  %gep = getelementptr inbounds i8, ptr %dst, i64 %iv.ext
  store i8 %l.t, ptr %gep, align 8
  %iv.next = add i8 %iv, 1
  %conv = zext i8 %iv.next to i32
  %c = icmp ne i32 %conv, 100
  br i1 %c, label %loop, label %exit

exit:
  ret void
}

define void @test_shl_const_shifted_op(ptr %dst, i32 %f) {
; CHECK-LABEL: define void @test_shl_const_shifted_op
; CHECK-SAME: (ptr [[DST:%.*]], i32 [[F:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[OFFSET_IDX:%.*]] = trunc i32 [[INDEX]] to i8
; CHECK-NEXT:    [[TMP0:%.*]] = add i8 [[OFFSET_IDX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = zext i8 [[TMP0]] to i64
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i8, ptr [[DST]], i64 [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds i8, ptr [[TMP2]], i32 0
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <4 x i8>, ptr [[TMP3]], align 1
; CHECK-NEXT:    [[TMP4:%.*]] = zext <4 x i8> [[WIDE_LOAD]] to <4 x i32>
; CHECK-NEXT:    [[TMP5:%.*]] = shl <4 x i32> <i32 19, i32 19, i32 19, i32 19>, [[TMP4]]
; CHECK-NEXT:    [[TMP6:%.*]] = trunc <4 x i32> [[TMP5]] to <4 x i8>
; CHECK-NEXT:    store <4 x i8> [[TMP6]], ptr [[TMP3]], align 8
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i32 [[INDEX]], 4
; CHECK-NEXT:    [[TMP7:%.*]] = icmp eq i32 [[INDEX_NEXT]], 100
; CHECK-NEXT:    br i1 [[TMP7]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP8:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    br i1 true, label [[EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i8 [ 100, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[IV_EXT:%.*]] = zext i8 [[IV]] to i64
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds i8, ptr [[DST]], i64 [[IV_EXT]]
; CHECK-NEXT:    [[LV:%.*]] = load i8, ptr [[GEP]], align 1
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i8 [[LV]] to i32
; CHECK-NEXT:    [[L:%.*]] = shl i32 19, [[ZEXT]]
; CHECK-NEXT:    [[L_T:%.*]] = trunc i32 [[L]] to i8
; CHECK-NEXT:    store i8 [[L_T]], ptr [[GEP]], align 8
; CHECK-NEXT:    [[IV_NEXT]] = add i8 [[IV]], 1
; CHECK-NEXT:    [[CONV:%.*]] = zext i8 [[IV_NEXT]] to i32
; CHECK-NEXT:    [[C:%.*]] = icmp ne i32 [[CONV]], 100
; CHECK-NEXT:    br i1 [[C]], label [[LOOP]], label [[EXIT]], !llvm.loop [[LOOP9:![0-9]+]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop

loop:
  %iv = phi i8 [ 0, %entry ], [ %iv.next, %loop ]
  %iv.ext = zext i8 %iv to i64
  %gep = getelementptr inbounds i8, ptr %dst, i64 %iv.ext
  %lv = load i8, ptr %gep
  %zext = zext i8 %lv to i32
  %l = shl i32 19, %zext
  %l.t = trunc i32 %l to i8
  store i8 %l.t, ptr %gep, align 8
  %iv.next = add i8 %iv, 1
  %conv = zext i8 %iv.next to i32
  %c = icmp ne i32 %conv, 100
  br i1 %c, label %loop, label %exit

exit:
  ret void
}


define void @test_lshr_by_18(ptr %A) {
; CHECK-LABEL: define void @test_lshr_by_18
; CHECK-SAME: (ptr [[A:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[OFFSET_IDX:%.*]] = trunc i32 [[INDEX]] to i8
; CHECK-NEXT:    [[TMP0:%.*]] = add i8 [[OFFSET_IDX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = zext i8 [[TMP0]] to i64
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i8, ptr [[A]], i64 [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds i8, ptr [[TMP2]], i32 0
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <4 x i8>, ptr [[TMP3]], align 1
; CHECK-NEXT:    [[TMP4:%.*]] = zext <4 x i8> [[WIDE_LOAD]] to <4 x i32>
; CHECK-NEXT:    [[TMP5:%.*]] = lshr <4 x i32> [[TMP4]], <i32 18, i32 18, i32 18, i32 18>
; CHECK-NEXT:    [[TMP6:%.*]] = trunc <4 x i32> [[TMP5]] to <4 x i8>
; CHECK-NEXT:    store <4 x i8> [[TMP6]], ptr [[TMP3]], align 8
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i32 [[INDEX]], 4
; CHECK-NEXT:    [[TMP7:%.*]] = icmp eq i32 [[INDEX_NEXT]], 100
; CHECK-NEXT:    br i1 [[TMP7]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP10:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    br i1 true, label [[EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i8 [ 100, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[IV_EXT:%.*]] = zext i8 [[IV]] to i64
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds i8, ptr [[A]], i64 [[IV_EXT]]
; CHECK-NEXT:    [[LV:%.*]] = load i8, ptr [[GEP]], align 1
; CHECK-NEXT:    [[LV_EXT:%.*]] = zext i8 [[LV]] to i32
; CHECK-NEXT:    [[L:%.*]] = lshr i32 [[LV_EXT]], 18
; CHECK-NEXT:    [[L_T:%.*]] = trunc i32 [[L]] to i8
; CHECK-NEXT:    store i8 [[L_T]], ptr [[GEP]], align 8
; CHECK-NEXT:    [[IV_NEXT]] = add i8 [[IV]], 1
; CHECK-NEXT:    [[CONV:%.*]] = zext i8 [[IV_NEXT]] to i32
; CHECK-NEXT:    [[C:%.*]] = icmp ne i32 [[CONV]], 100
; CHECK-NEXT:    br i1 [[C]], label [[LOOP]], label [[EXIT]], !llvm.loop [[LOOP11:![0-9]+]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop

loop:
  %iv = phi i8 [ 0, %entry ], [ %iv.next, %loop ]
  %iv.ext = zext i8 %iv to i64
  %gep = getelementptr inbounds i8, ptr %A, i64 %iv.ext
  %lv = load i8, ptr %gep
  %lv.ext = zext i8 %lv to i32
  %l = lshr i32 %lv.ext, 18
  %l.t = trunc i32 %l to i8
  store i8 %l.t, ptr %gep, align 8
  %iv.next = add i8 %iv, 1
  %conv = zext i8 %iv.next to i32
  %c = icmp ne i32 %conv, 100
  br i1 %c, label %loop, label %exit

exit:
  ret void
}

define void @test_lshr_by_4(ptr %A) {
; CHECK-LABEL: define void @test_lshr_by_4
; CHECK-SAME: (ptr [[A:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[OFFSET_IDX:%.*]] = trunc i32 [[INDEX]] to i8
; CHECK-NEXT:    [[TMP0:%.*]] = add i8 [[OFFSET_IDX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = zext i8 [[TMP0]] to i64
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i8, ptr [[A]], i64 [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds i8, ptr [[TMP2]], i32 0
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <4 x i8>, ptr [[TMP3]], align 1
; CHECK-NEXT:    [[TMP4:%.*]] = zext <4 x i8> [[WIDE_LOAD]] to <4 x i16>
; CHECK-NEXT:    [[TMP5:%.*]] = lshr <4 x i16> [[TMP4]], <i16 4, i16 4, i16 4, i16 4>
; CHECK-NEXT:    [[TMP6:%.*]] = trunc <4 x i16> [[TMP5]] to <4 x i8>
; CHECK-NEXT:    store <4 x i8> [[TMP6]], ptr [[TMP3]], align 8
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i32 [[INDEX]], 4
; CHECK-NEXT:    [[TMP9:%.*]] = icmp eq i32 [[INDEX_NEXT]], 100
; CHECK-NEXT:    br i1 [[TMP9]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP12:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    br i1 true, label [[EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i8 [ 100, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[IV_EXT:%.*]] = zext i8 [[IV]] to i64
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds i8, ptr [[A]], i64 [[IV_EXT]]
; CHECK-NEXT:    [[LV:%.*]] = load i8, ptr [[GEP]], align 1
; CHECK-NEXT:    [[LV_EXT:%.*]] = zext i8 [[LV]] to i32
; CHECK-NEXT:    [[L:%.*]] = lshr i32 [[LV_EXT]], 4
; CHECK-NEXT:    [[L_T:%.*]] = trunc i32 [[L]] to i8
; CHECK-NEXT:    store i8 [[L_T]], ptr [[GEP]], align 8
; CHECK-NEXT:    [[IV_NEXT]] = add i8 [[IV]], 1
; CHECK-NEXT:    [[CONV:%.*]] = zext i8 [[IV_NEXT]] to i32
; CHECK-NEXT:    [[C:%.*]] = icmp ne i32 [[CONV]], 100
; CHECK-NEXT:    br i1 [[C]], label [[LOOP]], label [[EXIT]], !llvm.loop [[LOOP13:![0-9]+]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop

loop:
  %iv = phi i8 [ 0, %entry ], [ %iv.next, %loop ]
  %iv.ext = zext i8 %iv to i64
  %gep = getelementptr inbounds i8, ptr %A, i64 %iv.ext
  %lv = load i8, ptr %gep
  %lv.ext = zext i8 %lv to i32
  %l = lshr i32 %lv.ext, 4
  %l.t = trunc i32 %l to i8
  store i8 %l.t, ptr %gep, align 8
  %iv.next = add i8 %iv, 1
  %conv = zext i8 %iv.next to i32
  %c = icmp ne i32 %conv, 100
  br i1 %c, label %loop, label %exit

exit:
  ret void
}
;.
; CHECK: [[LOOP0]] = distinct !{[[LOOP0]], [[META1:![0-9]+]], [[META2:![0-9]+]]}
; CHECK: [[META1]] = !{!"llvm.loop.isvectorized", i32 1}
; CHECK: [[META2]] = !{!"llvm.loop.unroll.runtime.disable"}
; CHECK: [[LOOP3]] = distinct !{[[LOOP3]], [[META2]], [[META1]]}
; CHECK: [[LOOP4]] = distinct !{[[LOOP4]], [[META1]], [[META2]]}
; CHECK: [[LOOP5]] = distinct !{[[LOOP5]], [[META2]], [[META1]]}
; CHECK: [[LOOP6]] = distinct !{[[LOOP6]], [[META1]], [[META2]]}
; CHECK: [[LOOP7]] = distinct !{[[LOOP7]], [[META2]], [[META1]]}
; CHECK: [[LOOP8]] = distinct !{[[LOOP8]], [[META1]], [[META2]]}
; CHECK: [[LOOP9]] = distinct !{[[LOOP9]], [[META2]], [[META1]]}
; CHECK: [[LOOP10]] = distinct !{[[LOOP10]], [[META1]], [[META2]]}
; CHECK: [[LOOP11]] = distinct !{[[LOOP11]], [[META2]], [[META1]]}
; CHECK: [[LOOP12]] = distinct !{[[LOOP12]], [[META1]], [[META2]]}
; CHECK: [[LOOP13]] = distinct !{[[LOOP13]], [[META2]], [[META1]]}
;.
