; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 2
; RUN: llc -mtriple=riscv64 < %s  | FileCheck  %s

define i64 @fold_binop_into_select_0(i1 %c, i64 %x) {
; CHECK-LABEL: fold_binop_into_select_0:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addi a1, a1, -2
; CHECK-NEXT:    slli a0, a0, 63
; CHECK-NEXT:    srai a0, a0, 63
; CHECK-NEXT:    and a0, a0, a1
; CHECK-NEXT:    ret
entry:
  %select_ = select i1 %c, i64 %x, i64 2
  %res = sub i64 %select_, 2
  ret i64 %res
}

define i64 @fold_binop_into_select_1(i1 %c, i64 %x) {
; CHECK-LABEL: fold_binop_into_select_1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    andi a0, a0, 1
; CHECK-NEXT:    addi a1, a1, -2
; CHECK-NEXT:    addi a0, a0, -1
; CHECK-NEXT:    and a0, a0, a1
; CHECK-NEXT:    ret
entry:
  %select_ = select i1 %c, i64 2, i64 %x
  %res = sub i64 %select_, 2
  ret i64 %res
}

define i64 @fold_binop_into_select_2(i1 %c, i64 %x) {
; CHECK-LABEL: fold_binop_into_select_2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li a2, 2
; CHECK-NEXT:    sub a2, a2, a1
; CHECK-NEXT:    slli a0, a0, 63
; CHECK-NEXT:    srai a0, a0, 63
; CHECK-NEXT:    and a0, a0, a2
; CHECK-NEXT:    ret
entry:
  %select_ = select i1 %c, i64 %x, i64 2
  %res = sub i64 2, %select_
  ret i64 %res
}

define i64 @fold_binop_into_select_3(i1 %c, i64 %x) {
; CHECK-LABEL: fold_binop_into_select_3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    andi a0, a0, 1
; CHECK-NEXT:    li a2, 2
; CHECK-NEXT:    sub a2, a2, a1
; CHECK-NEXT:    addi a0, a0, -1
; CHECK-NEXT:    and a0, a0, a2
; CHECK-NEXT:    ret
entry:
  %select_ = select i1 %c, i64 2, i64 %x
  %res = sub i64 2, %select_
  ret i64 %res
}
