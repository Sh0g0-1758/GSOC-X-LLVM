; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes='sroa<preserve-cfg>' -S | FileCheck %s --check-prefixes=CHECK,CHECK-PRESERVE-CFG
; RUN: opt < %s -passes='sroa<modify-cfg>' -S | FileCheck %s --check-prefixes=CHECK,CHECK-MODIFY-CFG
target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux"

; Make sure we properly handle allocas where the allocated
; size overflows a uint32_t. This specific constant results in
; the size in bits being 32 after truncation to a 32-bit int.
define void @fn1() {
; CHECK-LABEL: @fn1(
; CHECK-NEXT:    ret void
;
  %a = alloca [1073741825 x i32], align 16
  call void @llvm.lifetime.end.p0(i64 4294967300, ptr %a)
  ret void
}

declare void @llvm.lifetime.end.p0(i64, ptr nocapture)
;; NOTE: These prefixes are unused and the list is autogenerated. Do not add tests below this line:
; CHECK-MODIFY-CFG: {{.*}}
; CHECK-PRESERVE-CFG: {{.*}}
