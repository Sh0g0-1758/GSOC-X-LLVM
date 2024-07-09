; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes=ipsccp < %s | FileCheck %s

; Make sure we always consider the default edge executable for a switch
; with no cases.
declare void @foo()
declare i32 @g(i32)

define void @test1() {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    switch i32 undef, label [[D:%.*]] [
; CHECK-NEXT:    ]
; CHECK:       d:
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    ret void
;
  switch i32 undef, label %d []
d:
  call void @foo()
  ret void
}

define i32 @test_duplicate_successors_phi(i1 %c, i32 %x) {
; CHECK-LABEL: @test_duplicate_successors_phi(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[C:%.*]], label [[SWITCH:%.*]], label [[END:%.*]]
; CHECK:       switch:
; CHECK-NEXT:    br label [[SWITCH_DEFAULT:%.*]]
; CHECK:       switch.default:
; CHECK-NEXT:    ret i32 -1
; CHECK:       end:
; CHECK-NEXT:    ret i32 [[X:%.*]]
;
entry:
  br i1 %c, label %switch, label %end

switch:
  switch i32 -1, label %switch.default [
  i32 0, label %end
  i32 1, label %end
  ]

switch.default:
  ret i32 -1

end:
  %phi = phi i32 [ %x, %entry ], [ 1, %switch ], [ 1, %switch ]
  ret i32 %phi
}

define i32 @test_duplicate_successors_phi_2(i1 %c, i32 %x) {
; CHECK-LABEL: @test_duplicate_successors_phi_2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[C:%.*]], label [[SWITCH:%.*]], label [[END:%.*]]
; CHECK:       switch:
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[PHI:%.*]] = phi i32 [ [[X:%.*]], [[ENTRY:%.*]] ], [ 1, [[SWITCH]] ]
; CHECK-NEXT:    ret i32 [[PHI]]
;
entry:
  br i1 %c, label %switch, label %end

switch:
  switch i32 0, label %switch.default [
  i32 0, label %end
  i32 1, label %end
  ]

switch.default:
  ret i32 -1

end:
  %phi = phi i32 [ %x, %entry ], [ 1, %switch ], [ 1, %switch ]
  ret i32 %phi
}

define i32 @test_duplicate_successors_phi_3(i1 %c1, ptr %p, i32 %y) {
; CHECK-LABEL: @test_duplicate_successors_phi_3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[C1:%.*]], label [[SWITCH:%.*]], label [[SWITCH_1:%.*]]
; CHECK:       switch:
; CHECK-NEXT:    [[X:%.*]] = load i32, ptr [[P:%.*]], align 4, !range [[RNG0:![0-9]+]]
; CHECK-NEXT:    switch i32 [[X]], label [[SWITCH_DEFAULT:%.*]] [
; CHECK-NEXT:    i32 0, label [[SWITCH_DEFAULT]]
; CHECK-NEXT:    i32 1, label [[SWITCH_0:%.*]]
; CHECK-NEXT:    i32 2, label [[SWITCH_0]]
; CHECK-NEXT:    ]
; CHECK:       switch.default:
; CHECK-NEXT:    ret i32 -1
; CHECK:       switch.0:
; CHECK-NEXT:    ret i32 0
; CHECK:       switch.1:
; CHECK-NEXT:    ret i32 [[Y:%.*]]
;
entry:
  br i1 %c1, label %switch, label %switch.1

switch:
  %x = load i32, ptr %p, !range !{i32 0, i32 3}
  switch i32 %x, label %switch.default [
  i32 0, label %switch.default
  i32 1, label %switch.0
  i32 2, label %switch.0
  i32 3, label %switch.1
  i32 4, label %switch.1
  ]

switch.default:
  ret i32 -1

switch.0:
  ret i32 0

switch.1:
  %phi = phi i32 [ %y, %entry ], [ 0, %switch ], [ 0, %switch ]
  ret i32 %phi
}

define i32 @test_local_range(ptr %p) {
; CHECK-LABEL: @test_local_range(
; CHECK-NEXT:    [[X:%.*]] = load i32, ptr [[P:%.*]], align 4, !range [[RNG0]]
; CHECK-NEXT:    switch i32 [[X]], label [[DEFAULT_UNREACHABLE:%.*]] [
; CHECK-NEXT:    i32 0, label [[SWITCH_0:%.*]]
; CHECK-NEXT:    i32 1, label [[SWITCH_1:%.*]]
; CHECK-NEXT:    i32 2, label [[SWITCH_2:%.*]]
; CHECK-NEXT:    ]
; CHECK:       default.unreachable:
; CHECK-NEXT:    unreachable
; CHECK:       switch.0:
; CHECK-NEXT:    ret i32 0
; CHECK:       switch.1:
; CHECK-NEXT:    ret i32 1
; CHECK:       switch.2:
; CHECK-NEXT:    ret i32 2
;
  %x = load i32, ptr %p, !range !{i32 0, i32 3}
  switch i32 %x, label %switch.default [
  i32 0, label %switch.0
  i32 1, label %switch.1
  i32 2, label %switch.2
  i32 3, label %switch.3
  ]

switch.default:
  ret i32 -1

switch.0:
  ret i32 0

switch.1:
  ret i32 1

switch.2:
  ret i32 2

switch.3:
  ret i32 3
}

; TODO: Determine that case i3 is dead, even though the edge is shared?
define i32 @test_duplicate_successors(ptr %p) {
; CHECK-LABEL: @test_duplicate_successors(
; CHECK-NEXT:    [[X:%.*]] = load i32, ptr [[P:%.*]], align 4, !range [[RNG0]]
; CHECK-NEXT:    switch i32 [[X]], label [[DEFAULT_UNREACHABLE:%.*]] [
; CHECK-NEXT:    i32 0, label [[SWITCH_0:%.*]]
; CHECK-NEXT:    i32 1, label [[SWITCH_0]]
; CHECK-NEXT:    i32 2, label [[SWITCH_1:%.*]]
; CHECK-NEXT:    i32 3, label [[SWITCH_1]]
; CHECK-NEXT:    ]
; CHECK:       default.unreachable:
; CHECK-NEXT:    unreachable
; CHECK:       switch.0:
; CHECK-NEXT:    ret i32 0
; CHECK:       switch.1:
; CHECK-NEXT:    ret i32 1
;
  %x = load i32, ptr %p, !range !{i32 0, i32 3}
  switch i32 %x, label %switch.default [
  i32 0, label %switch.0
  i32 1, label %switch.0
  i32 2, label %switch.1
  i32 3, label %switch.1
  i32 4, label %switch.2
  i32 5, label %switch.2
  ]

switch.default:
  ret i32 -1

switch.0:
  ret i32 0

switch.1:
  ret i32 1

switch.2:
  ret i32 2
}

; Case i32 2 is dead as well, but this cannot be determined based on
; range information.
define internal i32 @test_ip_range(i32 %x) {
; CHECK-LABEL: @test_ip_range(
; CHECK-NEXT:    switch i32 [[X:%.*]], label [[DEFAULT_UNREACHABLE:%.*]] [
; CHECK-NEXT:    i32 3, label [[SWITCH_3:%.*]]
; CHECK-NEXT:    i32 1, label [[SWITCH_1:%.*]]
; CHECK-NEXT:    i32 2, label [[SWITCH_2:%.*]]
; CHECK-NEXT:    ], !prof [[PROF1:![0-9]+]]
; CHECK:       default.unreachable:
; CHECK-NEXT:    unreachable
; CHECK:       switch.1:
; CHECK-NEXT:    ret i32 1
; CHECK:       switch.2:
; CHECK-NEXT:    ret i32 2
; CHECK:       switch.3:
; CHECK-NEXT:    ret i32 3
;
  switch i32 %x, label %switch.default [
  i32 0, label %switch.0
  i32 1, label %switch.1
  i32 2, label %switch.2
  i32 3, label %switch.3
  ], !prof !{!"branch_weights", i32 1, i32 2, i32 3, i32 4, i32 5}

switch.default:
  ret i32 -1

switch.0:
  ret i32 0

switch.1:
  ret i32 1

switch.2:
  ret i32 2

switch.3:
  ret i32 3
}

define void @call_test_ip_range() {
; CHECK-LABEL: @call_test_ip_range(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @test_ip_range(i32 1), !range [[RNG2:![0-9]+]]
; CHECK-NEXT:    [[TMP2:%.*]] = call i32 @test_ip_range(i32 3), !range [[RNG2]]
; CHECK-NEXT:    ret void
;
  call i32 @test_ip_range(i32 1)
  call i32 @test_ip_range(i32 3)
  ret void
}

define i32 @test_switch_range_may_include_undef(i1 %c.1, i1 %c.2, i32 %x) {
; CHECK-LABEL: @test_switch_range_may_include_undef(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[C_1:%.*]], label [[THEN_1:%.*]], label [[ELSE_1:%.*]]
; CHECK:       then.1:
; CHECK-NEXT:    br i1 [[C_2:%.*]], label [[SWITCH:%.*]], label [[ELSE_2:%.*]]
; CHECK:       else.1:
; CHECK-NEXT:    br label [[SWITCH]]
; CHECK:       else.2:
; CHECK-NEXT:    br label [[SWITCH]]
; CHECK:       switch:
; CHECK-NEXT:    [[P:%.*]] = phi i32 [ 0, [[THEN_1]] ], [ 2, [[ELSE_1]] ], [ undef, [[ELSE_2]] ]
; CHECK-NEXT:    switch i32 [[P]], label [[SWITCH_DEFAULT:%.*]] [
; CHECK-NEXT:    i32 0, label [[END_1:%.*]]
; CHECK-NEXT:    i32 3, label [[END_2:%.*]]
; CHECK-NEXT:    ]
; CHECK:       switch.default:
; CHECK-NEXT:    ret i32 -1
; CHECK:       end.1:
; CHECK-NEXT:    ret i32 10
; CHECK:       end.2:
; CHECK-NEXT:    ret i32 20
;
entry:
  br i1 %c.1, label %then.1, label %else.1

then.1:
  br i1 %c.2, label %switch, label %else.2

else.1:
  br label %switch

else.2:
  br label %switch

switch:
  %p = phi i32 [ 0, %then.1 ], [ 2, %else.1 ], [ undef, %else.2 ]
  switch i32 %p, label %switch.default [
  i32 0, label %end.1
  i32 3, label %end.2
  ]

switch.default:
  ret i32 -1

end.1:
  ret i32 10

end.2:
  ret i32 20
}

define i32 @test_default_unreachable_by_dom_cond(i32 %x) {
; CHECK-LABEL: @test_default_unreachable_by_dom_cond(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[OR_COND:%.*]] = icmp ult i32 [[X:%.*]], 4
; CHECK-NEXT:    br i1 [[OR_COND]], label [[IF_THEN:%.*]], label [[RETURN:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    switch i32 [[X]], label [[DEFAULT_UNREACHABLE:%.*]] [
; CHECK-NEXT:      i32 0, label [[SW_BB:%.*]]
; CHECK-NEXT:      i32 1, label [[SW_BB2:%.*]]
; CHECK-NEXT:      i32 2, label [[SW_BB4:%.*]]
; CHECK-NEXT:      i32 3, label [[SW_BB6:%.*]]
; CHECK-NEXT:    ]
; CHECK:       sw.bb:
; CHECK-NEXT:    [[CALL:%.*]] = tail call i32 @g(i32 2)
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       sw.bb2:
; CHECK-NEXT:    [[CALL3:%.*]] = tail call i32 @g(i32 3)
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       sw.bb4:
; CHECK-NEXT:    [[CALL5:%.*]] = tail call i32 @g(i32 4)
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       sw.bb6:
; CHECK-NEXT:    [[CALL7:%.*]] = tail call i32 @g(i32 5)
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       default.unreachable:
; CHECK-NEXT:    unreachable
; CHECK:       return:
; CHECK-NEXT:    [[RETVAL_0:%.*]] = phi i32 [ [[CALL7]], [[SW_BB6]] ], [ [[CALL5]], [[SW_BB4]] ], [ [[CALL3]], [[SW_BB2]] ], [ [[CALL]], [[SW_BB]] ], [ -23, [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret i32 [[RETVAL_0]]
;
entry:
  %or.cond = icmp ult i32 %x, 4
  br i1 %or.cond, label %if.then, label %return

if.then:
  switch i32 %x, label %sw.epilog [
  i32 0, label %sw.bb
  i32 1, label %sw.bb2
  i32 2, label %sw.bb4
  i32 3, label %sw.bb6
  ]

sw.bb:
  %call = tail call i32 @g(i32 2)
  br label %return

sw.bb2:
  %call3 = tail call i32 @g(i32 3)
  br label %return

sw.bb4:
  %call5 = tail call i32 @g(i32 4)
  br label %return

sw.bb6:
  %call7 = tail call i32 @g(i32 5)
  br label %return

sw.epilog:
  call void @foo()
  br label %return

return:
  %retval.0 = phi i32 [ %call7, %sw.bb6 ], [ %call5, %sw.bb4 ], [ %call3, %sw.bb2 ], [ %call, %sw.bb ], [ -23, %sw.epilog ], [ -23, %entry ]
  ret i32 %retval.0
}

declare void @llvm.assume(i1)

; CHECK: !1 = !{!"branch_weights", i32 1, i32 5, i32 3, i32 4}
