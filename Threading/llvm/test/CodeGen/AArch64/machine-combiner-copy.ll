; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-linux-gnuabi -mattr=+fullfp16 -O3 | FileCheck %s

define void @fma_dup_f16(ptr noalias nocapture noundef readonly %A, half noundef %B, ptr noalias nocapture noundef %C, i32 noundef %n) {
; CHECK-LABEL: fma_dup_f16:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    // kill: def $h0 killed $h0 def $q0
; CHECK-NEXT:    cbz w2, .LBB0_8
; CHECK-NEXT:  // %bb.1: // %for.body.preheader
; CHECK-NEXT:    cmp w2, #15
; CHECK-NEXT:    mov w8, w2
; CHECK-NEXT:    b.hi .LBB0_3
; CHECK-NEXT:  // %bb.2:
; CHECK-NEXT:    mov x9, xzr
; CHECK-NEXT:    b .LBB0_6
; CHECK-NEXT:  .LBB0_3: // %vector.ph
; CHECK-NEXT:    and x9, x8, #0xfffffff0
; CHECK-NEXT:    add x10, x1, #16
; CHECK-NEXT:    add x11, x0, #16
; CHECK-NEXT:    mov x12, x9
; CHECK-NEXT:  .LBB0_4: // %vector.body
; CHECK-NEXT:    // =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldp q1, q4, [x10, #-16]
; CHECK-NEXT:    subs x12, x12, #16
; CHECK-NEXT:    ldp q2, q3, [x11, #-16]
; CHECK-NEXT:    add x11, x11, #32
; CHECK-NEXT:    fmla v1.8h, v2.8h, v0.h[0]
; CHECK-NEXT:    fmla v4.8h, v3.8h, v0.h[0]
; CHECK-NEXT:    stp q1, q4, [x10, #-16]
; CHECK-NEXT:    add x10, x10, #32
; CHECK-NEXT:    b.ne .LBB0_4
; CHECK-NEXT:  // %bb.5: // %middle.block
; CHECK-NEXT:    cmp x9, x8
; CHECK-NEXT:    b.eq .LBB0_8
; CHECK-NEXT:  .LBB0_6: // %for.body.preheader1
; CHECK-NEXT:    lsl x10, x9, #1
; CHECK-NEXT:    sub x8, x8, x9
; CHECK-NEXT:    add x9, x1, x10
; CHECK-NEXT:    add x10, x0, x10
; CHECK-NEXT:  .LBB0_7: // %for.body
; CHECK-NEXT:    // =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldr h1, [x10], #2
; CHECK-NEXT:    ldr h2, [x9]
; CHECK-NEXT:    subs x8, x8, #1
; CHECK-NEXT:    fmadd h1, h1, h0, h2
; CHECK-NEXT:    str h1, [x9], #2
; CHECK-NEXT:    b.ne .LBB0_7
; CHECK-NEXT:  .LBB0_8: // %for.cond.cleanup
; CHECK-NEXT:    ret
entry:
  %cmp6.not = icmp eq i32 %n, 0
  br i1 %cmp6.not, label %for.cond.cleanup, label %for.body.preheader

for.body.preheader:                               ; preds = %entry
  %wide.trip.count = zext i32 %n to i64
  %min.iters.check = icmp ult i32 %n, 16
  br i1 %min.iters.check, label %for.body.preheader14, label %vector.ph

vector.ph:                                        ; preds = %for.body.preheader
  %n.vec = and i64 %wide.trip.count, 4294967280
  %broadcast.splatinsert = insertelement <8 x half> poison, half %B, i64 0
  %broadcast.splat = shufflevector <8 x half> %broadcast.splatinsert, <8 x half> poison, <8 x i32> zeroinitializer
  %broadcast.splatinsert10 = insertelement <8 x half> poison, half %B, i64 0
  %broadcast.splat11 = shufflevector <8 x half> %broadcast.splatinsert10, <8 x half> poison, <8 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds half, ptr %A, i64 %index
  %wide.load = load <8 x half>, ptr %0, align 2
  %1 = getelementptr inbounds half, ptr %0, i64 8
  %wide.load9 = load <8 x half>, ptr %1, align 2
  %2 = fmul fast <8 x half> %wide.load, %broadcast.splat
  %3 = fmul fast <8 x half> %wide.load9, %broadcast.splat11
  %4 = getelementptr inbounds half, ptr %C, i64 %index
  %wide.load12 = load <8 x half>, ptr %4, align 2
  %5 = getelementptr inbounds half, ptr %4, i64 8
  %wide.load13 = load <8 x half>, ptr %5, align 2
  %6 = fadd fast <8 x half> %wide.load12, %2
  %7 = fadd fast <8 x half> %wide.load13, %3
  store <8 x half> %6, ptr %4, align 2
  store <8 x half> %7, ptr %5, align 2
  %index.next = add nuw i64 %index, 16
  %8 = icmp eq i64 %index.next, %n.vec
  br i1 %8, label %middle.block, label %vector.body

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i64 %n.vec, %wide.trip.count
  br i1 %cmp.n, label %for.cond.cleanup, label %for.body.preheader14

for.body.preheader14:                             ; preds = %for.body.preheader, %middle.block
  %indvars.iv.ph = phi i64 [ 0, %for.body.preheader ], [ %n.vec, %middle.block ]
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %middle.block, %entry
  ret void

for.body:                                         ; preds = %for.body.preheader14, %for.body
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.body ], [ %indvars.iv.ph, %for.body.preheader14 ]
  %arrayidx = getelementptr inbounds half, ptr %A, i64 %indvars.iv
  %9 = load half, ptr %arrayidx, align 2
  %mul = fmul fast half %9, %B
  %arrayidx2 = getelementptr inbounds half, ptr %C, i64 %indvars.iv
  %10 = load half, ptr %arrayidx2, align 2
  %add = fadd fast half %10, %mul
  store half %add, ptr %arrayidx2, align 2
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next, %wide.trip.count
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body
}
