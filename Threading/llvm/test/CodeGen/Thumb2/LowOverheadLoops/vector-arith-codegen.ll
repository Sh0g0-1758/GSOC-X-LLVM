; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=armv8.1m.main -mattr=+mve -tail-predication=enabled --verify-machineinstrs %s -o - | FileCheck %s

define dso_local i32 @mul_reduce_add(ptr noalias nocapture readonly %a, ptr noalias nocapture readonly %b, i32 %N) {
; CHECK-LABEL: mul_reduce_add:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r2, #0
; CHECK-NEXT:    itt eq
; CHECK-NEXT:    moveq r0, #0
; CHECK-NEXT:    bxeq lr
; CHECK-NEXT:  .LBB0_1: @ %vector.ph
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    adds r3, r2, #3
; CHECK-NEXT:    vmov.i32 q1, #0x0
; CHECK-NEXT:    bic r3, r3, #3
; CHECK-NEXT:    sub.w r12, r3, #4
; CHECK-NEXT:    movs r3, #1
; CHECK-NEXT:    add.w r3, r3, r12, lsr #2
; CHECK-NEXT:    dls lr, r3
; CHECK-NEXT:  .LBB0_2: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vctp.32 r2
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:    vpstt
; CHECK-NEXT:    vldrwt.u32 q1, [r0], #16
; CHECK-NEXT:    vldrwt.u32 q2, [r1], #16
; CHECK-NEXT:    subs r2, #4
; CHECK-NEXT:    vmul.i32 q1, q2, q1
; CHECK-NEXT:    vadd.i32 q1, q1, q0
; CHECK-NEXT:    le lr, .LBB0_2
; CHECK-NEXT:  @ %bb.3: @ %middle.block
; CHECK-NEXT:    vpsel q0, q1, q0
; CHECK-NEXT:    vaddv.u32 r0, q0
; CHECK-NEXT:    pop {r7, pc}
entry:
  %cmp8 = icmp eq i32 %N, 0
  br i1 %cmp8, label %for.cond.cleanup, label %vector.ph

vector.ph:                                        ; preds = %entry
  %n.rnd.up = add i32 %N, 3
  %n.vec = and i32 %n.rnd.up, -4
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %vec.phi = phi <4 x i32> [ zeroinitializer, %vector.ph ], [ %6, %vector.body ]
  %0 = getelementptr inbounds i32, ptr %a, i32 %index
  %1 = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 %index, i32 %N)
  %2 = bitcast ptr %0 to ptr
  %wide.masked.load = call <4 x i32> @llvm.masked.load.v4i32.p0(ptr %2, i32 4, <4 x i1> %1, <4 x i32> undef)
  %3 = getelementptr inbounds i32, ptr %b, i32 %index
  %4 = bitcast ptr %3 to ptr
  %wide.masked.load13 = call <4 x i32> @llvm.masked.load.v4i32.p0(ptr %4, i32 4, <4 x i1> %1, <4 x i32> undef)
  %5 = mul nsw <4 x i32> %wide.masked.load13, %wide.masked.load
  %6 = add nsw <4 x i32> %5, %vec.phi
  %index.next = add i32 %index, 4
  %7 = icmp eq i32 %index.next, %n.vec
  br i1 %7, label %middle.block, label %vector.body

middle.block:                                     ; preds = %vector.body
  %8 = select <4 x i1> %1, <4 x i32> %6, <4 x i32> %vec.phi
  %9 = call i32 @llvm.vector.reduce.add.v4i32(<4 x i32> %8)
  br label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %middle.block, %entry
  %res.0.lcssa = phi i32 [ 0, %entry ], [ %9, %middle.block ]
  ret i32 %res.0.lcssa
}

define dso_local i32 @mul_reduce_add_const(ptr noalias nocapture readonly %a, i32 %b, i32 %N) {
; CHECK-LABEL: mul_reduce_add_const:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r2, #0
; CHECK-NEXT:    itt eq
; CHECK-NEXT:    moveq r0, #0
; CHECK-NEXT:    bxeq lr
; CHECK-NEXT:  .LBB1_1: @ %vector.ph
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    adds r1, r2, #3
; CHECK-NEXT:    movs r3, #1
; CHECK-NEXT:    bic r1, r1, #3
; CHECK-NEXT:    vmov.i32 q0, #0x0
; CHECK-NEXT:    subs r1, #4
; CHECK-NEXT:    add.w r1, r3, r1, lsr #2
; CHECK-NEXT:    dls lr, r1
; CHECK-NEXT:  .LBB1_2: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vctp.32 r2
; CHECK-NEXT:    vmov q1, q0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vldrwt.u32 q0, [r0], #16
; CHECK-NEXT:    subs r2, #4
; CHECK-NEXT:    vadd.i32 q0, q0, q1
; CHECK-NEXT:    le lr, .LBB1_2
; CHECK-NEXT:  @ %bb.3: @ %middle.block
; CHECK-NEXT:    vpsel q0, q0, q1
; CHECK-NEXT:    vaddv.u32 r0, q0
; CHECK-NEXT:    pop {r7, pc}
entry:
  %cmp6 = icmp eq i32 %N, 0
  br i1 %cmp6, label %for.cond.cleanup, label %vector.ph

vector.ph:                                        ; preds = %entry
  %n.rnd.up = add i32 %N, 3
  %n.vec = and i32 %n.rnd.up, -4
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %vec.phi = phi <4 x i32> [ zeroinitializer, %vector.ph ], [ %3, %vector.body ]
  %0 = getelementptr inbounds i32, ptr %a, i32 %index
  %1 = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 %index, i32 %N)
  %2 = bitcast ptr %0 to ptr
  %wide.masked.load = call <4 x i32> @llvm.masked.load.v4i32.p0(ptr %2, i32 4, <4 x i1> %1, <4 x i32> undef)
  %3 = add nsw <4 x i32> %wide.masked.load, %vec.phi
  %index.next = add i32 %index, 4
  %4 = icmp eq i32 %index.next, %n.vec
  br i1 %4, label %middle.block, label %vector.body

middle.block:                                     ; preds = %vector.body
  %5 = select <4 x i1> %1, <4 x i32> %3, <4 x i32> %vec.phi
  %6 = call i32 @llvm.vector.reduce.add.v4i32(<4 x i32> %5)
  br label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %middle.block, %entry
  %res.0.lcssa = phi i32 [ 0, %entry ], [ %6, %middle.block ]
  ret i32 %res.0.lcssa
}

define dso_local i32 @add_reduce_add_const(ptr noalias nocapture readonly %a, i32 %b, i32 %N) {
; CHECK-LABEL: add_reduce_add_const:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r2, #0
; CHECK-NEXT:    itt eq
; CHECK-NEXT:    moveq r0, #0
; CHECK-NEXT:    bxeq lr
; CHECK-NEXT:  .LBB2_1: @ %vector.ph
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    adds r1, r2, #3
; CHECK-NEXT:    movs r3, #1
; CHECK-NEXT:    bic r1, r1, #3
; CHECK-NEXT:    vmov.i32 q0, #0x0
; CHECK-NEXT:    subs r1, #4
; CHECK-NEXT:    add.w r1, r3, r1, lsr #2
; CHECK-NEXT:    dls lr, r1
; CHECK-NEXT:  .LBB2_2: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vctp.32 r2
; CHECK-NEXT:    vmov q1, q0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vldrwt.u32 q0, [r0], #16
; CHECK-NEXT:    subs r2, #4
; CHECK-NEXT:    vadd.i32 q0, q0, q1
; CHECK-NEXT:    le lr, .LBB2_2
; CHECK-NEXT:  @ %bb.3: @ %middle.block
; CHECK-NEXT:    vpsel q0, q0, q1
; CHECK-NEXT:    vaddv.u32 r0, q0
; CHECK-NEXT:    pop {r7, pc}
entry:
  %cmp6 = icmp eq i32 %N, 0
  br i1 %cmp6, label %for.cond.cleanup, label %vector.ph

vector.ph:                                        ; preds = %entry
  %n.rnd.up = add i32 %N, 3
  %n.vec = and i32 %n.rnd.up, -4
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %vec.phi = phi <4 x i32> [ zeroinitializer, %vector.ph ], [ %3, %vector.body ]
  %0 = getelementptr inbounds i32, ptr %a, i32 %index
  %1 = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 %index, i32 %N)
  %2 = bitcast ptr %0 to ptr
  %wide.masked.load = call <4 x i32> @llvm.masked.load.v4i32.p0(ptr %2, i32 4, <4 x i1> %1, <4 x i32> undef)
  %3 = add nsw <4 x i32> %wide.masked.load, %vec.phi
  %index.next = add i32 %index, 4
  %4 = icmp eq i32 %index.next, %n.vec
  br i1 %4, label %middle.block, label %vector.body

middle.block:                                     ; preds = %vector.body
  %5 = select <4 x i1> %1, <4 x i32> %3, <4 x i32> %vec.phi
  %6 = call i32 @llvm.vector.reduce.add.v4i32(<4 x i32> %5)
  br label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %middle.block, %entry
  %res.0.lcssa = phi i32 [ 0, %entry ], [ %6, %middle.block ]
  ret i32 %res.0.lcssa
}

define dso_local void @vector_mul_const(ptr noalias nocapture %a, ptr noalias nocapture readonly %b, i32 %c, i32 %N) {
; CHECK-LABEL: vector_mul_const:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    cmp r3, #0
; CHECK-NEXT:    it eq
; CHECK-NEXT:    popeq {r7, pc}
; CHECK-NEXT:  .LBB3_1: @ %vector.ph
; CHECK-NEXT:    dlstp.32 lr, r3
; CHECK-NEXT:  .LBB3_2: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrw.u32 q0, [r1], #16
; CHECK-NEXT:    vmul.i32 q0, q0, r2
; CHECK-NEXT:    vstrw.32 q0, [r0], #16
; CHECK-NEXT:    letp lr, .LBB3_2
; CHECK-NEXT:  @ %bb.3: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r7, pc}
entry:
  %cmp6 = icmp eq i32 %N, 0
  br i1 %cmp6, label %for.cond.cleanup, label %vector.ph

vector.ph:                                        ; preds = %entry
  %n.rnd.up = add i32 %N, 3
  %n.vec = and i32 %n.rnd.up, -4
  %broadcast.splatinsert10 = insertelement <4 x i32> undef, i32 %c, i32 0
  %broadcast.splat11 = shufflevector <4 x i32> %broadcast.splatinsert10, <4 x i32> undef, <4 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds i32, ptr %b, i32 %index
  %1 = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 %index, i32 %N)
  %2 = bitcast ptr %0 to ptr
  %wide.masked.load = call <4 x i32> @llvm.masked.load.v4i32.p0(ptr %2, i32 4, <4 x i1> %1, <4 x i32> undef)
  %3 = mul nsw <4 x i32> %wide.masked.load, %broadcast.splat11
  %4 = getelementptr inbounds i32, ptr %a, i32 %index
  %5 = bitcast ptr %4 to ptr
  call void @llvm.masked.store.v4i32.p0(<4 x i32> %3, ptr %5, i32 4, <4 x i1> %1)
  %index.next = add i32 %index, 4
  %6 = icmp eq i32 %index.next, %n.vec
  br i1 %6, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body, %entry
  ret void
}

define dso_local void @vector_add_const(ptr noalias nocapture %a, ptr noalias nocapture readonly %b, i32 %c, i32 %N) {
; CHECK-LABEL: vector_add_const:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    cmp r3, #0
; CHECK-NEXT:    it eq
; CHECK-NEXT:    popeq {r7, pc}
; CHECK-NEXT:  .LBB4_1: @ %vector.ph
; CHECK-NEXT:    dlstp.32 lr, r3
; CHECK-NEXT:  .LBB4_2: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrw.u32 q0, [r1], #16
; CHECK-NEXT:    vadd.i32 q0, q0, r2
; CHECK-NEXT:    vstrw.32 q0, [r0], #16
; CHECK-NEXT:    letp lr, .LBB4_2
; CHECK-NEXT:  @ %bb.3: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r7, pc}
entry:
  %cmp6 = icmp eq i32 %N, 0
  br i1 %cmp6, label %for.cond.cleanup, label %vector.ph

vector.ph:                                        ; preds = %entry
  %n.rnd.up = add i32 %N, 3
  %n.vec = and i32 %n.rnd.up, -4
  %broadcast.splatinsert10 = insertelement <4 x i32> undef, i32 %c, i32 0
  %broadcast.splat11 = shufflevector <4 x i32> %broadcast.splatinsert10, <4 x i32> undef, <4 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds i32, ptr %b, i32 %index
  %1 = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 %index, i32 %N)
  %2 = bitcast ptr %0 to ptr
  %wide.masked.load = call <4 x i32> @llvm.masked.load.v4i32.p0(ptr %2, i32 4, <4 x i1> %1, <4 x i32> undef)
  %3 = add nsw <4 x i32> %wide.masked.load, %broadcast.splat11
  %4 = getelementptr inbounds i32, ptr %a, i32 %index
  %5 = bitcast ptr %4 to ptr
  call void @llvm.masked.store.v4i32.p0(<4 x i32> %3, ptr %5, i32 4, <4 x i1> %1)
  %index.next = add i32 %index, 4
  %6 = icmp eq i32 %index.next, %n.vec
  br i1 %6, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body, %entry
  ret void
}

define dso_local arm_aapcs_vfpcc void @vector_mul_vector_i8(ptr noalias nocapture %a, ptr noalias nocapture readonly %b, ptr noalias nocapture readonly %c, i32 %N) {
; CHECK-LABEL: vector_mul_vector_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    cmp r3, #0
; CHECK-NEXT:    it eq
; CHECK-NEXT:    popeq {r7, pc}
; CHECK-NEXT:  .LBB5_1: @ %vector.ph
; CHECK-NEXT:    dlstp.8 lr, r3
; CHECK-NEXT:  .LBB5_2: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrb.u8 q0, [r1], #16
; CHECK-NEXT:    vldrb.u8 q1, [r2], #16
; CHECK-NEXT:    vmul.i8 q0, q1, q0
; CHECK-NEXT:    vstrb.8 q0, [r0], #16
; CHECK-NEXT:    letp lr, .LBB5_2
; CHECK-NEXT:  @ %bb.3: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r7, pc}
entry:
  %cmp10 = icmp eq i32 %N, 0
  br i1 %cmp10, label %for.cond.cleanup, label %vector.ph

vector.ph:                                        ; preds = %entry
  %n.rnd.up = add i32 %N, 15
  %n.vec = and i32 %n.rnd.up, -16
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds i8, ptr %b, i32 %index
  %1 = call <16 x i1> @llvm.get.active.lane.mask.v16i1.i32(i32 %index, i32 %N)
  %2 = bitcast ptr %0 to ptr
  %wide.masked.load = call <16 x i8> @llvm.masked.load.v16i8.p0(ptr %2, i32 1, <16 x i1> %1, <16 x i8> undef)
  %3 = getelementptr inbounds i8, ptr %c, i32 %index
  %4 = bitcast ptr %3 to ptr
  %wide.masked.load14 = call <16 x i8> @llvm.masked.load.v16i8.p0(ptr %4, i32 1, <16 x i1> %1, <16 x i8> undef)
  %5 = mul <16 x i8> %wide.masked.load14, %wide.masked.load
  %6 = getelementptr inbounds i8, ptr %a, i32 %index
  %7 = bitcast ptr %6 to ptr
  call void @llvm.masked.store.v16i8.p0(<16 x i8> %5, ptr %7, i32 1, <16 x i1> %1)
  %index.next = add i32 %index, 16
  %8 = icmp eq i32 %index.next, %n.vec
  br i1 %8, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body, %entry
  ret void
}

; Function Attrs: nofree norecurse nounwind
define dso_local arm_aapcs_vfpcc void @vector_mul_vector_i16(ptr noalias nocapture %a, ptr noalias nocapture readonly %b, ptr noalias nocapture readonly %c, i32 %N) local_unnamed_addr #0 {
; CHECK-LABEL: vector_mul_vector_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    cmp r3, #0
; CHECK-NEXT:    it eq
; CHECK-NEXT:    popeq {r7, pc}
; CHECK-NEXT:  .LBB6_1: @ %vector.ph
; CHECK-NEXT:    dlstp.16 lr, r3
; CHECK-NEXT:  .LBB6_2: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrh.u16 q0, [r1], #16
; CHECK-NEXT:    vldrh.u16 q1, [r2], #16
; CHECK-NEXT:    vmul.i16 q0, q1, q0
; CHECK-NEXT:    vstrh.16 q0, [r0], #16
; CHECK-NEXT:    letp lr, .LBB6_2
; CHECK-NEXT:  @ %bb.3: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r7, pc}
entry:
  %cmp10 = icmp eq i32 %N, 0
  br i1 %cmp10, label %for.cond.cleanup, label %vector.ph

vector.ph:                                        ; preds = %entry
  %n.rnd.up = add i32 %N, 7
  %n.vec = and i32 %n.rnd.up, -8
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds i16, ptr %b, i32 %index
  %1 = call <8 x i1> @llvm.get.active.lane.mask.v8i1.i32(i32 %index, i32 %N)
  %2 = bitcast ptr %0 to ptr
  %wide.masked.load = call <8 x i16> @llvm.masked.load.v8i16.p0(ptr %2, i32 2, <8 x i1> %1, <8 x i16> undef)
  %3 = getelementptr inbounds i16, ptr %c, i32 %index
  %4 = bitcast ptr %3 to ptr
  %wide.masked.load14 = call <8 x i16> @llvm.masked.load.v8i16.p0(ptr %4, i32 2, <8 x i1> %1, <8 x i16> undef)
  %5 = mul <8 x i16> %wide.masked.load14, %wide.masked.load
  %6 = getelementptr inbounds i16, ptr %a, i32 %index
  %7 = bitcast ptr %6 to ptr
  call void @llvm.masked.store.v8i16.p0(<8 x i16> %5, ptr %7, i32 2, <8 x i1> %1)
  %index.next = add i32 %index, 8
  %8 = icmp eq i32 %index.next, %n.vec
  br i1 %8, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body, %entry
  ret void
}

declare <16 x i8> @llvm.masked.load.v16i8.p0(ptr, i32 immarg, <16 x i1>, <16 x i8>)
declare <8 x i16> @llvm.masked.load.v8i16.p0(ptr, i32 immarg, <8 x i1>, <8 x i16>)
declare <4 x i32> @llvm.masked.load.v4i32.p0(ptr, i32 immarg, <4 x i1>, <4 x i32>)
declare void @llvm.masked.store.v16i8.p0(<16 x i8>, ptr, i32 immarg, <16 x i1>)
declare void @llvm.masked.store.v8i16.p0(<8 x i16>, ptr, i32 immarg, <8 x i1>)
declare void @llvm.masked.store.v4i32.p0(<4 x i32>, ptr, i32 immarg, <4 x i1>)
declare i32 @llvm.vector.reduce.add.v4i32(<4 x i32>)
declare <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32, i32)
declare <8 x i1> @llvm.get.active.lane.mask.v8i1.i32(i32, i32)
declare <16 x i1> @llvm.get.active.lane.mask.v16i1.i32(i32, i32)
