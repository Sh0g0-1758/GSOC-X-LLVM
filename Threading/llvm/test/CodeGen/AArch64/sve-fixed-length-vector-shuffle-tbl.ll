; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mattr=+sve2 -force-streaming-compatible-sve -aarch64-sve-vector-bits-min=128 -aarch64-sve-vector-bits-max=128  < %s | FileCheck %s -check-prefixes=CHECK,SVE2_128
; RUN: llc -mattr=+sve2 -force-streaming-compatible-sve -aarch64-sve-vector-bits-min=128 < %s | FileCheck %s -check-prefixes=CHECK,SVE2_128_NOMAX
; RUN: llc -mattr=+sve2 -force-streaming-compatible-sve < %s | FileCheck %s -check-prefixes=CHECK,SVE2_NOMIN_NOMAX
; RUN: llc -mattr=+sve2 -force-streaming-compatible-sve -aarch64-sve-vector-bits-min=256 < %s | FileCheck %s -check-prefixes=CHECK,SVE2_MIN_256_NOMAX

target triple = "aarch64-unknown-linux-gnu"

; SVE2_128: .LCPI0_0:
; SVE2_128-NEXT:        .byte   0                               // 0x0
; SVE2_128-NEXT:        .byte   7                               // 0x7
; SVE2_128-NEXT:        .byte   2                               // 0x2
; SVE2_128-NEXT:        .byte   3                               // 0x3
; SVE2_128-NEXT:        .byte   4                               // 0x4
; SVE2_128-NEXT:        .byte   5                               // 0x5
; SVE2_128-NEXT:        .byte   6                               // 0x6
; SVE2_128-NEXT:        .byte   7                               // 0x7
; SVE2_128-NEXT:        .byte   255                             // 0xff
; SVE2_128-NEXT:        .byte   255                             // 0xff
define <8 x i8> @shuffle_index_indices_from_op1(ptr %a, ptr %b) {
; SVE2_128-LABEL: shuffle_index_indices_from_op1:
; SVE2_128:       // %bb.0:
; SVE2_128-NEXT:    adrp x8, .LCPI0_0
; SVE2_128-NEXT:    ldr d0, [x0]
; SVE2_128-NEXT:    ldr q1, [x8, :lo12:.LCPI0_0]
; SVE2_128-NEXT:    tbl z0.b, { z0.b }, z1.b
; SVE2_128-NEXT:    // kill: def $d0 killed $d0 killed $z0
; SVE2_128-NEXT:    ret
;
; SVE2_128_NOMAX-LABEL: shuffle_index_indices_from_op1:
; SVE2_128_NOMAX:       // %bb.0:
; SVE2_128_NOMAX-NEXT:    adrp x8, .LCPI0_0
; SVE2_128_NOMAX-NEXT:    ldr d0, [x0]
; SVE2_128_NOMAX-NEXT:    ldr q1, [x8, :lo12:.LCPI0_0]
; SVE2_128_NOMAX-NEXT:    tbl z0.b, { z0.b }, z1.b
; SVE2_128_NOMAX-NEXT:    // kill: def $d0 killed $d0 killed $z0
; SVE2_128_NOMAX-NEXT:    ret
;
; SVE2_NOMIN_NOMAX-LABEL: shuffle_index_indices_from_op1:
; SVE2_NOMIN_NOMAX:       // %bb.0:
; SVE2_NOMIN_NOMAX-NEXT:    adrp x8, .LCPI0_0
; SVE2_NOMIN_NOMAX-NEXT:    ldr d0, [x0]
; SVE2_NOMIN_NOMAX-NEXT:    ldr q1, [x8, :lo12:.LCPI0_0]
; SVE2_NOMIN_NOMAX-NEXT:    tbl z0.b, { z0.b }, z1.b
; SVE2_NOMIN_NOMAX-NEXT:    // kill: def $d0 killed $d0 killed $z0
; SVE2_NOMIN_NOMAX-NEXT:    ret
;
; SVE2_MIN_256_NOMAX-LABEL: shuffle_index_indices_from_op1:
; SVE2_MIN_256_NOMAX:       // %bb.0:
; SVE2_MIN_256_NOMAX-NEXT:    ptrue p0.b, vl32
; SVE2_MIN_256_NOMAX-NEXT:    adrp x8, .LCPI0_0
; SVE2_MIN_256_NOMAX-NEXT:    add x8, x8, :lo12:.LCPI0_0
; SVE2_MIN_256_NOMAX-NEXT:    ldr d1, [x0]
; SVE2_MIN_256_NOMAX-NEXT:    ld1b { z0.b }, p0/z, [x8]
; SVE2_MIN_256_NOMAX-NEXT:    tbl z0.b, { z1.b }, z0.b
; SVE2_MIN_256_NOMAX-NEXT:    // kill: def $d0 killed $d0 killed $z0
; SVE2_MIN_256_NOMAX-NEXT:    ret
  %op1 = load <8 x i8>, ptr %a
  %op2 = load <8 x i8>, ptr %b
  %1 = shufflevector <8 x i8> %op1, <8 x i8> %op2, <8 x i32> <i32 0, i32 7, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  ret <8 x i8> %1
}

; SVE2_128: .LCPI1_0:
; SVE2_128-NEXT:        .byte   0                               // 0x0
; SVE2_128-NEXT:        .byte   1                               // 0x1
; SVE2_128-NEXT:        .byte   1                               // 0x1
; SVE2_128-NEXT:        .byte   3                               // 0x3
; SVE2_128-NEXT:        .byte   4                               // 0x4
; SVE2_128-NEXT:        .byte   7                               // 0x7
; SVE2_128-NEXT:        .byte   6                               // 0x6
; SVE2_128-NEXT:        .byte   7                               // 0x7
; SVE2_128-NEXT:        .byte   255                             // 0xff
; SVE2_128-NEXT:        .byte   255                             // 0xff
define <8 x i8> @shuffle_index_indices_from_op2(ptr %a, ptr %b) {
; SVE2_128-LABEL: shuffle_index_indices_from_op2:
; SVE2_128:       // %bb.0:
; SVE2_128-NEXT:    adrp x8, .LCPI1_0
; SVE2_128-NEXT:    ldr d0, [x1]
; SVE2_128-NEXT:    ldr q1, [x8, :lo12:.LCPI1_0]
; SVE2_128-NEXT:    tbl z0.b, { z0.b }, z1.b
; SVE2_128-NEXT:    // kill: def $d0 killed $d0 killed $z0
; SVE2_128-NEXT:    ret
;
; SVE2_128_NOMAX-LABEL: shuffle_index_indices_from_op2:
; SVE2_128_NOMAX:       // %bb.0:
; SVE2_128_NOMAX-NEXT:    adrp x8, .LCPI1_0
; SVE2_128_NOMAX-NEXT:    ldr d0, [x1]
; SVE2_128_NOMAX-NEXT:    ldr q1, [x8, :lo12:.LCPI1_0]
; SVE2_128_NOMAX-NEXT:    tbl z0.b, { z0.b }, z1.b
; SVE2_128_NOMAX-NEXT:    // kill: def $d0 killed $d0 killed $z0
; SVE2_128_NOMAX-NEXT:    ret
;
; SVE2_NOMIN_NOMAX-LABEL: shuffle_index_indices_from_op2:
; SVE2_NOMIN_NOMAX:       // %bb.0:
; SVE2_NOMIN_NOMAX-NEXT:    adrp x8, .LCPI1_0
; SVE2_NOMIN_NOMAX-NEXT:    ldr d0, [x1]
; SVE2_NOMIN_NOMAX-NEXT:    ldr q1, [x8, :lo12:.LCPI1_0]
; SVE2_NOMIN_NOMAX-NEXT:    tbl z0.b, { z0.b }, z1.b
; SVE2_NOMIN_NOMAX-NEXT:    // kill: def $d0 killed $d0 killed $z0
; SVE2_NOMIN_NOMAX-NEXT:    ret
;
; SVE2_MIN_256_NOMAX-LABEL: shuffle_index_indices_from_op2:
; SVE2_MIN_256_NOMAX:       // %bb.0:
; SVE2_MIN_256_NOMAX-NEXT:    ptrue p0.b, vl32
; SVE2_MIN_256_NOMAX-NEXT:    adrp x8, .LCPI1_0
; SVE2_MIN_256_NOMAX-NEXT:    add x8, x8, :lo12:.LCPI1_0
; SVE2_MIN_256_NOMAX-NEXT:    ldr d1, [x1]
; SVE2_MIN_256_NOMAX-NEXT:    ld1b { z0.b }, p0/z, [x8]
; SVE2_MIN_256_NOMAX-NEXT:    tbl z0.b, { z1.b }, z0.b
; SVE2_MIN_256_NOMAX-NEXT:    // kill: def $d0 killed $d0 killed $z0
; SVE2_MIN_256_NOMAX-NEXT:    ret
  %op1 = load <8 x i8>, ptr %a
  %op2 = load <8 x i8>, ptr %b
  %1 = shufflevector <8 x i8> %op1, <8 x i8> %op2, <8 x i32> <i32 8, i32 9, i32 9, i32 11, i32 12, i32 15, i32 14, i32 15>
  ret <8 x i8> %1
}

; SVE2_128: .LCPI2_0:
; SVE2_128-NEXT:        .byte   1                               // 0x1
; SVE2_128-NEXT:        .byte   17                              // 0x11
; SVE2_128-NEXT:        .byte   18                              // 0x12
; SVE2_128-NEXT:        .byte   19                              // 0x13
; SVE2_128-NEXT:        .byte   20                              // 0x14
; SVE2_128-NEXT:        .byte   20                              // 0x14
; SVE2_128-NEXT:        .byte   22                              // 0x16
; SVE2_128-NEXT:        .byte   23                              // 0x17
; SVE2_128-NEXT:        .byte   255                             // 0xff
; SVE2_128-NEXT:        .byte   255                             // 0xff
define <8 x i8> @shuffle_index_indices_from_both_ops(ptr %a, ptr %b) {
; SVE2_128-LABEL: shuffle_index_indices_from_both_ops:
; SVE2_128:       // %bb.0:
; SVE2_128-NEXT:    adrp x8, .LCPI2_0
; SVE2_128-NEXT:    ldr d0, [x0]
; SVE2_128-NEXT:    ldr d1, [x1]
; SVE2_128-NEXT:    ldr q2, [x8, :lo12:.LCPI2_0]
; SVE2_128-NEXT:    tbl z0.b, { z0.b, z1.b }, z2.b
; SVE2_128-NEXT:    // kill: def $d0 killed $d0 killed $z0
; SVE2_128-NEXT:    ret
;
; SVE2_128_NOMAX-LABEL: shuffle_index_indices_from_both_ops:
; SVE2_128_NOMAX:       // %bb.0:
; SVE2_128_NOMAX-NEXT:    sub sp, sp, #16
; SVE2_128_NOMAX-NEXT:    .cfi_def_cfa_offset 16
; SVE2_128_NOMAX-NEXT:    ldr d0, [x1]
; SVE2_128_NOMAX-NEXT:    mov z1.b, z0.b[7]
; SVE2_128_NOMAX-NEXT:    mov z2.b, z0.b[6]
; SVE2_128_NOMAX-NEXT:    mov z3.b, z0.b[4]
; SVE2_128_NOMAX-NEXT:    fmov w8, s1
; SVE2_128_NOMAX-NEXT:    ldr d1, [x0]
; SVE2_128_NOMAX-NEXT:    fmov w9, s2
; SVE2_128_NOMAX-NEXT:    mov z2.b, z0.b[3]
; SVE2_128_NOMAX-NEXT:    mov z1.b, z1.b[1]
; SVE2_128_NOMAX-NEXT:    strb w8, [sp, #15]
; SVE2_128_NOMAX-NEXT:    fmov w8, s3
; SVE2_128_NOMAX-NEXT:    mov z3.b, z0.b[2]
; SVE2_128_NOMAX-NEXT:    strb w9, [sp, #14]
; SVE2_128_NOMAX-NEXT:    mov z0.b, z0.b[1]
; SVE2_128_NOMAX-NEXT:    fmov w9, s2
; SVE2_128_NOMAX-NEXT:    strb w8, [sp, #13]
; SVE2_128_NOMAX-NEXT:    strb w8, [sp, #12]
; SVE2_128_NOMAX-NEXT:    fmov w8, s3
; SVE2_128_NOMAX-NEXT:    strb w9, [sp, #11]
; SVE2_128_NOMAX-NEXT:    fmov w9, s0
; SVE2_128_NOMAX-NEXT:    strb w8, [sp, #10]
; SVE2_128_NOMAX-NEXT:    fmov w8, s1
; SVE2_128_NOMAX-NEXT:    strb w9, [sp, #9]
; SVE2_128_NOMAX-NEXT:    strb w8, [sp, #8]
; SVE2_128_NOMAX-NEXT:    ldr d0, [sp, #8]
; SVE2_128_NOMAX-NEXT:    add sp, sp, #16
; SVE2_128_NOMAX-NEXT:    ret
;
; SVE2_NOMIN_NOMAX-LABEL: shuffle_index_indices_from_both_ops:
; SVE2_NOMIN_NOMAX:       // %bb.0:
; SVE2_NOMIN_NOMAX-NEXT:    sub sp, sp, #16
; SVE2_NOMIN_NOMAX-NEXT:    .cfi_def_cfa_offset 16
; SVE2_NOMIN_NOMAX-NEXT:    ldr d0, [x1]
; SVE2_NOMIN_NOMAX-NEXT:    mov z1.b, z0.b[7]
; SVE2_NOMIN_NOMAX-NEXT:    mov z2.b, z0.b[6]
; SVE2_NOMIN_NOMAX-NEXT:    mov z3.b, z0.b[4]
; SVE2_NOMIN_NOMAX-NEXT:    fmov w8, s1
; SVE2_NOMIN_NOMAX-NEXT:    ldr d1, [x0]
; SVE2_NOMIN_NOMAX-NEXT:    fmov w9, s2
; SVE2_NOMIN_NOMAX-NEXT:    mov z2.b, z0.b[3]
; SVE2_NOMIN_NOMAX-NEXT:    mov z1.b, z1.b[1]
; SVE2_NOMIN_NOMAX-NEXT:    strb w8, [sp, #15]
; SVE2_NOMIN_NOMAX-NEXT:    fmov w8, s3
; SVE2_NOMIN_NOMAX-NEXT:    mov z3.b, z0.b[2]
; SVE2_NOMIN_NOMAX-NEXT:    strb w9, [sp, #14]
; SVE2_NOMIN_NOMAX-NEXT:    mov z0.b, z0.b[1]
; SVE2_NOMIN_NOMAX-NEXT:    fmov w9, s2
; SVE2_NOMIN_NOMAX-NEXT:    strb w8, [sp, #13]
; SVE2_NOMIN_NOMAX-NEXT:    strb w8, [sp, #12]
; SVE2_NOMIN_NOMAX-NEXT:    fmov w8, s3
; SVE2_NOMIN_NOMAX-NEXT:    strb w9, [sp, #11]
; SVE2_NOMIN_NOMAX-NEXT:    fmov w9, s0
; SVE2_NOMIN_NOMAX-NEXT:    strb w8, [sp, #10]
; SVE2_NOMIN_NOMAX-NEXT:    fmov w8, s1
; SVE2_NOMIN_NOMAX-NEXT:    strb w9, [sp, #9]
; SVE2_NOMIN_NOMAX-NEXT:    strb w8, [sp, #8]
; SVE2_NOMIN_NOMAX-NEXT:    ldr d0, [sp, #8]
; SVE2_NOMIN_NOMAX-NEXT:    add sp, sp, #16
; SVE2_NOMIN_NOMAX-NEXT:    ret
;
; SVE2_MIN_256_NOMAX-LABEL: shuffle_index_indices_from_both_ops:
; SVE2_MIN_256_NOMAX:       // %bb.0:
; SVE2_MIN_256_NOMAX-NEXT:    sub sp, sp, #16
; SVE2_MIN_256_NOMAX-NEXT:    .cfi_def_cfa_offset 16
; SVE2_MIN_256_NOMAX-NEXT:    ldr d0, [x1]
; SVE2_MIN_256_NOMAX-NEXT:    mov z1.b, z0.b[7]
; SVE2_MIN_256_NOMAX-NEXT:    mov z2.b, z0.b[6]
; SVE2_MIN_256_NOMAX-NEXT:    mov z3.b, z0.b[4]
; SVE2_MIN_256_NOMAX-NEXT:    fmov w8, s1
; SVE2_MIN_256_NOMAX-NEXT:    ldr d1, [x0]
; SVE2_MIN_256_NOMAX-NEXT:    fmov w9, s2
; SVE2_MIN_256_NOMAX-NEXT:    mov z2.b, z0.b[3]
; SVE2_MIN_256_NOMAX-NEXT:    mov z1.b, z1.b[1]
; SVE2_MIN_256_NOMAX-NEXT:    strb w8, [sp, #15]
; SVE2_MIN_256_NOMAX-NEXT:    fmov w8, s3
; SVE2_MIN_256_NOMAX-NEXT:    mov z3.b, z0.b[2]
; SVE2_MIN_256_NOMAX-NEXT:    strb w9, [sp, #14]
; SVE2_MIN_256_NOMAX-NEXT:    mov z0.b, z0.b[1]
; SVE2_MIN_256_NOMAX-NEXT:    fmov w9, s2
; SVE2_MIN_256_NOMAX-NEXT:    strb w8, [sp, #13]
; SVE2_MIN_256_NOMAX-NEXT:    strb w8, [sp, #12]
; SVE2_MIN_256_NOMAX-NEXT:    fmov w8, s3
; SVE2_MIN_256_NOMAX-NEXT:    strb w9, [sp, #11]
; SVE2_MIN_256_NOMAX-NEXT:    fmov w9, s0
; SVE2_MIN_256_NOMAX-NEXT:    strb w8, [sp, #10]
; SVE2_MIN_256_NOMAX-NEXT:    fmov w8, s1
; SVE2_MIN_256_NOMAX-NEXT:    strb w9, [sp, #9]
; SVE2_MIN_256_NOMAX-NEXT:    strb w8, [sp, #8]
; SVE2_MIN_256_NOMAX-NEXT:    ldr d0, [sp, #8]
; SVE2_MIN_256_NOMAX-NEXT:    add sp, sp, #16
; SVE2_MIN_256_NOMAX-NEXT:    ret
  %op1 = load <8 x i8>, ptr %a
  %op2 = load <8 x i8>, ptr %b
  %1 = shufflevector <8 x i8> %op1, <8 x i8> %op2, <8 x i32> <i32 1, i32 9, i32 10, i32 11, i32 12, i32 12, i32 14, i32 15>
  ret <8 x i8> %1
}

; SVE2_128: .LCPI3_0:
; SVE2_128-NEXT:        .byte   1                               // 0x1
; SVE2_128-NEXT:        .byte   17                              // 0x11
; SVE2_128-NEXT:        .byte   18                              // 0x12
; SVE2_128-NEXT:        .byte   19                              // 0x13
; SVE2_128-NEXT:        .byte   20                              // 0x14
; SVE2_128-NEXT:        .byte   20                              // 0x14
; SVE2_128-NEXT:        .byte   22                              // 0x16
; SVE2_128-NEXT:        .byte   0                               // 0x0
; SVE2_128-NEXT:        .byte   255                             // 0xff
; SVE2_128-NEXT:        .byte   255                             // 0xff
define <8 x i8> @shuffle_index_poison_value(ptr %a, ptr %b) {
; SVE2_128-LABEL: shuffle_index_poison_value:
; SVE2_128:       // %bb.0:
; SVE2_128-NEXT:    adrp x8, .LCPI3_0
; SVE2_128-NEXT:    ldr d0, [x0]
; SVE2_128-NEXT:    ldr d1, [x1]
; SVE2_128-NEXT:    ldr q2, [x8, :lo12:.LCPI3_0]
; SVE2_128-NEXT:    tbl z0.b, { z0.b, z1.b }, z2.b
; SVE2_128-NEXT:    // kill: def $d0 killed $d0 killed $z0
; SVE2_128-NEXT:    ret
;
; SVE2_128_NOMAX-LABEL: shuffle_index_poison_value:
; SVE2_128_NOMAX:       // %bb.0:
; SVE2_128_NOMAX-NEXT:    sub sp, sp, #16
; SVE2_128_NOMAX-NEXT:    .cfi_def_cfa_offset 16
; SVE2_128_NOMAX-NEXT:    ldr d0, [x1]
; SVE2_128_NOMAX-NEXT:    ldr d3, [x0]
; SVE2_128_NOMAX-NEXT:    mov z1.b, z0.b[6]
; SVE2_128_NOMAX-NEXT:    mov z2.b, z0.b[4]
; SVE2_128_NOMAX-NEXT:    fmov w8, s1
; SVE2_128_NOMAX-NEXT:    mov z1.b, z0.b[3]
; SVE2_128_NOMAX-NEXT:    fmov w9, s2
; SVE2_128_NOMAX-NEXT:    mov z2.b, z0.b[2]
; SVE2_128_NOMAX-NEXT:    mov z0.b, z0.b[1]
; SVE2_128_NOMAX-NEXT:    strb w8, [sp, #14]
; SVE2_128_NOMAX-NEXT:    fmov w8, s1
; SVE2_128_NOMAX-NEXT:    mov z1.b, z3.b[1]
; SVE2_128_NOMAX-NEXT:    strb w9, [sp, #13]
; SVE2_128_NOMAX-NEXT:    strb w9, [sp, #12]
; SVE2_128_NOMAX-NEXT:    fmov w9, s2
; SVE2_128_NOMAX-NEXT:    strb w8, [sp, #11]
; SVE2_128_NOMAX-NEXT:    fmov w8, s0
; SVE2_128_NOMAX-NEXT:    strb w9, [sp, #10]
; SVE2_128_NOMAX-NEXT:    fmov w9, s1
; SVE2_128_NOMAX-NEXT:    strb w8, [sp, #9]
; SVE2_128_NOMAX-NEXT:    strb w9, [sp, #8]
; SVE2_128_NOMAX-NEXT:    ldr d0, [sp, #8]
; SVE2_128_NOMAX-NEXT:    add sp, sp, #16
; SVE2_128_NOMAX-NEXT:    ret
;
; SVE2_NOMIN_NOMAX-LABEL: shuffle_index_poison_value:
; SVE2_NOMIN_NOMAX:       // %bb.0:
; SVE2_NOMIN_NOMAX-NEXT:    sub sp, sp, #16
; SVE2_NOMIN_NOMAX-NEXT:    .cfi_def_cfa_offset 16
; SVE2_NOMIN_NOMAX-NEXT:    ldr d0, [x1]
; SVE2_NOMIN_NOMAX-NEXT:    ldr d3, [x0]
; SVE2_NOMIN_NOMAX-NEXT:    mov z1.b, z0.b[6]
; SVE2_NOMIN_NOMAX-NEXT:    mov z2.b, z0.b[4]
; SVE2_NOMIN_NOMAX-NEXT:    fmov w8, s1
; SVE2_NOMIN_NOMAX-NEXT:    mov z1.b, z0.b[3]
; SVE2_NOMIN_NOMAX-NEXT:    fmov w9, s2
; SVE2_NOMIN_NOMAX-NEXT:    mov z2.b, z0.b[2]
; SVE2_NOMIN_NOMAX-NEXT:    mov z0.b, z0.b[1]
; SVE2_NOMIN_NOMAX-NEXT:    strb w8, [sp, #14]
; SVE2_NOMIN_NOMAX-NEXT:    fmov w8, s1
; SVE2_NOMIN_NOMAX-NEXT:    mov z1.b, z3.b[1]
; SVE2_NOMIN_NOMAX-NEXT:    strb w9, [sp, #13]
; SVE2_NOMIN_NOMAX-NEXT:    strb w9, [sp, #12]
; SVE2_NOMIN_NOMAX-NEXT:    fmov w9, s2
; SVE2_NOMIN_NOMAX-NEXT:    strb w8, [sp, #11]
; SVE2_NOMIN_NOMAX-NEXT:    fmov w8, s0
; SVE2_NOMIN_NOMAX-NEXT:    strb w9, [sp, #10]
; SVE2_NOMIN_NOMAX-NEXT:    fmov w9, s1
; SVE2_NOMIN_NOMAX-NEXT:    strb w8, [sp, #9]
; SVE2_NOMIN_NOMAX-NEXT:    strb w9, [sp, #8]
; SVE2_NOMIN_NOMAX-NEXT:    ldr d0, [sp, #8]
; SVE2_NOMIN_NOMAX-NEXT:    add sp, sp, #16
; SVE2_NOMIN_NOMAX-NEXT:    ret
;
; SVE2_MIN_256_NOMAX-LABEL: shuffle_index_poison_value:
; SVE2_MIN_256_NOMAX:       // %bb.0:
; SVE2_MIN_256_NOMAX-NEXT:    sub sp, sp, #16
; SVE2_MIN_256_NOMAX-NEXT:    .cfi_def_cfa_offset 16
; SVE2_MIN_256_NOMAX-NEXT:    ldr d0, [x1]
; SVE2_MIN_256_NOMAX-NEXT:    ldr d3, [x0]
; SVE2_MIN_256_NOMAX-NEXT:    mov z1.b, z0.b[6]
; SVE2_MIN_256_NOMAX-NEXT:    mov z2.b, z0.b[4]
; SVE2_MIN_256_NOMAX-NEXT:    fmov w8, s1
; SVE2_MIN_256_NOMAX-NEXT:    mov z1.b, z0.b[3]
; SVE2_MIN_256_NOMAX-NEXT:    fmov w9, s2
; SVE2_MIN_256_NOMAX-NEXT:    mov z2.b, z0.b[2]
; SVE2_MIN_256_NOMAX-NEXT:    mov z0.b, z0.b[1]
; SVE2_MIN_256_NOMAX-NEXT:    strb w8, [sp, #14]
; SVE2_MIN_256_NOMAX-NEXT:    fmov w8, s1
; SVE2_MIN_256_NOMAX-NEXT:    mov z1.b, z3.b[1]
; SVE2_MIN_256_NOMAX-NEXT:    strb w9, [sp, #13]
; SVE2_MIN_256_NOMAX-NEXT:    strb w9, [sp, #12]
; SVE2_MIN_256_NOMAX-NEXT:    fmov w9, s2
; SVE2_MIN_256_NOMAX-NEXT:    strb w8, [sp, #11]
; SVE2_MIN_256_NOMAX-NEXT:    fmov w8, s0
; SVE2_MIN_256_NOMAX-NEXT:    strb w9, [sp, #10]
; SVE2_MIN_256_NOMAX-NEXT:    fmov w9, s1
; SVE2_MIN_256_NOMAX-NEXT:    strb w8, [sp, #9]
; SVE2_MIN_256_NOMAX-NEXT:    strb w9, [sp, #8]
; SVE2_MIN_256_NOMAX-NEXT:    ldr d0, [sp, #8]
; SVE2_MIN_256_NOMAX-NEXT:    add sp, sp, #16
; SVE2_MIN_256_NOMAX-NEXT:    ret
  %op1 = load <8 x i8>, ptr %a
  %op2 = load <8 x i8>, ptr %b
  %1 = shufflevector <8 x i8> %op1, <8 x i8> %op2, <8 x i32> <i32 1, i32 9, i32 10, i32 11, i32 12, i32 12, i32 14, i32 poison>
  ret <8 x i8> %1
}

define <8 x i8> @shuffle_op1_poison(ptr %a, ptr %b) {
; SVE2_128-LABEL: shuffle_op1_poison:
; SVE2_128:       // %bb.0:
; SVE2_128-NEXT:    adrp x8, .LCPI4_0
; SVE2_128-NEXT:    ldr d0, [x1]
; SVE2_128-NEXT:    ldr q1, [x8, :lo12:.LCPI4_0]
; SVE2_128-NEXT:    tbl z0.b, { z0.b }, z1.b
; SVE2_128-NEXT:    // kill: def $d0 killed $d0 killed $z0
; SVE2_128-NEXT:    ret
;
; SVE2_128_NOMAX-LABEL: shuffle_op1_poison:
; SVE2_128_NOMAX:       // %bb.0:
; SVE2_128_NOMAX-NEXT:    adrp x8, .LCPI4_0
; SVE2_128_NOMAX-NEXT:    ldr d0, [x1]
; SVE2_128_NOMAX-NEXT:    ldr q1, [x8, :lo12:.LCPI4_0]
; SVE2_128_NOMAX-NEXT:    tbl z0.b, { z0.b }, z1.b
; SVE2_128_NOMAX-NEXT:    // kill: def $d0 killed $d0 killed $z0
; SVE2_128_NOMAX-NEXT:    ret
;
; SVE2_NOMIN_NOMAX-LABEL: shuffle_op1_poison:
; SVE2_NOMIN_NOMAX:       // %bb.0:
; SVE2_NOMIN_NOMAX-NEXT:    adrp x8, .LCPI4_0
; SVE2_NOMIN_NOMAX-NEXT:    ldr d0, [x1]
; SVE2_NOMIN_NOMAX-NEXT:    ldr q1, [x8, :lo12:.LCPI4_0]
; SVE2_NOMIN_NOMAX-NEXT:    tbl z0.b, { z0.b }, z1.b
; SVE2_NOMIN_NOMAX-NEXT:    // kill: def $d0 killed $d0 killed $z0
; SVE2_NOMIN_NOMAX-NEXT:    ret
;
; SVE2_MIN_256_NOMAX-LABEL: shuffle_op1_poison:
; SVE2_MIN_256_NOMAX:       // %bb.0:
; SVE2_MIN_256_NOMAX-NEXT:    ptrue p0.b, vl32
; SVE2_MIN_256_NOMAX-NEXT:    adrp x8, .LCPI4_0
; SVE2_MIN_256_NOMAX-NEXT:    add x8, x8, :lo12:.LCPI4_0
; SVE2_MIN_256_NOMAX-NEXT:    ldr d1, [x1]
; SVE2_MIN_256_NOMAX-NEXT:    ld1b { z0.b }, p0/z, [x8]
; SVE2_MIN_256_NOMAX-NEXT:    tbl z0.b, { z1.b }, z0.b
; SVE2_MIN_256_NOMAX-NEXT:    // kill: def $d0 killed $d0 killed $z0
; SVE2_MIN_256_NOMAX-NEXT:    ret
  %op2 = load <8 x i8>, ptr %b
  %1 = shufflevector <8 x i8> poison, <8 x i8> %op2, <8 x i32> <i32 1, i32 9, i32 10, i32 11, i32 12, i32 12, i32 14, i32 15>
  ret <8 x i8> %1
}

; In this function, we could not represent indexes for the second operand
; because for i8 type, the maximum constant in the mask is 256.
define <8 x i8> @negative_test_shuffle_index_size_op_both_maxhw(ptr %a, ptr %b) "target-features"="+sve2" vscale_range(16,16) {
; CHECK-LABEL: negative_test_shuffle_index_size_op_both_maxhw:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub sp, sp, #16
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    ldr d0, [x1]
; CHECK-NEXT:    mov z1.b, z0.b[7]
; CHECK-NEXT:    mov z2.b, z0.b[6]
; CHECK-NEXT:    mov z3.b, z0.b[4]
; CHECK-NEXT:    fmov w8, s1
; CHECK-NEXT:    ldr d1, [x0]
; CHECK-NEXT:    fmov w9, s2
; CHECK-NEXT:    mov z2.b, z0.b[3]
; CHECK-NEXT:    mov z1.b, z1.b[1]
; CHECK-NEXT:    strb w8, [sp, #15]
; CHECK-NEXT:    fmov w8, s3
; CHECK-NEXT:    mov z3.b, z0.b[2]
; CHECK-NEXT:    strb w9, [sp, #14]
; CHECK-NEXT:    mov z0.b, z0.b[1]
; CHECK-NEXT:    fmov w9, s2
; CHECK-NEXT:    strb w8, [sp, #13]
; CHECK-NEXT:    strb w8, [sp, #12]
; CHECK-NEXT:    fmov w8, s3
; CHECK-NEXT:    strb w9, [sp, #11]
; CHECK-NEXT:    fmov w9, s0
; CHECK-NEXT:    strb w8, [sp, #10]
; CHECK-NEXT:    fmov w8, s1
; CHECK-NEXT:    strb w9, [sp, #9]
; CHECK-NEXT:    strb w8, [sp, #8]
; CHECK-NEXT:    ldr d0, [sp, #8]
; CHECK-NEXT:    add sp, sp, #16
; CHECK-NEXT:    ret
  %op1 = load <8 x i8>, ptr %a
  %op2 = load <8 x i8>, ptr %b
  %1 = shufflevector <8 x i8> %op1, <8 x i8> %op2, <8 x i32> <i32 1, i32 9, i32 10, i32 11, i32 12, i32 12, i32 14, i32 15>
  ret <8 x i8> %1
}

; CHECK: .LCPI6_0:
; CHECK-NEXT:        .byte   0                               // 0x0
; CHECK-NEXT:        .byte   7                               // 0x7
; CHECK-NEXT:        .byte   2                               // 0x2
; CHECK-NEXT:        .byte   3                               // 0x3
; CHECK-NEXT:        .byte   4                               // 0x4
; CHECK-NEXT:        .byte   5                               // 0x5
; CHECK-NEXT:        .byte   6                               // 0x6
; CHECK-NEXT:        .byte   7                               // 0x7
; CHECK-NEXT:        .byte   255                             // 0xff
; CHECK-NEXT:        .byte   255                             // 0xff
define <8 x i8> @shuffle_index_size_op1_maxhw(ptr %a, ptr %b) "target-features"="+sve2" vscale_range(16,16) {
; CHECK-LABEL: shuffle_index_size_op1_maxhw:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b
; CHECK-NEXT:    adrp x8, .LCPI6_0
; CHECK-NEXT:    add x8, x8, :lo12:.LCPI6_0
; CHECK-NEXT:    ldr d1, [x0]
; CHECK-NEXT:    ld1b { z0.b }, p0/z, [x8]
; CHECK-NEXT:    tbl z0.b, { z1.b }, z0.b
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %op1 = load <8 x i8>, ptr %a
  %op2 = load <8 x i8>, ptr %b
  %1 = shufflevector <8 x i8> %op1, <8 x i8> %op2, <8 x i32> <i32 0, i32 7, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  ret <8 x i8> %1
}

; SVE2_128: .LCPI7_0:
; SVE2_128-NEXT:        .hword  1                               // 0x1
; SVE2_128-NEXT:        .hword  9                               // 0x9
; SVE2_128-NEXT:        .hword  10                              // 0xa
; SVE2_128-NEXT:        .hword  11                              // 0xb
; SVE2_128-NEXT:        .hword  12                              // 0xc
; SVE2_128-NEXT:        .hword  12                              // 0xc
; SVE2_128-NEXT:        .hword  14                              // 0xe
; SVE2_128-NEXT:        .hword  15                              // 0xf

; SVE2_128_NOMAX: .LCPI7_0:
; SVE2_128_NOMAX-NEXT:        .hword  0                               // 0x0
; SVE2_128_NOMAX-NEXT:        .hword  1                               // 0x1
; SVE2_128_NOMAX-NEXT:        .hword  1                               // 0x1
; SVE2_128_NOMAX-NEXT:        .hword  1                               // 0x1
; SVE2_128_NOMAX-NEXT:        .hword  1                               // 0x1
; SVE2_128_NOMAX-NEXT:        .hword  1                               // 0x1
; SVE2_128_NOMAX-NEXT:        .hword  1                               // 0x1
; SVE2_128_NOMAX-NEXT:        .hword  1                               // 0x1
; SVE2_128_NOMAX-NEXT:.LCPI7_1:
; SVE2_128_NOMAX-NEXT:        .hword  1                               // 0x1
; SVE2_128_NOMAX-NEXT:        .hword  1                               // 0x1
; SVE2_128_NOMAX-NEXT:        .hword  2                               // 0x2
; SVE2_128_NOMAX-NEXT:        .hword  3                               // 0x3
; SVE2_128_NOMAX-NEXT:        .hword  4                               // 0x4
; SVE2_128_NOMAX-NEXT:        .hword  4                               // 0x4
; SVE2_128_NOMAX-NEXT:        .hword  6                               // 0x6
; SVE2_128_NOMAX-NEXT:        .hword  7                               // 0x7

; SVE2_NOMIN_NOMAX: .LCPI7_0:
; SVE2_NOMIN_NOMAX-NEXT:        .hword  0                               // 0x0
; SVE2_NOMIN_NOMAX-NEXT:        .hword  1                               // 0x1
; SVE2_NOMIN_NOMAX-NEXT:        .hword  1                               // 0x1
; SVE2_NOMIN_NOMAX-NEXT:        .hword  1                               // 0x1
; SVE2_NOMIN_NOMAX-NEXT:        .hword  1                               // 0x1
; SVE2_NOMIN_NOMAX-NEXT:        .hword  1                               // 0x1
; SVE2_NOMIN_NOMAX-NEXT:        .hword  1                               // 0x1
; SVE2_NOMIN_NOMAX-NEXT:        .hword  1                               // 0x1
; SVE2_NOMIN_NOMAX-NEXT:.LCPI7_1:
; SVE2_NOMIN_NOMAX-NEXT:        .hword  1                               // 0x1
; SVE2_NOMIN_NOMAX-NEXT:        .hword  1                               // 0x1
; SVE2_NOMIN_NOMAX-NEXT:        .hword  2                               // 0x2
; SVE2_NOMIN_NOMAX-NEXT:        .hword  3                               // 0x3
; SVE2_NOMIN_NOMAX-NEXT:        .hword  4                               // 0x4
; SVE2_NOMIN_NOMAX-NEXT:        .hword  4                               // 0x4
; SVE2_NOMIN_NOMAX-NEXT:        .hword  6                               // 0x6
; SVE2_NOMIN_NOMAX-NEXT:        .hword  7                               // 0x7

; SVE2_MIN_256_NOMAX: .LCPI7_0:
; SVE2_MIN_256_NOMAX-NEXT:        .hword  0                               // 0x0
; SVE2_MIN_256_NOMAX-NEXT:        .hword  1                               // 0x1
; SVE2_MIN_256_NOMAX-NEXT:        .hword  1                               // 0x1
; SVE2_MIN_256_NOMAX-NEXT:        .hword  1                               // 0x1
; SVE2_MIN_256_NOMAX-NEXT:        .hword  1                               // 0x1
; SVE2_MIN_256_NOMAX-NEXT:        .hword  1                               // 0x1
; SVE2_MIN_256_NOMAX-NEXT:        .hword  1                               // 0x1
; SVE2_MIN_256_NOMAX-NEXT:        .hword  1                               // 0x1
; SVE2_MIN_256_NOMAX-NEXT:        .hword  0                               // 0x0
; SVE2_MIN_256_NOMAX-NEXT:        .hword  0                               // 0x0
; SVE2_MIN_256_NOMAX-NEXT:        .hword  0                               // 0x0
; SVE2_MIN_256_NOMAX-NEXT:        .hword  0                               // 0x0
; SVE2_MIN_256_NOMAX-NEXT:        .hword  0                               // 0x0
; SVE2_MIN_256_NOMAX-NEXT:        .hword  0                               // 0x0
; SVE2_MIN_256_NOMAX-NEXT:        .hword  0                               // 0x0
; SVE2_MIN_256_NOMAX-NEXT:        .hword  0                               // 0x0
; SVE2_MIN_256_NOMAX-NEXT:.LCPI7_1:
; SVE2_MIN_256_NOMAX-NEXT:        .hword  1                               // 0x1
; SVE2_MIN_256_NOMAX-NEXT:        .hword  1                               // 0x1
; SVE2_MIN_256_NOMAX-NEXT:        .hword  2                               // 0x2
; SVE2_MIN_256_NOMAX-NEXT:        .hword  3                               // 0x3
; SVE2_MIN_256_NOMAX-NEXT:        .hword  4                               // 0x4
; SVE2_MIN_256_NOMAX-NEXT:        .hword  4                               // 0x4
; SVE2_MIN_256_NOMAX-NEXT:        .hword  6                               // 0x6
; SVE2_MIN_256_NOMAX-NEXT:        .hword  7                               // 0x7
; SVE2_MIN_256_NOMAX-NEXT:        .hword  65535                           // 0xffff
; SVE2_MIN_256_NOMAX-NEXT:        .hword  65535                           // 0xffff
; SVE2_MIN_256_NOMAX-NEXT:        .hword  65535                           // 0xffff
; SVE2_MIN_256_NOMAX-NEXT:        .hword  65535                           // 0xffff
; SVE2_MIN_256_NOMAX-NEXT:        .hword  65535                           // 0xffff
; SVE2_MIN_256_NOMAX-NEXT:        .hword  65535                           // 0xffff
; SVE2_MIN_256_NOMAX-NEXT:        .hword  65535                           // 0xffff
; SVE2_MIN_256_NOMAX-NEXT:        .hword  65535                           // 0xffff
define <8 x i16> @shuffle_index_indices_from_both_ops_i16(ptr %a, ptr %b) {
; SVE2_128-LABEL: shuffle_index_indices_from_both_ops_i16:
; SVE2_128:       // %bb.0:
; SVE2_128-NEXT:    adrp x8, .LCPI7_0
; SVE2_128-NEXT:    ldr q0, [x0]
; SVE2_128-NEXT:    ldr q1, [x1]
; SVE2_128-NEXT:    ldr q2, [x8, :lo12:.LCPI7_0]
; SVE2_128-NEXT:    tbl z0.h, { z0.h, z1.h }, z2.h
; SVE2_128-NEXT:    // kill: def $q0 killed $q0 killed $z0
; SVE2_128-NEXT:    ret
;
; SVE2_128_NOMAX-LABEL: shuffle_index_indices_from_both_ops_i16:
; SVE2_128_NOMAX:       // %bb.0:
; SVE2_128_NOMAX-NEXT:    ptrue p0.h, vl8
; SVE2_128_NOMAX-NEXT:    cnth x8
; SVE2_128_NOMAX-NEXT:    adrp x9, .LCPI7_0
; SVE2_128_NOMAX-NEXT:    adrp x10, .LCPI7_1
; SVE2_128_NOMAX-NEXT:    mov z0.h, w8
; SVE2_128_NOMAX-NEXT:    ldr q1, [x9, :lo12:.LCPI7_0]
; SVE2_128_NOMAX-NEXT:    ldr q2, [x10, :lo12:.LCPI7_1]
; SVE2_128_NOMAX-NEXT:    mad z0.h, p0/m, z1.h, z2.h
; SVE2_128_NOMAX-NEXT:    ldr q1, [x0]
; SVE2_128_NOMAX-NEXT:    ldr q2, [x1]
; SVE2_128_NOMAX-NEXT:    tbl z0.h, { z1.h, z2.h }, z0.h
; SVE2_128_NOMAX-NEXT:    // kill: def $q0 killed $q0 killed $z0
; SVE2_128_NOMAX-NEXT:    ret
;
; SVE2_NOMIN_NOMAX-LABEL: shuffle_index_indices_from_both_ops_i16:
; SVE2_NOMIN_NOMAX:       // %bb.0:
; SVE2_NOMIN_NOMAX-NEXT:    ptrue p0.h, vl8
; SVE2_NOMIN_NOMAX-NEXT:    cnth x8
; SVE2_NOMIN_NOMAX-NEXT:    adrp x9, .LCPI7_0
; SVE2_NOMIN_NOMAX-NEXT:    adrp x10, .LCPI7_1
; SVE2_NOMIN_NOMAX-NEXT:    mov z0.h, w8
; SVE2_NOMIN_NOMAX-NEXT:    ldr q1, [x9, :lo12:.LCPI7_0]
; SVE2_NOMIN_NOMAX-NEXT:    ldr q2, [x10, :lo12:.LCPI7_1]
; SVE2_NOMIN_NOMAX-NEXT:    mad z0.h, p0/m, z1.h, z2.h
; SVE2_NOMIN_NOMAX-NEXT:    ldr q1, [x0]
; SVE2_NOMIN_NOMAX-NEXT:    ldr q2, [x1]
; SVE2_NOMIN_NOMAX-NEXT:    tbl z0.h, { z1.h, z2.h }, z0.h
; SVE2_NOMIN_NOMAX-NEXT:    // kill: def $q0 killed $q0 killed $z0
; SVE2_NOMIN_NOMAX-NEXT:    ret
;
; SVE2_MIN_256_NOMAX-LABEL: shuffle_index_indices_from_both_ops_i16:
; SVE2_MIN_256_NOMAX:       // %bb.0:
; SVE2_MIN_256_NOMAX-NEXT:    ptrue p0.h, vl16
; SVE2_MIN_256_NOMAX-NEXT:    adrp x8, .LCPI7_0
; SVE2_MIN_256_NOMAX-NEXT:    add x8, x8, :lo12:.LCPI7_0
; SVE2_MIN_256_NOMAX-NEXT:    adrp x9, .LCPI7_1
; SVE2_MIN_256_NOMAX-NEXT:    add x9, x9, :lo12:.LCPI7_1
; SVE2_MIN_256_NOMAX-NEXT:    cnth x10
; SVE2_MIN_256_NOMAX-NEXT:    mov z2.h, w10
; SVE2_MIN_256_NOMAX-NEXT:    ld1h { z0.h }, p0/z, [x8]
; SVE2_MIN_256_NOMAX-NEXT:    ld1h { z1.h }, p0/z, [x9]
; SVE2_MIN_256_NOMAX-NEXT:    mad z0.h, p0/m, z2.h, z1.h
; SVE2_MIN_256_NOMAX-NEXT:    ldr q1, [x0]
; SVE2_MIN_256_NOMAX-NEXT:    ldr q2, [x1]
; SVE2_MIN_256_NOMAX-NEXT:    tbl z0.h, { z1.h, z2.h }, z0.h
; SVE2_MIN_256_NOMAX-NEXT:    // kill: def $q0 killed $q0 killed $z0
; SVE2_MIN_256_NOMAX-NEXT:    ret
  %op1 = load <8 x i16>, ptr %a
  %op2 = load <8 x i16>, ptr %b
  %1 = shufflevector <8 x i16> %op1, <8 x i16> %op2, <8 x i32> <i32 1, i32 9, i32 10, i32 11, i32 12, i32 12, i32 14, i32 15>
  ret <8 x i16> %1
}
