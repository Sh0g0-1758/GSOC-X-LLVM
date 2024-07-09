; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -passes=loop-simplify | FileCheck %s

; This function should get a preheader inserted before bb3, that is jumped
; to by bb1 & bb2
define void @test() {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 true, label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[BB3_PREHEADER:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    br label [[BB3_PREHEADER]]
; CHECK:       bb3.preheader:
; CHECK-NEXT:    br label [[BB3:%.*]]
; CHECK:       bb3:
; CHECK-NEXT:    br label [[BB3]]
;
entry:
  br i1 true, label %bb1, label %bb2

bb1:
  br label %bb3

bb2:
  br label %bb3

bb3:
  br label %bb3
}

; Test a case where we have multiple exit blocks as successors of a single loop
; block that need to be made dedicated exit blocks. We also have multiple
; exiting edges to one of the exit blocks that all should be rewritten.
define void @test_multiple_exits_from_single_block(i8 %a, ptr %b.ptr) {
; CHECK-LABEL: @test_multiple_exits_from_single_block(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    switch i8 [[A:%.*]], label [[LOOP_PREHEADER:%.*]] [
; CHECK-NEXT:    i8 0, label [[EXIT_A:%.*]]
; CHECK-NEXT:    i8 1, label [[EXIT_B:%.*]]
; CHECK-NEXT:    ]
; CHECK:       loop.preheader:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[B:%.*]] = load volatile i8, ptr [[B_PTR:%.*]]
; CHECK-NEXT:    switch i8 [[B]], label [[LOOP_BACKEDGE:%.*]] [
; CHECK-NEXT:    i8 0, label [[EXIT_A_LOOPEXIT:%.*]]
; CHECK-NEXT:    i8 1, label [[EXIT_B_LOOPEXIT:%.*]]
; CHECK-NEXT:    i8 2, label [[LOOP_BACKEDGE]]
; CHECK-NEXT:    i8 3, label [[EXIT_A_LOOPEXIT]]
; CHECK-NEXT:    i8 4, label [[LOOP_BACKEDGE]]
; CHECK-NEXT:    i8 5, label [[EXIT_A_LOOPEXIT]]
; CHECK-NEXT:    i8 6, label [[LOOP_BACKEDGE]]
; CHECK-NEXT:    ]
; CHECK:       loop.backedge:
; CHECK-NEXT:    br label [[LOOP]]
; CHECK:       exit.a.loopexit:
; CHECK-NEXT:    br label [[EXIT_A]]
; CHECK:       exit.a:
; CHECK-NEXT:    ret void
; CHECK:       exit.b.loopexit:
; CHECK-NEXT:    br label [[EXIT_B]]
; CHECK:       exit.b:
; CHECK-NEXT:    ret void
;
entry:
  switch i8 %a, label %loop [
  i8 0, label %exit.a
  i8 1, label %exit.b
  ]

loop:
  %b = load volatile i8, ptr %b.ptr
  switch i8 %b, label %loop [
  i8 0, label %exit.a
  i8 1, label %exit.b
  i8 2, label %loop
  i8 3, label %exit.a
  i8 4, label %loop
  i8 5, label %exit.a
  i8 6, label %loop
  ]

exit.a:
  ret void

exit.b:
  ret void
}

; Check that we leave already dedicated exits alone when forming dedicated exit
; blocks.
define void @test_pre_existing_dedicated_exits(i1 %a, ptr %ptr) {
; CHECK-LABEL: @test_pre_existing_dedicated_exits(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[A:%.*]], label [[LOOP_PH:%.*]], label [[NON_DEDICATED_EXIT:%.*]]
; CHECK:       loop.ph:
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop.header:
; CHECK-NEXT:    [[C1:%.*]] = load volatile i1, ptr [[PTR:%.*]]
; CHECK-NEXT:    br i1 [[C1]], label [[LOOP_BODY1:%.*]], label [[DEDICATED_EXIT1:%.*]]
; CHECK:       loop.body1:
; CHECK-NEXT:    [[C2:%.*]] = load volatile i1, ptr [[PTR]]
; CHECK-NEXT:    br i1 [[C2]], label [[LOOP_BODY2:%.*]], label [[NON_DEDICATED_EXIT_LOOPEXIT:%.*]]
; CHECK:       loop.body2:
; CHECK-NEXT:    [[C3:%.*]] = load volatile i1, ptr [[PTR]]
; CHECK-NEXT:    br i1 [[C3]], label [[LOOP_BACKEDGE:%.*]], label [[DEDICATED_EXIT2:%.*]]
; CHECK:       loop.backedge:
; CHECK-NEXT:    br label [[LOOP_HEADER]]
; CHECK:       dedicated_exit1:
; CHECK-NEXT:    ret void
; CHECK:       dedicated_exit2:
; CHECK-NEXT:    ret void
; CHECK:       non_dedicated_exit.loopexit:
; CHECK-NEXT:    br label [[NON_DEDICATED_EXIT]]
; CHECK:       non_dedicated_exit:
; CHECK-NEXT:    ret void
;
entry:
  br i1 %a, label %loop.ph, label %non_dedicated_exit

loop.ph:
  br label %loop.header

loop.header:
  %c1 = load volatile i1, ptr %ptr
  br i1 %c1, label %loop.body1, label %dedicated_exit1

loop.body1:
  %c2 = load volatile i1, ptr %ptr
  br i1 %c2, label %loop.body2, label %non_dedicated_exit

loop.body2:
  %c3 = load volatile i1, ptr %ptr
  br i1 %c3, label %loop.backedge, label %dedicated_exit2

loop.backedge:
  br label %loop.header

dedicated_exit1:
  ret void
; Check that there isn't a split loop exit.

dedicated_exit2:
  ret void
; Check that there isn't a split loop exit.

non_dedicated_exit:
  ret void
}

; Check that we form what dedicated exits we can even when some exits are
; reached via indirectbr which precludes forming dedicated exits.
define void @test_form_some_dedicated_exits_despite_indirectbr(i8 %a, ptr %ptr, ptr %addr.ptr) {
; CHECK-LABEL: @test_form_some_dedicated_exits_despite_indirectbr(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    switch i8 [[A:%.*]], label [[LOOP_PH:%.*]] [
; CHECK-NEXT:    i8 0, label [[EXIT_A:%.*]]
; CHECK-NEXT:    i8 1, label [[EXIT_B:%.*]]
; CHECK-NEXT:    i8 2, label [[EXIT_C:%.*]]
; CHECK-NEXT:    ]
; CHECK:       loop.ph:
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop.header:
; CHECK-NEXT:    [[ADDR1:%.*]] = load volatile ptr, ptr [[ADDR_PTR:%.*]]
; CHECK-NEXT:    indirectbr ptr [[ADDR1]], [label [[LOOP_BODY1:%.*]], label %exit.a]
; CHECK:       loop.body1:
; CHECK-NEXT:    [[B:%.*]] = load volatile i8, ptr [[PTR:%.*]]
; CHECK-NEXT:    switch i8 [[B]], label [[LOOP_BODY2:%.*]] [
; CHECK-NEXT:    i8 0, label [[EXIT_A]]
; CHECK-NEXT:    i8 1, label [[EXIT_B_LOOPEXIT:%.*]]
; CHECK-NEXT:    i8 2, label [[EXIT_C]]
; CHECK-NEXT:    ]
; CHECK:       loop.body2:
; CHECK-NEXT:    [[ADDR2:%.*]] = load volatile ptr, ptr [[ADDR_PTR]]
; CHECK-NEXT:    indirectbr ptr [[ADDR2]], [label [[LOOP_BACKEDGE:%.*]], label %exit.c]
; CHECK:       loop.backedge:
; CHECK-NEXT:    br label [[LOOP_HEADER]]
; CHECK:       exit.a:
; CHECK-NEXT:    ret void
; CHECK:       exit.b.loopexit:
; CHECK-NEXT:    br label [[EXIT_B]]
; CHECK:       exit.b:
; CHECK-NEXT:    ret void
; CHECK:       exit.c:
; CHECK-NEXT:    ret void
;
entry:
  switch i8 %a, label %loop.ph [
  i8 0, label %exit.a
  i8 1, label %exit.b
  i8 2, label %exit.c
  ]

loop.ph:
  br label %loop.header

loop.header:
  %addr1 = load volatile ptr, ptr %addr.ptr
  indirectbr ptr %addr1, [label %loop.body1, label %exit.a]

loop.body1:
  %b = load volatile i8, ptr %ptr
  switch i8 %b, label %loop.body2 [
  i8 0, label %exit.a
  i8 1, label %exit.b
  i8 2, label %exit.c
  ]

loop.body2:
  %addr2 = load volatile ptr, ptr %addr.ptr
  indirectbr ptr %addr2, [label %loop.backedge, label %exit.c]

loop.backedge:
  br label %loop.header

exit.a:
  ret void
; Check that there isn't a split loop exit.

exit.b:
  ret void

exit.c:
  ret void
; Check that there isn't a split loop exit.
}
