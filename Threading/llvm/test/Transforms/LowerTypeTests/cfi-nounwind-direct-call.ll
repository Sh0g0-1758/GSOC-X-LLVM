; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --check-attributes --include-generated-funcs --version 2
; RUN: opt < %s -passes='lowertypetests,default<O3>' -S | FileCheck %s

; This IR is based of the following C++
; which was compiled with:
; clang -cc1 -fexceptions -fcxx-exceptions \
; -std=c++11 -internal-isystem llvm-project/build/lib/clang/17/include \
; -nostdsysteminc -triple x86_64-unknown-linux -fsanitize=cfi-icall \
; -fsanitize-cfi-cross-dso -fsanitize-trap=cfi-icall -Oz -S -emit-llvm
; int (*catch_ptr)(int);
; int nothrow_e (int num) noexcept {
;   if (num) return 1;
;   return 0;
; }
; int call_catch(int num) {
;   catch_ptr = &nothrow_e;
;   return catch_ptr(num);
; }

target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux"

@catch_ptr = local_unnamed_addr global ptr null, align 8
@llvm.used = appending global [1 x ptr] [ptr @__cfi_check_fail], section "llvm.metadata"

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none)
define dso_local noundef i32 @_Z9nothrow_ei(i32 noundef %num) #0 !type !4 !type !5 !type !6 {
entry:
  %tobool.not = icmp ne i32 %num, 0
  %. = zext i1 %tobool.not to i32
  ret i32 %.
}

; Function Attrs: minsize mustprogress nounwind optsize
define dso_local noundef i32 @_Z10call_catchi(i32 noundef %num) local_unnamed_addr #1 !type !4 !type !5 !type !6 {
entry:
  store ptr @_Z9nothrow_ei, ptr @catch_ptr, align 8, !tbaa !7
  %0 = tail call i1 @llvm.type.test(ptr nonnull @_Z9nothrow_ei, metadata !"_ZTSFiiE"), !nosanitize !11
  br i1 %0, label %cfi.cont, label %cfi.slowpath, !prof !12, !nosanitize !11

cfi.slowpath:                                     ; preds = %entry
  tail call void @__cfi_slowpath(i64 5174074510188755522, ptr nonnull @_Z9nothrow_ei) #5, !nosanitize !11
  br label %cfi.cont, !nosanitize !11

cfi.cont:                                         ; preds = %cfi.slowpath, %entry
  %tobool.not.i = icmp ne i32 %num, 0
  %..i = zext i1 %tobool.not.i to i32
  ret i32 %..i
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i1 @llvm.type.test(ptr, metadata) #2

declare void @__cfi_slowpath(i64, ptr) local_unnamed_addr

; Function Attrs: minsize optsize
define weak_odr hidden void @__cfi_check_fail(ptr noundef %0, ptr noundef %1) #3 {
entry:
  %.not = icmp eq ptr %0, null, !nosanitize !11
  br i1 %.not, label %trap, label %cont, !nosanitize !11

trap:                                             ; preds = %cont, %entry
  tail call void @llvm.ubsantrap(i8 2) #6, !nosanitize !11
  unreachable, !nosanitize !11

cont:                                             ; preds = %entry
  %2 = load i8, ptr %0, align 4, !nosanitize !11
  %switch = icmp ult i8 %2, 5
  br i1 %switch, label %trap, label %cont6

cont6:                                            ; preds = %cont
  ret void, !nosanitize !11
}

; Function Attrs: cold noreturn nounwind
declare void @llvm.ubsantrap(i8 immarg) #4

define weak void @__cfi_check(i64 %0, ptr %1, ptr %2) local_unnamed_addr {
entry:
  tail call void @llvm.trap()
  unreachable
}

; Function Attrs: cold noreturn nounwind
declare void @llvm.trap() #4

attributes #0 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none) "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-features"="+cx8,+mmx,+sse,+sse2,+x87" }
attributes #1 = { minsize mustprogress nounwind optsize "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-features"="+cx8,+mmx,+sse,+sse2,+x87" }
attributes #2 = { mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #3 = { minsize optsize "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-features"="+cx8,+mmx,+sse,+sse2,+x87" }
attributes #4 = { cold noreturn nounwind }
attributes #5 = { nounwind }
attributes #6 = { noreturn nounwind }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 4, !"Cross-DSO CFI", i32 1}
!2 = !{i32 4, !"CFI Canonical Jump Tables", i32 0}
!3 = !{!"clang version 17.0.2"}
!4 = !{i64 0, !"_ZTSFiiE"}
!5 = !{i64 0, !"_ZTSFiiE.generalized"}
!6 = !{i64 0, i64 5174074510188755522}
!7 = !{!8, !8, i64 0}
!8 = !{!"any pointer", !9, i64 0}
!9 = !{!"omnipotent char", !10, i64 0}
!10 = !{!"Simple C++ TBAA"}
!11 = !{}
!12 = !{!"branch_weights", i32 1048575, i32 1}
; CHECK: Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none)
; CHECK-LABEL: define dso_local noundef i32 @_Z9nothrow_ei
; CHECK-SAME: (i32 noundef [[NUM:%.*]]) #[[ATTR0:[0-9]+]] !type !4 !type !5 !type !6 {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TOBOOL_NOT:%.*]] = icmp ne i32 [[NUM]], 0
; CHECK-NEXT:    [[DOT:%.*]] = zext i1 [[TOBOOL_NOT]] to i32
; CHECK-NEXT:    ret i32 [[DOT]]
;
;
; CHECK: Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(write, argmem: none, inaccessiblemem: none)
; CHECK-LABEL: define dso_local noundef i32 @_Z10call_catchi
; CHECK-SAME: (i32 noundef [[NUM:%.*]]) local_unnamed_addr #[[ATTR1:[0-9]+]] !type !4 !type !5 !type !6 {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store ptr @_Z9nothrow_ei.cfi_jt, ptr @catch_ptr, align 8, !tbaa [[TBAA7:![0-9]+]]
; CHECK-NEXT:    [[TOBOOL_NOT_I:%.*]] = icmp ne i32 [[NUM]], 0
; CHECK-NEXT:    [[DOT_I:%.*]] = zext i1 [[TOBOOL_NOT_I]] to i32
; CHECK-NEXT:    ret i32 [[DOT_I]]
;
;
; CHECK: Function Attrs: minsize optsize
; CHECK-LABEL: define weak_odr hidden void @__cfi_check_fail
; CHECK-SAME: (ptr noundef [[TMP0:%.*]], ptr noundef [[TMP1:%.*]]) #[[ATTR2:[0-9]+]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[DOTNOT:%.*]] = icmp eq ptr [[TMP0]], null, !nosanitize !11
; CHECK-NEXT:    br i1 [[DOTNOT]], label [[TRAP:%.*]], label [[CONT:%.*]], !nosanitize !11
; CHECK:       trap:
; CHECK-NEXT:    tail call void @llvm.ubsantrap(i8 2) #[[ATTR5:[0-9]+]], !nosanitize !11
; CHECK-NEXT:    unreachable, !nosanitize !11
; CHECK:       cont:
; CHECK-NEXT:    [[TMP2:%.*]] = load i8, ptr [[TMP0]], align 4, !nosanitize !11
; CHECK-NEXT:    [[SWITCH:%.*]] = icmp ult i8 [[TMP2]], 5
; CHECK-NEXT:    br i1 [[SWITCH]], label [[TRAP]], label [[CONT6:%.*]]
; CHECK:       cont6:
; CHECK-NEXT:    ret void, !nosanitize !11
;
;
; CHECK-LABEL: define weak void @__cfi_check
; CHECK-SAME: (i64 [[TMP0:%.*]], ptr [[TMP1:%.*]], ptr [[TMP2:%.*]]) local_unnamed_addr {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    tail call void @llvm.trap()
; CHECK-NEXT:    unreachable
;
;
; CHECK: Function Attrs: naked nocf_check noinline nounwind
; CHECK-LABEL: define internal void @_Z9nothrow_ei.cfi_jt
; CHECK-SAME: () #[[ATTR4:[0-9]+]] align 8 {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    tail call void asm sideeffect "jmp ${0:c}@plt\0Aint3\0Aint3\0Aint3\0A", "s"(ptr nonnull @_Z9nothrow_ei) #[[ATTR6:[0-9]+]]
; CHECK-NEXT:    unreachable
;
