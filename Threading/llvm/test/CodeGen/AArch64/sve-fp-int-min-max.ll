; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64 -mattr=+sve %s -o - | FileCheck %s

define i64 @scalable_int_min_max(ptr %arg, ptr %arg1, <vscale x 2 x ptr> %i37, <vscale x 2 x i64> %i42, <vscale x 2 x i64> %i54) {
; CHECK-LABEL: scalable_int_min_max:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    mov w8, #3745 // =0xea1
; CHECK-NEXT:    movk w8, #16618, lsl #16
; CHECK-NEXT:    mov z4.s, w8
; CHECK-NEXT:    mov w8, #57344 // =0xe000
; CHECK-NEXT:    movk w8, #17535, lsl #16
; CHECK-NEXT:    mov z5.s, w8
; CHECK-NEXT:    ld1w { z3.d }, p0/z, [x0]
; CHECK-NEXT:    fmul z4.s, p0/m, z4.s, z3.s
; CHECK-NEXT:    fadd z4.s, p0/m, z4.s, z5.s
; CHECK-NEXT:    mov z5.d, #1023 // =0x3ff
; CHECK-NEXT:    fcvtzs z4.d, p0/m, z4.s
; CHECK-NEXT:    smax z4.d, z4.d, #0
; CHECK-NEXT:    smin z4.d, p0/m, z4.d, z5.d
; CHECK-NEXT:    cmpne p1.d, p0/z, z4.d, #0
; CHECK-NEXT:    ld1w { z0.d }, p1/z, [z0.d]
; CHECK-NEXT:    ld1w { z4.d }, p1/z, [x1]
; CHECK-NEXT:    fadd z0.s, p0/m, z0.s, z4.s
; CHECK-NEXT:    fcmge p2.s, p0/z, z0.s, z3.s
; CHECK-NEXT:    add z0.d, z2.d, z1.d
; CHECK-NEXT:    bic p2.b, p1/z, p1.b, p2.b
; CHECK-NEXT:    mov z0.d, p2/m, z2.d
; CHECK-NEXT:    sel z0.d, p1, z0.d, z2.d
; CHECK-NEXT:    uaddv d0, p0, z0.d
; CHECK-NEXT:    fmov x0, d0
; CHECK-NEXT:    ret
entry:
  %i56 = getelementptr inbounds float, ptr %arg, i64 0
  %i57 = load <vscale x 2 x float>, ptr %i56, align 4
  %i58 = fmul <vscale x 2 x float> %i57, splat (float 0x401D41D420000000)
  %i59 = fadd <vscale x 2 x float> %i58, splat (float 1.023500e+03)
  %i60 = fptosi <vscale x 2 x float> %i59 to <vscale x 2 x i32>
  %i61 = tail call <vscale x 2 x i32> @llvm.smax.nxv2i32(<vscale x 2 x i32> %i60, <vscale x 2 x i32> zeroinitializer)
  %i62 = tail call <vscale x 2 x i32> @llvm.smin.nxv2i32(<vscale x 2 x i32> %i61, <vscale x 2 x i32> splat (i32 1023))
  %i63 = icmp ne <vscale x 2 x i32> %i62, zeroinitializer
  %i64 = getelementptr float, ptr %arg1, i64 0
  %i65 = tail call <vscale x 2 x float> @llvm.masked.load.nxv2f32.p0(ptr %i64, i32 4, <vscale x 2 x i1> %i63, <vscale x 2 x float> poison)
  %i66 = tail call <vscale x 2 x float> @llvm.masked.gather.nxv2f32.nxv2p0(<vscale x 2 x ptr> %i37, i32 4, <vscale x 2 x i1> %i63, <vscale x 2 x float> poison)
  %i67 = fadd <vscale x 2 x float> %i65, %i66
  %i68 = fcmp ult <vscale x 2 x float> %i67, %i57
  %i74 = select <vscale x 2 x i1> %i63, <vscale x 2 x i1> %i68, <vscale x 2 x i1> zeroinitializer
  %i75 = select <vscale x 2 x i1> %i74, <vscale x 2 x i64> zeroinitializer, <vscale x 2 x i64> %i42
  %i76 = select <vscale x 2 x i1> %i63, <vscale x 2 x i64> %i75, <vscale x 2 x i64> zeroinitializer
  %i77 = add <vscale x 2 x i64> %i54, %i76
  %i116 = tail call i64 @llvm.vector.reduce.add.nxv2i64(<vscale x 2 x i64> %i77)
  ret i64 %i116
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare <vscale x 2 x i32> @llvm.smax.nxv2i32(<vscale x 2 x i32>, <vscale x 2 x i32>) #0

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare <vscale x 2 x i32> @llvm.smin.nxv2i32(<vscale x 2 x i32>, <vscale x 2 x i32>) #0

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: read)
declare <vscale x 2 x float> @llvm.masked.load.nxv2f32.p0(ptr nocapture, i32 immarg, <vscale x 2 x i1>, <vscale x 2 x float>) #1

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(read)
declare <vscale x 2 x float> @llvm.masked.gather.nxv2f32.nxv2p0(<vscale x 2 x ptr>, i32 immarg, <vscale x 2 x i1>, <vscale x 2 x float>) #2

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(none)
declare i64 @llvm.vector.reduce.add.nxv2i64(<vscale x 2 x i64>) #3

attributes #0 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(argmem: read) }
attributes #2 = { nocallback nofree nosync nounwind willreturn memory(read) }
attributes #3 = { nocallback nofree nosync nounwind willreturn memory(none) }
