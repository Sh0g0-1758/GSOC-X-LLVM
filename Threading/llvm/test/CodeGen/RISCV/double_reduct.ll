; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+d,+zfh,+zvfh,+v,+m -target-abi=ilp32d \
; RUN:     -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,RV32
; RUN: llc -mtriple=riscv64 -mattr=+d,+zfh,+zvfh,+v,+m -target-abi=lp64d \
; RUN:     -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,RV64

define float @add_f32(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: add_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; CHECK-NEXT:    vfadd.vv v8, v8, v9
; CHECK-NEXT:    vmv.s.x v9, zero
; CHECK-NEXT:    vfredusum.vs v8, v8, v9
; CHECK-NEXT:    vfmv.f.s fa0, v8
; CHECK-NEXT:    ret
  %r1 = call fast float @llvm.vector.reduce.fadd.f32.v4f32(float -0.0, <4 x float> %a)
  %r2 = call fast float @llvm.vector.reduce.fadd.f32.v4f32(float -0.0, <4 x float> %b)
  %r = fadd fast float %r1, %r2
  ret float %r
}

define float @fmul_f32(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: fmul_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; CHECK-NEXT:    vslidedown.vi v10, v8, 2
; CHECK-NEXT:    vfmul.vv v8, v8, v10
; CHECK-NEXT:    vrgather.vi v10, v8, 1
; CHECK-NEXT:    vfmul.vv v8, v8, v10
; CHECK-NEXT:    vfmv.f.s fa5, v8
; CHECK-NEXT:    vslidedown.vi v8, v9, 2
; CHECK-NEXT:    vfmul.vv v8, v9, v8
; CHECK-NEXT:    vrgather.vi v9, v8, 1
; CHECK-NEXT:    vfmul.vv v8, v8, v9
; CHECK-NEXT:    vfmv.f.s fa4, v8
; CHECK-NEXT:    fmul.s fa0, fa5, fa4
; CHECK-NEXT:    ret
  %r1 = call fast float @llvm.vector.reduce.fmul.f32.v4f32(float 1.0, <4 x float> %a)
  %r2 = call fast float @llvm.vector.reduce.fmul.f32.v4f32(float 1.0, <4 x float> %b)
  %r = fmul fast float %r1, %r2
  ret float %r
}

define float @fmin_f32(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: fmin_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; CHECK-NEXT:    vfmin.vv v8, v8, v9
; CHECK-NEXT:    vfredmin.vs v8, v8, v8
; CHECK-NEXT:    vfmv.f.s fa0, v8
; CHECK-NEXT:    ret
  %r1 = call fast float @llvm.vector.reduce.fmin.v4f32(<4 x float> %a)
  %r2 = call fast float @llvm.vector.reduce.fmin.v4f32(<4 x float> %b)
  %r = call float @llvm.minnum.f32(float %r1, float %r2)
  ret float %r
}

define float @fmax_f32(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: fmax_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; CHECK-NEXT:    vfmax.vv v8, v8, v9
; CHECK-NEXT:    vfredmax.vs v8, v8, v8
; CHECK-NEXT:    vfmv.f.s fa0, v8
; CHECK-NEXT:    ret
  %r1 = call fast float @llvm.vector.reduce.fmax.v4f32(<4 x float> %a)
  %r2 = call fast float @llvm.vector.reduce.fmax.v4f32(<4 x float> %b)
  %r = call float @llvm.maxnum.f32(float %r1, float %r2)
  ret float %r
}


define i32 @add_i32(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: add_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; CHECK-NEXT:    vadd.vv v8, v8, v9
; CHECK-NEXT:    vmv.s.x v9, zero
; CHECK-NEXT:    vredsum.vs v8, v8, v9
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r1 = call i32 @llvm.vector.reduce.add.i32.v4i32(<4 x i32> %a)
  %r2 = call i32 @llvm.vector.reduce.add.i32.v4i32(<4 x i32> %b)
  %r = add i32 %r1, %r2
  ret i32 %r
}

define i16 @add_ext_i16(<16 x i8> %a, <16 x i8> %b) {
; CHECK-LABEL: add_ext_i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e8, m1, ta, ma
; CHECK-NEXT:    vwaddu.vv v10, v8, v9
; CHECK-NEXT:    vsetvli zero, zero, e16, m2, ta, ma
; CHECK-NEXT:    vmv.s.x v8, zero
; CHECK-NEXT:    vredsum.vs v8, v10, v8
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %ae = zext <16 x i8> %a to <16 x i16>
  %be = zext <16 x i8> %b to <16 x i16>
  %r1 = call i16 @llvm.vector.reduce.add.i16.v16i16(<16 x i16> %ae)
  %r2 = call i16 @llvm.vector.reduce.add.i16.v16i16(<16 x i16> %be)
  %r = add i16 %r1, %r2
  ret i16 %r
}

define i16 @add_ext_v32i16(<32 x i8> %a, <16 x i8> %b) {
; CHECK-LABEL: add_ext_v32i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e16, m1, ta, ma
; CHECK-NEXT:    vmv.s.x v11, zero
; CHECK-NEXT:    vsetivli zero, 16, e8, m1, ta, ma
; CHECK-NEXT:    vwredsumu.vs v10, v10, v11
; CHECK-NEXT:    li a0, 32
; CHECK-NEXT:    vsetvli zero, a0, e8, m2, ta, ma
; CHECK-NEXT:    vwredsumu.vs v8, v8, v10
; CHECK-NEXT:    vsetvli zero, zero, e16, m4, ta, ma
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %ae = zext <32 x i8> %a to <32 x i16>
  %be = zext <16 x i8> %b to <16 x i16>
  %r1 = call i16 @llvm.vector.reduce.add.i16.v32i16(<32 x i16> %ae)
  %r2 = call i16 @llvm.vector.reduce.add.i16.v16i16(<16 x i16> %be)
  %r = add i16 %r1, %r2
  ret i16 %r
}

define i32 @mul_i32(<4 x i32> %a, <4 x i32> %b) {
; RV32-LABEL: mul_i32:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; RV32-NEXT:    vslidedown.vi v10, v8, 2
; RV32-NEXT:    vmul.vv v8, v8, v10
; RV32-NEXT:    vrgather.vi v10, v8, 1
; RV32-NEXT:    vmul.vv v8, v8, v10
; RV32-NEXT:    vmv.x.s a0, v8
; RV32-NEXT:    vslidedown.vi v8, v9, 2
; RV32-NEXT:    vmul.vv v8, v9, v8
; RV32-NEXT:    vrgather.vi v9, v8, 1
; RV32-NEXT:    vmul.vv v8, v8, v9
; RV32-NEXT:    vmv.x.s a1, v8
; RV32-NEXT:    mul a0, a0, a1
; RV32-NEXT:    ret
;
; RV64-LABEL: mul_i32:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; RV64-NEXT:    vslidedown.vi v10, v8, 2
; RV64-NEXT:    vmul.vv v8, v8, v10
; RV64-NEXT:    vrgather.vi v10, v8, 1
; RV64-NEXT:    vmul.vv v8, v8, v10
; RV64-NEXT:    vmv.x.s a0, v8
; RV64-NEXT:    vslidedown.vi v8, v9, 2
; RV64-NEXT:    vmul.vv v8, v9, v8
; RV64-NEXT:    vrgather.vi v9, v8, 1
; RV64-NEXT:    vmul.vv v8, v8, v9
; RV64-NEXT:    vmv.x.s a1, v8
; RV64-NEXT:    mulw a0, a0, a1
; RV64-NEXT:    ret
  %r1 = call i32 @llvm.vector.reduce.mul.i32.v4i32(<4 x i32> %a)
  %r2 = call i32 @llvm.vector.reduce.mul.i32.v4i32(<4 x i32> %b)
  %r = mul i32 %r1, %r2
  ret i32 %r
}

define i32 @and_i32(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: and_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; CHECK-NEXT:    vand.vv v8, v8, v9
; CHECK-NEXT:    vredand.vs v8, v8, v8
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r1 = call i32 @llvm.vector.reduce.and.i32.v4i32(<4 x i32> %a)
  %r2 = call i32 @llvm.vector.reduce.and.i32.v4i32(<4 x i32> %b)
  %r = and i32 %r1, %r2
  ret i32 %r
}

define i32 @or_i32(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: or_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; CHECK-NEXT:    vor.vv v8, v8, v9
; CHECK-NEXT:    vredor.vs v8, v8, v8
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r1 = call i32 @llvm.vector.reduce.or.i32.v4i32(<4 x i32> %a)
  %r2 = call i32 @llvm.vector.reduce.or.i32.v4i32(<4 x i32> %b)
  %r = or i32 %r1, %r2
  ret i32 %r
}

define i32 @xor_i32(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: xor_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; CHECK-NEXT:    vxor.vv v8, v8, v9
; CHECK-NEXT:    vmv.s.x v9, zero
; CHECK-NEXT:    vredxor.vs v8, v8, v9
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r1 = call i32 @llvm.vector.reduce.xor.i32.v4i32(<4 x i32> %a)
  %r2 = call i32 @llvm.vector.reduce.xor.i32.v4i32(<4 x i32> %b)
  %r = xor i32 %r1, %r2
  ret i32 %r
}

define i32 @umin_i32(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: umin_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; CHECK-NEXT:    vminu.vv v8, v8, v9
; CHECK-NEXT:    vredminu.vs v8, v8, v8
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r1 = call i32 @llvm.vector.reduce.umin.i32.v4i32(<4 x i32> %a)
  %r2 = call i32 @llvm.vector.reduce.umin.i32.v4i32(<4 x i32> %b)
  %r = call i32 @llvm.umin.i32(i32 %r1, i32 %r2)
  ret i32 %r
}

define i32 @umax_i32(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: umax_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; CHECK-NEXT:    vmaxu.vv v8, v8, v9
; CHECK-NEXT:    vredmaxu.vs v8, v8, v8
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r1 = call i32 @llvm.vector.reduce.umax.i32.v4i32(<4 x i32> %a)
  %r2 = call i32 @llvm.vector.reduce.umax.i32.v4i32(<4 x i32> %b)
  %r = call i32 @llvm.umax.i32(i32 %r1, i32 %r2)
  ret i32 %r
}

define i32 @smin_i32(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: smin_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; CHECK-NEXT:    vmin.vv v8, v8, v9
; CHECK-NEXT:    vredmin.vs v8, v8, v8
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r1 = call i32 @llvm.vector.reduce.smin.i32.v4i32(<4 x i32> %a)
  %r2 = call i32 @llvm.vector.reduce.smin.i32.v4i32(<4 x i32> %b)
  %r = call i32 @llvm.smin.i32(i32 %r1, i32 %r2)
  ret i32 %r
}

define i32 @smax_i32(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: smax_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; CHECK-NEXT:    vmax.vv v8, v8, v9
; CHECK-NEXT:    vredmax.vs v8, v8, v8
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %r1 = call i32 @llvm.vector.reduce.smax.i32.v4i32(<4 x i32> %a)
  %r2 = call i32 @llvm.vector.reduce.smax.i32.v4i32(<4 x i32> %b)
  %r = call i32 @llvm.smax.i32(i32 %r1, i32 %r2)
  ret i32 %r
}

declare float @llvm.vector.reduce.fadd.f32.v4f32(float, <4 x float>)
declare float @llvm.vector.reduce.fmul.f32.v4f32(float, <4 x float>)
declare float @llvm.vector.reduce.fmin.v4f32(<4 x float>)
declare float @llvm.vector.reduce.fmax.v4f32(<4 x float>)
declare i32 @llvm.vector.reduce.add.i32.v4i32(<4 x i32>)
declare i16 @llvm.vector.reduce.add.i16.v32i16(<32 x i16>)
declare i16 @llvm.vector.reduce.add.i16.v16i16(<16 x i16>)
declare i32 @llvm.vector.reduce.mul.i32.v4i32(<4 x i32>)
declare i32 @llvm.vector.reduce.and.i32.v4i32(<4 x i32>)
declare i32 @llvm.vector.reduce.or.i32.v4i32(<4 x i32>)
declare i32 @llvm.vector.reduce.xor.i32.v4i32(<4 x i32>)
declare i32 @llvm.vector.reduce.umin.i32.v4i32(<4 x i32>)
declare i32 @llvm.vector.reduce.umax.i32.v4i32(<4 x i32>)
declare i32 @llvm.vector.reduce.smin.i32.v4i32(<4 x i32>)
declare i32 @llvm.vector.reduce.smax.i32.v4i32(<4 x i32>)
declare float @llvm.minnum.f32(float, float)
declare float @llvm.maxnum.f32(float, float)
declare i32 @llvm.umin.i32(i32, i32)
declare i32 @llvm.umax.i32(i32, i32)
declare i32 @llvm.smin.i32(i32, i32)
declare i32 @llvm.smax.i32(i32, i32)
