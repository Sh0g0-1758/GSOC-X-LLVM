; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instsimplify -S | FileCheck %s

define i8 @noundef(i8 noundef %x) {
; CHECK-LABEL: @noundef(
; CHECK-NEXT:    ret i8 [[X:%.*]]
;
  %y = freeze i8 %x
  ret i8 %y
}

define i1 @icmp(i8 noundef %x, i8 noundef %y) {
; CHECK-LABEL: @icmp(
; CHECK-NEXT:    [[C:%.*]] = icmp eq i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[C]]
;
  %c = icmp eq i8 %x, %y
  %f = freeze i1 %c
  ret i1 %f
}

define i1 @or(i1 noundef %x, i1 noundef %x2) {
; CHECK-LABEL: @or(
; CHECK-NEXT:    [[Y:%.*]] = or i1 [[X:%.*]], [[X2:%.*]]
; CHECK-NEXT:    ret i1 [[Y]]
;
  %y = or i1 %x, %x2
  %z = freeze i1 %y
  ret i1 %z
}

define i1 @or_disjoint(i1 noundef %x, i1 noundef %x2) {
; CHECK-LABEL: @or_disjoint(
; CHECK-NEXT:    [[Y:%.*]] = or disjoint i1 [[X:%.*]], [[X2:%.*]]
; CHECK-NEXT:    [[Z:%.*]] = freeze i1 [[Y]]
; CHECK-NEXT:    ret i1 [[Z]]
;
  %y = or disjoint i1 %x, %x2
  %z = freeze i1 %y
  ret i1 %z
}

define i1 @or2(i1 noundef %x, i1 %x2) {
; CHECK-LABEL: @or2(
; CHECK-NEXT:    [[Y:%.*]] = or i1 [[X:%.*]], [[X2:%.*]]
; CHECK-NEXT:    [[Z:%.*]] = freeze i1 [[Y]]
; CHECK-NEXT:    ret i1 [[Z]]
;
  %y = or i1 %x, %x2
  %z = freeze i1 %y
  ret i1 %z
}

define i8 @add(i8 noundef %x) {
; CHECK-LABEL: @add(
; CHECK-NEXT:    [[Y:%.*]] = add i8 [[X:%.*]], 1
; CHECK-NEXT:    ret i8 [[Y]]
;
  %y = add i8 %x, 1
  %z = freeze i8 %y
  ret i8 %z
}

define i8 @addnsw(i8 noundef %x) {
; CHECK-LABEL: @addnsw(
; CHECK-NEXT:    [[Y:%.*]] = add nsw i8 [[X:%.*]], 1
; CHECK-NEXT:    [[Z:%.*]] = freeze i8 [[Y]]
; CHECK-NEXT:    ret i8 [[Z]]
;
  %y = add nsw i8 %x, 1
  %z = freeze i8 %y
  ret i8 %z
}

define i16 @zext(i8 noundef %x) {
; CHECK-LABEL: @zext(
; CHECK-NEXT:    [[Y:%.*]] = zext i8 [[X:%.*]] to i16
; CHECK-NEXT:    ret i16 [[Y]]
;
  %y = zext i8 %x to i16
  %z = freeze i16 %y
  ret i16 %z
}

define i16 @zext_nneg(i8 noundef %x) {
; CHECK-LABEL: @zext_nneg(
; CHECK-NEXT:    [[Y:%.*]] = zext nneg i8 [[X:%.*]] to i16
; CHECK-NEXT:    [[Z:%.*]] = freeze i16 [[Y]]
; CHECK-NEXT:    ret i16 [[Z]]
;
  %y = zext nneg i8 %x to i16
  %z = freeze i16 %y
  ret i16 %z
}

define {i8, i32} @aggr({i8, i32} noundef %x) {
; CHECK-LABEL: @aggr(
; CHECK-NEXT:    ret { i8, i32 } [[X:%.*]]
;
  %y = freeze {i8, i32} %x
  ret {i8, i32} %y
}

define i32 @extract({i8, i32} noundef %x) {
; CHECK-LABEL: @extract(
; CHECK-NEXT:    [[Y:%.*]] = extractvalue { i8, i32 } [[X:%.*]], 1
; CHECK-NEXT:    ret i32 [[Y]]
;
  %y = extractvalue {i8, i32} %x, 1
  %z = freeze i32 %y
  ret i32 %z
}

define i32 @extract2({i8, {i8, i32}} noundef %x) {
; CHECK-LABEL: @extract2(
; CHECK-NEXT:    [[Y:%.*]] = extractvalue { i8, { i8, i32 } } [[X:%.*]], 1
; CHECK-NEXT:    [[Z:%.*]] = extractvalue { i8, i32 } [[Y]], 1
; CHECK-NEXT:    ret i32 [[Z]]
;
  %y = extractvalue {i8, {i8, i32}} %x, 1
  %z = extractvalue {i8, i32} %y, 1
  %w = freeze i32 %z
  ret i32 %w
}

declare void @use_i1(i1 noundef)

define i1 @used_by_fncall(i1 %x) {
; CHECK-LABEL: @used_by_fncall(
; CHECK-NEXT:    [[Y:%.*]] = add nsw i1 [[X:%.*]], true
; CHECK-NEXT:    call void @use_i1(i1 [[Y]])
; CHECK-NEXT:    ret i1 [[Y]]
;
  %y = add nsw i1 %x, 1
  call void @use_i1(i1 %y)
  %f = freeze i1 %y
  ret i1 %f
}

define i32 @noundef_metadata(ptr %p) {
; CHECK-LABEL: @noundef_metadata(
; CHECK-NEXT:    [[V:%.*]] = load i32, ptr [[P:%.*]], align 4, !noundef [[META0:![0-9]+]]
; CHECK-NEXT:    ret i32 [[V]]
;
  %v = load i32, ptr %p, !noundef !{}
  %v.fr = freeze i32 %v
  ret i32 %v.fr
}

define {i8, i32} @noundef_metadata2(ptr %p) {
; CHECK-LABEL: @noundef_metadata2(
; CHECK-NEXT:    [[V:%.*]] = load { i8, i32 }, ptr [[P:%.*]], align 4, !noundef [[META0]]
; CHECK-NEXT:    ret { i8, i32 } [[V]]
;
  %v = load {i8, i32}, ptr %p, !noundef !{}
  %v.fr = freeze {i8, i32} %v
  ret {i8, i32} %v.fr
}
