; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-unknown-unknown | FileCheck %s

define i64 @sub1_disguised_constant(i64 %x) {
; CHECK-LABEL: sub1_disguised_constant:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub w8, w0, #1
; CHECK-NEXT:    and w8, w0, w8
; CHECK-NEXT:    and x0, x8, #0xffff
; CHECK-NEXT:    ret
  %a1 = and i64 %x, 65535
  %a2 = add i64 %x, 65535
  %r = and i64 %a1, %a2
  ret i64 %r
}

define i8 @masked_sub_i8(i8 %x) {
; CHECK-LABEL: masked_sub_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #5
; CHECK-NEXT:    and w8, w0, w8
; CHECK-NEXT:    eor w0, w8, #0x7
; CHECK-NEXT:    ret
  %a = and i8 %x, 5
  %m = sub i8 7, %a
  ret i8 %m
}

; Borrow from the MSB is ok.

define i8 @masked_sub_high_bit_mask_i8(i8 %x) {
; CHECK-LABEL: masked_sub_high_bit_mask_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #-96
; CHECK-NEXT:    and w8, w0, w8
; CHECK-NEXT:    eor w0, w8, #0x3c
; CHECK-NEXT:    ret
  %maskx = and i8 %x, 160 ; 0b10100000
  %s = sub i8 60, %maskx  ; 0b00111100
  ret i8 %s
}

define i8 @not_masked_sub_i8(i8 %x) {
; CHECK-LABEL: not_masked_sub_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #7
; CHECK-NEXT:    and w9, w0, #0x8
; CHECK-NEXT:    sub w0, w8, w9
; CHECK-NEXT:    ret
  %a = and i8 %x, 8
  %m = sub i8 7, %a
  ret i8 %m
}

define i32 @masked_sub_i32(i32 %x) {
; CHECK-LABEL: masked_sub_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #9
; CHECK-NEXT:    and w8, w0, w8
; CHECK-NEXT:    eor w0, w8, #0x1f
; CHECK-NEXT:    ret
  %a = and i32 %x, 9
  %m = sub i32 31, %a
  ret i32 %m
}

define <4 x i32> @masked_sub_v4i32(<4 x i32> %x) {
; CHECK-LABEL: masked_sub_v4i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.4s, #42
; CHECK-NEXT:    movi v2.4s, #1, msl #8
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    eor v0.16b, v0.16b, v2.16b
; CHECK-NEXT:    ret
  %a = and <4 x i32> %x, <i32 42, i32 42, i32 42, i32 42>
  %m = sub <4 x i32> <i32 511, i32 511, i32 511, i32 511>, %a
  ret <4 x i32>  %m
}
