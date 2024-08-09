; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=constraint-elimination -S %s | FileCheck %s

declare void @may_unwind()

declare i32 @__gxx_personality_v0(...)

define i1 @test_invoke_in_block_with_assume(i32 %x) personality ptr @__gxx_personality_v0 {
; CHECK-LABEL: @test_invoke_in_block_with_assume(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @may_unwind()
; CHECK-NEXT:    [[C_1:%.*]] = icmp ult i32 [[X:%.*]], 10
; CHECK-NEXT:    call void @llvm.assume(i1 [[C_1]])
; CHECK-NEXT:    invoke void @may_unwind()
; CHECK-NEXT:    to label [[CONT:%.*]] unwind label [[LPAD:%.*]]
; CHECK:       cont:
; CHECK-NEXT:    [[C_2:%.*]] = icmp ult i32 [[X]], 9
; CHECK-NEXT:    [[RES_1:%.*]] = xor i1 true, [[C_2]]
; CHECK-NEXT:    ret i1 [[RES_1]]
; CHECK:       lpad:
; CHECK-NEXT:    [[LP:%.*]] = landingpad { ptr, i32 }
; CHECK-NEXT:    filter [0 x ptr] zeroinitializer
; CHECK-NEXT:    [[C_3:%.*]] = icmp ult i32 [[X]], 9
; CHECK-NEXT:    [[RES_2:%.*]] = xor i1 true, [[C_3]]
; CHECK-NEXT:    ret i1 [[RES_2]]
;
entry:
  call void @may_unwind()
  %c.1 = icmp ult i32 %x, 10
  call void @llvm.assume(i1 %c.1)
  invoke void @may_unwind()
  to label %cont unwind label %lpad

cont:
  %t.1 = icmp ult i32 %x, 10
  %c.2 = icmp ult i32 %x, 9
  %res.1 = xor i1 %t.1, %c.2
  ret i1 %res.1

lpad:
  %lp = landingpad { ptr, i32 }
  filter [0 x ptr] zeroinitializer
  %t.2 = icmp ult i32 %x, 10
  %c.3 = icmp ult i32 %x, 9
  %res.2 = xor i1 %t.2, %c.3
  ret i1 %res.2
}

declare void @llvm.assume(i1)