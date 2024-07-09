; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 2
; Test 128-bit OR-NOT in vector registers on z14
;
; RUN: llc < %s -mtriple=s390x-linux-gnu -mcpu=z14 | FileCheck %s

; Or with complement.
define i128 @f1(i128 %a, i128 %b) {
; CHECK-LABEL: f1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vl %v0, 0(%r4), 3
; CHECK-NEXT:    vl %v1, 0(%r3), 3
; CHECK-NEXT:    voc %v0, %v1, %v0
; CHECK-NEXT:    vst %v0, 0(%r2), 3
; CHECK-NEXT:    br %r14
  %notb = xor i128 %b, -1
  %res = or i128 %a, %notb
  ret i128 %res
}
