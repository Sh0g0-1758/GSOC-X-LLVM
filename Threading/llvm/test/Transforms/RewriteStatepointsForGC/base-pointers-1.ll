; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=rewrite-statepoints-for-gc -S 2>&1 | FileCheck %s


declare void @site_for_call_safpeoint()

; derived %merged_value base %merged_value.base
define ptr addrspace(1) @test(ptr addrspace(1) %base_obj_x, ptr addrspace(1) %base_obj_y, i1 %runtime_condition) gc "statepoint-example" {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[RUNTIME_CONDITION:%.*]], label [[HERE:%.*]], label [[THERE:%.*]]
; CHECK:       here:
; CHECK-NEXT:    [[X:%.*]] = getelementptr i64, ptr addrspace(1) [[BASE_OBJ_X:%.*]], i32 1
; CHECK-NEXT:    br label [[MERGE:%.*]]
; CHECK:       there:
; CHECK-NEXT:    [[Y:%.*]] = getelementptr i64, ptr addrspace(1) [[BASE_OBJ_Y:%.*]], i32 1
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       merge:
; CHECK-NEXT:    [[MERGED_VALUE_BASE:%.*]] = phi ptr addrspace(1) [ [[BASE_OBJ_X]], [[HERE]] ], [ [[BASE_OBJ_Y]], [[THERE]] ], !is_base_value !0
; CHECK-NEXT:    [[MERGED_VALUE:%.*]] = phi ptr addrspace(1) [ [[X]], [[HERE]] ], [ [[Y]], [[THERE]] ]
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, ptr, i32, i32, ...) @llvm.experimental.gc.statepoint.p0(i64 2882400000, i32 0, ptr elementtype(void ()) @site_for_call_safpeoint, i32 0, i32 0, i32 0, i32 0) [ "deopt"(i32 0, i32 -1, i32 0, i32 0, i32 0), "gc-live"(ptr addrspace(1) [[MERGED_VALUE]], ptr addrspace(1) [[MERGED_VALUE_BASE]]) ]
; CHECK-NEXT:    [[MERGED_VALUE_RELOCATED:%.*]] = call coldcc ptr addrspace(1) @llvm.experimental.gc.relocate.p1(token [[STATEPOINT_TOKEN]], i32 1, i32 0)
; CHECK-NEXT:    [[MERGED_VALUE_BASE_RELOCATED:%.*]] = call coldcc ptr addrspace(1) @llvm.experimental.gc.relocate.p1(token [[STATEPOINT_TOKEN]], i32 1, i32 1)
; CHECK-NEXT:    ret ptr addrspace(1) [[MERGED_VALUE_RELOCATED]]
;
entry:
  br i1 %runtime_condition, label %here, label %there

here:                                             ; preds = %entry
  %x = getelementptr i64, ptr addrspace(1) %base_obj_x, i32 1
  br label %merge

there:                                            ; preds = %entry
  %y = getelementptr i64, ptr addrspace(1) %base_obj_y, i32 1
  br label %merge

merge:                                            ; preds = %there, %here
  %merged_value = phi ptr addrspace(1) [ %x, %here ], [ %y, %there ]
  call void @site_for_call_safpeoint() [ "deopt"(i32 0, i32 -1, i32 0, i32 0, i32 0) ]
  ret ptr addrspace(1) %merged_value
}
