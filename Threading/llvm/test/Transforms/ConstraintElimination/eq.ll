; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=constraint-elimination -S %s | FileCheck %s

declare void @llvm.assume(i1)

define i1 @test_eq_1(i8 %a, i8 %b) {
; CHECK-LABEL: @test_eq_1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[RES_1:%.*]] = xor i1 true, true
; CHECK-NEXT:    [[RES_2:%.*]] = xor i1 [[RES_1]], true
; CHECK-NEXT:    [[RES_3:%.*]] = xor i1 [[RES_2]], true
; CHECK-NEXT:    [[RES_4:%.*]] = xor i1 [[RES_3]], false
; CHECK-NEXT:    [[RES_5:%.*]] = xor i1 [[RES_4]], false
; CHECK-NEXT:    [[C_1:%.*]] = icmp ult i8 [[B]], 99
; CHECK-NEXT:    [[RES_6:%.*]] = xor i1 [[RES_5]], [[C_1]]
; CHECK-NEXT:    ret i1 [[RES_6]]
; CHECK:       else:
; CHECK-NEXT:    [[F_3:%.*]] = icmp eq i8 [[A]], [[B]]
; CHECK-NEXT:    [[F_4:%.*]] = icmp eq i8 [[B]], [[A]]
; CHECK-NEXT:    [[RES_7:%.*]] = xor i1 [[F_3]], [[F_4]]
; CHECK-NEXT:    [[C_2:%.*]] = icmp ult i8 [[B]], 99
; CHECK-NEXT:    [[RES_8:%.*]] = xor i1 [[RES_7]], [[C_2]]
; CHECK-NEXT:    [[C_3:%.*]] = icmp uge i8 [[A]], [[B]]
; CHECK-NEXT:    [[RES_9:%.*]] = xor i1 [[RES_8]], [[C_3]]
; CHECK-NEXT:    [[C_4:%.*]] = icmp ule i8 [[A]], [[B]]
; CHECK-NEXT:    [[RES_10:%.*]] = xor i1 [[RES_9]], [[C_4]]
; CHECK-NEXT:    [[C_5:%.*]] = icmp ugt i8 [[B]], [[A]]
; CHECK-NEXT:    [[RES_11:%.*]] = xor i1 [[RES_10]], [[C_5]]
; CHECK-NEXT:    [[C_6:%.*]] = icmp ult i8 [[B]], [[A]]
; CHECK-NEXT:    [[RES_12:%.*]] = xor i1 [[RES_11]], [[C_6]]
; CHECK-NEXT:    ret i1 [[RES_12]]
;
entry:
  %cmp = icmp eq i8 %a, %b
  br i1 %cmp, label %then, label %else

then:
  %t.1 = icmp uge i8 %a, %b
  %t.2 = icmp ule i8 %a, %b
  %res.1 = xor i1 %t.1, %t.2

  %t.3 = icmp eq i8 %a, %b
  %res.2 = xor i1 %res.1, %t.3

  %t.4 = icmp eq i8 %b, %a
  %res.3 = xor i1 %res.2, %t.4

  %f.1 = icmp ugt i8 %b, %a
  %res.4 = xor i1 %res.3, %f.1

  %f.2 = icmp ult i8 %b, %a
  %res.5 = xor i1 %res.4, %f.2

  %c.1 = icmp ult i8 %b, 99
  %res.6 = xor i1 %res.5, %c.1
  ret i1 %res.6

else:
  %f.3 = icmp eq i8 %a, %b
  %f.4 = icmp eq i8 %b, %a
  %res.7 = xor i1 %f.3, %f.4

  %c.2 = icmp ult i8 %b, 99
  %res.8 = xor i1 %res.7, %c.2

  %c.3 = icmp uge i8 %a, %b
  %res.9 = xor i1 %res.8, %c.3

  %c.4 = icmp ule i8 %a, %b
  %res.10 = xor i1 %res.9, %c.4

  %c.5 = icmp ugt i8 %b, %a
  %res.11 = xor i1 %res.10, %c.5

  %c.6 = icmp ult i8 %b, %a
  %res.12 = xor i1 %res.11, %c.6
  ret i1 %res.12
}

define i1 @test_eq_2(i8 %a, i8 %b) {
; CHECK-LABEL: @test_eq_2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[PRE_1:%.*]] = icmp eq i8 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    br i1 [[PRE_1]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[PRE_3:%.*]] = icmp ult i8 [[B]], 100
; CHECK-NEXT:    br i1 [[PRE_3]], label [[THEN_THEN:%.*]], label [[THEN_ELSE:%.*]]
; CHECK:       then.then:
; CHECK-NEXT:    [[XOR_1:%.*]] = xor i1 true, true
; CHECK-NEXT:    [[XOR_2:%.*]] = xor i1 [[XOR_1]], false
; CHECK-NEXT:    [[XOR_3:%.*]] = xor i1 [[XOR_2]], false
; CHECK-NEXT:    [[XOR_4:%.*]] = xor i1 [[XOR_3]], false
; CHECK-NEXT:    [[C_1:%.*]] = icmp ult i8 [[A]], 99
; CHECK-NEXT:    [[XOR_5:%.*]] = xor i1 [[XOR_4]], [[C_1]]
; CHECK-NEXT:    [[C_2:%.*]] = icmp ugt i8 [[A]], 98
; CHECK-NEXT:    [[XOR_6:%.*]] = xor i1 [[XOR_5]], [[C_1]]
; CHECK-NEXT:    ret i1 [[XOR_6]]
; CHECK:       then.else:
; CHECK-NEXT:    [[XOR_7:%.*]] = xor i1 false, false
; CHECK-NEXT:    [[XOR_8:%.*]] = xor i1 [[XOR_7]], true
; CHECK-NEXT:    [[XOR_9:%.*]] = xor i1 [[XOR_8]], true
; CHECK-NEXT:    [[XOR_10:%.*]] = xor i1 [[XOR_9]], true
; CHECK-NEXT:    [[XOR_11:%.*]] = xor i1 [[XOR_10]], false
; CHECK-NEXT:    [[XOR_12:%.*]] = xor i1 [[XOR_11]], true
; CHECK-NEXT:    ret i1 [[XOR_12]]
; CHECK:       else:
; CHECK-NEXT:    [[CMP_2:%.*]] = icmp ult i8 [[A]], 100
; CHECK-NEXT:    ret i1 [[CMP_2]]
;
entry:
  %pre.1 = icmp eq i8 %a, %b
  br i1 %pre.1, label %then, label %else

then:
  %pre.3 = icmp ult i8 %b, 100
  br i1 %pre.3, label %then.then, label %then.else

then.then:
  %t.1 = icmp ult i8 %a, 100
  %t.2 = icmp ult i8 %b, 100
  %xor.1 = xor i1 %t.1, %t.2

  %f.1 = icmp uge i8 %a, 100
  %xor.2 = xor i1 %xor.1, %f.1

  %f.2 = icmp uge i8 %b, 100
  %xor.3 = xor i1 %xor.2, %f.2

  %f.3.1 = icmp ugt i8 %a, 99
  %xor.4 = xor i1 %xor.3, %f.3.1

  %c.1 = icmp ult i8 %a, 99
  %xor.5 = xor i1 %xor.4, %c.1

  %c.2 = icmp ugt i8 %a, 98
  %xor.6 = xor i1 %xor.5, %c.1

  ret i1 %xor.6

then.else:
  %f.4 = icmp ult i8 %a, 100
  %f.5 = icmp ult i8 %b, 100
  %xor.7 = xor i1 %f.4, %f.5

  %t.3 = icmp uge i8 %a, 100
  %xor.8 = xor i1 %xor.7, %t.3

  %t.4 = icmp uge i8 %b, 100
  %xor.9 = xor i1 %xor.8, %t.4

  %t.5 = icmp ugt i8 %a, 99
  %xor.10 = xor i1 %xor.9, %t.5

  %c.3 = icmp ult i8 %a, 99
  %xor.11 = xor i1 %xor.10, %c.3

  %c.4 = icmp ugt i8 %a, 98
  %xor.12 = xor i1 %xor.11, %c.4

  ret i1 %xor.12

else:
  %cmp.2 = icmp ult i8 %a, 100
  ret i1 %cmp.2
}

; Test of explicitly using uge & ule instead of eq.
define i1 @test_eq_as_uge_ule_(i8 %a, i8 %b) {
; CHECK-LABEL: @test_eq_as_uge_ule_(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[PRE_1:%.*]] = icmp uge i8 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[PRE_2:%.*]] = icmp ule i8 [[A]], [[B]]
; CHECK-NEXT:    [[PRE_AND:%.*]] = and i1 [[PRE_1]], [[PRE_2]]
; CHECK-NEXT:    br i1 [[PRE_AND]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[PRE_3:%.*]] = icmp ult i8 [[B]], 100
; CHECK-NEXT:    br i1 [[PRE_3]], label [[THEN_THEN:%.*]], label [[THEN_ELSE:%.*]]
; CHECK:       then.then:
; CHECK-NEXT:    [[XOR_1:%.*]] = xor i1 true, true
; CHECK-NEXT:    [[XOR_2:%.*]] = xor i1 [[XOR_1]], false
; CHECK-NEXT:    [[XOR_3:%.*]] = xor i1 [[XOR_2]], false
; CHECK-NEXT:    [[XOR_4:%.*]] = xor i1 [[XOR_3]], false
; CHECK-NEXT:    [[C_1:%.*]] = icmp ult i8 [[A]], 99
; CHECK-NEXT:    [[XOR_5:%.*]] = xor i1 [[XOR_4]], [[C_1]]
; CHECK-NEXT:    [[C_2:%.*]] = icmp ugt i8 [[A]], 98
; CHECK-NEXT:    [[XOR_6:%.*]] = xor i1 [[XOR_5]], [[C_1]]
; CHECK-NEXT:    ret i1 [[XOR_6]]
; CHECK:       then.else:
; CHECK-NEXT:    [[XOR_7:%.*]] = xor i1 false, false
; CHECK-NEXT:    [[XOR_8:%.*]] = xor i1 [[XOR_7]], true
; CHECK-NEXT:    [[XOR_9:%.*]] = xor i1 [[XOR_8]], true
; CHECK-NEXT:    [[XOR_10:%.*]] = xor i1 [[XOR_9]], true
; CHECK-NEXT:    [[XOR_11:%.*]] = xor i1 [[XOR_10]], false
; CHECK-NEXT:    [[XOR_12:%.*]] = xor i1 [[XOR_11]], true
; CHECK-NEXT:    ret i1 [[XOR_12]]
; CHECK:       else:
; CHECK-NEXT:    [[CMP_2:%.*]] = icmp ult i8 [[A]], 100
; CHECK-NEXT:    ret i1 [[CMP_2]]
;
entry:
  %pre.1 = icmp uge i8 %a, %b
  %pre.2 = icmp ule i8 %a, %b
  %pre.and = and i1 %pre.1, %pre.2
  br i1 %pre.and, label %then, label %else

then:
  %pre.3 = icmp ult i8 %b, 100
  br i1 %pre.3, label %then.then, label %then.else

then.then:
  %t.1 = icmp ult i8 %a, 100
  %t.2 = icmp ult i8 %b, 100
  %xor.1 = xor i1 %t.1, %t.2

  %f.1 = icmp uge i8 %a, 100
  %xor.2 = xor i1 %xor.1, %f.1

  %f.2 = icmp uge i8 %b, 100
  %xor.3 = xor i1 %xor.2, %f.2

  %f.3.1 = icmp ugt i8 %a, 99
  %xor.4 = xor i1 %xor.3, %f.3.1

  %c.1 = icmp ult i8 %a, 99
  %xor.5 = xor i1 %xor.4, %c.1

  %c.2 = icmp ugt i8 %a, 98
  %xor.6 = xor i1 %xor.5, %c.1

  ret i1 %xor.6

then.else:
  %f.4 = icmp ult i8 %a, 100
  %f.5 = icmp ult i8 %b, 100
  %xor.7 = xor i1 %f.4, %f.5

  %t.3 = icmp uge i8 %a, 100
  %xor.8 = xor i1 %xor.7, %t.3

  %t.4 = icmp uge i8 %b, 100
  %xor.9 = xor i1 %xor.8, %t.4

  %t.5 = icmp ugt i8 %a, 99
  %xor.10 = xor i1 %xor.9, %t.5

  %c.3 = icmp ult i8 %a, 99
  %xor.11 = xor i1 %xor.10, %c.3

  %c.4 = icmp ugt i8 %a, 98
  %xor.12 = xor i1 %xor.11, %c.4

  ret i1 %xor.12

else:
  %cmp.2 = icmp ult i8 %a, 100
  ret i1 %cmp.2
}


define i1 @test_eq_ult_and(i8 %a, i8 %b) {
; CHECK-LABEL: @test_eq_ult_and(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[PRE_1:%.*]] = icmp eq i8 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[PRE_2:%.*]] = icmp ult i8 [[B]], 100
; CHECK-NEXT:    [[PRE_AND:%.*]] = and i1 [[PRE_1]], [[PRE_2]]
; CHECK-NEXT:    br i1 [[PRE_AND]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[XOR_1:%.*]] = xor i1 true, true
; CHECK-NEXT:    [[XOR_2:%.*]] = xor i1 [[XOR_1]], false
; CHECK-NEXT:    [[XOR_3:%.*]] = xor i1 [[XOR_2]], false
; CHECK-NEXT:    [[XOR_4:%.*]] = xor i1 [[XOR_3]], false
; CHECK-NEXT:    [[C_1:%.*]] = icmp ult i8 [[A]], 99
; CHECK-NEXT:    [[XOR_5:%.*]] = xor i1 [[XOR_4]], [[C_1]]
; CHECK-NEXT:    [[C_2:%.*]] = icmp ugt i8 [[A]], 98
; CHECK-NEXT:    [[XOR_6:%.*]] = xor i1 [[XOR_5]], [[C_1]]
; CHECK-NEXT:    ret i1 [[XOR_6]]
; CHECK:       else:
; CHECK-NEXT:    [[F_4:%.*]] = icmp ult i8 [[A]], 100
; CHECK-NEXT:    [[F_5:%.*]] = icmp ult i8 [[B]], 100
; CHECK-NEXT:    [[XOR_7:%.*]] = xor i1 [[F_4]], [[F_5]]
; CHECK-NEXT:    [[T_3:%.*]] = icmp uge i8 [[A]], 100
; CHECK-NEXT:    [[XOR_8:%.*]] = xor i1 [[XOR_7]], [[T_3]]
; CHECK-NEXT:    [[T_4:%.*]] = icmp uge i8 [[B]], 100
; CHECK-NEXT:    [[XOR_9:%.*]] = xor i1 [[XOR_8]], [[T_4]]
; CHECK-NEXT:    [[T_5:%.*]] = icmp ugt i8 [[A]], 99
; CHECK-NEXT:    [[XOR_10:%.*]] = xor i1 [[XOR_9]], [[T_5]]
; CHECK-NEXT:    [[C_3:%.*]] = icmp ult i8 [[A]], 99
; CHECK-NEXT:    [[XOR_11:%.*]] = xor i1 [[XOR_10]], [[C_3]]
; CHECK-NEXT:    [[C_4:%.*]] = icmp ugt i8 [[A]], 98
; CHECK-NEXT:    [[XOR_12:%.*]] = xor i1 [[XOR_11]], [[C_4]]
; CHECK-NEXT:    ret i1 [[XOR_12]]
;
entry:
  %pre.1 = icmp eq i8 %a, %b
  %pre.2 = icmp ult i8 %b, 100
  %pre.and = and i1 %pre.1, %pre.2
  br i1 %pre.and, label %then, label %else

then:
  %t.1 = icmp ult i8 %a, 100
  %t.2 = icmp ult i8 %b, 100
  %xor.1 = xor i1 %t.1, %t.2

  %f.1 = icmp uge i8 %a, 100
  %xor.2 = xor i1 %xor.1, %f.1

  %f.2 = icmp uge i8 %b, 100
  %xor.3 = xor i1 %xor.2, %f.2

  %f.3.1 = icmp ugt i8 %a, 99
  %xor.4 = xor i1 %xor.3, %f.3.1

  %c.1 = icmp ult i8 %a, 99
  %xor.5 = xor i1 %xor.4, %c.1

  %c.2 = icmp ugt i8 %a, 98
  %xor.6 = xor i1 %xor.5, %c.1

  ret i1 %xor.6

else:
  %f.4 = icmp ult i8 %a, 100
  %f.5 = icmp ult i8 %b, 100
  %xor.7 = xor i1 %f.4, %f.5

  %t.3 = icmp uge i8 %a, 100
  %xor.8 = xor i1 %xor.7, %t.3

  %t.4 = icmp uge i8 %b, 100
  %xor.9 = xor i1 %xor.8, %t.4

  %t.5 = icmp ugt i8 %a, 99
  %xor.10 = xor i1 %xor.9, %t.5

  %c.3 = icmp ult i8 %a, 99
  %xor.11 = xor i1 %xor.10, %c.3

  %c.4 = icmp ugt i8 %a, 98
  %xor.12 = xor i1 %xor.11, %c.4

  ret i1 %xor.12
}

define i1 @assume_b_plus_1_ult_a(i64 %a, i64 %b)  {
; CHECK-LABEL: @assume_b_plus_1_ult_a(
; CHECK-NEXT:    [[TMP1:%.*]] = add nuw i64 [[B:%.*]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ult i64 [[TMP1]], [[A:%.*]]
; CHECK-NEXT:    tail call void @llvm.assume(i1 [[TMP2]])
; CHECK-NEXT:    ret i1 false
;
  %1 = add nuw i64 %b, 1
  %2 = icmp ult i64 %1, %a
  tail call void @llvm.assume(i1 %2)
  %3 = icmp eq i64 %a, %b
  ret i1 %3
}

define i1 @assume_a_plus_1_eq_b(i64 %a, i64 %b)  {
; CHECK-LABEL: @assume_a_plus_1_eq_b(
; CHECK-NEXT:    [[TMP1:%.*]] = add nuw i64 [[A:%.*]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = icmp eq i64 [[TMP1]], [[B:%.*]]
; CHECK-NEXT:    tail call void @llvm.assume(i1 [[TMP2]])
; CHECK-NEXT:    ret i1 false
;
  %1 = add nuw i64 %a, 1
  %2 = icmp eq i64 %1, %b
  tail call void @llvm.assume(i1 %2)
  %3 = icmp eq i64 %a, %b
  ret i1 %3
}

define i1 @assume_a_ge_b_and_b_ge_c(i64 %a, i64 %b, i64 %c)  {
; CHECK-LABEL: @assume_a_ge_b_and_b_ge_c(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp uge i64 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    tail call void @llvm.assume(i1 [[TMP1]])
; CHECK-NEXT:    [[TMP2:%.*]] = icmp uge i64 [[B]], [[C:%.*]]
; CHECK-NEXT:    tail call void @llvm.assume(i1 [[TMP2]])
; CHECK-NEXT:    [[TMP3:%.*]] = icmp eq i64 [[A]], [[C]]
; CHECK-NEXT:    ret i1 [[TMP3]]
;
  %1 = icmp uge i64 %a, %b
  tail call void @llvm.assume(i1 %1)
  %2 = icmp uge i64 %b, %c
  tail call void @llvm.assume(i1 %2)
  %3 = icmp eq i64 %a, %c
  ret i1 %3
}

define i1 @test_transitivity_of_equality_and_plus_1(i64 %a, i64 %b, i64 %c) {
; CHECK-LABEL: @test_transitivity_of_equality_and_plus_1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[PRE_1:%.*]] = icmp eq i64 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    br i1 [[PRE_1]], label [[AB_EQUAL:%.*]], label [[NOT_EQ:%.*]]
; CHECK:       ab_equal:
; CHECK-NEXT:    [[BC_EQ:%.*]] = icmp eq i64 [[B]], [[C:%.*]]
; CHECK-NEXT:    br i1 [[BC_EQ]], label [[BC_EQUAL:%.*]], label [[NOT_EQ]]
; CHECK:       bc_equal:
; CHECK-NEXT:    [[A_PLUS_1:%.*]] = add nuw i64 [[A]], 1
; CHECK-NEXT:    [[C_PLUS_1:%.*]] = add nuw i64 [[C]], 1
; CHECK-NEXT:    [[RESULT:%.*]] = and i1 true, true
; CHECK-NEXT:    ret i1 [[RESULT]]
; CHECK:       not_eq:
; CHECK-NEXT:    ret i1 false
;
entry:
  %pre.1 = icmp eq i64 %a, %b
  br i1 %pre.1, label %ab_equal, label %not_eq

ab_equal:
  %bc_eq = icmp eq i64 %b, %c
  br i1 %bc_eq, label %bc_equal, label %not_eq

bc_equal:
  %ac_eq = icmp eq i64 %a, %c
  %a_plus_1 = add nuw i64 %a, 1
  %c_plus_1 = add nuw i64 %c, 1
  %ac_plus_1_eq = icmp eq i64 %a_plus_1, %c_plus_1
  %result = and i1 %ac_eq, %ac_plus_1_eq
  ret i1 %result

not_eq:
  ret i1 false
}
