; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -interleaved-access -S | FileCheck %s
; RUN: opt < %s -passes=interleaved-access -S | FileCheck %s

target datalayout = "e-m:e-i64:64-i128:128-n32:64-S128"
target triple = "aarch64--linux-gnu"

define <4 x float> @vld2(ptr %pSrc) {
; CHECK-LABEL: @vld2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[LDN:%.*]] = call { <4 x float>, <4 x float> } @llvm.aarch64.neon.ld2.v4f32.p0(ptr [[PSRC:%.*]])
; CHECK-NEXT:    [[TMP0:%.*]] = extractvalue { <4 x float>, <4 x float> } [[LDN]], 1
; CHECK-NEXT:    [[TMP1:%.*]] = extractvalue { <4 x float>, <4 x float> } [[LDN]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = extractvalue { <4 x float>, <4 x float> } [[LDN]], 0
; CHECK-NEXT:    [[TMP3:%.*]] = extractvalue { <4 x float>, <4 x float> } [[LDN]], 0
; CHECK-NEXT:    [[L26:%.*]] = fmul fast <4 x float> [[TMP2]], [[TMP3]]
; CHECK-NEXT:    [[L43:%.*]] = fmul fast <4 x float> [[TMP0]], [[TMP1]]
; CHECK-NEXT:    [[L6:%.*]] = fadd fast <4 x float> [[L43]], [[L26]]
; CHECK-NEXT:    ret <4 x float> [[L6]]
;
entry:
  %wide.vec = load <8 x float>, ptr %pSrc, align 4
  %l2 = fmul fast <8 x float> %wide.vec, %wide.vec
  %l3 = shufflevector <8 x float> %l2, <8 x float> undef, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %l4 = fmul fast <8 x float> %wide.vec, %wide.vec
  %l5 = shufflevector <8 x float> %l4, <8 x float> undef, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  %l6 = fadd fast <4 x float> %l5, %l3
  ret <4 x float> %l6
}

define <4 x float> @vld3(ptr %pSrc) {
; CHECK-LABEL: @vld3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[LDN:%.*]] = call { <4 x float>, <4 x float>, <4 x float> } @llvm.aarch64.neon.ld3.v4f32.p0(ptr [[PSRC:%.*]])
; CHECK-NEXT:    [[TMP0:%.*]] = extractvalue { <4 x float>, <4 x float>, <4 x float> } [[LDN]], 2
; CHECK-NEXT:    [[TMP1:%.*]] = extractvalue { <4 x float>, <4 x float>, <4 x float> } [[LDN]], 2
; CHECK-NEXT:    [[TMP2:%.*]] = extractvalue { <4 x float>, <4 x float>, <4 x float> } [[LDN]], 1
; CHECK-NEXT:    [[TMP3:%.*]] = extractvalue { <4 x float>, <4 x float>, <4 x float> } [[LDN]], 1
; CHECK-NEXT:    [[TMP4:%.*]] = extractvalue { <4 x float>, <4 x float>, <4 x float> } [[LDN]], 0
; CHECK-NEXT:    [[TMP5:%.*]] = extractvalue { <4 x float>, <4 x float>, <4 x float> } [[LDN]], 0
; CHECK-NEXT:    [[L29:%.*]] = fmul fast <4 x float> [[TMP4]], [[TMP5]]
; CHECK-NEXT:    [[L46:%.*]] = fmul fast <4 x float> [[TMP2]], [[TMP3]]
; CHECK-NEXT:    [[L6:%.*]] = fadd fast <4 x float> [[L46]], [[L29]]
; CHECK-NEXT:    [[L73:%.*]] = fmul fast <4 x float> [[TMP0]], [[TMP1]]
; CHECK-NEXT:    [[L9:%.*]] = fadd fast <4 x float> [[L6]], [[L73]]
; CHECK-NEXT:    ret <4 x float> [[L9]]
;
entry:
  %wide.vec = load <12 x float>, ptr %pSrc, align 4
  %l2 = fmul fast <12 x float> %wide.vec, %wide.vec
  %l3 = shufflevector <12 x float> %l2, <12 x float> undef, <4 x i32> <i32 0, i32 3, i32 6, i32 9>
  %l4 = fmul fast <12 x float> %wide.vec, %wide.vec
  %l5 = shufflevector <12 x float> %l4, <12 x float> undef, <4 x i32> <i32 1, i32 4, i32 7, i32 10>
  %l6 = fadd fast <4 x float> %l5, %l3
  %l7 = fmul fast <12 x float> %wide.vec, %wide.vec
  %l8 = shufflevector <12 x float> %l7, <12 x float> undef, <4 x i32> <i32 2, i32 5, i32 8, i32 11>
  %l9 = fadd fast <4 x float> %l6, %l8
  ret <4 x float> %l9
}

define <4 x float> @vld4(ptr %pSrc) {
; CHECK-LABEL: @vld4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[LDN:%.*]] = call { <4 x float>, <4 x float>, <4 x float>, <4 x float> } @llvm.aarch64.neon.ld4.v4f32.p0(ptr [[PSRC:%.*]])
; CHECK-NEXT:    [[TMP0:%.*]] = extractvalue { <4 x float>, <4 x float>, <4 x float>, <4 x float> } [[LDN]], 3
; CHECK-NEXT:    [[TMP1:%.*]] = extractvalue { <4 x float>, <4 x float>, <4 x float>, <4 x float> } [[LDN]], 3
; CHECK-NEXT:    [[TMP2:%.*]] = extractvalue { <4 x float>, <4 x float>, <4 x float>, <4 x float> } [[LDN]], 2
; CHECK-NEXT:    [[TMP3:%.*]] = extractvalue { <4 x float>, <4 x float>, <4 x float>, <4 x float> } [[LDN]], 2
; CHECK-NEXT:    [[TMP4:%.*]] = extractvalue { <4 x float>, <4 x float>, <4 x float>, <4 x float> } [[LDN]], 1
; CHECK-NEXT:    [[TMP5:%.*]] = extractvalue { <4 x float>, <4 x float>, <4 x float>, <4 x float> } [[LDN]], 1
; CHECK-NEXT:    [[TMP6:%.*]] = extractvalue { <4 x float>, <4 x float>, <4 x float>, <4 x float> } [[LDN]], 0
; CHECK-NEXT:    [[TMP7:%.*]] = extractvalue { <4 x float>, <4 x float>, <4 x float>, <4 x float> } [[LDN]], 0
; CHECK-NEXT:    [[L312:%.*]] = fmul fast <4 x float> [[TMP6]], [[TMP7]]
; CHECK-NEXT:    [[L59:%.*]] = fmul fast <4 x float> [[TMP4]], [[TMP5]]
; CHECK-NEXT:    [[L7:%.*]] = fadd fast <4 x float> [[L59]], [[L312]]
; CHECK-NEXT:    [[L86:%.*]] = fmul fast <4 x float> [[TMP2]], [[TMP3]]
; CHECK-NEXT:    [[L103:%.*]] = fmul fast <4 x float> [[TMP0]], [[TMP1]]
; CHECK-NEXT:    [[L12:%.*]] = fadd fast <4 x float> [[L103]], [[L86]]
; CHECK-NEXT:    ret <4 x float> [[L12]]
;
entry:
  %wide.vec = load <16 x float>, ptr %pSrc, align 4
  %l3 = fmul fast <16 x float> %wide.vec, %wide.vec
  %l4 = shufflevector <16 x float> %l3, <16 x float> undef, <4 x i32> <i32 0, i32 4, i32 8, i32 12>
  %l5 = fmul fast <16 x float> %wide.vec, %wide.vec
  %l6 = shufflevector <16 x float> %l5, <16 x float> undef, <4 x i32> <i32 1, i32 5, i32 9, i32 13>
  %l7 = fadd fast <4 x float> %l6, %l4
  %l8 = fmul fast <16 x float> %wide.vec, %wide.vec
  %l9 = shufflevector <16 x float> %l8, <16 x float> undef, <4 x i32> <i32 2, i32 6, i32 10, i32 14>
  %l10 = fmul fast <16 x float> %wide.vec, %wide.vec
  %l11 = shufflevector <16 x float> %l10, <16 x float> undef, <4 x i32> <i32 3, i32 7, i32 11, i32 15>
  %l12 = fadd fast <4 x float> %l11, %l9
  ret <4 x float> %l12
}

define <4 x float> @twosrc(ptr %pSrc1, ptr %pSrc2) {
; CHECK-LABEL: @twosrc(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[LDN:%.*]] = call { <4 x float>, <4 x float> } @llvm.aarch64.neon.ld2.v4f32.p0(ptr [[PSRC1:%.*]])
; CHECK-NEXT:    [[TMP0:%.*]] = extractvalue { <4 x float>, <4 x float> } [[LDN]], 1
; CHECK-NEXT:    [[TMP1:%.*]] = extractvalue { <4 x float>, <4 x float> } [[LDN]], 0
; CHECK-NEXT:    [[LDN7:%.*]] = call { <4 x float>, <4 x float> } @llvm.aarch64.neon.ld2.v4f32.p0(ptr [[PSRC2:%.*]])
; CHECK-NEXT:    [[TMP2:%.*]] = extractvalue { <4 x float>, <4 x float> } [[LDN7]], 0
; CHECK-NEXT:    [[TMP3:%.*]] = extractvalue { <4 x float>, <4 x float> } [[LDN7]], 1
; CHECK-NEXT:    [[L46:%.*]] = fmul fast <4 x float> [[TMP2]], [[TMP1]]
; CHECK-NEXT:    [[L63:%.*]] = fmul fast <4 x float> [[TMP3]], [[TMP0]]
; CHECK-NEXT:    [[L8:%.*]] = fadd fast <4 x float> [[L63]], [[L46]]
; CHECK-NEXT:    ret <4 x float> [[L8]]
;
entry:
  %wide.vec = load <8 x float>, ptr %pSrc1, align 4
  %wide.vec26 = load <8 x float>, ptr %pSrc2, align 4
  %l4 = fmul fast <8 x float> %wide.vec26, %wide.vec
  %l5 = shufflevector <8 x float> %l4, <8 x float> undef, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %l6 = fmul fast <8 x float> %wide.vec26, %wide.vec
  %l7 = shufflevector <8 x float> %l6, <8 x float> undef, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  %l8 = fadd fast <4 x float> %l7, %l5
  ret <4 x float> %l8
}

define <4 x float> @twosrc2(ptr %pSrc1, ptr %pSrc2) {
; CHECK-LABEL: @twosrc2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[LDN:%.*]] = call { <4 x float>, <4 x float> } @llvm.aarch64.neon.ld2.v4f32.p0(ptr [[PSRC1:%.*]])
; CHECK-NEXT:    [[TMP0:%.*]] = extractvalue { <4 x float>, <4 x float> } [[LDN]], 1
; CHECK-NEXT:    [[TMP1:%.*]] = extractvalue { <4 x float>, <4 x float> } [[LDN]], 0
; CHECK-NEXT:    [[LDN4:%.*]] = call { <4 x float>, <4 x float> } @llvm.aarch64.neon.ld2.v4f32.p0(ptr [[PSRC2:%.*]])
; CHECK-NEXT:    [[TMP2:%.*]] = extractvalue { <4 x float>, <4 x float> } [[LDN4]], 0
; CHECK-NEXT:    [[TMP3:%.*]] = extractvalue { <4 x float>, <4 x float> } [[LDN4]], 1
; CHECK-NEXT:    [[L43:%.*]] = fmul fast <4 x float> [[TMP2]], [[TMP1]]
; CHECK-NEXT:    [[L6:%.*]] = fmul fast <4 x float> [[TMP3]], [[TMP0]]
; CHECK-NEXT:    [[L8:%.*]] = fadd fast <4 x float> [[L6]], [[L43]]
; CHECK-NEXT:    ret <4 x float> [[L8]]
;
entry:
  %wide.vec = load <8 x float>, ptr %pSrc1, align 4
  %wide.vec26 = load <8 x float>, ptr %pSrc2, align 4
  %l4 = fmul fast <8 x float> %wide.vec26, %wide.vec
  %l5 = shufflevector <8 x float> %l4, <8 x float> undef, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %s1 = shufflevector <8 x float> %wide.vec26, <8 x float> undef, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  %s2 = shufflevector <8 x float> %wide.vec, <8 x float> undef, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  %l6 = fmul fast <4 x float> %s1, %s2
  %l8 = fadd fast <4 x float> %l6, %l5
  ret <4 x float> %l8
}

define void @noncanonical(ptr %p0, ptr %p1, ptr %p2) {
; CHECK-LABEL: @noncanonical(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[V0:%.*]] = load <8 x i8>, ptr [[P0:%.*]], align 8
; CHECK-NEXT:    [[V1:%.*]] = add <8 x i8> [[V0]], <i8 0, i8 1, i8 2, i8 3, i8 7, i8 7, i8 7, i8 7>
; CHECK-NEXT:    [[V2:%.*]] = load <8 x i8>, ptr [[P1:%.*]], align 8
; CHECK-NEXT:    [[SHUFFLED:%.*]] = shufflevector <8 x i8> [[V2]], <8 x i8> [[V1]], <4 x i32> <i32 0, i32 2, i32 4, i32 6>
; CHECK-NEXT:    store <4 x i8> [[SHUFFLED]], ptr [[P2:%.*]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %v0 = load <8 x i8>, ptr %p0
  %v1 = add <8 x i8> %v0, <i8 0, i8 1, i8 2, i8 3, i8 7, i8 7, i8 7, i8 7>
  %v2 = load <8 x i8>, ptr %p1
  %shuffled = shufflevector <8 x i8> %v2, <8 x i8> %v1, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  store <4 x i8> %shuffled, ptr %p2
  ret void
}

define void @noncanonical2(ptr %p0, ptr %p1, ptr %p2) {
; CHECK-LABEL: @noncanonical2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[V0:%.*]] = load <8 x i8>, ptr [[P0:%.*]], align 8
; CHECK-NEXT:    [[V1:%.*]] = load <8 x i8>, ptr [[P1:%.*]], align 8
; CHECK-NEXT:    [[V2:%.*]] = add <8 x i8> [[V0]], [[V1]]
; CHECK-NEXT:    [[SHUFFLED:%.*]] = shufflevector <8 x i8> undef, <8 x i8> [[V2]], <4 x i32> <i32 0, i32 2, i32 4, i32 6>
; CHECK-NEXT:    store <4 x i8> [[SHUFFLED]], ptr [[P2:%.*]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %v0 = load <8 x i8>, ptr %p0
  %v1 = load <8 x i8>, ptr %p1
  %v2 = add <8 x i8> %v0, %v1
  %shuffled = shufflevector <8 x i8> undef, <8 x i8> %v2, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  store <4 x i8> %shuffled, ptr %p2
  ret void
}

define <4 x float> @noncanonical3(ptr %pSrc) {
; CHECK-LABEL: @noncanonical3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[WIDE_VEC:%.*]] = load <8 x float>, ptr [[PSRC:%.*]], align 4
; CHECK-NEXT:    [[L2:%.*]] = fmul fast <8 x float> [[WIDE_VEC]], [[WIDE_VEC]]
; CHECK-NEXT:    [[L3:%.*]] = shufflevector <8 x float> undef, <8 x float> [[L2]], <4 x i32> <i32 8, i32 10, i32 12, i32 14>
; CHECK-NEXT:    [[L4:%.*]] = fmul fast <8 x float> [[WIDE_VEC]], [[WIDE_VEC]]
; CHECK-NEXT:    [[L5:%.*]] = shufflevector <8 x float> [[L4]], <8 x float> undef, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
; CHECK-NEXT:    [[L6:%.*]] = fadd fast <4 x float> [[L5]], [[L3]]
; CHECK-NEXT:    ret <4 x float> [[L6]]
;
entry:
  %wide.vec = load <8 x float>, ptr %pSrc, align 4
  %l2 = fmul fast <8 x float> %wide.vec, %wide.vec
  %l3 = shufflevector <8 x float> undef, <8 x float> %l2, <4 x i32> <i32 8, i32 10, i32 12, i32 14>
  %l4 = fmul fast <8 x float> %wide.vec, %wide.vec
  %l5 = shufflevector <8 x float> %l4, <8 x float> undef, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  %l6 = fadd fast <4 x float> %l5, %l3
  ret <4 x float> %l6
}

define void @noncanonical_extmask(ptr %p0, ptr %p1, ptr %p2) {
; CHECK-LABEL: @noncanonical_extmask(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[V0:%.*]] = load <8 x i8>, ptr [[P0:%.*]], align 8
; CHECK-NEXT:    [[V1:%.*]] = add <8 x i8> [[V0]], <i8 0, i8 1, i8 2, i8 3, i8 7, i8 7, i8 7, i8 7>
; CHECK-NEXT:    [[V2:%.*]] = load <8 x i8>, ptr [[P1:%.*]], align 8
; CHECK-NEXT:    [[SHUFFLED:%.*]] = shufflevector <8 x i8> [[V2]], <8 x i8> [[V1]], <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14>
; CHECK-NEXT:    store <8 x i8> [[SHUFFLED]], ptr [[P2:%.*]], align 8
; CHECK-NEXT:    ret void
;
entry:
  %v0 = load <8 x i8>, ptr %p0
  %v1 = add <8 x i8> %v0, <i8 0, i8 1, i8 2, i8 3, i8 7, i8 7, i8 7, i8 7>
  %v2 = load <8 x i8>, ptr %p1
  %shuffled = shufflevector <8 x i8> %v2, <8 x i8> %v1, <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14>
  store <8 x i8> %shuffled, ptr %p2
  ret void
}

define void @skip_optimizing_dead_binop(ptr %p0, ptr %p1) {
; CHECK-LABEL: @skip_optimizing_dead_binop(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[V0:%.*]] = load <8 x double>, ptr [[P0:%.*]]
; CHECK-NEXT:    [[SHUFFLED_1:%.*]] = shufflevector <8 x double> [[V0]], <8 x double> undef, <2 x i32> <i32 0, i32 4>
; CHECK-NEXT:    [[SHUFFLED_2:%.*]] = shufflevector <8 x double> [[V0]], <8 x double> undef, <2 x i32> <i32 1, i32 5>
; CHECK-NEXT:    [[SHUFFLED_3:%.*]] = shufflevector <8 x double> [[V0]], <8 x double> undef, <2 x i32> <i32 2, i32 6>
; CHECK-NEXT:    [[SHUFFLED_4:%.*]] = shufflevector <8 x double> [[V0]], <8 x double> undef, <2 x i32> <i32 3, i32 7>
; CHECK-NEXT:    [[DEAD_BINOP:%.*]] = fadd <8 x double> [[V0]], [[V0]]
; CHECK-NEXT:    ret void
;
entry:
  %v0 = load <8 x double>, ptr %p0
  %shuffled_1 = shufflevector <8 x double> %v0, <8 x double> undef, <2 x i32> <i32 0, i32 4>
  %shuffled_2 = shufflevector <8 x double> %v0, <8 x double> undef, <2 x i32> <i32 1, i32 5>
  %shuffled_3 = shufflevector <8 x double> %v0, <8 x double> undef, <2 x i32> <i32 2, i32 6>
  %shuffled_4 = shufflevector <8 x double> %v0, <8 x double> undef, <2 x i32> <i32 3, i32 7>
  %dead_binop = fadd <8 x double> %v0, %v0
  ret void
}
