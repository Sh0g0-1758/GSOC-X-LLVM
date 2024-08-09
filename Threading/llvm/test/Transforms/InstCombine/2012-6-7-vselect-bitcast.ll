; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes=instcombine < %s | FileCheck %s

define void @foo(<16 x i8> %a, <16 x i8> %b, ptr %c) {
; CHECK-LABEL: @foo(
; CHECK-NEXT:    store <16 x i8> [[B:%.*]], ptr [[C:%.*]], align 4
; CHECK-NEXT:    ret void
;
  %aa = bitcast <16 x i8> %a to <4 x i32>
  %bb = bitcast <16 x i8> %b to <4 x i32>
  %select_v = select <4 x i1> zeroinitializer, <4 x i32> %aa, <4 x i32> %bb
  store <4 x i32> %select_v, ptr %c, align 4
  ret void
}
