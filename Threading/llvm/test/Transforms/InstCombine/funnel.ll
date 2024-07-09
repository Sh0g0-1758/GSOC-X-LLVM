; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:128:128"

; Canonicalize or(shl,lshr) by constant to funnel shift intrinsics.
; This should help cost modeling for vectorization, inlining, etc.
; If a target does not have a fshl instruction, the expansion will
; be exactly these same 3 basic ops (shl/lshr/or).

define i32 @fshl_i32_constant(i32 %x, i32 %y) {
; CHECK-LABEL: @fshl_i32_constant(
; CHECK-NEXT:    [[R:%.*]] = call i32 @llvm.fshl.i32(i32 [[X:%.*]], i32 [[Y:%.*]], i32 11)
; CHECK-NEXT:    ret i32 [[R]]
;
  %shl = shl i32 %x, 11
  %shr = lshr i32 %y, 21
  %r = or i32 %shr, %shl
  ret i32 %r
}

define i42 @fshr_i42_constant(i42 %x, i42 %y) {
; CHECK-LABEL: @fshr_i42_constant(
; CHECK-NEXT:    [[R:%.*]] = call i42 @llvm.fshl.i42(i42 [[Y:%.*]], i42 [[X:%.*]], i42 11)
; CHECK-NEXT:    ret i42 [[R]]
;
  %shr = lshr i42 %x, 31
  %shl = shl i42 %y, 11
  %r = or i42 %shr, %shl
  ret i42 %r
}

; Vector types are allowed.

define <2 x i16> @fshl_v2i16_constant_splat(<2 x i16> %x, <2 x i16> %y) {
; CHECK-LABEL: @fshl_v2i16_constant_splat(
; CHECK-NEXT:    [[R:%.*]] = call <2 x i16> @llvm.fshl.v2i16(<2 x i16> [[X:%.*]], <2 x i16> [[Y:%.*]], <2 x i16> <i16 1, i16 1>)
; CHECK-NEXT:    ret <2 x i16> [[R]]
;
  %shl = shl <2 x i16> %x, <i16 1, i16 1>
  %shr = lshr <2 x i16> %y, <i16 15, i16 15>
  %r = or <2 x i16> %shl, %shr
  ret <2 x i16> %r
}

define <2 x i16> @fshl_v2i16_constant_splat_undef0(<2 x i16> %x, <2 x i16> %y) {
; CHECK-LABEL: @fshl_v2i16_constant_splat_undef0(
; CHECK-NEXT:    [[R:%.*]] = call <2 x i16> @llvm.fshl.v2i16(<2 x i16> [[X:%.*]], <2 x i16> [[Y:%.*]], <2 x i16> <i16 1, i16 1>)
; CHECK-NEXT:    ret <2 x i16> [[R]]
;
  %shl = shl <2 x i16> %x, <i16 undef, i16 1>
  %shr = lshr <2 x i16> %y, <i16 15, i16 15>
  %r = or <2 x i16> %shl, %shr
  ret <2 x i16> %r
}

define <2 x i16> @fshl_v2i16_constant_splat_undef1(<2 x i16> %x, <2 x i16> %y) {
; CHECK-LABEL: @fshl_v2i16_constant_splat_undef1(
; CHECK-NEXT:    [[R:%.*]] = call <2 x i16> @llvm.fshl.v2i16(<2 x i16> [[X:%.*]], <2 x i16> [[Y:%.*]], <2 x i16> <i16 1, i16 1>)
; CHECK-NEXT:    ret <2 x i16> [[R]]
;
  %shl = shl <2 x i16> %x, <i16 1, i16 1>
  %shr = lshr <2 x i16> %y, <i16 15, i16 undef>
  %r = or <2 x i16> %shl, %shr
  ret <2 x i16> %r
}

; Non-power-of-2 vector types are allowed.

define <2 x i17> @fshr_v2i17_constant_splat(<2 x i17> %x, <2 x i17> %y) {
; CHECK-LABEL: @fshr_v2i17_constant_splat(
; CHECK-NEXT:    [[R:%.*]] = call <2 x i17> @llvm.fshl.v2i17(<2 x i17> [[Y:%.*]], <2 x i17> [[X:%.*]], <2 x i17> <i17 5, i17 5>)
; CHECK-NEXT:    ret <2 x i17> [[R]]
;
  %shr = lshr <2 x i17> %x, <i17 12, i17 12>
  %shl = shl <2 x i17> %y, <i17 5, i17 5>
  %r = or <2 x i17> %shr, %shl
  ret <2 x i17> %r
}

define <2 x i17> @fshr_v2i17_constant_splat_undef0(<2 x i17> %x, <2 x i17> %y) {
; CHECK-LABEL: @fshr_v2i17_constant_splat_undef0(
; CHECK-NEXT:    [[R:%.*]] = call <2 x i17> @llvm.fshl.v2i17(<2 x i17> [[Y:%.*]], <2 x i17> [[X:%.*]], <2 x i17> <i17 5, i17 5>)
; CHECK-NEXT:    ret <2 x i17> [[R]]
;
  %shr = lshr <2 x i17> %x, <i17 12, i17 undef>
  %shl = shl <2 x i17> %y, <i17 undef, i17 5>
  %r = or <2 x i17> %shr, %shl
  ret <2 x i17> %r
}

define <2 x i17> @fshr_v2i17_constant_splat_undef1(<2 x i17> %x, <2 x i17> %y) {
; CHECK-LABEL: @fshr_v2i17_constant_splat_undef1(
; CHECK-NEXT:    [[R:%.*]] = call <2 x i17> @llvm.fshl.v2i17(<2 x i17> [[Y:%.*]], <2 x i17> [[X:%.*]], <2 x i17> <i17 5, i17 5>)
; CHECK-NEXT:    ret <2 x i17> [[R]]
;
  %shr = lshr <2 x i17> %x, <i17 12, i17 undef>
  %shl = shl <2 x i17> %y, <i17 5, i17 undef>
  %r = or <2 x i17> %shr, %shl
  ret <2 x i17> %r
}

; Allow arbitrary shift constants.
; Support undef elements.

define <2 x i32> @fshr_v2i32_constant_nonsplat(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @fshr_v2i32_constant_nonsplat(
; CHECK-NEXT:    [[R:%.*]] = call <2 x i32> @llvm.fshl.v2i32(<2 x i32> [[Y:%.*]], <2 x i32> [[X:%.*]], <2 x i32> <i32 15, i32 13>)
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %shr = lshr <2 x i32> %x, <i32 17, i32 19>
  %shl = shl <2 x i32> %y, <i32 15, i32 13>
  %r = or <2 x i32> %shl, %shr
  ret <2 x i32> %r
}

define <2 x i32> @fshr_v2i32_constant_nonsplat_undef0(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @fshr_v2i32_constant_nonsplat_undef0(
; CHECK-NEXT:    [[R:%.*]] = call <2 x i32> @llvm.fshl.v2i32(<2 x i32> [[Y:%.*]], <2 x i32> [[X:%.*]], <2 x i32> <i32 0, i32 13>)
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %shr = lshr <2 x i32> %x, <i32 undef, i32 19>
  %shl = shl <2 x i32> %y, <i32 15, i32 13>
  %r = or <2 x i32> %shl, %shr
  ret <2 x i32> %r
}

define <2 x i32> @fshr_v2i32_constant_nonsplat_undef1(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @fshr_v2i32_constant_nonsplat_undef1(
; CHECK-NEXT:    [[R:%.*]] = call <2 x i32> @llvm.fshl.v2i32(<2 x i32> [[Y:%.*]], <2 x i32> [[X:%.*]], <2 x i32> <i32 15, i32 0>)
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %shr = lshr <2 x i32> %x, <i32 17, i32 19>
  %shl = shl <2 x i32> %y, <i32 15, i32 undef>
  %r = or <2 x i32> %shl, %shr
  ret <2 x i32> %r
}

define <2 x i36> @fshl_v2i36_constant_nonsplat(<2 x i36> %x, <2 x i36> %y) {
; CHECK-LABEL: @fshl_v2i36_constant_nonsplat(
; CHECK-NEXT:    [[R:%.*]] = call <2 x i36> @llvm.fshl.v2i36(<2 x i36> [[X:%.*]], <2 x i36> [[Y:%.*]], <2 x i36> <i36 21, i36 11>)
; CHECK-NEXT:    ret <2 x i36> [[R]]
;
  %shl = shl <2 x i36> %x, <i36 21, i36 11>
  %shr = lshr <2 x i36> %y, <i36 15, i36 25>
  %r = or <2 x i36> %shl, %shr
  ret <2 x i36> %r
}

define <3 x i36> @fshl_v3i36_constant_nonsplat_undef0(<3 x i36> %x, <3 x i36> %y) {
; CHECK-LABEL: @fshl_v3i36_constant_nonsplat_undef0(
; CHECK-NEXT:    [[R:%.*]] = call <3 x i36> @llvm.fshl.v3i36(<3 x i36> [[X:%.*]], <3 x i36> [[Y:%.*]], <3 x i36> <i36 21, i36 11, i36 0>)
; CHECK-NEXT:    ret <3 x i36> [[R]]
;
  %shl = shl <3 x i36> %x, <i36 21, i36 11, i36 undef>
  %shr = lshr <3 x i36> %y, <i36 15, i36 25, i36 undef>
  %r = or <3 x i36> %shl, %shr
  ret <3 x i36> %r
}

; Fold or(shl(x,a),lshr(y,bw-a)) -> fshl(x,y,a) iff a < bw

define i64 @fshl_sub_mask(i64 %x, i64 %y, i64 %a) {
; CHECK-LABEL: @fshl_sub_mask(
; CHECK-NEXT:    [[R:%.*]] = call i64 @llvm.fshl.i64(i64 [[X:%.*]], i64 [[Y:%.*]], i64 [[A:%.*]])
; CHECK-NEXT:    ret i64 [[R]]
;
  %mask = and i64 %a, 63
  %shl = shl i64 %x, %mask
  %sub = sub nuw nsw i64 64, %mask
  %shr = lshr i64 %y, %sub
  %r = or i64 %shl, %shr
  ret i64 %r
}

; Fold or(lshr(v,a),shl(v,bw-a)) -> fshr(y,x,a) iff a < bw

define i64 @fshr_sub_mask(i64 %x, i64 %y, i64 %a) {
; CHECK-LABEL: @fshr_sub_mask(
; CHECK-NEXT:    [[R:%.*]] = call i64 @llvm.fshr.i64(i64 [[Y:%.*]], i64 [[X:%.*]], i64 [[A:%.*]])
; CHECK-NEXT:    ret i64 [[R]]
;
  %mask = and i64 %a, 63
  %shr = lshr i64 %x, %mask
  %sub = sub nuw nsw i64 64, %mask
  %shl = shl i64 %y, %sub
  %r = or i64 %shl, %shr
  ret i64 %r
}

define <2 x i64> @fshr_sub_mask_vector(<2 x i64> %x, <2 x i64> %y, <2 x i64> %a) {
; CHECK-LABEL: @fshr_sub_mask_vector(
; CHECK-NEXT:    [[R:%.*]] = call <2 x i64> @llvm.fshr.v2i64(<2 x i64> [[Y:%.*]], <2 x i64> [[X:%.*]], <2 x i64> [[A:%.*]])
; CHECK-NEXT:    ret <2 x i64> [[R]]
;
  %mask = and <2 x i64> %a, <i64 63, i64 63>
  %shr = lshr <2 x i64> %x, %mask
  %sub = sub nuw nsw <2 x i64> <i64 64, i64 64>, %mask
  %shl = shl <2 x i64> %y, %sub
  %r = or <2 x i64> %shl, %shr
  ret <2 x i64> %r
}

; PR35155 - these are optionally UB-free funnel shift left/right patterns that are narrowed to a smaller bitwidth.

define i16 @fshl_16bit(i16 %x, i16 %y, i32 %shift) {
; CHECK-LABEL: @fshl_16bit(
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i32 [[SHIFT:%.*]] to i16
; CHECK-NEXT:    [[CONV2:%.*]] = call i16 @llvm.fshl.i16(i16 [[X:%.*]], i16 [[Y:%.*]], i16 [[TMP1]])
; CHECK-NEXT:    ret i16 [[CONV2]]
;
  %and = and i32 %shift, 15
  %convx = zext i16 %x to i32
  %shl = shl i32 %convx, %and
  %sub = sub i32 16, %and
  %convy = zext i16 %y to i32
  %shr = lshr i32 %convy, %sub
  %or = or i32 %shr, %shl
  %conv2 = trunc i32 %or to i16
  ret i16 %conv2
}

; Commute the 'or' operands and try a vector type.

define <2 x i16> @fshl_commute_16bit_vec(<2 x i16> %x, <2 x i16> %y, <2 x i32> %shift) {
; CHECK-LABEL: @fshl_commute_16bit_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = trunc <2 x i32> [[SHIFT:%.*]] to <2 x i16>
; CHECK-NEXT:    [[CONV2:%.*]] = call <2 x i16> @llvm.fshl.v2i16(<2 x i16> [[X:%.*]], <2 x i16> [[Y:%.*]], <2 x i16> [[TMP1]])
; CHECK-NEXT:    ret <2 x i16> [[CONV2]]
;
  %and = and <2 x i32> %shift, <i32 15, i32 15>
  %convx = zext <2 x i16> %x to <2 x i32>
  %shl = shl <2 x i32> %convx, %and
  %sub = sub <2 x i32> <i32 16, i32 16>, %and
  %convy = zext <2 x i16> %y to <2 x i32>
  %shr = lshr <2 x i32> %convy, %sub
  %or = or <2 x i32> %shl, %shr
  %conv2 = trunc <2 x i32> %or to <2 x i16>
  ret <2 x i16> %conv2
}

; Change the size, shift direction (the subtract is on the left-shift), and mask op.

define i8 @fshr_8bit(i8 %x, i8 %y, i3 %shift) {
; CHECK-LABEL: @fshr_8bit(
; CHECK-NEXT:    [[TMP1:%.*]] = zext i3 [[SHIFT:%.*]] to i8
; CHECK-NEXT:    [[CONV2:%.*]] = call i8 @llvm.fshr.i8(i8 [[Y:%.*]], i8 [[X:%.*]], i8 [[TMP1]])
; CHECK-NEXT:    ret i8 [[CONV2]]
;
  %and = zext i3 %shift to i32
  %convx = zext i8 %x to i32
  %shr = lshr i32 %convx, %and
  %sub = sub i32 8, %and
  %convy = zext i8 %y to i32
  %shl = shl i32 %convy, %sub
  %or = or i32 %shl, %shr
  %conv2 = trunc i32 %or to i8
  ret i8 %conv2
}

; The right-shifted value does not need to be a zexted value; here it is masked.
; The shift mask could be less than the bitwidth, but this is still ok.

define i8 @fshr_commute_8bit(i32 %x, i32 %y, i32 %shift) {
; CHECK-LABEL: @fshr_commute_8bit(
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i32 [[SHIFT:%.*]] to i8
; CHECK-NEXT:    [[TMP2:%.*]] = and i8 [[TMP1]], 3
; CHECK-NEXT:    [[TMP3:%.*]] = trunc i32 [[Y:%.*]] to i8
; CHECK-NEXT:    [[TMP4:%.*]] = trunc i32 [[X:%.*]] to i8
; CHECK-NEXT:    [[CONV2:%.*]] = call i8 @llvm.fshr.i8(i8 [[TMP3]], i8 [[TMP4]], i8 [[TMP2]])
; CHECK-NEXT:    ret i8 [[CONV2]]
;
  %and = and i32 %shift, 3
  %convx = and i32 %x, 255
  %shr = lshr i32 %convx, %and
  %sub = sub i32 8, %and
  %convy = and i32 %y, 255
  %shl = shl i32 %convy, %sub
  %or = or i32 %shr, %shl
  %conv2 = trunc i32 %or to i8
  ret i8 %conv2
}

; The left-shifted value does not need to be masked at all.

define i8 @fshr_commute_8bit_unmasked_shl(i32 %x, i32 %y, i32 %shift) {
; CHECK-LABEL: @fshr_commute_8bit_unmasked_shl(
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i32 [[SHIFT:%.*]] to i8
; CHECK-NEXT:    [[TMP2:%.*]] = and i8 [[TMP1]], 3
; CHECK-NEXT:    [[TMP3:%.*]] = trunc i32 [[Y:%.*]] to i8
; CHECK-NEXT:    [[TMP4:%.*]] = trunc i32 [[X:%.*]] to i8
; CHECK-NEXT:    [[CONV2:%.*]] = call i8 @llvm.fshr.i8(i8 [[TMP3]], i8 [[TMP4]], i8 [[TMP2]])
; CHECK-NEXT:    ret i8 [[CONV2]]
;
  %and = and i32 %shift, 3
  %convx = and i32 %x, 255
  %shr = lshr i32 %convx, %and
  %sub = sub i32 8, %and
  %convy = and i32 %y, 255
  %shl = shl i32 %y, %sub
  %or = or i32 %shr, %shl
  %conv2 = trunc i32 %or to i8
  ret i8 %conv2
}

; Convert select pattern to funnel shift that ends in 'or'.

define i8 @fshr_select(i8 %x, i8 %y, i8 %shamt) {
; CHECK-LABEL: @fshr_select(
; CHECK-NEXT:    [[TMP1:%.*]] = freeze i8 [[X:%.*]]
; CHECK-NEXT:    [[R:%.*]] = call i8 @llvm.fshr.i8(i8 [[TMP1]], i8 [[Y:%.*]], i8 [[SHAMT:%.*]])
; CHECK-NEXT:    ret i8 [[R]]
;
  %cmp = icmp eq i8 %shamt, 0
  %sub = sub i8 8, %shamt
  %shr = lshr i8 %y, %shamt
  %shl = shl i8 %x, %sub
  %or = or i8 %shl, %shr
  %r = select i1 %cmp, i8 %y, i8 %or
  ret i8 %r
}

; Convert select pattern to funnel shift that ends in 'or'.

define i16 @fshl_select(i16 %x, i16 %y, i16 %shamt) {
; CHECK-LABEL: @fshl_select(
; CHECK-NEXT:    [[TMP1:%.*]] = freeze i16 [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = call i16 @llvm.fshl.i16(i16 [[X:%.*]], i16 [[TMP1]], i16 [[SHAMT:%.*]])
; CHECK-NEXT:    ret i16 [[R]]
;
  %cmp = icmp eq i16 %shamt, 0
  %sub = sub i16 16, %shamt
  %shr = lshr i16 %y, %sub
  %shl = shl i16 %x, %shamt
  %or = or i16 %shr, %shl
  %r = select i1 %cmp, i16 %x, i16 %or
  ret i16 %r
}

; Convert select pattern to funnel shift that ends in 'or'.

define <2 x i64> @fshl_select_vector(<2 x i64> %x, <2 x i64> %y, <2 x i64> %shamt) {
; CHECK-LABEL: @fshl_select_vector(
; CHECK-NEXT:    [[TMP1:%.*]] = freeze <2 x i64> [[X:%.*]]
; CHECK-NEXT:    [[R:%.*]] = call <2 x i64> @llvm.fshl.v2i64(<2 x i64> [[Y:%.*]], <2 x i64> [[TMP1]], <2 x i64> [[SHAMT:%.*]])
; CHECK-NEXT:    ret <2 x i64> [[R]]
;
  %cmp = icmp eq <2 x i64> %shamt, zeroinitializer
  %sub = sub <2 x i64> <i64 64, i64 64>, %shamt
  %shr = lshr <2 x i64> %x, %sub
  %shl = shl <2 x i64> %y, %shamt
  %or = or <2 x i64> %shl, %shr
  %r = select <2 x i1> %cmp, <2 x i64> %y, <2 x i64> %or
  ret <2 x i64> %r
}

; Convert 'or concat' to fshl if opposite 'or concat' exists.

define i32 @fshl_concat_i8_i24(i8 %x, i24 %y, ptr %addr) {
; CHECK-LABEL: @fshl_concat_i8_i24(
; CHECK-NEXT:    [[ZEXT_X:%.*]] = zext i8 [[X:%.*]] to i32
; CHECK-NEXT:    [[SLX:%.*]] = shl nuw i32 [[ZEXT_X]], 24
; CHECK-NEXT:    [[ZEXT_Y:%.*]] = zext i24 [[Y:%.*]] to i32
; CHECK-NEXT:    [[XY:%.*]] = or disjoint i32 [[SLX]], [[ZEXT_Y]]
; CHECK-NEXT:    store i32 [[XY]], ptr [[ADDR:%.*]], align 4
; CHECK-NEXT:    [[YX:%.*]] = call i32 @llvm.fshl.i32(i32 [[XY]], i32 [[XY]], i32 8)
; CHECK-NEXT:    ret i32 [[YX]]
;
  %zext.x = zext i8 %x to i32
  %slx = shl i32 %zext.x, 24
  %zext.y = zext i24 %y to i32
  %xy = or i32 %zext.y, %slx
  store i32 %xy, ptr %addr, align 4
  %sly = shl i32 %zext.y, 8
  %yx = or i32 %zext.x, %sly
  ret i32 %yx
}

define i32 @fshl_concat_i8_i8(i8 %x, i8 %y, ptr %addr) {
; CHECK-LABEL: @fshl_concat_i8_i8(
; CHECK-NEXT:    [[ZEXT_X:%.*]] = zext i8 [[X:%.*]] to i32
; CHECK-NEXT:    [[SLX:%.*]] = shl nuw nsw i32 [[ZEXT_X]], 13
; CHECK-NEXT:    [[ZEXT_Y:%.*]] = zext i8 [[Y:%.*]] to i32
; CHECK-NEXT:    [[XY:%.*]] = or disjoint i32 [[SLX]], [[ZEXT_Y]]
; CHECK-NEXT:    store i32 [[XY]], ptr [[ADDR:%.*]], align 4
; CHECK-NEXT:    [[YX:%.*]] = call i32 @llvm.fshl.i32(i32 [[XY]], i32 [[XY]], i32 19)
; CHECK-NEXT:    ret i32 [[YX]]
;
  %zext.x = zext i8 %x to i32
  %slx = shl i32 %zext.x, 13
  %zext.y = zext i8 %y to i32
  %xy = or i32 %zext.y, %slx
  store i32 %xy, ptr %addr, align 4
  %sly = shl i32 %zext.y, 19
  %yx = or i32 %zext.x, %sly
  ret i32 %yx
}

define i32 @fshl_concat_i8_i8_overlap(i8 %x, i8 %y, ptr %addr) {
; CHECK-LABEL: @fshl_concat_i8_i8_overlap(
; CHECK-NEXT:    [[ZEXT_X:%.*]] = zext i8 [[X:%.*]] to i32
; CHECK-NEXT:    [[SLX:%.*]] = shl i32 [[ZEXT_X]], 25
; CHECK-NEXT:    [[ZEXT_Y:%.*]] = zext i8 [[Y:%.*]] to i32
; CHECK-NEXT:    [[XY:%.*]] = or disjoint i32 [[SLX]], [[ZEXT_Y]]
; CHECK-NEXT:    store i32 [[XY]], ptr [[ADDR:%.*]], align 4
; CHECK-NEXT:    [[SLY:%.*]] = shl nuw nsw i32 [[ZEXT_Y]], 7
; CHECK-NEXT:    [[YX:%.*]] = or i32 [[SLY]], [[ZEXT_X]]
; CHECK-NEXT:    ret i32 [[YX]]
;
  ; Test sly overlap.
  %zext.x = zext i8 %x to i32
  %slx = shl i32 %zext.x, 25
  %zext.y = zext i8 %y to i32
  %xy = or i32 %zext.y, %slx
  store i32 %xy, ptr %addr, align 4
  %sly = shl i32 %zext.y, 7
  %yx = or i32 %zext.x, %sly
  ret i32 %yx
}

define i32 @fshl_concat_i8_i8_drop(i8 %x, i8 %y, ptr %addr) {
; CHECK-LABEL: @fshl_concat_i8_i8_drop(
; CHECK-NEXT:    [[ZEXT_X:%.*]] = zext i8 [[X:%.*]] to i32
; CHECK-NEXT:    [[SLX:%.*]] = shl nuw nsw i32 [[ZEXT_X]], 7
; CHECK-NEXT:    [[ZEXT_Y:%.*]] = zext i8 [[Y:%.*]] to i32
; CHECK-NEXT:    [[XY:%.*]] = or i32 [[SLX]], [[ZEXT_Y]]
; CHECK-NEXT:    store i32 [[XY]], ptr [[ADDR:%.*]], align 4
; CHECK-NEXT:    [[SLY:%.*]] = shl i32 [[ZEXT_Y]], 25
; CHECK-NEXT:    [[YX:%.*]] = or disjoint i32 [[SLY]], [[ZEXT_X]]
; CHECK-NEXT:    ret i32 [[YX]]
;
  ; Test sly drop.
  %zext.x = zext i8 %x to i32
  %slx = shl i32 %zext.x, 7
  %zext.y = zext i8 %y to i32
  %xy = or i32 %zext.y, %slx
  store i32 %xy, ptr %addr, align 4
  %sly = shl i32 %zext.y, 25
  %yx = or i32 %zext.x, %sly
  ret i32 %yx
}

define i32 @fshl_concat_i8_i8_different_slot(i8 %x, i8 %y, ptr %addr) {
; CHECK-LABEL: @fshl_concat_i8_i8_different_slot(
; CHECK-NEXT:    [[ZEXT_X:%.*]] = zext i8 [[X:%.*]] to i32
; CHECK-NEXT:    [[SLX:%.*]] = shl nuw nsw i32 [[ZEXT_X]], 9
; CHECK-NEXT:    [[ZEXT_Y:%.*]] = zext i8 [[Y:%.*]] to i32
; CHECK-NEXT:    [[XY:%.*]] = or disjoint i32 [[SLX]], [[ZEXT_Y]]
; CHECK-NEXT:    store i32 [[XY]], ptr [[ADDR:%.*]], align 4
; CHECK-NEXT:    [[SLY:%.*]] = shl nuw nsw i32 [[ZEXT_Y]], 22
; CHECK-NEXT:    [[YX:%.*]] = or disjoint i32 [[SLY]], [[ZEXT_X]]
; CHECK-NEXT:    ret i32 [[YX]]
;
  %zext.x = zext i8 %x to i32
  %slx = shl i32 %zext.x, 9
  %zext.y = zext i8 %y to i32
  %xy = or i32 %zext.y, %slx
  store i32 %xy, ptr %addr, align 4
  %sly = shl i32 %zext.y, 22
  %yx = or i32 %zext.x, %sly
  ret i32 %yx
}

define i32 @fshl_concat_unknown_source(i32 %zext.x, i32 %zext.y, ptr %addr) {
; CHECK-LABEL: @fshl_concat_unknown_source(
; CHECK-NEXT:    [[SLX:%.*]] = shl i32 [[ZEXT_X:%.*]], 16
; CHECK-NEXT:    [[XY:%.*]] = or i32 [[SLX]], [[ZEXT_Y:%.*]]
; CHECK-NEXT:    store i32 [[XY]], ptr [[ADDR:%.*]], align 4
; CHECK-NEXT:    [[SLY:%.*]] = shl i32 [[ZEXT_Y]], 16
; CHECK-NEXT:    [[YX:%.*]] = or i32 [[SLY]], [[ZEXT_X]]
; CHECK-NEXT:    ret i32 [[YX]]
;
  %slx = shl i32 %zext.x, 16
  %xy = or i32 %zext.y, %slx
  store i32 %xy, ptr %addr, align 4
  %sly = shl i32 %zext.y, 16
  %yx = or i32 %zext.x, %sly
  ret i32 %yx
}

define <2 x i32> @fshl_concat_vector(<2 x i8> %x, <2 x i24> %y, ptr %addr) {
; CHECK-LABEL: @fshl_concat_vector(
; CHECK-NEXT:    [[ZEXT_X:%.*]] = zext <2 x i8> [[X:%.*]] to <2 x i32>
; CHECK-NEXT:    [[SLX:%.*]] = shl nuw <2 x i32> [[ZEXT_X]], <i32 24, i32 24>
; CHECK-NEXT:    [[ZEXT_Y:%.*]] = zext <2 x i24> [[Y:%.*]] to <2 x i32>
; CHECK-NEXT:    [[XY:%.*]] = or disjoint <2 x i32> [[SLX]], [[ZEXT_Y]]
; CHECK-NEXT:    store <2 x i32> [[XY]], ptr [[ADDR:%.*]], align 4
; CHECK-NEXT:    [[YX:%.*]] = call <2 x i32> @llvm.fshl.v2i32(<2 x i32> [[XY]], <2 x i32> [[XY]], <2 x i32> <i32 8, i32 8>)
; CHECK-NEXT:    ret <2 x i32> [[YX]]
;
  %zext.x = zext <2 x i8> %x to <2 x i32>
  %slx = shl <2 x i32> %zext.x, <i32 24, i32 24>
  %zext.y = zext <2 x i24> %y to <2 x i32>
  %xy = or <2 x i32> %slx, %zext.y
  store <2 x i32> %xy, ptr %addr, align 4
  %sly = shl <2 x i32> %zext.y, <i32 8, i32 8>
  %yx = or <2 x i32> %sly, %zext.x
  ret <2 x i32> %yx
}

; Negative test - an oversized shift in the narrow type would produce the wrong value.

define i8 @unmasked_shlop_unmasked_shift_amount(i32 %x, i32 %y, i32 %shamt) {
; CHECK-LABEL: @unmasked_shlop_unmasked_shift_amount(
; CHECK-NEXT:    [[MASKY:%.*]] = and i32 [[Y:%.*]], 255
; CHECK-NEXT:    [[T4:%.*]] = sub i32 8, [[SHAMT:%.*]]
; CHECK-NEXT:    [[T5:%.*]] = shl i32 [[X:%.*]], [[T4]]
; CHECK-NEXT:    [[T6:%.*]] = lshr i32 [[MASKY]], [[SHAMT]]
; CHECK-NEXT:    [[T7:%.*]] = or i32 [[T5]], [[T6]]
; CHECK-NEXT:    [[T8:%.*]] = trunc i32 [[T7]] to i8
; CHECK-NEXT:    ret i8 [[T8]]
;
  %masky = and i32 %y, 255
  %t4 = sub i32 8, %shamt
  %t5 = shl i32 %x, %t4
  %t6 = lshr i32 %masky, %shamt
  %t7 = or i32 %t5, %t6
  %t8 = trunc i32 %t7 to i8
  ret i8 %t8
}

; Negative test - an oversized shift in the narrow type would produce the wrong value.

define i8 @unmasked_shlop_insufficient_mask_shift_amount(i16 %x, i16 %y, i16 %shamt) {
; CHECK-LABEL: @unmasked_shlop_insufficient_mask_shift_amount(
; CHECK-NEXT:    [[SHM:%.*]] = and i16 [[SHAMT:%.*]], 15
; CHECK-NEXT:    [[MASKX:%.*]] = and i16 [[X:%.*]], 255
; CHECK-NEXT:    [[T4:%.*]] = sub nsw i16 8, [[SHM]]
; CHECK-NEXT:    [[T5:%.*]] = shl i16 [[Y:%.*]], [[T4]]
; CHECK-NEXT:    [[T6:%.*]] = lshr i16 [[MASKX]], [[SHM]]
; CHECK-NEXT:    [[T7:%.*]] = or i16 [[T5]], [[T6]]
; CHECK-NEXT:    [[T8:%.*]] = trunc i16 [[T7]] to i8
; CHECK-NEXT:    ret i8 [[T8]]
;
  %shm = and i16 %shamt, 15
  %maskx = and i16 %x, 255
  %t4 = sub i16 8, %shm
  %t5 = shl i16 %y, %t4
  %t6 = lshr i16 %maskx, %shm
  %t7 = or i16 %t5, %t6
  %t8 = trunc i16 %t7 to i8
  ret i8 %t8
}

define i8 @unmasked_shlop_masked_shift_amount(i16 %x, i16 %y, i16 %shamt) {
; CHECK-LABEL: @unmasked_shlop_masked_shift_amount(
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i16 [[SHAMT:%.*]] to i8
; CHECK-NEXT:    [[TMP2:%.*]] = trunc i16 [[Y:%.*]] to i8
; CHECK-NEXT:    [[TMP3:%.*]] = trunc i16 [[X:%.*]] to i8
; CHECK-NEXT:    [[T8:%.*]] = call i8 @llvm.fshr.i8(i8 [[TMP2]], i8 [[TMP3]], i8 [[TMP1]])
; CHECK-NEXT:    ret i8 [[T8]]
;
  %shm = and i16 %shamt, 7
  %maskx = and i16 %x, 255
  %t4 = sub i16 8, %shm
  %t5 = shl i16 %y, %t4
  %t6 = lshr i16 %maskx, %shm
  %t7 = or i16 %t5, %t6
  %t8 = trunc i16 %t7 to i8
  ret i8 %t8
}

define i32 @test_rotl_and_neg(i32 %x, i32 %shamt) {
; CHECK-LABEL: @test_rotl_and_neg(
; CHECK-NEXT:    [[OR:%.*]] = call i32 @llvm.fshl.i32(i32 [[X:%.*]], i32 [[X]], i32 [[SHAMT:%.*]])
; CHECK-NEXT:    ret i32 [[OR]]
;
  %shl = shl i32 %x, %shamt
  %neg = sub i32 0, %shamt
  %and = and i32 %neg, 31
  %shr = lshr i32 %x, %and
  %or = or i32 %shl, %shr
  ret i32 %or
}

define i32 @test_rotl_and_neg_commuted(i32 %x, i32 %shamt) {
; CHECK-LABEL: @test_rotl_and_neg_commuted(
; CHECK-NEXT:    [[OR:%.*]] = call i32 @llvm.fshl.i32(i32 [[X:%.*]], i32 [[X]], i32 [[SHAMT:%.*]])
; CHECK-NEXT:    ret i32 [[OR]]
;
  %shl = shl i32 %x, %shamt
  %neg = sub i32 0, %shamt
  %and = and i32 %neg, 31
  %shr = lshr i32 %x, %and
  %or = or i32 %shr, %shl
  ret i32 %or
}

define i32 @test_rotr_and_neg(i32 %x, i32 %shamt) {
; CHECK-LABEL: @test_rotr_and_neg(
; CHECK-NEXT:    [[OR:%.*]] = call i32 @llvm.fshr.i32(i32 [[X:%.*]], i32 [[X]], i32 [[SHAMT:%.*]])
; CHECK-NEXT:    ret i32 [[OR]]
;
  %shr = lshr i32 %x, %shamt
  %neg = sub i32 0, %shamt
  %and = and i32 %neg, 31
  %shl = shl i32 %x, %and
  %or = or i32 %shl, %shr
  ret i32 %or
}

; Negative tests

; Only work for rotation patterns
define i32 @test_fshl_and_neg(i32 %x, i32 %y, i32 %shamt) {
; CHECK-LABEL: @test_fshl_and_neg(
; CHECK-NEXT:    [[SHL:%.*]] = shl i32 [[X:%.*]], [[SHAMT:%.*]]
; CHECK-NEXT:    [[NEG:%.*]] = sub i32 0, [[SHAMT]]
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[NEG]], 31
; CHECK-NEXT:    [[SHR:%.*]] = lshr i32 [[Y:%.*]], [[AND]]
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[SHL]], [[SHR]]
; CHECK-NEXT:    ret i32 [[OR]]
;
  %shl = shl i32 %x, %shamt
  %neg = sub i32 0, %shamt
  %and = and i32 %neg, 31
  %shr = lshr i32 %y, %and
  %or = or i32 %shl, %shr
  ret i32 %or
}

define i32 @test_rotl_and_neg_wrong_mask(i32 %x, i32 %shamt) {
; CHECK-LABEL: @test_rotl_and_neg_wrong_mask(
; CHECK-NEXT:    [[SHL:%.*]] = shl i32 [[X:%.*]], [[SHAMT:%.*]]
; CHECK-NEXT:    [[NEG:%.*]] = sub i32 0, [[SHAMT]]
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[NEG]], 15
; CHECK-NEXT:    [[SHR:%.*]] = lshr i32 [[X]], [[AND]]
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[SHL]], [[SHR]]
; CHECK-NEXT:    ret i32 [[OR]]
;
  %shl = shl i32 %x, %shamt
  %neg = sub i32 0, %shamt
  %and = and i32 %neg, 15
  %shr = lshr i32 %x, %and
  %or = or i32 %shl, %shr
  ret i32 %or
}
