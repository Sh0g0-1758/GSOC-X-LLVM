; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=riscv64 -mattr=+m,+v,+f -target-abi=lp64f \
; RUN:     -disable-machine-licm | FileCheck %s

; Make sure we don't unnecessrily sink i1 vector splats.

declare <8 x i1> @llvm.vp.and.v4i1(<8 x i1>, <8 x i1>, <8 x i1>, i32)

define void @sink_splat_vp_and_i1(ptr nocapture %a, i1 zeroext %x, <8 x i1> %m, i32 zeroext %vl) {
; CHECK-LABEL: sink_splat_vp_and_i1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, ma
; CHECK-NEXT:    vmv.v.x v8, a1
; CHECK-NEXT:    vmsne.vi v8, v8, 0
; CHECK-NEXT:    addi a1, a0, 1024
; CHECK-NEXT:  .LBB0_1: # %vector.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vlm.v v9, (a0)
; CHECK-NEXT:    vsetvli zero, a2, e8, mf2, ta, ma
; CHECK-NEXT:    vmand.mm v9, v9, v8
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, ma
; CHECK-NEXT:    vsm.v v9, (a0)
; CHECK-NEXT:    addi a0, a0, 1
; CHECK-NEXT:    bne a0, a1, .LBB0_1
; CHECK-NEXT:  # %bb.2: # %for.cond.cleanup
; CHECK-NEXT:    ret
entry:
  %broadcast.splatinsert = insertelement <8 x i1> poison, i1 %x, i32 0
  %broadcast.splat = shufflevector <8 x i1> %broadcast.splatinsert, <8 x i1> poison, <8 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %entry
  %index = phi i64 [ 0, %entry ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds i8, ptr %a, i64 %index
  %wide.load = load <8 x i1>, ptr %0, align 4
  %1 = call <8 x i1> @llvm.vp.and.v4i1(<8 x i1> %wide.load, <8 x i1> %broadcast.splat, <8 x i1> %m, i32 %vl)
  store <8 x i1> %1, ptr %0, align 1
  %index.next = add nuw i64 %index, 1
  %2 = icmp eq i64 %index.next, 1024
  br i1 %2, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body
  ret void
}
