; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -target-abi=ilp32d -mattr=+v,+zfh,+zvfh,+f,+d -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,CHECK-RV32
; RUN: llc -mtriple=riscv64 -target-abi=lp64d -mattr=+v,+zfh,+zvfh,+f,+d -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,CHECK-RV64

define void @splat_v8f16(ptr %x, half %y) {
; CHECK-LABEL: splat_v8f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e16, m1, ta, ma
; CHECK-NEXT:    vfmv.v.f v8, fa0
; CHECK-NEXT:    vse16.v v8, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <8 x half> poison, half %y, i32 0
  %b = shufflevector <8 x half> %a, <8 x half> poison, <8 x i32> zeroinitializer
  store <8 x half> %b, ptr %x
  ret void
}

define void @splat_v4f32(ptr %x, float %y) {
; CHECK-LABEL: splat_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; CHECK-NEXT:    vfmv.v.f v8, fa0
; CHECK-NEXT:    vse32.v v8, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <4 x float> poison, float %y, i32 0
  %b = shufflevector <4 x float> %a, <4 x float> poison, <4 x i32> zeroinitializer
  store <4 x float> %b, ptr %x
  ret void
}

define void @splat_v2f64(ptr %x, double %y) {
; CHECK-LABEL: splat_v2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e64, m1, ta, ma
; CHECK-NEXT:    vfmv.v.f v8, fa0
; CHECK-NEXT:    vse64.v v8, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <2 x double> poison, double %y, i32 0
  %b = shufflevector <2 x double> %a, <2 x double> poison, <2 x i32> zeroinitializer
  store <2 x double> %b, ptr %x
  ret void
}

define void @splat_16f16(ptr %x, half %y) {
; CHECK-LABEL: splat_16f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e16, m2, ta, ma
; CHECK-NEXT:    vfmv.v.f v8, fa0
; CHECK-NEXT:    vse16.v v8, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <16 x half> poison, half %y, i32 0
  %b = shufflevector <16 x half> %a, <16 x half> poison, <16 x i32> zeroinitializer
  store <16 x half> %b, ptr %x
  ret void
}

define void @splat_v8f32(ptr %x, float %y) {
; CHECK-LABEL: splat_v8f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e32, m2, ta, ma
; CHECK-NEXT:    vfmv.v.f v8, fa0
; CHECK-NEXT:    vse32.v v8, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <8 x float> poison, float %y, i32 0
  %b = shufflevector <8 x float> %a, <8 x float> poison, <8 x i32> zeroinitializer
  store <8 x float> %b, ptr %x
  ret void
}

define void @splat_v4f64(ptr %x, double %y) {
; CHECK-LABEL: splat_v4f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e64, m2, ta, ma
; CHECK-NEXT:    vfmv.v.f v8, fa0
; CHECK-NEXT:    vse64.v v8, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <4 x double> poison, double %y, i32 0
  %b = shufflevector <4 x double> %a, <4 x double> poison, <4 x i32> zeroinitializer
  store <4 x double> %b, ptr %x
  ret void
}

define void @splat_zero_v8f16(ptr %x) {
; CHECK-LABEL: splat_zero_v8f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e16, m1, ta, ma
; CHECK-NEXT:    vmv.v.i v8, 0
; CHECK-NEXT:    vse16.v v8, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <8 x half> poison, half 0.0, i32 0
  %b = shufflevector <8 x half> %a, <8 x half> poison, <8 x i32> zeroinitializer
  store <8 x half> %b, ptr %x
  ret void
}

define void @splat_zero_v4f32(ptr %x) {
; CHECK-LABEL: splat_zero_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; CHECK-NEXT:    vmv.v.i v8, 0
; CHECK-NEXT:    vse32.v v8, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <4 x float> poison, float 0.0, i32 0
  %b = shufflevector <4 x float> %a, <4 x float> poison, <4 x i32> zeroinitializer
  store <4 x float> %b, ptr %x
  ret void
}

define void @splat_zero_v2f64(ptr %x) {
; CHECK-LABEL: splat_zero_v2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e64, m1, ta, ma
; CHECK-NEXT:    vmv.v.i v8, 0
; CHECK-NEXT:    vse64.v v8, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <2 x double> poison, double 0.0, i32 0
  %b = shufflevector <2 x double> %a, <2 x double> poison, <2 x i32> zeroinitializer
  store <2 x double> %b, ptr %x
  ret void
}

define void @splat_zero_16f16(ptr %x) {
; CHECK-LABEL: splat_zero_16f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e16, m2, ta, ma
; CHECK-NEXT:    vmv.v.i v8, 0
; CHECK-NEXT:    vse16.v v8, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <16 x half> poison, half 0.0, i32 0
  %b = shufflevector <16 x half> %a, <16 x half> poison, <16 x i32> zeroinitializer
  store <16 x half> %b, ptr %x
  ret void
}

define void @splat_zero_v8f32(ptr %x) {
; CHECK-LABEL: splat_zero_v8f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e32, m2, ta, ma
; CHECK-NEXT:    vmv.v.i v8, 0
; CHECK-NEXT:    vse32.v v8, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <8 x float> poison, float 0.0, i32 0
  %b = shufflevector <8 x float> %a, <8 x float> poison, <8 x i32> zeroinitializer
  store <8 x float> %b, ptr %x
  ret void
}

define void @splat_zero_v4f64(ptr %x) {
; CHECK-LABEL: splat_zero_v4f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e64, m2, ta, ma
; CHECK-NEXT:    vmv.v.i v8, 0
; CHECK-NEXT:    vse64.v v8, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <4 x double> poison, double 0.0, i32 0
  %b = shufflevector <4 x double> %a, <4 x double> poison, <4 x i32> zeroinitializer
  store <4 x double> %b, ptr %x
  ret void
}

define void @splat_negzero_v8f16(ptr %x) {
; CHECK-LABEL: splat_negzero_v8f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a1, 1048568
; CHECK-NEXT:    vsetivli zero, 8, e16, m1, ta, ma
; CHECK-NEXT:    vmv.v.x v8, a1
; CHECK-NEXT:    vse16.v v8, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <8 x half> poison, half -0.0, i32 0
  %b = shufflevector <8 x half> %a, <8 x half> poison, <8 x i32> zeroinitializer
  store <8 x half> %b, ptr %x
  ret void
}

define void @splat_negzero_v4f32(ptr %x) {
; CHECK-LABEL: splat_negzero_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a1, 524288
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; CHECK-NEXT:    vmv.v.x v8, a1
; CHECK-NEXT:    vse32.v v8, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <4 x float> poison, float -0.0, i32 0
  %b = shufflevector <4 x float> %a, <4 x float> poison, <4 x i32> zeroinitializer
  store <4 x float> %b, ptr %x
  ret void
}

define void @splat_negzero_v2f64(ptr %x) {
; CHECK-RV32-LABEL: splat_negzero_v2f64:
; CHECK-RV32:       # %bb.0:
; CHECK-RV32-NEXT:    fcvt.d.w fa5, zero
; CHECK-RV32-NEXT:    fneg.d fa5, fa5
; CHECK-RV32-NEXT:    vsetivli zero, 2, e64, m1, ta, ma
; CHECK-RV32-NEXT:    vfmv.v.f v8, fa5
; CHECK-RV32-NEXT:    vse64.v v8, (a0)
; CHECK-RV32-NEXT:    ret
;
; CHECK-RV64-LABEL: splat_negzero_v2f64:
; CHECK-RV64:       # %bb.0:
; CHECK-RV64-NEXT:    li a1, -1
; CHECK-RV64-NEXT:    slli a1, a1, 63
; CHECK-RV64-NEXT:    vsetivli zero, 2, e64, m1, ta, ma
; CHECK-RV64-NEXT:    vmv.v.x v8, a1
; CHECK-RV64-NEXT:    vse64.v v8, (a0)
; CHECK-RV64-NEXT:    ret
  %a = insertelement <2 x double> poison, double -0.0, i32 0
  %b = shufflevector <2 x double> %a, <2 x double> poison, <2 x i32> zeroinitializer
  store <2 x double> %b, ptr %x
  ret void
}

define void @splat_negzero_16f16(ptr %x) {
; CHECK-LABEL: splat_negzero_16f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a1, 1048568
; CHECK-NEXT:    vsetivli zero, 16, e16, m2, ta, ma
; CHECK-NEXT:    vmv.v.x v8, a1
; CHECK-NEXT:    vse16.v v8, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <16 x half> poison, half -0.0, i32 0
  %b = shufflevector <16 x half> %a, <16 x half> poison, <16 x i32> zeroinitializer
  store <16 x half> %b, ptr %x
  ret void
}

define void @splat_negzero_v8f32(ptr %x) {
; CHECK-LABEL: splat_negzero_v8f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a1, 524288
; CHECK-NEXT:    vsetivli zero, 8, e32, m2, ta, ma
; CHECK-NEXT:    vmv.v.x v8, a1
; CHECK-NEXT:    vse32.v v8, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <8 x float> poison, float -0.0, i32 0
  %b = shufflevector <8 x float> %a, <8 x float> poison, <8 x i32> zeroinitializer
  store <8 x float> %b, ptr %x
  ret void
}

define void @splat_negzero_v4f64(ptr %x) {
; CHECK-RV32-LABEL: splat_negzero_v4f64:
; CHECK-RV32:       # %bb.0:
; CHECK-RV32-NEXT:    fcvt.d.w fa5, zero
; CHECK-RV32-NEXT:    fneg.d fa5, fa5
; CHECK-RV32-NEXT:    vsetivli zero, 4, e64, m2, ta, ma
; CHECK-RV32-NEXT:    vfmv.v.f v8, fa5
; CHECK-RV32-NEXT:    vse64.v v8, (a0)
; CHECK-RV32-NEXT:    ret
;
; CHECK-RV64-LABEL: splat_negzero_v4f64:
; CHECK-RV64:       # %bb.0:
; CHECK-RV64-NEXT:    li a1, -1
; CHECK-RV64-NEXT:    slli a1, a1, 63
; CHECK-RV64-NEXT:    vsetivli zero, 4, e64, m2, ta, ma
; CHECK-RV64-NEXT:    vmv.v.x v8, a1
; CHECK-RV64-NEXT:    vse64.v v8, (a0)
; CHECK-RV64-NEXT:    ret
  %a = insertelement <4 x double> poison, double -0.0, i32 0
  %b = shufflevector <4 x double> %a, <4 x double> poison, <4 x i32> zeroinitializer
  store <4 x double> %b, ptr %x
  ret void
}
