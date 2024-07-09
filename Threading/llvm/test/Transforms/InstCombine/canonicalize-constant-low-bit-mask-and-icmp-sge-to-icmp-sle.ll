; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

; https://bugs.llvm.org/show_bug.cgi?id=38123

; Pattern:
;   x & C s>= x
; Should be transformed into:
;   x s<= C
; Iff: isPowerOf2(C + 1)
; C must not be -1, but may be 0.

; ============================================================================ ;
; Basic positive tests
; ============================================================================ ;

define i1 @p0(i8 %x) {
; CHECK-LABEL: @p0(
; CHECK-NEXT:    [[RET:%.*]] = icmp slt i8 [[X:%.*]], 4
; CHECK-NEXT:    ret i1 [[RET]]
;
  %tmp0 = and i8 %x, 3
  %ret = icmp sge i8 %tmp0, %x
  ret i1 %ret
}

; ============================================================================ ;
; Vector tests
; ============================================================================ ;

define <2 x i1> @p1_vec_splat(<2 x i8> %x) {
; CHECK-LABEL: @p1_vec_splat(
; CHECK-NEXT:    [[RET:%.*]] = icmp slt <2 x i8> [[X:%.*]], <i8 4, i8 4>
; CHECK-NEXT:    ret <2 x i1> [[RET]]
;
  %tmp0 = and <2 x i8> %x, <i8 3, i8 3>
  %ret = icmp sge <2 x i8> %tmp0, %x
  ret <2 x i1> %ret
}

define <2 x i1> @p2_vec_nonsplat(<2 x i8> %x) {
; CHECK-LABEL: @p2_vec_nonsplat(
; CHECK-NEXT:    [[RET:%.*]] = icmp slt <2 x i8> [[X:%.*]], <i8 4, i8 16>
; CHECK-NEXT:    ret <2 x i1> [[RET]]
;
  %tmp0 = and <2 x i8> %x, <i8 3, i8 15> ; doesn't have to be splat.
  %ret = icmp sge <2 x i8> %tmp0, %x
  ret <2 x i1> %ret
}

define <2 x i1> @p2_vec_nonsplat_edgecase(<2 x i8> %x) {
; CHECK-LABEL: @p2_vec_nonsplat_edgecase(
; CHECK-NEXT:    [[RET:%.*]] = icmp slt <2 x i8> [[X:%.*]], <i8 4, i8 1>
; CHECK-NEXT:    ret <2 x i1> [[RET]]
;
  %tmp0 = and <2 x i8> %x, <i8 3, i8 0>
  %ret = icmp sge <2 x i8> %tmp0, %x
  ret <2 x i1> %ret
}

define <3 x i1> @p3_vec_splat_undef(<3 x i8> %x) {
; CHECK-LABEL: @p3_vec_splat_undef(
; CHECK-NEXT:    [[RET:%.*]] = icmp slt <3 x i8> [[X:%.*]], <i8 4, i8 4, i8 4>
; CHECK-NEXT:    ret <3 x i1> [[RET]]
;
  %tmp0 = and <3 x i8> %x, <i8 3, i8 undef, i8 3>
  %ret = icmp sge <3 x i8> %tmp0, %x
  ret <3 x i1> %ret
}

; ============================================================================ ;
; One-use tests. We don't care about multi-uses here.
; ============================================================================ ;

declare void @use8(i8)

define i1 @oneuse0(i8 %x) {
; CHECK-LABEL: @oneuse0(
; CHECK-NEXT:    [[TMP0:%.*]] = and i8 [[X:%.*]], 3
; CHECK-NEXT:    call void @use8(i8 [[TMP0]])
; CHECK-NEXT:    [[RET:%.*]] = icmp slt i8 [[X]], 4
; CHECK-NEXT:    ret i1 [[RET]]
;
  %tmp0 = and i8 %x, 3
  call void @use8(i8 %tmp0)
  %ret = icmp sge i8 %tmp0, %x
  ret i1 %ret
}

; ============================================================================ ;
; Negative tests
; ============================================================================ ;

; Commutativity tests.

declare i8 @gen8()

define i1 @c0() {
; CHECK-LABEL: @c0(
; CHECK-NEXT:    [[X:%.*]] = call i8 @gen8()
; CHECK-NEXT:    [[TMP0:%.*]] = and i8 [[X]], 3
; CHECK-NEXT:    [[RET:%.*]] = icmp sge i8 [[X]], [[TMP0]]
; CHECK-NEXT:    ret i1 [[RET]]
;
  %x = call i8 @gen8()
  %tmp0 = and i8 %x, 3
  %ret = icmp sge i8 %x, %tmp0 ; swapped order
  ret i1 %ret
}

; ============================================================================ ;
; Rest of negative tests
; ============================================================================ ;

define i1 @n0(i8 %x) {
; CHECK-LABEL: @n0(
; CHECK-NEXT:    [[TMP0:%.*]] = and i8 [[X:%.*]], 4
; CHECK-NEXT:    [[RET:%.*]] = icmp sge i8 [[TMP0]], [[X]]
; CHECK-NEXT:    ret i1 [[RET]]
;
  %tmp0 = and i8 %x, 4 ; power-of-two, but invalid.
  %ret = icmp sge i8 %tmp0, %x
  ret i1 %ret
}

define i1 @n1(i8 %x, i8 %y, i8 %notx) {
; CHECK-LABEL: @n1(
; CHECK-NEXT:    [[TMP0:%.*]] = and i8 [[X:%.*]], 3
; CHECK-NEXT:    [[RET:%.*]] = icmp sge i8 [[TMP0]], [[NOTX:%.*]]
; CHECK-NEXT:    ret i1 [[RET]]
;
  %tmp0 = and i8 %x, 3
  %ret = icmp sge i8 %tmp0, %notx ; not %x
  ret i1 %ret
}

define <2 x i1> @n2(<2 x i8> %x) {
; CHECK-LABEL: @n2(
; CHECK-NEXT:    [[TMP0:%.*]] = and <2 x i8> [[X:%.*]], <i8 3, i8 16>
; CHECK-NEXT:    [[RET:%.*]] = icmp sge <2 x i8> [[TMP0]], [[X]]
; CHECK-NEXT:    ret <2 x i1> [[RET]]
;
  %tmp0 = and <2 x i8> %x, <i8 3, i8 16> ; only the first one is valid.
  %ret = icmp sge <2 x i8> %tmp0, %x
  ret <2 x i1> %ret
}

; ============================================================================ ;
; Potential miscompiles.
; ============================================================================ ;

define i1 @nv(i8 %x, i8 %y) {
; CHECK-LABEL: @nv(
; CHECK-NEXT:    [[TMP0:%.*]] = lshr i8 -1, [[Y:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = and i8 [[TMP0]], [[X:%.*]]
; CHECK-NEXT:    [[RET:%.*]] = icmp sge i8 [[TMP1]], [[X]]
; CHECK-NEXT:    ret i1 [[RET]]
;
  %tmp0 = lshr i8 -1, %y
  %tmp1 = and i8 %tmp0, %x
  %ret = icmp sge i8 %tmp1, %x
  ret i1 %ret
}

define <2 x i1> @n3_vec(<2 x i8> %x) {
; CHECK-LABEL: @n3_vec(
; CHECK-NEXT:    [[TMP0:%.*]] = and <2 x i8> [[X:%.*]], <i8 3, i8 -1>
; CHECK-NEXT:    [[RET:%.*]] = icmp sge <2 x i8> [[TMP0]], [[X]]
; CHECK-NEXT:    ret <2 x i1> [[RET]]
;
  %tmp0 = and <2 x i8> %x, <i8 3, i8 -1>
  %ret = icmp sge <2 x i8> %tmp0, %x
  ret <2 x i1> %ret
}

define <3 x i1> @n4_vec(<3 x i8> %x) {
; CHECK-LABEL: @n4_vec(
; CHECK-NEXT:    [[TMP0:%.*]] = and <3 x i8> [[X:%.*]], <i8 3, i8 undef, i8 -1>
; CHECK-NEXT:    [[RET:%.*]] = icmp sge <3 x i8> [[TMP0]], [[X]]
; CHECK-NEXT:    ret <3 x i1> [[RET]]
;
  %tmp0 = and <3 x i8> %x, <i8 3, i8 undef, i8 -1>
  %ret = icmp sge <3 x i8> %tmp0, %x
  ret <3 x i1> %ret
}

; Commutativity tests with variable

define i1 @cv0(i8 %y) {
; CHECK-LABEL: @cv0(
; CHECK-NEXT:    [[X:%.*]] = call i8 @gen8()
; CHECK-NEXT:    [[TMP0:%.*]] = lshr i8 -1, [[Y:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = and i8 [[X]], [[TMP0]]
; CHECK-NEXT:    [[RET:%.*]] = icmp sge i8 [[TMP1]], [[X]]
; CHECK-NEXT:    ret i1 [[RET]]
;
  %x = call i8 @gen8()
  %tmp0 = lshr i8 -1, %y
  %tmp1 = and i8 %x, %tmp0 ; swapped order
  %ret = icmp sge i8 %tmp1, %x
  ret i1 %ret
}

define i1 @cv1(i8 %y) {
; CHECK-LABEL: @cv1(
; CHECK-NEXT:    [[X:%.*]] = call i8 @gen8()
; CHECK-NEXT:    [[TMP0:%.*]] = lshr i8 -1, [[Y:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = and i8 [[TMP0]], [[X]]
; CHECK-NEXT:    [[RET:%.*]] = icmp sge i8 [[X]], [[TMP1]]
; CHECK-NEXT:    ret i1 [[RET]]
;
  %x = call i8 @gen8()
  %tmp0 = lshr i8 -1, %y
  %tmp1 = and i8 %tmp0, %x
  %ret = icmp sge i8 %x, %tmp1 ; swapped order
  ret i1 %ret
}

define i1 @cv2(i8 %y) {
; CHECK-LABEL: @cv2(
; CHECK-NEXT:    [[X:%.*]] = call i8 @gen8()
; CHECK-NEXT:    [[TMP0:%.*]] = lshr i8 -1, [[Y:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = and i8 [[X]], [[TMP0]]
; CHECK-NEXT:    [[RET:%.*]] = icmp sge i8 [[X]], [[TMP1]]
; CHECK-NEXT:    ret i1 [[RET]]
;
  %x = call i8 @gen8()
  %tmp0 = lshr i8 -1, %y
  %tmp1 = and i8 %x, %tmp0 ; swapped order
  %ret = icmp sge i8 %x, %tmp1 ; swapped order
  ret i1 %ret
}
