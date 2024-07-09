; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=amdgcn -mcpu=gfx1200 -global-isel=0 -verify-machineinstrs | FileCheck %s -check-prefix=GFX12-SDAG
; RUN: llc < %s -mtriple=amdgcn -mcpu=gfx1200 -global-isel=1 -verify-machineinstrs | FileCheck %s -check-prefix=GFX12-GISEL

declare <2 x half> @llvm.amdgcn.struct.buffer.atomic.fadd.v2f16(<2 x half>, <4 x i32>, i32, i32, i32, i32 immarg)
declare <2 x bfloat> @llvm.amdgcn.struct.buffer.atomic.fadd.v2bf16(<2 x bfloat>, <4 x i32>, i32, i32, i32, i32 immarg)
declare <2 x half> @llvm.amdgcn.raw.buffer.atomic.fadd.v2f16(<2 x half>, <4 x i32>, i32, i32, i32)
declare <2 x bfloat> @llvm.amdgcn.raw.buffer.atomic.fadd.v2bf16(<2 x bfloat> %val, <4 x i32> %rsrc, i32, i32, i32)
declare <2 x half> @llvm.amdgcn.global.atomic.fadd.v2f16.p1.v2f16(ptr addrspace(1) %ptr, <2 x half> %data)
declare <2 x i16> @llvm.amdgcn.global.atomic.fadd.v2bf16.p1(ptr addrspace(1) %ptr, <2 x i16> %data)
declare <2 x half> @llvm.amdgcn.ds.fadd.v2f16(ptr addrspace(3) %ptr, <2 x half> %data, i32, i32, i1)
declare <2 x i16> @llvm.amdgcn.ds.fadd.v2bf16(ptr addrspace(3) %ptr, <2 x i16> %data)
declare <2 x half> @llvm.amdgcn.flat.atomic.fadd.v2f16.p0.v2f16(ptr %ptr, <2 x half> %data)
declare <2 x i16> @llvm.amdgcn.flat.atomic.fadd.v2bf16.p0(ptr %ptr, <2 x i16> %data)

define amdgpu_kernel void @local_atomic_fadd_v2f16_noret(ptr addrspace(3) %ptr, <2 x half> %data) {
; GFX12-SDAG-LABEL: local_atomic_fadd_v2f16_noret:
; GFX12-SDAG:       ; %bb.0:
; GFX12-SDAG-NEXT:    s_load_b64 s[0:1], s[0:1], 0x24
; GFX12-SDAG-NEXT:    s_wait_kmcnt 0x0
; GFX12-SDAG-NEXT:    v_dual_mov_b32 v0, s0 :: v_dual_mov_b32 v1, s1
; GFX12-SDAG-NEXT:    ds_pk_add_f16 v0, v1
; GFX12-SDAG-NEXT:    s_endpgm
;
; GFX12-GISEL-LABEL: local_atomic_fadd_v2f16_noret:
; GFX12-GISEL:       ; %bb.0:
; GFX12-GISEL-NEXT:    s_load_b64 s[0:1], s[0:1], 0x24
; GFX12-GISEL-NEXT:    s_wait_kmcnt 0x0
; GFX12-GISEL-NEXT:    v_dual_mov_b32 v0, s0 :: v_dual_mov_b32 v1, s1
; GFX12-GISEL-NEXT:    ds_pk_add_f16 v0, v1
; GFX12-GISEL-NEXT:    s_endpgm
  %ret = call <2 x half> @llvm.amdgcn.ds.fadd.v2f16(ptr addrspace(3) %ptr, <2 x half> %data, i32 0, i32 0, i1 0)
  ret void
}

define amdgpu_kernel void @local_atomic_fadd_v2bf16_noret(ptr addrspace(3) %ptr, <2 x i16> %data) {
; GFX12-SDAG-LABEL: local_atomic_fadd_v2bf16_noret:
; GFX12-SDAG:       ; %bb.0:
; GFX12-SDAG-NEXT:    s_load_b64 s[0:1], s[0:1], 0x24
; GFX12-SDAG-NEXT:    s_wait_kmcnt 0x0
; GFX12-SDAG-NEXT:    v_dual_mov_b32 v0, s0 :: v_dual_mov_b32 v1, s1
; GFX12-SDAG-NEXT:    ds_pk_add_bf16 v0, v1
; GFX12-SDAG-NEXT:    s_wait_dscnt 0x0
; GFX12-SDAG-NEXT:    global_inv scope:SCOPE_SYS
; GFX12-SDAG-NEXT:    s_endpgm
;
; GFX12-GISEL-LABEL: local_atomic_fadd_v2bf16_noret:
; GFX12-GISEL:       ; %bb.0:
; GFX12-GISEL-NEXT:    s_load_b64 s[0:1], s[0:1], 0x24
; GFX12-GISEL-NEXT:    s_wait_kmcnt 0x0
; GFX12-GISEL-NEXT:    v_dual_mov_b32 v0, s1 :: v_dual_mov_b32 v1, s0
; GFX12-GISEL-NEXT:    ds_pk_add_bf16 v1, v0
; GFX12-GISEL-NEXT:    s_wait_dscnt 0x0
; GFX12-GISEL-NEXT:    global_inv scope:SCOPE_SYS
; GFX12-GISEL-NEXT:    s_endpgm
  %ret = call <2 x i16> @llvm.amdgcn.ds.fadd.v2bf16(ptr addrspace(3) %ptr, <2 x i16> %data)
  ret void
}

define <2 x half> @local_atomic_fadd_v2f16_rtn(ptr addrspace(3) %ptr, <2 x half> %data) {
; GFX12-SDAG-LABEL: local_atomic_fadd_v2f16_rtn:
; GFX12-SDAG:       ; %bb.0:
; GFX12-SDAG-NEXT:    s_wait_loadcnt_dscnt 0x0
; GFX12-SDAG-NEXT:    s_wait_expcnt 0x0
; GFX12-SDAG-NEXT:    s_wait_samplecnt 0x0
; GFX12-SDAG-NEXT:    s_wait_bvhcnt 0x0
; GFX12-SDAG-NEXT:    s_wait_kmcnt 0x0
; GFX12-SDAG-NEXT:    ds_pk_add_rtn_f16 v0, v0, v1
; GFX12-SDAG-NEXT:    s_wait_dscnt 0x0
; GFX12-SDAG-NEXT:    s_setpc_b64 s[30:31]
;
; GFX12-GISEL-LABEL: local_atomic_fadd_v2f16_rtn:
; GFX12-GISEL:       ; %bb.0:
; GFX12-GISEL-NEXT:    s_wait_loadcnt_dscnt 0x0
; GFX12-GISEL-NEXT:    s_wait_expcnt 0x0
; GFX12-GISEL-NEXT:    s_wait_samplecnt 0x0
; GFX12-GISEL-NEXT:    s_wait_bvhcnt 0x0
; GFX12-GISEL-NEXT:    s_wait_kmcnt 0x0
; GFX12-GISEL-NEXT:    ds_pk_add_rtn_f16 v0, v0, v1
; GFX12-GISEL-NEXT:    s_wait_dscnt 0x0
; GFX12-GISEL-NEXT:    s_setpc_b64 s[30:31]
  %ret = call <2 x half> @llvm.amdgcn.ds.fadd.v2f16(ptr addrspace(3) %ptr, <2 x half> %data, i32 0, i32 0, i1 0)
  ret <2 x half> %ret
}

define <2 x i16> @local_atomic_fadd_v2bf16_rtn(ptr addrspace(3) %ptr, <2 x i16> %data) {
; GFX12-SDAG-LABEL: local_atomic_fadd_v2bf16_rtn:
; GFX12-SDAG:       ; %bb.0:
; GFX12-SDAG-NEXT:    s_wait_loadcnt_dscnt 0x0
; GFX12-SDAG-NEXT:    s_wait_expcnt 0x0
; GFX12-SDAG-NEXT:    s_wait_samplecnt 0x0
; GFX12-SDAG-NEXT:    s_wait_bvhcnt 0x0
; GFX12-SDAG-NEXT:    s_wait_kmcnt 0x0
; GFX12-SDAG-NEXT:    s_wait_storecnt 0x0
; GFX12-SDAG-NEXT:    ds_pk_add_rtn_bf16 v0, v0, v1
; GFX12-SDAG-NEXT:    s_wait_dscnt 0x0
; GFX12-SDAG-NEXT:    global_inv scope:SCOPE_SYS
; GFX12-SDAG-NEXT:    s_setpc_b64 s[30:31]
;
; GFX12-GISEL-LABEL: local_atomic_fadd_v2bf16_rtn:
; GFX12-GISEL:       ; %bb.0:
; GFX12-GISEL-NEXT:    s_wait_loadcnt_dscnt 0x0
; GFX12-GISEL-NEXT:    s_wait_expcnt 0x0
; GFX12-GISEL-NEXT:    s_wait_samplecnt 0x0
; GFX12-GISEL-NEXT:    s_wait_bvhcnt 0x0
; GFX12-GISEL-NEXT:    s_wait_kmcnt 0x0
; GFX12-GISEL-NEXT:    s_wait_storecnt 0x0
; GFX12-GISEL-NEXT:    ds_pk_add_rtn_bf16 v0, v0, v1
; GFX12-GISEL-NEXT:    s_wait_dscnt 0x0
; GFX12-GISEL-NEXT:    global_inv scope:SCOPE_SYS
; GFX12-GISEL-NEXT:    s_setpc_b64 s[30:31]
  %ret = call <2 x i16> @llvm.amdgcn.ds.fadd.v2bf16(ptr addrspace(3) %ptr, <2 x i16> %data)
  ret <2 x i16> %ret
}

define amdgpu_kernel void @flat_atomic_fadd_v2f16_noret(ptr %ptr, <2 x half> %data) {
; GFX12-SDAG-LABEL: flat_atomic_fadd_v2f16_noret:
; GFX12-SDAG:       ; %bb.0:
; GFX12-SDAG-NEXT:    s_load_b96 s[0:2], s[0:1], 0x24
; GFX12-SDAG-NEXT:    s_wait_kmcnt 0x0
; GFX12-SDAG-NEXT:    v_dual_mov_b32 v0, s0 :: v_dual_mov_b32 v1, s1
; GFX12-SDAG-NEXT:    v_mov_b32_e32 v2, s2
; GFX12-SDAG-NEXT:    flat_atomic_pk_add_f16 v[0:1], v2
; GFX12-SDAG-NEXT:    s_endpgm
;
; GFX12-GISEL-LABEL: flat_atomic_fadd_v2f16_noret:
; GFX12-GISEL:       ; %bb.0:
; GFX12-GISEL-NEXT:    s_load_b96 s[0:2], s[0:1], 0x24
; GFX12-GISEL-NEXT:    s_wait_kmcnt 0x0
; GFX12-GISEL-NEXT:    v_dual_mov_b32 v0, s0 :: v_dual_mov_b32 v1, s1
; GFX12-GISEL-NEXT:    v_mov_b32_e32 v2, s2
; GFX12-GISEL-NEXT:    flat_atomic_pk_add_f16 v[0:1], v2
; GFX12-GISEL-NEXT:    s_endpgm
  %ret = call <2 x half> @llvm.amdgcn.flat.atomic.fadd.v2f16.p0.v2f16(ptr %ptr, <2 x half> %data)
  ret void
}

define <2 x half> @flat_atomic_fadd_v2f16_rtn(ptr %ptr, <2 x half> %data) {
; GFX12-SDAG-LABEL: flat_atomic_fadd_v2f16_rtn:
; GFX12-SDAG:       ; %bb.0:
; GFX12-SDAG-NEXT:    s_wait_loadcnt_dscnt 0x0
; GFX12-SDAG-NEXT:    s_wait_expcnt 0x0
; GFX12-SDAG-NEXT:    s_wait_samplecnt 0x0
; GFX12-SDAG-NEXT:    s_wait_bvhcnt 0x0
; GFX12-SDAG-NEXT:    s_wait_kmcnt 0x0
; GFX12-SDAG-NEXT:    flat_atomic_pk_add_f16 v0, v[0:1], v2 th:TH_ATOMIC_RETURN
; GFX12-SDAG-NEXT:    s_wait_loadcnt_dscnt 0x0
; GFX12-SDAG-NEXT:    s_setpc_b64 s[30:31]
;
; GFX12-GISEL-LABEL: flat_atomic_fadd_v2f16_rtn:
; GFX12-GISEL:       ; %bb.0:
; GFX12-GISEL-NEXT:    s_wait_loadcnt_dscnt 0x0
; GFX12-GISEL-NEXT:    s_wait_expcnt 0x0
; GFX12-GISEL-NEXT:    s_wait_samplecnt 0x0
; GFX12-GISEL-NEXT:    s_wait_bvhcnt 0x0
; GFX12-GISEL-NEXT:    s_wait_kmcnt 0x0
; GFX12-GISEL-NEXT:    flat_atomic_pk_add_f16 v0, v[0:1], v2 th:TH_ATOMIC_RETURN
; GFX12-GISEL-NEXT:    s_wait_loadcnt_dscnt 0x0
; GFX12-GISEL-NEXT:    s_setpc_b64 s[30:31]
  %ret = call <2 x half> @llvm.amdgcn.flat.atomic.fadd.v2f16.p0.v2f16(ptr %ptr, <2 x half> %data)
  ret <2 x half> %ret
}

define amdgpu_kernel void @flat_atomic_fadd_v2bf16_noret(ptr %ptr, <2 x i16> %data) {
; GFX12-SDAG-LABEL: flat_atomic_fadd_v2bf16_noret:
; GFX12-SDAG:       ; %bb.0:
; GFX12-SDAG-NEXT:    s_load_b96 s[0:2], s[0:1], 0x24
; GFX12-SDAG-NEXT:    s_wait_kmcnt 0x0
; GFX12-SDAG-NEXT:    v_dual_mov_b32 v0, s0 :: v_dual_mov_b32 v1, s1
; GFX12-SDAG-NEXT:    v_mov_b32_e32 v2, s2
; GFX12-SDAG-NEXT:    flat_atomic_pk_add_bf16 v[0:1], v2
; GFX12-SDAG-NEXT:    s_endpgm
;
; GFX12-GISEL-LABEL: flat_atomic_fadd_v2bf16_noret:
; GFX12-GISEL:       ; %bb.0:
; GFX12-GISEL-NEXT:    s_load_b96 s[0:2], s[0:1], 0x24
; GFX12-GISEL-NEXT:    s_wait_kmcnt 0x0
; GFX12-GISEL-NEXT:    v_dual_mov_b32 v0, s0 :: v_dual_mov_b32 v1, s1
; GFX12-GISEL-NEXT:    v_mov_b32_e32 v2, s2
; GFX12-GISEL-NEXT:    flat_atomic_pk_add_bf16 v[0:1], v2
; GFX12-GISEL-NEXT:    s_endpgm
  %ret = call <2 x i16> @llvm.amdgcn.flat.atomic.fadd.v2bf16.p0(ptr %ptr, <2 x i16> %data)
  ret void
}

define <2 x i16> @flat_atomic_fadd_v2bf16_rtn(ptr %ptr, <2 x i16> %data) {
; GFX12-SDAG-LABEL: flat_atomic_fadd_v2bf16_rtn:
; GFX12-SDAG:       ; %bb.0:
; GFX12-SDAG-NEXT:    s_wait_loadcnt_dscnt 0x0
; GFX12-SDAG-NEXT:    s_wait_expcnt 0x0
; GFX12-SDAG-NEXT:    s_wait_samplecnt 0x0
; GFX12-SDAG-NEXT:    s_wait_bvhcnt 0x0
; GFX12-SDAG-NEXT:    s_wait_kmcnt 0x0
; GFX12-SDAG-NEXT:    flat_atomic_pk_add_bf16 v0, v[0:1], v2 th:TH_ATOMIC_RETURN
; GFX12-SDAG-NEXT:    s_wait_loadcnt_dscnt 0x0
; GFX12-SDAG-NEXT:    s_setpc_b64 s[30:31]
;
; GFX12-GISEL-LABEL: flat_atomic_fadd_v2bf16_rtn:
; GFX12-GISEL:       ; %bb.0:
; GFX12-GISEL-NEXT:    s_wait_loadcnt_dscnt 0x0
; GFX12-GISEL-NEXT:    s_wait_expcnt 0x0
; GFX12-GISEL-NEXT:    s_wait_samplecnt 0x0
; GFX12-GISEL-NEXT:    s_wait_bvhcnt 0x0
; GFX12-GISEL-NEXT:    s_wait_kmcnt 0x0
; GFX12-GISEL-NEXT:    flat_atomic_pk_add_bf16 v0, v[0:1], v2 th:TH_ATOMIC_RETURN
; GFX12-GISEL-NEXT:    s_wait_loadcnt_dscnt 0x0
; GFX12-GISEL-NEXT:    s_setpc_b64 s[30:31]
  %ret = call <2 x i16> @llvm.amdgcn.flat.atomic.fadd.v2bf16.p0(ptr %ptr, <2 x i16> %data)
  ret <2 x i16> %ret
}

define amdgpu_kernel void @global_atomic_fadd_v2bf16_noret(ptr addrspace(1) %ptr, <2 x i16> %data) {
; GFX12-SDAG-LABEL: global_atomic_fadd_v2bf16_noret:
; GFX12-SDAG:       ; %bb.0:
; GFX12-SDAG-NEXT:    s_load_b96 s[0:2], s[0:1], 0x24
; GFX12-SDAG-NEXT:    s_wait_kmcnt 0x0
; GFX12-SDAG-NEXT:    v_dual_mov_b32 v0, 0 :: v_dual_mov_b32 v1, s2
; GFX12-SDAG-NEXT:    global_atomic_pk_add_bf16 v0, v1, s[0:1]
; GFX12-SDAG-NEXT:    s_nop 0
; GFX12-SDAG-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX12-SDAG-NEXT:    s_endpgm
;
; GFX12-GISEL-LABEL: global_atomic_fadd_v2bf16_noret:
; GFX12-GISEL:       ; %bb.0:
; GFX12-GISEL-NEXT:    s_load_b96 s[0:2], s[0:1], 0x24
; GFX12-GISEL-NEXT:    s_wait_kmcnt 0x0
; GFX12-GISEL-NEXT:    v_dual_mov_b32 v1, 0 :: v_dual_mov_b32 v0, s2
; GFX12-GISEL-NEXT:    global_atomic_pk_add_bf16 v1, v0, s[0:1]
; GFX12-GISEL-NEXT:    s_nop 0
; GFX12-GISEL-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX12-GISEL-NEXT:    s_endpgm
  %ret = call <2 x i16> @llvm.amdgcn.global.atomic.fadd.v2bf16.p1(ptr addrspace(1) %ptr, <2 x i16> %data)
  ret void
}

define <2 x i16> @global_atomic_fadd_v2bf16_rtn(ptr addrspace(1) %ptr, <2 x i16> %data) {
; GFX12-SDAG-LABEL: global_atomic_fadd_v2bf16_rtn:
; GFX12-SDAG:       ; %bb.0:
; GFX12-SDAG-NEXT:    s_wait_loadcnt_dscnt 0x0
; GFX12-SDAG-NEXT:    s_wait_expcnt 0x0
; GFX12-SDAG-NEXT:    s_wait_samplecnt 0x0
; GFX12-SDAG-NEXT:    s_wait_bvhcnt 0x0
; GFX12-SDAG-NEXT:    s_wait_kmcnt 0x0
; GFX12-SDAG-NEXT:    global_atomic_pk_add_bf16 v0, v[0:1], v2, off th:TH_ATOMIC_RETURN
; GFX12-SDAG-NEXT:    s_wait_loadcnt 0x0
; GFX12-SDAG-NEXT:    s_setpc_b64 s[30:31]
;
; GFX12-GISEL-LABEL: global_atomic_fadd_v2bf16_rtn:
; GFX12-GISEL:       ; %bb.0:
; GFX12-GISEL-NEXT:    s_wait_loadcnt_dscnt 0x0
; GFX12-GISEL-NEXT:    s_wait_expcnt 0x0
; GFX12-GISEL-NEXT:    s_wait_samplecnt 0x0
; GFX12-GISEL-NEXT:    s_wait_bvhcnt 0x0
; GFX12-GISEL-NEXT:    s_wait_kmcnt 0x0
; GFX12-GISEL-NEXT:    global_atomic_pk_add_bf16 v0, v[0:1], v2, off th:TH_ATOMIC_RETURN
; GFX12-GISEL-NEXT:    s_wait_loadcnt 0x0
; GFX12-GISEL-NEXT:    s_setpc_b64 s[30:31]
  %ret = call <2 x i16> @llvm.amdgcn.global.atomic.fadd.v2bf16.p1(ptr addrspace(1) %ptr, <2 x i16> %data)
  ret <2 x i16> %ret
}

define void @global_atomic_pk_add_v2f16(ptr addrspace(1) %ptr, <2 x half> %data) {
; GFX12-SDAG-LABEL: global_atomic_pk_add_v2f16:
; GFX12-SDAG:       ; %bb.0: ; %main_body
; GFX12-SDAG-NEXT:    s_wait_loadcnt_dscnt 0x0
; GFX12-SDAG-NEXT:    s_wait_expcnt 0x0
; GFX12-SDAG-NEXT:    s_wait_samplecnt 0x0
; GFX12-SDAG-NEXT:    s_wait_bvhcnt 0x0
; GFX12-SDAG-NEXT:    s_wait_kmcnt 0x0
; GFX12-SDAG-NEXT:    global_atomic_pk_add_f16 v[0:1], v2, off
; GFX12-SDAG-NEXT:    s_setpc_b64 s[30:31]
;
; GFX12-GISEL-LABEL: global_atomic_pk_add_v2f16:
; GFX12-GISEL:       ; %bb.0: ; %main_body
; GFX12-GISEL-NEXT:    s_wait_loadcnt_dscnt 0x0
; GFX12-GISEL-NEXT:    s_wait_expcnt 0x0
; GFX12-GISEL-NEXT:    s_wait_samplecnt 0x0
; GFX12-GISEL-NEXT:    s_wait_bvhcnt 0x0
; GFX12-GISEL-NEXT:    s_wait_kmcnt 0x0
; GFX12-GISEL-NEXT:    global_atomic_pk_add_f16 v[0:1], v2, off
; GFX12-GISEL-NEXT:    s_setpc_b64 s[30:31]
main_body:
  %ret = call <2 x half> @llvm.amdgcn.global.atomic.fadd.v2f16.p1.v2f16(ptr addrspace(1) %ptr, <2 x half> %data)
  ret void
}

define <2 x half> @global_atomic_pk_add_v2f16_rtn(ptr addrspace(1) %ptr, <2 x half> %data) {
; GFX12-SDAG-LABEL: global_atomic_pk_add_v2f16_rtn:
; GFX12-SDAG:       ; %bb.0: ; %main_body
; GFX12-SDAG-NEXT:    s_wait_loadcnt_dscnt 0x0
; GFX12-SDAG-NEXT:    s_wait_expcnt 0x0
; GFX12-SDAG-NEXT:    s_wait_samplecnt 0x0
; GFX12-SDAG-NEXT:    s_wait_bvhcnt 0x0
; GFX12-SDAG-NEXT:    s_wait_kmcnt 0x0
; GFX12-SDAG-NEXT:    global_atomic_pk_add_f16 v0, v[0:1], v2, off th:TH_ATOMIC_RETURN
; GFX12-SDAG-NEXT:    s_wait_loadcnt 0x0
; GFX12-SDAG-NEXT:    s_setpc_b64 s[30:31]
;
; GFX12-GISEL-LABEL: global_atomic_pk_add_v2f16_rtn:
; GFX12-GISEL:       ; %bb.0: ; %main_body
; GFX12-GISEL-NEXT:    s_wait_loadcnt_dscnt 0x0
; GFX12-GISEL-NEXT:    s_wait_expcnt 0x0
; GFX12-GISEL-NEXT:    s_wait_samplecnt 0x0
; GFX12-GISEL-NEXT:    s_wait_bvhcnt 0x0
; GFX12-GISEL-NEXT:    s_wait_kmcnt 0x0
; GFX12-GISEL-NEXT:    global_atomic_pk_add_f16 v0, v[0:1], v2, off th:TH_ATOMIC_RETURN
; GFX12-GISEL-NEXT:    s_wait_loadcnt 0x0
; GFX12-GISEL-NEXT:    s_setpc_b64 s[30:31]
main_body:
  %ret = call <2 x half> @llvm.amdgcn.global.atomic.fadd.v2f16.p1.v2f16(ptr addrspace(1) %ptr, <2 x half> %data)
  ret <2 x half> %ret
}

define amdgpu_ps void @raw_buffer_atomic_add_v2f16_noret_offset(<2 x half> %val, <4 x i32> inreg %rsrc, i32 %voffset, i32 inreg %soffset) {
; GFX12-SDAG-LABEL: raw_buffer_atomic_add_v2f16_noret_offset:
; GFX12-SDAG:       ; %bb.0:
; GFX12-SDAG-NEXT:    buffer_atomic_pk_add_f16 v0, off, s[0:3], s4 offset:92
; GFX12-SDAG-NEXT:    s_nop 0
; GFX12-SDAG-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX12-SDAG-NEXT:    s_endpgm
;
; GFX12-GISEL-LABEL: raw_buffer_atomic_add_v2f16_noret_offset:
; GFX12-GISEL:       ; %bb.0:
; GFX12-GISEL-NEXT:    buffer_atomic_pk_add_f16 v0, off, s[0:3], s4 offset:92
; GFX12-GISEL-NEXT:    s_nop 0
; GFX12-GISEL-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX12-GISEL-NEXT:    s_endpgm
  %ret = call <2 x half> @llvm.amdgcn.raw.buffer.atomic.fadd.v2f16(<2 x half> %val, <4 x i32> %rsrc, i32 92, i32 %soffset, i32 0)
  ret void
}

define amdgpu_ps void @raw_buffer_atomic_add_v2f16_noret(<2 x half> %val, <4 x i32> inreg %rsrc, i32 %voffset, i32 inreg %soffset) {
; GFX12-SDAG-LABEL: raw_buffer_atomic_add_v2f16_noret:
; GFX12-SDAG:       ; %bb.0:
; GFX12-SDAG-NEXT:    buffer_atomic_pk_add_f16 v0, v1, s[0:3], s4 offen
; GFX12-SDAG-NEXT:    s_nop 0
; GFX12-SDAG-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX12-SDAG-NEXT:    s_endpgm
;
; GFX12-GISEL-LABEL: raw_buffer_atomic_add_v2f16_noret:
; GFX12-GISEL:       ; %bb.0:
; GFX12-GISEL-NEXT:    buffer_atomic_pk_add_f16 v0, v1, s[0:3], s4 offen
; GFX12-GISEL-NEXT:    s_nop 0
; GFX12-GISEL-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX12-GISEL-NEXT:    s_endpgm
  %ret = call <2 x half> @llvm.amdgcn.raw.buffer.atomic.fadd.v2f16(<2 x half> %val, <4 x i32> %rsrc, i32 %voffset, i32 %soffset, i32 0)
  ret void
}

define amdgpu_ps <2 x half> @raw_buffer_atomic_add_v2f16_ret_offset(<2 x half> %val, <4 x i32> inreg %rsrc, i32 %voffset, i32 inreg %soffset) {
; GFX12-SDAG-LABEL: raw_buffer_atomic_add_v2f16_ret_offset:
; GFX12-SDAG:       ; %bb.0:
; GFX12-SDAG-NEXT:    buffer_atomic_pk_add_f16 v0, off, s[0:3], s4 offset:92 th:TH_ATOMIC_RETURN
; GFX12-SDAG-NEXT:    s_wait_loadcnt 0x0
; GFX12-SDAG-NEXT:    ; return to shader part epilog
;
; GFX12-GISEL-LABEL: raw_buffer_atomic_add_v2f16_ret_offset:
; GFX12-GISEL:       ; %bb.0:
; GFX12-GISEL-NEXT:    buffer_atomic_pk_add_f16 v0, off, s[0:3], s4 offset:92 th:TH_ATOMIC_RETURN
; GFX12-GISEL-NEXT:    s_wait_loadcnt 0x0
; GFX12-GISEL-NEXT:    ; return to shader part epilog
  %ret = call <2 x half> @llvm.amdgcn.raw.buffer.atomic.fadd.v2f16(<2 x half> %val, <4 x i32> %rsrc, i32 92, i32 %soffset, i32 0)
  ret <2 x half> %ret
}

define amdgpu_ps <2 x half> @raw_buffer_atomic_add_v2f16_ret(<2 x half> %val, <4 x i32> inreg %rsrc, i32 %voffset, i32 inreg %soffset) {
; GFX12-SDAG-LABEL: raw_buffer_atomic_add_v2f16_ret:
; GFX12-SDAG:       ; %bb.0:
; GFX12-SDAG-NEXT:    buffer_atomic_pk_add_f16 v0, v1, s[0:3], s4 offen th:TH_ATOMIC_RETURN
; GFX12-SDAG-NEXT:    s_wait_loadcnt 0x0
; GFX12-SDAG-NEXT:    ; return to shader part epilog
;
; GFX12-GISEL-LABEL: raw_buffer_atomic_add_v2f16_ret:
; GFX12-GISEL:       ; %bb.0:
; GFX12-GISEL-NEXT:    buffer_atomic_pk_add_f16 v0, v1, s[0:3], s4 offen th:TH_ATOMIC_RETURN
; GFX12-GISEL-NEXT:    s_wait_loadcnt 0x0
; GFX12-GISEL-NEXT:    ; return to shader part epilog
  %ret = call <2 x half> @llvm.amdgcn.raw.buffer.atomic.fadd.v2f16(<2 x half> %val, <4 x i32> %rsrc, i32 %voffset, i32 %soffset, i32 0)
  ret <2 x half> %ret
}

define amdgpu_ps float @struct_buffer_atomic_add_v2f16_ret(<2 x half> %val, <4 x i32> inreg %rsrc, i32 %vindex, i32 %voffset, i32 inreg %soffset) {
; GFX12-SDAG-LABEL: struct_buffer_atomic_add_v2f16_ret:
; GFX12-SDAG:       ; %bb.0:
; GFX12-SDAG-NEXT:    buffer_atomic_pk_add_f16 v0, v[1:2], s[0:3], s4 idxen offen th:TH_ATOMIC_RETURN
; GFX12-SDAG-NEXT:    s_wait_loadcnt 0x0
; GFX12-SDAG-NEXT:    ; return to shader part epilog
;
; GFX12-GISEL-LABEL: struct_buffer_atomic_add_v2f16_ret:
; GFX12-GISEL:       ; %bb.0:
; GFX12-GISEL-NEXT:    buffer_atomic_pk_add_f16 v0, v[1:2], s[0:3], s4 idxen offen th:TH_ATOMIC_RETURN
; GFX12-GISEL-NEXT:    s_wait_loadcnt 0x0
; GFX12-GISEL-NEXT:    ; return to shader part epilog
  %orig = call <2 x half> @llvm.amdgcn.struct.buffer.atomic.fadd.v2f16(<2 x half> %val, <4 x i32> %rsrc, i32 %vindex, i32 %voffset, i32 %soffset, i32 0)
  %r = bitcast <2 x half> %orig to float
  ret float %r
}

define amdgpu_ps void @struct_buffer_atomic_add_v2f16_noret(<2 x half> %val, <4 x i32> inreg %rsrc, i32 %vindex, i32 %voffset, i32 inreg %soffset) {
; GFX12-SDAG-LABEL: struct_buffer_atomic_add_v2f16_noret:
; GFX12-SDAG:       ; %bb.0:
; GFX12-SDAG-NEXT:    buffer_atomic_pk_add_f16 v0, v[1:2], s[0:3], s4 idxen offen
; GFX12-SDAG-NEXT:    s_nop 0
; GFX12-SDAG-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX12-SDAG-NEXT:    s_endpgm
;
; GFX12-GISEL-LABEL: struct_buffer_atomic_add_v2f16_noret:
; GFX12-GISEL:       ; %bb.0:
; GFX12-GISEL-NEXT:    buffer_atomic_pk_add_f16 v0, v[1:2], s[0:3], s4 idxen offen
; GFX12-GISEL-NEXT:    s_nop 0
; GFX12-GISEL-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX12-GISEL-NEXT:    s_endpgm
  %orig = call <2 x half> @llvm.amdgcn.struct.buffer.atomic.fadd.v2f16(<2 x half> %val, <4 x i32> %rsrc, i32 %vindex, i32 %voffset, i32 %soffset, i32 0)
  ret void
}

define amdgpu_ps float @struct_buffer_atomic_add_v2bf16_ret(<2 x bfloat> %val, <4 x i32> inreg %rsrc, i32 %vindex, i32 %voffset, i32 inreg %soffset) {
; GFX12-SDAG-LABEL: struct_buffer_atomic_add_v2bf16_ret:
; GFX12-SDAG:       ; %bb.0:
; GFX12-SDAG-NEXT:    buffer_atomic_pk_add_bf16 v0, v[1:2], s[0:3], s4 idxen offen th:TH_ATOMIC_RETURN
; GFX12-SDAG-NEXT:    v_mov_b32_e32 v1, 0
; GFX12-SDAG-NEXT:    v_mov_b32_e32 v2, 0
; GFX12-SDAG-NEXT:    s_wait_loadcnt 0x0
; GFX12-SDAG-NEXT:    flat_store_b32 v[1:2], v0
; GFX12-SDAG-NEXT:    v_mov_b32_e32 v0, 1.0
; GFX12-SDAG-NEXT:    s_wait_dscnt 0x0
; GFX12-SDAG-NEXT:    ; return to shader part epilog
;
; GFX12-GISEL-LABEL: struct_buffer_atomic_add_v2bf16_ret:
; GFX12-GISEL:       ; %bb.0:
; GFX12-GISEL-NEXT:    buffer_atomic_pk_add_bf16 v0, v[1:2], s[0:3], s4 idxen offen th:TH_ATOMIC_RETURN
; GFX12-GISEL-NEXT:    v_mov_b32_e32 v1, 0
; GFX12-GISEL-NEXT:    v_mov_b32_e32 v2, 0
; GFX12-GISEL-NEXT:    s_wait_loadcnt 0x0
; GFX12-GISEL-NEXT:    flat_store_b32 v[1:2], v0
; GFX12-GISEL-NEXT:    v_mov_b32_e32 v0, 1.0
; GFX12-GISEL-NEXT:    s_wait_dscnt 0x0
; GFX12-GISEL-NEXT:    ; return to shader part epilog
  %orig = call <2 x bfloat> @llvm.amdgcn.struct.buffer.atomic.fadd.v2bf16(<2 x bfloat> %val, <4 x i32> %rsrc, i32 %vindex, i32 %voffset, i32 %soffset, i32 0)
  store <2 x bfloat> %orig, ptr null
  ret float 1.0
}

define amdgpu_ps void @struct_buffer_atomic_add_v2bf16_noret(<2 x bfloat> %val, <4 x i32> inreg %rsrc, i32 %vindex, i32 %voffset, i32 inreg %soffset) {
; GFX12-SDAG-LABEL: struct_buffer_atomic_add_v2bf16_noret:
; GFX12-SDAG:       ; %bb.0:
; GFX12-SDAG-NEXT:    buffer_atomic_pk_add_bf16 v0, v[1:2], s[0:3], s4 idxen offen
; GFX12-SDAG-NEXT:    s_nop 0
; GFX12-SDAG-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX12-SDAG-NEXT:    s_endpgm
;
; GFX12-GISEL-LABEL: struct_buffer_atomic_add_v2bf16_noret:
; GFX12-GISEL:       ; %bb.0:
; GFX12-GISEL-NEXT:    buffer_atomic_pk_add_bf16 v0, v[1:2], s[0:3], s4 idxen offen
; GFX12-GISEL-NEXT:    s_nop 0
; GFX12-GISEL-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX12-GISEL-NEXT:    s_endpgm
  %orig = call <2 x bfloat> @llvm.amdgcn.struct.buffer.atomic.fadd.v2bf16(<2 x bfloat> %val, <4 x i32> %rsrc, i32 %vindex, i32 %voffset, i32 %soffset, i32 0)
  ret void
}

define amdgpu_ps void @raw_buffer_atomic_add_v2bf16(<2 x bfloat> %val, <4 x i32> inreg %rsrc, i32 %voffset, i32 inreg %soffset) {
; GFX12-SDAG-LABEL: raw_buffer_atomic_add_v2bf16:
; GFX12-SDAG:       ; %bb.0:
; GFX12-SDAG-NEXT:    buffer_atomic_pk_add_bf16 v0, v1, s[0:3], s4 offen
; GFX12-SDAG-NEXT:    s_nop 0
; GFX12-SDAG-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX12-SDAG-NEXT:    s_endpgm
;
; GFX12-GISEL-LABEL: raw_buffer_atomic_add_v2bf16:
; GFX12-GISEL:       ; %bb.0:
; GFX12-GISEL-NEXT:    buffer_atomic_pk_add_bf16 v0, v1, s[0:3], s4 offen
; GFX12-GISEL-NEXT:    s_nop 0
; GFX12-GISEL-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX12-GISEL-NEXT:    s_endpgm
  %ret = call <2 x bfloat> @llvm.amdgcn.raw.buffer.atomic.fadd.v2bf16(<2 x bfloat> %val, <4 x i32> %rsrc, i32 %voffset, i32 %soffset, i32 0)
  ret void
}

define amdgpu_ps float @raw_buffer_atomic_add_v2bf16_ret(<2 x bfloat> %val, <4 x i32> inreg %rsrc, i32 %voffset, i32 inreg %soffset) {
; GFX12-SDAG-LABEL: raw_buffer_atomic_add_v2bf16_ret:
; GFX12-SDAG:       ; %bb.0:
; GFX12-SDAG-NEXT:    buffer_atomic_pk_add_bf16 v0, v1, s[0:3], s4 offen th:TH_ATOMIC_RETURN
; GFX12-SDAG-NEXT:    v_mov_b32_e32 v1, 0
; GFX12-SDAG-NEXT:    v_mov_b32_e32 v2, 0
; GFX12-SDAG-NEXT:    s_wait_loadcnt 0x0
; GFX12-SDAG-NEXT:    flat_store_b32 v[1:2], v0
; GFX12-SDAG-NEXT:    v_mov_b32_e32 v0, 1.0
; GFX12-SDAG-NEXT:    s_wait_dscnt 0x0
; GFX12-SDAG-NEXT:    ; return to shader part epilog
;
; GFX12-GISEL-LABEL: raw_buffer_atomic_add_v2bf16_ret:
; GFX12-GISEL:       ; %bb.0:
; GFX12-GISEL-NEXT:    buffer_atomic_pk_add_bf16 v0, v1, s[0:3], s4 offen th:TH_ATOMIC_RETURN
; GFX12-GISEL-NEXT:    v_mov_b32_e32 v1, 0
; GFX12-GISEL-NEXT:    v_mov_b32_e32 v2, 0
; GFX12-GISEL-NEXT:    s_wait_loadcnt 0x0
; GFX12-GISEL-NEXT:    flat_store_b32 v[1:2], v0
; GFX12-GISEL-NEXT:    v_mov_b32_e32 v0, 1.0
; GFX12-GISEL-NEXT:    s_wait_dscnt 0x0
; GFX12-GISEL-NEXT:    ; return to shader part epilog
  %orig = call <2 x bfloat> @llvm.amdgcn.raw.buffer.atomic.fadd.v2bf16(<2 x bfloat> %val, <4 x i32> %rsrc, i32 %voffset, i32 %soffset, i32 0)
  store <2 x bfloat> %orig, ptr null
  ret float 1.0
}
