; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 4
; RUN: llc -mtriple=aarch64 -verify-machineinstrs %s -o - | FileCheck %s --check-prefixes=CHECK,CHECK-SD
; RUN: llc -mtriple=aarch64 -global-isel -global-isel-abort=2 -verify-machineinstrs %s -o - 2>&1 | FileCheck %s --check-prefixes=CHECK,CHECK-GI

define i64 @i64_i64(i64 %a, i64 %b, i64 %d, i64 %e) {
; CHECK-LABEL: i64_i64:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    cmp x0, x1
; CHECK-NEXT:    csel x0, x2, x3, lt
; CHECK-NEXT:    ret
entry:
  %c = icmp slt i64 %a, %b
  %s = select i1 %c, i64 %d, i64 %e
  ret i64 %s
}

define i32 @i32_i32(i32 %a, i32 %b, i32 %d, i32 %e) {
; CHECK-LABEL: i32_i32:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    cmp w0, w1
; CHECK-NEXT:    csel w0, w2, w3, lt
; CHECK-NEXT:    ret
entry:
  %c = icmp slt i32 %a, %b
  %s = select i1 %c, i32 %d, i32 %e
  ret i32 %s
}

define i16 @i16_i16(i16 %a, i16 %b, i16 %d, i16 %e) {
; CHECK-LABEL: i16_i16:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    sxth w8, w0
; CHECK-NEXT:    cmp w8, w1, sxth
; CHECK-NEXT:    csel w0, w2, w3, lt
; CHECK-NEXT:    ret
entry:
  %c = icmp slt i16 %a, %b
  %s = select i1 %c, i16 %d, i16 %e
  ret i16 %s
}

define i8 @i8_i8(i8 %a, i8 %b, i8 %d, i8 %e) {
; CHECK-LABEL: i8_i8:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    sxtb w8, w0
; CHECK-NEXT:    cmp w8, w1, sxtb
; CHECK-NEXT:    csel w0, w2, w3, lt
; CHECK-NEXT:    ret
entry:
  %c = icmp slt i8 %a, %b
  %s = select i1 %c, i8 %d, i8 %e
  ret i8 %s
}

define <2 x i64> @v2i64_i64(<2 x i64> %a, <2 x i64> %b, <2 x i64> %d, <2 x i64> %e) {
; CHECK-LABEL: v2i64_i64:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    cmgt v0.2d, v1.2d, v0.2d
; CHECK-NEXT:    bsl v0.16b, v2.16b, v3.16b
; CHECK-NEXT:    ret
entry:
  %c = icmp slt <2 x i64> %a, %b
  %s = select <2 x i1> %c, <2 x i64> %d, <2 x i64> %e
  ret <2 x i64> %s
}

define <3 x i64> @v3i64_i64(<3 x i64> %a, <3 x i64> %b, <3 x i64> %d, <3 x i64> %e) {
; CHECK-SD-LABEL: v3i64_i64:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    // kill: def $d4 killed $d4 def $q4
; CHECK-SD-NEXT:    // kill: def $d3 killed $d3 def $q3
; CHECK-SD-NEXT:    // kill: def $d1 killed $d1 def $q1
; CHECK-SD-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-SD-NEXT:    // kill: def $d6 killed $d6 def $q6
; CHECK-SD-NEXT:    // kill: def $d7 killed $d7 def $q7
; CHECK-SD-NEXT:    // kill: def $d5 killed $d5 def $q5
; CHECK-SD-NEXT:    // kill: def $d2 killed $d2 def $q2
; CHECK-SD-NEXT:    ldr d16, [sp, #24]
; CHECK-SD-NEXT:    ldr d17, [sp]
; CHECK-SD-NEXT:    mov v3.d[1], v4.d[0]
; CHECK-SD-NEXT:    mov v0.d[1], v1.d[0]
; CHECK-SD-NEXT:    mov v6.d[1], v7.d[0]
; CHECK-SD-NEXT:    ldp d1, d4, [sp, #8]
; CHECK-SD-NEXT:    mov v1.d[1], v4.d[0]
; CHECK-SD-NEXT:    cmgt v0.2d, v3.2d, v0.2d
; CHECK-SD-NEXT:    bsl v0.16b, v6.16b, v1.16b
; CHECK-SD-NEXT:    cmgt v1.2d, v5.2d, v2.2d
; CHECK-SD-NEXT:    mov v2.16b, v1.16b
; CHECK-SD-NEXT:    ext v1.16b, v0.16b, v0.16b, #8
; CHECK-SD-NEXT:    // kill: def $d0 killed $d0 killed $q0
; CHECK-SD-NEXT:    // kill: def $d1 killed $d1 killed $q1
; CHECK-SD-NEXT:    bsl v2.16b, v17.16b, v16.16b
; CHECK-SD-NEXT:    // kill: def $d2 killed $d2 killed $q2
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: v3i64_i64:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-GI-NEXT:    // kill: def $d1 killed $d1 def $q1
; CHECK-GI-NEXT:    // kill: def $d3 killed $d3 def $q3
; CHECK-GI-NEXT:    // kill: def $d4 killed $d4 def $q4
; CHECK-GI-NEXT:    // kill: def $d2 killed $d2 def $q2
; CHECK-GI-NEXT:    // kill: def $d6 killed $d6 def $q6
; CHECK-GI-NEXT:    // kill: def $d5 killed $d5 def $q5
; CHECK-GI-NEXT:    // kill: def $d7 killed $d7 def $q7
; CHECK-GI-NEXT:    ldr x8, [sp]
; CHECK-GI-NEXT:    ldr x10, [sp, #24]
; CHECK-GI-NEXT:    mov v0.d[1], v1.d[0]
; CHECK-GI-NEXT:    mov v3.d[1], v4.d[0]
; CHECK-GI-NEXT:    cmgt v2.2d, v5.2d, v2.2d
; CHECK-GI-NEXT:    ldp d1, d4, [sp, #8]
; CHECK-GI-NEXT:    mov v6.d[1], v7.d[0]
; CHECK-GI-NEXT:    fmov x9, d2
; CHECK-GI-NEXT:    mov v1.d[1], v4.d[0]
; CHECK-GI-NEXT:    cmgt v0.2d, v3.2d, v0.2d
; CHECK-GI-NEXT:    sbfx x9, x9, #0, #1
; CHECK-GI-NEXT:    bsl v0.16b, v6.16b, v1.16b
; CHECK-GI-NEXT:    and x8, x8, x9
; CHECK-GI-NEXT:    bic x9, x10, x9
; CHECK-GI-NEXT:    orr x8, x8, x9
; CHECK-GI-NEXT:    fmov d2, x8
; CHECK-GI-NEXT:    mov d1, v0.d[1]
; CHECK-GI-NEXT:    // kill: def $d0 killed $d0 killed $q0
; CHECK-GI-NEXT:    ret
entry:
  %c = icmp slt <3 x i64> %a, %b
  %s = select <3 x i1> %c, <3 x i64> %d, <3 x i64> %e
  ret <3 x i64> %s
}

define <4 x i64> @v4i64_i64(<4 x i64> %a, <4 x i64> %b, <4 x i64> %d, <4 x i64> %e) {
; CHECK-SD-LABEL: v4i64_i64:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    cmgt v1.2d, v3.2d, v1.2d
; CHECK-SD-NEXT:    cmgt v0.2d, v2.2d, v0.2d
; CHECK-SD-NEXT:    bsl v1.16b, v5.16b, v7.16b
; CHECK-SD-NEXT:    bsl v0.16b, v4.16b, v6.16b
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: v4i64_i64:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    cmgt v0.2d, v2.2d, v0.2d
; CHECK-GI-NEXT:    cmgt v1.2d, v3.2d, v1.2d
; CHECK-GI-NEXT:    bsl v0.16b, v4.16b, v6.16b
; CHECK-GI-NEXT:    bsl v1.16b, v5.16b, v7.16b
; CHECK-GI-NEXT:    ret
entry:
  %c = icmp slt <4 x i64> %a, %b
  %s = select <4 x i1> %c, <4 x i64> %d, <4 x i64> %e
  ret <4 x i64> %s
}

define <2 x i32> @v2i32_i32(<2 x i32> %a, <2 x i32> %b, <2 x i32> %d, <2 x i32> %e) {
; CHECK-LABEL: v2i32_i32:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    cmgt v0.2s, v1.2s, v0.2s
; CHECK-NEXT:    bsl v0.8b, v2.8b, v3.8b
; CHECK-NEXT:    ret
entry:
  %c = icmp slt <2 x i32> %a, %b
  %s = select <2 x i1> %c, <2 x i32> %d, <2 x i32> %e
  ret <2 x i32> %s
}

define <3 x i32> @v3i32_i32(<3 x i32> %a, <3 x i32> %b, <3 x i32> %d, <3 x i32> %e) {
; CHECK-SD-LABEL: v3i32_i32:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    cmgt v0.4s, v1.4s, v0.4s
; CHECK-SD-NEXT:    bsl v0.16b, v2.16b, v3.16b
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: v3i32_i32:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    mov w8, #31 // =0x1f
; CHECK-GI-NEXT:    cmgt v0.4s, v1.4s, v0.4s
; CHECK-GI-NEXT:    fmov s4, w8
; CHECK-GI-NEXT:    mov v4.s[1], w8
; CHECK-GI-NEXT:    mov v4.s[2], w8
; CHECK-GI-NEXT:    mov w8, #-1 // =0xffffffff
; CHECK-GI-NEXT:    fmov s1, w8
; CHECK-GI-NEXT:    mov v1.s[1], w8
; CHECK-GI-NEXT:    neg v5.4s, v4.4s
; CHECK-GI-NEXT:    ushl v0.4s, v0.4s, v4.4s
; CHECK-GI-NEXT:    mov v1.s[2], w8
; CHECK-GI-NEXT:    sshl v0.4s, v0.4s, v5.4s
; CHECK-GI-NEXT:    eor v1.16b, v0.16b, v1.16b
; CHECK-GI-NEXT:    and v0.16b, v2.16b, v0.16b
; CHECK-GI-NEXT:    and v1.16b, v3.16b, v1.16b
; CHECK-GI-NEXT:    orr v0.16b, v0.16b, v1.16b
; CHECK-GI-NEXT:    ret
entry:
  %c = icmp slt <3 x i32> %a, %b
  %s = select <3 x i1> %c, <3 x i32> %d, <3 x i32> %e
  ret <3 x i32> %s
}

define <4 x i32> @v4i32_i32(<4 x i32> %a, <4 x i32> %b, <4 x i32> %d, <4 x i32> %e) {
; CHECK-LABEL: v4i32_i32:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    cmgt v0.4s, v1.4s, v0.4s
; CHECK-NEXT:    bsl v0.16b, v2.16b, v3.16b
; CHECK-NEXT:    ret
entry:
  %c = icmp slt <4 x i32> %a, %b
  %s = select <4 x i1> %c, <4 x i32> %d, <4 x i32> %e
  ret <4 x i32> %s
}

define <8 x i32> @v8i32_i32(<8 x i32> %a, <8 x i32> %b, <8 x i32> %d, <8 x i32> %e) {
; CHECK-SD-LABEL: v8i32_i32:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    cmgt v1.4s, v3.4s, v1.4s
; CHECK-SD-NEXT:    cmgt v0.4s, v2.4s, v0.4s
; CHECK-SD-NEXT:    bsl v1.16b, v5.16b, v7.16b
; CHECK-SD-NEXT:    bsl v0.16b, v4.16b, v6.16b
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: v8i32_i32:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    cmgt v0.4s, v2.4s, v0.4s
; CHECK-GI-NEXT:    cmgt v1.4s, v3.4s, v1.4s
; CHECK-GI-NEXT:    bsl v0.16b, v4.16b, v6.16b
; CHECK-GI-NEXT:    bsl v1.16b, v5.16b, v7.16b
; CHECK-GI-NEXT:    ret
entry:
  %c = icmp slt <8 x i32> %a, %b
  %s = select <8 x i1> %c, <8 x i32> %d, <8 x i32> %e
  ret <8 x i32> %s
}

define <4 x i16> @v4i16_i16(<4 x i16> %a, <4 x i16> %b, <4 x i16> %d, <4 x i16> %e) {
; CHECK-LABEL: v4i16_i16:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    cmgt v0.4h, v1.4h, v0.4h
; CHECK-NEXT:    bsl v0.8b, v2.8b, v3.8b
; CHECK-NEXT:    ret
entry:
  %c = icmp slt <4 x i16> %a, %b
  %s = select <4 x i1> %c, <4 x i16> %d, <4 x i16> %e
  ret <4 x i16> %s
}

define <8 x i16> @v8i16_i16(<8 x i16> %a, <8 x i16> %b, <8 x i16> %d, <8 x i16> %e) {
; CHECK-LABEL: v8i16_i16:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    cmgt v0.8h, v1.8h, v0.8h
; CHECK-NEXT:    bsl v0.16b, v2.16b, v3.16b
; CHECK-NEXT:    ret
entry:
  %c = icmp slt <8 x i16> %a, %b
  %s = select <8 x i1> %c, <8 x i16> %d, <8 x i16> %e
  ret <8 x i16> %s
}

define <16 x i16> @v16i16_i16(<16 x i16> %a, <16 x i16> %b, <16 x i16> %d, <16 x i16> %e) {
; CHECK-SD-LABEL: v16i16_i16:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    cmgt v1.8h, v3.8h, v1.8h
; CHECK-SD-NEXT:    cmgt v0.8h, v2.8h, v0.8h
; CHECK-SD-NEXT:    bsl v1.16b, v5.16b, v7.16b
; CHECK-SD-NEXT:    bsl v0.16b, v4.16b, v6.16b
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: v16i16_i16:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    cmgt v0.8h, v2.8h, v0.8h
; CHECK-GI-NEXT:    cmgt v1.8h, v3.8h, v1.8h
; CHECK-GI-NEXT:    bsl v0.16b, v4.16b, v6.16b
; CHECK-GI-NEXT:    bsl v1.16b, v5.16b, v7.16b
; CHECK-GI-NEXT:    ret
entry:
  %c = icmp slt <16 x i16> %a, %b
  %s = select <16 x i1> %c, <16 x i16> %d, <16 x i16> %e
  ret <16 x i16> %s
}

define <8 x i8> @v8i8_i8(<8 x i8> %a, <8 x i8> %b, <8 x i8> %d, <8 x i8> %e) {
; CHECK-LABEL: v8i8_i8:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    cmgt v0.8b, v1.8b, v0.8b
; CHECK-NEXT:    bsl v0.8b, v2.8b, v3.8b
; CHECK-NEXT:    ret
entry:
  %c = icmp slt <8 x i8> %a, %b
  %s = select <8 x i1> %c, <8 x i8> %d, <8 x i8> %e
  ret <8 x i8> %s
}

define <16 x i8> @v16i8_i8(<16 x i8> %a, <16 x i8> %b, <16 x i8> %d, <16 x i8> %e) {
; CHECK-LABEL: v16i8_i8:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    cmgt v0.16b, v1.16b, v0.16b
; CHECK-NEXT:    bsl v0.16b, v2.16b, v3.16b
; CHECK-NEXT:    ret
entry:
  %c = icmp slt <16 x i8> %a, %b
  %s = select <16 x i1> %c, <16 x i8> %d, <16 x i8> %e
  ret <16 x i8> %s
}

define <32 x i8> @v32i8_i8(<32 x i8> %a, <32 x i8> %b, <32 x i8> %d, <32 x i8> %e) {
; CHECK-SD-LABEL: v32i8_i8:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    cmgt v1.16b, v3.16b, v1.16b
; CHECK-SD-NEXT:    cmgt v0.16b, v2.16b, v0.16b
; CHECK-SD-NEXT:    bsl v1.16b, v5.16b, v7.16b
; CHECK-SD-NEXT:    bsl v0.16b, v4.16b, v6.16b
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: v32i8_i8:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    cmgt v0.16b, v2.16b, v0.16b
; CHECK-GI-NEXT:    cmgt v1.16b, v3.16b, v1.16b
; CHECK-GI-NEXT:    bsl v0.16b, v4.16b, v6.16b
; CHECK-GI-NEXT:    bsl v1.16b, v5.16b, v7.16b
; CHECK-GI-NEXT:    ret
entry:
  %c = icmp slt <32 x i8> %a, %b
  %s = select <32 x i1> %c, <32 x i8> %d, <32 x i8> %e
  ret <32 x i8> %s
}
