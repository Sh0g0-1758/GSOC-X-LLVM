; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=slp-vectorizer -mtriple=riscv64 -mattr=+v \
; RUN: -riscv-v-vector-bits-min=-1 -riscv-v-slp-max-vf=0 -S | FileCheck %s --check-prefixes=CHECK
; RUN: opt < %s -passes=slp-vectorizer -mtriple=riscv64 -mattr=+v -S | FileCheck %s --check-prefixes=DEFAULT

define void @vec_add(ptr %dest, ptr %p) {
; CHECK-LABEL: @vec_add(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <2 x i16>, ptr [[P:%.*]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = add <2 x i16> [[TMP0]], <i16 1, i16 1>
; CHECK-NEXT:    store <2 x i16> [[TMP1]], ptr [[DEST:%.*]], align 4
; CHECK-NEXT:    ret void
;
; DEFAULT-LABEL: @vec_add(
; DEFAULT-NEXT:  entry:
; DEFAULT-NEXT:    [[TMP0:%.*]] = load <2 x i16>, ptr [[P:%.*]], align 4
; DEFAULT-NEXT:    [[TMP1:%.*]] = add <2 x i16> [[TMP0]], <i16 1, i16 1>
; DEFAULT-NEXT:    store <2 x i16> [[TMP1]], ptr [[DEST:%.*]], align 4
; DEFAULT-NEXT:    ret void
;
entry:
  %e0 = load i16, ptr %p, align 4
  %inc = getelementptr inbounds i16, ptr %p, i64 1
  %e1 = load i16, ptr %inc, align 2

  %a0 = add i16 %e0, 1
  %a1 = add i16 %e1, 1

  store i16 %a0, ptr %dest, align 4
  %inc2 = getelementptr inbounds i16, ptr %dest, i64 1
  store i16 %a1, ptr %inc2, align 2
  ret void
}

define void @vec_sub(ptr %dest, ptr %p) {
; CHECK-LABEL: @vec_sub(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <2 x i16>, ptr [[P:%.*]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = sub <2 x i16> [[TMP0]], <i16 17, i16 17>
; CHECK-NEXT:    store <2 x i16> [[TMP1]], ptr [[DEST:%.*]], align 4
; CHECK-NEXT:    ret void
;
; DEFAULT-LABEL: @vec_sub(
; DEFAULT-NEXT:  entry:
; DEFAULT-NEXT:    [[TMP0:%.*]] = load <2 x i16>, ptr [[P:%.*]], align 4
; DEFAULT-NEXT:    [[TMP1:%.*]] = sub <2 x i16> [[TMP0]], <i16 17, i16 17>
; DEFAULT-NEXT:    store <2 x i16> [[TMP1]], ptr [[DEST:%.*]], align 4
; DEFAULT-NEXT:    ret void
;
entry:
  %e0 = load i16, ptr %p, align 4
  %inc = getelementptr inbounds i16, ptr %p, i64 1
  %e1 = load i16, ptr %inc, align 2

  %a0 = sub i16 %e0, 17
  %a1 = sub i16 %e1, 17

  store i16 %a0, ptr %dest, align 4
  %inc2 = getelementptr inbounds i16, ptr %dest, i64 1
  store i16 %a1, ptr %inc2, align 2
  ret void
}

define void @vec_rsub(ptr %dest, ptr %p) {
; CHECK-LABEL: @vec_rsub(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <2 x i16>, ptr [[P:%.*]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = sub <2 x i16> <i16 29, i16 29>, [[TMP0]]
; CHECK-NEXT:    store <2 x i16> [[TMP1]], ptr [[DEST:%.*]], align 4
; CHECK-NEXT:    ret void
;
; DEFAULT-LABEL: @vec_rsub(
; DEFAULT-NEXT:  entry:
; DEFAULT-NEXT:    [[TMP0:%.*]] = load <2 x i16>, ptr [[P:%.*]], align 4
; DEFAULT-NEXT:    [[TMP1:%.*]] = sub <2 x i16> <i16 29, i16 29>, [[TMP0]]
; DEFAULT-NEXT:    store <2 x i16> [[TMP1]], ptr [[DEST:%.*]], align 4
; DEFAULT-NEXT:    ret void
;
entry:
  %e0 = load i16, ptr %p, align 4
  %inc = getelementptr inbounds i16, ptr %p, i64 1
  %e1 = load i16, ptr %inc, align 2

  %a0 = sub i16 29, %e0
  %a1 = sub i16 29, %e1

  store i16 %a0, ptr %dest, align 4
  %inc2 = getelementptr inbounds i16, ptr %dest, i64 1
  store i16 %a1, ptr %inc2, align 2
  ret void
}

define void @vec_mul(ptr %dest, ptr %p) {
; CHECK-LABEL: @vec_mul(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <2 x i16>, ptr [[P:%.*]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = mul <2 x i16> [[TMP0]], <i16 7, i16 7>
; CHECK-NEXT:    store <2 x i16> [[TMP1]], ptr [[DEST:%.*]], align 4
; CHECK-NEXT:    ret void
;
; DEFAULT-LABEL: @vec_mul(
; DEFAULT-NEXT:  entry:
; DEFAULT-NEXT:    [[TMP0:%.*]] = load <2 x i16>, ptr [[P:%.*]], align 4
; DEFAULT-NEXT:    [[TMP1:%.*]] = mul <2 x i16> [[TMP0]], <i16 7, i16 7>
; DEFAULT-NEXT:    store <2 x i16> [[TMP1]], ptr [[DEST:%.*]], align 4
; DEFAULT-NEXT:    ret void
;
entry:
  %e0 = load i16, ptr %p, align 4
  %inc = getelementptr inbounds i16, ptr %p, i64 1
  %e1 = load i16, ptr %inc, align 2

  %a0 = mul i16 %e0, 7
  %a1 = mul i16 %e1, 7

  store i16 %a0, ptr %dest, align 4
  %inc2 = getelementptr inbounds i16, ptr %dest, i64 1
  store i16 %a1, ptr %inc2, align 2
  ret void
}

define void @vec_sdiv(ptr %dest, ptr %p) {
; CHECK-LABEL: @vec_sdiv(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <2 x i16>, ptr [[P:%.*]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = sdiv <2 x i16> [[TMP0]], <i16 7, i16 7>
; CHECK-NEXT:    store <2 x i16> [[TMP1]], ptr [[DEST:%.*]], align 4
; CHECK-NEXT:    ret void
;
; DEFAULT-LABEL: @vec_sdiv(
; DEFAULT-NEXT:  entry:
; DEFAULT-NEXT:    [[TMP0:%.*]] = load <2 x i16>, ptr [[P:%.*]], align 4
; DEFAULT-NEXT:    [[TMP1:%.*]] = sdiv <2 x i16> [[TMP0]], <i16 7, i16 7>
; DEFAULT-NEXT:    store <2 x i16> [[TMP1]], ptr [[DEST:%.*]], align 4
; DEFAULT-NEXT:    ret void
;
entry:
  %e0 = load i16, ptr %p, align 4
  %inc = getelementptr inbounds i16, ptr %p, i64 1
  %e1 = load i16, ptr %inc, align 2

  %a0 = sdiv i16 %e0, 7
  %a1 = sdiv i16 %e1, 7

  store i16 %a0, ptr %dest, align 4
  %inc2 = getelementptr inbounds i16, ptr %dest, i64 1
  store i16 %a1, ptr %inc2, align 2
  ret void
}

define void @vec_and(ptr %dest, ptr %p, ptr %q) {
; CHECK-LABEL: @vec_and(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <2 x i16>, ptr [[P:%.*]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = load <2 x i16>, ptr [[Q:%.*]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = and <2 x i16> [[TMP0]], [[TMP1]]
; CHECK-NEXT:    store <2 x i16> [[TMP2]], ptr [[DEST:%.*]], align 4
; CHECK-NEXT:    ret void
;
; DEFAULT-LABEL: @vec_and(
; DEFAULT-NEXT:  entry:
; DEFAULT-NEXT:    [[TMP0:%.*]] = load <2 x i16>, ptr [[P:%.*]], align 4
; DEFAULT-NEXT:    [[TMP1:%.*]] = load <2 x i16>, ptr [[Q:%.*]], align 4
; DEFAULT-NEXT:    [[TMP2:%.*]] = and <2 x i16> [[TMP0]], [[TMP1]]
; DEFAULT-NEXT:    store <2 x i16> [[TMP2]], ptr [[DEST:%.*]], align 4
; DEFAULT-NEXT:    ret void
;
entry:
  %e0 = load i16, ptr %p, align 4
  %inc = getelementptr inbounds i16, ptr %p, i64 1
  %e1 = load i16, ptr %inc, align 2

  %f0 = load i16, ptr %q, align 4
  %inq = getelementptr inbounds i16, ptr %q, i64 1
  %f1 = load i16, ptr %inq, align 2

  %a0 = and i16 %e0, %f0
  %a1 = and i16 %e1, %f1

  store i16 %a0, ptr %dest, align 4
  %inc2 = getelementptr inbounds i16, ptr %dest, i64 1
  store i16 %a1, ptr %inc2, align 2
  ret void
}

define void @vec_or(ptr %dest, ptr %p, ptr %q) {
; CHECK-LABEL: @vec_or(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <2 x i16>, ptr [[P:%.*]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = load <2 x i16>, ptr [[Q:%.*]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = or <2 x i16> [[TMP0]], [[TMP1]]
; CHECK-NEXT:    store <2 x i16> [[TMP2]], ptr [[DEST:%.*]], align 4
; CHECK-NEXT:    ret void
;
; DEFAULT-LABEL: @vec_or(
; DEFAULT-NEXT:  entry:
; DEFAULT-NEXT:    [[TMP0:%.*]] = load <2 x i16>, ptr [[P:%.*]], align 4
; DEFAULT-NEXT:    [[TMP1:%.*]] = load <2 x i16>, ptr [[Q:%.*]], align 4
; DEFAULT-NEXT:    [[TMP2:%.*]] = or <2 x i16> [[TMP0]], [[TMP1]]
; DEFAULT-NEXT:    store <2 x i16> [[TMP2]], ptr [[DEST:%.*]], align 4
; DEFAULT-NEXT:    ret void
;
entry:
  %e0 = load i16, ptr %p, align 4
  %inc = getelementptr inbounds i16, ptr %p, i64 1
  %e1 = load i16, ptr %inc, align 2

  %f0 = load i16, ptr %q, align 4
  %inq = getelementptr inbounds i16, ptr %q, i64 1
  %f1 = load i16, ptr %inq, align 2

  %a0 = or i16 %e0, %f0
  %a1 = or i16 %e1, %f1

  store i16 %a0, ptr %dest, align 4
  %inc2 = getelementptr inbounds i16, ptr %dest, i64 1
  store i16 %a1, ptr %inc2, align 2
  ret void
}

define void @vec_sll(ptr %dest, ptr %p, ptr %q) {
; CHECK-LABEL: @vec_sll(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <2 x i16>, ptr [[P:%.*]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = load <2 x i16>, ptr [[Q:%.*]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = shl <2 x i16> [[TMP0]], [[TMP1]]
; CHECK-NEXT:    store <2 x i16> [[TMP2]], ptr [[DEST:%.*]], align 4
; CHECK-NEXT:    ret void
;
; DEFAULT-LABEL: @vec_sll(
; DEFAULT-NEXT:  entry:
; DEFAULT-NEXT:    [[TMP0:%.*]] = load <2 x i16>, ptr [[P:%.*]], align 4
; DEFAULT-NEXT:    [[TMP1:%.*]] = load <2 x i16>, ptr [[Q:%.*]], align 4
; DEFAULT-NEXT:    [[TMP2:%.*]] = shl <2 x i16> [[TMP0]], [[TMP1]]
; DEFAULT-NEXT:    store <2 x i16> [[TMP2]], ptr [[DEST:%.*]], align 4
; DEFAULT-NEXT:    ret void
;
entry:
  %e0 = load i16, ptr %p, align 4
  %inc = getelementptr inbounds i16, ptr %p, i64 1
  %e1 = load i16, ptr %inc, align 2

  %f0 = load i16, ptr %q, align 4
  %inq = getelementptr inbounds i16, ptr %q, i64 1
  %f1 = load i16, ptr %inq, align 2

  %a0 = shl i16 %e0, %f0
  %a1 = shl i16 %e1, %f1

  store i16 %a0, ptr %dest, align 4
  %inc2 = getelementptr inbounds i16, ptr %dest, i64 1
  store i16 %a1, ptr %inc2, align 2
  ret void
}

declare i16 @llvm.smin.i16(i16, i16)
define void @vec_smin(ptr %dest, ptr %p, ptr %q) {
; CHECK-LABEL: @vec_smin(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <2 x i16>, ptr [[P:%.*]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = load <2 x i16>, ptr [[Q:%.*]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = call <2 x i16> @llvm.smin.v2i16(<2 x i16> [[TMP0]], <2 x i16> [[TMP1]])
; CHECK-NEXT:    store <2 x i16> [[TMP2]], ptr [[DEST:%.*]], align 4
; CHECK-NEXT:    ret void
;
; DEFAULT-LABEL: @vec_smin(
; DEFAULT-NEXT:  entry:
; DEFAULT-NEXT:    [[TMP0:%.*]] = load <2 x i16>, ptr [[P:%.*]], align 4
; DEFAULT-NEXT:    [[TMP1:%.*]] = load <2 x i16>, ptr [[Q:%.*]], align 4
; DEFAULT-NEXT:    [[TMP2:%.*]] = call <2 x i16> @llvm.smin.v2i16(<2 x i16> [[TMP0]], <2 x i16> [[TMP1]])
; DEFAULT-NEXT:    store <2 x i16> [[TMP2]], ptr [[DEST:%.*]], align 4
; DEFAULT-NEXT:    ret void
;
entry:
  %e0 = load i16, ptr %p, align 4
  %inc = getelementptr inbounds i16, ptr %p, i64 1
  %e1 = load i16, ptr %inc, align 2

  %f0 = load i16, ptr %q, align 4
  %inq = getelementptr inbounds i16, ptr %q, i64 1
  %f1 = load i16, ptr %inq, align 2

  %a0 = tail call i16 @llvm.smin.i16(i16 %e0, i16 %f0)
  %a1 = tail call i16 @llvm.smin.i16(i16 %e1, i16 %f1)

  store i16 %a0, ptr %dest, align 4
  %inc2 = getelementptr inbounds i16, ptr %dest, i64 1
  store i16 %a1, ptr %inc2, align 2
  ret void
}

declare i16 @llvm.umax.i16(i16, i16)
define void @vec_umax(ptr %dest, ptr %p, ptr %q) {
; CHECK-LABEL: @vec_umax(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <2 x i16>, ptr [[P:%.*]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = load <2 x i16>, ptr [[Q:%.*]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = call <2 x i16> @llvm.umax.v2i16(<2 x i16> [[TMP0]], <2 x i16> [[TMP1]])
; CHECK-NEXT:    store <2 x i16> [[TMP2]], ptr [[DEST:%.*]], align 4
; CHECK-NEXT:    ret void
;
; DEFAULT-LABEL: @vec_umax(
; DEFAULT-NEXT:  entry:
; DEFAULT-NEXT:    [[TMP0:%.*]] = load <2 x i16>, ptr [[P:%.*]], align 4
; DEFAULT-NEXT:    [[TMP1:%.*]] = load <2 x i16>, ptr [[Q:%.*]], align 4
; DEFAULT-NEXT:    [[TMP2:%.*]] = call <2 x i16> @llvm.umax.v2i16(<2 x i16> [[TMP0]], <2 x i16> [[TMP1]])
; DEFAULT-NEXT:    store <2 x i16> [[TMP2]], ptr [[DEST:%.*]], align 4
; DEFAULT-NEXT:    ret void
;
entry:
  %e0 = load i16, ptr %p, align 4
  %inc = getelementptr inbounds i16, ptr %p, i64 1
  %e1 = load i16, ptr %inc, align 2

  %f0 = load i16, ptr %q, align 4
  %inq = getelementptr inbounds i16, ptr %q, i64 1
  %f1 = load i16, ptr %inq, align 2

  %a0 = tail call i16 @llvm.umax.i16(i16 %e0, i16 %f0)
  %a1 = tail call i16 @llvm.umax.i16(i16 %e1, i16 %f1)

  store i16 %a0, ptr %dest, align 4
  %inc2 = getelementptr inbounds i16, ptr %dest, i64 1
  store i16 %a1, ptr %inc2, align 2
  ret void
}
