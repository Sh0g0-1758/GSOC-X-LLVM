; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 2
; RUN: opt -S -passes=inline %s | FileCheck %s
; RUN: opt -S -passes='cgscc(inline)' %s | FileCheck %s
; RUN: opt -S -passes='module-inline' %s | FileCheck %s

declare ptr @foo()
declare void @use.ptr(ptr) willreturn nounwind
declare void @bar()
declare void @baz()
declare ptr @llvm.ptrmask.p0.i64(ptr, i64)
declare i1 @val()

define ptr @callee0123() {
; CHECK-LABEL: define ptr @callee0123() {
; CHECK-NEXT:    [[R:%.*]] = call ptr @foo()
; CHECK-NEXT:    ret ptr [[R]]
;
  %r = call ptr @foo()
  ret ptr %r
}

define ptr @caller0() {
; CHECK-LABEL: define ptr @caller0() {
; CHECK-NEXT:    [[R_I:%.*]] = call dereferenceable(16) ptr @foo()
; CHECK-NEXT:    ret ptr [[R_I]]
;
  %r = call dereferenceable(16) ptr @callee0123()
  ret ptr %r
}

define ptr @caller1() {
; CHECK-LABEL: define ptr @caller1() {
; CHECK-NEXT:    [[R_I:%.*]] = call align 16 ptr @foo()
; CHECK-NEXT:    ret ptr [[R_I]]
;
  %r = call align(16) ptr @callee0123()
  ret ptr %r
}

define ptr @caller2() {
; CHECK-LABEL: define ptr @caller2() {
; CHECK-NEXT:    [[R_I:%.*]] = call noundef ptr @foo()
; CHECK-NEXT:    ret ptr [[R_I]]
;
  %r = call noundef ptr @callee0123()
  ret ptr %r
}

define ptr @caller3() {
; CHECK-LABEL: define ptr @caller3() {
; CHECK-NEXT:    [[R_I:%.*]] = call dereferenceable_or_null(32) ptr @foo()
; CHECK-NEXT:    ret ptr [[R_I]]
;
  %r = call dereferenceable_or_null(32) ptr @callee0123()
  ret ptr %r
}

define ptr @caller_0123_dornull() {
; CHECK-LABEL: define ptr @caller_0123_dornull() {
; CHECK-NEXT:    [[R_I:%.*]] = call noundef align 32 dereferenceable_or_null(16) ptr @foo()
; CHECK-NEXT:    ret ptr [[R_I]]
;
  %r = call noundef align(32) dereferenceable_or_null(16) ptr @callee0123()
  ret ptr %r
}

define ptr @caller_0123_d() {
; CHECK-LABEL: define ptr @caller_0123_d() {
; CHECK-NEXT:    [[R_I:%.*]] = call noundef align 32 dereferenceable(16) ptr @foo()
; CHECK-NEXT:    ret ptr [[R_I]]
;
  %r = call noundef align(32) dereferenceable(16) ptr @callee0123()
  ret ptr %r
}

define ptr @callee4() {
; CHECK-LABEL: define ptr @callee4() {
; CHECK-NEXT:    [[R:%.*]] = call ptr @foo()
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    ret ptr [[R]]
;
  %r = call ptr @foo()
  call void @bar()
  ret ptr %r
}

define ptr @caller4_fail() {
; CHECK-LABEL: define ptr @caller4_fail() {
; CHECK-NEXT:    [[R_I:%.*]] = call ptr @foo()
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    ret ptr [[R_I]]
;
  %r = call noundef align(256) ptr @callee4()
  ret ptr %r
}

define ptr @callee5() {
; CHECK-LABEL: define ptr @callee5() {
; CHECK-NEXT:    [[R:%.*]] = call align 64 ptr @foo()
; CHECK-NEXT:    ret ptr [[R]]
;
  %r = call align(64) ptr @foo()
  ret ptr %r
}

define ptr @caller5_fail() {
; CHECK-LABEL: define ptr @caller5_fail() {
; CHECK-NEXT:    [[R_I:%.*]] = call noundef align 64 ptr @foo()
; CHECK-NEXT:    ret ptr [[R_I]]
;
  %r = call noundef align(32) ptr @callee5()
  ret ptr %r
}

define ptr @caller5_okay() {
; CHECK-LABEL: define ptr @caller5_okay() {
; CHECK-NEXT:    [[R_I:%.*]] = call noundef align 128 ptr @foo()
; CHECK-NEXT:    ret ptr [[R_I]]
;
  %r = call noundef align(128) ptr @callee5()
  ret ptr %r
}

define ptr @callee6() {
; CHECK-LABEL: define ptr @callee6() {
; CHECK-NEXT:    [[R:%.*]] = call dereferenceable(16) ptr @foo()
; CHECK-NEXT:    ret ptr [[R]]
;
  %r = call dereferenceable(16) ptr @foo()
  ret ptr %r
}

define ptr @caller6_fail() {
; CHECK-LABEL: define ptr @caller6_fail() {
; CHECK-NEXT:    [[R_I:%.*]] = call dereferenceable(16) ptr @foo()
; CHECK-NEXT:    ret ptr [[R_I]]
;
  %r = call dereferenceable(8) ptr @callee6()
  ret ptr %r
}

define ptr @caller6_okay() {
; CHECK-LABEL: define ptr @caller6_okay() {
; CHECK-NEXT:    [[R_I:%.*]] = call dereferenceable(32) ptr @foo()
; CHECK-NEXT:    ret ptr [[R_I]]
;
  %r = call dereferenceable(32) ptr @callee6()
  ret ptr %r
}

define ptr @callee7() {
; CHECK-LABEL: define ptr @callee7() {
; CHECK-NEXT:    [[R:%.*]] = call dereferenceable_or_null(16) ptr @foo()
; CHECK-NEXT:    ret ptr [[R]]
;
  %r = call dereferenceable_or_null(16) ptr @foo()
  ret ptr %r
}

define ptr @caller7_fail() {
; CHECK-LABEL: define ptr @caller7_fail() {
; CHECK-NEXT:    [[R_I:%.*]] = call dereferenceable_or_null(16) ptr @foo()
; CHECK-NEXT:    ret ptr [[R_I]]
;
  %r = call dereferenceable_or_null(8) ptr @callee7()
  ret ptr %r
}

define ptr @caller7_okay() {
; CHECK-LABEL: define ptr @caller7_okay() {
; CHECK-NEXT:    [[R_I:%.*]] = call dereferenceable_or_null(32) ptr @foo()
; CHECK-NEXT:    ret ptr [[R_I]]
;
  %r = call dereferenceable_or_null(32) ptr @callee7()
  ret ptr %r
}

define ptr @callee8() {
; CHECK-LABEL: define ptr @callee8() {
; CHECK-NEXT:    [[R:%.*]] = call ptr @foo()
; CHECK-NEXT:    ret ptr [[R]]
;
  %r = call ptr @foo()
  ret ptr %r
}

define ptr @caller8_okay_use_after_poison_anyways() {
; CHECK-LABEL: define ptr @caller8_okay_use_after_poison_anyways() {
; CHECK-NEXT:    [[R_I:%.*]] = call nonnull ptr @foo()
; CHECK-NEXT:    call void @use.ptr(ptr [[R_I]])
; CHECK-NEXT:    ret ptr [[R_I]]
;
  %r = call nonnull ptr @callee8()
  call void @use.ptr(ptr %r)
  ret ptr %r
}

define ptr @callee9() {
; CHECK-LABEL: define ptr @callee9() {
; CHECK-NEXT:    [[R:%.*]] = call noundef ptr @foo()
; CHECK-NEXT:    ret ptr [[R]]
;
  %r = call noundef ptr @foo()
  ret ptr %r
}

define ptr @caller9_fail_creates_ub() {
; CHECK-LABEL: define ptr @caller9_fail_creates_ub() {
; CHECK-NEXT:    [[R_I:%.*]] = call noundef ptr @foo()
; CHECK-NEXT:    call void @use.ptr(ptr [[R_I]])
; CHECK-NEXT:    ret ptr [[R_I]]
;
  %r = call nonnull ptr @callee9()
  call void @use.ptr(ptr %r)
  ret ptr %r
}

define ptr @caller9_okay_is_ub_anyways() {
; CHECK-LABEL: define ptr @caller9_okay_is_ub_anyways() {
; CHECK-NEXT:    [[R_I:%.*]] = call noundef nonnull ptr @foo()
; CHECK-NEXT:    call void @use.ptr(ptr [[R_I]])
; CHECK-NEXT:    ret ptr [[R_I]]
;
  %r = call noundef nonnull ptr @callee9()
  call void @use.ptr(ptr %r)
  ret ptr %r
}

define ptr @callee10() {
; CHECK-LABEL: define ptr @callee10() {
; CHECK-NEXT:    [[R:%.*]] = call ptr @foo()
; CHECK-NEXT:    call void @use.ptr(ptr [[R]])
; CHECK-NEXT:    ret ptr [[R]]
;
  %r = call ptr @foo()
  call void @use.ptr(ptr %r)
  ret ptr %r
}

define ptr @caller10_fail_maybe_poison() {
; CHECK-LABEL: define ptr @caller10_fail_maybe_poison() {
; CHECK-NEXT:    [[R_I:%.*]] = call ptr @foo()
; CHECK-NEXT:    call void @use.ptr(ptr [[R_I]])
; CHECK-NEXT:    ret ptr [[R_I]]
;
  %r = call nonnull ptr @callee10()
  ret ptr %r
}

define ptr @caller10_okay_will_be_ub() {
; CHECK-LABEL: define ptr @caller10_okay_will_be_ub() {
; CHECK-NEXT:    [[R_I:%.*]] = call noundef nonnull ptr @foo()
; CHECK-NEXT:    call void @use.ptr(ptr [[R_I]])
; CHECK-NEXT:    ret ptr [[R_I]]
;
  %r = call noundef nonnull ptr @callee10()
  ret ptr %r
}

define noundef ptr @caller10_okay_will_be_ub_todo() {
; CHECK-LABEL: define noundef ptr @caller10_okay_will_be_ub_todo() {
; CHECK-NEXT:    [[R_I:%.*]] = call ptr @foo()
; CHECK-NEXT:    call void @use.ptr(ptr [[R_I]])
; CHECK-NEXT:    ret ptr [[R_I]]
;
  %r = call nonnull ptr @callee10()
  ret ptr %r
}

define ptr @callee11() {
; CHECK-LABEL: define ptr @callee11() {
; CHECK-NEXT:    [[R:%.*]] = call ptr @foo()
; CHECK-NEXT:    [[COND:%.*]] = call i1 @val() #[[ATTR0:[0-9]+]]
; CHECK-NEXT:    br i1 [[COND]], label [[TRUE:%.*]], label [[FALSE:%.*]]
; CHECK:       True:
; CHECK-NEXT:    call void @baz() #[[ATTR0]]
; CHECK-NEXT:    ret ptr [[R]]
; CHECK:       False:
; CHECK-NEXT:    call void @bar() #[[ATTR0]]
; CHECK-NEXT:    [[COND2:%.*]] = call i1 @val()
; CHECK-NEXT:    ret ptr [[R]]
;
  %r = call ptr @foo()
  %cond = call i1 @val() nounwind willreturn
  br i1 %cond, label %True, label %False
True:
  call void @baz() nounwind willreturn
  ret ptr %r
False:
  call void @bar() nounwind willreturn
  %cond2 = call i1 @val()
  ret ptr %r
}

define ptr @caller11_todo() {
; CHECK-LABEL: define ptr @caller11_todo() {
; CHECK-NEXT:    [[R_I:%.*]] = call ptr @foo()
; CHECK-NEXT:    [[COND_I:%.*]] = call i1 @val() #[[ATTR0]]
; CHECK-NEXT:    br i1 [[COND_I]], label [[TRUE_I:%.*]], label [[FALSE_I:%.*]]
; CHECK:       True.i:
; CHECK-NEXT:    call void @baz() #[[ATTR0]]
; CHECK-NEXT:    br label [[CALLEE11_EXIT:%.*]]
; CHECK:       False.i:
; CHECK-NEXT:    call void @bar() #[[ATTR0]]
; CHECK-NEXT:    [[COND2_I:%.*]] = call i1 @val()
; CHECK-NEXT:    br label [[CALLEE11_EXIT]]
; CHECK:       callee11.exit:
; CHECK-NEXT:    ret ptr [[R_I]]
;
  %r = call nonnull ptr @callee11()
  ret ptr %r
}

define ptr @callee12() {
; CHECK-LABEL: define ptr @callee12() {
; CHECK-NEXT:    [[P:%.*]] = call ptr @foo()
; CHECK-NEXT:    [[COND:%.*]] = call i1 @val() #[[ATTR0]]
; CHECK-NEXT:    [[PP:%.*]] = call ptr @llvm.ptrmask.p0.i64(ptr [[P]], i64 -4)
; CHECK-NEXT:    [[R:%.*]] = select i1 [[COND]], ptr [[P]], ptr [[PP]]
; CHECK-NEXT:    ret ptr [[R]]
;
  %p = call ptr @foo()
  %cond = call i1 @val() nounwind willreturn
  %pp = call ptr @llvm.ptrmask.p0.i64(ptr %p, i64 -4)
  %r = select i1 %cond, ptr %p, ptr %pp
  ret ptr %r
}

define ptr @caller12_todo() {
; CHECK-LABEL: define ptr @caller12_todo() {
; CHECK-NEXT:    [[P_I:%.*]] = call ptr @foo()
; CHECK-NEXT:    [[COND_I:%.*]] = call i1 @val() #[[ATTR0]]
; CHECK-NEXT:    [[PP_I:%.*]] = call ptr @llvm.ptrmask.p0.i64(ptr [[P_I]], i64 -4)
; CHECK-NEXT:    [[R_I:%.*]] = select i1 [[COND_I]], ptr [[P_I]], ptr [[PP_I]]
; CHECK-NEXT:    ret ptr [[R_I]]
;
  %r = call nonnull ptr @callee12()
  ret ptr %r
}
