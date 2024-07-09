; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=powerpc64le-unknown-linux-gnu -global-isel -o - \
; RUN:   -ppc-vsr-nums-as-vr -ppc-asm-full-reg-names < %s | FileCheck %s

define float @float_add(float %a, float %b) {
; CHECK-LABEL: float_add:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xsaddsp f1, f1, f2
; CHECK-NEXT:    blr
entry:
  %add = fadd float %a, %b
  ret float %add
}

define double @double_add(double %a, double %b) {
; CHECK-LABEL: double_add:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xsadddp f1, f1, f2
; CHECK-NEXT:    blr
entry:
  %add = fadd double %a, %b
  ret double %add
}

define float @float_sub(float %a, float %b) {
; CHECK-LABEL: float_sub:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xssubsp f1, f1, f2
; CHECK-NEXT:    blr
entry:
  %sub = fsub float %a, %b
  ret float %sub
}

define float @float_mul(float %a, float %b) {
; CHECK-LABEL: float_mul:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xsmulsp f1, f1, f2
; CHECK-NEXT:    blr
entry:
  %mul = fmul float %a, %b
  ret float %mul
}

define float @float_div(float %a, float %b) {
; CHECK-LABEL: float_div:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xsdivsp f1, f1, f2
; CHECK-NEXT:    blr
entry:
  %div = fdiv float %a, %b
  ret float %div
}

define <4 x float> @test_fadd_v4f32(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: test_fadd_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvaddsp v2, v2, v3
; CHECK-NEXT:    blr
  %res = fadd <4 x float> %a, %b
  ret <4 x float> %res
}

define <2 x double> @test_fadd_v2f64(<2 x double> %a, <2 x double> %b) {
; CHECK-LABEL: test_fadd_v2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvadddp v2, v2, v3
; CHECK-NEXT:    blr
  %res = fadd <2 x double> %a, %b
  ret <2 x double> %res
}

define <4 x float> @test_fsub_v4f32(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: test_fsub_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvsubsp v2, v2, v3
; CHECK-NEXT:    blr
  %res = fsub <4 x float> %a, %b
  ret <4 x float> %res
}

define <2 x double> @test_fsub_v2f64(<2 x double> %a, <2 x double> %b) {
; CHECK-LABEL: test_fsub_v2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvsubdp v2, v2, v3
; CHECK-NEXT:    blr
  %res = fsub <2 x double> %a, %b
  ret <2 x double> %res
}

define <4 x float> @test_fmul_v4f32(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: test_fmul_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvmulsp v2, v2, v3
; CHECK-NEXT:    blr
  %res = fmul <4 x float> %a, %b
  ret <4 x float> %res
}

define <2 x double> @test_fmul_v2f64(<2 x double> %a, <2 x double> %b) {
; CHECK-LABEL: test_fmul_v2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvmuldp v2, v2, v3
; CHECK-NEXT:    blr
  %res = fmul <2 x double> %a, %b
  ret <2 x double> %res
}

define <4 x float> @test_fdiv_v4f32(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: test_fdiv_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvdivsp v2, v2, v3
; CHECK-NEXT:    blr
  %res = fdiv <4 x float> %a, %b
  ret <4 x float> %res
}

define <2 x double> @test_fdiv_v2f64(<2 x double> %a, <2 x double> %b) {
; CHECK-LABEL: test_fdiv_v2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvdivdp v2, v2, v3
; CHECK-NEXT:    blr
  %res = fdiv <2 x double> %a, %b
  ret <2 x double> %res
}
