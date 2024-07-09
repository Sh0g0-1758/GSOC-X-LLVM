; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN:  llc -mtriple=amdgcn -mcpu=gfx1010 -global-isel=1 -verify-machineinstrs < %s | FileCheck -allow-deprecated-dag-overlap -check-prefixes=GFX10 %s
; RUN:  llc -mtriple=amdgcn -mcpu=gfx1100 -global-isel=1 -verify-machineinstrs < %s | FileCheck -allow-deprecated-dag-overlap -check-prefixes=GFX11 %s
declare i32 @llvm.amdgcn.workitem.id.x()

; A 64-bit multiplication where no arguments were zero extended.
define amdgpu_kernel void @v_mul_i64_no_zext(ptr addrspace(1) %out, ptr addrspace(1) %aptr, ptr addrspace(1) %bptr) nounwind {
; GFX10-LABEL: v_mul_i64_no_zext:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x2c
; GFX10-NEXT:    v_lshlrev_b32_e32 v7, 3, v0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_clause 0x1
; GFX10-NEXT:    global_load_dwordx2 v[0:1], v7, s[0:1]
; GFX10-NEXT:    global_load_dwordx2 v[2:3], v7, s[2:3]
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    v_mad_u64_u32 v[4:5], s0, v0, v2, 0
; GFX10-NEXT:    v_mad_u64_u32 v[5:6], s0, v0, v3, v[5:6]
; GFX10-NEXT:    v_mad_u64_u32 v[0:1], s0, v1, v2, v[5:6]
; GFX10-NEXT:    v_mov_b32_e32 v5, v0
; GFX10-NEXT:    global_store_dwordx2 v7, v[4:5], s[2:3]
; GFX10-NEXT:    s_endpgm
;
; GFX11-LABEL: v_mul_i64_no_zext:
; GFX11:       ; %bb.0:
; GFX11-NEXT:    s_load_b128 s[0:3], s[0:1], 0x2c
; GFX11-NEXT:    v_lshlrev_b32_e32 v9, 3, v0
; GFX11-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-NEXT:    s_clause 0x1
; GFX11-NEXT:    global_load_b64 v[0:1], v9, s[0:1]
; GFX11-NEXT:    global_load_b64 v[2:3], v9, s[2:3]
; GFX11-NEXT:    s_waitcnt vmcnt(0)
; GFX11-NEXT:    v_mad_u64_u32 v[4:5], null, v0, v2, 0
; GFX11-NEXT:    s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
; GFX11-NEXT:    v_mad_u64_u32 v[6:7], null, v0, v3, v[5:6]
; GFX11-NEXT:    v_mad_u64_u32 v[7:8], null, v1, v2, v[6:7]
; GFX11-NEXT:    s_delay_alu instid0(VALU_DEP_1)
; GFX11-NEXT:    v_mov_b32_e32 v5, v7
; GFX11-NEXT:    global_store_b64 v9, v[4:5], s[2:3]
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %gep.a = getelementptr inbounds i64, ptr addrspace(1) %aptr, i32 %tid
  %gep.b = getelementptr inbounds i64, ptr addrspace(1) %bptr, i32 %tid
  %gep.out = getelementptr inbounds i64, ptr addrspace(1) %bptr, i32 %tid
  %a = load i64, ptr addrspace(1) %gep.a
  %b = load i64, ptr addrspace(1) %gep.b
  %mul = mul i64 %a, %b
  store i64 %mul, ptr addrspace(1) %gep.out
  ret void
}

; a 64 bit multiplication where the second argument was zero extended.
define amdgpu_kernel void @v_mul_i64_zext_src1(ptr addrspace(1) %out, ptr addrspace(1) %aptr, ptr addrspace(1) %bptr) {
; GFX10-LABEL: v_mul_i64_zext_src1:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_clause 0x1
; GFX10-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX10-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x34
; GFX10-NEXT:    v_lshlrev_b32_e32 v2, 3, v0
; GFX10-NEXT:    v_lshlrev_b32_e32 v3, 2, v0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    global_load_dwordx2 v[0:1], v2, s[6:7]
; GFX10-NEXT:    global_load_dword v4, v3, s[2:3]
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    v_mad_u64_u32 v[2:3], s0, v0, v4, 0
; GFX10-NEXT:    v_mov_b32_e32 v0, v3
; GFX10-NEXT:    v_mad_u64_u32 v[0:1], s0, v1, v4, v[0:1]
; GFX10-NEXT:    v_mov_b32_e32 v3, v0
; GFX10-NEXT:    v_mov_b32_e32 v0, 0
; GFX10-NEXT:    global_store_dwordx2 v0, v[2:3], s[4:5]
; GFX10-NEXT:    s_endpgm
;
; GFX11-LABEL: v_mul_i64_zext_src1:
; GFX11:       ; %bb.0:
; GFX11-NEXT:    s_clause 0x1
; GFX11-NEXT:    s_load_b128 s[4:7], s[0:1], 0x24
; GFX11-NEXT:    s_load_b64 s[0:1], s[0:1], 0x34
; GFX11-NEXT:    v_lshlrev_b32_e32 v1, 3, v0
; GFX11-NEXT:    v_lshlrev_b32_e32 v2, 2, v0
; GFX11-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-NEXT:    global_load_b64 v[0:1], v1, s[6:7]
; GFX11-NEXT:    global_load_b32 v5, v2, s[0:1]
; GFX11-NEXT:    s_waitcnt vmcnt(0)
; GFX11-NEXT:    v_mad_u64_u32 v[2:3], null, v0, v5, 0
; GFX11-NEXT:    s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
; GFX11-NEXT:    v_mov_b32_e32 v0, v3
; GFX11-NEXT:    v_mad_u64_u32 v[3:4], null, v1, v5, v[0:1]
; GFX11-NEXT:    v_mov_b32_e32 v0, 0
; GFX11-NEXT:    global_store_b64 v0, v[2:3], s[4:5]
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %gep.a = getelementptr inbounds i64, ptr addrspace(1) %aptr, i32 %tid
  %gep.b = getelementptr inbounds i32, ptr addrspace(1) %bptr, i32 %tid
  %a = load i64, ptr addrspace(1) %gep.a
  %b = load i32, ptr addrspace(1) %gep.b
  %b_ext = zext i32 %b to i64
  %mul = mul i64 %a, %b_ext
  store i64 %mul, ptr addrspace(1) %out
  ret void
}

; 64 bit multiplication where the first argument was zero extended.
define amdgpu_kernel void @v_mul_i64_zext_src0(ptr addrspace(1) %out, ptr addrspace(1) %aptr, ptr addrspace(1) %bptr) {
; GFX10-LABEL: v_mul_i64_zext_src0:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_clause 0x1
; GFX10-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX10-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x34
; GFX10-NEXT:    v_lshlrev_b32_e32 v2, 2, v0
; GFX10-NEXT:    v_lshlrev_b32_e32 v3, 3, v0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    global_load_dword v4, v2, s[6:7]
; GFX10-NEXT:    global_load_dwordx2 v[0:1], v3, s[2:3]
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    v_mad_u64_u32 v[2:3], s0, v4, v0, 0
; GFX10-NEXT:    v_mov_b32_e32 v0, v3
; GFX10-NEXT:    v_mad_u64_u32 v[0:1], s0, v4, v1, v[0:1]
; GFX10-NEXT:    v_mov_b32_e32 v3, v0
; GFX10-NEXT:    v_mov_b32_e32 v0, 0
; GFX10-NEXT:    global_store_dwordx2 v0, v[2:3], s[4:5]
; GFX10-NEXT:    s_endpgm
;
; GFX11-LABEL: v_mul_i64_zext_src0:
; GFX11:       ; %bb.0:
; GFX11-NEXT:    s_clause 0x1
; GFX11-NEXT:    s_load_b128 s[4:7], s[0:1], 0x24
; GFX11-NEXT:    s_load_b64 s[0:1], s[0:1], 0x34
; GFX11-NEXT:    v_lshlrev_b32_e32 v1, 2, v0
; GFX11-NEXT:    v_lshlrev_b32_e32 v0, 3, v0
; GFX11-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-NEXT:    global_load_b32 v5, v1, s[6:7]
; GFX11-NEXT:    global_load_b64 v[0:1], v0, s[0:1]
; GFX11-NEXT:    s_waitcnt vmcnt(0)
; GFX11-NEXT:    v_mad_u64_u32 v[2:3], null, v5, v0, 0
; GFX11-NEXT:    s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
; GFX11-NEXT:    v_mov_b32_e32 v0, v3
; GFX11-NEXT:    v_mad_u64_u32 v[3:4], null, v5, v1, v[0:1]
; GFX11-NEXT:    v_mov_b32_e32 v0, 0
; GFX11-NEXT:    global_store_b64 v0, v[2:3], s[4:5]
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %gep.a = getelementptr inbounds i32, ptr addrspace(1) %aptr, i32 %tid
  %gep.b = getelementptr inbounds i64, ptr addrspace(1) %bptr, i32 %tid
  %a = load i32, ptr addrspace(1) %gep.a
  %b = load i64, ptr addrspace(1) %gep.b
  %a_ext = zext i32 %a to i64
  %mul = mul i64 %a_ext, %b
  store i64 %mul, ptr addrspace(1) %out
  ret void
}

; 64-bit multiplication where both arguments were zero extended.
define amdgpu_kernel void @v_mul_i64_zext_src0_src1(ptr addrspace(1) %out, ptr addrspace(1) %aptr, ptr addrspace(1) %bptr) {
; GFX10-LABEL: v_mul_i64_zext_src0_src1:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_clause 0x1
; GFX10-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX10-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x34
; GFX10-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_clause 0x1
; GFX10-NEXT:    global_load_dword v1, v0, s[6:7]
; GFX10-NEXT:    global_load_dword v2, v0, s[2:3]
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    v_mad_u64_u32 v[0:1], s0, v1, v2, 0
; GFX10-NEXT:    v_mov_b32_e32 v2, 0
; GFX10-NEXT:    global_store_dwordx2 v2, v[0:1], s[4:5]
; GFX10-NEXT:    s_endpgm
;
; GFX11-LABEL: v_mul_i64_zext_src0_src1:
; GFX11:       ; %bb.0:
; GFX11-NEXT:    s_clause 0x1
; GFX11-NEXT:    s_load_b128 s[4:7], s[0:1], 0x24
; GFX11-NEXT:    s_load_b64 s[0:1], s[0:1], 0x34
; GFX11-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX11-NEXT:    v_mov_b32_e32 v2, 0
; GFX11-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-NEXT:    s_clause 0x1
; GFX11-NEXT:    global_load_b32 v1, v0, s[6:7]
; GFX11-NEXT:    global_load_b32 v0, v0, s[0:1]
; GFX11-NEXT:    s_waitcnt vmcnt(0)
; GFX11-NEXT:    v_mad_u64_u32 v[0:1], null, v1, v0, 0
; GFX11-NEXT:    global_store_b64 v2, v[0:1], s[4:5]
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %gep.a = getelementptr inbounds i32, ptr addrspace(1) %aptr, i32 %tid
  %gep.b = getelementptr inbounds i32, ptr addrspace(1) %bptr, i32 %tid
  %a = load i32, ptr addrspace(1) %gep.a
  %b = load i32, ptr addrspace(1) %gep.b
  %a_ext = zext i32 %a to i64
  %b_ext = zext i32 %b to i64
  %mul = mul i64 %a_ext, %b_ext
  store i64 %mul, ptr addrspace(1) %out
  ret void
}

; 64-bit multiplication where the upper bytes of the first argument were masked.
define amdgpu_kernel void @v_mul_i64_masked_src0_hi(ptr addrspace(1) %out, ptr addrspace(1) %aptr, ptr addrspace(1) %bptr) {
; GFX10-LABEL: v_mul_i64_masked_src0_hi:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_clause 0x1
; GFX10-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX10-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x34
; GFX10-NEXT:    v_lshlrev_b32_e32 v2, 3, v0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_clause 0x1
; GFX10-NEXT:    global_load_dword v4, v2, s[6:7]
; GFX10-NEXT:    global_load_dwordx2 v[0:1], v2, s[2:3]
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    v_mad_u64_u32 v[2:3], s0, v4, v0, 0
; GFX10-NEXT:    v_mov_b32_e32 v0, v3
; GFX10-NEXT:    v_mad_u64_u32 v[0:1], s0, v4, v1, v[0:1]
; GFX10-NEXT:    v_mov_b32_e32 v3, v0
; GFX10-NEXT:    v_mov_b32_e32 v0, 0
; GFX10-NEXT:    global_store_dwordx2 v0, v[2:3], s[4:5]
; GFX10-NEXT:    s_endpgm
;
; GFX11-LABEL: v_mul_i64_masked_src0_hi:
; GFX11:       ; %bb.0:
; GFX11-NEXT:    s_clause 0x1
; GFX11-NEXT:    s_load_b128 s[4:7], s[0:1], 0x24
; GFX11-NEXT:    s_load_b64 s[0:1], s[0:1], 0x34
; GFX11-NEXT:    v_lshlrev_b32_e32 v0, 3, v0
; GFX11-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-NEXT:    s_clause 0x1
; GFX11-NEXT:    global_load_b32 v5, v0, s[6:7]
; GFX11-NEXT:    global_load_b64 v[0:1], v0, s[0:1]
; GFX11-NEXT:    s_waitcnt vmcnt(0)
; GFX11-NEXT:    v_mad_u64_u32 v[2:3], null, v5, v0, 0
; GFX11-NEXT:    s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
; GFX11-NEXT:    v_mov_b32_e32 v0, v3
; GFX11-NEXT:    v_mad_u64_u32 v[3:4], null, v5, v1, v[0:1]
; GFX11-NEXT:    v_mov_b32_e32 v0, 0
; GFX11-NEXT:    global_store_b64 v0, v[2:3], s[4:5]
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
 %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %gep.a = getelementptr inbounds i64, ptr addrspace(1) %aptr, i32 %tid
  %gep.b = getelementptr inbounds i64, ptr addrspace(1) %bptr, i32 %tid
  %a = load i64, ptr addrspace(1) %gep.a
  %b = load i64, ptr addrspace(1) %gep.b
  %a_and = and i64 %a, u0x00000000FFFFFFFF
  %mul = mul i64 %a_and, %b
  store i64 %mul, ptr addrspace(1) %out
  ret void
}

; 64-bit multiplication where lower bytes of first argument were masked.
define amdgpu_kernel void @v_mul_i64_masked_src0_lo(ptr addrspace(1) %out, ptr addrspace(1) %aptr, ptr addrspace(1) %bptr) {
; GFX10-LABEL: v_mul_i64_masked_src0_lo:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_clause 0x1
; GFX10-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX10-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x34
; GFX10-NEXT:    v_lshlrev_b32_e32 v4, 3, v0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_clause 0x1
; GFX10-NEXT:    global_load_dwordx2 v[0:1], v4, s[6:7]
; GFX10-NEXT:    global_load_dwordx2 v[2:3], v4, s[2:3]
; GFX10-NEXT:    s_waitcnt vmcnt(1)
; GFX10-NEXT:    v_mov_b32_e32 v0, 0
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    v_mul_lo_u32 v1, v1, v2
; GFX10-NEXT:    global_store_dwordx2 v0, v[0:1], s[4:5]
; GFX10-NEXT:    s_endpgm
;
; GFX11-LABEL: v_mul_i64_masked_src0_lo:
; GFX11:       ; %bb.0:
; GFX11-NEXT:    s_clause 0x1
; GFX11-NEXT:    s_load_b128 s[4:7], s[0:1], 0x24
; GFX11-NEXT:    s_load_b64 s[0:1], s[0:1], 0x34
; GFX11-NEXT:    v_lshlrev_b32_e32 v2, 3, v0
; GFX11-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-NEXT:    s_clause 0x1
; GFX11-NEXT:    global_load_b64 v[0:1], v2, s[6:7]
; GFX11-NEXT:    global_load_b64 v[2:3], v2, s[0:1]
; GFX11-NEXT:    s_waitcnt vmcnt(1)
; GFX11-NEXT:    v_mov_b32_e32 v0, 0
; GFX11-NEXT:    s_waitcnt vmcnt(0)
; GFX11-NEXT:    v_mul_lo_u32 v1, v1, v2
; GFX11-NEXT:    global_store_b64 v0, v[0:1], s[4:5]
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %gep.a = getelementptr inbounds i64, ptr addrspace(1) %aptr, i32 %tid
  %gep.b = getelementptr inbounds i64, ptr addrspace(1) %bptr, i32 %tid
  %a = load i64, ptr addrspace(1) %gep.a
  %b = load i64, ptr addrspace(1) %gep.b
  %a_and = and i64 %a, u0xFFFFFFFF00000000
  %mul = mul i64 %a_and, %b
  store i64 %mul, ptr addrspace(1) %out
  ret void
}

; 64-bit multiplication where the lower bytes of the second argument were masked.
define amdgpu_kernel void @v_mul_i64_masked_src1_lo(ptr addrspace(1) %out, ptr addrspace(1) %aptr, ptr addrspace(1) %bptr) {
; GFX10-LABEL: v_mul_i64_masked_src1_lo:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_clause 0x1
; GFX10-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX10-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x34
; GFX10-NEXT:    v_lshlrev_b32_e32 v3, 3, v0
; GFX10-NEXT:    ; kill: killed $vgpr3
; GFX10-NEXT:    ; kill: killed $sgpr6_sgpr7
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_clause 0x1
; GFX10-NEXT:    global_load_dwordx2 v[0:1], v3, s[6:7]
; GFX10-NEXT:    global_load_dwordx2 v[1:2], v3, s[2:3]
; GFX10-NEXT:    ; kill: killed $sgpr2_sgpr3
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    v_mul_lo_u32 v1, v0, v2
; GFX10-NEXT:    v_mov_b32_e32 v0, 0
; GFX10-NEXT:    global_store_dwordx2 v0, v[0:1], s[4:5]
; GFX10-NEXT:    s_endpgm
;
; GFX11-LABEL: v_mul_i64_masked_src1_lo:
; GFX11:       ; %bb.0:
; GFX11-NEXT:    s_clause 0x1
; GFX11-NEXT:    s_load_b128 s[4:7], s[0:1], 0x24
; GFX11-NEXT:    s_load_b64 s[0:1], s[0:1], 0x34
; GFX11-NEXT:    v_lshlrev_b32_e32 v2, 3, v0
; GFX11-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-NEXT:    s_clause 0x1
; GFX11-NEXT:    global_load_b64 v[0:1], v2, s[6:7]
; GFX11-NEXT:    global_load_b64 v[1:2], v2, s[0:1]
; GFX11-NEXT:    s_waitcnt vmcnt(0)
; GFX11-NEXT:    v_mul_lo_u32 v1, v0, v2
; GFX11-NEXT:    v_mov_b32_e32 v0, 0
; GFX11-NEXT:    global_store_b64 v0, v[0:1], s[4:5]
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %gep.a = getelementptr inbounds i64, ptr addrspace(1) %aptr, i32 %tid
  %gep.b = getelementptr inbounds i64, ptr addrspace(1) %bptr, i32 %tid
  %a = load i64, ptr addrspace(1) %gep.a
  %b = load i64, ptr addrspace(1) %gep.b
  %b_and = and i64 %b, u0xFFFFFFFF00000000
  %mul = mul i64 %a, %b_and
  store i64 %mul, ptr addrspace(1) %out
  ret void
}

; 64-bit multiplication where the entire first argument is masked.
define amdgpu_kernel void @v_mul_i64_masked_src0(ptr addrspace(1) %out, ptr addrspace(1) %aptr, ptr addrspace(1) %bptr) {
; GFX10-LABEL: v_mul_i64_masked_src0:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GFX10-NEXT:    v_mov_b32_e32 v0, 0
; GFX10-NEXT:    v_mov_b32_e32 v1, 0
; GFX10-NEXT:    v_mov_b32_e32 v2, 0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    global_store_dwordx2 v2, v[0:1], s[0:1]
; GFX10-NEXT:    s_endpgm
;
; GFX11-LABEL: v_mul_i64_masked_src0:
; GFX11:       ; %bb.0:
; GFX11-NEXT:    s_load_b64 s[0:1], s[0:1], 0x24
; GFX11-NEXT:    v_mov_b32_e32 v0, 0
; GFX11-NEXT:    v_dual_mov_b32 v1, 0 :: v_dual_mov_b32 v2, 0
; GFX11-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-NEXT:    global_store_b64 v2, v[0:1], s[0:1]
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %gep.a = getelementptr inbounds i64, ptr addrspace(1) %aptr, i32 %tid
  %gep.b = getelementptr inbounds i64, ptr addrspace(1) %bptr, i32 %tid
  %a = load i64, ptr addrspace(1) %gep.a
  %b = load i64, ptr addrspace(1) %gep.b
  %a_and = and i64 %a, u0x0000000000000000
  %mul = mul i64 %a_and, %b
  store i64 %mul, ptr addrspace(1) %out
  ret void
}

; 64-bit multiplication where the parts of the high and low bytes of the first argument are masked.
define amdgpu_kernel void @v_mul_i64_partially_masked_src0(ptr addrspace(1) %out, ptr addrspace(1) %aptr, ptr addrspace(1) %bptr) {
; GFX10-LABEL: v_mul_i64_partially_masked_src0:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_clause 0x1
; GFX10-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX10-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x34
; GFX10-NEXT:    v_lshlrev_b32_e32 v4, 3, v0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_clause 0x1
; GFX10-NEXT:    global_load_dwordx2 v[0:1], v4, s[6:7]
; GFX10-NEXT:    global_load_dwordx2 v[2:3], v4, s[2:3]
; GFX10-NEXT:    s_waitcnt vmcnt(1)
; GFX10-NEXT:    v_and_b32_e32 v6, 0xfff00000, v0
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    v_mad_u64_u32 v[4:5], s0, v6, v2, 0
; GFX10-NEXT:    v_mov_b32_e32 v0, v5
; GFX10-NEXT:    v_mad_u64_u32 v[5:6], s0, v6, v3, v[0:1]
; GFX10-NEXT:    v_and_b32_e32 v0, 0xf00f, v1
; GFX10-NEXT:    v_mad_u64_u32 v[0:1], s0, v0, v2, v[5:6]
; GFX10-NEXT:    v_mov_b32_e32 v5, v0
; GFX10-NEXT:    v_mov_b32_e32 v0, 0
; GFX10-NEXT:    global_store_dwordx2 v0, v[4:5], s[4:5]
; GFX10-NEXT:    s_endpgm
;
; GFX11-LABEL: v_mul_i64_partially_masked_src0:
; GFX11:       ; %bb.0:
; GFX11-NEXT:    s_clause 0x1
; GFX11-NEXT:    s_load_b128 s[4:7], s[0:1], 0x24
; GFX11-NEXT:    s_load_b64 s[0:1], s[0:1], 0x34
; GFX11-NEXT:    v_lshlrev_b32_e32 v2, 3, v0
; GFX11-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-NEXT:    s_clause 0x1
; GFX11-NEXT:    global_load_b64 v[0:1], v2, s[6:7]
; GFX11-NEXT:    global_load_b64 v[2:3], v2, s[0:1]
; GFX11-NEXT:    s_waitcnt vmcnt(1)
; GFX11-NEXT:    v_and_b32_e32 v7, 0xfff00000, v0
; GFX11-NEXT:    s_waitcnt vmcnt(0)
; GFX11-NEXT:    s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
; GFX11-NEXT:    v_mad_u64_u32 v[4:5], null, v7, v2, 0
; GFX11-NEXT:    v_mov_b32_e32 v0, v5
; GFX11-NEXT:    s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
; GFX11-NEXT:    v_mad_u64_u32 v[5:6], null, v7, v3, v[0:1]
; GFX11-NEXT:    v_and_b32_e32 v3, 0xf00f, v1
; GFX11-NEXT:    v_mad_u64_u32 v[0:1], null, v3, v2, v[5:6]
; GFX11-NEXT:    s_delay_alu instid0(VALU_DEP_1)
; GFX11-NEXT:    v_dual_mov_b32 v5, v0 :: v_dual_mov_b32 v0, 0
; GFX11-NEXT:    global_store_b64 v0, v[4:5], s[4:5]
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %gep.a = getelementptr inbounds i64, ptr addrspace(1) %aptr, i32 %tid
  %gep.b = getelementptr inbounds i64, ptr addrspace(1) %bptr, i32 %tid
  %a = load i64, ptr addrspace(1) %gep.a
  %b = load i64, ptr addrspace(1) %gep.b
  %a_and = and i64 %a, u0x0000F00FFFF00000
  %mul = mul i64 %a_and, %b
  store i64 %mul, ptr addrspace(1) %out
  ret void
}

; 64-bit multiplication, where the first argument is masked before a branch
define amdgpu_kernel void @v_mul64_masked_before_branch(ptr addrspace(1) %out, ptr addrspace(1) %aptr, ptr addrspace(1) %bptr) {
; GFX10-LABEL: v_mul64_masked_before_branch:
; GFX10:       ; %bb.0: ; %entry
; GFX10-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GFX10-NEXT:    v_mov_b32_e32 v0, 0
; GFX10-NEXT:    v_mov_b32_e32 v1, 0
; GFX10-NEXT:    v_mov_b32_e32 v2, 0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    global_store_dwordx2 v2, v[0:1], s[0:1]
; GFX10-NEXT:    s_endpgm
;
; GFX11-LABEL: v_mul64_masked_before_branch:
; GFX11:       ; %bb.0: ; %entry
; GFX11-NEXT:    s_load_b64 s[0:1], s[0:1], 0x24
; GFX11-NEXT:    v_mov_b32_e32 v0, 0
; GFX11-NEXT:    v_dual_mov_b32 v1, 0 :: v_dual_mov_b32 v2, 0
; GFX11-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-NEXT:    global_store_b64 v2, v[0:1], s[0:1]
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
entry:
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %gep.a = getelementptr inbounds i64, ptr addrspace(1) %aptr, i32 %tid
  %gep.b = getelementptr inbounds i64, ptr addrspace(1) %bptr, i32 %tid
  %a = load i64, ptr addrspace(1) %gep.a
  %b = load i64, ptr addrspace(1) %gep.b
  %a_and = and i64 %a, u0x0000000000000000
  %0 = icmp eq i64 %b, 0
  br i1 %0, label %if, label %else

if:
  %b_and = and i64 %b, u0xFFFFFFFF00000000
  %1 = mul i64 %a_and, %b_and
  br label %endif

else:
  %2 = mul i64 %a_and, %b
  br label %endif

endif:
  %3 = phi i64 [%1, %if], [%2, %else]
  store i64 %3, ptr addrspace(1) %out
  ret void
}

; 64-bit multiplication with both arguments changed in different basic blocks.
define amdgpu_kernel void @v_mul64_masked_before_and_in_branch(ptr addrspace(1) %out, ptr addrspace(1) %aptr, ptr addrspace(1) %bptr) {
; GFX10-LABEL: v_mul64_masked_before_and_in_branch:
; GFX10:       ; %bb.0: ; %entry
; GFX10-NEXT:    s_clause 0x1
; GFX10-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX10-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x34
; GFX10-NEXT:    v_lshlrev_b32_e32 v0, 3, v0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_clause 0x1
; GFX10-NEXT:    global_load_dwordx2 v[2:3], v0, s[6:7]
; GFX10-NEXT:    global_load_dwordx2 v[4:5], v0, s[2:3]
; GFX10-NEXT:    ; implicit-def: $vgpr0_vgpr1
; GFX10-NEXT:    s_waitcnt vmcnt(1)
; GFX10-NEXT:    v_cmp_ge_u64_e32 vcc_lo, 0, v[2:3]
; GFX10-NEXT:    s_and_saveexec_b32 s0, vcc_lo
; GFX10-NEXT:    s_xor_b32 s0, exec_lo, s0
; GFX10-NEXT:    s_cbranch_execz .LBB10_2
; GFX10-NEXT:  ; %bb.1: ; %else
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    v_mad_u64_u32 v[0:1], s1, v2, v4, 0
; GFX10-NEXT:    v_mad_u64_u32 v[1:2], s1, v2, v5, v[1:2]
; GFX10-NEXT:    ; implicit-def: $vgpr2_vgpr3
; GFX10-NEXT:    ; implicit-def: $vgpr4_vgpr5
; GFX10-NEXT:  .LBB10_2: ; %Flow
; GFX10-NEXT:    s_andn2_saveexec_b32 s0, s0
; GFX10-NEXT:    s_cbranch_execz .LBB10_4
; GFX10-NEXT:  ; %bb.3: ; %if
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    v_mul_lo_u32 v1, v2, v5
; GFX10-NEXT:    v_mov_b32_e32 v0, 0
; GFX10-NEXT:  .LBB10_4: ; %endif
; GFX10-NEXT:    s_or_b32 exec_lo, exec_lo, s0
; GFX10-NEXT:    v_mov_b32_e32 v2, 0
; GFX10-NEXT:    global_store_dwordx2 v2, v[0:1], s[4:5]
; GFX10-NEXT:    s_endpgm
;
; GFX11-LABEL: v_mul64_masked_before_and_in_branch:
; GFX11:       ; %bb.0: ; %entry
; GFX11-NEXT:    s_clause 0x1
; GFX11-NEXT:    s_load_b128 s[4:7], s[0:1], 0x24
; GFX11-NEXT:    s_load_b64 s[0:1], s[0:1], 0x34
; GFX11-NEXT:    v_lshlrev_b32_e32 v0, 3, v0
; GFX11-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-NEXT:    s_clause 0x1
; GFX11-NEXT:    global_load_b64 v[2:3], v0, s[6:7]
; GFX11-NEXT:    global_load_b64 v[4:5], v0, s[0:1]
; GFX11-NEXT:    s_mov_b32 s0, exec_lo
; GFX11-NEXT:    ; implicit-def: $vgpr0_vgpr1
; GFX11-NEXT:    s_waitcnt vmcnt(1)
; GFX11-NEXT:    v_cmpx_ge_u64_e32 0, v[2:3]
; GFX11-NEXT:    s_xor_b32 s0, exec_lo, s0
; GFX11-NEXT:    s_cbranch_execz .LBB10_2
; GFX11-NEXT:  ; %bb.1: ; %else
; GFX11-NEXT:    s_waitcnt vmcnt(0)
; GFX11-NEXT:    v_mad_u64_u32 v[0:1], null, v2, v4, 0
; GFX11-NEXT:    s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
; GFX11-NEXT:    v_mad_u64_u32 v[3:4], null, v2, v5, v[1:2]
; GFX11-NEXT:    ; implicit-def: $vgpr4_vgpr5
; GFX11-NEXT:    v_mov_b32_e32 v1, v3
; GFX11-NEXT:    ; implicit-def: $vgpr2_vgpr3
; GFX11-NEXT:  .LBB10_2: ; %Flow
; GFX11-NEXT:    s_and_not1_saveexec_b32 s0, s0
; GFX11-NEXT:    s_cbranch_execz .LBB10_4
; GFX11-NEXT:  ; %bb.3: ; %if
; GFX11-NEXT:    s_waitcnt vmcnt(0)
; GFX11-NEXT:    v_mul_lo_u32 v1, v2, v5
; GFX11-NEXT:    v_mov_b32_e32 v0, 0
; GFX11-NEXT:  .LBB10_4: ; %endif
; GFX11-NEXT:    s_or_b32 exec_lo, exec_lo, s0
; GFX11-NEXT:    v_mov_b32_e32 v2, 0
; GFX11-NEXT:    global_store_b64 v2, v[0:1], s[4:5]
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
entry:
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %gep.a = getelementptr inbounds i64, ptr addrspace(1) %aptr, i32 %tid
  %gep.b = getelementptr inbounds i64, ptr addrspace(1) %bptr, i32 %tid
  %a = load i64, ptr addrspace(1) %gep.a
  %b = load i64, ptr addrspace(1) %gep.b
  %a_and = and i64 %a, u0x00000000FFFFFFFF
  %0 = icmp ugt i64 %a, 0
  br i1 %0, label %if, label %else

if:
  %b_and = and i64 %b, u0xFFFFFFFF00000000
  %1 = mul i64 %a_and, %b_and
  br label %endif

else:
  %2 = mul i64 %a_and, %b
  br label %endif

endif:
  %3 = phi i64 [%1, %if], [%2, %else]
  store i64 %3, ptr addrspace(1) %out
  ret void
}


