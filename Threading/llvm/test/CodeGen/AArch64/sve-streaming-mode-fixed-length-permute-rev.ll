; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mattr=+sve -force-streaming-compatible-sve < %s | FileCheck %s
; RUN: llc -mattr=+sme -force-streaming-compatible-sve < %s | FileCheck %s


target triple = "aarch64-unknown-linux-gnu"

; REVB pattern for shuffle v32i8 -> v16i16
define void @test_revbv16i16(ptr %a) {
; CHECK-LABEL: test_revbv16i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    ldp q0, q1, [x0]
; CHECK-NEXT:    revb z0.h, p0/m, z0.h
; CHECK-NEXT:    revb z1.h, p0/m, z1.h
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
  %tmp1 = load <32 x i8>, ptr %a
  %tmp2 = shufflevector <32 x i8> %tmp1, <32 x i8> undef, <32 x i32> <i32 1, i32 0, i32 3, i32 2, i32 5, i32 4, i32 7, i32 6, i32 9, i32 8, i32 11, i32 10, i32 13, i32 12, i32 15, i32 14, i32 17, i32 16, i32 19, i32 18, i32 21, i32 20, i32 23, i32 22, i32 undef, i32 24, i32 27, i32 undef, i32 29, i32 28, i32 undef, i32 undef>
  store <32 x i8> %tmp2, ptr %a
  ret void
}

; REVB pattern for shuffle v32i8 -> v8i32
define void @test_revbv8i32(ptr %a) {
; CHECK-LABEL: test_revbv8i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    ldp q0, q1, [x0]
; CHECK-NEXT:    revb z0.s, p0/m, z0.s
; CHECK-NEXT:    revb z1.s, p0/m, z1.s
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
  %tmp1 = load <32 x i8>, ptr %a
  %tmp2 = shufflevector <32 x i8> %tmp1, <32 x i8> undef, <32 x i32> <i32 3, i32 2, i32 1, i32 0, i32 7, i32 6, i32 5, i32 4, i32 11, i32 10, i32 9, i32 8, i32 15, i32 14, i32 13, i32 12, i32 19, i32 18, i32 17, i32 16, i32 23, i32 22, i32 21, i32 20, i32 27, i32 undef, i32 undef, i32 undef, i32 31, i32 30, i32 29, i32 undef>
  store <32 x i8> %tmp2, ptr %a
  ret void
}

; REVB pattern for shuffle v32i8 -> v4i64
define void @test_revbv4i64(ptr %a) {
; CHECK-LABEL: test_revbv4i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    ldp q0, q1, [x0]
; CHECK-NEXT:    revb z0.d, p0/m, z0.d
; CHECK-NEXT:    revb z1.d, p0/m, z1.d
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
  %tmp1 = load <32 x i8>, ptr %a
  %tmp2 = shufflevector <32 x i8> %tmp1, <32 x i8> undef, <32 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0, i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 23, i32 22, i32 21, i32 20, i32 19, i32 18, i32 17, i32 16, i32 31, i32 30, i32 29, i32 undef, i32 27, i32 undef, i32 undef, i32 undef>
  store <32 x i8> %tmp2, ptr %a
  ret void
}

; REVH pattern for shuffle v16i16 -> v8i32
define void @test_revhv8i32(ptr %a) {
; CHECK-LABEL: test_revhv8i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    ldp q0, q1, [x0]
; CHECK-NEXT:    revh z0.s, p0/m, z0.s
; CHECK-NEXT:    revh z1.s, p0/m, z1.s
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
  %tmp1 = load <16 x i16>, ptr %a
  %tmp2 = shufflevector <16 x i16> %tmp1, <16 x i16> undef, <16 x i32> <i32 1, i32 0, i32 3, i32 2, i32 5, i32 4, i32 7, i32 6, i32 9, i32 8, i32 11, i32 10, i32 13, i32 12, i32 15, i32 14>
  store <16 x i16> %tmp2, ptr %a
  ret void
}

; REVH pattern for shuffle v16f16 -> v8f32
define void @test_revhv8f32(ptr %a) {
; CHECK-LABEL: test_revhv8f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    ldp q0, q1, [x0]
; CHECK-NEXT:    revh z0.s, p0/m, z0.s
; CHECK-NEXT:    revh z1.s, p0/m, z1.s
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
  %tmp1 = load <16 x half>, ptr %a
  %tmp2 = shufflevector <16 x half> %tmp1, <16 x half> undef, <16 x i32> <i32 1, i32 0, i32 3, i32 2, i32 5, i32 4, i32 7, i32 6, i32 9, i32 8, i32 11, i32 10, i32 13, i32 12, i32 15, i32 14>
  store <16 x half> %tmp2, ptr %a
  ret void
}

; REVH pattern for shuffle v16i16 -> v4i64
define void @test_revhv4i64(ptr %a) {
; CHECK-LABEL: test_revhv4i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    ldp q0, q1, [x0]
; CHECK-NEXT:    revh z0.d, p0/m, z0.d
; CHECK-NEXT:    revh z1.d, p0/m, z1.d
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
  %tmp1 = load <16 x i16>, ptr %a
  %tmp2 = shufflevector <16 x i16> %tmp1, <16 x i16> undef, <16 x i32> <i32 3, i32 2, i32 1, i32 0, i32 7, i32 6, i32 5, i32 4, i32 11, i32 10, i32 9, i32 8, i32 15, i32 14, i32 13, i32 12>
  store <16 x i16> %tmp2, ptr %a
  ret void
}

; REVW pattern for shuffle v8i32 -> v4i64
define void @test_revwv4i64(ptr %a) {
; CHECK-LABEL: test_revwv4i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    ldp q0, q1, [x0]
; CHECK-NEXT:    revw z0.d, p0/m, z0.d
; CHECK-NEXT:    revw z1.d, p0/m, z1.d
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
  %tmp1 = load <8 x i32>, ptr %a
  %tmp2 = shufflevector <8 x i32> %tmp1, <8 x i32> undef, <8 x i32> <i32 1, i32 0, i32 3, i32 2, i32 5, i32 4, i32 7, i32 6>
  store <8 x i32> %tmp2, ptr %a
  ret void
}

; REVW pattern for shuffle v8f32 -> v4f64
define void @test_revwv4f64(ptr %a) {
; CHECK-LABEL: test_revwv4f64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    ldp q0, q1, [x0]
; CHECK-NEXT:    revw z0.d, p0/m, z0.d
; CHECK-NEXT:    revw z1.d, p0/m, z1.d
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
  %tmp1 = load <8 x float>, ptr %a
  %tmp2 = shufflevector <8 x float> %tmp1, <8 x float> undef, <8 x i32> <i32 1, i32 0, i32 3, i32 2, i32 5, i32 4, i32 7, i32 6>
  store <8 x float> %tmp2, ptr %a
  ret void
}

define <16 x i8> @test_revv16i8(ptr %a) {
; CHECK-LABEL: test_revv16i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    ldr q0, [x0]
; CHECK-NEXT:    revb z0.d, p0/m, z0.d
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %tmp1 = load <16 x i8>, ptr %a
  %tmp2 = shufflevector <16 x i8> %tmp1, <16 x i8> undef, <16 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0, i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8>
  ret <16 x i8> %tmp2
}

; REVW pattern for shuffle two v8i32 inputs with the second input available.
define void @test_revwv8i32v8i32(ptr %a, ptr %b) {
; CHECK-LABEL: test_revwv8i32v8i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    ldp q0, q1, [x1]
; CHECK-NEXT:    revw z0.d, p0/m, z0.d
; CHECK-NEXT:    revw z1.d, p0/m, z1.d
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
  %tmp1 = load <8 x i32>, ptr %a
  %tmp2 = load <8 x i32>, ptr %b
  %tmp3 = shufflevector <8 x i32> %tmp1, <8 x i32> %tmp2, <8 x i32> <i32 9, i32 8, i32 11, i32 10, i32 13, i32 12, i32 15, i32 14>
  store <8 x i32> %tmp3, ptr %a
  ret void
}

define void @test_revhv32i16(ptr %a) {
; CHECK-LABEL: test_revhv32i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    ldp q0, q1, [x0, #32]
; CHECK-NEXT:    ldp q2, q3, [x0]
; CHECK-NEXT:    revh z0.d, p0/m, z0.d
; CHECK-NEXT:    revh z1.d, p0/m, z1.d
; CHECK-NEXT:    revh z2.d, p0/m, z2.d
; CHECK-NEXT:    revh z3.d, p0/m, z3.d
; CHECK-NEXT:    stp q0, q1, [x0, #32]
; CHECK-NEXT:    stp q2, q3, [x0]
; CHECK-NEXT:    ret
  %tmp1 = load <32 x i16>, ptr %a
  %tmp2 = shufflevector <32 x i16> %tmp1, <32 x i16> undef, <32 x i32> <i32 3, i32 2, i32 1, i32 0, i32 7, i32 6, i32 5, i32 4, i32 11, i32 10, i32 9, i32 8, i32 15, i32 14, i32 13, i32 12, i32 19, i32 18, i32 17, i32 16, i32 23, i32 22, i32 21, i32 20, i32 27, i32 undef, i32 undef, i32 undef, i32 31, i32 30, i32 29, i32 undef>
  store <32 x i16> %tmp2, ptr %a
  ret void
}

define void @test_rev_elts_fail(ptr %a) {
; CHECK-LABEL: test_rev_elts_fail:
; CHECK:       // %bb.0:
; CHECK-NEXT:    index z0.d, #1, #-1
; CHECK-NEXT:    ldp q1, q2, [x0]
; CHECK-NEXT:    tbl z1.d, { z1.d }, z0.d
; CHECK-NEXT:    tbl z0.d, { z2.d }, z0.d
; CHECK-NEXT:    stp q1, q0, [x0]
; CHECK-NEXT:    ret
  %tmp1 = load <4 x i64>, ptr %a
  %tmp2 = shufflevector <4 x i64> %tmp1, <4 x i64> undef, <4 x i32> <i32 1, i32 0, i32 3, i32 2>
  store <4 x i64> %tmp2, ptr %a
  ret void
}

; This is the same test as above, but with sve2p1 it can use the REVD instruction to reverse
; the double-words within quard-words.
define void @test_revdv4i64_sve2p1(ptr %a) #1 {
; CHECK-LABEL: test_revdv4i64_sve2p1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d, vl2
; CHECK-NEXT:    ldp q0, q1, [x0]
; CHECK-NEXT:    revd z0.q, p0/m, z0.q
; CHECK-NEXT:    revd z1.q, p0/m, z1.q
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
  %tmp1 = load <4 x i64>, ptr %a
  %tmp2 = shufflevector <4 x i64> %tmp1, <4 x i64> undef, <4 x i32> <i32 1, i32 0, i32 3, i32 2>
  store <4 x i64> %tmp2, ptr %a
  ret void
}

define void @test_revdv4f64_sve2p1(ptr %a) #1 {
; CHECK-LABEL: test_revdv4f64_sve2p1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    ldp q0, q1, [x0]
; CHECK-NEXT:    revd z0.q, p0/m, z0.q
; CHECK-NEXT:    revd z1.q, p0/m, z1.q
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
  %tmp1 = load <4 x double>, ptr %a
  %tmp2 = shufflevector <4 x double> %tmp1, <4 x double> undef, <4 x i32> <i32 1, i32 0, i32 3, i32 2>
  store <4 x double> %tmp2, ptr %a
  ret void
}

define void @test_revv8i32(ptr %a) {
; CHECK-LABEL: test_revv8i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    index z0.s, #3, #-1
; CHECK-NEXT:    ldp q2, q1, [x0]
; CHECK-NEXT:    tbl z1.s, { z1.s }, z0.s
; CHECK-NEXT:    tbl z0.s, { z2.s }, z0.s
; CHECK-NEXT:    stp q1, q0, [x0]
; CHECK-NEXT:    ret
  %tmp1 = load <8 x i32>, ptr %a
  %tmp2 = shufflevector <8 x i32> %tmp1, <8 x i32> undef, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  store <8 x i32> %tmp2, ptr %a
  ret void
}
attributes #1 = { "target-features"="+sve2p1" }
