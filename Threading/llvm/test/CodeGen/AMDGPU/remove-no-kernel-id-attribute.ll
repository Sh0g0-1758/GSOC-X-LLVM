; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --check-attributes --check-globals --version 3
; RUN: opt -S -mtriple=amdgcn-- -passes=amdgpu-attributor,amdgpu-lower-module-lds < %s --amdgpu-lower-module-lds-strategy=table | FileCheck -check-prefixes=CHECK,TABLE %s

; FIXME: Work around update_test_checks bug in constant expression handling by manually deleting part of the last global pattern

@function.lds = addrspace(3) global i16 poison
@other.kernel.lds = addrspace(3) global i16 poison
@recursive.kernel.lds = addrspace(3) global i16 poison

;.
; CHECK: @[[LLVM_AMDGCN_KERNEL_K0_F0_LDS:[a-zA-Z0-9_$"\\.-]+]] = internal addrspace(3) global [[LLVM_AMDGCN_KERNEL_K0_F0_LDS_T:%.*]] poison, align 2, !absolute_symbol !0
; CHECK: @[[LLVM_AMDGCN_KERNEL_K1_F0_LDS:[a-zA-Z0-9_$"\\.-]+]] = internal addrspace(3) global [[LLVM_AMDGCN_KERNEL_K1_F0_LDS_T:%.*]] poison, align 2, !absolute_symbol !0
; CHECK: @[[LLVM_AMDGCN_KERNEL_KERNEL_LDS_LDS:[a-zA-Z0-9_$"\\.-]+]] = internal addrspace(3) global [[LLVM_AMDGCN_KERNEL_KERNEL_LDS_LDS_T:%.*]] poison, align 2, !absolute_symbol !0
; CHECK: @[[LLVM_AMDGCN_KERNEL_KERNEL_LDS_RECURSION_LDS:[a-zA-Z0-9_$"\\.-]+]] = internal addrspace(3) global [[LLVM_AMDGCN_KERNEL_KERNEL_LDS_RECURSION_LDS_T:%.*]] poison, align 2, !absolute_symbol !0
; CHECK: @[[LLVM_AMDGCN_LDS_OFFSET_TABLE:[a-zA-Z0-9_$"\\.-]+]] = internal addrspace(4) constant [3 x [2 x i32]]
;.
define internal void @lds_use_through_indirect() {
; CHECK-LABEL: define internal void @lds_use_through_indirect(
; CHECK-SAME: ) #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.amdgcn.lds.kernel.id()
; CHECK-NEXT:    [[FUNCTION_LDS2:%.*]] = getelementptr inbounds [3 x [2 x i32]], ptr addrspace(4) @llvm.amdgcn.lds.offset.table, i32 0, i32 [[TMP1]], i32 0
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, ptr addrspace(4) [[FUNCTION_LDS2]], align 4
; CHECK-NEXT:    [[FUNCTION_LDS3:%.*]] = inttoptr i32 [[TMP2]] to ptr addrspace(3)
; CHECK-NEXT:    [[LD:%.*]] = load i16, ptr addrspace(3) [[FUNCTION_LDS3]], align 2
; CHECK-NEXT:    [[MUL:%.*]] = mul i16 [[LD]], 7
; CHECK-NEXT:    [[FUNCTION_LDS:%.*]] = getelementptr inbounds [3 x [2 x i32]], ptr addrspace(4) @llvm.amdgcn.lds.offset.table, i32 0, i32 [[TMP1]], i32 0
; CHECK-NEXT:    [[TMP3:%.*]] = load i32, ptr addrspace(4) [[FUNCTION_LDS]], align 4
; CHECK-NEXT:    [[FUNCTION_LDS1:%.*]] = inttoptr i32 [[TMP3]] to ptr addrspace(3)
; CHECK-NEXT:    store i16 [[MUL]], ptr addrspace(3) [[FUNCTION_LDS1]], align 2
; CHECK-NEXT:    ret void
;
  %ld = load i16, ptr addrspace(3) @function.lds
  %mul = mul i16 %ld, 7
  store i16 %mul, ptr addrspace(3) @function.lds
  ret void
}

define internal void @indirectly_called() {
; CHECK-LABEL: define internal void @indirectly_called(
; CHECK-SAME: ) #[[ATTR0]] {
; CHECK-NEXT:    store volatile ptr @indirectly_called, ptr addrspace(1) null, align 8
; CHECK-NEXT:    call void @lds_use_through_indirect()
; CHECK-NEXT:    ret void
;
  store volatile ptr @indirectly_called, ptr addrspace(1) null
  call void @lds_use_through_indirect()
  ret void
}

define internal void @calls_indirectly_called() {
; CHECK-LABEL: define internal void @calls_indirectly_called(
; CHECK-SAME: ) #[[ATTR0]] {
; CHECK-NEXT:    call void @indirectly_called()
; CHECK-NEXT:    ret void
;
  call void @indirectly_called()
  ret void
}

; TODO: Should still have "amdgpu-no-lds-kernel-id" attached
define internal void @no_lds_global_use_leaf() {
; CHECK-LABEL: define internal void @no_lds_global_use_leaf(
; CHECK-SAME: ) #[[ATTR1:[0-9]+]] {
; CHECK-NEXT:    ret void
;
  ret void
}

; Should have "amdgpu-no-lds-kernel-id" stripped
define internal void @f0() {
; CHECK-LABEL: define internal void @f0(
; CHECK-SAME: ) #[[ATTR0]] {
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.amdgcn.lds.kernel.id()
; CHECK-NEXT:    [[FUNCTION_LDS2:%.*]] = getelementptr inbounds [3 x [2 x i32]], ptr addrspace(4) @llvm.amdgcn.lds.offset.table, i32 0, i32 [[TMP1]], i32 0
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, ptr addrspace(4) [[FUNCTION_LDS2]], align 4
; CHECK-NEXT:    [[FUNCTION_LDS3:%.*]] = inttoptr i32 [[TMP2]] to ptr addrspace(3)
; CHECK-NEXT:    [[LD:%.*]] = load i16, ptr addrspace(3) [[FUNCTION_LDS3]], align 2
; CHECK-NEXT:    [[MUL:%.*]] = mul i16 [[LD]], 4
; CHECK-NEXT:    [[FUNCTION_LDS:%.*]] = getelementptr inbounds [3 x [2 x i32]], ptr addrspace(4) @llvm.amdgcn.lds.offset.table, i32 0, i32 [[TMP1]], i32 0
; CHECK-NEXT:    [[TMP3:%.*]] = load i32, ptr addrspace(4) [[FUNCTION_LDS]], align 4
; CHECK-NEXT:    [[FUNCTION_LDS1:%.*]] = inttoptr i32 [[TMP3]] to ptr addrspace(3)
; CHECK-NEXT:    store i16 [[MUL]], ptr addrspace(3) [[FUNCTION_LDS1]], align 2
; CHECK-NEXT:    call void @no_lds_global_use_leaf()
; CHECK-NEXT:    ret void
;
  %ld = load i16, ptr addrspace(3) @function.lds
  %mul = mul i16 %ld, 4
  store i16 %mul, ptr addrspace(3) @function.lds
  call void @no_lds_global_use_leaf()
  ret void
}

; Should have "amdgpu-no-lds-kernel-id" stripped
define internal void @f0_transitive() {
; CHECK-LABEL: define internal void @f0_transitive(
; CHECK-SAME: ) #[[ATTR0]] {
; CHECK-NEXT:    call void @f0()
; CHECK-NEXT:    call void @no_lds_global_use_leaf()
; CHECK-NEXT:    ret void
;
  call void @f0()
  call void @no_lds_global_use_leaf()
  ret void
}

define amdgpu_kernel void @k0_f0() {
; CHECK-LABEL: define amdgpu_kernel void @k0_f0(
; CHECK-SAME: ) #[[ATTR2:[0-9]+]] !llvm.amdgcn.lds.kernel.id !2 {
; CHECK-NEXT:    call void @llvm.donothing() [ "ExplicitUse"(ptr addrspace(3) @llvm.amdgcn.kernel.k0_f0.lds) ]
; CHECK-NEXT:    call void @f0_transitive()
; CHECK-NEXT:    ret void
;
  call void @f0_transitive()
  ret void
}

define amdgpu_kernel void @k1_f0() {
; CHECK-LABEL: define amdgpu_kernel void @k1_f0(
; CHECK-SAME: ) #[[ATTR3:[0-9]+]] !llvm.amdgcn.lds.kernel.id !3 {
; CHECK-NEXT:    call void @llvm.donothing() [ "ExplicitUse"(ptr addrspace(3) @llvm.amdgcn.kernel.k1_f0.lds) ], !alias.scope !4, !noalias !7
; CHECK-NEXT:    call void @f0_transitive()
; CHECK-NEXT:    [[FPTR:%.*]] = load volatile ptr, ptr addrspace(1) null, align 8
; CHECK-NEXT:    call void [[FPTR]]()
; CHECK-NEXT:    call void @calls_indirectly_called()
; CHECK-NEXT:    ret void
;
  call void @f0_transitive()
  %fptr = load volatile ptr, ptr addrspace(1) null
  call void %fptr()
  call void @calls_indirectly_called()
  ret void
}

; Should still have "amdgpu-no-lds-kernel-id" attached
define amdgpu_kernel void @kernel_lds() {
; CHECK-LABEL: define amdgpu_kernel void @kernel_lds(
; CHECK-SAME: ) #[[ATTR4:[0-9]+]] {
; CHECK-NEXT:    [[LD:%.*]] = load i16, ptr addrspace(3) @llvm.amdgcn.kernel.kernel_lds.lds, align 2
; CHECK-NEXT:    [[MUL:%.*]] = mul i16 [[LD]], 42
; CHECK-NEXT:    store i16 [[MUL]], ptr addrspace(3) @llvm.amdgcn.kernel.kernel_lds.lds, align 2
; CHECK-NEXT:    ret void
;
  %ld = load i16, ptr addrspace(3) @other.kernel.lds
  %mul = mul i16 %ld, 42
  store i16 %mul, ptr addrspace(3) @other.kernel.lds
  ret void
}

define internal i16 @mutual_recursion_0(i16 %arg) {
; CHECK-LABEL: define internal i16 @mutual_recursion_0(
; CHECK-SAME: i16 [[ARG:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.amdgcn.lds.kernel.id()
; CHECK-NEXT:    [[RECURSIVE_KERNEL_LDS:%.*]] = getelementptr inbounds [3 x [2 x i32]], ptr addrspace(4) @llvm.amdgcn.lds.offset.table, i32 0, i32 [[TMP1]], i32 1
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, ptr addrspace(4) [[RECURSIVE_KERNEL_LDS]], align 4
; CHECK-NEXT:    [[RECURSIVE_KERNEL_LDS1:%.*]] = inttoptr i32 [[TMP2]] to ptr addrspace(3)
; CHECK-NEXT:    [[LD:%.*]] = load i16, ptr addrspace(3) [[RECURSIVE_KERNEL_LDS1]], align 2
; CHECK-NEXT:    [[MUL:%.*]] = mul i16 [[LD]], 7
; CHECK-NEXT:    [[RET:%.*]] = call i16 @mutual_recursion_1(i16 [[LD]])
; CHECK-NEXT:    [[ADD:%.*]] = add i16 [[RET]], 1
; CHECK-NEXT:    ret i16 [[ADD]]
;
  %ld = load i16, ptr addrspace(3) @recursive.kernel.lds
  %mul = mul i16 %ld, 7
  %ret = call i16 @mutual_recursion_1(i16 %ld)
  %add = add i16 %ret, 1
  ret i16 %add
}

define internal void @mutual_recursion_1(i16 %arg) {
; CHECK-LABEL: define internal void @mutual_recursion_1(
; CHECK-SAME: i16 [[ARG:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    call void @mutual_recursion_0(i16 [[ARG]])
; CHECK-NEXT:    ret void
;
  call void @mutual_recursion_0(i16 %arg)
  ret void
}

define amdgpu_kernel void @kernel_lds_recursion() {
; CHECK-LABEL: define amdgpu_kernel void @kernel_lds_recursion(
; CHECK-SAME: ) #[[ATTR2]] !llvm.amdgcn.lds.kernel.id !9 {
; CHECK-NEXT:    call void @llvm.donothing() [ "ExplicitUse"(ptr addrspace(3) @llvm.amdgcn.kernel.kernel_lds_recursion.lds) ]
; CHECK-NEXT:    call void @mutual_recursion_0(i16 0)
; CHECK-NEXT:    ret void
;
  call void @mutual_recursion_0(i16 0)
  ret void
}

!llvm.module.flags = !{!1}
!1 = !{i32 1, !"amdhsa_code_object_version", i32 400}

;.
; CHECK: attributes #[[ATTR0]] = { "amdgpu-no-completion-action" "amdgpu-no-default-queue" "amdgpu-no-dispatch-id" "amdgpu-no-dispatch-ptr" "amdgpu-no-heap-ptr" "amdgpu-no-hostcall-ptr" "amdgpu-no-implicitarg-ptr" "amdgpu-no-multigrid-sync-arg" "amdgpu-no-workgroup-id-x" "amdgpu-no-workgroup-id-y" "amdgpu-no-workgroup-id-z" "amdgpu-no-workitem-id-x" "amdgpu-no-workitem-id-y" "amdgpu-no-workitem-id-z" "amdgpu-waves-per-eu"="4,10" "uniform-work-group-size"="false" }
; CHECK: attributes #[[ATTR1]] = { "amdgpu-no-completion-action" "amdgpu-no-default-queue" "amdgpu-no-dispatch-id" "amdgpu-no-dispatch-ptr" "amdgpu-no-heap-ptr" "amdgpu-no-hostcall-ptr" "amdgpu-no-implicitarg-ptr" "amdgpu-no-multigrid-sync-arg" "amdgpu-no-queue-ptr" "amdgpu-no-workgroup-id-x" "amdgpu-no-workgroup-id-y" "amdgpu-no-workgroup-id-z" "amdgpu-no-workitem-id-x" "amdgpu-no-workitem-id-y" "amdgpu-no-workitem-id-z" "amdgpu-waves-per-eu"="4,10" "uniform-work-group-size"="false" }
; CHECK: attributes #[[ATTR2]] = { "amdgpu-lds-size"="2" "amdgpu-no-completion-action" "amdgpu-no-default-queue" "amdgpu-no-dispatch-id" "amdgpu-no-dispatch-ptr" "amdgpu-no-heap-ptr" "amdgpu-no-hostcall-ptr" "amdgpu-no-implicitarg-ptr" "amdgpu-no-multigrid-sync-arg" "amdgpu-no-workgroup-id-x" "amdgpu-no-workgroup-id-y" "amdgpu-no-workgroup-id-z" "amdgpu-no-workitem-id-x" "amdgpu-no-workitem-id-y" "amdgpu-no-workitem-id-z" "amdgpu-waves-per-eu"="4,10" "uniform-work-group-size"="false" }
; CHECK: attributes #[[ATTR3]] = { "amdgpu-lds-size"="4" "amdgpu-waves-per-eu"="4,10" "uniform-work-group-size"="false" }
; CHECK: attributes #[[ATTR4]] = { "amdgpu-lds-size"="2" "amdgpu-no-completion-action" "amdgpu-no-default-queue" "amdgpu-no-dispatch-id" "amdgpu-no-dispatch-ptr" "amdgpu-no-heap-ptr" "amdgpu-no-hostcall-ptr" "amdgpu-no-implicitarg-ptr" "amdgpu-no-lds-kernel-id" "amdgpu-no-multigrid-sync-arg" "amdgpu-no-queue-ptr" "amdgpu-no-workgroup-id-x" "amdgpu-no-workgroup-id-y" "amdgpu-no-workgroup-id-z" "amdgpu-no-workitem-id-x" "amdgpu-no-workitem-id-y" "amdgpu-no-workitem-id-z" "uniform-work-group-size"="false" }
; CHECK: attributes #[[ATTR5:[0-9]+]] = { nocallback nofree nosync nounwind willreturn memory(none) }
; CHECK: attributes #[[ATTR6:[0-9]+]] = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
;.
; CHECK: [[META0:![0-9]+]] = !{i32 0, i32 1}
; CHECK: [[META1:![0-9]+]] = !{i32 0}
; CHECK: [[META2:![0-9]+]] = !{i32 1}
; CHECK: [[META3:![0-9]+]] = !{!5}
; CHECK: [[META4:![0-9]+]] = distinct !{!5, !6}
; CHECK: [[META5:![0-9]+]] = distinct !{!6}
; CHECK: [[META6:![0-9]+]] = !{!8}
; CHECK: [[META7:![0-9]+]] = distinct !{!8, !6}
; CHECK: [[META8:![0-9]+]] = !{i32 2}
;.
;; NOTE: These prefixes are unused and the list is autogenerated. Do not add tests below this line:
; TABLE: {{.*}}
