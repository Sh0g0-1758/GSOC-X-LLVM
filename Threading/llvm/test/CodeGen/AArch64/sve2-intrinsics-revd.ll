; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+sme -verify-machineinstrs < %s | FileCheck %s

define <vscale x 16 x i8> @test_revd_i8(<vscale x 16 x i8> %a, <vscale x 16 x i1> %pg, <vscale x 16 x i8> %b) {
; CHECK-LABEL: test_revd_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    revd z0.q, p0/m, z1.q
; CHECK-NEXT:    ret
  %res = call <vscale x 16 x i8> @llvm.aarch64.sve.revd.nxv16i8(<vscale x 16 x i8> %a, <vscale x 16 x i1> %pg, <vscale x 16 x i8> %b)
  ret <vscale x 16 x i8> %res
}

define <vscale x 8 x i16> @test_revd_i16(<vscale x 8 x i16> %a, <vscale x 8 x i1> %pg, <vscale x 8 x i16> %b) {
; CHECK-LABEL: test_revd_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    revd z0.q, p0/m, z1.q
; CHECK-NEXT:    ret
  %res = call <vscale x  8 x i16> @llvm.aarch64.sve.revd.nxv8i16(<vscale x  8 x i16> %a, <vscale x 8 x i1> %pg, <vscale x 8 x i16> %b)
  ret <vscale x 8 x i16> %res
}

define <vscale x 4 x i32> @test_revd_i32(<vscale x 4 x i32> %a, <vscale x 4 x i1> %pg, <vscale x 4 x i32> %b) {
; CHECK-LABEL: test_revd_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    revd z0.q, p0/m, z1.q
; CHECK-NEXT:    ret
  %res = call <vscale x 4 x i32> @llvm.aarch64.sve.revd.nxv4i32(<vscale x 4 x i32> %a, <vscale x 4 x i1> %pg, <vscale x 4 x i32> %b)
  ret <vscale x 4 x i32> %res
}

define <vscale x 2 x i64> @test_revd_i64(<vscale x 2 x i64> %a, <vscale x 2 x i1> %pg, <vscale x 2 x i64> %b) {
; CHECK-LABEL: test_revd_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    revd z0.q, p0/m, z1.q
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x i64> @llvm.aarch64.sve.revd.nxv2i64(<vscale x 2 x i64> %a, <vscale x 2 x i1> %pg, <vscale x 2 x i64> %b)
  ret <vscale x 2 x i64> %res
}

define <vscale x 8 x bfloat> @test_revd_bf16(<vscale x 8 x bfloat> %a, <vscale x 8 x i1> %pg, <vscale x 8 x bfloat> %b) {
; CHECK-LABEL: test_revd_bf16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    revd z0.q, p0/m, z1.q
; CHECK-NEXT:    ret
  %res = call <vscale x 8 x bfloat> @llvm.aarch64.sve.revd.nxv8bf16(<vscale x 8 x bfloat> %a, <vscale x 8 x i1> %pg, <vscale x 8 x bfloat> %b)
  ret <vscale x 8 x bfloat> %res
}

define <vscale x 8 x half> @test_revd_f16(<vscale x 8 x half> %a, <vscale x 8 x i1> %pg, <vscale x 8 x half> %b) {
; CHECK-LABEL: test_revd_f16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    revd z0.q, p0/m, z1.q
; CHECK-NEXT:    ret
  %res = call <vscale x 8 x half> @llvm.aarch64.sve.revd.nxv8f16(<vscale x 8 x half> %a, <vscale x 8 x i1> %pg, <vscale x 8 x half> %b)
  ret <vscale x 8 x half> %res
}

define <vscale x 4 x float> @test_revd_f32(<vscale x 4 x float> %a, <vscale x 4 x i1> %pg, <vscale x 4 x float> %b) {
; CHECK-LABEL: test_revd_f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    revd z0.q, p0/m, z1.q
; CHECK-NEXT:    ret
  %res = call <vscale x 4 x float> @llvm.aarch64.sve.revd.nxv4f32(<vscale x 4 x float> %a, <vscale x 4 x i1> %pg, <vscale x 4 x float> %b)
  ret <vscale x 4 x float> %res
}

define <vscale x 2 x double> @test_revd_f64(<vscale x 2 x double> %a, <vscale x 2 x i1> %pg, <vscale x 2 x double> %b) {
; CHECK-LABEL: test_revd_f64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    revd z0.q, p0/m, z1.q
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x double> @llvm.aarch64.sve.revd.nxv2f64(<vscale x 2 x double> %a, <vscale x 2 x i1> %pg, <vscale x 2 x double> %b)
  ret <vscale x 2 x double> %res
}

declare <vscale x 16 x i8> @llvm.aarch64.sve.revd.nxv16i8(<vscale x 16 x i8>, <vscale x 16 x i1>, <vscale x 16 x i8>)
declare <vscale x 8 x i16> @llvm.aarch64.sve.revd.nxv8i16(<vscale x 8 x i16>, <vscale x 8 x i1>, <vscale x 8 x i16>)
declare <vscale x 4 x i32> @llvm.aarch64.sve.revd.nxv4i32(<vscale x 4 x i32>, <vscale x 4 x i1>, <vscale x 4 x i32>)
declare <vscale x 2 x i64> @llvm.aarch64.sve.revd.nxv2i64(<vscale x 2 x i64>, <vscale x 2 x i1>, <vscale x 2 x i64>)

declare <vscale x 8 x bfloat> @llvm.aarch64.sve.revd.nxv8bf16(<vscale x 8 x bfloat>, <vscale x 8 x i1>, <vscale x 8 x bfloat>)
declare <vscale x 8 x half> @llvm.aarch64.sve.revd.nxv8f16(<vscale x 8 x half>, <vscale x 8 x i1>, <vscale x 8 x half>)
declare <vscale x 4 x float> @llvm.aarch64.sve.revd.nxv4f32(<vscale x 4 x float>, <vscale x 4 x i1>, <vscale x 4 x float>)
declare <vscale x 2 x double> @llvm.aarch64.sve.revd.nxv2f64(<vscale x 2 x double>, <vscale x 2 x i1>, <vscale x 2 x double>)
