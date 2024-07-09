; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=ppc32-- | FileCheck %s --check-prefixes=CHECK,CHECK32,CHECK32_32
; RUN: llc < %s -mtriple=ppc32-- -mcpu=ppc64 | FileCheck %s --check-prefixes=CHECK,CHECK32,CHECK32_64
; RUN: llc < %s -mtriple=powerpc64le-- | FileCheck %s --check-prefixes=CHECK,CHECK64

declare i8 @llvm.fshl.i8(i8, i8, i8)
declare i16 @llvm.fshl.i16(i16, i16, i16)
declare i32 @llvm.fshl.i32(i32, i32, i32)
declare i64 @llvm.fshl.i64(i64, i64, i64)
declare i128 @llvm.fshl.i128(i128, i128, i128)
declare <4 x i32> @llvm.fshl.v4i32(<4 x i32>, <4 x i32>, <4 x i32>)

declare i8 @llvm.fshr.i8(i8, i8, i8)
declare i16 @llvm.fshr.i16(i16, i16, i16)
declare i32 @llvm.fshr.i32(i32, i32, i32)
declare i64 @llvm.fshr.i64(i64, i64, i64)
declare <4 x i32> @llvm.fshr.v4i32(<4 x i32>, <4 x i32>, <4 x i32>)

; General case - all operands can be variables.

define i32 @fshl_i32(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: fshl_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    clrlwi 5, 5, 27
; CHECK-NEXT:    slw 3, 3, 5
; CHECK-NEXT:    subfic 5, 5, 32
; CHECK-NEXT:    srw 4, 4, 5
; CHECK-NEXT:    or 3, 3, 4
; CHECK-NEXT:    blr
  %f = call i32 @llvm.fshl.i32(i32 %x, i32 %y, i32 %z)
  ret i32 %f
}

define i64 @fshl_i64(i64 %x, i64 %y, i64 %z) {
; CHECK32-LABEL: fshl_i64:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    andi. 7, 8, 32
; CHECK32-NEXT:    mr 7, 5
; CHECK32-NEXT:    bne 0, .LBB1_2
; CHECK32-NEXT:  # %bb.1:
; CHECK32-NEXT:    mr 7, 4
; CHECK32-NEXT:  .LBB1_2:
; CHECK32-NEXT:    clrlwi 8, 8, 27
; CHECK32-NEXT:    subfic 9, 8, 32
; CHECK32-NEXT:    srw 10, 7, 9
; CHECK32-NEXT:    bne 0, .LBB1_4
; CHECK32-NEXT:  # %bb.3:
; CHECK32-NEXT:    mr 4, 3
; CHECK32-NEXT:  .LBB1_4:
; CHECK32-NEXT:    slw 3, 4, 8
; CHECK32-NEXT:    or 3, 3, 10
; CHECK32-NEXT:    bne 0, .LBB1_6
; CHECK32-NEXT:  # %bb.5:
; CHECK32-NEXT:    mr 6, 5
; CHECK32-NEXT:  .LBB1_6:
; CHECK32-NEXT:    srw 4, 6, 9
; CHECK32-NEXT:    slw 5, 7, 8
; CHECK32-NEXT:    or 4, 5, 4
; CHECK32-NEXT:    blr
;
; CHECK64-LABEL: fshl_i64:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    clrlwi 5, 5, 26
; CHECK64-NEXT:    sld 3, 3, 5
; CHECK64-NEXT:    subfic 5, 5, 64
; CHECK64-NEXT:    srd 4, 4, 5
; CHECK64-NEXT:    or 3, 3, 4
; CHECK64-NEXT:    blr
  %f = call i64 @llvm.fshl.i64(i64 %x, i64 %y, i64 %z)
  ret i64 %f
}

define i128 @fshl_i128(i128 %x, i128 %y, i128 %z) nounwind {
; CHECK32_32-LABEL: fshl_i128:
; CHECK32_32:       # %bb.0:
; CHECK32_32-NEXT:    stwu 1, -32(1)
; CHECK32_32-NEXT:    lwz 12, 52(1)
; CHECK32_32-NEXT:    stw 29, 20(1) # 4-byte Folded Spill
; CHECK32_32-NEXT:    andi. 11, 12, 64
; CHECK32_32-NEXT:    mcrf 1, 0
; CHECK32_32-NEXT:    mr 11, 6
; CHECK32_32-NEXT:    stw 30, 24(1) # 4-byte Folded Spill
; CHECK32_32-NEXT:    bne 0, .LBB2_2
; CHECK32_32-NEXT:  # %bb.1:
; CHECK32_32-NEXT:    mr 11, 4
; CHECK32_32-NEXT:  .LBB2_2:
; CHECK32_32-NEXT:    mr 30, 7
; CHECK32_32-NEXT:    bne 1, .LBB2_4
; CHECK32_32-NEXT:  # %bb.3:
; CHECK32_32-NEXT:    mr 30, 5
; CHECK32_32-NEXT:  .LBB2_4:
; CHECK32_32-NEXT:    andi. 4, 12, 32
; CHECK32_32-NEXT:    mr 4, 30
; CHECK32_32-NEXT:    beq 0, .LBB2_18
; CHECK32_32-NEXT:  # %bb.5:
; CHECK32_32-NEXT:    beq 1, .LBB2_19
; CHECK32_32-NEXT:  .LBB2_6:
; CHECK32_32-NEXT:    beq 0, .LBB2_20
; CHECK32_32-NEXT:  .LBB2_7:
; CHECK32_32-NEXT:    mr 5, 8
; CHECK32_32-NEXT:    beq 1, .LBB2_21
; CHECK32_32-NEXT:  .LBB2_8:
; CHECK32_32-NEXT:    mr 3, 5
; CHECK32_32-NEXT:    beq 0, .LBB2_22
; CHECK32_32-NEXT:  .LBB2_9:
; CHECK32_32-NEXT:    clrlwi 6, 12, 27
; CHECK32_32-NEXT:    bne 1, .LBB2_11
; CHECK32_32-NEXT:  .LBB2_10:
; CHECK32_32-NEXT:    mr 9, 7
; CHECK32_32-NEXT:  .LBB2_11:
; CHECK32_32-NEXT:    subfic 7, 6, 32
; CHECK32_32-NEXT:    mr 12, 9
; CHECK32_32-NEXT:    bne 0, .LBB2_13
; CHECK32_32-NEXT:  # %bb.12:
; CHECK32_32-NEXT:    mr 12, 5
; CHECK32_32-NEXT:  .LBB2_13:
; CHECK32_32-NEXT:    srw 5, 4, 7
; CHECK32_32-NEXT:    slw 11, 11, 6
; CHECK32_32-NEXT:    srw 0, 3, 7
; CHECK32_32-NEXT:    slw 4, 4, 6
; CHECK32_32-NEXT:    srw 30, 12, 7
; CHECK32_32-NEXT:    slw 29, 3, 6
; CHECK32_32-NEXT:    bne 1, .LBB2_15
; CHECK32_32-NEXT:  # %bb.14:
; CHECK32_32-NEXT:    mr 10, 8
; CHECK32_32-NEXT:  .LBB2_15:
; CHECK32_32-NEXT:    or 3, 11, 5
; CHECK32_32-NEXT:    or 4, 4, 0
; CHECK32_32-NEXT:    or 5, 29, 30
; CHECK32_32-NEXT:    bne 0, .LBB2_17
; CHECK32_32-NEXT:  # %bb.16:
; CHECK32_32-NEXT:    mr 10, 9
; CHECK32_32-NEXT:  .LBB2_17:
; CHECK32_32-NEXT:    srw 7, 10, 7
; CHECK32_32-NEXT:    slw 6, 12, 6
; CHECK32_32-NEXT:    or 6, 6, 7
; CHECK32_32-NEXT:    lwz 30, 24(1) # 4-byte Folded Reload
; CHECK32_32-NEXT:    lwz 29, 20(1) # 4-byte Folded Reload
; CHECK32_32-NEXT:    addi 1, 1, 32
; CHECK32_32-NEXT:    blr
; CHECK32_32-NEXT:  .LBB2_18:
; CHECK32_32-NEXT:    mr 4, 11
; CHECK32_32-NEXT:    bne 1, .LBB2_6
; CHECK32_32-NEXT:  .LBB2_19:
; CHECK32_32-NEXT:    mr 5, 3
; CHECK32_32-NEXT:    bne 0, .LBB2_7
; CHECK32_32-NEXT:  .LBB2_20:
; CHECK32_32-NEXT:    mr 11, 5
; CHECK32_32-NEXT:    mr 5, 8
; CHECK32_32-NEXT:    bne 1, .LBB2_8
; CHECK32_32-NEXT:  .LBB2_21:
; CHECK32_32-NEXT:    mr 5, 6
; CHECK32_32-NEXT:    mr 3, 5
; CHECK32_32-NEXT:    bne 0, .LBB2_9
; CHECK32_32-NEXT:  .LBB2_22:
; CHECK32_32-NEXT:    mr 3, 30
; CHECK32_32-NEXT:    clrlwi 6, 12, 27
; CHECK32_32-NEXT:    beq 1, .LBB2_10
; CHECK32_32-NEXT:    b .LBB2_11
;
; CHECK32_64-LABEL: fshl_i128:
; CHECK32_64:       # %bb.0:
; CHECK32_64-NEXT:    stwu 1, -32(1)
; CHECK32_64-NEXT:    lwz 12, 52(1)
; CHECK32_64-NEXT:    andi. 11, 12, 64
; CHECK32_64-NEXT:    stw 29, 20(1) # 4-byte Folded Spill
; CHECK32_64-NEXT:    mcrf 1, 0
; CHECK32_64-NEXT:    mr 11, 6
; CHECK32_64-NEXT:    stw 30, 24(1) # 4-byte Folded Spill
; CHECK32_64-NEXT:    bne 0, .LBB2_2
; CHECK32_64-NEXT:  # %bb.1:
; CHECK32_64-NEXT:    mr 11, 4
; CHECK32_64-NEXT:  .LBB2_2:
; CHECK32_64-NEXT:    mr 30, 7
; CHECK32_64-NEXT:    bne 1, .LBB2_4
; CHECK32_64-NEXT:  # %bb.3:
; CHECK32_64-NEXT:    mr 30, 5
; CHECK32_64-NEXT:  .LBB2_4:
; CHECK32_64-NEXT:    andi. 4, 12, 32
; CHECK32_64-NEXT:    mr 4, 30
; CHECK32_64-NEXT:    beq 0, .LBB2_18
; CHECK32_64-NEXT:  # %bb.5:
; CHECK32_64-NEXT:    beq 1, .LBB2_19
; CHECK32_64-NEXT:  .LBB2_6:
; CHECK32_64-NEXT:    beq 0, .LBB2_20
; CHECK32_64-NEXT:  .LBB2_7:
; CHECK32_64-NEXT:    mr 5, 8
; CHECK32_64-NEXT:    beq 1, .LBB2_21
; CHECK32_64-NEXT:  .LBB2_8:
; CHECK32_64-NEXT:    mr 3, 5
; CHECK32_64-NEXT:    beq 0, .LBB2_22
; CHECK32_64-NEXT:  .LBB2_9:
; CHECK32_64-NEXT:    clrlwi 6, 12, 27
; CHECK32_64-NEXT:    bne 1, .LBB2_11
; CHECK32_64-NEXT:  .LBB2_10:
; CHECK32_64-NEXT:    mr 9, 7
; CHECK32_64-NEXT:  .LBB2_11:
; CHECK32_64-NEXT:    subfic 7, 6, 32
; CHECK32_64-NEXT:    mr 12, 9
; CHECK32_64-NEXT:    bne 0, .LBB2_13
; CHECK32_64-NEXT:  # %bb.12:
; CHECK32_64-NEXT:    mr 12, 5
; CHECK32_64-NEXT:  .LBB2_13:
; CHECK32_64-NEXT:    srw 5, 4, 7
; CHECK32_64-NEXT:    slw 11, 11, 6
; CHECK32_64-NEXT:    srw 0, 3, 7
; CHECK32_64-NEXT:    slw 4, 4, 6
; CHECK32_64-NEXT:    srw 30, 12, 7
; CHECK32_64-NEXT:    slw 29, 3, 6
; CHECK32_64-NEXT:    bne 1, .LBB2_15
; CHECK32_64-NEXT:  # %bb.14:
; CHECK32_64-NEXT:    mr 10, 8
; CHECK32_64-NEXT:  .LBB2_15:
; CHECK32_64-NEXT:    or 3, 11, 5
; CHECK32_64-NEXT:    or 4, 4, 0
; CHECK32_64-NEXT:    or 5, 29, 30
; CHECK32_64-NEXT:    bne 0, .LBB2_17
; CHECK32_64-NEXT:  # %bb.16:
; CHECK32_64-NEXT:    mr 10, 9
; CHECK32_64-NEXT:  .LBB2_17:
; CHECK32_64-NEXT:    srw 7, 10, 7
; CHECK32_64-NEXT:    slw 6, 12, 6
; CHECK32_64-NEXT:    lwz 30, 24(1) # 4-byte Folded Reload
; CHECK32_64-NEXT:    or 6, 6, 7
; CHECK32_64-NEXT:    lwz 29, 20(1) # 4-byte Folded Reload
; CHECK32_64-NEXT:    addi 1, 1, 32
; CHECK32_64-NEXT:    blr
; CHECK32_64-NEXT:  .LBB2_18:
; CHECK32_64-NEXT:    mr 4, 11
; CHECK32_64-NEXT:    bne 1, .LBB2_6
; CHECK32_64-NEXT:  .LBB2_19:
; CHECK32_64-NEXT:    mr 5, 3
; CHECK32_64-NEXT:    bne 0, .LBB2_7
; CHECK32_64-NEXT:  .LBB2_20:
; CHECK32_64-NEXT:    mr 11, 5
; CHECK32_64-NEXT:    mr 5, 8
; CHECK32_64-NEXT:    bne 1, .LBB2_8
; CHECK32_64-NEXT:  .LBB2_21:
; CHECK32_64-NEXT:    mr 5, 6
; CHECK32_64-NEXT:    mr 3, 5
; CHECK32_64-NEXT:    bne 0, .LBB2_9
; CHECK32_64-NEXT:  .LBB2_22:
; CHECK32_64-NEXT:    mr 3, 30
; CHECK32_64-NEXT:    clrlwi 6, 12, 27
; CHECK32_64-NEXT:    beq 1, .LBB2_10
; CHECK32_64-NEXT:    b .LBB2_11
;
; CHECK64-LABEL: fshl_i128:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    andi. 8, 7, 64
; CHECK64-NEXT:    clrlwi 7, 7, 26
; CHECK64-NEXT:    subfic 8, 7, 64
; CHECK64-NEXT:    iseleq 5, 6, 5
; CHECK64-NEXT:    iseleq 6, 3, 6
; CHECK64-NEXT:    iseleq 3, 4, 3
; CHECK64-NEXT:    srd 5, 5, 8
; CHECK64-NEXT:    sld 9, 6, 7
; CHECK64-NEXT:    srd 6, 6, 8
; CHECK64-NEXT:    sld 3, 3, 7
; CHECK64-NEXT:    or 5, 9, 5
; CHECK64-NEXT:    or 4, 3, 6
; CHECK64-NEXT:    mr 3, 5
; CHECK64-NEXT:    blr
  %f = call i128 @llvm.fshl.i128(i128 %x, i128 %y, i128 %z)
  ret i128 %f
}

; Verify that weird types are minimally supported.
declare i37 @llvm.fshl.i37(i37, i37, i37)
define i37 @fshl_i37(i37 %x, i37 %y, i37 %z) {
; CHECK32_32-LABEL: fshl_i37:
; CHECK32_32:       # %bb.0:
; CHECK32_32-NEXT:    mflr 0
; CHECK32_32-NEXT:    stwu 1, -32(1)
; CHECK32_32-NEXT:    stw 0, 36(1)
; CHECK32_32-NEXT:    .cfi_def_cfa_offset 32
; CHECK32_32-NEXT:    .cfi_offset lr, 4
; CHECK32_32-NEXT:    .cfi_offset r27, -20
; CHECK32_32-NEXT:    .cfi_offset r28, -16
; CHECK32_32-NEXT:    .cfi_offset r29, -12
; CHECK32_32-NEXT:    .cfi_offset r30, -8
; CHECK32_32-NEXT:    stw 27, 12(1) # 4-byte Folded Spill
; CHECK32_32-NEXT:    mr 27, 5
; CHECK32_32-NEXT:    stw 28, 16(1) # 4-byte Folded Spill
; CHECK32_32-NEXT:    mr 28, 3
; CHECK32_32-NEXT:    stw 29, 20(1) # 4-byte Folded Spill
; CHECK32_32-NEXT:    mr 29, 4
; CHECK32_32-NEXT:    stw 30, 24(1) # 4-byte Folded Spill
; CHECK32_32-NEXT:    mr 30, 6
; CHECK32_32-NEXT:    clrlwi 3, 7, 27
; CHECK32_32-NEXT:    mr 4, 8
; CHECK32_32-NEXT:    li 5, 0
; CHECK32_32-NEXT:    li 6, 37
; CHECK32_32-NEXT:    bl __umoddi3
; CHECK32_32-NEXT:    rotlwi 5, 30, 27
; CHECK32_32-NEXT:    rlwimi 5, 27, 27, 0, 4
; CHECK32_32-NEXT:    andi. 3, 4, 32
; CHECK32_32-NEXT:    mr 6, 5
; CHECK32_32-NEXT:    bne 0, .LBB3_2
; CHECK32_32-NEXT:  # %bb.1:
; CHECK32_32-NEXT:    mr 6, 29
; CHECK32_32-NEXT:  .LBB3_2:
; CHECK32_32-NEXT:    clrlwi 4, 4, 27
; CHECK32_32-NEXT:    subfic 7, 4, 32
; CHECK32_32-NEXT:    srw 3, 6, 7
; CHECK32_32-NEXT:    bne 0, .LBB3_4
; CHECK32_32-NEXT:  # %bb.3:
; CHECK32_32-NEXT:    mr 29, 28
; CHECK32_32-NEXT:  .LBB3_4:
; CHECK32_32-NEXT:    slw 8, 29, 4
; CHECK32_32-NEXT:    or 3, 8, 3
; CHECK32_32-NEXT:    beq 0, .LBB3_6
; CHECK32_32-NEXT:  # %bb.5:
; CHECK32_32-NEXT:    slwi 5, 30, 27
; CHECK32_32-NEXT:  .LBB3_6:
; CHECK32_32-NEXT:    srw 5, 5, 7
; CHECK32_32-NEXT:    slw 4, 6, 4
; CHECK32_32-NEXT:    or 4, 4, 5
; CHECK32_32-NEXT:    lwz 30, 24(1) # 4-byte Folded Reload
; CHECK32_32-NEXT:    lwz 29, 20(1) # 4-byte Folded Reload
; CHECK32_32-NEXT:    lwz 28, 16(1) # 4-byte Folded Reload
; CHECK32_32-NEXT:    lwz 27, 12(1) # 4-byte Folded Reload
; CHECK32_32-NEXT:    lwz 0, 36(1)
; CHECK32_32-NEXT:    addi 1, 1, 32
; CHECK32_32-NEXT:    mtlr 0
; CHECK32_32-NEXT:    blr
;
; CHECK32_64-LABEL: fshl_i37:
; CHECK32_64:       # %bb.0:
; CHECK32_64-NEXT:    mflr 0
; CHECK32_64-NEXT:    stwu 1, -32(1)
; CHECK32_64-NEXT:    stw 0, 36(1)
; CHECK32_64-NEXT:    .cfi_def_cfa_offset 32
; CHECK32_64-NEXT:    .cfi_offset lr, 4
; CHECK32_64-NEXT:    .cfi_offset r27, -20
; CHECK32_64-NEXT:    .cfi_offset r28, -16
; CHECK32_64-NEXT:    .cfi_offset r29, -12
; CHECK32_64-NEXT:    .cfi_offset r30, -8
; CHECK32_64-NEXT:    stw 27, 12(1) # 4-byte Folded Spill
; CHECK32_64-NEXT:    mr 27, 5
; CHECK32_64-NEXT:    li 5, 0
; CHECK32_64-NEXT:    stw 28, 16(1) # 4-byte Folded Spill
; CHECK32_64-NEXT:    mr 28, 3
; CHECK32_64-NEXT:    clrlwi 3, 7, 27
; CHECK32_64-NEXT:    stw 29, 20(1) # 4-byte Folded Spill
; CHECK32_64-NEXT:    mr 29, 4
; CHECK32_64-NEXT:    mr 4, 8
; CHECK32_64-NEXT:    stw 30, 24(1) # 4-byte Folded Spill
; CHECK32_64-NEXT:    mr 30, 6
; CHECK32_64-NEXT:    li 6, 37
; CHECK32_64-NEXT:    bl __umoddi3
; CHECK32_64-NEXT:    rotlwi 5, 30, 27
; CHECK32_64-NEXT:    andi. 3, 4, 32
; CHECK32_64-NEXT:    rlwimi 5, 27, 27, 0, 4
; CHECK32_64-NEXT:    mr 6, 5
; CHECK32_64-NEXT:    bne 0, .LBB3_2
; CHECK32_64-NEXT:  # %bb.1:
; CHECK32_64-NEXT:    mr 6, 29
; CHECK32_64-NEXT:  .LBB3_2:
; CHECK32_64-NEXT:    clrlwi 4, 4, 27
; CHECK32_64-NEXT:    subfic 7, 4, 32
; CHECK32_64-NEXT:    srw 3, 6, 7
; CHECK32_64-NEXT:    bne 0, .LBB3_4
; CHECK32_64-NEXT:  # %bb.3:
; CHECK32_64-NEXT:    mr 29, 28
; CHECK32_64-NEXT:  .LBB3_4:
; CHECK32_64-NEXT:    slw 8, 29, 4
; CHECK32_64-NEXT:    or 3, 8, 3
; CHECK32_64-NEXT:    beq 0, .LBB3_6
; CHECK32_64-NEXT:  # %bb.5:
; CHECK32_64-NEXT:    slwi 5, 30, 27
; CHECK32_64-NEXT:  .LBB3_6:
; CHECK32_64-NEXT:    srw 5, 5, 7
; CHECK32_64-NEXT:    slw 4, 6, 4
; CHECK32_64-NEXT:    lwz 30, 24(1) # 4-byte Folded Reload
; CHECK32_64-NEXT:    or 4, 4, 5
; CHECK32_64-NEXT:    lwz 29, 20(1) # 4-byte Folded Reload
; CHECK32_64-NEXT:    lwz 28, 16(1) # 4-byte Folded Reload
; CHECK32_64-NEXT:    lwz 27, 12(1) # 4-byte Folded Reload
; CHECK32_64-NEXT:    lwz 0, 36(1)
; CHECK32_64-NEXT:    addi 1, 1, 32
; CHECK32_64-NEXT:    mtlr 0
; CHECK32_64-NEXT:    blr
;
; CHECK64-LABEL: fshl_i37:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    lis 7, 1771
; CHECK64-NEXT:    clrldi 6, 5, 27
; CHECK64-NEXT:    sldi 4, 4, 27
; CHECK64-NEXT:    ori 7, 7, 15941
; CHECK64-NEXT:    rldic 7, 7, 32, 5
; CHECK64-NEXT:    oris 7, 7, 12398
; CHECK64-NEXT:    ori 7, 7, 46053
; CHECK64-NEXT:    mulhdu 6, 6, 7
; CHECK64-NEXT:    mulli 6, 6, 37
; CHECK64-NEXT:    sub 5, 5, 6
; CHECK64-NEXT:    clrlwi 5, 5, 26
; CHECK64-NEXT:    sld 3, 3, 5
; CHECK64-NEXT:    subfic 5, 5, 64
; CHECK64-NEXT:    srd 4, 4, 5
; CHECK64-NEXT:    or 3, 3, 4
; CHECK64-NEXT:    blr
  %f = call i37 @llvm.fshl.i37(i37 %x, i37 %y, i37 %z)
  ret i37 %f
}

; extract(concat(0b1110000, 0b1111111) << 2) = 0b1000011

declare i7 @llvm.fshl.i7(i7, i7, i7)
define i7 @fshl_i7_const_fold() {
; CHECK-LABEL: fshl_i7_const_fold:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li 3, 67
; CHECK-NEXT:    blr
  %f = call i7 @llvm.fshl.i7(i7 112, i7 127, i7 2)
  ret i7 %f
}

; With constant shift amount, this is rotate + insert (missing extended mnemonics).

define i32 @fshl_i32_const_shift(i32 %x, i32 %y) {
; CHECK-LABEL: fshl_i32_const_shift:
; CHECK:       # %bb.0:
; CHECK-NEXT:    rotlwi 4, 4, 9
; CHECK-NEXT:    rlwimi 4, 3, 9, 0, 22
; CHECK-NEXT:    mr 3, 4
; CHECK-NEXT:    blr
  %f = call i32 @llvm.fshl.i32(i32 %x, i32 %y, i32 9)
  ret i32 %f
}

; Check modulo math on shift amount.

define i32 @fshl_i32_const_overshift(i32 %x, i32 %y) {
; CHECK-LABEL: fshl_i32_const_overshift:
; CHECK:       # %bb.0:
; CHECK-NEXT:    rotlwi 4, 4, 9
; CHECK-NEXT:    rlwimi 4, 3, 9, 0, 22
; CHECK-NEXT:    mr 3, 4
; CHECK-NEXT:    blr
  %f = call i32 @llvm.fshl.i32(i32 %x, i32 %y, i32 41)
  ret i32 %f
}

; 64-bit should also work.

define i64 @fshl_i64_const_overshift(i64 %x, i64 %y) {
; CHECK32-LABEL: fshl_i64_const_overshift:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    rotlwi 6, 6, 9
; CHECK32-NEXT:    rotlwi 3, 5, 9
; CHECK32-NEXT:    rlwimi 6, 5, 9, 0, 22
; CHECK32-NEXT:    rlwimi 3, 4, 9, 0, 22
; CHECK32-NEXT:    mr 4, 6
; CHECK32-NEXT:    blr
;
; CHECK64-LABEL: fshl_i64_const_overshift:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    rotldi 4, 4, 41
; CHECK64-NEXT:    rldimi 4, 3, 41, 0
; CHECK64-NEXT:    mr 3, 4
; CHECK64-NEXT:    blr
  %f = call i64 @llvm.fshl.i64(i64 %x, i64 %y, i64 105)
  ret i64 %f
}

; This should work without any node-specific logic.

define i8 @fshl_i8_const_fold() {
; CHECK-LABEL: fshl_i8_const_fold:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li 3, 128
; CHECK-NEXT:    blr
  %f = call i8 @llvm.fshl.i8(i8 255, i8 0, i8 7)
  ret i8 %f
}

; Repeat everything for funnel shift right.

; General case - all operands can be variables.

define i32 @fshr_i32(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: fshr_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    clrlwi 5, 5, 27
; CHECK-NEXT:    srw 4, 4, 5
; CHECK-NEXT:    subfic 5, 5, 32
; CHECK-NEXT:    slw 3, 3, 5
; CHECK-NEXT:    or 3, 3, 4
; CHECK-NEXT:    blr
  %f = call i32 @llvm.fshr.i32(i32 %x, i32 %y, i32 %z)
  ret i32 %f
}

define i64 @fshr_i64(i64 %x, i64 %y, i64 %z) {
; CHECK32-LABEL: fshr_i64:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    andi. 7, 8, 32
; CHECK32-NEXT:    mr 7, 5
; CHECK32-NEXT:    beq 0, .LBB10_2
; CHECK32-NEXT:  # %bb.1:
; CHECK32-NEXT:    mr 7, 4
; CHECK32-NEXT:  .LBB10_2:
; CHECK32-NEXT:    clrlwi 8, 8, 27
; CHECK32-NEXT:    srw 10, 7, 8
; CHECK32-NEXT:    beq 0, .LBB10_4
; CHECK32-NEXT:  # %bb.3:
; CHECK32-NEXT:    mr 4, 3
; CHECK32-NEXT:  .LBB10_4:
; CHECK32-NEXT:    subfic 9, 8, 32
; CHECK32-NEXT:    slw 3, 4, 9
; CHECK32-NEXT:    or 3, 3, 10
; CHECK32-NEXT:    beq 0, .LBB10_6
; CHECK32-NEXT:  # %bb.5:
; CHECK32-NEXT:    mr 6, 5
; CHECK32-NEXT:  .LBB10_6:
; CHECK32-NEXT:    srw 4, 6, 8
; CHECK32-NEXT:    slw 5, 7, 9
; CHECK32-NEXT:    or 4, 5, 4
; CHECK32-NEXT:    blr
;
; CHECK64-LABEL: fshr_i64:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    clrlwi 5, 5, 26
; CHECK64-NEXT:    srd 4, 4, 5
; CHECK64-NEXT:    subfic 5, 5, 64
; CHECK64-NEXT:    sld 3, 3, 5
; CHECK64-NEXT:    or 3, 3, 4
; CHECK64-NEXT:    blr
  %f = call i64 @llvm.fshr.i64(i64 %x, i64 %y, i64 %z)
  ret i64 %f
}

; Verify that weird types are minimally supported.
declare i37 @llvm.fshr.i37(i37, i37, i37)
define i37 @fshr_i37(i37 %x, i37 %y, i37 %z) {
; CHECK32_32-LABEL: fshr_i37:
; CHECK32_32:       # %bb.0:
; CHECK32_32-NEXT:    mflr 0
; CHECK32_32-NEXT:    stwu 1, -32(1)
; CHECK32_32-NEXT:    stw 0, 36(1)
; CHECK32_32-NEXT:    .cfi_def_cfa_offset 32
; CHECK32_32-NEXT:    .cfi_offset lr, 4
; CHECK32_32-NEXT:    .cfi_offset r27, -20
; CHECK32_32-NEXT:    .cfi_offset r28, -16
; CHECK32_32-NEXT:    .cfi_offset r29, -12
; CHECK32_32-NEXT:    .cfi_offset r30, -8
; CHECK32_32-NEXT:    stw 27, 12(1) # 4-byte Folded Spill
; CHECK32_32-NEXT:    mr 27, 5
; CHECK32_32-NEXT:    stw 28, 16(1) # 4-byte Folded Spill
; CHECK32_32-NEXT:    mr 28, 3
; CHECK32_32-NEXT:    stw 29, 20(1) # 4-byte Folded Spill
; CHECK32_32-NEXT:    mr 29, 4
; CHECK32_32-NEXT:    stw 30, 24(1) # 4-byte Folded Spill
; CHECK32_32-NEXT:    mr 30, 6
; CHECK32_32-NEXT:    clrlwi 3, 7, 27
; CHECK32_32-NEXT:    mr 4, 8
; CHECK32_32-NEXT:    li 5, 0
; CHECK32_32-NEXT:    li 6, 37
; CHECK32_32-NEXT:    bl __umoddi3
; CHECK32_32-NEXT:    rotlwi 5, 30, 27
; CHECK32_32-NEXT:    addi 3, 4, 27
; CHECK32_32-NEXT:    andi. 4, 3, 32
; CHECK32_32-NEXT:    rlwimi 5, 27, 27, 0, 4
; CHECK32_32-NEXT:    mr 4, 5
; CHECK32_32-NEXT:    beq 0, .LBB11_2
; CHECK32_32-NEXT:  # %bb.1:
; CHECK32_32-NEXT:    mr 4, 29
; CHECK32_32-NEXT:  .LBB11_2:
; CHECK32_32-NEXT:    clrlwi 6, 3, 27
; CHECK32_32-NEXT:    srw 3, 4, 6
; CHECK32_32-NEXT:    beq 0, .LBB11_4
; CHECK32_32-NEXT:  # %bb.3:
; CHECK32_32-NEXT:    mr 29, 28
; CHECK32_32-NEXT:  .LBB11_4:
; CHECK32_32-NEXT:    subfic 7, 6, 32
; CHECK32_32-NEXT:    slw 8, 29, 7
; CHECK32_32-NEXT:    or 3, 8, 3
; CHECK32_32-NEXT:    bne 0, .LBB11_6
; CHECK32_32-NEXT:  # %bb.5:
; CHECK32_32-NEXT:    slwi 5, 30, 27
; CHECK32_32-NEXT:  .LBB11_6:
; CHECK32_32-NEXT:    srw 5, 5, 6
; CHECK32_32-NEXT:    slw 4, 4, 7
; CHECK32_32-NEXT:    or 4, 4, 5
; CHECK32_32-NEXT:    lwz 30, 24(1) # 4-byte Folded Reload
; CHECK32_32-NEXT:    lwz 29, 20(1) # 4-byte Folded Reload
; CHECK32_32-NEXT:    lwz 28, 16(1) # 4-byte Folded Reload
; CHECK32_32-NEXT:    lwz 27, 12(1) # 4-byte Folded Reload
; CHECK32_32-NEXT:    lwz 0, 36(1)
; CHECK32_32-NEXT:    addi 1, 1, 32
; CHECK32_32-NEXT:    mtlr 0
; CHECK32_32-NEXT:    blr
;
; CHECK32_64-LABEL: fshr_i37:
; CHECK32_64:       # %bb.0:
; CHECK32_64-NEXT:    mflr 0
; CHECK32_64-NEXT:    stwu 1, -32(1)
; CHECK32_64-NEXT:    stw 0, 36(1)
; CHECK32_64-NEXT:    .cfi_def_cfa_offset 32
; CHECK32_64-NEXT:    .cfi_offset lr, 4
; CHECK32_64-NEXT:    .cfi_offset r27, -20
; CHECK32_64-NEXT:    .cfi_offset r28, -16
; CHECK32_64-NEXT:    .cfi_offset r29, -12
; CHECK32_64-NEXT:    .cfi_offset r30, -8
; CHECK32_64-NEXT:    stw 27, 12(1) # 4-byte Folded Spill
; CHECK32_64-NEXT:    mr 27, 5
; CHECK32_64-NEXT:    li 5, 0
; CHECK32_64-NEXT:    stw 28, 16(1) # 4-byte Folded Spill
; CHECK32_64-NEXT:    mr 28, 3
; CHECK32_64-NEXT:    clrlwi 3, 7, 27
; CHECK32_64-NEXT:    stw 29, 20(1) # 4-byte Folded Spill
; CHECK32_64-NEXT:    mr 29, 4
; CHECK32_64-NEXT:    mr 4, 8
; CHECK32_64-NEXT:    stw 30, 24(1) # 4-byte Folded Spill
; CHECK32_64-NEXT:    mr 30, 6
; CHECK32_64-NEXT:    li 6, 37
; CHECK32_64-NEXT:    bl __umoddi3
; CHECK32_64-NEXT:    rotlwi 5, 30, 27
; CHECK32_64-NEXT:    addi 3, 4, 27
; CHECK32_64-NEXT:    andi. 4, 3, 32
; CHECK32_64-NEXT:    rlwimi 5, 27, 27, 0, 4
; CHECK32_64-NEXT:    mr 4, 5
; CHECK32_64-NEXT:    beq 0, .LBB11_2
; CHECK32_64-NEXT:  # %bb.1:
; CHECK32_64-NEXT:    mr 4, 29
; CHECK32_64-NEXT:  .LBB11_2:
; CHECK32_64-NEXT:    clrlwi 6, 3, 27
; CHECK32_64-NEXT:    srw 3, 4, 6
; CHECK32_64-NEXT:    beq 0, .LBB11_4
; CHECK32_64-NEXT:  # %bb.3:
; CHECK32_64-NEXT:    mr 29, 28
; CHECK32_64-NEXT:  .LBB11_4:
; CHECK32_64-NEXT:    subfic 7, 6, 32
; CHECK32_64-NEXT:    slw 8, 29, 7
; CHECK32_64-NEXT:    or 3, 8, 3
; CHECK32_64-NEXT:    bne 0, .LBB11_6
; CHECK32_64-NEXT:  # %bb.5:
; CHECK32_64-NEXT:    slwi 5, 30, 27
; CHECK32_64-NEXT:  .LBB11_6:
; CHECK32_64-NEXT:    srw 5, 5, 6
; CHECK32_64-NEXT:    slw 4, 4, 7
; CHECK32_64-NEXT:    lwz 30, 24(1) # 4-byte Folded Reload
; CHECK32_64-NEXT:    or 4, 4, 5
; CHECK32_64-NEXT:    lwz 29, 20(1) # 4-byte Folded Reload
; CHECK32_64-NEXT:    lwz 28, 16(1) # 4-byte Folded Reload
; CHECK32_64-NEXT:    lwz 27, 12(1) # 4-byte Folded Reload
; CHECK32_64-NEXT:    lwz 0, 36(1)
; CHECK32_64-NEXT:    addi 1, 1, 32
; CHECK32_64-NEXT:    mtlr 0
; CHECK32_64-NEXT:    blr
;
; CHECK64-LABEL: fshr_i37:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    lis 7, 1771
; CHECK64-NEXT:    clrldi 6, 5, 27
; CHECK64-NEXT:    sldi 4, 4, 27
; CHECK64-NEXT:    ori 7, 7, 15941
; CHECK64-NEXT:    rldic 7, 7, 32, 5
; CHECK64-NEXT:    oris 7, 7, 12398
; CHECK64-NEXT:    ori 7, 7, 46053
; CHECK64-NEXT:    mulhdu 6, 6, 7
; CHECK64-NEXT:    mulli 6, 6, 37
; CHECK64-NEXT:    sub 5, 5, 6
; CHECK64-NEXT:    addi 5, 5, 27
; CHECK64-NEXT:    clrlwi 5, 5, 26
; CHECK64-NEXT:    srd 4, 4, 5
; CHECK64-NEXT:    subfic 5, 5, 64
; CHECK64-NEXT:    sld 3, 3, 5
; CHECK64-NEXT:    or 3, 3, 4
; CHECK64-NEXT:    blr
  %f = call i37 @llvm.fshr.i37(i37 %x, i37 %y, i37 %z)
  ret i37 %f
}

; extract(concat(0b1110000, 0b1111111) >> 2) = 0b0011111

declare i7 @llvm.fshr.i7(i7, i7, i7)
define i7 @fshr_i7_const_fold() {
; CHECK-LABEL: fshr_i7_const_fold:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li 3, 31
; CHECK-NEXT:    blr
  %f = call i7 @llvm.fshr.i7(i7 112, i7 127, i7 2)
  ret i7 %f
}

; With constant shift amount, this is rotate + insert (missing extended mnemonics).

define i32 @fshr_i32_const_shift(i32 %x, i32 %y) {
; CHECK-LABEL: fshr_i32_const_shift:
; CHECK:       # %bb.0:
; CHECK-NEXT:    rotlwi 4, 4, 23
; CHECK-NEXT:    rlwimi 4, 3, 23, 0, 8
; CHECK-NEXT:    mr 3, 4
; CHECK-NEXT:    blr
  %f = call i32 @llvm.fshr.i32(i32 %x, i32 %y, i32 9)
  ret i32 %f
}

; Check modulo math on shift amount. 41-32=9.

define i32 @fshr_i32_const_overshift(i32 %x, i32 %y) {
; CHECK-LABEL: fshr_i32_const_overshift:
; CHECK:       # %bb.0:
; CHECK-NEXT:    rotlwi 4, 4, 23
; CHECK-NEXT:    rlwimi 4, 3, 23, 0, 8
; CHECK-NEXT:    mr 3, 4
; CHECK-NEXT:    blr
  %f = call i32 @llvm.fshr.i32(i32 %x, i32 %y, i32 41)
  ret i32 %f
}

; 64-bit should also work. 105-64 = 41.

define i64 @fshr_i64_const_overshift(i64 %x, i64 %y) {
; CHECK32-LABEL: fshr_i64_const_overshift:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    rotlwi 6, 4, 23
; CHECK32-NEXT:    rotlwi 5, 5, 23
; CHECK32-NEXT:    rlwimi 6, 3, 23, 0, 8
; CHECK32-NEXT:    rlwimi 5, 4, 23, 0, 8
; CHECK32-NEXT:    mr 3, 6
; CHECK32-NEXT:    mr 4, 5
; CHECK32-NEXT:    blr
;
; CHECK64-LABEL: fshr_i64_const_overshift:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    rotldi 4, 4, 23
; CHECK64-NEXT:    rldimi 4, 3, 23, 0
; CHECK64-NEXT:    mr 3, 4
; CHECK64-NEXT:    blr
  %f = call i64 @llvm.fshr.i64(i64 %x, i64 %y, i64 105)
  ret i64 %f
}

; This should work without any node-specific logic.

define i8 @fshr_i8_const_fold() {
; CHECK-LABEL: fshr_i8_const_fold:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li 3, 254
; CHECK-NEXT:    blr
  %f = call i8 @llvm.fshr.i8(i8 255, i8 0, i8 7)
  ret i8 %f
}

define i32 @fshl_i32_shift_by_bitwidth(i32 %x, i32 %y) {
; CHECK-LABEL: fshl_i32_shift_by_bitwidth:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blr
  %f = call i32 @llvm.fshl.i32(i32 %x, i32 %y, i32 32)
  ret i32 %f
}

define i32 @fshr_i32_shift_by_bitwidth(i32 %x, i32 %y) {
; CHECK-LABEL: fshr_i32_shift_by_bitwidth:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mr 3, 4
; CHECK-NEXT:    blr
  %f = call i32 @llvm.fshr.i32(i32 %x, i32 %y, i32 32)
  ret i32 %f
}

define <4 x i32> @fshl_v4i32_shift_by_bitwidth(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: fshl_v4i32_shift_by_bitwidth:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blr
  %f = call <4 x i32> @llvm.fshl.v4i32(<4 x i32> %x, <4 x i32> %y, <4 x i32> <i32 32, i32 32, i32 32, i32 32>)
  ret <4 x i32> %f
}

define <4 x i32> @fshr_v4i32_shift_by_bitwidth(<4 x i32> %x, <4 x i32> %y) {
; CHECK32_32-LABEL: fshr_v4i32_shift_by_bitwidth:
; CHECK32_32:       # %bb.0:
; CHECK32_32-NEXT:    mr 6, 10
; CHECK32_32-NEXT:    mr 5, 9
; CHECK32_32-NEXT:    mr 4, 8
; CHECK32_32-NEXT:    mr 3, 7
; CHECK32_32-NEXT:    blr
;
; CHECK32_64-LABEL: fshr_v4i32_shift_by_bitwidth:
; CHECK32_64:       # %bb.0:
; CHECK32_64-NEXT:    vmr 2, 3
; CHECK32_64-NEXT:    blr
;
; CHECK64-LABEL: fshr_v4i32_shift_by_bitwidth:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    vmr 2, 3
; CHECK64-NEXT:    blr
  %f = call <4 x i32> @llvm.fshr.v4i32(<4 x i32> %x, <4 x i32> %y, <4 x i32> <i32 32, i32 32, i32 32, i32 32>)
  ret <4 x i32> %f
}

