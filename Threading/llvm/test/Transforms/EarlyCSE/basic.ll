; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -passes=early-cse -earlycse-debug-hash | FileCheck %s
; RUN: opt < %s -S -passes='early-cse<memssa>' | FileCheck %s
; RUN: opt < %s -S -passes=early-cse | FileCheck %s

declare void @llvm.assume(i1) nounwind

define void @test1(i8 %V, ptr%P) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    store i32 23, ptr [[P:%.*]], align 4
; CHECK-NEXT:    [[C:%.*]] = zext i8 [[V:%.*]] to i32
; CHECK-NEXT:    store volatile i32 [[C]], ptr [[P]], align 4
; CHECK-NEXT:    store volatile i32 [[C]], ptr [[P]], align 4
; CHECK-NEXT:    [[E:%.*]] = add i32 [[C]], [[C]]
; CHECK-NEXT:    store volatile i32 [[E]], ptr [[P]], align 4
; CHECK-NEXT:    store volatile i32 [[E]], ptr [[P]], align 4
; CHECK-NEXT:    store volatile i32 [[E]], ptr [[P]], align 4
; CHECK-NEXT:    ret void
;
  %A = bitcast i64 42 to double  ;; dead
  %B = add i32 4, 19             ;; constant folds
  store i32 %B, ptr %P

  %C = zext i8 %V to i32
  %D = zext i8 %V to i32  ;; CSE
  store volatile i32 %C, ptr %P
  store volatile i32 %D, ptr %P

  %E = add i32 %C, %C
  %F = add i32 %C, %C
  store volatile i32 %E, ptr %P
  store volatile i32 %F, ptr %P

  %G = add nuw i32 %C, %C
  store volatile i32 %G, ptr %P
  ret void
}


;; Simple load value numbering.
define i32 @test2(ptr%P) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[V1:%.*]] = load i32, ptr [[P:%.*]], align 4
; CHECK-NEXT:    ret i32 0
;
  %V1 = load i32, ptr %P
  %V2 = load i32, ptr %P
  %Diff = sub i32 %V1, %V2
  ret i32 %Diff
}

define i32 @test2a(ptr%P, i1 %b) {
; CHECK-LABEL: @test2a(
; CHECK-NEXT:    [[V1:%.*]] = load i32, ptr [[P:%.*]], align 4
; CHECK-NEXT:    tail call void @llvm.assume(i1 [[B:%.*]])
; CHECK-NEXT:    ret i32 0
;
  %V1 = load i32, ptr %P
  tail call void @llvm.assume(i1 %b)
  %V2 = load i32, ptr %P
  %Diff = sub i32 %V1, %V2
  ret i32 %Diff
}

;; Cross block load value numbering.
define i32 @test3(ptr%P, i1 %Cond) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[V1:%.*]] = load i32, ptr [[P:%.*]], align 4
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[T:%.*]], label [[F:%.*]]
; CHECK:       T:
; CHECK-NEXT:    store i32 4, ptr [[P]], align 4
; CHECK-NEXT:    ret i32 42
; CHECK:       F:
; CHECK-NEXT:    ret i32 0
;
  %V1 = load i32, ptr %P
  br i1 %Cond, label %T, label %F
T:
  store i32 4, ptr %P
  ret i32 42
F:
  %V2 = load i32, ptr %P
  %Diff = sub i32 %V1, %V2
  ret i32 %Diff
}

define i32 @test3a(ptr%P, i1 %Cond, i1 %b) {
; CHECK-LABEL: @test3a(
; CHECK-NEXT:    [[V1:%.*]] = load i32, ptr [[P:%.*]], align 4
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[T:%.*]], label [[F:%.*]]
; CHECK:       T:
; CHECK-NEXT:    store i32 4, ptr [[P]], align 4
; CHECK-NEXT:    ret i32 42
; CHECK:       F:
; CHECK-NEXT:    tail call void @llvm.assume(i1 [[B:%.*]])
; CHECK-NEXT:    ret i32 0
;
  %V1 = load i32, ptr %P
  br i1 %Cond, label %T, label %F
T:
  store i32 4, ptr %P
  ret i32 42
F:
  tail call void @llvm.assume(i1 %b)
  %V2 = load i32, ptr %P
  %Diff = sub i32 %V1, %V2
  ret i32 %Diff
}

;; Cross block load value numbering stops when stores happen.
define i32 @test4(ptr%P, i1 %Cond) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[V1:%.*]] = load i32, ptr [[P:%.*]], align 4
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[T:%.*]], label [[F:%.*]]
; CHECK:       T:
; CHECK-NEXT:    ret i32 42
; CHECK:       F:
; CHECK-NEXT:    store i32 42, ptr [[P]], align 4
; CHECK-NEXT:    [[DIFF:%.*]] = sub i32 [[V1]], 42
; CHECK-NEXT:    ret i32 [[DIFF]]
;
  %V1 = load i32, ptr %P
  br i1 %Cond, label %T, label %F
T:
  ret i32 42
F:
  ; Clobbers V1
  store i32 42, ptr %P

  %V2 = load i32, ptr %P
  %Diff = sub i32 %V1, %V2
  ret i32 %Diff
}

declare i32 @func(ptr%P) readonly

;; Simple call CSE'ing.
define i32 @test5(ptr%P) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    [[V1:%.*]] = call i32 @func(ptr [[P:%.*]]), !prof !0
; CHECK-NEXT:    ret i32 0
;
  %V1 = call i32 @func(ptr %P), !prof !0
  %V2 = call i32 @func(ptr %P), !prof !1
  %Diff = sub i32 %V1, %V2
  ret i32 %Diff
}

!0 = !{!"branch_weights", i32 95}
!1 = !{!"branch_weights", i32 95}

;; Trivial Store->load forwarding
define i32 @test6(ptr%P) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    store i32 42, ptr [[P:%.*]], align 4
; CHECK-NEXT:    ret i32 42
;
  store i32 42, ptr %P
  %V1 = load i32, ptr %P
  ret i32 %V1
}

define i32 @test6a(ptr%P, i1 %b) {
; CHECK-LABEL: @test6a(
; CHECK-NEXT:    store i32 42, ptr [[P:%.*]], align 4
; CHECK-NEXT:    tail call void @llvm.assume(i1 [[B:%.*]])
; CHECK-NEXT:    ret i32 42
;
  store i32 42, ptr %P
  tail call void @llvm.assume(i1 %b)
  %V1 = load i32, ptr %P
  ret i32 %V1
}

;; Trivial dead store elimination.
define void @test7(ptr%P) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    store i32 45, ptr [[P:%.*]], align 4
; CHECK-NEXT:    ret void
;
  store i32 42, ptr %P
  store i32 45, ptr %P
  ret void
}

;; Readnone functions aren't invalidated by stores.
define i32 @test8(ptr%P) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    [[V1:%.*]] = call i32 @func(ptr [[P:%.*]]) #[[ATTR2:[0-9]+]]
; CHECK-NEXT:    store i32 4, ptr [[P]], align 4
; CHECK-NEXT:    ret i32 0
;
  %V1 = call i32 @func(ptr %P) readnone
  store i32 4, ptr %P
  %V2 = call i32 @func(ptr %P) readnone
  %Diff = sub i32 %V1, %V2
  ret i32 %Diff
}

;; Trivial DSE can't be performed across a readonly call.  The call
;; can observe the earlier write.
define i32 @test9(ptr%P) {
; CHECK-LABEL: @test9(
; CHECK-NEXT:    store i32 4, ptr [[P:%.*]], align 4
; CHECK-NEXT:    [[V1:%.*]] = call i32 @func(ptr [[P]]) #[[ATTR1:[0-9]+]]
; CHECK-NEXT:    store i32 5, ptr [[P]], align 4
; CHECK-NEXT:    ret i32 [[V1]]
;
  store i32 4, ptr %P
  %V1 = call i32 @func(ptr %P) readonly
  store i32 5, ptr %P
  ret i32 %V1
}

;; Trivial DSE can be performed across a readnone call.
define i32 @test10(ptr%P) {
; CHECK-LABEL: @test10(
; CHECK-NEXT:    [[V1:%.*]] = call i32 @func(ptr [[P:%.*]]) #[[ATTR2]]
; CHECK-NEXT:    store i32 5, ptr [[P]], align 4
; CHECK-NEXT:    ret i32 [[V1]]
;
  store i32 4, ptr %P
  %V1 = call i32 @func(ptr %P) readnone
  store i32 5, ptr %P
  ret i32 %V1
}

;; Trivial dead store elimination - should work for an entire series of dead stores too.
define void @test11(ptr%P) {
; CHECK-LABEL: @test11(
; CHECK-NEXT:    store i32 45, ptr [[P:%.*]], align 4
; CHECK-NEXT:    ret void
;
  store i32 42, ptr %P
  store i32 43, ptr %P
  store i32 44, ptr %P
  store i32 45, ptr %P
  ret void
}

define i32 @test12(i1 %B, ptr %P1, ptr %P2) {
; CHECK-LABEL: @test12(
; CHECK-NEXT:    [[LOAD0:%.*]] = load i32, ptr [[P1:%.*]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = load atomic i32, ptr [[P2:%.*]] seq_cst, align 4
; CHECK-NEXT:    [[LOAD1:%.*]] = load i32, ptr [[P1]], align 4
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[B:%.*]], i32 [[LOAD0]], i32 [[LOAD1]]
; CHECK-NEXT:    ret i32 [[SEL]]
;
  %load0 = load i32, ptr %P1
  %1 = load atomic i32, ptr %P2 seq_cst, align 4
  %load1 = load i32, ptr %P1
  %sel = select i1 %B, i32 %load0, i32 %load1
  ret i32 %sel
}

define void @dse1(ptr%P) {
; CHECK-LABEL: @dse1(
; CHECK-NEXT:    [[V:%.*]] = load i32, ptr [[P:%.*]], align 4
; CHECK-NEXT:    ret void
;
  %v = load i32, ptr %P
  store i32 %v, ptr %P
  ret void
}

define void @dse2(ptr%P) {
; CHECK-LABEL: @dse2(
; CHECK-NEXT:    [[V:%.*]] = load atomic i32, ptr [[P:%.*]] seq_cst, align 4
; CHECK-NEXT:    ret void
;
  %v = load atomic i32, ptr %P seq_cst, align 4
  store i32 %v, ptr %P
  ret void
}

define void @dse3(ptr%P) {
; CHECK-LABEL: @dse3(
; CHECK-NEXT:    [[V:%.*]] = load atomic i32, ptr [[P:%.*]] seq_cst, align 4
; CHECK-NEXT:    ret void
;
  %v = load atomic i32, ptr %P seq_cst, align 4
  store atomic i32 %v, ptr %P unordered, align 4
  ret void
}

define i32 @dse4(ptr%P, ptr%Q) {
; CHECK-LABEL: @dse4(
; CHECK-NEXT:    [[A:%.*]] = load i32, ptr [[Q:%.*]], align 4
; CHECK-NEXT:    [[V:%.*]] = load atomic i32, ptr [[P:%.*]] unordered, align 4
; CHECK-NEXT:    ret i32 0
;
  %a = load i32, ptr %Q
  %v = load atomic i32, ptr %P unordered, align 4
  store atomic i32 %v, ptr %P unordered, align 4
  %b = load i32, ptr %Q
  %res = sub i32 %a, %b
  ret i32 %res
}

; Note that in this example, %P and %Q could in fact be the same
; pointer.  %v could be different than the value observed for %a
; and that's okay because we're using relaxed memory ordering.
; The only guarantee we have to provide is that each of the loads
; has to observe some value written to that location.  We  do
; not have to respect the order in which those writes were done.
define i32 @dse5(ptr%P, ptr%Q) {
; CHECK-LABEL: @dse5(
; CHECK-NEXT:    [[V:%.*]] = load atomic i32, ptr [[P:%.*]] unordered, align 4
; CHECK-NEXT:    [[A:%.*]] = load atomic i32, ptr [[Q:%.*]] unordered, align 4
; CHECK-NEXT:    ret i32 0
;
  %v = load atomic i32, ptr %P unordered, align 4
  %a = load atomic i32, ptr %Q unordered, align 4
  store atomic i32 %v, ptr %P unordered, align 4
  %b = load atomic i32, ptr %Q unordered, align 4
  %res = sub i32 %a, %b
  ret i32 %res
}


define void @dse_neg1(ptr%P) {
; CHECK-LABEL: @dse_neg1(
; CHECK-NEXT:    store i32 5, ptr [[P:%.*]], align 4
; CHECK-NEXT:    ret void
;
  %v = load i32, ptr %P
  store i32 5, ptr %P
  ret void
}

; Could remove the store, but only if ordering was somehow
; encoded.
define void @dse_neg2(ptr%P) {
; CHECK-LABEL: @dse_neg2(
; CHECK-NEXT:    [[V:%.*]] = load i32, ptr [[P:%.*]], align 4
; CHECK-NEXT:    store atomic i32 [[V]], ptr [[P]] seq_cst, align 4
; CHECK-NEXT:    ret void
;
  %v = load i32, ptr %P
  store atomic i32 %v, ptr %P seq_cst, align 4
  ret void
}

@c = external global i32, align 4
declare i32 @reads_c(i32 returned)
define void @pr28763() {
; CHECK-LABEL: @pr28763(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i32 0, ptr @c, align 4
; CHECK-NEXT:    [[CALL:%.*]] = call i32 @reads_c(i32 0)
; CHECK-NEXT:    store i32 2, ptr @c, align 4
; CHECK-NEXT:    ret void
;
entry:
  %load = load i32, ptr @c, align 4
  store i32 0, ptr @c, align 4
  %call = call i32 @reads_c(i32 0)
  store i32 2, ptr @c, align 4
  ret void
}

define i1 @cse_freeze(i1 %a) {
; CHECK-LABEL: @cse_freeze(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[B:%.*]] = freeze i1 [[A:%.*]]
; CHECK-NEXT:    ret i1 [[B]]
;
entry:
  %b = freeze i1 %a
  %c = freeze i1 %a
  %and = and i1 %b, %c
  ret i1 %and
}
