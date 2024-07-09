; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 4
; RUN: llc -verify-machineinstrs < %s -mtriple=powerpc64le-unknown-linux-gnu | FileCheck %s

define i32 @test1(i32 %a) {
; CHECK-LABEL: test1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    rlwinm 3, 3, 0, 4, 19
; CHECK-NEXT:    blr
entry:
  %tmp.1 = and i32 %a, 268431360
  ret i32 %tmp.1
}

define i32 @test2(i32 %a) {
; CHECK-LABEL: test2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    rlwinm 3, 3, 24, 24, 31
; CHECK-NEXT:    blr
entry:
  %tmp.2 = ashr i32 %a, 8
  %tmp.3 = and i32 %tmp.2, 255
  ret i32 %tmp.3
}

define i32 @test3(i32 %a) {
; CHECK-LABEL: test3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    rlwinm 3, 3, 24, 24, 31
; CHECK-NEXT:    blr
entry:
  %tmp.3 = lshr i32 %a, 8
  %tmp.4 = and i32 %tmp.3, 255
  ret i32 %tmp.4
}

define i32 @test4(i32 %a) {
; CHECK-LABEL: test4:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    rlwinm 3, 3, 8, 0, 8
; CHECK-NEXT:    blr
entry:
  %tmp.2 = shl i32 %a, 8
  %tmp.3 = and i32 %tmp.2, -8388608
  ret i32 %tmp.3
}

define i32 @test5(i32 %a) {
; CHECK-LABEL: test5:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    rlwinm 3, 3, 24, 24, 31
; CHECK-NEXT:    blr
entry:
  %tmp.1 = and i32 %a, 65280
  %tmp.2 = ashr i32 %tmp.1, 8
  ret i32 %tmp.2
}

define i32 @test6(i32 %a) {
; CHECK-LABEL: test6:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    rlwinm 3, 3, 24, 24, 31
; CHECK-NEXT:    blr
entry:
  %tmp.1 = and i32 %a, 65280
  %tmp.2 = lshr i32 %tmp.1, 8
  ret i32 %tmp.2
}

define i32 @test7(i32 %a) {
; CHECK-LABEL: test7:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    rlwinm 3, 3, 8, 0, 7
; CHECK-NEXT:    blr
entry:
  %tmp.1 = and i32 %a, 16711680
  %tmp.2 = shl i32 %tmp.1, 8
  ret i32 %tmp.2
}

define i32 @test8(i32 %a, i32 %s) {
; CHECK-LABEL: test8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    rlwnm 3, 3, 4, 23, 31
; CHECK-NEXT:    blr
entry:
  %r = call i32 @llvm.ppc.rlwnm(i32 %a, i32 %s, i32 511)
  ret i32 %r
}

define i32 @test9(i32 %a) {
; CHECK-LABEL: test9:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    rlwinm 3, 3, 31, 23, 31
; CHECK-NEXT:    blr
entry:
  %r = call i32 @llvm.ppc.rlwnm(i32 %a, i32 31, i32 511)
  ret i32 %r
}

declare i32 @llvm.ppc.rlwnm(i32, i32, i32 immarg)
