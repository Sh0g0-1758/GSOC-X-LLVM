; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

define i1 @test1(i8 %A) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    ret i1 true
;
  %B = sitofp i8 %A to double
  %C = fcmp ult double %B, 128.0
  ret i1 %C
}

define i1 @test2(i8 %A) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    ret i1 true
;
  %B = sitofp i8 %A to double
  %C = fcmp ugt double %B, -128.1
  ret i1 %C
}

define i1 @test3(i8 %A) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    ret i1 true
;
  %B = sitofp i8 %A to double
  %C = fcmp ule double %B, 127.0
  ret i1 %C
}

define i1 @test4(i8 %A) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[C:%.*]] = icmp ne i8 [[A:%.*]], 127
; CHECK-NEXT:    ret i1 [[C]]
;
  %B = sitofp i8 %A to double
  %C = fcmp ult double %B, 127.0
  ret i1 %C
}

define i32 @test5(i32 %A) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    ret i32 [[A:%.*]]
;
  %B = sitofp i32 %A to double
  %C = fptosi double %B to i32
  %D = uitofp i32 %C to double
  %E = fptoui double %D to i32
  ret i32 %E
}

define i32 @test6(i32 %A) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    [[ADDCONV:%.*]] = and i32 [[A:%.*]], 39
; CHECK-NEXT:    ret i32 [[ADDCONV]]
;
  %B = and i32 %A, 7
  %C = and i32 %A, 32
  %D = sitofp i32 %B to double
  %E = sitofp i32 %C to double
  %F = fadd double %D, %E
  %G = fptosi double %F to i32
  ret i32 %G
}

define i32 @test7(i32 %A) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    ret i32 [[A:%.*]]
;
  %B = sitofp i32 %A to double
  %C = fptoui double %B to i32
  ret i32 %C
}

define i32 @test8(i32 %A) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    ret i32 [[A:%.*]]
;
  %B = uitofp i32 %A to double
  %C = fptosi double %B to i32
  ret i32 %C
}

define i32 @test9(i8 %A) {
; CHECK-LABEL: @test9(
; CHECK-NEXT:    [[C:%.*]] = zext i8 [[A:%.*]] to i32
; CHECK-NEXT:    ret i32 [[C]]
;
  %B = sitofp i8 %A to float
  %C = fptoui float %B to i32
  ret i32 %C
}

define i32 @test10(i8 %A) {
; CHECK-LABEL: @test10(
; CHECK-NEXT:    [[C:%.*]] = sext i8 [[A:%.*]] to i32
; CHECK-NEXT:    ret i32 [[C]]
;
  %B = sitofp i8 %A to float
  %C = fptosi float %B to i32
  ret i32 %C
}

; If the input value is outside of the range of the output cast, it's
; undefined behavior, so we can assume it fits.

define i8 @test11(i32 %A) {
; CHECK-LABEL: @test11(
; CHECK-NEXT:    [[C:%.*]] = trunc i32 [[A:%.*]] to i8
; CHECK-NEXT:    ret i8 [[C]]
;
  %B = sitofp i32 %A to float
  %C = fptosi float %B to i8
  ret i8 %C
}

; If the input value is negative, it'll be outside the range of the
; output cast, and thus undefined behavior.

define i32 @test12(i8 %A) {
; CHECK-LABEL: @test12(
; CHECK-NEXT:    [[C:%.*]] = zext i8 [[A:%.*]] to i32
; CHECK-NEXT:    ret i32 [[C]]
;
  %B = sitofp i8 %A to float
  %C = fptoui float %B to i32
  ret i32 %C
}

; This can't fold because the 25-bit input doesn't fit in the mantissa.

define i32 @test13(i25 %A) {
; CHECK-LABEL: @test13(
; CHECK-NEXT:    [[B:%.*]] = uitofp i25 [[A:%.*]] to float
; CHECK-NEXT:    [[C:%.*]] = fptoui float [[B]] to i32
; CHECK-NEXT:    ret i32 [[C]]
;
  %B = uitofp i25 %A to float
  %C = fptoui float %B to i32
  ret i32 %C
}

; But this one can.

define i32 @test14(i24 %A) {
; CHECK-LABEL: @test14(
; CHECK-NEXT:    [[C:%.*]] = zext i24 [[A:%.*]] to i32
; CHECK-NEXT:    ret i32 [[C]]
;
  %B = uitofp i24 %A to float
  %C = fptoui float %B to i32
  ret i32 %C
}

; And this one can too.

define i24 @test15(i32 %A) {
; CHECK-LABEL: @test15(
; CHECK-NEXT:    [[C:%.*]] = trunc i32 [[A:%.*]] to i24
; CHECK-NEXT:    ret i24 [[C]]
;
  %B = uitofp i32 %A to float
  %C = fptoui float %B to i24
  ret i24 %C
}

; This can fold because the 25-bit input is signed and we discard the sign bit.

define i32 @test16(i25 %A) {
; CHECK-LABEL: @test16(
; CHECK-NEXT:    [[C:%.*]] = zext i25 [[A:%.*]] to i32
; CHECK-NEXT:    ret i32 [[C]]
;
  %B = sitofp i25 %A to float
  %C = fptoui float %B to i32
  ret i32 %C
}

; This can't fold because the 26-bit input won't fit the mantissa
; even after discarding the signed bit.

define i32 @test17(i26 %A) {
; CHECK-LABEL: @test17(
; CHECK-NEXT:    [[B:%.*]] = sitofp i26 [[A:%.*]] to float
; CHECK-NEXT:    [[C:%.*]] = fptoui float [[B]] to i32
; CHECK-NEXT:    ret i32 [[C]]
;
  %B = sitofp i26 %A to float
  %C = fptoui float %B to i32
  ret i32 %C
}

; This can't fold because the 54-bit output is big enough to hold an input
; that was rounded when converted to double.

define i54 @test18(i64 %A) {
; CHECK-LABEL: @test18(
; CHECK-NEXT:    [[B:%.*]] = sitofp i64 [[A:%.*]] to double
; CHECK-NEXT:    [[C:%.*]] = fptosi double [[B]] to i54
; CHECK-NEXT:    ret i54 [[C]]
;
  %B = sitofp i64 %A to double
  %C = fptosi double %B to i54
  ret i54 %C
}

; This can't fold because the 55-bit output won't fit the mantissa
; even after discarding the sign bit.

define i55 @test19(i64 %A) {
; CHECK-LABEL: @test19(
; CHECK-NEXT:    [[B:%.*]] = sitofp i64 [[A:%.*]] to double
; CHECK-NEXT:    [[C:%.*]] = fptosi double [[B]] to i55
; CHECK-NEXT:    ret i55 [[C]]
;
  %B = sitofp i64 %A to double
  %C = fptosi double %B to i55
  ret i55 %C
}

; The mask guarantees that the input is small enough to eliminate the FP casts.

define i25 @masked_input(i25 %A) {
; CHECK-LABEL: @masked_input(
; CHECK-NEXT:    [[M:%.*]] = and i25 [[A:%.*]], 65535
; CHECK-NEXT:    ret i25 [[M]]
;
  %m = and i25 %A, 65535
  %B = uitofp i25 %m to float
  %C = fptoui float %B to i25
  ret i25 %C
}

define i25 @max_masked_input(i25 %A) {
; CHECK-LABEL: @max_masked_input(
; CHECK-NEXT:    [[M:%.*]] = and i25 [[A:%.*]], 16777215
; CHECK-NEXT:    ret i25 [[M]]
;
  %m = and i25 %A, 16777215    ; max intermediate 16777215 (= 1 << 24)-1
  %B = uitofp i25 %m to float
  %C = fptoui float %B to i25
  ret i25 %C
}

define i25 @consider_lowbits_masked_input(i25 %A) {
; CHECK-LABEL: @consider_lowbits_masked_input(
; CHECK-NEXT:    [[M:%.*]] = and i25 [[A:%.*]], -16777214
; CHECK-NEXT:    ret i25 [[M]]
;
  %m = and i25 %A, 16777218  ; Make use of the low zero bits - intermediate 16777218 (= 1 << 24 + 2)
  %B = uitofp i25 %m to float
  %C = fptoui float %B to i25
  ret i25 %C
}

define i32 @overflow_masked_input(i32 %A) {
; CHECK-LABEL: @overflow_masked_input(
; CHECK-NEXT:    [[M:%.*]] = and i32 [[A:%.*]], 16777217
; CHECK-NEXT:    [[B:%.*]] = uitofp i32 [[M]] to float
; CHECK-NEXT:    [[C:%.*]] = fptoui float [[B]] to i32
; CHECK-NEXT:    ret i32 [[C]]
;
  %m = and i32 %A, 16777217  ; Negative test - intermediate 16777217 (= 1 << 24 + 1)
  %B = uitofp i32 %m to float
  %C = fptoui float %B to i32
  ret i32 %C
}

; Clear the low bit - guarantees that the input is converted to FP without rounding.

define i25 @low_masked_input(i25 %A) {
; CHECK-LABEL: @low_masked_input(
; CHECK-NEXT:    [[M:%.*]] = and i25 [[A:%.*]], -2
; CHECK-NEXT:    ret i25 [[M]]
;
  %m = and i25 %A, -2
  %B = uitofp i25 %m to float
  %C = fptoui float %B to i25
  ret i25 %C
}

; Output is small enough to ensure exact cast (overflow produces poison).

define i11 @s32_half_s11(i32 %x) {
; CHECK-LABEL: @s32_half_s11(
; CHECK-NEXT:    [[R:%.*]] = trunc i32 [[X:%.*]] to i11
; CHECK-NEXT:    ret i11 [[R]]
;
  %h = sitofp i32 %x to half
  %r = fptosi half %h to i11
  ret i11 %r
}

; Output is small enough to ensure exact cast (overflow produces poison).

define i11 @s32_half_u11(i32 %x) {
; CHECK-LABEL: @s32_half_u11(
; CHECK-NEXT:    [[R:%.*]] = trunc i32 [[X:%.*]] to i11
; CHECK-NEXT:    ret i11 [[R]]
;
  %h = sitofp i32 %x to half
  %r = fptoui half %h to i11
  ret i11 %r
}

; Output is small enough to ensure exact cast (overflow produces poison).

define i11 @u32_half_s11(i32 %x) {
; CHECK-LABEL: @u32_half_s11(
; CHECK-NEXT:    [[R:%.*]] = trunc i32 [[X:%.*]] to i11
; CHECK-NEXT:    ret i11 [[R]]
;
  %h = uitofp i32 %x to half
  %r = fptosi half %h to i11
  ret i11 %r
}

; Output is small enough to ensure exact cast (overflow produces poison).

define i11 @u32_half_u11(i32 %x) {
; CHECK-LABEL: @u32_half_u11(
; CHECK-NEXT:    [[R:%.*]] = trunc i32 [[X:%.*]] to i11
; CHECK-NEXT:    ret i11 [[R]]
;
  %h = uitofp i32 %x to half
  %r = fptoui half %h to i11
  ret i11 %r
}

; Too many bits in output to ensure exact cast.

define i12 @s32_half_s12(i32 %x) {
; CHECK-LABEL: @s32_half_s12(
; CHECK-NEXT:    [[H:%.*]] = sitofp i32 [[X:%.*]] to half
; CHECK-NEXT:    [[R:%.*]] = fptosi half [[H]] to i12
; CHECK-NEXT:    ret i12 [[R]]
;
  %h = sitofp i32 %x to half
  %r = fptosi half %h to i12
  ret i12 %r
}

; Too many bits in output to ensure exact cast.

define i12 @s32_half_u12(i32 %x) {
; CHECK-LABEL: @s32_half_u12(
; CHECK-NEXT:    [[H:%.*]] = sitofp i32 [[X:%.*]] to half
; CHECK-NEXT:    [[R:%.*]] = fptoui half [[H]] to i12
; CHECK-NEXT:    ret i12 [[R]]
;
  %h = sitofp i32 %x to half
  %r = fptoui half %h to i12
  ret i12 %r
}

; TODO: This is safe to convert to trunc.

define i12 @u32_half_s12(i32 %x) {
; CHECK-LABEL: @u32_half_s12(
; CHECK-NEXT:    [[H:%.*]] = uitofp i32 [[X:%.*]] to half
; CHECK-NEXT:    [[R:%.*]] = fptosi half [[H]] to i12
; CHECK-NEXT:    ret i12 [[R]]
;
  %h = uitofp i32 %x to half
  %r = fptosi half %h to i12
  ret i12 %r
}

; Too many bits in output to ensure exact cast.

define i12 @u32_half_u12(i32 %x) {
; CHECK-LABEL: @u32_half_u12(
; CHECK-NEXT:    [[H:%.*]] = uitofp i32 [[X:%.*]] to half
; CHECK-NEXT:    [[R:%.*]] = fptoui half [[H]] to i12
; CHECK-NEXT:    ret i12 [[R]]
;
  %h = uitofp i32 %x to half
  %r = fptoui half %h to i12
  ret i12 %r
}

define <2 x i1> @i8_vec_sitofp_test1(<2 x i8> %A) {
; CHECK-LABEL: @i8_vec_sitofp_test1(
; CHECK-NEXT:    ret <2 x i1> <i1 true, i1 true>
;
  %B = sitofp <2 x i8> %A to <2 x double>
  %C = fcmp ult <2 x double> %B, <double 128.0, double 128.0>
  ret <2 x i1> %C
}

define <2 x i1> @i8_vec_sitofp_test2(<2 x i8> %A) {
; CHECK-LABEL: @i8_vec_sitofp_test2(
; CHECK-NEXT:    ret <2 x i1> <i1 true, i1 true>
;
  %B = sitofp <2 x i8> %A to <2 x double>
  %C = fcmp ugt <2 x double> %B, <double -128.1, double -128.1>
  ret <2 x i1> %C
}

define <2 x i1> @i8_vec_sitofp_test3(<2 x i8> %A) {
; CHECK-LABEL: @i8_vec_sitofp_test3(
; CHECK-NEXT:    ret <2 x i1> <i1 true, i1 true>
;
  %B = sitofp <2 x i8> %A to <2 x double>
  %C = fcmp ule <2 x double> %B, <double 127.0, double 127.0>
  ret <2 x i1> %C
}

define <2 x i1> @i8_vec_sitofp_test4(<2 x i8> %A) {
; CHECK-LABEL: @i8_vec_sitofp_test4(
; CHECK-NEXT:    [[C:%.*]] = icmp ne <2 x i8> [[A:%.*]], <i8 127, i8 127>
; CHECK-NEXT:    ret <2 x i1> [[C]]
;
  %B = sitofp <2 x i8> %A to <2 x double>
  %C = fcmp ult <2 x double> %B, <double 127.0, double 127.0>
  ret <2 x i1> %C
}
