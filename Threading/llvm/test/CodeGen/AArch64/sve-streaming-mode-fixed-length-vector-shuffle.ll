; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mattr=+sve -force-streaming-compatible-sve < %s | FileCheck %s
; RUN: llc -mattr=+sme -force-streaming-compatible-sve < %s | FileCheck %s


target triple = "aarch64-unknown-linux-gnu"

define <4 x i8> @shuffle_ext_byone_v4i8(<4 x i8> %op1, <4 x i8> %op2) {
; CHECK-LABEL: shuffle_ext_byone_v4i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI0_0
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    ldr q1, [x8, :lo12:.LCPI0_0]
; CHECK-NEXT:    tbl z0.h, { z0.h }, z1.h
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %ret = shufflevector <4 x i8> %op1, <4 x i8> %op2, <4 x i32> <i32 0, i32 3, i32 2, i32 1>
  ret <4 x i8> %ret
}

define <8 x i8> @shuffle_ext_byone_v8i8(<8 x i8> %op1, <8 x i8> %op2) {
; CHECK-LABEL: shuffle_ext_byone_v8i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    mov z0.b, z0.b[7]
; CHECK-NEXT:    fmov w8, s0
; CHECK-NEXT:    insr z1.b, w8
; CHECK-NEXT:    fmov d0, d1
; CHECK-NEXT:    ret
  %ret = shufflevector <8 x i8> %op1, <8 x i8> %op2, <8 x i32> <i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14>
  ret <8 x i8> %ret
}

define <16 x i8> @shuffle_ext_byone_v16i8(<16 x i8> %op1, <16 x i8> %op2) {
; CHECK-LABEL: shuffle_ext_byone_v16i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $q0 killed $q0 def $z0
; CHECK-NEXT:    // kill: def $q1 killed $q1 def $z1
; CHECK-NEXT:    mov z0.b, z0.b[15]
; CHECK-NEXT:    fmov w8, s0
; CHECK-NEXT:    insr z1.b, w8
; CHECK-NEXT:    mov z0.d, z1.d
; CHECK-NEXT:    ret
  %ret = shufflevector <16 x i8> %op1, <16 x i8> %op2, <16 x i32> <i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22,
                                                                   i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30>
  ret <16 x i8> %ret
}

define void @shuffle_ext_byone_v32i8(ptr %a, ptr %b) {
; CHECK-LABEL: shuffle_ext_byone_v32i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr q0, [x0, #16]
; CHECK-NEXT:    ldp q1, q3, [x1]
; CHECK-NEXT:    mov z0.b, z0.b[15]
; CHECK-NEXT:    mov z2.b, z1.b[15]
; CHECK-NEXT:    fmov w8, s0
; CHECK-NEXT:    insr z1.b, w8
; CHECK-NEXT:    fmov w8, s2
; CHECK-NEXT:    insr z3.b, w8
; CHECK-NEXT:    stp q1, q3, [x0]
; CHECK-NEXT:    ret
  %op1 = load <32 x i8>, ptr %a
  %op2 = load <32 x i8>, ptr %b
  %ret = shufflevector <32 x i8> %op1, <32 x i8> %op2, <32 x i32> <i32 31, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38,
                                                                   i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46,
                                                                   i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54,
                                                                   i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62>
  store <32 x i8> %ret, ptr %a
  ret void
}

define <2 x i16> @shuffle_ext_byone_v2i16(<2 x i16> %op1, <2 x i16> %op2) {
; CHECK-LABEL: shuffle_ext_byone_v2i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    revw z0.d, p0/m, z0.d
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %ret = shufflevector <2 x i16> %op1, <2 x i16> %op2, <2 x i32> <i32 1, i32 0>
  ret <2 x i16> %ret
}

define <4 x i16> @shuffle_ext_byone_v4i16(<4 x i16> %op1, <4 x i16> %op2) {
; CHECK-LABEL: shuffle_ext_byone_v4i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    mov z0.h, z0.h[3]
; CHECK-NEXT:    fmov w8, s0
; CHECK-NEXT:    insr z1.h, w8
; CHECK-NEXT:    fmov d0, d1
; CHECK-NEXT:    ret
  %ret = shufflevector <4 x i16> %op1, <4 x i16> %op2, <4 x i32> <i32 3, i32 4, i32 5, i32 6>
  ret <4 x i16> %ret
}

define <8 x i16> @shuffle_ext_byone_v8i16(<8 x i16> %op1, <8 x i16> %op2) {
; CHECK-LABEL: shuffle_ext_byone_v8i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $q0 killed $q0 def $z0
; CHECK-NEXT:    // kill: def $q1 killed $q1 def $z1
; CHECK-NEXT:    mov z0.h, z0.h[7]
; CHECK-NEXT:    fmov w8, s0
; CHECK-NEXT:    insr z1.h, w8
; CHECK-NEXT:    mov z0.d, z1.d
; CHECK-NEXT:    ret
  %ret = shufflevector <8 x i16> %op1, <8 x i16> %op2, <8 x i32> <i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14>
  ret <8 x i16> %ret
}

define void @shuffle_ext_byone_v16i16(ptr %a, ptr %b) {
; CHECK-LABEL: shuffle_ext_byone_v16i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr q0, [x0, #16]
; CHECK-NEXT:    ldp q1, q3, [x1]
; CHECK-NEXT:    mov z0.h, z0.h[7]
; CHECK-NEXT:    mov z2.h, z1.h[7]
; CHECK-NEXT:    fmov w8, s0
; CHECK-NEXT:    insr z1.h, w8
; CHECK-NEXT:    fmov w8, s2
; CHECK-NEXT:    insr z3.h, w8
; CHECK-NEXT:    stp q1, q3, [x0]
; CHECK-NEXT:    ret
  %op1 = load <16 x i16>, ptr %a
  %op2 = load <16 x i16>, ptr %b
  %ret = shufflevector <16 x i16> %op1, <16 x i16> %op2, <16 x i32> <i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22,
                                                                     i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30>
  store <16 x i16> %ret, ptr %a
  ret void
}

define <2 x i32> @shuffle_ext_byone_v2i32(<2 x i32> %op1, <2 x i32> %op2) {
; CHECK-LABEL: shuffle_ext_byone_v2i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    mov z0.s, z0.s[1]
; CHECK-NEXT:    fmov w8, s0
; CHECK-NEXT:    insr z1.s, w8
; CHECK-NEXT:    fmov d0, d1
; CHECK-NEXT:    ret
  %ret = shufflevector <2 x i32> %op1, <2 x i32> %op2, <2 x i32> <i32 1, i32 2>
  ret <2 x i32> %ret
}

define <4 x i32> @shuffle_ext_byone_v4i32(<4 x i32> %op1, <4 x i32> %op2) {
; CHECK-LABEL: shuffle_ext_byone_v4i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $q0 killed $q0 def $z0
; CHECK-NEXT:    // kill: def $q1 killed $q1 def $z1
; CHECK-NEXT:    mov z0.s, z0.s[3]
; CHECK-NEXT:    fmov w8, s0
; CHECK-NEXT:    insr z1.s, w8
; CHECK-NEXT:    mov z0.d, z1.d
; CHECK-NEXT:    ret
  %ret = shufflevector <4 x i32> %op1, <4 x i32> %op2, <4 x i32> <i32 3, i32 4, i32 5, i32 6>
  ret <4 x i32> %ret
}

define void @shuffle_ext_byone_v8i32(ptr %a, ptr %b) {
; CHECK-LABEL: shuffle_ext_byone_v8i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr q0, [x0, #16]
; CHECK-NEXT:    ldp q1, q3, [x1]
; CHECK-NEXT:    mov z0.s, z0.s[3]
; CHECK-NEXT:    mov z2.s, z1.s[3]
; CHECK-NEXT:    fmov w8, s0
; CHECK-NEXT:    insr z1.s, w8
; CHECK-NEXT:    fmov w8, s2
; CHECK-NEXT:    insr z3.s, w8
; CHECK-NEXT:    stp q1, q3, [x0]
; CHECK-NEXT:    ret
  %op1 = load <8 x i32>, ptr %a
  %op2 = load <8 x i32>, ptr %b
  %ret = shufflevector <8 x i32> %op1, <8 x i32> %op2, <8 x i32> <i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14>
  store <8 x i32> %ret, ptr %a
  ret void
}

define <2 x i64> @shuffle_ext_byone_v2i64(<2 x i64> %op1, <2 x i64> %op2) {
; CHECK-LABEL: shuffle_ext_byone_v2i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $q0 killed $q0 def $z0
; CHECK-NEXT:    // kill: def $q1 killed $q1 def $z1
; CHECK-NEXT:    mov z0.d, z0.d[1]
; CHECK-NEXT:    fmov x8, d0
; CHECK-NEXT:    insr z1.d, x8
; CHECK-NEXT:    mov z0.d, z1.d
; CHECK-NEXT:    ret
  %ret = shufflevector <2 x i64> %op1, <2 x i64> %op2, <2 x i32> <i32 1, i32 2>
  ret <2 x i64> %ret
}

define void @shuffle_ext_byone_v4i64(ptr %a, ptr %b) {
; CHECK-LABEL: shuffle_ext_byone_v4i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr q0, [x0, #16]
; CHECK-NEXT:    ldp q1, q3, [x1]
; CHECK-NEXT:    mov z0.d, z0.d[1]
; CHECK-NEXT:    mov z2.d, z1.d[1]
; CHECK-NEXT:    fmov x8, d0
; CHECK-NEXT:    insr z1.d, x8
; CHECK-NEXT:    fmov x8, d2
; CHECK-NEXT:    insr z3.d, x8
; CHECK-NEXT:    stp q1, q3, [x0]
; CHECK-NEXT:    ret
  %op1 = load <4 x i64>, ptr %a
  %op2 = load <4 x i64>, ptr %b
  %ret = shufflevector <4 x i64> %op1, <4 x i64> %op2, <4 x i32> <i32 3, i32 4, i32 5, i32 6>
  store <4 x i64> %ret, ptr %a
  ret void
}


define <4 x half> @shuffle_ext_byone_v4f16(<4 x half> %op1, <4 x half> %op2) {
; CHECK-LABEL: shuffle_ext_byone_v4f16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    mov z2.h, z0.h[3]
; CHECK-NEXT:    fmov d0, d1
; CHECK-NEXT:    insr z0.h, h2
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %ret = shufflevector <4 x half> %op1, <4 x half> %op2, <4 x i32> <i32 3, i32 4, i32 5, i32 6>
  ret <4 x half> %ret
}

define <8 x half> @shuffle_ext_byone_v8f16(<8 x half> %op1, <8 x half> %op2) {
; CHECK-LABEL: shuffle_ext_byone_v8f16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $q0 killed $q0 def $z0
; CHECK-NEXT:    mov z2.h, z0.h[7]
; CHECK-NEXT:    mov z0.d, z1.d
; CHECK-NEXT:    insr z0.h, h2
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %ret = shufflevector <8 x half> %op1, <8 x half> %op2, <8 x i32> <i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14>
  ret <8 x half> %ret
}

define void @shuffle_ext_byone_v16f16(ptr %a, ptr %b) {
; CHECK-LABEL: shuffle_ext_byone_v16f16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldp q1, q3, [x1]
; CHECK-NEXT:    ldr q0, [x0, #16]
; CHECK-NEXT:    mov z0.h, z0.h[7]
; CHECK-NEXT:    mov z2.h, z1.h[7]
; CHECK-NEXT:    insr z1.h, h0
; CHECK-NEXT:    insr z3.h, h2
; CHECK-NEXT:    stp q1, q3, [x0]
; CHECK-NEXT:    ret
  %op1 = load <16 x half>, ptr %a
  %op2 = load <16 x half>, ptr %b
  %ret = shufflevector <16 x half> %op1, <16 x half> %op2, <16 x i32> <i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22,
                                                                       i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30>
  store <16 x half> %ret, ptr %a
  ret void
}

define <2 x float> @shuffle_ext_byone_v2f32(<2 x float> %op1, <2 x float> %op2) {
; CHECK-LABEL: shuffle_ext_byone_v2f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    mov z2.s, z0.s[1]
; CHECK-NEXT:    fmov d0, d1
; CHECK-NEXT:    insr z0.s, s2
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %ret = shufflevector <2 x float> %op1, <2 x float> %op2, <2 x i32> <i32 1, i32 2>
  ret <2 x float> %ret
}

define <4 x float> @shuffle_ext_byone_v4f32(<4 x float> %op1, <4 x float> %op2) {
; CHECK-LABEL: shuffle_ext_byone_v4f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $q0 killed $q0 def $z0
; CHECK-NEXT:    mov z2.s, z0.s[3]
; CHECK-NEXT:    mov z0.d, z1.d
; CHECK-NEXT:    insr z0.s, s2
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %ret = shufflevector <4 x float> %op1, <4 x float> %op2, <4 x i32> <i32 3, i32 4, i32 5, i32 6>
  ret <4 x float> %ret
}

define void @shuffle_ext_byone_v8f32(ptr %a, ptr %b) {
; CHECK-LABEL: shuffle_ext_byone_v8f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldp q1, q3, [x1]
; CHECK-NEXT:    ldr q0, [x0, #16]
; CHECK-NEXT:    mov z0.s, z0.s[3]
; CHECK-NEXT:    mov z2.s, z1.s[3]
; CHECK-NEXT:    insr z1.s, s0
; CHECK-NEXT:    insr z3.s, s2
; CHECK-NEXT:    stp q1, q3, [x0]
; CHECK-NEXT:    ret
  %op1 = load <8 x float>, ptr %a
  %op2 = load <8 x float>, ptr %b
  %ret = shufflevector <8 x float> %op1, <8 x float> %op2, <8 x i32> <i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14>
  store <8 x float> %ret, ptr %a
  ret void
}

define <2 x double> @shuffle_ext_byone_v2f64(<2 x double> %op1, <2 x double> %op2) {
; CHECK-LABEL: shuffle_ext_byone_v2f64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $q0 killed $q0 def $z0
; CHECK-NEXT:    mov z2.d, z0.d[1]
; CHECK-NEXT:    mov z0.d, z1.d
; CHECK-NEXT:    insr z0.d, d2
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %ret = shufflevector <2 x double> %op1, <2 x double> %op2, <2 x i32> <i32 1, i32 2>
  ret <2 x double> %ret
}

define void @shuffle_ext_byone_v4f64(ptr %a, ptr %b) {
; CHECK-LABEL: shuffle_ext_byone_v4f64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldp q1, q3, [x1]
; CHECK-NEXT:    ldr q0, [x0, #16]
; CHECK-NEXT:    mov z0.d, z0.d[1]
; CHECK-NEXT:    mov z2.d, z1.d[1]
; CHECK-NEXT:    insr z1.d, d0
; CHECK-NEXT:    insr z3.d, d2
; CHECK-NEXT:    stp q1, q3, [x0]
; CHECK-NEXT:    ret
  %op1 = load <4 x double>, ptr %a
  %op2 = load <4 x double>, ptr %b
  %ret = shufflevector <4 x double> %op1, <4 x double> %op2, <4 x i32> <i32 3, i32 4, i32 5, i32 6>
  store <4 x double> %ret, ptr %a
  ret void
}

define void @shuffle_ext_byone_reverse(ptr %a, ptr %b) {
; CHECK-LABEL: shuffle_ext_byone_reverse:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldp q1, q3, [x0]
; CHECK-NEXT:    ldr q0, [x1, #16]
; CHECK-NEXT:    mov z0.d, z0.d[1]
; CHECK-NEXT:    mov z2.d, z1.d[1]
; CHECK-NEXT:    insr z1.d, d0
; CHECK-NEXT:    insr z3.d, d2
; CHECK-NEXT:    stp q1, q3, [x0]
; CHECK-NEXT:    ret
  %op1 = load <4 x double>, ptr %a
  %op2 = load <4 x double>, ptr %b
  %ret = shufflevector <4 x double> %op1, <4 x double> %op2, <4 x i32> <i32 7, i32 0, i32 1, i32 2>
  store <4 x double> %ret, ptr %a
  ret void
}

define void @shuffle_ext_invalid(ptr %a, ptr %b) {
; CHECK-LABEL: shuffle_ext_invalid:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr q0, [x0, #16]
; CHECK-NEXT:    ldr q1, [x1]
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
  %op1 = load <4 x double>, ptr %a
  %op2 = load <4 x double>, ptr %b
  %ret = shufflevector <4 x double> %op1, <4 x double> %op2, <4 x i32> <i32 2, i32 3, i32 4, i32 5>
  store <4 x double> %ret, ptr %a
  ret void
}
