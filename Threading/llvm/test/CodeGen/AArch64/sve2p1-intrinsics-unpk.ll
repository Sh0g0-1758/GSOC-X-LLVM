; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+sme2 -verify-machineinstrs < %s | FileCheck %s


; == 2 vectors ==

define { <vscale x 8 x i16>, <vscale x 8 x i16> } @test_unpk_s16_x2(<vscale x 16 x i8> %unused, <vscale x 16 x i8> %a) {
; CHECK-LABEL: test_unpk_s16_x2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sunpk { z0.h, z1.h }, z1.b
; CHECK-NEXT:    ret
  %res = call { <vscale x 8 x i16>, <vscale x 8 x i16> } @llvm.aarch64.sve.sunpk.x2.nxv8i16(<vscale x 16 x i8> %a)
  ret { <vscale x 8 x i16>, <vscale x 8 x i16> } %res
}

define { <vscale x 4 x i32>, <vscale x 4 x i32> } @test_unpk_s32_x2(<vscale x 8 x i16> %unused, <vscale x 8 x i16> %a) {
; CHECK-LABEL: test_unpk_s32_x2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sunpk { z0.s, z1.s }, z1.h
; CHECK-NEXT:    ret
  %res = call { <vscale x 4 x i32>, <vscale x 4 x i32> } @llvm.aarch64.sve.sunpk.x2.nxv4i32(<vscale x 8 x i16> %a)
  ret { <vscale x 4 x i32>, <vscale x 4 x i32> } %res
}

define { <vscale x 2 x i64>, <vscale x 2 x i64> } @test_unpk_s64_x2(<vscale x 4 x i32> %unusued, <vscale x 4 x i32> %a) {
; CHECK-LABEL: test_unpk_s64_x2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sunpk { z0.d, z1.d }, z1.s
; CHECK-NEXT:    ret
  %res = call { <vscale x 2 x i64>, <vscale x 2 x i64> } @llvm.aarch64.sve.sunpk.x2.nxv2i64(<vscale x 4 x i32> %a)
  ret { <vscale x 2 x i64>, <vscale x 2 x i64> } %res
}

define { <vscale x 8 x i16>, <vscale x 8 x i16> } @test_unpk_u16_x2(<vscale x 16 x i8> %unused, <vscale x 16 x i8> %a) {
; CHECK-LABEL: test_unpk_u16_x2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpk { z0.h, z1.h }, z1.b
; CHECK-NEXT:    ret
  %res = call { <vscale x 8 x i16>, <vscale x 8 x i16> } @llvm.aarch64.sve.uunpk.x2.nxv8i16(<vscale x 16 x i8> %a)
  ret { <vscale x 8 x i16>, <vscale x 8 x i16> } %res
}

define { <vscale x 4 x i32>, <vscale x 4 x i32> } @test_unpk_u32_x2(<vscale x 8 x i16> %unused, <vscale x 8 x i16> %a) {
; CHECK-LABEL: test_unpk_u32_x2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpk { z0.s, z1.s }, z1.h
; CHECK-NEXT:    ret
  %res = call { <vscale x 4 x i32>, <vscale x 4 x i32> } @llvm.aarch64.sve.uunpk.x2.nxv4i32(<vscale x 8 x i16> %a)
  ret { <vscale x 4 x i32>, <vscale x 4 x i32> } %res
}

define { <vscale x 2 x i64>, <vscale x 2 x i64> } @test_unpk_u64_x2(<vscale x 4 x i32> %unused, <vscale x 4 x i32> %a) {
; CHECK-LABEL: test_unpk_u64_x2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpk { z0.d, z1.d }, z1.s
; CHECK-NEXT:    ret
  %res = call { <vscale x 2 x i64>, <vscale x 2 x i64> } @llvm.aarch64.sve.uunpk.x2.nxv2i64(<vscale x 4 x i32> %a)
  ret { <vscale x 2 x i64>, <vscale x 2 x i64> } %res
}


; == 4 vectors ==

define { <vscale x 8 x i16>, <vscale x 8 x i16>, <vscale x 8 x i16>, <vscale x 8 x i16> } @test_unpk_s16_x4(<vscale x 16 x i8> %unused, <vscale x 16 x i8> %a, <vscale x 16 x i8> %b) {
; CHECK-LABEL: test_unpk_s16_x4:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov z3.d, z2.d
; CHECK-NEXT:    mov z2.d, z1.d
; CHECK-NEXT:    sunpk { z0.h - z3.h }, { z2.b, z3.b }
; CHECK-NEXT:    ret
  %res = call { <vscale x 8 x i16>, <vscale x 8 x i16>, <vscale x 8 x i16>, <vscale x 8 x i16> } @llvm.aarch64.sve.sunpk.x4.nxv8i16(<vscale x 16 x i8> %a, <vscale x 16 x i8> %b)
  ret { <vscale x 8 x i16>, <vscale x 8 x i16>, <vscale x 8 x i16>, <vscale x 8 x i16> } %res
}

define { <vscale x 4 x i32>, <vscale x 4 x i32>, <vscale x 4 x i32>, <vscale x 4 x i32> } @test_unpk_s32(<vscale x 8 x i16> %unused, <vscale x 8 x i16> %a, <vscale x 8 x i16> %b) {
; CHECK-LABEL: test_unpk_s32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov z3.d, z2.d
; CHECK-NEXT:    mov z2.d, z1.d
; CHECK-NEXT:    sunpk { z0.s - z3.s }, { z2.h, z3.h }
; CHECK-NEXT:    ret
  %res = call { <vscale x 4 x i32>, <vscale x 4 x i32>, <vscale x 4 x i32>, <vscale x 4 x i32> } @llvm.aarch64.sve.sunpk.x4.nxv4i32(<vscale x 8 x i16> %a, <vscale x 8 x i16> %b)
  ret { <vscale x 4 x i32>, <vscale x 4 x i32>, <vscale x 4 x i32>, <vscale x 4 x i32> } %res
}

define { <vscale x 2 x i64>, <vscale x 2 x i64>, <vscale x 2 x i64>, <vscale x 2 x i64> } @test_unpk_s64(<vscale x 4 x i32> %unused, <vscale x 4 x i32> %a, <vscale x 4 x i32> %b) {
; CHECK-LABEL: test_unpk_s64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov z3.d, z2.d
; CHECK-NEXT:    mov z2.d, z1.d
; CHECK-NEXT:    sunpk { z0.d - z3.d }, { z2.s, z3.s }
; CHECK-NEXT:    ret
  %res = call { <vscale x 2 x i64>, <vscale x 2 x i64>, <vscale x 2 x i64>, <vscale x 2 x i64> } @llvm.aarch64.sve.sunpk.x4.nxv2i64(<vscale x 4 x i32> %a, <vscale x 4 x i32> %b)
  ret { <vscale x 2 x i64>, <vscale x 2 x i64>, <vscale x 2 x i64>, <vscale x 2 x i64> } %res
}

define { <vscale x 8 x i16>, <vscale x 8 x i16>, <vscale x 8 x i16>, <vscale x 8 x i16> } @test_unpk_u16_x4(<vscale x 16 x i8> %unused, <vscale x 16 x i8> %a, <vscale x 16 x i8> %b) {
; CHECK-LABEL: test_unpk_u16_x4:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov z3.d, z2.d
; CHECK-NEXT:    mov z2.d, z1.d
; CHECK-NEXT:    uunpk { z0.h - z3.h }, { z2.b, z3.b }
; CHECK-NEXT:    ret
  %res = call { <vscale x 8 x i16>, <vscale x 8 x i16>, <vscale x 8 x i16>, <vscale x 8 x i16> } @llvm.aarch64.sve.uunpk.x4.nxv8i16(<vscale x 16 x i8> %a, <vscale x 16 x i8> %b)
  ret { <vscale x 8 x i16>, <vscale x 8 x i16>, <vscale x 8 x i16>, <vscale x 8 x i16> } %res
}

define { <vscale x 4 x i32>, <vscale x 4 x i32>, <vscale x 4 x i32>, <vscale x 4 x i32> } @test_unpk_u32(<vscale x 8 x i16> %unused, <vscale x 8 x i16> %a, <vscale x 8 x i16> %b) {
; CHECK-LABEL: test_unpk_u32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov z3.d, z2.d
; CHECK-NEXT:    mov z2.d, z1.d
; CHECK-NEXT:    uunpk { z0.s - z3.s }, { z2.h, z3.h }
; CHECK-NEXT:    ret
  %res = call { <vscale x 4 x i32>, <vscale x 4 x i32>, <vscale x 4 x i32>, <vscale x 4 x i32> } @llvm.aarch64.sve.uunpk.x4.nxv4i32(<vscale x 8 x i16> %a, <vscale x 8 x i16> %b)
  ret { <vscale x 4 x i32>, <vscale x 4 x i32>, <vscale x 4 x i32>, <vscale x 4 x i32> } %res
}

define { <vscale x 2 x i64>, <vscale x 2 x i64>, <vscale x 2 x i64>, <vscale x 2 x i64> } @test_unpk_u64(<vscale x 4 x i32> %unused, <vscale x 4 x i32> %a, <vscale x 4 x i32> %b) {
; CHECK-LABEL: test_unpk_u64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov z3.d, z2.d
; CHECK-NEXT:    mov z2.d, z1.d
; CHECK-NEXT:    uunpk { z0.d - z3.d }, { z2.s, z3.s }
; CHECK-NEXT:    ret
  %res = call { <vscale x 2 x i64>, <vscale x 2 x i64>, <vscale x 2 x i64>, <vscale x 2 x i64> } @llvm.aarch64.sve.uunpk.x4.nxv2i64(<vscale x 4 x i32> %a, <vscale x 4 x i32> %b)
  ret { <vscale x 2 x i64>, <vscale x 2 x i64>, <vscale x 2 x i64>, <vscale x 2 x i64> } %res
}



; == 2 vectors ==
declare { <vscale x 8 x i16>, <vscale x 8 x i16> } @llvm.aarch64.sve.sunpk.x2.nxv8i16(<vscale x 16 x i8>)
declare { <vscale x 4 x i32>, <vscale x 4 x i32> } @llvm.aarch64.sve.sunpk.x2.nxv4i32(<vscale x 8 x i16>)
declare { <vscale x 2 x i64>, <vscale x 2 x i64> } @llvm.aarch64.sve.sunpk.x2.nxv2i64(<vscale x 4 x i32>)
declare { <vscale x 8 x i16>, <vscale x 8 x i16> } @llvm.aarch64.sve.uunpk.x2.nxv8i16(<vscale x 16 x i8>)
declare { <vscale x 4 x i32>, <vscale x 4 x i32> } @llvm.aarch64.sve.uunpk.x2.nxv4i32(<vscale x 8 x i16>)
declare { <vscale x 2 x i64>, <vscale x 2 x i64> } @llvm.aarch64.sve.uunpk.x2.nxv2i64(<vscale x 4 x i32>)

; == 4 vectors ==
declare { <vscale x 8 x i16>, <vscale x 8 x i16>, <vscale x 8 x i16>, <vscale x 8 x i16> } @llvm.aarch64.sve.sunpk.x4.nxv8i16(<vscale x 16 x i8>, <vscale x 16 x i8>)
declare { <vscale x 4 x i32>, <vscale x 4 x i32>, <vscale x 4 x i32>, <vscale x 4 x i32> } @llvm.aarch64.sve.sunpk.x4.nxv4i32(<vscale x 8 x i16>, <vscale x 8 x i16>)
declare { <vscale x 2 x i64>, <vscale x 2 x i64>, <vscale x 2 x i64>, <vscale x 2 x i64> } @llvm.aarch64.sve.sunpk.x4.nxv2i64(<vscale x 4 x i32>, <vscale x 4 x i32>)
declare { <vscale x 8 x i16>, <vscale x 8 x i16>, <vscale x 8 x i16>, <vscale x 8 x i16> } @llvm.aarch64.sve.uunpk.x4.nxv8i16(<vscale x 16 x i8>, <vscale x 16 x i8>)
declare { <vscale x 4 x i32>, <vscale x 4 x i32>, <vscale x 4 x i32>, <vscale x 4 x i32> } @llvm.aarch64.sve.uunpk.x4.nxv4i32(<vscale x 8 x i16>, <vscale x 8 x i16>)
declare { <vscale x 2 x i64>, <vscale x 2 x i64>, <vscale x 2 x i64>, <vscale x 2 x i64> } @llvm.aarch64.sve.uunpk.x4.nxv2i64(<vscale x 4 x i32>, <vscale x 4 x i32>)
