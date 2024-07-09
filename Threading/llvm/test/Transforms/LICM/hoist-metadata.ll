; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --check-globals --version 2
; RUN: opt -S -passes=licm < %s| FileCheck %s

declare void @foo(...) memory(none)

; We can preserve all metadata on instructions that are guaranteed to execute.
define void @test_unconditional(i1 %c, ptr dereferenceable(8) align 8 %p) {
; CHECK-LABEL: define void @test_unconditional
; CHECK-SAME: (i1 [[C:%.*]], ptr align 8 dereferenceable(8) [[P:%.*]]) {
; CHECK-NEXT:    [[V1:%.*]] = load i32, ptr [[P]], align 4, !range [[RNG0:![0-9]+]]
; CHECK-NEXT:    [[V2:%.*]] = load ptr, ptr [[P]], align 8, !nonnull !1, !noundef !1
; CHECK-NEXT:    [[V3:%.*]] = load ptr, ptr [[P]], align 8, !dereferenceable !2, !align !2
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    call void @foo(i32 [[V1]], ptr [[V2]], ptr [[V3]])
; CHECK-NEXT:    br i1 [[C]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
  br label %loop

loop:
  %v1 = load i32, ptr %p, !range !{i32 0, i32 10}
  %v2 = load ptr, ptr %p, !nonnull !{}, !noundef !{}
  %v3 = load ptr, ptr %p, !align !{i64 4}, !dereferenceable !{i64 4}
  call void @foo(i32 %v1, ptr %v2, ptr %v3)
  br i1 %c, label %loop, label %exit

exit:
  ret void
}

; We cannot preserve UB-implying metadata on instructions that are speculated.
; However, we can preserve poison-implying metadata.
define void @test_conditional(i1 %c, i1 %c2, ptr dereferenceable(8) align 8 %p) {
; CHECK-LABEL: define void @test_conditional
; CHECK-SAME: (i1 [[C:%.*]], i1 [[C2:%.*]], ptr align 8 dereferenceable(8) [[P:%.*]]) {
; CHECK-NEXT:    [[V1:%.*]] = load i32, ptr [[P]], align 4, !range [[RNG0]]
; CHECK-NEXT:    [[V2:%.*]] = load ptr, ptr [[P]], align 8, !nonnull !1
; CHECK-NEXT:    [[V3:%.*]] = load ptr, ptr [[P]], align 8, !align !2
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    br i1 [[C]], label [[IF:%.*]], label [[LATCH:%.*]]
; CHECK:       if:
; CHECK-NEXT:    call void @foo(i32 [[V1]], ptr [[V2]], ptr [[V3]])
; CHECK-NEXT:    br label [[LATCH]]
; CHECK:       latch:
; CHECK-NEXT:    br i1 [[C2]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
  br label %loop

loop:
  br i1 %c, label %if, label %latch

if:
  %v1 = load i32, ptr %p, !range !{i32 0, i32 10}
  %v2 = load ptr, ptr %p, !nonnull !{}, !noundef !{}
  %v3 = load ptr, ptr %p, !align !{i64 4}, !dereferenceable !{i64 4}
  call void @foo(i32 %v1, ptr %v2, ptr %v3)
  br label %latch

latch:
  br i1 %c2, label %loop, label %exit

exit:
  ret void
}
;.
; CHECK: attributes #[[ATTR0:[0-9]+]] = { memory(none) }
;.
; CHECK: [[RNG0]] = !{i32 0, i32 10}
; CHECK: [[META1:![0-9]+]] = !{}
; CHECK: [[META2:![0-9]+]] = !{i64 4}
;.
