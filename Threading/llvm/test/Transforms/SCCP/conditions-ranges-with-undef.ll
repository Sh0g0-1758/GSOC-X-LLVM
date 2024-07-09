; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=ipsccp -S | FileCheck %s

declare void @use(i1)

; We can simplify the conditions in the true block, because the condition
; allows us to replace all uses of %a in the block with a  constant.
define void @val_undef_eq() {
; CHECK-LABEL: @val_undef_eq(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = add nuw nsw i32 undef, 0
; CHECK-NEXT:    [[BC_1:%.*]] = icmp eq i32 [[A]], 10
; CHECK-NEXT:    br i1 [[BC_1]], label [[TRUE:%.*]], label [[FALSE:%.*]]
; CHECK:       true:
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    ret void
; CHECK:       false:
; CHECK-NEXT:    ret void
;
entry:
  %a = add i32 undef, 0
  %bc.1 = icmp eq i32 %a, 10
  br i1 %bc.1, label %true, label %false

true:
  %f.1 = icmp ne i32 %a, 10
  call void @use(i1 %f.1)
  %f.2 = icmp eq i32 %a,  10
  call void @use(i1 %f.2)
  ret void

false:
  ret void
}

declare void @use.i32(i32)

; It is not allowed to use the range information from the condition to remove
; %a.127 = and ... in the true block, as %a could be undef.
define void @val_undef_range() {
; CHECK-LABEL: @val_undef_range(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = add nuw nsw i32 undef, 0
; CHECK-NEXT:    [[BC_1:%.*]] = icmp ult i32 [[A]], 127
; CHECK-NEXT:    br i1 [[BC_1]], label [[TRUE:%.*]], label [[FALSE:%.*]]
; CHECK:       true:
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    [[A_127:%.*]] = and i32 [[A]], 127
; CHECK-NEXT:    call void @use.i32(i32 [[A_127]])
; CHECK-NEXT:    ret void
; CHECK:       false:
; CHECK-NEXT:    ret void
;
entry:
  %a = add i32 undef, 0
  %bc.1 = icmp ult i32 %a, 127
  br i1 %bc.1, label %true, label %false

true:
  %f.1 = icmp eq i32 %a, 128
  call void @use(i1 %f.1)

  %a.127 = and i32 %a, 127
  call void @use.i32(i32 %a.127)
  ret void

false:
  ret void
}

; All uses of %p can be replaced by a constant (10).
define void @val_singlecrfromundef_range(i1 %cond) {
; CHECK-LABEL: @val_singlecrfromundef_range(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[INC1:%.*]], label [[INC2:%.*]]
; CHECK:       inc1:
; CHECK-NEXT:    br label [[IF:%.*]]
; CHECK:       inc2:
; CHECK-NEXT:    br label [[IF]]
; CHECK:       if:
; CHECK-NEXT:    br label [[TRUE:%.*]]
; CHECK:       true:
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    [[P_127:%.*]] = and i32 10, 127
; CHECK-NEXT:    call void @use.i32(i32 [[P_127]])
; CHECK-NEXT:    ret void
;
entry:

  br i1 %cond, label %inc1, label %inc2

inc1:
  br label %if

inc2:
  br label %if

if:
  %p = phi i32 [ 10, %inc1 ], [ undef, %inc2 ]
  %bc.1 = icmp ult i32 %p, 127
  br i1 %bc.1, label %true, label %false

true:
  %f.1 = icmp eq i32 %p, 128
  call void @use(i1 %f.1)

  %p.127 = and i32 %p, 127
  call void @use.i32(i32 %p.127)
  ret void

false:
  ret void
}


; It is not allowed to use the information from the condition ([0, 128))
; to remove a.127.2 = and i32 %p, 127, as %p might be undef.
define void @val_undef_to_cr_to_overdef_range(i32 %a, i1 %cond) {
; CHECK-LABEL: @val_undef_to_cr_to_overdef_range(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A_127:%.*]] = and i32 [[A:%.*]], 127
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[INC1:%.*]], label [[INC2:%.*]]
; CHECK:       inc1:
; CHECK-NEXT:    br label [[IF:%.*]]
; CHECK:       inc2:
; CHECK-NEXT:    br label [[IF]]
; CHECK:       if:
; CHECK-NEXT:    [[P:%.*]] = phi i32 [ [[A_127]], [[INC1]] ], [ undef, [[INC2]] ]
; CHECK-NEXT:    [[BC_1:%.*]] = icmp ult i32 [[P]], 100
; CHECK-NEXT:    br i1 [[BC_1]], label [[TRUE:%.*]], label [[FALSE:%.*]]
; CHECK:       true:
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    [[P_127:%.*]] = and i32 [[P]], 127
; CHECK-NEXT:    call void @use.i32(i32 [[P_127]])
; CHECK-NEXT:    ret void
; CHECK:       false:
; CHECK-NEXT:    ret void
;
entry:
  %a.127 = and i32 %a, 127
  br i1 %cond, label %inc1, label %inc2

inc1:
  br label %if

inc2:
  br label %if

if:
  %p = phi i32 [ %a.127, %inc1 ], [ undef, %inc2 ]
  %bc.1 = icmp ult i32 %p, 100
  br i1 %bc.1, label %true, label %false

true:
  %f.1 = icmp eq i32 %p, 128
  call void @use(i1 %f.1)

  %p.127 = and i32 %p, 127
  call void @use.i32(i32 %p.127)
  ret void

false:
  ret void
}

; All uses of %p can be replaced by a constant (10), we are allowed to use it
; as a bound too.
define void @bound_singlecrfromundef(i32 %a, i1 %cond) {
; CHECK-LABEL: @bound_singlecrfromundef(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[PRED:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    br label [[PRED]]
; CHECK:       pred:
; CHECK-NEXT:    [[BC_1:%.*]] = icmp ugt i32 [[A:%.*]], 10
; CHECK-NEXT:    br i1 [[BC_1]], label [[TRUE:%.*]], label [[FALSE:%.*]]
; CHECK:       true:
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    [[A_127:%.*]] = and i32 [[A]], 127
; CHECK-NEXT:    call void @use.i32(i32 [[A_127]])
; CHECK-NEXT:    ret void
; CHECK:       false:
; CHECK-NEXT:    ret void
;
entry:
  br i1 %cond, label %bb1, label %bb2

bb1:
  br label %pred

bb2:
  br label %pred

pred:
  %p = phi i32 [ undef, %bb1 ], [ 10, %bb2 ]
  %bc.1 = icmp ugt i32 %a, %p
  br i1 %bc.1, label %true, label %false

true:
  %f.1 = icmp eq i32 %a, 5
  call void @use(i1 %f.1)

  %t.1 = icmp ne i32 %a,  5
  call void @use(i1 %t.1)

  %a.127 = and i32 %a, 127
  call void @use.i32(i32 %a.127)

  ret void

false:
  ret void
}

; It is not allowed to use the information from %p as a bound, because an
; incoming value is undef.
define void @bound_range_and_undef(i32 %a, i1 %cond) {
; CHECK-LABEL: @bound_range_and_undef(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A_10:%.*]] = and i32 [[A:%.*]], 127
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[PRED:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    br label [[PRED]]
; CHECK:       pred:
; CHECK-NEXT:    [[P:%.*]] = phi i32 [ [[A_10]], [[BB1]] ], [ undef, [[BB2]] ]
; CHECK-NEXT:    [[BC_1:%.*]] = icmp ugt i32 [[A]], [[P]]
; CHECK-NEXT:    br i1 [[BC_1]], label [[TRUE:%.*]], label [[FALSE:%.*]]
; CHECK:       true:
; CHECK-NEXT:    [[F_1:%.*]] = icmp eq i32 [[A]], 300
; CHECK-NEXT:    call void @use(i1 [[F_1]])
; CHECK-NEXT:    [[A_127_2:%.*]] = and i32 [[P]], 127
; CHECK-NEXT:    call void @use.i32(i32 [[A_127_2]])
; CHECK-NEXT:    ret void
; CHECK:       false:
; CHECK-NEXT:    ret void
;
entry:
  %a.10 = and i32 %a, 127
  br i1 %cond, label %bb1, label %bb2

bb1:
  br label %pred

bb2:
  br label %pred

pred:
  %p = phi i32 [ %a.10, %bb1 ], [ undef, %bb2 ]
  %bc.1 = icmp ugt i32 %a, %p
  br i1 %bc.1, label %true, label %false

true:
  %f.1 = icmp eq i32 %a, 300
  call void @use(i1 %f.1)

  %a.127.2 = and i32 %p, 127
  call void @use.i32(i32 %a.127.2)

  ret void

false:
  ret void
}
