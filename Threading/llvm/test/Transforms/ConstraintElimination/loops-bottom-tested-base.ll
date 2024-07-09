; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=constraint-elimination -S %s | FileCheck %s

declare void @use(i1)

define void @loop_iv_cond_variable_bound(i32 %n) {
; CHECK-LABEL: @loop_iv_cond_variable_bound(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[T_1:%.*]] = icmp ule i32 [[IV]], [[N:%.*]]
; CHECK-NEXT:    call void @use(i1 [[T_1]])
; CHECK-NEXT:    [[T_2:%.*]] = icmp sge i32 [[IV]], 0
; CHECK-NEXT:    call void @use(i1 [[T_2]])
; CHECK-NEXT:    [[T_3:%.*]] = icmp sge i32 [[IV]], -1
; CHECK-NEXT:    call void @use(i1 [[T_3]])
; CHECK-NEXT:    [[C_1:%.*]] = icmp ult i32 [[IV]], [[N]]
; CHECK-NEXT:    call void @use(i1 [[C_1]])
; CHECK-NEXT:    [[C_2:%.*]] = icmp ugt i32 [[IV]], 1
; CHECK-NEXT:    call void @use(i1 [[C_2]])
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i32 [[IV]], [[N]]
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i32 [[IV]], 1
; CHECK-NEXT:    br i1 [[CMP]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry ], [ %iv.next, %loop ]
  %t.1 = icmp ule i32 %iv, %n
  call void @use(i1 %t.1)
  %t.2 = icmp sge i32 %iv, 0
  call void @use(i1 %t.2)
  %t.3 = icmp sge i32 %iv, -1
  call void @use(i1 %t.3)

  %c.1 = icmp ult i32 %iv, %n
  call void @use(i1 %c.1)
  %c.2 = icmp ugt i32 %iv, 1
  call void @use(i1 %c.2)

  %cmp = icmp ult i32 %iv, %n
  %iv.next = add nuw nsw i32 %iv, 1
  br i1 %cmp, label %loop, label %exit

exit:
  ret void
}

define void @loop_iv_cond_constant_bound() {
; CHECK-LABEL: @loop_iv_cond_constant_bound(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[T_1:%.*]] = icmp ule i32 [[IV]], 2
; CHECK-NEXT:    call void @use(i1 [[T_1]])
; CHECK-NEXT:    [[T_2:%.*]] = icmp sge i32 [[IV]], 0
; CHECK-NEXT:    call void @use(i1 [[T_2]])
; CHECK-NEXT:    [[T_3:%.*]] = icmp sge i32 [[IV]], -1
; CHECK-NEXT:    call void @use(i1 [[T_3]])
; CHECK-NEXT:    [[C_1:%.*]] = icmp ult i32 [[IV]], 2
; CHECK-NEXT:    call void @use(i1 [[C_1]])
; CHECK-NEXT:    [[C_2:%.*]] = icmp ugt i32 [[IV]], 1
; CHECK-NEXT:    call void @use(i1 [[C_2]])
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i32 [[IV]], 2
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i32 [[IV]], 1
; CHECK-NEXT:    br i1 [[CMP]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry ], [ %iv.next, %loop ]
  %t.1 = icmp ule i32 %iv, 2
  call void @use(i1 %t.1)
  %t.2 = icmp sge i32 %iv, 0
  call void @use(i1 %t.2)
  %t.3 = icmp sge i32 %iv, -1
  call void @use(i1 %t.3)

  %c.1 = icmp ult i32 %iv, 2
  call void @use(i1 %c.1)
  %c.2 = icmp ugt i32 %iv, 1
  call void @use(i1 %c.2)

  %cmp = icmp ult i32 %iv, 2
  %iv.next = add nuw nsw i32 %iv, 1
  br i1 %cmp, label %loop, label %exit

exit:
  ret void
}

declare void @clobber()

define void @eq_exit_check_constant_int() {
; CHECK-LABEL: @eq_exit_check_constant_int(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ 1, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add nuw i64 [[IV]], 1
; CHECK-NEXT:    call void @clobber()
; CHECK-NEXT:    [[C:%.*]] = icmp eq i64 [[IV]], 2
; CHECK-NEXT:    br i1 [[C]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop

loop:
  %iv = phi i64 [ 1, %entry], [ %iv.next, %loop ]
  %iv.next = add nuw i64 %iv, 1
  call void @clobber()
  %c = icmp eq i64 %iv, 2
  br i1 %c, label %exit, label %loop

exit:
  ret void
}

define void @eq_exit_check_variable(i64 %N) {
; CHECK-LABEL: @eq_exit_check_variable(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[PRECOND:%.*]] = icmp eq i64 [[N:%.*]], 0
; CHECK-NEXT:    br i1 [[PRECOND]], label [[EXIT:%.*]], label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ 1, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add nuw i64 [[IV]], 1
; CHECK-NEXT:    call void @clobber()
; CHECK-NEXT:    [[EXITCOND86_NOT_I_I:%.*]] = icmp eq i64 [[IV]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND86_NOT_I_I]], label [[EXIT]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %precond = icmp eq i64 %N, 0
  br i1 %precond, label %exit, label %loop

loop:
  %iv = phi i64 [ 1, %entry ], [ %iv.next, %loop ]
  %iv.next = add nuw i64 %iv, 1
  call void @clobber()
  %exitcond86.not.i.i = icmp eq i64 %iv, %N
  br i1 %exitcond86.not.i.i, label %exit, label %loop

exit:
  ret void
}

define void @eq_exit_check_constant_ptr(ptr %start) {
; CHECK-LABEL: @eq_exit_check_constant_ptr(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[UPPER:%.*]] = getelementptr inbounds i8, ptr [[START:%.*]], i8 2
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi ptr [ [[START]], [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[IV_NEXT]] = getelementptr inbounds i8, ptr [[IV]], i8 1
; CHECK-NEXT:    call void @clobber()
; CHECK-NEXT:    [[C:%.*]] = icmp eq ptr [[IV]], [[UPPER]]
; CHECK-NEXT:    br i1 [[C]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %upper = getelementptr inbounds i8, ptr %start, i8 2
  br label %loop

loop:
  %iv = phi ptr [ %start, %entry], [ %iv.next, %loop ]
  %iv.next = getelementptr inbounds i8, ptr %iv, i8 1
  call void @clobber()
  %c = icmp eq ptr %iv, %upper
  br i1 %c, label %exit, label %loop

exit:
  ret void
}
