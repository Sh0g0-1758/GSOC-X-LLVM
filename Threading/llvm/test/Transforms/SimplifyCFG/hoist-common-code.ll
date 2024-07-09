; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=simplifycfg -simplifycfg-require-and-preserve-domtree=1 -S -hoist-common-insts=true | FileCheck %s

declare void @bar(i32)

define void @test(i1 %P, ptr %Q) {
; CHECK-LABEL: @test(
; CHECK-NEXT:  common.ret:
; CHECK-NEXT:    store i32 1, ptr [[Q:%.*]], align 4
; CHECK-NEXT:    [[A:%.*]] = load i32, ptr [[Q]], align 4
; CHECK-NEXT:    call void @bar(i32 [[A]])
; CHECK-NEXT:    ret void
;
  br i1 %P, label %T, label %F
T:              ; preds = %0
  store i32 1, ptr %Q
  %A = load i32, ptr %Q               ; <i32> [#uses=1]
  call void @bar( i32 %A )
  ret void
F:              ; preds = %0
  store i32 1, ptr %Q
  %B = load i32, ptr %Q               ; <i32> [#uses=1]
  call void @bar( i32 %B )
  ret void
}

define void @test_switch(i64 %i, ptr %Q) {
; CHECK-LABEL: @test_switch(
; CHECK-NEXT:  common.ret:
; CHECK-NEXT:    store i32 1, ptr [[Q:%.*]], align 4
; CHECK-NEXT:    [[A:%.*]] = load i32, ptr [[Q]], align 4
; CHECK-NEXT:    call void @bar(i32 [[A]])
; CHECK-NEXT:    ret void
;
  switch i64 %i, label %bb0 [
  i64 1, label %bb1
  i64 2, label %bb2
  ]
bb0:              ; preds = %0
  store i32 1, ptr %Q
  %A = load i32, ptr %Q               ; <i32> [#uses=1]
  call void @bar( i32 %A )
  ret void
bb1:              ; preds = %0
  store i32 1, ptr %Q
  %B = load i32, ptr %Q               ; <i32> [#uses=1]
  call void @bar( i32 %B )
  ret void
bb2:              ; preds = %0
  store i32 1, ptr %Q
  %C = load i32, ptr %Q               ; <i32> [#uses=1]
  call void @bar( i32 %C )
  ret void
}

; We ensure that we examine all instructions during each iteration to confirm the presence of a terminating one.
define void @test_switch_reach_terminator(i64 %i, ptr %p) {
; CHECK-LABEL: @test_switch_reach_terminator(
; CHECK-NEXT:    switch i64 [[I:%.*]], label [[BB0:%.*]] [
; CHECK-NEXT:    i64 1, label [[BB1:%.*]]
; CHECK-NEXT:    i64 2, label [[COMMON_RET:%.*]]
; CHECK-NEXT:    ]
; CHECK:       common.ret:
; CHECK-NEXT:    ret void
; CHECK:       bb0:
; CHECK-NEXT:    store i32 1, ptr [[P:%.*]], align 4
; CHECK-NEXT:    br label [[COMMON_RET]]
; CHECK:       bb1:
; CHECK-NEXT:    store i32 2, ptr [[P]], align 4
; CHECK-NEXT:    br label [[COMMON_RET]]
;
  switch i64 %i, label %bb0 [
  i64 1, label %bb1
  i64 2, label %bb2
  ]
bb0:              ; preds = %0
  store i32 1, ptr %p
  ret void
bb1:              ; preds = %0
  store i32 2, ptr %p
  ret void
bb2:              ; preds = %0
  ret void
}

define i1 @common_instr_on_switch(i64 %a, i64 %b, i64 %c) unnamed_addr {
; CHECK-LABEL: @common_instr_on_switch(
; CHECK-NEXT:  start:
; CHECK-NEXT:    [[TMP0:%.*]] = icmp eq i64 [[B:%.*]], [[C:%.*]]
; CHECK-NEXT:    ret i1 [[TMP0]]
;
start:
  switch i64 %a, label %bb0 [
  i64 1, label %bb1
  i64 2, label %bb2
  ]

bb0:                                              ; preds = %start
  %0 = icmp eq i64 %b, %c
  br label %exit

bb1:                                              ; preds = %start
  %1 = icmp eq i64 %b, %c
  br label %exit

bb2:                                              ; preds = %start
  %2 = icmp eq i64 %b, %c
  br label %exit

exit:                                             ; preds = %bb2, %bb1, %bb0
  %result = phi i1 [ %0, %bb0 ], [ %1, %bb1 ], [ %2, %bb2 ]
  ret i1 %result
}

define i1 @partial_common_instr_on_switch(i64 %a, i64 %b, i64 %c) unnamed_addr {
; CHECK-LABEL: @partial_common_instr_on_switch(
; CHECK-NEXT:  start:
; CHECK-NEXT:    switch i64 [[A:%.*]], label [[BB0:%.*]] [
; CHECK-NEXT:    i64 1, label [[BB1:%.*]]
; CHECK-NEXT:    i64 2, label [[BB2:%.*]]
; CHECK-NEXT:    ]
; CHECK:       bb0:
; CHECK-NEXT:    [[TMP0:%.*]] = icmp eq i64 [[B:%.*]], [[C:%.*]]
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ne i64 [[B]], [[C]]
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       bb2:
; CHECK-NEXT:    [[TMP2:%.*]] = icmp eq i64 [[B]], [[C]]
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[RESULT:%.*]] = phi i1 [ [[TMP0]], [[BB0]] ], [ [[TMP1]], [[BB1]] ], [ [[TMP2]], [[BB2]] ]
; CHECK-NEXT:    ret i1 [[RESULT]]
;
start:
  switch i64 %a, label %bb0 [
  i64 1, label %bb1
  i64 2, label %bb2
  ]

bb0:                                              ; preds = %start
  %0 = icmp eq i64 %b, %c
  br label %exit

bb1:                                              ; preds = %start
  %1 = icmp ne i64 %b, %c
  br label %exit

bb2:                                              ; preds = %start
  %2 = icmp eq i64 %b, %c
  br label %exit

exit:                                             ; preds = %bb2, %bb1, %bb0
  %result = phi i1 [ %0, %bb0 ], [ %1, %bb1 ], [ %2, %bb2 ]
  ret i1 %result
}
