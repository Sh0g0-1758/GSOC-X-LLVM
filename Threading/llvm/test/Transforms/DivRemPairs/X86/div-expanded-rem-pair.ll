; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=div-rem-pairs -S -mtriple=x86_64-unknown-unknown    | FileCheck %s

declare void @foo(i32, i32)

define void @decompose_illegal_srem_same_block(i32 %a, i32 %b) {
; CHECK-LABEL: @decompose_illegal_srem_same_block(
; CHECK-NEXT:    [[DIV:%.*]] = sdiv i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[T0:%.*]] = mul i32 [[DIV]], [[B]]
; CHECK-NEXT:    [[REM_RECOMPOSED:%.*]] = srem i32 [[A]], [[B]]
; CHECK-NEXT:    call void @foo(i32 [[REM_RECOMPOSED]], i32 [[DIV]])
; CHECK-NEXT:    ret void
;
  %div = sdiv i32 %a, %b
  %t0 = mul i32 %div, %b
  %rem = sub i32 %a, %t0
  call void @foo(i32 %rem, i32 %div)
  ret void
}

define void @decompose_illegal_urem_same_block(i32 %a, i32 %b) {
; CHECK-LABEL: @decompose_illegal_urem_same_block(
; CHECK-NEXT:    [[DIV:%.*]] = udiv i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[T0:%.*]] = mul i32 [[DIV]], [[B]]
; CHECK-NEXT:    [[REM_RECOMPOSED:%.*]] = urem i32 [[A]], [[B]]
; CHECK-NEXT:    call void @foo(i32 [[REM_RECOMPOSED]], i32 [[DIV]])
; CHECK-NEXT:    ret void
;
  %div = udiv i32 %a, %b
  %t0 = mul i32 %div, %b
  %rem = sub i32 %a, %t0
  call void @foo(i32 %rem, i32 %div)
  ret void
}

; Recompose and hoist the srem if it's safe and free, otherwise keep as-is..

define i16 @hoist_srem(i16 %a, i16 %b) {
; CHECK-LABEL: @hoist_srem(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[DIV:%.*]] = sdiv i16 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[REM_RECOMPOSED:%.*]] = srem i16 [[A]], [[B]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i16 [[DIV]], 42
; CHECK-NEXT:    br i1 [[CMP]], label [[IF:%.*]], label [[END:%.*]]
; CHECK:       if:
; CHECK-NEXT:    [[T0:%.*]] = mul i16 [[DIV]], [[B]]
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[RET:%.*]] = phi i16 [ [[REM_RECOMPOSED]], [[IF]] ], [ 3, [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret i16 [[RET]]
;
entry:
  %div = sdiv i16 %a, %b
  %cmp = icmp eq i16 %div, 42
  br i1 %cmp, label %if, label %end

if:
  %t0 = mul i16 %div, %b
  %rem = sub i16 %a, %t0
  br label %end

end:
  %ret = phi i16 [ %rem, %if ], [ 3, %entry ]
  ret i16 %ret
}

; Recompose and hoist the urem if it's safe and free, otherwise keep as-is..

define i8 @hoist_urem(i8 %a, i8 %b) {
; CHECK-LABEL: @hoist_urem(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[DIV:%.*]] = udiv i8 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[REM_RECOMPOSED:%.*]] = urem i8 [[A]], [[B]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[DIV]], 42
; CHECK-NEXT:    br i1 [[CMP]], label [[IF:%.*]], label [[END:%.*]]
; CHECK:       if:
; CHECK-NEXT:    [[T0:%.*]] = mul i8 [[DIV]], [[B]]
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[RET:%.*]] = phi i8 [ [[REM_RECOMPOSED]], [[IF]] ], [ 3, [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret i8 [[RET]]
;
entry:
  %div = udiv i8 %a, %b
  %cmp = icmp eq i8 %div, 42
  br i1 %cmp, label %if, label %end

if:
  %t0 = mul i8 %div, %b
  %rem = sub i8 %a, %t0
  br label %end

end:
  %ret = phi i8 [ %rem, %if ], [ 3, %entry ]
  ret i8 %ret
}

; Be careful with RAUW/invalidation if this is a srem-of-srem.

define i32 @srem_of_srem_unexpanded(i32 %X, i32 %Y, i32 %Z) {
; CHECK-LABEL: @srem_of_srem_unexpanded(
; CHECK-NEXT:    [[T0:%.*]] = mul nsw i32 [[Z:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = sdiv i32 [[X:%.*]], [[T0]]
; CHECK-NEXT:    [[T2:%.*]] = mul nsw i32 [[T0]], [[T1]]
; CHECK-NEXT:    [[T3:%.*]] = srem i32 [[X]], [[T0]]
; CHECK-NEXT:    [[T4:%.*]] = sdiv i32 [[T3]], [[Y]]
; CHECK-NEXT:    [[T5:%.*]] = mul nsw i32 [[T4]], [[Y]]
; CHECK-NEXT:    [[T6:%.*]] = srem i32 [[T3]], [[Y]]
; CHECK-NEXT:    ret i32 [[T6]]
;
  %t0 = mul nsw i32 %Z, %Y
  %t1 = sdiv i32 %X, %t0
  %t2 = mul nsw i32 %t0, %t1
  %t3 = srem i32 %X, %t0
  %t4 = sdiv i32 %t3, %Y
  %t5 = mul nsw i32 %t4, %Y
  %t6 = srem i32 %t3, %Y
  ret i32 %t6
}
define i32 @srem_of_srem_expanded(i32 %X, i32 %Y, i32 %Z) {
; CHECK-LABEL: @srem_of_srem_expanded(
; CHECK-NEXT:    [[T0:%.*]] = mul nsw i32 [[Z:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = sdiv i32 [[X:%.*]], [[T0]]
; CHECK-NEXT:    [[T2:%.*]] = mul nsw i32 [[T0]], [[T1]]
; CHECK-NEXT:    [[T3_RECOMPOSED:%.*]] = srem i32 [[X]], [[T0]]
; CHECK-NEXT:    [[T4:%.*]] = sdiv i32 [[T3_RECOMPOSED]], [[Y]]
; CHECK-NEXT:    [[T5:%.*]] = mul nsw i32 [[T4]], [[Y]]
; CHECK-NEXT:    [[T6_RECOMPOSED:%.*]] = srem i32 [[T3_RECOMPOSED]], [[Y]]
; CHECK-NEXT:    ret i32 [[T6_RECOMPOSED]]
;
  %t0 = mul nsw i32 %Z, %Y
  %t1 = sdiv i32 %X, %t0
  %t2 = mul nsw i32 %t0, %t1
  %t3 = sub nsw i32 %X, %t2
  %t4 = sdiv i32 %t3, %Y
  %t5 = mul nsw i32 %t4, %Y
  %t6 = sub nsw i32 %t3, %t5
  ret i32 %t6
}

; If the target doesn't have a unified div/rem op for the type, keep decomposed rem

define i128 @dont_hoist_urem(i128 %a, i128 %b) {
; CHECK-LABEL: @dont_hoist_urem(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[DIV:%.*]] = udiv i128 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i128 [[DIV]], 42
; CHECK-NEXT:    br i1 [[CMP]], label [[IF:%.*]], label [[END:%.*]]
; CHECK:       if:
; CHECK-NEXT:    [[T0:%.*]] = mul i128 [[DIV]], [[B]]
; CHECK-NEXT:    [[REM:%.*]] = sub i128 [[A]], [[T0]]
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[RET:%.*]] = phi i128 [ [[REM]], [[IF]] ], [ 3, [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret i128 [[RET]]
;
entry:
  %div = udiv i128 %a, %b
  %cmp = icmp eq i128 %div, 42
  br i1 %cmp, label %if, label %end

if:
  %t0 = mul i128 %div, %b
  %rem = sub i128 %a, %t0
  br label %end

end:
  %ret = phi i128 [ %rem, %if ], [ 3, %entry ]
  ret i128 %ret
}

; Even in expanded form, we can end up with div and rem in different basic
; blocks neither of which dominates each another.
define i32 @can_have_divrem_in_mutually_nondominating_bbs(i1 %cmp, i32 %a, i32 %b) {
; CHECK-LABEL: @can_have_divrem_in_mutually_nondominating_bbs(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[T3:%.*]] = udiv i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[T2_RECOMPOSED:%.*]] = urem i32 [[A]], [[B]]
; CHECK-NEXT:    br i1 [[CMP:%.*]], label [[IF_THEN:%.*]], label [[IF_ELSE:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[T0:%.*]] = udiv i32 [[A]], [[B]]
; CHECK-NEXT:    [[T1:%.*]] = mul nuw i32 [[T0]], [[B]]
; CHECK-NEXT:    br label [[END:%.*]]
; CHECK:       if.else:
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[RET:%.*]] = phi i32 [ [[T2_RECOMPOSED]], [[IF_THEN]] ], [ [[T3]], [[IF_ELSE]] ]
; CHECK-NEXT:    ret i32 [[RET]]
;
entry:
  br i1 %cmp, label %if.then, label %if.else

if.then:
  %t0 = udiv i32 %a, %b
  %t1 = mul nuw i32 %t0, %b
  %t2 = sub i32 %a, %t1
  br label %end

if.else:
  %t3 = udiv i32 %a, %b
  br label %end

end:
  %ret = phi i32 [ %t2, %if.then ], [ %t3, %if.else ]
  ret i32 %ret
}

; Test for hoisting a udiv to dominate a urem to allow udivrem.
define i64 @remainder_triangle_i64(i64 %a, i64 %b, ptr %rp) {
; CHECK-LABEL: @remainder_triangle_i64(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne ptr [[RP:%.*]], null
; CHECK-NEXT:    [[DIV:%.*]] = udiv i64 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[REM:%.*]] = urem i64 [[A]], [[B]]
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_THEN:%.*]], label [[END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    store i64 [[REM]], ptr [[RP]], align 8
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    ret i64 [[DIV]]
;
entry:
  %cmp = icmp ne ptr %rp, null
  br i1 %cmp, label %if.then, label %end

if.then:
  %rem = urem i64 %a, %b
  store i64 %rem, ptr %rp
  br label %end

end:
  %div = udiv i64 %a, %b
  ret i64 %div
}

; Test for hoisting a udiv to dominate a urem to allow the urem to be expanded
; into mul+sub.
define i128 @remainder_triangle_i128(i128 %a, i128 %b, ptr %rp) {
; CHECK-LABEL: @remainder_triangle_i128(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne ptr [[RP:%.*]], null
; CHECK-NEXT:    [[A_FROZEN:%.*]] = freeze i128 [[A:%.*]]
; CHECK-NEXT:    [[B_FROZEN:%.*]] = freeze i128 [[B:%.*]]
; CHECK-NEXT:    [[DIV:%.*]] = udiv i128 [[A_FROZEN]], [[B_FROZEN]]
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_THEN:%.*]], label [[END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[TMP0:%.*]] = mul i128 [[DIV]], [[B_FROZEN]]
; CHECK-NEXT:    [[REM_DECOMPOSED:%.*]] = sub i128 [[A_FROZEN]], [[TMP0]]
; CHECK-NEXT:    store i128 [[REM_DECOMPOSED]], ptr [[RP]], align 16
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    ret i128 [[DIV]]
;
entry:
  %cmp = icmp ne ptr %rp, null
  br i1 %cmp, label %if.then, label %end

if.then:
  %rem = urem i128 %a, %b
  store i128 %rem, ptr %rp
  br label %end

end:
  %div = udiv i128 %a, %b
  ret i128 %div
}

define i64 @remainder_triangle_i64_multiple_rem_edges(i64 %a, i64 %b, i64 %c, ptr %rp) {
; CHECK-LABEL: @remainder_triangle_i64_multiple_rem_edges(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[DIV:%.*]] = udiv i64 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[REM:%.*]] = urem i64 [[A]], [[B]]
; CHECK-NEXT:    switch i64 [[C:%.*]], label [[SW_DEFAULT:%.*]] [
; CHECK-NEXT:    i64 0, label [[SW_BB:%.*]]
; CHECK-NEXT:    i64 2, label [[SW_BB]]
; CHECK-NEXT:    ]
; CHECK:       sw.bb:
; CHECK-NEXT:    store i64 [[REM]], ptr [[RP:%.*]], align 8
; CHECK-NEXT:    br label [[SW_DEFAULT]]
; CHECK:       sw.default:
; CHECK-NEXT:    ret i64 [[DIV]]
;
entry:
  switch i64 %c, label %sw.default [
  i64 0, label %sw.bb
  i64 2, label %sw.bb
  ]

sw.bb:                                            ; preds = %entry, %entry
  %rem = urem i64 %a, %b
  store i64 %rem, ptr %rp
  br label %sw.default

sw.default:                                       ; preds = %entry, %sw.bb
  %div = udiv i64 %a, %b
  ret i64 %div
}

define i64 @remainder_triangle_i64_multiple_div_edges(i64 %a, i64 %b, i64 %c, ptr %rp) {
; CHECK-LABEL: @remainder_triangle_i64_multiple_div_edges(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[DIV:%.*]] = udiv i64 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[REM:%.*]] = urem i64 [[A]], [[B]]
; CHECK-NEXT:    switch i64 [[C:%.*]], label [[SW_DEFAULT:%.*]] [
; CHECK-NEXT:    i64 0, label [[SW_BB:%.*]]
; CHECK-NEXT:    i64 2, label [[SW_BB]]
; CHECK-NEXT:    ]
; CHECK:       sw.default:
; CHECK-NEXT:    store i64 [[REM]], ptr [[RP:%.*]], align 8
; CHECK-NEXT:    br label [[SW_BB]]
; CHECK:       sw.bb:
; CHECK-NEXT:    ret i64 [[DIV]]
;
entry:
  switch i64 %c, label %sw.default [
  i64 0, label %sw.bb
  i64 2, label %sw.bb
  ]

sw.default:                                       ; preds = %entry, %entry
  %rem = urem i64 %a, %b
  store i64 %rem, ptr %rp
  br label %sw.bb

sw.bb:                                            ; preds = %entry, %sw.default
  %div = udiv i64 %a, %b
  ret i64 %div
}

declare void @maythrow()

; Negative test. make sure we don't transform if there are instructions before
; the rem that might throw.
define i64 @remainder_triangle_i64_maythrow_rem(i64 %a, i64 %b, ptr %rp) {
; CHECK-LABEL: @remainder_triangle_i64_maythrow_rem(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne ptr [[RP:%.*]], null
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_THEN:%.*]], label [[END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    call void @maythrow()
; CHECK-NEXT:    [[REM:%.*]] = urem i64 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    store i64 [[REM]], ptr [[RP]], align 8
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[DIV:%.*]] = udiv i64 [[A]], [[B]]
; CHECK-NEXT:    ret i64 [[DIV]]
;
entry:
  %cmp = icmp ne ptr %rp, null
  br i1 %cmp, label %if.then, label %end

if.then:
  call void @maythrow()
  %rem = urem i64 %a, %b
  store i64 %rem, ptr %rp
  br label %end

end:
  %div = udiv i64 %a, %b
  ret i64 %div
}

; Negative test. make sure we don't transform if there are instructions before
; the div that might throw.
define i64 @remainder_triangle_i64_maythrow_div(i64 %a, i64 %b, ptr %rp) {
; CHECK-LABEL: @remainder_triangle_i64_maythrow_div(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne ptr [[RP:%.*]], null
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_THEN:%.*]], label [[END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[REM:%.*]] = urem i64 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    store i64 [[REM]], ptr [[RP]], align 8
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    call void @maythrow()
; CHECK-NEXT:    [[DIV:%.*]] = udiv i64 [[A]], [[B]]
; CHECK-NEXT:    ret i64 [[DIV]]
;
entry:
  %cmp = icmp ne ptr %rp, null
  br i1 %cmp, label %if.then, label %end

if.then:
  %rem = urem i64 %a, %b
  store i64 %rem, ptr %rp
  br label %end

end:
  call void @maythrow()
  %div = udiv i64 %a, %b
  ret i64 %div
}

; Negative test, Make sure we don't transform if there are instructions before
; the rem that might throw.
define i128 @remainder_triangle_i128_maythrow_rem(i128 %a, i128 %b, ptr %rp) {
; CHECK-LABEL: @remainder_triangle_i128_maythrow_rem(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne ptr [[RP:%.*]], null
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_THEN:%.*]], label [[END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    call void @maythrow()
; CHECK-NEXT:    [[REM:%.*]] = urem i128 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    store i128 [[REM]], ptr [[RP]], align 16
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[DIV:%.*]] = udiv i128 [[A]], [[B]]
; CHECK-NEXT:    ret i128 [[DIV]]
;
entry:
  %cmp = icmp ne ptr %rp, null
  br i1 %cmp, label %if.then, label %end

if.then:
  call void @maythrow()
  %rem = urem i128 %a, %b
  store i128 %rem, ptr %rp
  br label %end

end:
  %div = udiv i128 %a, %b
  ret i128 %div
}

; Negative test. Make sure we don't transform if there are instructions before
; the div that might throw.
define i128 @remainder_triangle_i128_maythrow_div(i128 %a, i128 %b, ptr %rp) {
; CHECK-LABEL: @remainder_triangle_i128_maythrow_div(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne ptr [[RP:%.*]], null
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_THEN:%.*]], label [[END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[REM:%.*]] = urem i128 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    store i128 [[REM]], ptr [[RP]], align 16
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    call void @maythrow()
; CHECK-NEXT:    [[DIV:%.*]] = udiv i128 [[A]], [[B]]
; CHECK-NEXT:    ret i128 [[DIV]]
;
entry:
  %cmp = icmp ne ptr %rp, null
  br i1 %cmp, label %if.then, label %end

if.then:
  %rem = urem i128 %a, %b
  store i128 %rem, ptr %rp
  br label %end

end:
  call void @maythrow()
  %div = udiv i128 %a, %b
  ret i128 %div
}

; Negative test. The common predecessor has another successor so we can't hoist
; the udiv to the common predecessor.
define i64 @remainder_not_triangle_i32(i64 %a, i64 %b, i64 %c, ptr %rp) {
; CHECK-LABEL: @remainder_not_triangle_i32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    switch i64 [[C:%.*]], label [[RETURN:%.*]] [
; CHECK-NEXT:    i64 0, label [[SW_BB:%.*]]
; CHECK-NEXT:    i64 1, label [[SW_BB1:%.*]]
; CHECK-NEXT:    ]
; CHECK:       sw.bb:
; CHECK-NEXT:    [[REM:%.*]] = urem i64 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    store i64 [[REM]], ptr [[RP:%.*]], align 8
; CHECK-NEXT:    br label [[SW_BB1]]
; CHECK:       sw.bb1:
; CHECK-NEXT:    [[DIV:%.*]] = udiv i64 [[A]], [[B]]
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       return:
; CHECK-NEXT:    [[RETVAL_0:%.*]] = phi i64 [ [[DIV]], [[SW_BB1]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret i64 [[RETVAL_0]]
;
entry:
  switch i64 %c, label %return [
  i64 0, label %sw.bb
  i64 1, label %sw.bb1
  ]

sw.bb:                                            ; preds = %entry
  %rem = urem i64 %a, %b
  store i64 %rem, ptr %rp
  br label %sw.bb1

sw.bb1:                                           ; preds = %entry, %sw.bb
  %div = udiv i64 %a, %b
  br label %return

return:                                           ; preds = %entry, %sw.bb1
  %retval.0 = phi i64 [ %div, %sw.bb1 ], [ 0, %entry ]
  ret i64 %retval.0
}

; Negative test. The urem block has a successor that isn't udiv.
define i64 @remainder_not_triangle_i32_2(i64 %a, i64 %b, i64 %c, ptr %rp) {
; CHECK-LABEL: @remainder_not_triangle_i32_2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TOBOOL_NOT:%.*]] = icmp eq ptr [[RP:%.*]], null
; CHECK-NEXT:    br i1 [[TOBOOL_NOT]], label [[IF_END3:%.*]], label [[IF_THEN:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[REM:%.*]] = urem i64 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    store i64 [[REM]], ptr [[RP]], align 8
; CHECK-NEXT:    [[TOBOOL1_NOT:%.*]] = icmp eq i64 [[C:%.*]], 0
; CHECK-NEXT:    br i1 [[TOBOOL1_NOT]], label [[IF_END3]], label [[RETURN:%.*]]
; CHECK:       if.end3:
; CHECK-NEXT:    [[DIV:%.*]] = udiv i64 [[A]], [[B]]
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       return:
; CHECK-NEXT:    [[RETVAL_0:%.*]] = phi i64 [ [[DIV]], [[IF_END3]] ], [ 0, [[IF_THEN]] ]
; CHECK-NEXT:    ret i64 [[RETVAL_0]]
;
entry:
  %tobool.not = icmp eq ptr %rp, null
  br i1 %tobool.not, label %if.end3, label %if.then

if.then:                                          ; preds = %entry
  %rem = urem i64 %a, %b
  store i64 %rem, ptr %rp
  %tobool1.not = icmp eq i64 %c, 0
  br i1 %tobool1.not, label %if.end3, label %return

if.end3:                                          ; preds = %if.then, %entry
  %div = udiv i64 %a, %b
  br label %return

return:                                           ; preds = %if.then, %if.end3
  %retval.0 = phi i64 [ %div, %if.end3 ], [ 0, %if.then ]
  ret i64 %retval.0
}

; Negative test (this would create invalid IR and crash).
; The div block can't have predecessors other than the rem block
; and the common single pred block (it is reachable from entry here).

define i32 @PR51241(i1 %b1, i1 %b2, i32 %t0) {
; CHECK-LABEL: @PR51241(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[B1:%.*]], label [[DIVBB:%.*]], label [[PREDBB:%.*]]
; CHECK:       predbb:
; CHECK-NEXT:    br i1 [[B2:%.*]], label [[DIVBB]], label [[REMBB:%.*]]
; CHECK:       rembb:
; CHECK-NEXT:    [[REM2:%.*]] = srem i32 7, [[T0:%.*]]
; CHECK-NEXT:    br label [[DIVBB]]
; CHECK:       divbb:
; CHECK-NEXT:    [[DIV:%.*]] = sdiv i32 7, [[T0]]
; CHECK-NEXT:    ret i32 [[DIV]]
;
entry:
  br i1 %b1, label %divbb, label %predbb

predbb:
  br i1 %b2, label %divbb, label %rembb

rembb:
  %rem2 = srem i32 7, %t0
  br label %divbb

divbb:
  %div = sdiv i32 7, %t0
  ret i32 %div
}