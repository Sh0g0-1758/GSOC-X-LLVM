; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; Only run with new pass manager since old pass manager's alias analysis isn't
; powerful enough to tell that the tailcall's arguments don't alias the frame.
;
; RUN: opt < %s -passes='coro-elide' -S | FileCheck %s
; RUN: opt < %s -aa-pipeline= -passes='coro-elide' -S | FileCheck %s -check-prefix=NOAA

%"bar.Frame" = type { ptr, ptr, %"struct.coroutine<false, int>::promise_type", i1 }
%"struct.coroutine<false, int>::promise_type" = type { i32 }
%"foo.Frame" = type { ptr, ptr, %"struct.coroutine<true, int>::promise_type", i1, %"struct.coroutine<true, int>::promise_type::final_awaitable" }
%"struct.coroutine<true, int>::promise_type" = type { i32 }
%"struct.coroutine<true, int>::promise_type::final_awaitable" = type { i8 }
@"bar.resumers" = private constant [3 x ptr] [ptr @"bar.resume", ptr undef, ptr undef]

declare dso_local void @"bar"() align 2
declare dso_local fastcc void @"bar.resume"(ptr align 8 dereferenceable(24)) align 2

; There is a musttail call.
; With alias analysis, we can tell that the frame does not interfere with CALL34, and hence we can keep the tailcalls.
; Without alias analysis, we have to keep the tailcalls.
define internal fastcc void @foo.resume_musttail(ptr %FramePtr) {
; CHECK-LABEL: @foo.resume_musttail(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = alloca [24 x i8], align 8
; CHECK-NEXT:    [[VFRAME:%.*]] = bitcast ptr [[TMP0]] to ptr
; CHECK-NEXT:    [[TMP1:%.*]] = tail call token @llvm.coro.id(i32 16, ptr null, ptr @bar, ptr @bar.resumers)
; CHECK-NEXT:    [[CALL34:%.*]] = call ptr undef()
; CHECK-NEXT:    musttail call fastcc void undef(ptr [[CALL34]])
; CHECK-NEXT:    ret void
;
; NOAA-LABEL: @foo.resume_musttail(
; NOAA-NEXT:  entry:
; NOAA-NEXT:    [[TMP0:%.*]] = alloca [24 x i8], align 8
; NOAA-NEXT:    [[VFRAME:%.*]] = bitcast ptr [[TMP0]] to ptr
; NOAA-NEXT:    [[TMP1:%.*]] = call token @llvm.coro.id(i32 16, ptr null, ptr @bar, ptr @bar.resumers)
; NOAA-NEXT:    [[CALL34:%.*]] = call ptr undef()
; NOAA-NEXT:    musttail call fastcc void undef(ptr [[CALL34]])
; NOAA-NEXT:    ret void
;
entry:
  %0 = tail call token @llvm.coro.id(i32 16, ptr null, ptr @"bar", ptr @"bar.resumers")
  %1 = tail call i1 @llvm.coro.alloc(token %0)
  %2 = tail call ptr @llvm.coro.begin(token %0, ptr null)
  call ptr @llvm.coro.subfn.addr(ptr %2, i8 1)
  %call34 = call ptr undef()
  musttail call fastcc void undef(ptr %call34)
  ret void
}

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #0

; Function Attrs: argmemonly nounwind readonly
declare token @llvm.coro.id(i32, ptr readnone, ptr nocapture readonly, ptr) #1

; Function Attrs: nounwind
declare i1 @llvm.coro.alloc(token) #2

; Function Attrs: nounwind
declare ptr @llvm.coro.begin(token, ptr writeonly) #2

; Function Attrs: argmemonly nounwind readonly
declare ptr @llvm.coro.subfn.addr(ptr nocapture readonly, i8) #1

attributes #0 = { argmemonly nofree nosync nounwind willreturn }
attributes #1 = { argmemonly nounwind readonly }
attributes #2 = { nounwind }
