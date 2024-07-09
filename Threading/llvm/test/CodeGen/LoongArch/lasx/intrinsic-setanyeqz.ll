; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc --mtriple=loongarch64 --mattr=+lasx < %s | FileCheck %s

declare i32 @llvm.loongarch.lasx.xbz.b(<32 x i8>)

define i32 @lasx_xbz_b(<32 x i8> %va) nounwind {
; CHECK-LABEL: lasx_xbz_b:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvsetanyeqz.b $fcc0, $xr0
; CHECK-NEXT:    bcnez $fcc0, .LBB0_2
; CHECK-NEXT:  # %bb.1: # %entry
; CHECK-NEXT:    addi.w $a0, $zero, 0
; CHECK-NEXT:    ret
; CHECK-NEXT:  .LBB0_2: # %entry
; CHECK-NEXT:    addi.w $a0, $zero, 1
; CHECK-NEXT:    ret
entry:
  %res = call i32 @llvm.loongarch.lasx.xbz.b(<32 x i8> %va)
  ret i32 %res
}

declare i32 @llvm.loongarch.lasx.xbz.h(<16 x i16>)

define i32 @lasx_xbz_h(<16 x i16> %va) nounwind {
; CHECK-LABEL: lasx_xbz_h:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvsetanyeqz.h $fcc0, $xr0
; CHECK-NEXT:    bcnez $fcc0, .LBB1_2
; CHECK-NEXT:  # %bb.1: # %entry
; CHECK-NEXT:    addi.w $a0, $zero, 0
; CHECK-NEXT:    ret
; CHECK-NEXT:  .LBB1_2: # %entry
; CHECK-NEXT:    addi.w $a0, $zero, 1
; CHECK-NEXT:    ret
entry:
  %res = call i32 @llvm.loongarch.lasx.xbz.h(<16 x i16> %va)
  ret i32 %res
}

declare i32 @llvm.loongarch.lasx.xbz.w(<8 x i32>)

define i32 @lasx_xbz_w(<8 x i32> %va) nounwind {
; CHECK-LABEL: lasx_xbz_w:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvsetanyeqz.w $fcc0, $xr0
; CHECK-NEXT:    bcnez $fcc0, .LBB2_2
; CHECK-NEXT:  # %bb.1: # %entry
; CHECK-NEXT:    addi.w $a0, $zero, 0
; CHECK-NEXT:    ret
; CHECK-NEXT:  .LBB2_2: # %entry
; CHECK-NEXT:    addi.w $a0, $zero, 1
; CHECK-NEXT:    ret
entry:
  %res = call i32 @llvm.loongarch.lasx.xbz.w(<8 x i32> %va)
  ret i32 %res
}

declare i32 @llvm.loongarch.lasx.xbz.d(<4 x i64>)

define i32 @lasx_xbz_d(<4 x i64> %va) nounwind {
; CHECK-LABEL: lasx_xbz_d:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvsetanyeqz.d $fcc0, $xr0
; CHECK-NEXT:    bcnez $fcc0, .LBB3_2
; CHECK-NEXT:  # %bb.1: # %entry
; CHECK-NEXT:    addi.w $a0, $zero, 0
; CHECK-NEXT:    ret
; CHECK-NEXT:  .LBB3_2: # %entry
; CHECK-NEXT:    addi.w $a0, $zero, 1
; CHECK-NEXT:    ret
entry:
  %res = call i32 @llvm.loongarch.lasx.xbz.d(<4 x i64> %va)
  ret i32 %res
}
