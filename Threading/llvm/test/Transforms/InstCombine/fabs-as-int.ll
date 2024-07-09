; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 2
; RUN: opt -S -passes=instcombine %s | FileCheck %s

define float @fabs_as_int_f32_castback_noimplicitfloat(float %val) noimplicitfloat {
; CHECK-LABEL: define float @fabs_as_int_f32_castback_noimplicitfloat
; CHECK-SAME: (float [[VAL:%.*]]) #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:    [[BITCAST:%.*]] = bitcast float [[VAL]] to i32
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[BITCAST]], 2147483647
; CHECK-NEXT:    [[FABS:%.*]] = bitcast i32 [[AND]] to float
; CHECK-NEXT:    ret float [[FABS]]
;
  %bitcast = bitcast float %val to i32
  %and = and i32 %bitcast, 2147483647
  %fabs = bitcast i32 %and to float
  ret float %fabs
}

define <2 x i32> @fabs_as_int_v2f32_noimplicitfloat(<2 x float> %x) noimplicitfloat {
; CHECK-LABEL: define <2 x i32> @fabs_as_int_v2f32_noimplicitfloat
; CHECK-SAME: (<2 x float> [[X:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[BC:%.*]] = bitcast <2 x float> [[X]] to <2 x i32>
; CHECK-NEXT:    [[AND:%.*]] = and <2 x i32> [[BC]], <i32 2147483647, i32 2147483647>
; CHECK-NEXT:    ret <2 x i32> [[AND]]
;
  %bc = bitcast <2 x float> %x to <2 x i32>
  %and = and <2 x i32> %bc, <i32 2147483647, i32 2147483647>
  ret <2 x i32> %and
}

define float @fabs_as_int_f32_castback(float %val) {
; CHECK-LABEL: define float @fabs_as_int_f32_castback
; CHECK-SAME: (float [[VAL:%.*]]) {
; CHECK-NEXT:    [[TMP1:%.*]] = call float @llvm.fabs.f32(float [[VAL]])
; CHECK-NEXT:    ret float [[TMP1]]
;
  %bitcast = bitcast float %val to i32
  %and = and i32 %bitcast, 2147483647
  %fabs = bitcast i32 %and to float
  ret float %fabs
}

define float @not_fabs_as_int_f32_castback_wrongconst(float %val) {
; CHECK-LABEL: define float @not_fabs_as_int_f32_castback_wrongconst
; CHECK-SAME: (float [[VAL:%.*]]) {
; CHECK-NEXT:    [[TMP1:%.*]] = call float @llvm.fabs.f32(float [[VAL]])
; CHECK-NEXT:    ret float [[TMP1]]
;
  %bitcast = bitcast float %val to i32
  %and = and i32 %bitcast, 2147483647
  %fabs = bitcast i32 %and to float
  ret float %fabs
}

define float @fabs_as_int_f32_castback_multi_use(float %val, ptr %ptr) {
; CHECK-LABEL: define float @fabs_as_int_f32_castback_multi_use
; CHECK-SAME: (float [[VAL:%.*]], ptr [[PTR:%.*]]) {
; CHECK-NEXT:    [[TMP1:%.*]] = call float @llvm.fabs.f32(float [[VAL]])
; CHECK-NEXT:    store float [[TMP1]], ptr [[PTR]], align 4
; CHECK-NEXT:    ret float [[TMP1]]
;
  %bitcast = bitcast float %val to i32
  %and = and i32 %bitcast, 2147483647
  store i32 %and, ptr %ptr
  %fabs = bitcast i32 %and to float
  ret float %fabs
}

define i64 @fabs_as_int_f64(double %x) {
; CHECK-LABEL: define i64 @fabs_as_int_f64
; CHECK-SAME: (double [[X:%.*]]) {
; CHECK-NEXT:    [[TMP1:%.*]] = call double @llvm.fabs.f64(double [[X]])
; CHECK-NEXT:    [[AND:%.*]] = bitcast double [[TMP1]] to i64
; CHECK-NEXT:    ret i64 [[AND]]
;
  %bc = bitcast double %x to i64
  %and = and i64 %bc, 9223372036854775807
  ret i64 %and
}

define <2 x i64> @fabs_as_int_v2f64(<2 x double> %x) {
; CHECK-LABEL: define <2 x i64> @fabs_as_int_v2f64
; CHECK-SAME: (<2 x double> [[X:%.*]]) {
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x double> @llvm.fabs.v2f64(<2 x double> [[X]])
; CHECK-NEXT:    [[AND:%.*]] = bitcast <2 x double> [[TMP1]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[AND]]
;
  %bc = bitcast <2 x double> %x to <2 x i64>
  %and = and <2 x i64> %bc, <i64 9223372036854775807, i64 9223372036854775807>
  ret <2 x i64> %and
}

define i64 @fabs_as_int_f64_swap(double %x) {
; CHECK-LABEL: define i64 @fabs_as_int_f64_swap
; CHECK-SAME: (double [[X:%.*]]) {
; CHECK-NEXT:    [[TMP1:%.*]] = call double @llvm.fabs.f64(double [[X]])
; CHECK-NEXT:    [[AND:%.*]] = bitcast double [[TMP1]] to i64
; CHECK-NEXT:    ret i64 [[AND]]
;
  %bc = bitcast double %x to i64
  %and = and i64 9223372036854775807, %bc
  ret i64 %and
}

define i32 @fabs_as_int_f32(float %x) {
; CHECK-LABEL: define i32 @fabs_as_int_f32
; CHECK-SAME: (float [[X:%.*]]) {
; CHECK-NEXT:    [[TMP1:%.*]] = call float @llvm.fabs.f32(float [[X]])
; CHECK-NEXT:    [[AND:%.*]] = bitcast float [[TMP1]] to i32
; CHECK-NEXT:    ret i32 [[AND]]
;
  %bc = bitcast float %x to i32
  %and = and i32 %bc, 2147483647
  ret i32 %and
}

define <2 x i32> @fabs_as_int_v2f32(<2 x float> %x) {
; CHECK-LABEL: define <2 x i32> @fabs_as_int_v2f32
; CHECK-SAME: (<2 x float> [[X:%.*]]) {
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x float> @llvm.fabs.v2f32(<2 x float> [[X]])
; CHECK-NEXT:    [[AND:%.*]] = bitcast <2 x float> [[TMP1]] to <2 x i32>
; CHECK-NEXT:    ret <2 x i32> [[AND]]
;
  %bc = bitcast <2 x float> %x to <2 x i32>
  %and = and <2 x i32> %bc, <i32 2147483647, i32 2147483647>
  ret <2 x i32> %and
}

define <2 x i32> @not_fabs_as_int_v2f32_nonsplat(<2 x float> %x) {
; CHECK-LABEL: define <2 x i32> @not_fabs_as_int_v2f32_nonsplat
; CHECK-SAME: (<2 x float> [[X:%.*]]) {
; CHECK-NEXT:    [[BC:%.*]] = bitcast <2 x float> [[X]] to <2 x i32>
; CHECK-NEXT:    [[AND:%.*]] = and <2 x i32> [[BC]], <i32 2147483647, i32 2147483646>
; CHECK-NEXT:    ret <2 x i32> [[AND]]
;
  %bc = bitcast <2 x float> %x to <2 x i32>
  %and = and <2 x i32> %bc, <i32 2147483647, i32 2147483646>
  ret <2 x i32> %and
}

define <3 x i32> @fabs_as_int_v3f32_undef(<3 x float> %x) {
; CHECK-LABEL: define <3 x i32> @fabs_as_int_v3f32_undef
; CHECK-SAME: (<3 x float> [[X:%.*]]) {
; CHECK-NEXT:    [[TMP1:%.*]] = call <3 x float> @llvm.fabs.v3f32(<3 x float> [[X]])
; CHECK-NEXT:    [[AND:%.*]] = bitcast <3 x float> [[TMP1]] to <3 x i32>
; CHECK-NEXT:    ret <3 x i32> [[AND]]
;
  %bc = bitcast <3 x float> %x to <3 x i32>
  %and = and <3 x i32> %bc, <i32 2147483647, i32 undef, i32 2147483647>
  ret <3 x i32> %and
}

; Make sure that only a bitcast is transformed.
define i64 @fabs_as_int_f64_not_bitcast(double %x) {
; CHECK-LABEL: define i64 @fabs_as_int_f64_not_bitcast
; CHECK-SAME: (double [[X:%.*]]) {
; CHECK-NEXT:    [[BC:%.*]] = fptoui double [[X]] to i64
; CHECK-NEXT:    [[AND:%.*]] = and i64 [[BC]], 9223372036854775807
; CHECK-NEXT:    ret i64 [[AND]]
;
  %bc = fptoui double %x to i64
  %and = and i64 %bc, 9223372036854775807
  ret i64 %and
}

define float @not_fabs_as_int_f32_bitcast_from_v2f16(<2 x half> %val) {
; CHECK-LABEL: define float @not_fabs_as_int_f32_bitcast_from_v2f16
; CHECK-SAME: (<2 x half> [[VAL:%.*]]) {
; CHECK-NEXT:    [[BITCAST:%.*]] = bitcast <2 x half> [[VAL]] to i32
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[BITCAST]], 2147483647
; CHECK-NEXT:    [[FABS:%.*]] = bitcast i32 [[AND]] to float
; CHECK-NEXT:    ret float [[FABS]]
;
  %bitcast = bitcast <2 x half> %val to i32
  %and = and i32 %bitcast, 2147483647
  %fabs = bitcast i32 %and to float
  ret float %fabs
}

define float @not_fabs_as_int_f32_bitcast_from_v2i16(<2 x i16> %val) {
; CHECK-LABEL: define float @not_fabs_as_int_f32_bitcast_from_v2i16
; CHECK-SAME: (<2 x i16> [[VAL:%.*]]) {
; CHECK-NEXT:    [[BITCAST:%.*]] = bitcast <2 x i16> [[VAL]] to i32
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[BITCAST]], 2147483647
; CHECK-NEXT:    [[FABS:%.*]] = bitcast i32 [[AND]] to float
; CHECK-NEXT:    ret float [[FABS]]
;
  %bitcast = bitcast <2 x i16> %val to i32
  %and = and i32 %bitcast, 2147483647
  %fabs = bitcast i32 %and to float
  ret float %fabs
}

define i128 @fabs_as_int_fp128_f64_mask(fp128 %x) {
; CHECK-LABEL: define i128 @fabs_as_int_fp128_f64_mask
; CHECK-SAME: (fp128 [[X:%.*]]) {
; CHECK-NEXT:    [[TMP1:%.*]] = call fp128 @llvm.fabs.f128(fp128 [[X]])
; CHECK-NEXT:    [[AND:%.*]] = bitcast fp128 [[TMP1]] to i128
; CHECK-NEXT:    ret i128 [[AND]]
;
  %bc = bitcast fp128 %x to i128
  %and = and i128 %bc, 170141183460469231731687303715884105727
  ret i128 %and
}

define i128 @fabs_as_int_fp128_f128_mask(fp128 %x) {
; CHECK-LABEL: define i128 @fabs_as_int_fp128_f128_mask
; CHECK-SAME: (fp128 [[X:%.*]]) {
; CHECK-NEXT:    [[TMP1:%.*]] = call fp128 @llvm.fabs.f128(fp128 [[X]])
; CHECK-NEXT:    [[AND:%.*]] = bitcast fp128 [[TMP1]] to i128
; CHECK-NEXT:    ret i128 [[AND]]
;
  %bc = bitcast fp128 %x to i128
  %and = and i128 %bc, 170141183460469231731687303715884105727
  ret i128 %and
}

define i16 @fabs_as_int_f16(half %x) {
; CHECK-LABEL: define i16 @fabs_as_int_f16
; CHECK-SAME: (half [[X:%.*]]) {
; CHECK-NEXT:    [[TMP1:%.*]] = call half @llvm.fabs.f16(half [[X]])
; CHECK-NEXT:    [[AND:%.*]] = bitcast half [[TMP1]] to i16
; CHECK-NEXT:    ret i16 [[AND]]
;
  %bc = bitcast half %x to i16
  %and = and i16 %bc, 32767
  ret i16 %and
}

define <2 x i16> @fabs_as_int_v2f16(<2 x half> %x) {
; CHECK-LABEL: define <2 x i16> @fabs_as_int_v2f16
; CHECK-SAME: (<2 x half> [[X:%.*]]) {
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x half> @llvm.fabs.v2f16(<2 x half> [[X]])
; CHECK-NEXT:    [[AND:%.*]] = bitcast <2 x half> [[TMP1]] to <2 x i16>
; CHECK-NEXT:    ret <2 x i16> [[AND]]
;
  %bc = bitcast <2 x half> %x to <2 x i16>
  %and = and <2 x i16> %bc, <i16 32767, i16 32767>
  ret <2 x i16> %and
}

define i16 @fabs_as_int_bf16(bfloat %x) {
; CHECK-LABEL: define i16 @fabs_as_int_bf16
; CHECK-SAME: (bfloat [[X:%.*]]) {
; CHECK-NEXT:    [[TMP1:%.*]] = call bfloat @llvm.fabs.bf16(bfloat [[X]])
; CHECK-NEXT:    [[AND:%.*]] = bitcast bfloat [[TMP1]] to i16
; CHECK-NEXT:    ret i16 [[AND]]
;
  %bc = bitcast bfloat %x to i16
  %and = and i16 %bc, 32767
  ret i16 %and
}

define <2 x i16> @fabs_as_int_v2bf16(<2 x bfloat> %x) {
; CHECK-LABEL: define <2 x i16> @fabs_as_int_v2bf16
; CHECK-SAME: (<2 x bfloat> [[X:%.*]]) {
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x bfloat> @llvm.fabs.v2bf16(<2 x bfloat> [[X]])
; CHECK-NEXT:    [[AND:%.*]] = bitcast <2 x bfloat> [[TMP1]] to <2 x i16>
; CHECK-NEXT:    ret <2 x i16> [[AND]]
;
  %bc = bitcast <2 x bfloat> %x to <2 x i16>
  %and = and <2 x i16> %bc, <i16 32767, i16 32767>
  ret <2 x i16> %and
}

define i80 @fabs_as_int_x86_fp80_f64_mask(x86_fp80 %x) {
; CHECK-LABEL: define i80 @fabs_as_int_x86_fp80_f64_mask
; CHECK-SAME: (x86_fp80 [[X:%.*]]) {
; CHECK-NEXT:    [[BC:%.*]] = bitcast x86_fp80 [[X]] to i80
; CHECK-NEXT:    [[AND:%.*]] = and i80 [[BC]], 9223372036854775807
; CHECK-NEXT:    ret i80 [[AND]]
;
  %bc = bitcast x86_fp80 %x to i80
  %and = and i80 %bc, 9223372036854775807
  ret i80 %and
}

define i128 @fabs_as_int_ppc_fp128_f64_mask(ppc_fp128 %x) {
; CHECK-LABEL: define i128 @fabs_as_int_ppc_fp128_f64_mask
; CHECK-SAME: (ppc_fp128 [[X:%.*]]) {
; CHECK-NEXT:    [[BC:%.*]] = bitcast ppc_fp128 [[X]] to i128
; CHECK-NEXT:    [[AND:%.*]] = and i128 [[BC]], 9223372036854775807
; CHECK-NEXT:    ret i128 [[AND]]
;
  %bc = bitcast ppc_fp128 %x to i128
  %and = and i128 %bc, 9223372036854775807
  ret i128 %and
}

define i128 @fabs_as_int_ppc_fp128_f128_mask(ppc_fp128 %x) {
; CHECK-LABEL: define i128 @fabs_as_int_ppc_fp128_f128_mask
; CHECK-SAME: (ppc_fp128 [[X:%.*]]) {
; CHECK-NEXT:    [[BC:%.*]] = bitcast ppc_fp128 [[X]] to i128
; CHECK-NEXT:    [[AND:%.*]] = and i128 [[BC]], 170141183460469231731687303715884105727
; CHECK-NEXT:    ret i128 [[AND]]
;
  %bc = bitcast ppc_fp128 %x to i128
  %and = and i128 %bc, 170141183460469231731687303715884105727
  ret i128 %and
}
