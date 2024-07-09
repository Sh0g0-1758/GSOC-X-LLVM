; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 2
; RUN: llc -mtriple=aarch64 -verify-machineinstrs %s -o - 2>&1 | FileCheck %s --check-prefixes=CHECK,CHECK-SD
; RUN: llc -mtriple=aarch64 -global-isel -global-isel-abort=2 -verify-machineinstrs %s -o - 2>&1 | FileCheck %s --check-prefixes=CHECK,CHECK-GI

; CHECK-GI:       warning: Instruction selection used fallback path for zext_v16i10_v16i16

define i16 @zext_i8_to_i16(i8 %a) {
; CHECK-LABEL: zext_i8_to_i16:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    and w0, w0, #0xff
; CHECK-NEXT:    ret
entry:
  %c = zext i8 %a to i16
  ret i16 %c
}

define i32 @zext_i8_to_i32(i8 %a) {
; CHECK-LABEL: zext_i8_to_i32:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    and w0, w0, #0xff
; CHECK-NEXT:    ret
entry:
  %c = zext i8 %a to i32
  ret i32 %c
}

define i64 @zext_i8_to_i64(i8 %a) {
; CHECK-LABEL: zext_i8_to_i64:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    // kill: def $w0 killed $w0 def $x0
; CHECK-NEXT:    and x0, x0, #0xff
; CHECK-NEXT:    ret
entry:
  %c = zext i8 %a to i64
  ret i64 %c
}

define i10 @zext_i8_to_i10(i8 %a) {
; CHECK-LABEL: zext_i8_to_i10:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    and w0, w0, #0xff
; CHECK-NEXT:    ret
entry:
  %c = zext i8 %a to i10
  ret i10 %c
}

define i32 @zext_i16_to_i32(i16 %a) {
; CHECK-LABEL: zext_i16_to_i32:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    and w0, w0, #0xffff
; CHECK-NEXT:    ret
entry:
  %c = zext i16 %a to i32
  ret i32 %c
}

define i64 @zext_i16_to_i64(i16 %a) {
; CHECK-LABEL: zext_i16_to_i64:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    // kill: def $w0 killed $w0 def $x0
; CHECK-NEXT:    and x0, x0, #0xffff
; CHECK-NEXT:    ret
entry:
  %c = zext i16 %a to i64
  ret i64 %c
}

define i64 @zext_i32_to_i64(i32 %a) {
; CHECK-LABEL: zext_i32_to_i64:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    mov w0, w0
; CHECK-NEXT:    ret
entry:
  %c = zext i32 %a to i64
  ret i64 %c
}

define i16 @zext_i10_to_i16(i10 %a) {
; CHECK-LABEL: zext_i10_to_i16:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    and w0, w0, #0x3ff
; CHECK-NEXT:    ret
entry:
  %c = zext i10 %a to i16
  ret i16 %c
}

define i32 @zext_i10_to_i32(i10 %a) {
; CHECK-LABEL: zext_i10_to_i32:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    and w0, w0, #0x3ff
; CHECK-NEXT:    ret
entry:
  %c = zext i10 %a to i32
  ret i32 %c
}

define i64 @zext_i10_to_i64(i10 %a) {
; CHECK-LABEL: zext_i10_to_i64:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    // kill: def $w0 killed $w0 def $x0
; CHECK-NEXT:    and x0, x0, #0x3ff
; CHECK-NEXT:    ret
entry:
  %c = zext i10 %a to i64
  ret i64 %c
}

define <2 x i16> @zext_v2i8_v2i16(<2 x i8> %a) {
; CHECK-LABEL: zext_v2i8_v2i16:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    movi d1, #0x0000ff000000ff
; CHECK-NEXT:    and v0.8b, v0.8b, v1.8b
; CHECK-NEXT:    ret
entry:
  %c = zext <2 x i8> %a to <2 x i16>
  ret <2 x i16> %c
}

define <2 x i32> @zext_v2i8_v2i32(<2 x i8> %a) {
; CHECK-LABEL: zext_v2i8_v2i32:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    movi d1, #0x0000ff000000ff
; CHECK-NEXT:    and v0.8b, v0.8b, v1.8b
; CHECK-NEXT:    ret
entry:
  %c = zext <2 x i8> %a to <2 x i32>
  ret <2 x i32> %c
}

define <2 x i64> @zext_v2i8_v2i64(<2 x i8> %a) {
; CHECK-SD-LABEL: zext_v2i8_v2i64:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    movi d1, #0x0000ff000000ff
; CHECK-SD-NEXT:    and v0.8b, v0.8b, v1.8b
; CHECK-SD-NEXT:    ushll v0.2d, v0.2s, #0
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: zext_v2i8_v2i64:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    movi v1.2d, #0x000000000000ff
; CHECK-GI-NEXT:    ushll v0.2d, v0.2s, #0
; CHECK-GI-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-GI-NEXT:    ret
entry:
  %c = zext <2 x i8> %a to <2 x i64>
  ret <2 x i64> %c
}

define <2 x i32> @zext_v2i16_v2i32(<2 x i16> %a) {
; CHECK-LABEL: zext_v2i16_v2i32:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    movi d1, #0x00ffff0000ffff
; CHECK-NEXT:    and v0.8b, v0.8b, v1.8b
; CHECK-NEXT:    ret
entry:
  %c = zext <2 x i16> %a to <2 x i32>
  ret <2 x i32> %c
}

define <2 x i64> @zext_v2i16_v2i64(<2 x i16> %a) {
; CHECK-SD-LABEL: zext_v2i16_v2i64:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    movi d1, #0x00ffff0000ffff
; CHECK-SD-NEXT:    and v0.8b, v0.8b, v1.8b
; CHECK-SD-NEXT:    ushll v0.2d, v0.2s, #0
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: zext_v2i16_v2i64:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    movi v1.2d, #0x0000000000ffff
; CHECK-GI-NEXT:    ushll v0.2d, v0.2s, #0
; CHECK-GI-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-GI-NEXT:    ret
entry:
  %c = zext <2 x i16> %a to <2 x i64>
  ret <2 x i64> %c
}

define <2 x i64> @zext_v2i32_v2i64(<2 x i32> %a) {
; CHECK-LABEL: zext_v2i32_v2i64:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    ushll v0.2d, v0.2s, #0
; CHECK-NEXT:    ret
entry:
  %c = zext <2 x i32> %a to <2 x i64>
  ret <2 x i64> %c
}

define <2 x i16> @zext_v2i10_v2i16(<2 x i10> %a) {
; CHECK-LABEL: zext_v2i10_v2i16:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    movi v1.2s, #3, msl #8
; CHECK-NEXT:    and v0.8b, v0.8b, v1.8b
; CHECK-NEXT:    ret
entry:
  %c = zext <2 x i10> %a to <2 x i16>
  ret <2 x i16> %c
}

define <2 x i32> @zext_v2i10_v2i32(<2 x i10> %a) {
; CHECK-LABEL: zext_v2i10_v2i32:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    movi v1.2s, #3, msl #8
; CHECK-NEXT:    and v0.8b, v0.8b, v1.8b
; CHECK-NEXT:    ret
entry:
  %c = zext <2 x i10> %a to <2 x i32>
  ret <2 x i32> %c
}

define <2 x i64> @zext_v2i10_v2i64(<2 x i10> %a) {
; CHECK-SD-LABEL: zext_v2i10_v2i64:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    movi v1.2s, #3, msl #8
; CHECK-SD-NEXT:    and v0.8b, v0.8b, v1.8b
; CHECK-SD-NEXT:    ushll v0.2d, v0.2s, #0
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: zext_v2i10_v2i64:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    adrp x8, .LCPI18_0
; CHECK-GI-NEXT:    ushll v0.2d, v0.2s, #0
; CHECK-GI-NEXT:    ldr q1, [x8, :lo12:.LCPI18_0]
; CHECK-GI-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-GI-NEXT:    ret
entry:
  %c = zext <2 x i10> %a to <2 x i64>
  ret <2 x i64> %c
}

define <3 x i16> @zext_v3i8_v3i16(<3 x i8> %a) {
; CHECK-SD-LABEL: zext_v3i8_v3i16:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    fmov s0, w0
; CHECK-SD-NEXT:    mov v0.h[1], w1
; CHECK-SD-NEXT:    mov v0.h[2], w2
; CHECK-SD-NEXT:    bic v0.4h, #255, lsl #8
; CHECK-SD-NEXT:    // kill: def $d0 killed $d0 killed $q0
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: zext_v3i8_v3i16:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    fmov s0, w0
; CHECK-GI-NEXT:    mov w8, #255 // =0xff
; CHECK-GI-NEXT:    fmov s1, w8
; CHECK-GI-NEXT:    mov v0.s[1], w1
; CHECK-GI-NEXT:    mov v2.16b, v1.16b
; CHECK-GI-NEXT:    mov v0.s[2], w2
; CHECK-GI-NEXT:    mov v2.h[1], v1.h[0]
; CHECK-GI-NEXT:    xtn v0.4h, v0.4s
; CHECK-GI-NEXT:    mov v2.h[2], v1.h[0]
; CHECK-GI-NEXT:    and v0.8b, v0.8b, v2.8b
; CHECK-GI-NEXT:    ret
entry:
  %c = zext <3 x i8> %a to <3 x i16>
  ret <3 x i16> %c
}

define <3 x i32> @zext_v3i8_v3i32(<3 x i8> %a) {
; CHECK-SD-LABEL: zext_v3i8_v3i32:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    fmov s0, w0
; CHECK-SD-NEXT:    movi v1.2d, #0x0000ff000000ff
; CHECK-SD-NEXT:    mov v0.h[1], w1
; CHECK-SD-NEXT:    mov v0.h[2], w2
; CHECK-SD-NEXT:    ushll v0.4s, v0.4h, #0
; CHECK-SD-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: zext_v3i8_v3i32:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    mov w8, #255 // =0xff
; CHECK-GI-NEXT:    fmov s0, w0
; CHECK-GI-NEXT:    fmov s1, w8
; CHECK-GI-NEXT:    mov v0.s[1], w1
; CHECK-GI-NEXT:    mov v1.s[1], w8
; CHECK-GI-NEXT:    mov v0.s[2], w2
; CHECK-GI-NEXT:    mov v1.s[2], w8
; CHECK-GI-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-GI-NEXT:    ret
entry:
  %c = zext <3 x i8> %a to <3 x i32>
  ret <3 x i32> %c
}

define <3 x i64> @zext_v3i8_v3i64(<3 x i8> %a) {
; CHECK-SD-LABEL: zext_v3i8_v3i64:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    fmov s0, w0
; CHECK-SD-NEXT:    movi v1.2d, #0x000000000000ff
; CHECK-SD-NEXT:    fmov s3, w2
; CHECK-SD-NEXT:    movi v2.2d, #0000000000000000
; CHECK-SD-NEXT:    mov v0.s[1], w1
; CHECK-SD-NEXT:    ushll v0.2d, v0.2s, #0
; CHECK-SD-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-SD-NEXT:    ushll v1.2d, v3.2s, #0
; CHECK-SD-NEXT:    mov v2.b[0], v1.b[0]
; CHECK-SD-NEXT:    ext v1.16b, v0.16b, v0.16b, #8
; CHECK-SD-NEXT:    // kill: def $d0 killed $d0 killed $q0
; CHECK-SD-NEXT:    // kill: def $d1 killed $d1 killed $q1
; CHECK-SD-NEXT:    // kill: def $d2 killed $d2 killed $q2
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: zext_v3i8_v3i64:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    // kill: def $w0 killed $w0 def $x0
; CHECK-GI-NEXT:    fmov d1, x0
; CHECK-GI-NEXT:    // kill: def $w1 killed $w1 def $x1
; CHECK-GI-NEXT:    movi v0.2d, #0x000000000000ff
; CHECK-GI-NEXT:    // kill: def $w2 killed $w2 def $x2
; CHECK-GI-NEXT:    and x8, x2, #0xff
; CHECK-GI-NEXT:    fmov d2, x8
; CHECK-GI-NEXT:    mov v1.d[1], x1
; CHECK-GI-NEXT:    and v0.16b, v1.16b, v0.16b
; CHECK-GI-NEXT:    mov d1, v0.d[1]
; CHECK-GI-NEXT:    // kill: def $d0 killed $d0 killed $q0
; CHECK-GI-NEXT:    ret
entry:
  %c = zext <3 x i8> %a to <3 x i64>
  ret <3 x i64> %c
}

define <3 x i32> @zext_v3i16_v3i32(<3 x i16> %a) {
; CHECK-SD-LABEL: zext_v3i16_v3i32:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    ushll v0.4s, v0.4h, #0
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: zext_v3i16_v3i32:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-GI-NEXT:    umov w8, v0.h[0]
; CHECK-GI-NEXT:    umov w9, v0.h[1]
; CHECK-GI-NEXT:    fmov s1, w8
; CHECK-GI-NEXT:    umov w8, v0.h[2]
; CHECK-GI-NEXT:    mov v1.s[1], w9
; CHECK-GI-NEXT:    mov v1.s[2], w8
; CHECK-GI-NEXT:    mov v0.16b, v1.16b
; CHECK-GI-NEXT:    ret
entry:
  %c = zext <3 x i16> %a to <3 x i32>
  ret <3 x i32> %c
}

define <3 x i64> @zext_v3i16_v3i64(<3 x i16> %a) {
; CHECK-SD-LABEL: zext_v3i16_v3i64:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    ushll v2.4s, v0.4h, #0
; CHECK-SD-NEXT:    ushll v0.2d, v2.2s, #0
; CHECK-SD-NEXT:    ushll2 v2.2d, v2.4s, #0
; CHECK-SD-NEXT:    // kill: def $d2 killed $d2 killed $q2
; CHECK-SD-NEXT:    ext v1.16b, v0.16b, v0.16b, #8
; CHECK-SD-NEXT:    // kill: def $d0 killed $d0 killed $q0
; CHECK-SD-NEXT:    // kill: def $d1 killed $d1 killed $q1
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: zext_v3i16_v3i64:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-GI-NEXT:    umov w8, v0.h[0]
; CHECK-GI-NEXT:    umov w9, v0.h[1]
; CHECK-GI-NEXT:    umov w10, v0.h[2]
; CHECK-GI-NEXT:    fmov d0, x8
; CHECK-GI-NEXT:    fmov d1, x9
; CHECK-GI-NEXT:    fmov d2, x10
; CHECK-GI-NEXT:    ret
entry:
  %c = zext <3 x i16> %a to <3 x i64>
  ret <3 x i64> %c
}

define <3 x i64> @zext_v3i32_v3i64(<3 x i32> %a) {
; CHECK-SD-LABEL: zext_v3i32_v3i64:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    ushll v3.2d, v0.2s, #0
; CHECK-SD-NEXT:    ushll2 v2.2d, v0.4s, #0
; CHECK-SD-NEXT:    // kill: def $d2 killed $d2 killed $q2
; CHECK-SD-NEXT:    fmov d0, d3
; CHECK-SD-NEXT:    ext v1.16b, v3.16b, v3.16b, #8
; CHECK-SD-NEXT:    // kill: def $d1 killed $d1 killed $q1
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: zext_v3i32_v3i64:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    mov w8, v0.s[0]
; CHECK-GI-NEXT:    mov w9, v0.s[1]
; CHECK-GI-NEXT:    mov w10, v0.s[2]
; CHECK-GI-NEXT:    fmov d0, x8
; CHECK-GI-NEXT:    fmov d1, x9
; CHECK-GI-NEXT:    fmov d2, x10
; CHECK-GI-NEXT:    ret
entry:
  %c = zext <3 x i32> %a to <3 x i64>
  ret <3 x i64> %c
}

define <3 x i16> @zext_v3i10_v3i16(<3 x i10> %a) {
; CHECK-SD-LABEL: zext_v3i10_v3i16:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    fmov s0, w0
; CHECK-SD-NEXT:    mov v0.h[1], w1
; CHECK-SD-NEXT:    mov v0.h[2], w2
; CHECK-SD-NEXT:    bic v0.4h, #252, lsl #8
; CHECK-SD-NEXT:    // kill: def $d0 killed $d0 killed $q0
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: zext_v3i10_v3i16:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    fmov s0, w0
; CHECK-GI-NEXT:    mov w8, #1023 // =0x3ff
; CHECK-GI-NEXT:    fmov s1, w8
; CHECK-GI-NEXT:    mov v0.s[1], w1
; CHECK-GI-NEXT:    mov v2.16b, v1.16b
; CHECK-GI-NEXT:    mov v0.s[2], w2
; CHECK-GI-NEXT:    mov v2.h[1], v1.h[0]
; CHECK-GI-NEXT:    xtn v0.4h, v0.4s
; CHECK-GI-NEXT:    mov v2.h[2], v1.h[0]
; CHECK-GI-NEXT:    and v0.8b, v0.8b, v2.8b
; CHECK-GI-NEXT:    ret
entry:
  %c = zext <3 x i10> %a to <3 x i16>
  ret <3 x i16> %c
}

define <3 x i32> @zext_v3i10_v3i32(<3 x i10> %a) {
; CHECK-SD-LABEL: zext_v3i10_v3i32:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    fmov s0, w0
; CHECK-SD-NEXT:    movi v1.4s, #3, msl #8
; CHECK-SD-NEXT:    mov v0.h[1], w1
; CHECK-SD-NEXT:    mov v0.h[2], w2
; CHECK-SD-NEXT:    ushll v0.4s, v0.4h, #0
; CHECK-SD-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: zext_v3i10_v3i32:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    mov w8, #1023 // =0x3ff
; CHECK-GI-NEXT:    fmov s0, w0
; CHECK-GI-NEXT:    fmov s1, w8
; CHECK-GI-NEXT:    mov v0.s[1], w1
; CHECK-GI-NEXT:    mov v1.s[1], w8
; CHECK-GI-NEXT:    mov v0.s[2], w2
; CHECK-GI-NEXT:    mov v1.s[2], w8
; CHECK-GI-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-GI-NEXT:    ret
entry:
  %c = zext <3 x i10> %a to <3 x i32>
  ret <3 x i32> %c
}

define <3 x i64> @zext_v3i10_v3i64(<3 x i10> %a) {
; CHECK-SD-LABEL: zext_v3i10_v3i64:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    fmov s0, w0
; CHECK-SD-NEXT:    fmov s1, w2
; CHECK-SD-NEXT:    mov w8, #1023 // =0x3ff
; CHECK-SD-NEXT:    dup v2.2d, x8
; CHECK-SD-NEXT:    mov v0.s[1], w1
; CHECK-SD-NEXT:    ushll v3.2d, v1.2s, #0
; CHECK-SD-NEXT:    ushll v0.2d, v0.2s, #0
; CHECK-SD-NEXT:    and v0.16b, v0.16b, v2.16b
; CHECK-SD-NEXT:    and v2.8b, v3.8b, v2.8b
; CHECK-SD-NEXT:    ext v1.16b, v0.16b, v0.16b, #8
; CHECK-SD-NEXT:    // kill: def $d0 killed $d0 killed $q0
; CHECK-SD-NEXT:    // kill: def $d1 killed $d1 killed $q1
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: zext_v3i10_v3i64:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    // kill: def $w0 killed $w0 def $x0
; CHECK-GI-NEXT:    fmov d0, x0
; CHECK-GI-NEXT:    // kill: def $w1 killed $w1 def $x1
; CHECK-GI-NEXT:    adrp x8, .LCPI27_0
; CHECK-GI-NEXT:    // kill: def $w2 killed $w2 def $x2
; CHECK-GI-NEXT:    ldr q1, [x8, :lo12:.LCPI27_0]
; CHECK-GI-NEXT:    and x8, x2, #0x3ff
; CHECK-GI-NEXT:    fmov d2, x8
; CHECK-GI-NEXT:    mov v0.d[1], x1
; CHECK-GI-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-GI-NEXT:    mov d1, v0.d[1]
; CHECK-GI-NEXT:    // kill: def $d0 killed $d0 killed $q0
; CHECK-GI-NEXT:    ret
entry:
  %c = zext <3 x i10> %a to <3 x i64>
  ret <3 x i64> %c
}

define <4 x i16> @zext_v4i8_v4i16(<4 x i8> %a) {
; CHECK-SD-LABEL: zext_v4i8_v4i16:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    bic v0.4h, #255, lsl #8
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: zext_v4i8_v4i16:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    movi d1, #0xff00ff00ff00ff
; CHECK-GI-NEXT:    and v0.8b, v0.8b, v1.8b
; CHECK-GI-NEXT:    ret
entry:
  %c = zext <4 x i8> %a to <4 x i16>
  ret <4 x i16> %c
}

define <4 x i32> @zext_v4i8_v4i32(<4 x i8> %a) {
; CHECK-SD-LABEL: zext_v4i8_v4i32:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    bic v0.4h, #255, lsl #8
; CHECK-SD-NEXT:    ushll v0.4s, v0.4h, #0
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: zext_v4i8_v4i32:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    movi v1.2d, #0x0000ff000000ff
; CHECK-GI-NEXT:    ushll v0.4s, v0.4h, #0
; CHECK-GI-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-GI-NEXT:    ret
entry:
  %c = zext <4 x i8> %a to <4 x i32>
  ret <4 x i32> %c
}

define <4 x i64> @zext_v4i8_v4i64(<4 x i8> %a) {
; CHECK-SD-LABEL: zext_v4i8_v4i64:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    bic v0.4h, #255, lsl #8
; CHECK-SD-NEXT:    ushll v0.4s, v0.4h, #0
; CHECK-SD-NEXT:    ushll2 v1.2d, v0.4s, #0
; CHECK-SD-NEXT:    ushll v0.2d, v0.2s, #0
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: zext_v4i8_v4i64:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    ushll v0.4s, v0.4h, #0
; CHECK-GI-NEXT:    movi v1.2d, #0x000000000000ff
; CHECK-GI-NEXT:    ushll v2.2d, v0.2s, #0
; CHECK-GI-NEXT:    ushll2 v3.2d, v0.4s, #0
; CHECK-GI-NEXT:    and v0.16b, v2.16b, v1.16b
; CHECK-GI-NEXT:    and v1.16b, v3.16b, v1.16b
; CHECK-GI-NEXT:    ret
entry:
  %c = zext <4 x i8> %a to <4 x i64>
  ret <4 x i64> %c
}

define <4 x i32> @zext_v4i16_v4i32(<4 x i16> %a) {
; CHECK-LABEL: zext_v4i16_v4i32:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    ushll v0.4s, v0.4h, #0
; CHECK-NEXT:    ret
entry:
  %c = zext <4 x i16> %a to <4 x i32>
  ret <4 x i32> %c
}

define <4 x i64> @zext_v4i16_v4i64(<4 x i16> %a) {
; CHECK-SD-LABEL: zext_v4i16_v4i64:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    ushll v0.4s, v0.4h, #0
; CHECK-SD-NEXT:    ushll2 v1.2d, v0.4s, #0
; CHECK-SD-NEXT:    ushll v0.2d, v0.2s, #0
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: zext_v4i16_v4i64:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    ushll v1.4s, v0.4h, #0
; CHECK-GI-NEXT:    ushll v0.2d, v1.2s, #0
; CHECK-GI-NEXT:    ushll2 v1.2d, v1.4s, #0
; CHECK-GI-NEXT:    ret
entry:
  %c = zext <4 x i16> %a to <4 x i64>
  ret <4 x i64> %c
}

define <4 x i64> @zext_v4i32_v4i64(<4 x i32> %a) {
; CHECK-SD-LABEL: zext_v4i32_v4i64:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    ushll2 v1.2d, v0.4s, #0
; CHECK-SD-NEXT:    ushll v0.2d, v0.2s, #0
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: zext_v4i32_v4i64:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    ushll v2.2d, v0.2s, #0
; CHECK-GI-NEXT:    ushll2 v1.2d, v0.4s, #0
; CHECK-GI-NEXT:    mov v0.16b, v2.16b
; CHECK-GI-NEXT:    ret
entry:
  %c = zext <4 x i32> %a to <4 x i64>
  ret <4 x i64> %c
}

define <4 x i16> @zext_v4i10_v4i16(<4 x i10> %a) {
; CHECK-SD-LABEL: zext_v4i10_v4i16:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    bic v0.4h, #252, lsl #8
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: zext_v4i10_v4i16:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    mvni v1.4h, #252, lsl #8
; CHECK-GI-NEXT:    and v0.8b, v0.8b, v1.8b
; CHECK-GI-NEXT:    ret
entry:
  %c = zext <4 x i10> %a to <4 x i16>
  ret <4 x i16> %c
}

define <4 x i32> @zext_v4i10_v4i32(<4 x i10> %a) {
; CHECK-SD-LABEL: zext_v4i10_v4i32:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    bic v0.4h, #252, lsl #8
; CHECK-SD-NEXT:    ushll v0.4s, v0.4h, #0
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: zext_v4i10_v4i32:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    movi v1.4s, #3, msl #8
; CHECK-GI-NEXT:    ushll v0.4s, v0.4h, #0
; CHECK-GI-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-GI-NEXT:    ret
entry:
  %c = zext <4 x i10> %a to <4 x i32>
  ret <4 x i32> %c
}

define <4 x i64> @zext_v4i10_v4i64(<4 x i10> %a) {
; CHECK-SD-LABEL: zext_v4i10_v4i64:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    bic v0.4h, #252, lsl #8
; CHECK-SD-NEXT:    ushll v0.4s, v0.4h, #0
; CHECK-SD-NEXT:    ushll2 v1.2d, v0.4s, #0
; CHECK-SD-NEXT:    ushll v0.2d, v0.2s, #0
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: zext_v4i10_v4i64:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    ushll v0.4s, v0.4h, #0
; CHECK-GI-NEXT:    adrp x8, .LCPI36_0
; CHECK-GI-NEXT:    ldr q3, [x8, :lo12:.LCPI36_0]
; CHECK-GI-NEXT:    ushll v1.2d, v0.2s, #0
; CHECK-GI-NEXT:    ushll2 v2.2d, v0.4s, #0
; CHECK-GI-NEXT:    and v0.16b, v1.16b, v3.16b
; CHECK-GI-NEXT:    and v1.16b, v2.16b, v3.16b
; CHECK-GI-NEXT:    ret
entry:
  %c = zext <4 x i10> %a to <4 x i64>
  ret <4 x i64> %c
}

define <8 x i16> @zext_v8i8_v8i16(<8 x i8> %a) {
; CHECK-LABEL: zext_v8i8_v8i16:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    ushll v0.8h, v0.8b, #0
; CHECK-NEXT:    ret
entry:
  %c = zext <8 x i8> %a to <8 x i16>
  ret <8 x i16> %c
}

define <8 x i32> @zext_v8i8_v8i32(<8 x i8> %a) {
; CHECK-SD-LABEL: zext_v8i8_v8i32:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    ushll v0.8h, v0.8b, #0
; CHECK-SD-NEXT:    ushll2 v1.4s, v0.8h, #0
; CHECK-SD-NEXT:    ushll v0.4s, v0.4h, #0
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: zext_v8i8_v8i32:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    ushll v1.8h, v0.8b, #0
; CHECK-GI-NEXT:    ushll v0.4s, v1.4h, #0
; CHECK-GI-NEXT:    ushll2 v1.4s, v1.8h, #0
; CHECK-GI-NEXT:    ret
entry:
  %c = zext <8 x i8> %a to <8 x i32>
  ret <8 x i32> %c
}

define <8 x i64> @zext_v8i8_v8i64(<8 x i8> %a) {
; CHECK-SD-LABEL: zext_v8i8_v8i64:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    ushll v0.8h, v0.8b, #0
; CHECK-SD-NEXT:    ushll v1.4s, v0.4h, #0
; CHECK-SD-NEXT:    ushll2 v2.4s, v0.8h, #0
; CHECK-SD-NEXT:    ushll v0.2d, v1.2s, #0
; CHECK-SD-NEXT:    ushll2 v3.2d, v2.4s, #0
; CHECK-SD-NEXT:    ushll2 v1.2d, v1.4s, #0
; CHECK-SD-NEXT:    ushll v2.2d, v2.2s, #0
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: zext_v8i8_v8i64:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    ushll v0.8h, v0.8b, #0
; CHECK-GI-NEXT:    ushll v1.4s, v0.4h, #0
; CHECK-GI-NEXT:    ushll2 v3.4s, v0.8h, #0
; CHECK-GI-NEXT:    ushll v0.2d, v1.2s, #0
; CHECK-GI-NEXT:    ushll2 v1.2d, v1.4s, #0
; CHECK-GI-NEXT:    ushll v2.2d, v3.2s, #0
; CHECK-GI-NEXT:    ushll2 v3.2d, v3.4s, #0
; CHECK-GI-NEXT:    ret
entry:
  %c = zext <8 x i8> %a to <8 x i64>
  ret <8 x i64> %c
}

define <8 x i32> @zext_v8i16_v8i32(<8 x i16> %a) {
; CHECK-SD-LABEL: zext_v8i16_v8i32:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    ushll2 v1.4s, v0.8h, #0
; CHECK-SD-NEXT:    ushll v0.4s, v0.4h, #0
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: zext_v8i16_v8i32:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    ushll v2.4s, v0.4h, #0
; CHECK-GI-NEXT:    ushll2 v1.4s, v0.8h, #0
; CHECK-GI-NEXT:    mov v0.16b, v2.16b
; CHECK-GI-NEXT:    ret
entry:
  %c = zext <8 x i16> %a to <8 x i32>
  ret <8 x i32> %c
}

define <8 x i64> @zext_v8i16_v8i64(<8 x i16> %a) {
; CHECK-SD-LABEL: zext_v8i16_v8i64:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    ushll v1.4s, v0.4h, #0
; CHECK-SD-NEXT:    ushll2 v2.4s, v0.8h, #0
; CHECK-SD-NEXT:    ushll v0.2d, v1.2s, #0
; CHECK-SD-NEXT:    ushll2 v3.2d, v2.4s, #0
; CHECK-SD-NEXT:    ushll2 v1.2d, v1.4s, #0
; CHECK-SD-NEXT:    ushll v2.2d, v2.2s, #0
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: zext_v8i16_v8i64:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    ushll v1.4s, v0.4h, #0
; CHECK-GI-NEXT:    ushll2 v3.4s, v0.8h, #0
; CHECK-GI-NEXT:    ushll v0.2d, v1.2s, #0
; CHECK-GI-NEXT:    ushll2 v1.2d, v1.4s, #0
; CHECK-GI-NEXT:    ushll v2.2d, v3.2s, #0
; CHECK-GI-NEXT:    ushll2 v3.2d, v3.4s, #0
; CHECK-GI-NEXT:    ret
entry:
  %c = zext <8 x i16> %a to <8 x i64>
  ret <8 x i64> %c
}

define <8 x i64> @zext_v8i32_v8i64(<8 x i32> %a) {
; CHECK-SD-LABEL: zext_v8i32_v8i64:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    ushll v5.2d, v0.2s, #0
; CHECK-SD-NEXT:    ushll2 v4.2d, v0.4s, #0
; CHECK-SD-NEXT:    ushll2 v3.2d, v1.4s, #0
; CHECK-SD-NEXT:    ushll v2.2d, v1.2s, #0
; CHECK-SD-NEXT:    mov v0.16b, v5.16b
; CHECK-SD-NEXT:    mov v1.16b, v4.16b
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: zext_v8i32_v8i64:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    ushll v4.2d, v0.2s, #0
; CHECK-GI-NEXT:    ushll2 v5.2d, v0.4s, #0
; CHECK-GI-NEXT:    ushll v2.2d, v1.2s, #0
; CHECK-GI-NEXT:    ushll2 v3.2d, v1.4s, #0
; CHECK-GI-NEXT:    mov v0.16b, v4.16b
; CHECK-GI-NEXT:    mov v1.16b, v5.16b
; CHECK-GI-NEXT:    ret
entry:
  %c = zext <8 x i32> %a to <8 x i64>
  ret <8 x i64> %c
}

define <8 x i16> @zext_v8i10_v8i16(<8 x i10> %a) {
; CHECK-SD-LABEL: zext_v8i10_v8i16:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    bic v0.8h, #252, lsl #8
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: zext_v8i10_v8i16:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    mvni v1.8h, #252, lsl #8
; CHECK-GI-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-GI-NEXT:    ret
entry:
  %c = zext <8 x i10> %a to <8 x i16>
  ret <8 x i16> %c
}

define <8 x i32> @zext_v8i10_v8i32(<8 x i10> %a) {
; CHECK-SD-LABEL: zext_v8i10_v8i32:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    bic v0.8h, #252, lsl #8
; CHECK-SD-NEXT:    ushll2 v1.4s, v0.8h, #0
; CHECK-SD-NEXT:    ushll v0.4s, v0.4h, #0
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: zext_v8i10_v8i32:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    movi v1.4s, #3, msl #8
; CHECK-GI-NEXT:    ushll v2.4s, v0.4h, #0
; CHECK-GI-NEXT:    ushll2 v3.4s, v0.8h, #0
; CHECK-GI-NEXT:    and v0.16b, v2.16b, v1.16b
; CHECK-GI-NEXT:    and v1.16b, v3.16b, v1.16b
; CHECK-GI-NEXT:    ret
entry:
  %c = zext <8 x i10> %a to <8 x i32>
  ret <8 x i32> %c
}

define <8 x i64> @zext_v8i10_v8i64(<8 x i10> %a) {
; CHECK-SD-LABEL: zext_v8i10_v8i64:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    bic v0.8h, #252, lsl #8
; CHECK-SD-NEXT:    ushll v1.4s, v0.4h, #0
; CHECK-SD-NEXT:    ushll2 v2.4s, v0.8h, #0
; CHECK-SD-NEXT:    ushll v0.2d, v1.2s, #0
; CHECK-SD-NEXT:    ushll2 v3.2d, v2.4s, #0
; CHECK-SD-NEXT:    ushll2 v1.2d, v1.4s, #0
; CHECK-SD-NEXT:    ushll v2.2d, v2.2s, #0
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: zext_v8i10_v8i64:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    ushll v1.4s, v0.4h, #0
; CHECK-GI-NEXT:    ushll2 v0.4s, v0.8h, #0
; CHECK-GI-NEXT:    adrp x8, .LCPI45_0
; CHECK-GI-NEXT:    ldr q3, [x8, :lo12:.LCPI45_0]
; CHECK-GI-NEXT:    ushll v2.2d, v1.2s, #0
; CHECK-GI-NEXT:    ushll2 v1.2d, v1.4s, #0
; CHECK-GI-NEXT:    ushll v4.2d, v0.2s, #0
; CHECK-GI-NEXT:    ushll2 v5.2d, v0.4s, #0
; CHECK-GI-NEXT:    and v0.16b, v2.16b, v3.16b
; CHECK-GI-NEXT:    and v1.16b, v1.16b, v3.16b
; CHECK-GI-NEXT:    and v2.16b, v4.16b, v3.16b
; CHECK-GI-NEXT:    and v3.16b, v5.16b, v3.16b
; CHECK-GI-NEXT:    ret
entry:
  %c = zext <8 x i10> %a to <8 x i64>
  ret <8 x i64> %c
}

define <16 x i16> @zext_v16i8_v16i16(<16 x i8> %a) {
; CHECK-SD-LABEL: zext_v16i8_v16i16:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    ushll2 v1.8h, v0.16b, #0
; CHECK-SD-NEXT:    ushll v0.8h, v0.8b, #0
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: zext_v16i8_v16i16:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    ushll v2.8h, v0.8b, #0
; CHECK-GI-NEXT:    ushll2 v1.8h, v0.16b, #0
; CHECK-GI-NEXT:    mov v0.16b, v2.16b
; CHECK-GI-NEXT:    ret
entry:
  %c = zext <16 x i8> %a to <16 x i16>
  ret <16 x i16> %c
}

define <16 x i32> @zext_v16i8_v16i32(<16 x i8> %a) {
; CHECK-SD-LABEL: zext_v16i8_v16i32:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    ushll v1.8h, v0.8b, #0
; CHECK-SD-NEXT:    ushll2 v2.8h, v0.16b, #0
; CHECK-SD-NEXT:    ushll v0.4s, v1.4h, #0
; CHECK-SD-NEXT:    ushll2 v3.4s, v2.8h, #0
; CHECK-SD-NEXT:    ushll2 v1.4s, v1.8h, #0
; CHECK-SD-NEXT:    ushll v2.4s, v2.4h, #0
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: zext_v16i8_v16i32:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    ushll v1.8h, v0.8b, #0
; CHECK-GI-NEXT:    ushll2 v3.8h, v0.16b, #0
; CHECK-GI-NEXT:    ushll v0.4s, v1.4h, #0
; CHECK-GI-NEXT:    ushll2 v1.4s, v1.8h, #0
; CHECK-GI-NEXT:    ushll v2.4s, v3.4h, #0
; CHECK-GI-NEXT:    ushll2 v3.4s, v3.8h, #0
; CHECK-GI-NEXT:    ret
entry:
  %c = zext <16 x i8> %a to <16 x i32>
  ret <16 x i32> %c
}

define <16 x i64> @zext_v16i8_v16i64(<16 x i8> %a) {
; CHECK-SD-LABEL: zext_v16i8_v16i64:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    ushll v1.8h, v0.8b, #0
; CHECK-SD-NEXT:    ushll2 v0.8h, v0.16b, #0
; CHECK-SD-NEXT:    ushll v2.4s, v1.4h, #0
; CHECK-SD-NEXT:    ushll2 v4.4s, v1.8h, #0
; CHECK-SD-NEXT:    ushll v5.4s, v0.4h, #0
; CHECK-SD-NEXT:    ushll2 v6.4s, v0.8h, #0
; CHECK-SD-NEXT:    ushll2 v1.2d, v2.4s, #0
; CHECK-SD-NEXT:    ushll v0.2d, v2.2s, #0
; CHECK-SD-NEXT:    ushll2 v3.2d, v4.4s, #0
; CHECK-SD-NEXT:    ushll v2.2d, v4.2s, #0
; CHECK-SD-NEXT:    ushll v4.2d, v5.2s, #0
; CHECK-SD-NEXT:    ushll2 v7.2d, v6.4s, #0
; CHECK-SD-NEXT:    ushll2 v5.2d, v5.4s, #0
; CHECK-SD-NEXT:    ushll v6.2d, v6.2s, #0
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: zext_v16i8_v16i64:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    ushll v1.8h, v0.8b, #0
; CHECK-GI-NEXT:    ushll2 v0.8h, v0.16b, #0
; CHECK-GI-NEXT:    ushll v2.4s, v1.4h, #0
; CHECK-GI-NEXT:    ushll2 v3.4s, v1.8h, #0
; CHECK-GI-NEXT:    ushll v5.4s, v0.4h, #0
; CHECK-GI-NEXT:    ushll2 v7.4s, v0.8h, #0
; CHECK-GI-NEXT:    ushll v0.2d, v2.2s, #0
; CHECK-GI-NEXT:    ushll2 v1.2d, v2.4s, #0
; CHECK-GI-NEXT:    ushll v2.2d, v3.2s, #0
; CHECK-GI-NEXT:    ushll2 v3.2d, v3.4s, #0
; CHECK-GI-NEXT:    ushll v4.2d, v5.2s, #0
; CHECK-GI-NEXT:    ushll2 v5.2d, v5.4s, #0
; CHECK-GI-NEXT:    ushll v6.2d, v7.2s, #0
; CHECK-GI-NEXT:    ushll2 v7.2d, v7.4s, #0
; CHECK-GI-NEXT:    ret
entry:
  %c = zext <16 x i8> %a to <16 x i64>
  ret <16 x i64> %c
}

define <16 x i32> @zext_v16i16_v16i32(<16 x i16> %a) {
; CHECK-SD-LABEL: zext_v16i16_v16i32:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    ushll v5.4s, v0.4h, #0
; CHECK-SD-NEXT:    ushll2 v4.4s, v0.8h, #0
; CHECK-SD-NEXT:    ushll2 v3.4s, v1.8h, #0
; CHECK-SD-NEXT:    ushll v2.4s, v1.4h, #0
; CHECK-SD-NEXT:    mov v0.16b, v5.16b
; CHECK-SD-NEXT:    mov v1.16b, v4.16b
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: zext_v16i16_v16i32:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    ushll v4.4s, v0.4h, #0
; CHECK-GI-NEXT:    ushll2 v5.4s, v0.8h, #0
; CHECK-GI-NEXT:    ushll v2.4s, v1.4h, #0
; CHECK-GI-NEXT:    ushll2 v3.4s, v1.8h, #0
; CHECK-GI-NEXT:    mov v0.16b, v4.16b
; CHECK-GI-NEXT:    mov v1.16b, v5.16b
; CHECK-GI-NEXT:    ret
entry:
  %c = zext <16 x i16> %a to <16 x i32>
  ret <16 x i32> %c
}

define <16 x i64> @zext_v16i16_v16i64(<16 x i16> %a) {
; CHECK-SD-LABEL: zext_v16i16_v16i64:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    ushll v2.4s, v0.4h, #0
; CHECK-SD-NEXT:    ushll2 v4.4s, v0.8h, #0
; CHECK-SD-NEXT:    ushll v5.4s, v1.4h, #0
; CHECK-SD-NEXT:    ushll2 v6.4s, v1.8h, #0
; CHECK-SD-NEXT:    ushll2 v1.2d, v2.4s, #0
; CHECK-SD-NEXT:    ushll v0.2d, v2.2s, #0
; CHECK-SD-NEXT:    ushll2 v3.2d, v4.4s, #0
; CHECK-SD-NEXT:    ushll v2.2d, v4.2s, #0
; CHECK-SD-NEXT:    ushll v4.2d, v5.2s, #0
; CHECK-SD-NEXT:    ushll2 v7.2d, v6.4s, #0
; CHECK-SD-NEXT:    ushll2 v5.2d, v5.4s, #0
; CHECK-SD-NEXT:    ushll v6.2d, v6.2s, #0
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: zext_v16i16_v16i64:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    ushll v2.4s, v0.4h, #0
; CHECK-GI-NEXT:    ushll2 v3.4s, v0.8h, #0
; CHECK-GI-NEXT:    ushll v5.4s, v1.4h, #0
; CHECK-GI-NEXT:    ushll2 v7.4s, v1.8h, #0
; CHECK-GI-NEXT:    ushll v0.2d, v2.2s, #0
; CHECK-GI-NEXT:    ushll2 v1.2d, v2.4s, #0
; CHECK-GI-NEXT:    ushll v2.2d, v3.2s, #0
; CHECK-GI-NEXT:    ushll2 v3.2d, v3.4s, #0
; CHECK-GI-NEXT:    ushll v4.2d, v5.2s, #0
; CHECK-GI-NEXT:    ushll2 v5.2d, v5.4s, #0
; CHECK-GI-NEXT:    ushll v6.2d, v7.2s, #0
; CHECK-GI-NEXT:    ushll2 v7.2d, v7.4s, #0
; CHECK-GI-NEXT:    ret
entry:
  %c = zext <16 x i16> %a to <16 x i64>
  ret <16 x i64> %c
}

define <16 x i64> @zext_v16i32_v16i64(<16 x i32> %a) {
; CHECK-SD-LABEL: zext_v16i32_v16i64:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    ushll2 v17.2d, v0.4s, #0
; CHECK-SD-NEXT:    ushll2 v16.2d, v1.4s, #0
; CHECK-SD-NEXT:    ushll v18.2d, v1.2s, #0
; CHECK-SD-NEXT:    ushll v0.2d, v0.2s, #0
; CHECK-SD-NEXT:    ushll v4.2d, v2.2s, #0
; CHECK-SD-NEXT:    ushll2 v5.2d, v2.4s, #0
; CHECK-SD-NEXT:    ushll2 v7.2d, v3.4s, #0
; CHECK-SD-NEXT:    ushll v6.2d, v3.2s, #0
; CHECK-SD-NEXT:    mov v1.16b, v17.16b
; CHECK-SD-NEXT:    mov v2.16b, v18.16b
; CHECK-SD-NEXT:    mov v3.16b, v16.16b
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: zext_v16i32_v16i64:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    ushll v16.2d, v0.2s, #0
; CHECK-GI-NEXT:    ushll2 v17.2d, v0.4s, #0
; CHECK-GI-NEXT:    ushll v18.2d, v1.2s, #0
; CHECK-GI-NEXT:    ushll2 v19.2d, v1.4s, #0
; CHECK-GI-NEXT:    ushll v4.2d, v2.2s, #0
; CHECK-GI-NEXT:    ushll2 v5.2d, v2.4s, #0
; CHECK-GI-NEXT:    ushll v6.2d, v3.2s, #0
; CHECK-GI-NEXT:    ushll2 v7.2d, v3.4s, #0
; CHECK-GI-NEXT:    mov v0.16b, v16.16b
; CHECK-GI-NEXT:    mov v1.16b, v17.16b
; CHECK-GI-NEXT:    mov v2.16b, v18.16b
; CHECK-GI-NEXT:    mov v3.16b, v19.16b
; CHECK-GI-NEXT:    ret
entry:
  %c = zext <16 x i32> %a to <16 x i64>
  ret <16 x i64> %c
}

define <16 x i16> @zext_v16i10_v16i16(<16 x i10> %a) {
; CHECK-LABEL: zext_v16i10_v16i16:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    ldr w8, [sp]
; CHECK-NEXT:    fmov s0, w0
; CHECK-NEXT:    ldr w9, [sp, #8]
; CHECK-NEXT:    fmov s1, w8
; CHECK-NEXT:    ldr w8, [sp, #16]
; CHECK-NEXT:    mov v0.h[1], w1
; CHECK-NEXT:    mov v1.h[1], w9
; CHECK-NEXT:    mov v0.h[2], w2
; CHECK-NEXT:    mov v1.h[2], w8
; CHECK-NEXT:    ldr w8, [sp, #24]
; CHECK-NEXT:    mov v0.h[3], w3
; CHECK-NEXT:    mov v1.h[3], w8
; CHECK-NEXT:    ldr w8, [sp, #32]
; CHECK-NEXT:    mov v0.h[4], w4
; CHECK-NEXT:    mov v1.h[4], w8
; CHECK-NEXT:    ldr w8, [sp, #40]
; CHECK-NEXT:    mov v0.h[5], w5
; CHECK-NEXT:    mov v1.h[5], w8
; CHECK-NEXT:    ldr w8, [sp, #48]
; CHECK-NEXT:    mov v0.h[6], w6
; CHECK-NEXT:    mov v1.h[6], w8
; CHECK-NEXT:    ldr w8, [sp, #56]
; CHECK-NEXT:    mov v0.h[7], w7
; CHECK-NEXT:    mov v1.h[7], w8
; CHECK-NEXT:    bic v0.8h, #252, lsl #8
; CHECK-NEXT:    bic v1.8h, #252, lsl #8
; CHECK-NEXT:    ret
entry:
  %c = zext <16 x i10> %a to <16 x i16>
  ret <16 x i16> %c
}

define <16 x i32> @zext_v16i10_v16i32(<16 x i10> %a) {
; CHECK-SD-LABEL: zext_v16i10_v16i32:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    ldr w8, [sp, #32]
; CHECK-SD-NEXT:    ldr w9, [sp]
; CHECK-SD-NEXT:    fmov s0, w0
; CHECK-SD-NEXT:    fmov s1, w4
; CHECK-SD-NEXT:    ldr w10, [sp, #40]
; CHECK-SD-NEXT:    ldr w11, [sp, #8]
; CHECK-SD-NEXT:    fmov s2, w9
; CHECK-SD-NEXT:    fmov s3, w8
; CHECK-SD-NEXT:    ldr w8, [sp, #48]
; CHECK-SD-NEXT:    mov v0.h[1], w1
; CHECK-SD-NEXT:    ldr w9, [sp, #16]
; CHECK-SD-NEXT:    movi v4.4s, #3, msl #8
; CHECK-SD-NEXT:    mov v1.h[1], w5
; CHECK-SD-NEXT:    mov v2.h[1], w11
; CHECK-SD-NEXT:    mov v3.h[1], w10
; CHECK-SD-NEXT:    mov v0.h[2], w2
; CHECK-SD-NEXT:    mov v1.h[2], w6
; CHECK-SD-NEXT:    mov v2.h[2], w9
; CHECK-SD-NEXT:    mov v3.h[2], w8
; CHECK-SD-NEXT:    ldr w8, [sp, #56]
; CHECK-SD-NEXT:    ldr w9, [sp, #24]
; CHECK-SD-NEXT:    mov v0.h[3], w3
; CHECK-SD-NEXT:    mov v1.h[3], w7
; CHECK-SD-NEXT:    mov v2.h[3], w9
; CHECK-SD-NEXT:    mov v3.h[3], w8
; CHECK-SD-NEXT:    ushll v0.4s, v0.4h, #0
; CHECK-SD-NEXT:    ushll v1.4s, v1.4h, #0
; CHECK-SD-NEXT:    ushll v2.4s, v2.4h, #0
; CHECK-SD-NEXT:    ushll v3.4s, v3.4h, #0
; CHECK-SD-NEXT:    and v0.16b, v0.16b, v4.16b
; CHECK-SD-NEXT:    and v1.16b, v1.16b, v4.16b
; CHECK-SD-NEXT:    and v2.16b, v2.16b, v4.16b
; CHECK-SD-NEXT:    and v3.16b, v3.16b, v4.16b
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: zext_v16i10_v16i32:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    fmov s4, w0
; CHECK-GI-NEXT:    fmov s5, w4
; CHECK-GI-NEXT:    ldr s2, [sp]
; CHECK-GI-NEXT:    ldr s0, [sp, #8]
; CHECK-GI-NEXT:    ldr s3, [sp, #32]
; CHECK-GI-NEXT:    ldr s1, [sp, #40]
; CHECK-GI-NEXT:    movi v6.4s, #3, msl #8
; CHECK-GI-NEXT:    mov v4.s[1], w1
; CHECK-GI-NEXT:    mov v5.s[1], w5
; CHECK-GI-NEXT:    mov v2.s[1], v0.s[0]
; CHECK-GI-NEXT:    mov v3.s[1], v1.s[0]
; CHECK-GI-NEXT:    ldr s0, [sp, #16]
; CHECK-GI-NEXT:    ldr s1, [sp, #48]
; CHECK-GI-NEXT:    mov v4.s[2], w2
; CHECK-GI-NEXT:    mov v5.s[2], w6
; CHECK-GI-NEXT:    mov v2.s[2], v0.s[0]
; CHECK-GI-NEXT:    mov v3.s[2], v1.s[0]
; CHECK-GI-NEXT:    ldr s0, [sp, #24]
; CHECK-GI-NEXT:    ldr s1, [sp, #56]
; CHECK-GI-NEXT:    mov v4.s[3], w3
; CHECK-GI-NEXT:    mov v5.s[3], w7
; CHECK-GI-NEXT:    mov v2.s[3], v0.s[0]
; CHECK-GI-NEXT:    mov v3.s[3], v1.s[0]
; CHECK-GI-NEXT:    and v0.16b, v4.16b, v6.16b
; CHECK-GI-NEXT:    and v1.16b, v5.16b, v6.16b
; CHECK-GI-NEXT:    and v2.16b, v2.16b, v6.16b
; CHECK-GI-NEXT:    and v3.16b, v3.16b, v6.16b
; CHECK-GI-NEXT:    ret
entry:
  %c = zext <16 x i10> %a to <16 x i32>
  ret <16 x i32> %c
}

define <16 x i64> @zext_v16i10_v16i64(<16 x i10> %a) {
; CHECK-SD-LABEL: zext_v16i10_v16i64:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    fmov s0, w2
; CHECK-SD-NEXT:    fmov s1, w0
; CHECK-SD-NEXT:    ldr s2, [sp]
; CHECK-SD-NEXT:    fmov s3, w4
; CHECK-SD-NEXT:    fmov s4, w6
; CHECK-SD-NEXT:    add x9, sp, #8
; CHECK-SD-NEXT:    ldr s5, [sp, #16]
; CHECK-SD-NEXT:    ldr s6, [sp, #32]
; CHECK-SD-NEXT:    ldr s7, [sp, #48]
; CHECK-SD-NEXT:    mov v1.s[1], w1
; CHECK-SD-NEXT:    mov v0.s[1], w3
; CHECK-SD-NEXT:    ld1 { v2.s }[1], [x9]
; CHECK-SD-NEXT:    mov v3.s[1], w5
; CHECK-SD-NEXT:    mov v4.s[1], w7
; CHECK-SD-NEXT:    add x9, sp, #24
; CHECK-SD-NEXT:    add x10, sp, #40
; CHECK-SD-NEXT:    add x11, sp, #56
; CHECK-SD-NEXT:    ld1 { v5.s }[1], [x9]
; CHECK-SD-NEXT:    ld1 { v6.s }[1], [x10]
; CHECK-SD-NEXT:    ld1 { v7.s }[1], [x11]
; CHECK-SD-NEXT:    mov w8, #1023 // =0x3ff
; CHECK-SD-NEXT:    ushll v1.2d, v1.2s, #0
; CHECK-SD-NEXT:    dup v16.2d, x8
; CHECK-SD-NEXT:    ushll v17.2d, v0.2s, #0
; CHECK-SD-NEXT:    ushll v3.2d, v3.2s, #0
; CHECK-SD-NEXT:    ushll v4.2d, v4.2s, #0
; CHECK-SD-NEXT:    ushll v18.2d, v2.2s, #0
; CHECK-SD-NEXT:    ushll v5.2d, v5.2s, #0
; CHECK-SD-NEXT:    ushll v6.2d, v6.2s, #0
; CHECK-SD-NEXT:    ushll v7.2d, v7.2s, #0
; CHECK-SD-NEXT:    and v0.16b, v1.16b, v16.16b
; CHECK-SD-NEXT:    and v1.16b, v17.16b, v16.16b
; CHECK-SD-NEXT:    and v2.16b, v3.16b, v16.16b
; CHECK-SD-NEXT:    and v3.16b, v4.16b, v16.16b
; CHECK-SD-NEXT:    and v4.16b, v18.16b, v16.16b
; CHECK-SD-NEXT:    and v5.16b, v5.16b, v16.16b
; CHECK-SD-NEXT:    and v6.16b, v6.16b, v16.16b
; CHECK-SD-NEXT:    and v7.16b, v7.16b, v16.16b
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: zext_v16i10_v16i64:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    fmov s16, w0
; CHECK-GI-NEXT:    fmov s17, w2
; CHECK-GI-NEXT:    ldr s0, [sp]
; CHECK-GI-NEXT:    fmov s18, w4
; CHECK-GI-NEXT:    fmov s19, w6
; CHECK-GI-NEXT:    ldr s1, [sp, #8]
; CHECK-GI-NEXT:    ldr s2, [sp, #16]
; CHECK-GI-NEXT:    ldr s3, [sp, #24]
; CHECK-GI-NEXT:    ldr s4, [sp, #32]
; CHECK-GI-NEXT:    ldr s5, [sp, #40]
; CHECK-GI-NEXT:    ldr s6, [sp, #48]
; CHECK-GI-NEXT:    ldr s7, [sp, #56]
; CHECK-GI-NEXT:    mov v16.s[1], w1
; CHECK-GI-NEXT:    mov v17.s[1], w3
; CHECK-GI-NEXT:    mov v18.s[1], w5
; CHECK-GI-NEXT:    mov v19.s[1], w7
; CHECK-GI-NEXT:    mov v0.s[1], v1.s[0]
; CHECK-GI-NEXT:    mov v2.s[1], v3.s[0]
; CHECK-GI-NEXT:    mov v4.s[1], v5.s[0]
; CHECK-GI-NEXT:    mov v6.s[1], v7.s[0]
; CHECK-GI-NEXT:    adrp x8, .LCPI54_0
; CHECK-GI-NEXT:    ushll v1.2d, v16.2s, #0
; CHECK-GI-NEXT:    ushll v3.2d, v17.2s, #0
; CHECK-GI-NEXT:    ushll v5.2d, v18.2s, #0
; CHECK-GI-NEXT:    ushll v7.2d, v19.2s, #0
; CHECK-GI-NEXT:    ushll v16.2d, v0.2s, #0
; CHECK-GI-NEXT:    ushll v18.2d, v2.2s, #0
; CHECK-GI-NEXT:    ushll v19.2d, v4.2s, #0
; CHECK-GI-NEXT:    ushll v20.2d, v6.2s, #0
; CHECK-GI-NEXT:    ldr q17, [x8, :lo12:.LCPI54_0]
; CHECK-GI-NEXT:    and v0.16b, v1.16b, v17.16b
; CHECK-GI-NEXT:    and v1.16b, v3.16b, v17.16b
; CHECK-GI-NEXT:    and v2.16b, v5.16b, v17.16b
; CHECK-GI-NEXT:    and v3.16b, v7.16b, v17.16b
; CHECK-GI-NEXT:    and v4.16b, v16.16b, v17.16b
; CHECK-GI-NEXT:    and v5.16b, v18.16b, v17.16b
; CHECK-GI-NEXT:    and v6.16b, v19.16b, v17.16b
; CHECK-GI-NEXT:    and v7.16b, v20.16b, v17.16b
; CHECK-GI-NEXT:    ret
entry:
  %c = zext <16 x i10> %a to <16 x i64>
  ret <16 x i64> %c
}
