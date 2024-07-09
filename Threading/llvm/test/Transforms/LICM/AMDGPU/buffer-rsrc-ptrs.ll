; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 2
; RUN: opt < %s -aa-pipeline=basic-aa,scoped-noalias-aa -passes=licm -S | FileCheck %s

target triple = "amdgcn-amd-amdhsa"

define void @hoistable_noalias(ptr addrspace(8) noalias %p, ptr addrspace(8) noalias %q, i32 %bound) {
; CHECK-LABEL: define void @hoistable_noalias
; CHECK-SAME: (ptr addrspace(8) noalias [[P:%.*]], ptr addrspace(8) noalias [[Q:%.*]], i32 [[BOUND:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[HOISTABLE:%.*]] = call i32 @llvm.amdgcn.struct.ptr.buffer.load.i32(ptr addrspace(8) [[Q]], i32 0, i32 0, i32 0, i32 0)
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[I:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[ORIG:%.*]] = call i32 @llvm.amdgcn.raw.ptr.buffer.load.i32(ptr addrspace(8) [[P]], i32 [[I]], i32 0, i32 0)
; CHECK-NEXT:    [[INC:%.*]] = add i32 [[HOISTABLE]], [[ORIG]]
; CHECK-NEXT:    call void @llvm.amdgcn.raw.ptr.buffer.store.i32(i32 [[INC]], ptr addrspace(8) [[P]], i32 [[I]], i32 0, i32 0)
; CHECK-NEXT:    [[NEXT]] = add i32 [[I]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp ult i32 [[NEXT]], [[BOUND]]
; CHECK-NEXT:    br i1 [[COND]], label [[LOOP]], label [[TAIL:%.*]]
; CHECK:       tail:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop
loop:
  %i = phi i32 [0, %entry], [%next, %loop]

  %hoistable = call i32 @llvm.amdgcn.struct.ptr.buffer.load.i32(ptr addrspace(8) %q, i32 0, i32 0, i32 0, i32 0)
  %orig = call i32 @llvm.amdgcn.raw.ptr.buffer.load.i32(ptr addrspace(8) %p, i32 %i, i32 0, i32 0)
  %inc = add i32 %hoistable, %orig
  call void @llvm.amdgcn.raw.ptr.buffer.store.i32(i32 %inc, ptr addrspace(8) %p, i32 %i, i32 0, i32 0)

  %next = add i32 %i, 1
  %cond = icmp ult i32 %next, %bound
  br i1 %cond, label %loop, label %tail
tail:
  ret void
}

define void @not_hoistable_may_alias(ptr addrspace(8) %p, ptr addrspace(8) %q, i32 %bound) {
; CHECK-LABEL: define void @not_hoistable_may_alias
; CHECK-SAME: (ptr addrspace(8) [[P:%.*]], ptr addrspace(8) [[Q:%.*]], i32 [[BOUND:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[I:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[NOT_HOISTABLE:%.*]] = call i32 @llvm.amdgcn.struct.ptr.buffer.load.i32(ptr addrspace(8) [[Q]], i32 0, i32 0, i32 0, i32 0)
; CHECK-NEXT:    [[ORIG:%.*]] = call i32 @llvm.amdgcn.raw.ptr.buffer.load.i32(ptr addrspace(8) [[P]], i32 [[I]], i32 0, i32 0)
; CHECK-NEXT:    [[INC:%.*]] = add i32 [[NOT_HOISTABLE]], [[ORIG]]
; CHECK-NEXT:    call void @llvm.amdgcn.raw.ptr.buffer.store.i32(i32 [[INC]], ptr addrspace(8) [[P]], i32 [[I]], i32 0, i32 0)
; CHECK-NEXT:    [[NEXT]] = add i32 [[I]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp ult i32 [[NEXT]], [[BOUND]]
; CHECK-NEXT:    br i1 [[COND]], label [[LOOP]], label [[TAIL:%.*]]
; CHECK:       tail:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop
loop:
  %i = phi i32 [0, %entry], [%next, %loop]

  %not.hoistable = call i32 @llvm.amdgcn.struct.ptr.buffer.load.i32(ptr addrspace(8) %q, i32 0, i32 0, i32 0, i32 0)
  %orig = call i32 @llvm.amdgcn.raw.ptr.buffer.load.i32(ptr addrspace(8) %p, i32 %i, i32 0, i32 0)
  %inc = add i32 %not.hoistable, %orig
  call void @llvm.amdgcn.raw.ptr.buffer.store.i32(i32 %inc, ptr addrspace(8) %p, i32 %i, i32 0, i32 0)

  %next = add i32 %i, 1
  %cond = icmp ult i32 %next, %bound
  br i1 %cond, label %loop, label %tail
tail:
  ret void
}

define void @hoistable_alias_scope(ptr addrspace(8) %p, ptr addrspace(8) %q, i32 %bound) {
; CHECK-LABEL: define void @hoistable_alias_scope
; CHECK-SAME: (ptr addrspace(8) [[P:%.*]], ptr addrspace(8) [[Q:%.*]], i32 [[BOUND:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[HOISTABLE:%.*]] = call i32 @llvm.amdgcn.struct.ptr.buffer.load.i32(ptr addrspace(8) [[Q]], i32 0, i32 0, i32 0, i32 0), !alias.scope !0, !noalias !3
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[I:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[ORIG:%.*]] = call i32 @llvm.amdgcn.raw.ptr.buffer.load.i32(ptr addrspace(8) [[P]], i32 [[I]], i32 0, i32 0), !alias.scope !3, !noalias !0
; CHECK-NEXT:    [[INC:%.*]] = add i32 [[HOISTABLE]], [[ORIG]]
; CHECK-NEXT:    call void @llvm.amdgcn.raw.ptr.buffer.store.i32(i32 [[INC]], ptr addrspace(8) [[P]], i32 [[I]], i32 0, i32 0), !alias.scope !3, !noalias !0
; CHECK-NEXT:    [[NEXT]] = add i32 [[I]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp ult i32 [[NEXT]], [[BOUND]]
; CHECK-NEXT:    br i1 [[COND]], label [[LOOP]], label [[TAIL:%.*]]
; CHECK:       tail:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop
loop:
  %i = phi i32 [0, %entry], [%next, %loop]

  %hoistable = call i32 @llvm.amdgcn.struct.ptr.buffer.load.i32(ptr addrspace(8) %q, i32 0, i32 0, i32 0, i32 0), !alias.scope !4, !noalias !3
  %orig = call i32 @llvm.amdgcn.raw.ptr.buffer.load.i32(ptr addrspace(8) %p, i32 %i, i32 0, i32 0), !alias.scope !3, !noalias !4
  %inc = add i32 %hoistable, %orig
  call void @llvm.amdgcn.raw.ptr.buffer.store.i32(i32 %inc, ptr addrspace(8) %p, i32 %i, i32 0, i32 0), !alias.scope !3, !noalias !4

  %next = add i32 %i, 1
  %cond = icmp ult i32 %next, %bound
  br i1 %cond, label %loop, label %tail
tail:
  ret void
}
!0 = !{!0, !"hoisting"}
!1 = !{!1, !0, !"p"}
!2 = !{!2, !0, !"q"}

!3 = !{!1}
!4 = !{!2}

define void @not_hoistable_buffer_construction(ptr addrspace(1) noalias %p.global, ptr addrspace(1) noalias %q.global, i32 %bound) {
; CHECK-LABEL: define void @not_hoistable_buffer_construction
; CHECK-SAME: (ptr addrspace(1) noalias [[P_GLOBAL:%.*]], ptr addrspace(1) noalias [[Q_GLOBAL:%.*]], i32 [[BOUND:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[P_GLOBAL_INT:%.*]] = ptrtoint ptr addrspace(1) [[P_GLOBAL]] to i64
; CHECK-NEXT:    [[Q_GLOBAL_INT:%.*]] = ptrtoint ptr addrspace(1) [[Q_GLOBAL]] to i64
; CHECK-NEXT:    [[P_TRUNC:%.*]] = trunc i64 [[P_GLOBAL_INT]] to i48
; CHECK-NEXT:    [[Q_TRUNC:%.*]] = trunc i64 [[Q_GLOBAL_INT]] to i48
; CHECK-NEXT:    [[P_EXT:%.*]] = zext i48 [[P_TRUNC]] to i128
; CHECK-NEXT:    [[Q_EXT:%.*]] = zext i48 [[Q_TRUNC]] to i128
; CHECK-NEXT:    [[P:%.*]] = inttoptr i128 [[P_EXT]] to ptr addrspace(8)
; CHECK-NEXT:    [[Q:%.*]] = inttoptr i128 [[Q_EXT]] to ptr addrspace(8)
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[I:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[NOT_HOISTABLE:%.*]] = call i32 @llvm.amdgcn.struct.ptr.buffer.load.i32(ptr addrspace(8) [[Q]], i32 0, i32 0, i32 0, i32 0)
; CHECK-NEXT:    [[ORIG:%.*]] = call i32 @llvm.amdgcn.raw.ptr.buffer.load.i32(ptr addrspace(8) [[P]], i32 [[I]], i32 0, i32 0)
; CHECK-NEXT:    [[INC:%.*]] = add i32 [[NOT_HOISTABLE]], [[ORIG]]
; CHECK-NEXT:    call void @llvm.amdgcn.raw.ptr.buffer.store.i32(i32 [[INC]], ptr addrspace(8) [[P]], i32 [[I]], i32 0, i32 0)
; CHECK-NEXT:    [[NEXT]] = add i32 [[I]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp ult i32 [[NEXT]], [[BOUND]]
; CHECK-NEXT:    br i1 [[COND]], label [[LOOP]], label [[TAIL:%.*]]
; CHECK:       tail:
; CHECK-NEXT:    ret void
;
entry:
  %p.global.int = ptrtoint ptr addrspace(1) %p.global to i64
  %q.global.int = ptrtoint ptr addrspace(1) %q.global to i64
  %p.trunc = trunc i64 %p.global.int to i48
  %q.trunc = trunc i64 %q.global.int to i48
  %p.ext = zext i48 %p.trunc to i128
  %q.ext = zext i48 %q.trunc to i128
  %p = inttoptr i128 %p.ext to ptr addrspace(8)
  %q = inttoptr i128 %q.ext to ptr addrspace(8)
  br label %loop
loop:
  %i = phi i32 [0, %entry], [%next, %loop]

  %not.hoistable = call i32 @llvm.amdgcn.struct.ptr.buffer.load.i32(ptr addrspace(8) %q, i32 0, i32 0, i32 0, i32 0)
  %orig = call i32 @llvm.amdgcn.raw.ptr.buffer.load.i32(ptr addrspace(8) %p, i32 %i, i32 0, i32 0)
  %inc = add i32 %not.hoistable, %orig
  call void @llvm.amdgcn.raw.ptr.buffer.store.i32(i32 %inc, ptr addrspace(8) %p, i32 %i, i32 0, i32 0)

  %next = add i32 %i, 1
  %cond = icmp ult i32 %next, %bound
  br i1 %cond, label %loop, label %tail
tail:
  ret void
}

define void @hoistable_buffer_construction_intrinsic(ptr addrspace(1) noalias %p.global, ptr addrspace(1) noalias %q.global, i32 %bound) {
; CHECK-LABEL: define void @hoistable_buffer_construction_intrinsic
; CHECK-SAME: (ptr addrspace(1) noalias [[P_GLOBAL:%.*]], ptr addrspace(1) noalias [[Q_GLOBAL:%.*]], i32 [[BOUND:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[P:%.*]] = call ptr addrspace(8) @llvm.amdgcn.make.buffer.rsrc.p1(ptr addrspace(1) [[P_GLOBAL]], i16 0, i32 0, i32 0)
; CHECK-NEXT:    [[Q:%.*]] = call ptr addrspace(8) @llvm.amdgcn.make.buffer.rsrc.p1(ptr addrspace(1) [[Q_GLOBAL]], i16 0, i32 0, i32 0)
; CHECK-NEXT:    [[HOISTABLE:%.*]] = call i32 @llvm.amdgcn.struct.ptr.buffer.load.i32(ptr addrspace(8) [[Q]], i32 0, i32 0, i32 0, i32 0)
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[I:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[ORIG:%.*]] = call i32 @llvm.amdgcn.raw.ptr.buffer.load.i32(ptr addrspace(8) [[P]], i32 [[I]], i32 0, i32 0)
; CHECK-NEXT:    [[INC:%.*]] = add i32 [[HOISTABLE]], [[ORIG]]
; CHECK-NEXT:    call void @llvm.amdgcn.raw.ptr.buffer.store.i32(i32 [[INC]], ptr addrspace(8) [[P]], i32 [[I]], i32 0, i32 0)
; CHECK-NEXT:    [[NEXT]] = add i32 [[I]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp ult i32 [[NEXT]], [[BOUND]]
; CHECK-NEXT:    br i1 [[COND]], label [[LOOP]], label [[TAIL:%.*]]
; CHECK:       tail:
; CHECK-NEXT:    ret void
;
entry:
  %p = call ptr addrspace(8) @llvm.amdgcn.make.buffer.rsrc.p1(ptr addrspace(1) %p.global, i16 0, i32 0, i32 0)
  %q = call ptr addrspace(8) @llvm.amdgcn.make.buffer.rsrc.p1(ptr addrspace(1) %q.global, i16 0, i32 0, i32 0)
  br label %loop
loop:
  %i = phi i32 [0, %entry], [%next, %loop]

  %hoistable = call i32 @llvm.amdgcn.struct.ptr.buffer.load.i32(ptr addrspace(8) %q, i32 0, i32 0, i32 0, i32 0)
  %orig = call i32 @llvm.amdgcn.raw.ptr.buffer.load.i32(ptr addrspace(8) %p, i32 %i, i32 0, i32 0)
  %inc = add i32 %hoistable, %orig
  call void @llvm.amdgcn.raw.ptr.buffer.store.i32(i32 %inc, ptr addrspace(8) %p, i32 %i, i32 0, i32 0)

  %next = add i32 %i, 1
  %cond = icmp ult i32 %next, %bound
  br i1 %cond, label %loop, label %tail
tail:
  ret void
}


define void @hoistable_buffer_construction_alias_scope(ptr addrspace(1) %p.global, ptr addrspace(1) %q.global, i32 %bound) {
; CHECK-LABEL: define void @hoistable_buffer_construction_alias_scope
; CHECK-SAME: (ptr addrspace(1) [[P_GLOBAL:%.*]], ptr addrspace(1) [[Q_GLOBAL:%.*]], i32 [[BOUND:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[P_GLOBAL_INT:%.*]] = ptrtoint ptr addrspace(1) [[P_GLOBAL]] to i64
; CHECK-NEXT:    [[Q_GLOBAL_INT:%.*]] = ptrtoint ptr addrspace(1) [[Q_GLOBAL]] to i64
; CHECK-NEXT:    [[P_TRUNC:%.*]] = trunc i64 [[P_GLOBAL_INT]] to i48
; CHECK-NEXT:    [[Q_TRUNC:%.*]] = trunc i64 [[Q_GLOBAL_INT]] to i48
; CHECK-NEXT:    [[P_EXT:%.*]] = zext i48 [[P_TRUNC]] to i128
; CHECK-NEXT:    [[Q_EXT:%.*]] = zext i48 [[Q_TRUNC]] to i128
; CHECK-NEXT:    [[P:%.*]] = inttoptr i128 [[P_EXT]] to ptr addrspace(8)
; CHECK-NEXT:    [[Q:%.*]] = inttoptr i128 [[Q_EXT]] to ptr addrspace(8)
; CHECK-NEXT:    [[HOISTABLE:%.*]] = call i32 @llvm.amdgcn.struct.ptr.buffer.load.i32(ptr addrspace(8) [[Q]], i32 0, i32 0, i32 0, i32 0), !alias.scope !0, !noalias !3
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[I:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[ORIG:%.*]] = call i32 @llvm.amdgcn.raw.ptr.buffer.load.i32(ptr addrspace(8) [[P]], i32 [[I]], i32 0, i32 0), !alias.scope !3, !noalias !0
; CHECK-NEXT:    [[INC:%.*]] = add i32 [[HOISTABLE]], [[ORIG]]
; CHECK-NEXT:    call void @llvm.amdgcn.raw.ptr.buffer.store.i32(i32 [[INC]], ptr addrspace(8) [[P]], i32 [[I]], i32 0, i32 0), !alias.scope !3, !noalias !0
; CHECK-NEXT:    [[NEXT]] = add i32 [[I]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp ult i32 [[NEXT]], [[BOUND]]
; CHECK-NEXT:    br i1 [[COND]], label [[LOOP]], label [[TAIL:%.*]]
; CHECK:       tail:
; CHECK-NEXT:    ret void
;
entry:
  %p.global.int = ptrtoint ptr addrspace(1) %p.global to i64
  %q.global.int = ptrtoint ptr addrspace(1) %q.global to i64
  %p.trunc = trunc i64 %p.global.int to i48
  %q.trunc = trunc i64 %q.global.int to i48
  %p.ext = zext i48 %p.trunc to i128
  %q.ext = zext i48 %q.trunc to i128
  %p = inttoptr i128 %p.ext to ptr addrspace(8)
  %q = inttoptr i128 %q.ext to ptr addrspace(8)
  br label %loop
loop:
  %i = phi i32 [0, %entry], [%next, %loop]

  %hoistable = call i32 @llvm.amdgcn.struct.ptr.buffer.load.i32(ptr addrspace(8) %q, i32 0, i32 0, i32 0, i32 0), !alias.scope !4, !noalias !3
  %orig = call i32 @llvm.amdgcn.raw.ptr.buffer.load.i32(ptr addrspace(8) %p, i32 %i, i32 0, i32 0), !alias.scope !3, !noalias !4
  %inc = add i32 %hoistable, %orig
  call void @llvm.amdgcn.raw.ptr.buffer.store.i32(i32 %inc, ptr addrspace(8) %p, i32 %i, i32 0, i32 0), !alias.scope !3, !noalias !4

  %next = add i32 %i, 1
  %cond = icmp ult i32 %next, %bound
  br i1 %cond, label %loop, label %tail
tail:
  ret void
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: read)
declare i32 @llvm.amdgcn.raw.ptr.buffer.load.i32(ptr addrspace(8) nocapture readonly, i32, i32, i32 immarg) #0
; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: read)
declare i32 @llvm.amdgcn.struct.ptr.buffer.load.i32(ptr addrspace(8) nocapture readonly, i32, i32, i32, i32 immarg) #0
; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: write)
declare void @llvm.amdgcn.raw.ptr.buffer.store.i32(i32, ptr addrspace(8) nocapture writeonly, i32, i32, i32 immarg) #1
; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)declare ptr addrspace(8) @llvm.amdgcn.make.buffer.rsrc.p1(ptr addrspace(1) nocapture readnone, i16, i32, i32) #2
declare ptr addrspace(8) @llvm.amdgcn.make.buffer.rsrc.p1(ptr addrspace(1) readnone nocapture, i16, i32, i32)
attributes #0 = { nocallback nofree nosync nounwind willreturn memory(argmem: read) }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(argmem: write) }
attributes #2 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
