; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-globals
; RUN: opt -S -mtriple=amdgcn-amd-amdhsa -amdgpu-annotate-kernel-features  %s | FileCheck -check-prefix=AKF_GCN %s
; RUN: opt -S -mtriple=amdgcn-amd-amdhsa -passes=amdgpu-attributor %s | FileCheck -check-prefix=ATTRIBUTOR_GCN %s

; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 < %s | FileCheck -check-prefix=GFX9 %s

target datalayout = "A5"

define internal void @indirect() {
; AKF_GCN-LABEL: define {{[^@]+}}@indirect() {
; AKF_GCN-NEXT:    ret void
;
; ATTRIBUTOR_GCN-LABEL: define {{[^@]+}}@indirect
; ATTRIBUTOR_GCN-SAME: () #[[ATTR0:[0-9]+]] {
; ATTRIBUTOR_GCN-NEXT:    ret void
;
; GFX9-LABEL: indirect:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  ret void
}

define amdgpu_kernel void @test_simple_indirect_call() {
; AKF_GCN-LABEL: define {{[^@]+}}@test_simple_indirect_call
; AKF_GCN-SAME: () #[[ATTR0:[0-9]+]] {
; AKF_GCN-NEXT:    [[FPTR:%.*]] = alloca ptr, align 8, addrspace(5)
; AKF_GCN-NEXT:    [[FPTR_CAST:%.*]] = addrspacecast ptr addrspace(5) [[FPTR]] to ptr
; AKF_GCN-NEXT:    store ptr @indirect, ptr [[FPTR_CAST]], align 8
; AKF_GCN-NEXT:    [[FP:%.*]] = load ptr, ptr [[FPTR_CAST]], align 8
; AKF_GCN-NEXT:    call void [[FP]]()
; AKF_GCN-NEXT:    ret void
;
; ATTRIBUTOR_GCN-LABEL: define {{[^@]+}}@test_simple_indirect_call
; ATTRIBUTOR_GCN-SAME: () #[[ATTR1:[0-9]+]] {
; ATTRIBUTOR_GCN-NEXT:    [[FPTR:%.*]] = alloca ptr, align 8, addrspace(5)
; ATTRIBUTOR_GCN-NEXT:    [[FPTR_CAST:%.*]] = addrspacecast ptr addrspace(5) [[FPTR]] to ptr
; ATTRIBUTOR_GCN-NEXT:    store ptr @indirect, ptr [[FPTR_CAST]], align 8
; ATTRIBUTOR_GCN-NEXT:    [[FP:%.*]] = load ptr, ptr [[FPTR_CAST]], align 8
; ATTRIBUTOR_GCN-NEXT:    call void [[FP]]()
; ATTRIBUTOR_GCN-NEXT:    ret void
;
; GFX9-LABEL: test_simple_indirect_call:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_load_dwordx2 s[4:5], s[4:5], 0x4
; GFX9-NEXT:    s_add_u32 flat_scratch_lo, s10, s15
; GFX9-NEXT:    s_addc_u32 flat_scratch_hi, s11, 0
; GFX9-NEXT:    s_add_u32 s0, s0, s15
; GFX9-NEXT:    s_addc_u32 s1, s1, 0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_lshr_b32 s4, s4, 16
; GFX9-NEXT:    s_mul_i32 s4, s4, s5
; GFX9-NEXT:    v_mul_lo_u32 v0, s4, v0
; GFX9-NEXT:    s_getpc_b64 s[6:7]
; GFX9-NEXT:    s_add_u32 s6, s6, indirect@rel32@lo+4
; GFX9-NEXT:    s_addc_u32 s7, s7, indirect@rel32@hi+12
; GFX9-NEXT:    v_mov_b32_e32 v3, s6
; GFX9-NEXT:    v_mov_b32_e32 v4, s7
; GFX9-NEXT:    v_mad_u32_u24 v0, v1, s5, v0
; GFX9-NEXT:    v_add_lshl_u32 v0, v0, v2, 3
; GFX9-NEXT:    s_mov_b32 s32, 0
; GFX9-NEXT:    ds_write_b64 v0, v[3:4]
; GFX9-NEXT:    s_swappc_b64 s[30:31], s[6:7]
; GFX9-NEXT:    s_endpgm
  %fptr = alloca ptr, addrspace(5)
  %fptr.cast = addrspacecast ptr addrspace(5) %fptr to ptr
  store ptr @indirect, ptr %fptr.cast
  %fp = load ptr, ptr %fptr.cast
  call void %fp()
  ret void
}

;.
; AKF_GCN: attributes #[[ATTR0]] = { "amdgpu-calls" "amdgpu-stack-objects" }
;.
; ATTRIBUTOR_GCN: attributes #[[ATTR0]] = { "amdgpu-no-completion-action" "amdgpu-no-default-queue" "amdgpu-no-dispatch-id" "amdgpu-no-dispatch-ptr" "amdgpu-no-heap-ptr" "amdgpu-no-hostcall-ptr" "amdgpu-no-implicitarg-ptr" "amdgpu-no-lds-kernel-id" "amdgpu-no-multigrid-sync-arg" "amdgpu-no-queue-ptr" "amdgpu-no-workgroup-id-x" "amdgpu-no-workgroup-id-y" "amdgpu-no-workgroup-id-z" "amdgpu-no-workitem-id-x" "amdgpu-no-workitem-id-y" "amdgpu-no-workitem-id-z" "amdgpu-waves-per-eu"="4,10" "uniform-work-group-size"="false" }
; ATTRIBUTOR_GCN: attributes #[[ATTR1]] = { "uniform-work-group-size"="false" }
;.

!llvm.module.flags = !{!0}
!0 = !{i32 1, !"amdhsa_code_object_version", i32 500}
