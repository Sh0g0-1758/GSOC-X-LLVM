; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc --mtriple=loongarch64 --mattr=+lasx < %s | FileCheck %s

declare <8 x float> @llvm.loongarch.lasx.xvfmax.s(<8 x float>, <8 x float>)

define <8 x float> @lasx_xvfmax_s(<8 x float> %va, <8 x float> %vb) nounwind {
; CHECK-LABEL: lasx_xvfmax_s:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvfmax.s $xr0, $xr0, $xr1
; CHECK-NEXT:    ret
entry:
  %res = call <8 x float> @llvm.loongarch.lasx.xvfmax.s(<8 x float> %va, <8 x float> %vb)
  ret <8 x float> %res
}

declare <4 x double> @llvm.loongarch.lasx.xvfmax.d(<4 x double>, <4 x double>)

define <4 x double> @lasx_xvfmax_d(<4 x double> %va, <4 x double> %vb) nounwind {
; CHECK-LABEL: lasx_xvfmax_d:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvfmax.d $xr0, $xr0, $xr1
; CHECK-NEXT:    ret
entry:
  %res = call <4 x double> @llvm.loongarch.lasx.xvfmax.d(<4 x double> %va, <4 x double> %vb)
  ret <4 x double> %res
}
