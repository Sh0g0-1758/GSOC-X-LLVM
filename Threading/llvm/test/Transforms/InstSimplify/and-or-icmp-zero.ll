; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instsimplify -S | FileCheck %s

; In the next 16 tests (4 commutes * 2 (and/or) * 2 optional ptrtoint casts),
; eliminate the simple (not) null check because that compare is implied by the
; masked compare of the same operand.
; Vary types between scalar and vector and weird for extra coverage.

; or (icmp eq (and X, ?), 0), (icmp eq X, 0) --> icmp eq (and X, ?), 0

define i1 @or_cmps_eq_zero_with_mask_commute1(i64 %x, i64 %y) {
; CHECK-LABEL: @or_cmps_eq_zero_with_mask_commute1(
; CHECK-NEXT:    [[SOMEBITS:%.*]] = and i64 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[SOMEBITS_ARE_ZERO:%.*]] = icmp eq i64 [[SOMEBITS]], 0
; CHECK-NEXT:    ret i1 [[SOMEBITS_ARE_ZERO]]
;
  %isnull = icmp eq i64 %x, 0
  %somebits = and i64 %x, %y
  %somebits_are_zero = icmp eq i64 %somebits, 0
  %r = or i1 %somebits_are_zero, %isnull
  ret i1 %r
}

; or (icmp eq X, 0), (icmp eq (and X, ?), 0) --> icmp eq (and X, ?), 0

define <2 x i1> @or_cmps_eq_zero_with_mask_commute2(<2 x i64> %x, <2 x i64> %y) {
; CHECK-LABEL: @or_cmps_eq_zero_with_mask_commute2(
; CHECK-NEXT:    [[SOMEBITS:%.*]] = and <2 x i64> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[SOMEBITS_ARE_ZERO:%.*]] = icmp eq <2 x i64> [[SOMEBITS]], zeroinitializer
; CHECK-NEXT:    ret <2 x i1> [[SOMEBITS_ARE_ZERO]]
;
  %isnull = icmp eq <2 x i64> %x, zeroinitializer
  %somebits = and <2 x i64> %x, %y
  %somebits_are_zero = icmp eq <2 x i64> %somebits, zeroinitializer
  %r = or <2 x i1> %isnull, %somebits_are_zero
  ret <2 x i1> %r
}

; or (icmp eq (and ?, X), 0), (icmp eq X, 0) --> icmp eq (and ?, X), 0

define i1 @or_cmps_eq_zero_with_mask_commute3(i4 %x, i4 %y) {
; CHECK-LABEL: @or_cmps_eq_zero_with_mask_commute3(
; CHECK-NEXT:    [[SOMEBITS:%.*]] = and i4 [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    [[SOMEBITS_ARE_ZERO:%.*]] = icmp eq i4 [[SOMEBITS]], 0
; CHECK-NEXT:    ret i1 [[SOMEBITS_ARE_ZERO]]
;
  %isnull = icmp eq i4 %x, 0
  %somebits = and i4 %y, %x
  %somebits_are_zero = icmp eq i4 %somebits, 0
  %r = or i1 %somebits_are_zero, %isnull
  ret i1 %r
}

; or (icmp eq X, 0), (icmp eq (and ?, X), 0) --> icmp eq (and ?, X), 0

define <2 x i1> @or_cmps_eq_zero_with_mask_commute4(<2 x i4> %x, <2 x i4> %y) {
; CHECK-LABEL: @or_cmps_eq_zero_with_mask_commute4(
; CHECK-NEXT:    [[SOMEBITS:%.*]] = and <2 x i4> [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    [[SOMEBITS_ARE_ZERO:%.*]] = icmp eq <2 x i4> [[SOMEBITS]], zeroinitializer
; CHECK-NEXT:    ret <2 x i1> [[SOMEBITS_ARE_ZERO]]
;
  %isnull = icmp eq <2 x i4> %x, zeroinitializer
  %somebits = and <2 x i4> %y, %x
  %somebits_are_zero = icmp eq <2 x i4> %somebits, zeroinitializer
  %r = or <2 x i1> %isnull, %somebits_are_zero
  ret <2 x i1> %r
}

; and (icmp ne (and X, ?), 0), (icmp ne X, 0) --> icmp ne (and X, ?), 0

define <3 x i1> @and_cmps_eq_zero_with_mask_commute1(<3 x i4> %x, <3 x i4> %y) {
; CHECK-LABEL: @and_cmps_eq_zero_with_mask_commute1(
; CHECK-NEXT:    [[SOMEBITS:%.*]] = and <3 x i4> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[SOMEBITS_ARE_NOT_ZERO:%.*]] = icmp ne <3 x i4> [[SOMEBITS]], zeroinitializer
; CHECK-NEXT:    ret <3 x i1> [[SOMEBITS_ARE_NOT_ZERO]]
;
  %isnotnull = icmp ne <3 x i4> %x, zeroinitializer
  %somebits = and <3 x i4> %x, %y
  %somebits_are_not_zero = icmp ne <3 x i4> %somebits, zeroinitializer
  %r = and <3 x i1> %somebits_are_not_zero, %isnotnull
  ret <3 x i1> %r
}

; and (icmp ne X, 0), (icmp ne (and X, ?), 0) --> icmp ne (and X, ?), 0

define i1 @and_cmps_eq_zero_with_mask_commute2(i4 %x, i4 %y) {
; CHECK-LABEL: @and_cmps_eq_zero_with_mask_commute2(
; CHECK-NEXT:    [[SOMEBITS:%.*]] = and i4 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[SOMEBITS_ARE_NOT_ZERO:%.*]] = icmp ne i4 [[SOMEBITS]], 0
; CHECK-NEXT:    ret i1 [[SOMEBITS_ARE_NOT_ZERO]]
;
  %isnotnull = icmp ne i4 %x, 0
  %somebits = and i4 %x, %y
  %somebits_are_not_zero = icmp ne i4 %somebits, 0
  %r = and i1 %isnotnull, %somebits_are_not_zero
  ret i1 %r
}

; and (icmp ne (and ?, X), 0), (icmp ne X, 0) --> icmp ne (and ?, X), 0

define <3 x i1> @and_cmps_eq_zero_with_mask_commute3(<3 x i64> %x, <3 x i64> %y) {
; CHECK-LABEL: @and_cmps_eq_zero_with_mask_commute3(
; CHECK-NEXT:    [[SOMEBITS:%.*]] = and <3 x i64> [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    [[SOMEBITS_ARE_NOT_ZERO:%.*]] = icmp ne <3 x i64> [[SOMEBITS]], zeroinitializer
; CHECK-NEXT:    ret <3 x i1> [[SOMEBITS_ARE_NOT_ZERO]]
;
  %isnotnull = icmp ne <3 x i64> %x, zeroinitializer
  %somebits = and <3 x i64> %y, %x
  %somebits_are_not_zero = icmp ne <3 x i64> %somebits, zeroinitializer
  %r = and <3 x i1> %somebits_are_not_zero, %isnotnull
  ret <3 x i1> %r
}

; and (icmp ne X, 0), (icmp ne (and ?, X), 0) --> icmp ne (and ?, X), 0

define i1 @and_cmps_eq_zero_with_mask_commute4(i64 %x, i64 %y) {
; CHECK-LABEL: @and_cmps_eq_zero_with_mask_commute4(
; CHECK-NEXT:    [[SOMEBITS:%.*]] = and i64 [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    [[SOMEBITS_ARE_NOT_ZERO:%.*]] = icmp ne i64 [[SOMEBITS]], 0
; CHECK-NEXT:    ret i1 [[SOMEBITS_ARE_NOT_ZERO]]
;
  %isnotnull = icmp ne i64 %x, 0
  %somebits = and i64 %y, %x
  %somebits_are_not_zero = icmp ne i64 %somebits, 0
  %r = and i1 %isnotnull, %somebits_are_not_zero
  ret i1 %r
}

; or (icmp eq (and (ptrtoint P), ?), 0), (icmp eq P, 0) --> icmp eq (and (ptrtoint P), ?), 0

define i1 @or_cmps_ptr_eq_zero_with_mask_commute1(ptr %p, i64 %y) {
; CHECK-LABEL: @or_cmps_ptr_eq_zero_with_mask_commute1(
; CHECK-NEXT:    [[X:%.*]] = ptrtoint ptr [[P:%.*]] to i64
; CHECK-NEXT:    [[SOMEBITS:%.*]] = and i64 [[X]], [[Y:%.*]]
; CHECK-NEXT:    [[SOMEBITS_ARE_ZERO:%.*]] = icmp eq i64 [[SOMEBITS]], 0
; CHECK-NEXT:    ret i1 [[SOMEBITS_ARE_ZERO]]
;
  %isnull = icmp eq ptr %p, null
  %x = ptrtoint ptr %p to i64
  %somebits = and i64 %x, %y
  %somebits_are_zero = icmp eq i64 %somebits, 0
  %r = or i1 %somebits_are_zero, %isnull
  ret i1 %r
}

; or (icmp eq P, 0), (icmp eq (and (ptrtoint P), ?), 0) --> icmp eq (and (ptrtoint P), ?), 0

define <2 x i1> @or_cmps_ptr_eq_zero_with_mask_commute2(<2 x ptr> %p, <2 x i64> %y) {
; CHECK-LABEL: @or_cmps_ptr_eq_zero_with_mask_commute2(
; CHECK-NEXT:    [[X:%.*]] = ptrtoint <2 x ptr> [[P:%.*]] to <2 x i64>
; CHECK-NEXT:    [[SOMEBITS:%.*]] = and <2 x i64> [[X]], [[Y:%.*]]
; CHECK-NEXT:    [[SOMEBITS_ARE_ZERO:%.*]] = icmp eq <2 x i64> [[SOMEBITS]], zeroinitializer
; CHECK-NEXT:    ret <2 x i1> [[SOMEBITS_ARE_ZERO]]
;
  %isnull = icmp eq <2 x ptr> %p, zeroinitializer
  %x = ptrtoint <2 x ptr> %p to <2 x i64>
  %somebits = and <2 x i64> %x, %y
  %somebits_are_zero = icmp eq <2 x i64> %somebits, zeroinitializer
  %r = or <2 x i1> %isnull, %somebits_are_zero
  ret <2 x i1> %r
}

; or (icmp eq (and ?, (ptrtoint P)), 0), (icmp eq P, 0) --> icmp eq (and ?, (ptrtoint P)), 0

define i1 @or_cmps_ptr_eq_zero_with_mask_commute3(ptr %p, i4 %y) {
; CHECK-LABEL: @or_cmps_ptr_eq_zero_with_mask_commute3(
; CHECK-NEXT:    [[X:%.*]] = ptrtoint ptr [[P:%.*]] to i4
; CHECK-NEXT:    [[SOMEBITS:%.*]] = and i4 [[Y:%.*]], [[X]]
; CHECK-NEXT:    [[SOMEBITS_ARE_ZERO:%.*]] = icmp eq i4 [[SOMEBITS]], 0
; CHECK-NEXT:    ret i1 [[SOMEBITS_ARE_ZERO]]
;
  %isnull = icmp eq ptr %p, null
  %x = ptrtoint ptr %p to i4
  %somebits = and i4 %y, %x
  %somebits_are_zero = icmp eq i4 %somebits, 0
  %r = or i1 %somebits_are_zero, %isnull
  ret i1 %r
}

; or (icmp eq P, 0), (icmp eq (and ?, (ptrtoint P)), 0) --> icmp eq (and ?, (ptrtoint P)), 0

define <2 x i1> @or_cmps_ptr_eq_zero_with_mask_commute4(<2 x ptr> %p, <2 x i4> %y) {
; CHECK-LABEL: @or_cmps_ptr_eq_zero_with_mask_commute4(
; CHECK-NEXT:    [[X:%.*]] = ptrtoint <2 x ptr> [[P:%.*]] to <2 x i4>
; CHECK-NEXT:    [[SOMEBITS:%.*]] = and <2 x i4> [[Y:%.*]], [[X]]
; CHECK-NEXT:    [[SOMEBITS_ARE_ZERO:%.*]] = icmp eq <2 x i4> [[SOMEBITS]], zeroinitializer
; CHECK-NEXT:    ret <2 x i1> [[SOMEBITS_ARE_ZERO]]
;
  %isnull = icmp eq <2 x ptr> %p, zeroinitializer
  %x = ptrtoint <2 x ptr> %p to <2 x i4>
  %somebits = and <2 x i4> %y, %x
  %somebits_are_zero = icmp eq <2 x i4> %somebits, zeroinitializer
  %r = or <2 x i1> %isnull, %somebits_are_zero
  ret <2 x i1> %r
}

; and (icmp ne (and (ptrtoint P), ?), 0), (icmp ne P, 0) --> icmp ne (and (ptrtoint P), ?), 0

define <3 x i1> @and_cmps_ptr_eq_zero_with_mask_commute1(<3 x ptr> %p, <3 x i4> %y) {
; CHECK-LABEL: @and_cmps_ptr_eq_zero_with_mask_commute1(
; CHECK-NEXT:    [[X:%.*]] = ptrtoint <3 x ptr> [[P:%.*]] to <3 x i4>
; CHECK-NEXT:    [[SOMEBITS:%.*]] = and <3 x i4> [[X]], [[Y:%.*]]
; CHECK-NEXT:    [[SOMEBITS_ARE_NOT_ZERO:%.*]] = icmp ne <3 x i4> [[SOMEBITS]], zeroinitializer
; CHECK-NEXT:    ret <3 x i1> [[SOMEBITS_ARE_NOT_ZERO]]
;
  %isnotnull = icmp ne <3 x ptr> %p, zeroinitializer
  %x = ptrtoint <3 x ptr> %p to <3 x i4>
  %somebits = and <3 x i4> %x, %y
  %somebits_are_not_zero = icmp ne <3 x i4> %somebits, zeroinitializer
  %r = and <3 x i1> %somebits_are_not_zero, %isnotnull
  ret <3 x i1> %r
}

; and (icmp ne P, 0), (icmp ne (and (ptrtoint P), ?), 0) --> icmp ne (and (ptrtoint P), ?), 0

define i1 @and_cmps_ptr_eq_zero_with_mask_commute2(ptr %p, i4 %y) {
; CHECK-LABEL: @and_cmps_ptr_eq_zero_with_mask_commute2(
; CHECK-NEXT:    [[X:%.*]] = ptrtoint ptr [[P:%.*]] to i4
; CHECK-NEXT:    [[SOMEBITS:%.*]] = and i4 [[X]], [[Y:%.*]]
; CHECK-NEXT:    [[SOMEBITS_ARE_NOT_ZERO:%.*]] = icmp ne i4 [[SOMEBITS]], 0
; CHECK-NEXT:    ret i1 [[SOMEBITS_ARE_NOT_ZERO]]
;
  %isnotnull = icmp ne ptr %p, null
  %x = ptrtoint ptr %p to i4
  %somebits = and i4 %x, %y
  %somebits_are_not_zero = icmp ne i4 %somebits, 0
  %r = and i1 %isnotnull, %somebits_are_not_zero
  ret i1 %r
}

; and (icmp ne (and ?, (ptrtoint P)), 0), (icmp ne P, 0) --> icmp ne (and ?, (ptrtoint P)), 0

define <3 x i1> @and_cmps_ptr_eq_zero_with_mask_commute3(<3 x ptr> %p, <3 x i64> %y) {
; CHECK-LABEL: @and_cmps_ptr_eq_zero_with_mask_commute3(
; CHECK-NEXT:    [[X:%.*]] = ptrtoint <3 x ptr> [[P:%.*]] to <3 x i64>
; CHECK-NEXT:    [[SOMEBITS:%.*]] = and <3 x i64> [[Y:%.*]], [[X]]
; CHECK-NEXT:    [[SOMEBITS_ARE_NOT_ZERO:%.*]] = icmp ne <3 x i64> [[SOMEBITS]], zeroinitializer
; CHECK-NEXT:    ret <3 x i1> [[SOMEBITS_ARE_NOT_ZERO]]
;
  %isnotnull = icmp ne <3 x ptr> %p, zeroinitializer
  %x = ptrtoint <3 x ptr> %p to <3 x i64>
  %somebits = and <3 x i64> %y, %x
  %somebits_are_not_zero = icmp ne <3 x i64> %somebits, zeroinitializer
  %r = and <3 x i1> %somebits_are_not_zero, %isnotnull
  ret <3 x i1> %r
}

; and (icmp ne P, 0), (icmp ne (and ?, (ptrtoint P)), 0) --> icmp ne (and ?, (ptrtoint P)), 0

define i1 @and_cmps_ptr_eq_zero_with_mask_commute4(ptr %p, i64 %y) {
; CHECK-LABEL: @and_cmps_ptr_eq_zero_with_mask_commute4(
; CHECK-NEXT:    [[X:%.*]] = ptrtoint ptr [[P:%.*]] to i64
; CHECK-NEXT:    [[SOMEBITS:%.*]] = and i64 [[Y:%.*]], [[X]]
; CHECK-NEXT:    [[SOMEBITS_ARE_NOT_ZERO:%.*]] = icmp ne i64 [[SOMEBITS]], 0
; CHECK-NEXT:    ret i1 [[SOMEBITS_ARE_NOT_ZERO]]
;
  %isnotnull = icmp ne ptr %p, null
  %x = ptrtoint ptr %p to i64
  %somebits = and i64 %y, %x
  %somebits_are_not_zero = icmp ne i64 %somebits, 0
  %r = and i1 %isnotnull, %somebits_are_not_zero
  ret i1 %r
}
