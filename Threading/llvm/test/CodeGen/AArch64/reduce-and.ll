; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-unknown-linux-gnu -mattr=+neon | FileCheck %s
; RUN: llc < %s -mtriple=aarch64-none-linux-gnu -mattr=+neon -global-isel -global-isel-abort=1 | FileCheck %s --check-prefix=GISEL


define i1 @test_redand_v1i1(<1 x i1> %a) {
; CHECK-LABEL: test_redand_v1i1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and w0, w0, #0x1
; CHECK-NEXT:    ret
;
; GISEL-LABEL: test_redand_v1i1:
; GISEL:       // %bb.0:
; GISEL-NEXT:    and w0, w0, #0x1
; GISEL-NEXT:    ret
  %or_result = call i1 @llvm.vector.reduce.and.v1i1(<1 x i1> %a)
  ret i1 %or_result
}

define i1 @test_redand_v2i1(<2 x i1> %a) {
; CHECK-LABEL: test_redand_v2i1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    shl v0.2s, v0.2s, #31
; CHECK-NEXT:    cmlt v0.2s, v0.2s, #0
; CHECK-NEXT:    uminp v0.2s, v0.2s, v0.2s
; CHECK-NEXT:    fmov w8, s0
; CHECK-NEXT:    and w0, w8, #0x1
; CHECK-NEXT:    ret
;
; GISEL-LABEL: test_redand_v2i1:
; GISEL:       // %bb.0:
; GISEL-NEXT:    // kill: def $d0 killed $d0 def $q0
; GISEL-NEXT:    mov s1, v0.s[1]
; GISEL-NEXT:    fmov w8, s0
; GISEL-NEXT:    fmov w9, s1
; GISEL-NEXT:    and w8, w8, w9
; GISEL-NEXT:    and w0, w8, #0x1
; GISEL-NEXT:    ret
  %or_result = call i1 @llvm.vector.reduce.and.v2i1(<2 x i1> %a)
  ret i1 %or_result
}

define i1 @test_redand_v4i1(<4 x i1> %a) {
; CHECK-LABEL: test_redand_v4i1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    shl v0.4h, v0.4h, #15
; CHECK-NEXT:    cmlt v0.4h, v0.4h, #0
; CHECK-NEXT:    uminv h0, v0.4h
; CHECK-NEXT:    fmov w8, s0
; CHECK-NEXT:    and w0, w8, #0x1
; CHECK-NEXT:    ret
;
; GISEL-LABEL: test_redand_v4i1:
; GISEL:       // %bb.0:
; GISEL-NEXT:    // kill: def $d0 killed $d0 def $q0
; GISEL-NEXT:    umov w8, v0.h[0]
; GISEL-NEXT:    umov w9, v0.h[1]
; GISEL-NEXT:    umov w10, v0.h[2]
; GISEL-NEXT:    umov w11, v0.h[3]
; GISEL-NEXT:    and w8, w8, w9
; GISEL-NEXT:    and w9, w10, w11
; GISEL-NEXT:    and w8, w8, w9
; GISEL-NEXT:    and w0, w8, #0x1
; GISEL-NEXT:    ret
  %or_result = call i1 @llvm.vector.reduce.and.v4i1(<4 x i1> %a)
  ret i1 %or_result
}

define i1 @test_redand_v8i1(<8 x i1> %a) {
; CHECK-LABEL: test_redand_v8i1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    shl v0.8b, v0.8b, #7
; CHECK-NEXT:    cmlt v0.8b, v0.8b, #0
; CHECK-NEXT:    uminv b0, v0.8b
; CHECK-NEXT:    fmov w8, s0
; CHECK-NEXT:    and w0, w8, #0x1
; CHECK-NEXT:    ret
;
; GISEL-LABEL: test_redand_v8i1:
; GISEL:       // %bb.0:
; GISEL-NEXT:    // kill: def $d0 killed $d0 def $q0
; GISEL-NEXT:    umov w8, v0.b[0]
; GISEL-NEXT:    umov w9, v0.b[1]
; GISEL-NEXT:    umov w10, v0.b[2]
; GISEL-NEXT:    umov w11, v0.b[3]
; GISEL-NEXT:    umov w12, v0.b[4]
; GISEL-NEXT:    umov w13, v0.b[5]
; GISEL-NEXT:    umov w14, v0.b[6]
; GISEL-NEXT:    umov w15, v0.b[7]
; GISEL-NEXT:    and w8, w8, w9
; GISEL-NEXT:    and w9, w10, w11
; GISEL-NEXT:    and w10, w12, w13
; GISEL-NEXT:    and w11, w14, w15
; GISEL-NEXT:    and w8, w8, w9
; GISEL-NEXT:    and w9, w10, w11
; GISEL-NEXT:    and w8, w8, w9
; GISEL-NEXT:    and w0, w8, #0x1
; GISEL-NEXT:    ret
  %or_result = call i1 @llvm.vector.reduce.and.v8i1(<8 x i1> %a)
  ret i1 %or_result
}

define i1 @test_redand_v16i1(<16 x i1> %a) {
; CHECK-LABEL: test_redand_v16i1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    shl v0.16b, v0.16b, #7
; CHECK-NEXT:    cmlt v0.16b, v0.16b, #0
; CHECK-NEXT:    uminv b0, v0.16b
; CHECK-NEXT:    fmov w8, s0
; CHECK-NEXT:    and w0, w8, #0x1
; CHECK-NEXT:    ret
;
; GISEL-LABEL: test_redand_v16i1:
; GISEL:       // %bb.0:
; GISEL-NEXT:    umov w8, v0.b[0]
; GISEL-NEXT:    umov w9, v0.b[1]
; GISEL-NEXT:    umov w10, v0.b[2]
; GISEL-NEXT:    umov w11, v0.b[3]
; GISEL-NEXT:    umov w12, v0.b[4]
; GISEL-NEXT:    umov w13, v0.b[5]
; GISEL-NEXT:    umov w14, v0.b[6]
; GISEL-NEXT:    umov w15, v0.b[7]
; GISEL-NEXT:    umov w16, v0.b[8]
; GISEL-NEXT:    umov w17, v0.b[9]
; GISEL-NEXT:    umov w18, v0.b[10]
; GISEL-NEXT:    umov w0, v0.b[11]
; GISEL-NEXT:    and w8, w8, w9
; GISEL-NEXT:    umov w1, v0.b[12]
; GISEL-NEXT:    umov w2, v0.b[13]
; GISEL-NEXT:    and w9, w10, w11
; GISEL-NEXT:    and w10, w12, w13
; GISEL-NEXT:    umov w3, v0.b[14]
; GISEL-NEXT:    and w11, w14, w15
; GISEL-NEXT:    and w8, w8, w9
; GISEL-NEXT:    umov w4, v0.b[15]
; GISEL-NEXT:    and w12, w16, w17
; GISEL-NEXT:    and w13, w18, w0
; GISEL-NEXT:    and w9, w10, w11
; GISEL-NEXT:    and w14, w1, w2
; GISEL-NEXT:    and w10, w12, w13
; GISEL-NEXT:    and w8, w8, w9
; GISEL-NEXT:    and w15, w3, w4
; GISEL-NEXT:    and w11, w14, w15
; GISEL-NEXT:    and w9, w10, w11
; GISEL-NEXT:    and w8, w8, w9
; GISEL-NEXT:    and w0, w8, #0x1
; GISEL-NEXT:    ret
  %or_result = call i1 @llvm.vector.reduce.and.v16i1(<16 x i1> %a)
  ret i1 %or_result
}

define <16 x i1> @test_redand_ins_v16i1(<16 x i1> %a) {
; CHECK-LABEL: test_redand_ins_v16i1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    shl v0.16b, v0.16b, #7
; CHECK-NEXT:    cmlt v0.16b, v0.16b, #0
; CHECK-NEXT:    uminv b0, v0.16b
; CHECK-NEXT:    ret
;
; GISEL-LABEL: test_redand_ins_v16i1:
; GISEL:       // %bb.0:
; GISEL-NEXT:    umov w8, v0.b[0]
; GISEL-NEXT:    umov w9, v0.b[1]
; GISEL-NEXT:    umov w10, v0.b[2]
; GISEL-NEXT:    umov w11, v0.b[3]
; GISEL-NEXT:    umov w12, v0.b[4]
; GISEL-NEXT:    umov w13, v0.b[5]
; GISEL-NEXT:    umov w14, v0.b[6]
; GISEL-NEXT:    umov w15, v0.b[7]
; GISEL-NEXT:    umov w16, v0.b[8]
; GISEL-NEXT:    umov w17, v0.b[9]
; GISEL-NEXT:    umov w18, v0.b[10]
; GISEL-NEXT:    umov w0, v0.b[11]
; GISEL-NEXT:    and w8, w8, w9
; GISEL-NEXT:    umov w1, v0.b[12]
; GISEL-NEXT:    umov w2, v0.b[13]
; GISEL-NEXT:    and w9, w10, w11
; GISEL-NEXT:    and w10, w12, w13
; GISEL-NEXT:    umov w3, v0.b[14]
; GISEL-NEXT:    and w11, w14, w15
; GISEL-NEXT:    and w8, w8, w9
; GISEL-NEXT:    umov w4, v0.b[15]
; GISEL-NEXT:    and w12, w16, w17
; GISEL-NEXT:    and w13, w18, w0
; GISEL-NEXT:    and w9, w10, w11
; GISEL-NEXT:    and w14, w1, w2
; GISEL-NEXT:    and w10, w12, w13
; GISEL-NEXT:    and w8, w8, w9
; GISEL-NEXT:    and w15, w3, w4
; GISEL-NEXT:    and w11, w14, w15
; GISEL-NEXT:    and w9, w10, w11
; GISEL-NEXT:    and w8, w8, w9
; GISEL-NEXT:    fmov s0, w8
; GISEL-NEXT:    ret
  %and_result = call i1 @llvm.vector.reduce.and.v16i1(<16 x i1> %a)
  %ins = insertelement <16 x i1> poison, i1 %and_result, i64 0
  ret <16 x i1> %ins
}

define i8 @test_redand_v1i8(<1 x i8> %a) {
; CHECK-LABEL: test_redand_v1i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    umov w0, v0.b[0]
; CHECK-NEXT:    ret
;
; GISEL-LABEL: test_redand_v1i8:
; GISEL:       // %bb.0:
; GISEL-NEXT:    // kill: def $d0 killed $d0 def $q0
; GISEL-NEXT:    umov w0, v0.b[0]
; GISEL-NEXT:    ret
  %and_result = call i8 @llvm.vector.reduce.and.v1i8(<1 x i8> %a)
  ret i8 %and_result
}

define i8 @test_redand_v3i8(<3 x i8> %a) {
; CHECK-LABEL: test_redand_v3i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi d0, #0xff00ff00ff00ff
; CHECK-NEXT:    mov v0.h[0], w0
; CHECK-NEXT:    mov v0.h[1], w1
; CHECK-NEXT:    mov v0.h[2], w2
; CHECK-NEXT:    fmov x8, d0
; CHECK-NEXT:    and x8, x8, x8, lsr #32
; CHECK-NEXT:    lsr x9, x8, #16
; CHECK-NEXT:    and w0, w8, w9
; CHECK-NEXT:    ret
;
; GISEL-LABEL: test_redand_v3i8:
; GISEL:       // %bb.0:
; GISEL-NEXT:    and w8, w0, w1
; GISEL-NEXT:    and w0, w8, w2
; GISEL-NEXT:    ret
  %and_result = call i8 @llvm.vector.reduce.and.v3i8(<3 x i8> %a)
  ret i8 %and_result
}

define i8 @test_redand_v4i8(<4 x i8> %a) {
; CHECK-LABEL: test_redand_v4i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fmov x8, d0
; CHECK-NEXT:    and x8, x8, x8, lsr #32
; CHECK-NEXT:    lsr x9, x8, #16
; CHECK-NEXT:    and w0, w8, w9
; CHECK-NEXT:    ret
;
; GISEL-LABEL: test_redand_v4i8:
; GISEL:       // %bb.0:
; GISEL-NEXT:    // kill: def $d0 killed $d0 def $q0
; GISEL-NEXT:    umov w8, v0.h[0]
; GISEL-NEXT:    umov w9, v0.h[1]
; GISEL-NEXT:    umov w10, v0.h[2]
; GISEL-NEXT:    umov w11, v0.h[3]
; GISEL-NEXT:    and w8, w8, w9
; GISEL-NEXT:    and w9, w10, w11
; GISEL-NEXT:    and w0, w8, w9
; GISEL-NEXT:    ret
  %and_result = call i8 @llvm.vector.reduce.and.v4i8(<4 x i8> %a)
  ret i8 %and_result
}

define i8 @test_redand_v8i8(<8 x i8> %a) {
; CHECK-LABEL: test_redand_v8i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fmov x8, d0
; CHECK-NEXT:    and x8, x8, x8, lsr #32
; CHECK-NEXT:    and x8, x8, x8, lsr #16
; CHECK-NEXT:    lsr x9, x8, #8
; CHECK-NEXT:    and w0, w8, w9
; CHECK-NEXT:    ret
;
; GISEL-LABEL: test_redand_v8i8:
; GISEL:       // %bb.0:
; GISEL-NEXT:    // kill: def $d0 killed $d0 def $q0
; GISEL-NEXT:    umov w8, v0.b[0]
; GISEL-NEXT:    umov w9, v0.b[1]
; GISEL-NEXT:    umov w10, v0.b[2]
; GISEL-NEXT:    umov w11, v0.b[3]
; GISEL-NEXT:    umov w12, v0.b[4]
; GISEL-NEXT:    umov w13, v0.b[5]
; GISEL-NEXT:    umov w14, v0.b[6]
; GISEL-NEXT:    umov w15, v0.b[7]
; GISEL-NEXT:    and w8, w8, w9
; GISEL-NEXT:    and w9, w10, w11
; GISEL-NEXT:    and w10, w12, w13
; GISEL-NEXT:    and w11, w14, w15
; GISEL-NEXT:    and w8, w8, w9
; GISEL-NEXT:    and w9, w10, w11
; GISEL-NEXT:    and w0, w8, w9
; GISEL-NEXT:    ret
  %and_result = call i8 @llvm.vector.reduce.and.v8i8(<8 x i8> %a)
  ret i8 %and_result
}

define i8 @test_redand_v16i8(<16 x i8> %a) {
; CHECK-LABEL: test_redand_v16i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ext v1.16b, v0.16b, v0.16b, #8
; CHECK-NEXT:    and v0.8b, v0.8b, v1.8b
; CHECK-NEXT:    fmov x8, d0
; CHECK-NEXT:    and x8, x8, x8, lsr #32
; CHECK-NEXT:    and x8, x8, x8, lsr #16
; CHECK-NEXT:    lsr x9, x8, #8
; CHECK-NEXT:    and w0, w8, w9
; CHECK-NEXT:    ret
;
; GISEL-LABEL: test_redand_v16i8:
; GISEL:       // %bb.0:
; GISEL-NEXT:    mov d1, v0.d[1]
; GISEL-NEXT:    and v0.8b, v0.8b, v1.8b
; GISEL-NEXT:    umov w8, v0.b[0]
; GISEL-NEXT:    umov w9, v0.b[1]
; GISEL-NEXT:    umov w10, v0.b[2]
; GISEL-NEXT:    umov w11, v0.b[3]
; GISEL-NEXT:    umov w12, v0.b[4]
; GISEL-NEXT:    umov w13, v0.b[5]
; GISEL-NEXT:    umov w14, v0.b[6]
; GISEL-NEXT:    umov w15, v0.b[7]
; GISEL-NEXT:    and w8, w8, w9
; GISEL-NEXT:    and w9, w10, w11
; GISEL-NEXT:    and w10, w12, w13
; GISEL-NEXT:    and w11, w14, w15
; GISEL-NEXT:    and w8, w8, w9
; GISEL-NEXT:    and w9, w10, w11
; GISEL-NEXT:    and w0, w8, w9
; GISEL-NEXT:    ret
  %and_result = call i8 @llvm.vector.reduce.and.v16i8(<16 x i8> %a)
  ret i8 %and_result
}

define i8 @test_redand_v32i8(<32 x i8> %a) {
; CHECK-LABEL: test_redand_v32i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ext v1.16b, v0.16b, v0.16b, #8
; CHECK-NEXT:    and v0.8b, v0.8b, v1.8b
; CHECK-NEXT:    fmov x8, d0
; CHECK-NEXT:    and x8, x8, x8, lsr #32
; CHECK-NEXT:    and x8, x8, x8, lsr #16
; CHECK-NEXT:    lsr x9, x8, #8
; CHECK-NEXT:    and w0, w8, w9
; CHECK-NEXT:    ret
;
; GISEL-LABEL: test_redand_v32i8:
; GISEL:       // %bb.0:
; GISEL-NEXT:    and v0.16b, v0.16b, v1.16b
; GISEL-NEXT:    mov d1, v0.d[1]
; GISEL-NEXT:    and v0.8b, v0.8b, v1.8b
; GISEL-NEXT:    umov w8, v0.b[0]
; GISEL-NEXT:    umov w9, v0.b[1]
; GISEL-NEXT:    umov w10, v0.b[2]
; GISEL-NEXT:    umov w11, v0.b[3]
; GISEL-NEXT:    umov w12, v0.b[4]
; GISEL-NEXT:    umov w13, v0.b[5]
; GISEL-NEXT:    umov w14, v0.b[6]
; GISEL-NEXT:    umov w15, v0.b[7]
; GISEL-NEXT:    and w8, w8, w9
; GISEL-NEXT:    and w9, w10, w11
; GISEL-NEXT:    and w10, w12, w13
; GISEL-NEXT:    and w11, w14, w15
; GISEL-NEXT:    and w8, w8, w9
; GISEL-NEXT:    and w9, w10, w11
; GISEL-NEXT:    and w0, w8, w9
; GISEL-NEXT:    ret
  %and_result = call i8 @llvm.vector.reduce.and.v32i8(<32 x i8> %a)
  ret i8 %and_result
}

define i16 @test_redand_v4i16(<4 x i16> %a) {
; CHECK-LABEL: test_redand_v4i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fmov x8, d0
; CHECK-NEXT:    and x8, x8, x8, lsr #32
; CHECK-NEXT:    lsr x9, x8, #16
; CHECK-NEXT:    and w0, w8, w9
; CHECK-NEXT:    ret
;
; GISEL-LABEL: test_redand_v4i16:
; GISEL:       // %bb.0:
; GISEL-NEXT:    // kill: def $d0 killed $d0 def $q0
; GISEL-NEXT:    umov w8, v0.h[0]
; GISEL-NEXT:    umov w9, v0.h[1]
; GISEL-NEXT:    umov w10, v0.h[2]
; GISEL-NEXT:    umov w11, v0.h[3]
; GISEL-NEXT:    and w8, w8, w9
; GISEL-NEXT:    and w9, w10, w11
; GISEL-NEXT:    and w0, w8, w9
; GISEL-NEXT:    ret
  %and_result = call i16 @llvm.vector.reduce.and.v4i16(<4 x i16> %a)
  ret i16 %and_result
}

define i16 @test_redand_v8i16(<8 x i16> %a) {
; CHECK-LABEL: test_redand_v8i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ext v1.16b, v0.16b, v0.16b, #8
; CHECK-NEXT:    and v0.8b, v0.8b, v1.8b
; CHECK-NEXT:    fmov x8, d0
; CHECK-NEXT:    and x8, x8, x8, lsr #32
; CHECK-NEXT:    lsr x9, x8, #16
; CHECK-NEXT:    and w0, w8, w9
; CHECK-NEXT:    ret
;
; GISEL-LABEL: test_redand_v8i16:
; GISEL:       // %bb.0:
; GISEL-NEXT:    mov d1, v0.d[1]
; GISEL-NEXT:    and v0.8b, v0.8b, v1.8b
; GISEL-NEXT:    umov w8, v0.h[0]
; GISEL-NEXT:    umov w9, v0.h[1]
; GISEL-NEXT:    umov w10, v0.h[2]
; GISEL-NEXT:    umov w11, v0.h[3]
; GISEL-NEXT:    and w8, w8, w9
; GISEL-NEXT:    and w9, w10, w11
; GISEL-NEXT:    and w0, w8, w9
; GISEL-NEXT:    ret
  %and_result = call i16 @llvm.vector.reduce.and.v8i16(<8 x i16> %a)
  ret i16 %and_result
}

define i16 @test_redand_v16i16(<16 x i16> %a) {
; CHECK-LABEL: test_redand_v16i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ext v1.16b, v0.16b, v0.16b, #8
; CHECK-NEXT:    and v0.8b, v0.8b, v1.8b
; CHECK-NEXT:    fmov x8, d0
; CHECK-NEXT:    and x8, x8, x8, lsr #32
; CHECK-NEXT:    lsr x9, x8, #16
; CHECK-NEXT:    and w0, w8, w9
; CHECK-NEXT:    ret
;
; GISEL-LABEL: test_redand_v16i16:
; GISEL:       // %bb.0:
; GISEL-NEXT:    and v0.16b, v0.16b, v1.16b
; GISEL-NEXT:    mov d1, v0.d[1]
; GISEL-NEXT:    and v0.8b, v0.8b, v1.8b
; GISEL-NEXT:    umov w8, v0.h[0]
; GISEL-NEXT:    umov w9, v0.h[1]
; GISEL-NEXT:    umov w10, v0.h[2]
; GISEL-NEXT:    umov w11, v0.h[3]
; GISEL-NEXT:    and w8, w8, w9
; GISEL-NEXT:    and w9, w10, w11
; GISEL-NEXT:    and w0, w8, w9
; GISEL-NEXT:    ret
  %and_result = call i16 @llvm.vector.reduce.and.v16i16(<16 x i16> %a)
  ret i16 %and_result
}

define i32 @test_redand_v2i32(<2 x i32> %a) {
; CHECK-LABEL: test_redand_v2i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fmov x8, d0
; CHECK-NEXT:    lsr x9, x8, #32
; CHECK-NEXT:    and w0, w8, w9
; CHECK-NEXT:    ret
;
; GISEL-LABEL: test_redand_v2i32:
; GISEL:       // %bb.0:
; GISEL-NEXT:    // kill: def $d0 killed $d0 def $q0
; GISEL-NEXT:    mov s1, v0.s[1]
; GISEL-NEXT:    fmov w8, s0
; GISEL-NEXT:    fmov w9, s1
; GISEL-NEXT:    and w0, w8, w9
; GISEL-NEXT:    ret
  %and_result = call i32 @llvm.vector.reduce.and.v2i32(<2 x i32> %a)
  ret i32 %and_result
}

define i32 @test_redand_v4i32(<4 x i32> %a) {
; CHECK-LABEL: test_redand_v4i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ext v1.16b, v0.16b, v0.16b, #8
; CHECK-NEXT:    and v0.8b, v0.8b, v1.8b
; CHECK-NEXT:    fmov x8, d0
; CHECK-NEXT:    lsr x9, x8, #32
; CHECK-NEXT:    and w0, w8, w9
; CHECK-NEXT:    ret
;
; GISEL-LABEL: test_redand_v4i32:
; GISEL:       // %bb.0:
; GISEL-NEXT:    mov d1, v0.d[1]
; GISEL-NEXT:    and v0.8b, v0.8b, v1.8b
; GISEL-NEXT:    mov s1, v0.s[1]
; GISEL-NEXT:    fmov w8, s0
; GISEL-NEXT:    fmov w9, s1
; GISEL-NEXT:    and w0, w8, w9
; GISEL-NEXT:    ret
  %and_result = call i32 @llvm.vector.reduce.and.v4i32(<4 x i32> %a)
  ret i32 %and_result
}

define i32 @test_redand_v8i32(<8 x i32> %a) {
; CHECK-LABEL: test_redand_v8i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ext v1.16b, v0.16b, v0.16b, #8
; CHECK-NEXT:    and v0.8b, v0.8b, v1.8b
; CHECK-NEXT:    fmov x8, d0
; CHECK-NEXT:    lsr x9, x8, #32
; CHECK-NEXT:    and w0, w8, w9
; CHECK-NEXT:    ret
;
; GISEL-LABEL: test_redand_v8i32:
; GISEL:       // %bb.0:
; GISEL-NEXT:    and v0.16b, v0.16b, v1.16b
; GISEL-NEXT:    mov d1, v0.d[1]
; GISEL-NEXT:    and v0.8b, v0.8b, v1.8b
; GISEL-NEXT:    mov s1, v0.s[1]
; GISEL-NEXT:    fmov w8, s0
; GISEL-NEXT:    fmov w9, s1
; GISEL-NEXT:    and w0, w8, w9
; GISEL-NEXT:    ret
  %and_result = call i32 @llvm.vector.reduce.and.v8i32(<8 x i32> %a)
  ret i32 %and_result
}

define i64 @test_redand_v2i64(<2 x i64> %a) {
; CHECK-LABEL: test_redand_v2i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ext v1.16b, v0.16b, v0.16b, #8
; CHECK-NEXT:    and v0.8b, v0.8b, v1.8b
; CHECK-NEXT:    fmov x0, d0
; CHECK-NEXT:    ret
;
; GISEL-LABEL: test_redand_v2i64:
; GISEL:       // %bb.0:
; GISEL-NEXT:    mov d1, v0.d[1]
; GISEL-NEXT:    fmov x8, d0
; GISEL-NEXT:    fmov x9, d1
; GISEL-NEXT:    and x0, x8, x9
; GISEL-NEXT:    ret
  %and_result = call i64 @llvm.vector.reduce.and.v2i64(<2 x i64> %a)
  ret i64 %and_result
}

define i64 @test_redand_v4i64(<4 x i64> %a) {
; CHECK-LABEL: test_redand_v4i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ext v1.16b, v0.16b, v0.16b, #8
; CHECK-NEXT:    and v0.8b, v0.8b, v1.8b
; CHECK-NEXT:    fmov x0, d0
; CHECK-NEXT:    ret
;
; GISEL-LABEL: test_redand_v4i64:
; GISEL:       // %bb.0:
; GISEL-NEXT:    and v0.16b, v0.16b, v1.16b
; GISEL-NEXT:    mov d1, v0.d[1]
; GISEL-NEXT:    fmov x8, d0
; GISEL-NEXT:    fmov x9, d1
; GISEL-NEXT:    and x0, x8, x9
; GISEL-NEXT:    ret
  %and_result = call i64 @llvm.vector.reduce.and.v4i64(<4 x i64> %a)
  ret i64 %and_result
}

declare i1 @llvm.vector.reduce.and.v1i1(<1 x i1>)
declare i1 @llvm.vector.reduce.and.v2i1(<2 x i1>)
declare i1 @llvm.vector.reduce.and.v4i1(<4 x i1>)
declare i1 @llvm.vector.reduce.and.v8i1(<8 x i1>)
declare i1 @llvm.vector.reduce.and.v16i1(<16 x i1>)
declare i64 @llvm.vector.reduce.and.v2i64(<2 x i64>)
declare i64 @llvm.vector.reduce.and.v4i64(<4 x i64>)
declare i32 @llvm.vector.reduce.and.v2i32(<2 x i32>)
declare i32 @llvm.vector.reduce.and.v4i32(<4 x i32>)
declare i32 @llvm.vector.reduce.and.v8i32(<8 x i32>)
declare i16 @llvm.vector.reduce.and.v4i16(<4 x i16>)
declare i16 @llvm.vector.reduce.and.v8i16(<8 x i16>)
declare i16 @llvm.vector.reduce.and.v16i16(<16 x i16>)
declare i8 @llvm.vector.reduce.and.v1i8(<1 x i8>)
declare i8 @llvm.vector.reduce.and.v3i8(<3 x i8>)
declare i8 @llvm.vector.reduce.and.v4i8(<4 x i8>)
declare i8 @llvm.vector.reduce.and.v8i8(<8 x i8>)
declare i8 @llvm.vector.reduce.and.v16i8(<16 x i8>)
declare i8 @llvm.vector.reduce.and.v32i8(<32 x i8>)
