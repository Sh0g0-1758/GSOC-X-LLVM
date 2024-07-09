; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn -mcpu=gfx1100 -mattr=+wavefrontsize32,-wavefrontsize64 -verify-machineinstrs < %s | FileCheck %s --check-prefix=W32

declare <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.f16.v8f32.v16f16(<16 x half>, <16 x half> , <8 x float>)
declare <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16>, <16 x i16> , <8 x float>)
declare <16 x half> @llvm.amdgcn.wmma.f16.16x16x16.f16.v16f16.v16f16(<16 x half>, <16 x half> , <16 x half>, i1 immarg)
declare <16 x i16> @llvm.amdgcn.wmma.bf16.16x16x16.bf16.v16i16.v16i16(<16 x i16>, <16 x i16> , <16 x i16>, i1 immarg)
declare <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu8.v8i32.v4i32(i1 immarg, <4 x i32>, i1 immarg, <4 x i32> , <8 x i32>, i1 immarg)
declare <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu4.v8i32.v2i32(i1 immarg, <2 x i32>, i1 immarg, <2 x i32> , <8 x i32>, i1 immarg)

; The tests demonstrate that the following WMMA register constraints are satisfied.
;
; v_wmma D, A, B, C
; A and B cannot overlap with D. C cannot partially overlap with D, but it is OK for them to be the same (which is a typical case).
;
; In each test,
;   - first wmma instruction: the dest register D is different than all the sources
;   - second wmma instruction: the dest register D and src2 (C) are the same


; @llvm.amdgcn.wmma.f32.16x16x16.f16

define amdgpu_ps void @test_wmma_f32_16x16x16_f16(<16 x half> %A, <16 x half> %B, <8 x float> %C, ptr addrspace(1) %out, ptr addrspace(1) %out2) {
; W32-LABEL: test_wmma_f32_16x16x16_f16:
; W32:       ; %bb.0: ; %bb
; W32-NEXT:    v_wmma_f32_16x16x16_f16 v[28:35], v[0:7], v[8:15], v[16:23]
; W32-NEXT:    v_wmma_f32_16x16x16_f16 v[16:23], v[8:15], v[8:15], v[16:23]
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[24:25], v[32:35], off offset:16
; W32-NEXT:    global_store_b128 v[24:25], v[28:31], off
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[26:27], v[20:23], off offset:16
; W32-NEXT:    global_store_b128 v[26:27], v[16:19], off
; W32-NEXT:    s_nop 0
; W32-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; W32-NEXT:    s_endpgm
bb:
  %res = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.f16.v8f32.v16f16(<16 x half> %A, <16 x half> %B, <8 x float> %C)
  %res2 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.f16.v8f32.v16f16(<16 x half> %B, <16 x half> %B, <8 x float> %C)
  store <8 x float> %res, ptr addrspace(1) %out, align 32
  store <8 x float> %res2, ptr addrspace(1) %out2, align 32
  ret void
}

; @llvm.amdgcn.wmma.f32.16x16x16.bf16

define amdgpu_ps void @test_wmma_f32_16x16x16_bf16(<16 x i16> %A, <16 x i16> %B, <8 x float> %C, ptr addrspace(1) %out, ptr addrspace(1) %out2) {
; W32-LABEL: test_wmma_f32_16x16x16_bf16:
; W32:       ; %bb.0: ; %bb
; W32-NEXT:    v_wmma_f32_16x16x16_bf16 v[28:35], v[0:7], v[8:15], v[16:23]
; W32-NEXT:    v_wmma_f32_16x16x16_bf16 v[16:23], v[8:15], v[8:15], v[16:23]
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[24:25], v[32:35], off offset:16
; W32-NEXT:    global_store_b128 v[24:25], v[28:31], off
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[26:27], v[20:23], off offset:16
; W32-NEXT:    global_store_b128 v[26:27], v[16:19], off
; W32-NEXT:    s_nop 0
; W32-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; W32-NEXT:    s_endpgm
bb:
  %res = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %A, <16 x i16> %B, <8 x float> %C)
  %res2 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %B, <16 x i16> %B, <8 x float> %C)
  store <8 x float> %res, ptr addrspace(1) %out, align 32
  store <8 x float> %res2, ptr addrspace(1) %out2, align 32
  ret void
}

; @llvm.amdgcn.wmma.f16.16x16x16.f16

define amdgpu_ps void @test_wmma_f16_16x16x16_f16_lo(<16 x half> %A, <16 x half> %B, <16 x half> %C, ptr addrspace(1) %out, ptr addrspace(1) %out2) {
; W32-LABEL: test_wmma_f16_16x16x16_f16_lo:
; W32:       ; %bb.0: ; %bb
; W32-NEXT:    v_wmma_f16_16x16x16_f16 v[28:35], v[0:7], v[8:15], v[16:23]
; W32-NEXT:    v_wmma_f16_16x16x16_f16 v[16:23], v[8:15], v[8:15], v[16:23]
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[24:25], v[32:35], off offset:16
; W32-NEXT:    global_store_b128 v[24:25], v[28:31], off
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[26:27], v[20:23], off offset:16
; W32-NEXT:    global_store_b128 v[26:27], v[16:19], off
; W32-NEXT:    s_nop 0
; W32-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; W32-NEXT:    s_endpgm
bb:
  %res = call <16 x half> @llvm.amdgcn.wmma.f16.16x16x16.f16.v16f16.v16f16(<16 x half> %A, <16 x half> %B, <16 x half> %C, i1 0)
  %res2 = call <16 x half> @llvm.amdgcn.wmma.f16.16x16x16.f16.v16f16.v16f16(<16 x half> %B, <16 x half> %B, <16 x half> %C, i1 0)
  store <16 x half> %res, ptr addrspace(1) %out, align 32
  store <16 x half> %res2, ptr addrspace(1) %out2, align 32
  ret void
}

define amdgpu_ps void @test_wmma_f16_16x16x16_f16_hi(<16 x half> %A, <16 x half> %B, <16 x half> %C, ptr addrspace(1) %out, ptr addrspace(1) %out2) {
; W32-LABEL: test_wmma_f16_16x16x16_f16_hi:
; W32:       ; %bb.0: ; %bb
; W32-NEXT:    v_wmma_f16_16x16x16_f16 v[28:35], v[0:7], v[8:15], v[16:23] op_sel:[0,0,1]
; W32-NEXT:    v_wmma_f16_16x16x16_f16 v[16:23], v[8:15], v[8:15], v[16:23] op_sel:[0,0,1]
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[24:25], v[32:35], off offset:16
; W32-NEXT:    global_store_b128 v[24:25], v[28:31], off
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[26:27], v[20:23], off offset:16
; W32-NEXT:    global_store_b128 v[26:27], v[16:19], off
; W32-NEXT:    s_nop 0
; W32-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; W32-NEXT:    s_endpgm
bb:
  %res = call <16 x half> @llvm.amdgcn.wmma.f16.16x16x16.f16.v16f16.v16f16(<16 x half> %A, <16 x half> %B, <16 x half> %C, i1 1)
  %res2 = call <16 x half> @llvm.amdgcn.wmma.f16.16x16x16.f16.v16f16.v16f16(<16 x half> %B, <16 x half> %B, <16 x half> %C, i1 1)
  store <16 x half> %res, ptr addrspace(1) %out, align 32
  store <16 x half> %res2, ptr addrspace(1) %out2, align 32
  ret void
}

; @llvm.amdgcn.wmma.bf16.16x16x16.bf16

define amdgpu_ps void @test_wmma_bf16_16x16x16_bf16_lo(<16 x i16> %A, <16 x i16> %B, <16 x i16> %C, ptr addrspace(1) %out, ptr addrspace(1) %out2) {
; W32-LABEL: test_wmma_bf16_16x16x16_bf16_lo:
; W32:       ; %bb.0: ; %bb
; W32-NEXT:    v_wmma_bf16_16x16x16_bf16 v[28:35], v[0:7], v[8:15], v[16:23]
; W32-NEXT:    v_wmma_bf16_16x16x16_bf16 v[16:23], v[8:15], v[8:15], v[16:23]
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[24:25], v[32:35], off offset:16
; W32-NEXT:    global_store_b128 v[24:25], v[28:31], off
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[26:27], v[20:23], off offset:16
; W32-NEXT:    global_store_b128 v[26:27], v[16:19], off
; W32-NEXT:    s_nop 0
; W32-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; W32-NEXT:    s_endpgm
bb:
  %res = call <16 x i16> @llvm.amdgcn.wmma.bf16.16x16x16.bf16.v16i16.v16i16(<16 x i16> %A, <16 x i16> %B, <16 x i16> %C, i1 0)
  %res2 = call <16 x i16> @llvm.amdgcn.wmma.bf16.16x16x16.bf16.v16i16.v16i16(<16 x i16> %B, <16 x i16> %B, <16 x i16> %C, i1 0)
  store <16 x i16> %res, ptr addrspace(1) %out, align 32
  store <16 x i16> %res2, ptr addrspace(1) %out2, align 32
  ret void
}

define amdgpu_ps void @test_wmma_bf16_16x16x16_bf16_hi(<16 x i16> %A, <16 x i16> %B, <16 x i16> %C, ptr addrspace(1) %out, ptr addrspace(1) %out2) {
; W32-LABEL: test_wmma_bf16_16x16x16_bf16_hi:
; W32:       ; %bb.0: ; %bb
; W32-NEXT:    v_wmma_bf16_16x16x16_bf16 v[28:35], v[0:7], v[8:15], v[16:23] op_sel:[0,0,1]
; W32-NEXT:    v_wmma_bf16_16x16x16_bf16 v[16:23], v[8:15], v[8:15], v[16:23] op_sel:[0,0,1]
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[24:25], v[32:35], off offset:16
; W32-NEXT:    global_store_b128 v[24:25], v[28:31], off
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[26:27], v[20:23], off offset:16
; W32-NEXT:    global_store_b128 v[26:27], v[16:19], off
; W32-NEXT:    s_nop 0
; W32-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; W32-NEXT:    s_endpgm
bb:
  %res = call <16 x i16> @llvm.amdgcn.wmma.bf16.16x16x16.bf16.v16i16.v16i16(<16 x i16> %A, <16 x i16> %B, <16 x i16> %C, i1 1)
  %res2 = call <16 x i16> @llvm.amdgcn.wmma.bf16.16x16x16.bf16.v16i16.v16i16(<16 x i16> %B, <16 x i16> %B, <16 x i16> %C, i1 1)
  store <16 x i16> %res, ptr addrspace(1) %out, align 32
  store <16 x i16> %res2, ptr addrspace(1) %out2, align 32
  ret void
}

; @llvm.amdgcn.wmma.i32.16x16x16.iu8

define amdgpu_ps void @test_wmma_i32_16x16x16_ui8_unsigned_unsigned(<4 x i32> %A, <4 x i32> %B, <8 x i32> %C, ptr addrspace(1) %out, ptr addrspace(1) %out2) {
; W32-LABEL: test_wmma_i32_16x16x16_ui8_unsigned_unsigned:
; W32:       ; %bb.0: ; %bb
; W32-NEXT:    v_wmma_i32_16x16x16_iu8 v[20:27], v[0:3], v[4:7], v[8:15]
; W32-NEXT:    v_wmma_i32_16x16x16_iu8 v[8:15], v[4:7], v[4:7], v[8:15]
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[16:17], v[24:27], off offset:16
; W32-NEXT:    global_store_b128 v[16:17], v[20:23], off
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[18:19], v[12:15], off offset:16
; W32-NEXT:    global_store_b128 v[18:19], v[8:11], off
; W32-NEXT:    s_nop 0
; W32-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; W32-NEXT:    s_endpgm
bb:
  %res = call <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu8.v8i32.v4i32(i1 0, <4 x i32> %A, i1 0, <4 x i32> %B, <8 x i32> %C, i1 0)
  %res2 = call <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu8.v8i32.v4i32(i1 0, <4 x i32> %B, i1 0, <4 x i32> %B, <8 x i32> %C, i1 0)
  store <8 x i32> %res, ptr addrspace(1) %out, align 32
  store <8 x i32> %res2, ptr addrspace(1) %out2, align 32
  ret void
}

define amdgpu_ps void @test_wmma_i32_16x16x16_ui8_unsigned_signed(<4 x i32> %A, <4 x i32> %B, <8 x i32> %C, ptr addrspace(1) %out, ptr addrspace(1) %out2) {
; W32-LABEL: test_wmma_i32_16x16x16_ui8_unsigned_signed:
; W32:       ; %bb.0: ; %bb
; W32-NEXT:    v_wmma_i32_16x16x16_iu8 v[20:27], v[0:3], v[4:7], v[8:15] neg_lo:[0,1,0]
; W32-NEXT:    v_wmma_i32_16x16x16_iu8 v[8:15], v[4:7], v[4:7], v[8:15] neg_lo:[0,1,0]
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[16:17], v[24:27], off offset:16
; W32-NEXT:    global_store_b128 v[16:17], v[20:23], off
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[18:19], v[12:15], off offset:16
; W32-NEXT:    global_store_b128 v[18:19], v[8:11], off
; W32-NEXT:    s_nop 0
; W32-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; W32-NEXT:    s_endpgm
bb:
  %res = call <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu8.v8i32.v4i32(i1 0, <4 x i32> %A, i1 1, <4 x i32> %B, <8 x i32> %C, i1 0)
  %res2 = call <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu8.v8i32.v4i32(i1 0, <4 x i32> %B, i1 1, <4 x i32> %B, <8 x i32> %C, i1 0)
  store <8 x i32> %res, ptr addrspace(1) %out, align 32
  store <8 x i32> %res2, ptr addrspace(1) %out2, align 32
  ret void
}

define amdgpu_ps void @test_wmma_i32_16x16x16_ui8_signed_unsigned(<4 x i32> %A, <4 x i32> %B, <8 x i32> %C, ptr addrspace(1) %out, ptr addrspace(1) %out2) {
; W32-LABEL: test_wmma_i32_16x16x16_ui8_signed_unsigned:
; W32:       ; %bb.0: ; %bb
; W32-NEXT:    v_wmma_i32_16x16x16_iu8 v[20:27], v[0:3], v[4:7], v[8:15] neg_lo:[1,0,0]
; W32-NEXT:    v_wmma_i32_16x16x16_iu8 v[8:15], v[4:7], v[4:7], v[8:15] neg_lo:[1,0,0]
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[16:17], v[24:27], off offset:16
; W32-NEXT:    global_store_b128 v[16:17], v[20:23], off
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[18:19], v[12:15], off offset:16
; W32-NEXT:    global_store_b128 v[18:19], v[8:11], off
; W32-NEXT:    s_nop 0
; W32-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; W32-NEXT:    s_endpgm
bb:
  %res = call <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu8.v8i32.v4i32(i1 1, <4 x i32> %A, i1 0, <4 x i32> %B, <8 x i32> %C, i1 0)
  %res2 = call <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu8.v8i32.v4i32(i1 1, <4 x i32> %B, i1 0, <4 x i32> %B, <8 x i32> %C, i1 0)
  store <8 x i32> %res, ptr addrspace(1) %out, align 32
  store <8 x i32> %res2, ptr addrspace(1) %out2, align 32
  ret void
}

define amdgpu_ps void @test_wmma_i32_16x16x16_ui8_signed_signed(<4 x i32> %A, <4 x i32> %B, <8 x i32> %C, ptr addrspace(1) %out, ptr addrspace(1) %out2) {
; W32-LABEL: test_wmma_i32_16x16x16_ui8_signed_signed:
; W32:       ; %bb.0: ; %bb
; W32-NEXT:    v_wmma_i32_16x16x16_iu8 v[20:27], v[0:3], v[4:7], v[8:15] neg_lo:[1,1,0]
; W32-NEXT:    v_wmma_i32_16x16x16_iu8 v[8:15], v[4:7], v[4:7], v[8:15] neg_lo:[1,1,0]
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[16:17], v[24:27], off offset:16
; W32-NEXT:    global_store_b128 v[16:17], v[20:23], off
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[18:19], v[12:15], off offset:16
; W32-NEXT:    global_store_b128 v[18:19], v[8:11], off
; W32-NEXT:    s_nop 0
; W32-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; W32-NEXT:    s_endpgm
bb:
  %res = call <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu8.v8i32.v4i32(i1 1, <4 x i32> %A, i1 1, <4 x i32> %B, <8 x i32> %C, i1 0)
  %res2 = call <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu8.v8i32.v4i32(i1 1, <4 x i32> %B, i1 1, <4 x i32> %B, <8 x i32> %C, i1 0)
  store <8 x i32> %res, ptr addrspace(1) %out, align 32
  store <8 x i32> %res2, ptr addrspace(1) %out2, align 32
  ret void
}

define amdgpu_ps void @test_wmma_i32_16x16x16_ui8_unsigned_unsigned_clamp(<4 x i32> %A, <4 x i32> %B, <8 x i32> %C, ptr addrspace(1) %out, ptr addrspace(1) %out2) {
; W32-LABEL: test_wmma_i32_16x16x16_ui8_unsigned_unsigned_clamp:
; W32:       ; %bb.0: ; %bb
; W32-NEXT:    v_wmma_i32_16x16x16_iu8 v[20:27], v[0:3], v[4:7], v[8:15] clamp
; W32-NEXT:    v_wmma_i32_16x16x16_iu8 v[8:15], v[4:7], v[4:7], v[8:15] clamp
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[16:17], v[24:27], off offset:16
; W32-NEXT:    global_store_b128 v[16:17], v[20:23], off
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[18:19], v[12:15], off offset:16
; W32-NEXT:    global_store_b128 v[18:19], v[8:11], off
; W32-NEXT:    s_nop 0
; W32-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; W32-NEXT:    s_endpgm
bb:
  %res = call <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu8.v8i32.v4i32(i1 0, <4 x i32> %A, i1 0, <4 x i32> %B, <8 x i32> %C, i1 1)
  %res2 = call <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu8.v8i32.v4i32(i1 0, <4 x i32> %B, i1 0, <4 x i32> %B, <8 x i32> %C, i1 1)
  store <8 x i32> %res, ptr addrspace(1) %out, align 32
  store <8 x i32> %res2, ptr addrspace(1) %out2, align 32
  ret void
}

define amdgpu_ps void @test_wmma_i32_16x16x16_ui8_unsigned_signed_clamp(<4 x i32> %A, <4 x i32> %B, <8 x i32> %C, ptr addrspace(1) %out, ptr addrspace(1) %out2) {
; W32-LABEL: test_wmma_i32_16x16x16_ui8_unsigned_signed_clamp:
; W32:       ; %bb.0: ; %bb
; W32-NEXT:    v_wmma_i32_16x16x16_iu8 v[20:27], v[0:3], v[4:7], v[8:15] neg_lo:[0,1,0] clamp
; W32-NEXT:    v_wmma_i32_16x16x16_iu8 v[8:15], v[4:7], v[4:7], v[8:15] neg_lo:[0,1,0] clamp
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[16:17], v[24:27], off offset:16
; W32-NEXT:    global_store_b128 v[16:17], v[20:23], off
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[18:19], v[12:15], off offset:16
; W32-NEXT:    global_store_b128 v[18:19], v[8:11], off
; W32-NEXT:    s_nop 0
; W32-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; W32-NEXT:    s_endpgm
bb:
  %res = call <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu8.v8i32.v4i32(i1 0, <4 x i32> %A, i1 1, <4 x i32> %B, <8 x i32> %C, i1 1)
  %res2 = call <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu8.v8i32.v4i32(i1 0, <4 x i32> %B, i1 1, <4 x i32> %B, <8 x i32> %C, i1 1)
  store <8 x i32> %res, ptr addrspace(1) %out, align 32
  store <8 x i32> %res2, ptr addrspace(1) %out2, align 32
  ret void
}

define amdgpu_ps void @test_wmma_i32_16x16x16_ui8_signed_unsigned_clamp(<4 x i32> %A, <4 x i32> %B, <8 x i32> %C, ptr addrspace(1) %out, ptr addrspace(1) %out2) {
; W32-LABEL: test_wmma_i32_16x16x16_ui8_signed_unsigned_clamp:
; W32:       ; %bb.0: ; %bb
; W32-NEXT:    v_wmma_i32_16x16x16_iu8 v[20:27], v[0:3], v[4:7], v[8:15] neg_lo:[1,0,0] clamp
; W32-NEXT:    v_wmma_i32_16x16x16_iu8 v[8:15], v[4:7], v[4:7], v[8:15] neg_lo:[1,0,0] clamp
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[16:17], v[24:27], off offset:16
; W32-NEXT:    global_store_b128 v[16:17], v[20:23], off
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[18:19], v[12:15], off offset:16
; W32-NEXT:    global_store_b128 v[18:19], v[8:11], off
; W32-NEXT:    s_nop 0
; W32-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; W32-NEXT:    s_endpgm
bb:
  %res = call <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu8.v8i32.v4i32(i1 1, <4 x i32> %A, i1 0, <4 x i32> %B, <8 x i32> %C, i1 1)
  %res2 = call <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu8.v8i32.v4i32(i1 1, <4 x i32> %B, i1 0, <4 x i32> %B, <8 x i32> %C, i1 1)
  store <8 x i32> %res, ptr addrspace(1) %out, align 32
  store <8 x i32> %res2, ptr addrspace(1) %out2, align 32
  ret void
}

define amdgpu_ps void @test_wmma_i32_16x16x16_ui8_signed_signed_clamp(<4 x i32> %A, <4 x i32> %B, <8 x i32> %C, ptr addrspace(1) %out, ptr addrspace(1) %out2) {
; W32-LABEL: test_wmma_i32_16x16x16_ui8_signed_signed_clamp:
; W32:       ; %bb.0: ; %bb
; W32-NEXT:    v_wmma_i32_16x16x16_iu8 v[20:27], v[0:3], v[4:7], v[8:15] neg_lo:[1,1,0] clamp
; W32-NEXT:    v_wmma_i32_16x16x16_iu8 v[8:15], v[4:7], v[4:7], v[8:15] neg_lo:[1,1,0] clamp
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[16:17], v[24:27], off offset:16
; W32-NEXT:    global_store_b128 v[16:17], v[20:23], off
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[18:19], v[12:15], off offset:16
; W32-NEXT:    global_store_b128 v[18:19], v[8:11], off
; W32-NEXT:    s_nop 0
; W32-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; W32-NEXT:    s_endpgm
bb:
  %res = call <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu8.v8i32.v4i32(i1 1, <4 x i32> %A, i1 1, <4 x i32> %B, <8 x i32> %C, i1 1)
  %res2 = call <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu8.v8i32.v4i32(i1 1, <4 x i32> %B, i1 1, <4 x i32> %B, <8 x i32> %C, i1 1)
  store <8 x i32> %res, ptr addrspace(1) %out, align 32
  store <8 x i32> %res2, ptr addrspace(1) %out2, align 32
  ret void
}

; @llvm.amdgcn.wmma.i32.16x16x16.iu4

define amdgpu_ps void @test_wmma_i32_16x16x16_ui4_unsigned_unsigned(<2 x i32> %A, <2 x i32> %B, <8 x i32> %C, ptr addrspace(1) %out, ptr addrspace(1) %out2) {
; W32-LABEL: test_wmma_i32_16x16x16_ui4_unsigned_unsigned:
; W32:       ; %bb.0: ; %bb
; W32-NEXT:    v_wmma_i32_16x16x16_iu4 v[16:23], v[0:1], v[2:3], v[4:11]
; W32-NEXT:    v_wmma_i32_16x16x16_iu4 v[4:11], v[2:3], v[2:3], v[4:11]
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[12:13], v[20:23], off offset:16
; W32-NEXT:    global_store_b128 v[12:13], v[16:19], off
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[14:15], v[8:11], off offset:16
; W32-NEXT:    global_store_b128 v[14:15], v[4:7], off
; W32-NEXT:    s_nop 0
; W32-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; W32-NEXT:    s_endpgm
bb:
  %res = call <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu4.v8i32.v2i32(i1 0, <2 x i32> %A, i1 0, <2 x i32> %B, <8 x i32> %C, i1 0)
  %res2 = call <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu4.v8i32.v2i32(i1 0, <2 x i32> %B, i1 0, <2 x i32> %B, <8 x i32> %C, i1 0)
  store <8 x i32> %res, ptr addrspace(1) %out, align 32
  store <8 x i32> %res2, ptr addrspace(1) %out2, align 32
  ret void
}

define amdgpu_ps void @test_wmma_i32_16x16x16_ui4_unsigned_signed(<2 x i32> %A, <2 x i32> %B, <8 x i32> %C, ptr addrspace(1) %out, ptr addrspace(1) %out2) {
; W32-LABEL: test_wmma_i32_16x16x16_ui4_unsigned_signed:
; W32:       ; %bb.0: ; %bb
; W32-NEXT:    v_wmma_i32_16x16x16_iu4 v[16:23], v[0:1], v[2:3], v[4:11] neg_lo:[0,1,0]
; W32-NEXT:    v_wmma_i32_16x16x16_iu4 v[4:11], v[2:3], v[2:3], v[4:11] neg_lo:[0,1,0]
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[12:13], v[20:23], off offset:16
; W32-NEXT:    global_store_b128 v[12:13], v[16:19], off
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[14:15], v[8:11], off offset:16
; W32-NEXT:    global_store_b128 v[14:15], v[4:7], off
; W32-NEXT:    s_nop 0
; W32-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; W32-NEXT:    s_endpgm
bb:
  %res = call <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu4.v8i32.v2i32(i1 0, <2 x i32> %A, i1 1, <2 x i32> %B, <8 x i32> %C, i1 0)
  %res2 = call <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu4.v8i32.v2i32(i1 0, <2 x i32> %B, i1 1, <2 x i32> %B, <8 x i32> %C, i1 0)
  store <8 x i32> %res, ptr addrspace(1) %out, align 32
  store <8 x i32> %res2, ptr addrspace(1) %out2, align 32
  ret void
}

define amdgpu_ps void @test_wmma_i32_16x16x16_ui4_signed_unsigned(<2 x i32> %A, <2 x i32> %B, <8 x i32> %C, ptr addrspace(1) %out, ptr addrspace(1) %out2) {
; W32-LABEL: test_wmma_i32_16x16x16_ui4_signed_unsigned:
; W32:       ; %bb.0: ; %bb
; W32-NEXT:    v_wmma_i32_16x16x16_iu4 v[16:23], v[0:1], v[2:3], v[4:11] neg_lo:[1,0,0]
; W32-NEXT:    v_wmma_i32_16x16x16_iu4 v[4:11], v[2:3], v[2:3], v[4:11] neg_lo:[1,0,0]
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[12:13], v[20:23], off offset:16
; W32-NEXT:    global_store_b128 v[12:13], v[16:19], off
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[14:15], v[8:11], off offset:16
; W32-NEXT:    global_store_b128 v[14:15], v[4:7], off
; W32-NEXT:    s_nop 0
; W32-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; W32-NEXT:    s_endpgm
bb:
  %res = call <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu4.v8i32.v2i32(i1 1, <2 x i32> %A, i1 0, <2 x i32> %B, <8 x i32> %C, i1 0)
  %res2 = call <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu4.v8i32.v2i32(i1 1, <2 x i32> %B, i1 0, <2 x i32> %B, <8 x i32> %C, i1 0)
  store <8 x i32> %res, ptr addrspace(1) %out, align 32
  store <8 x i32> %res2, ptr addrspace(1) %out2, align 32
  ret void
}

define amdgpu_ps void @test_wmma_i32_16x16x16_ui4_signed_signed(<2 x i32> %A, <2 x i32> %B, <8 x i32> %C, ptr addrspace(1) %out, ptr addrspace(1) %out2) {
; W32-LABEL: test_wmma_i32_16x16x16_ui4_signed_signed:
; W32:       ; %bb.0: ; %bb
; W32-NEXT:    v_wmma_i32_16x16x16_iu4 v[16:23], v[0:1], v[2:3], v[4:11] neg_lo:[1,1,0]
; W32-NEXT:    v_wmma_i32_16x16x16_iu4 v[4:11], v[2:3], v[2:3], v[4:11] neg_lo:[1,1,0]
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[12:13], v[20:23], off offset:16
; W32-NEXT:    global_store_b128 v[12:13], v[16:19], off
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[14:15], v[8:11], off offset:16
; W32-NEXT:    global_store_b128 v[14:15], v[4:7], off
; W32-NEXT:    s_nop 0
; W32-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; W32-NEXT:    s_endpgm
bb:
  %res = call <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu4.v8i32.v2i32(i1 1, <2 x i32> %A, i1 1, <2 x i32> %B, <8 x i32> %C, i1 0)
  %res2 = call <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu4.v8i32.v2i32(i1 1, <2 x i32> %B, i1 1, <2 x i32> %B, <8 x i32> %C, i1 0)
  store <8 x i32> %res, ptr addrspace(1) %out, align 32
  store <8 x i32> %res2, ptr addrspace(1) %out2, align 32
  ret void
}


define amdgpu_ps void @test_wmma_i32_16x16x16_ui4_unsigned_unsigned_clamp(<2 x i32> %A, <2 x i32> %B, <8 x i32> %C, ptr addrspace(1) %out, ptr addrspace(1) %out2) {
; W32-LABEL: test_wmma_i32_16x16x16_ui4_unsigned_unsigned_clamp:
; W32:       ; %bb.0: ; %bb
; W32-NEXT:    v_wmma_i32_16x16x16_iu4 v[16:23], v[0:1], v[2:3], v[4:11] clamp
; W32-NEXT:    v_wmma_i32_16x16x16_iu4 v[4:11], v[2:3], v[2:3], v[4:11] clamp
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[12:13], v[20:23], off offset:16
; W32-NEXT:    global_store_b128 v[12:13], v[16:19], off
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[14:15], v[8:11], off offset:16
; W32-NEXT:    global_store_b128 v[14:15], v[4:7], off
; W32-NEXT:    s_nop 0
; W32-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; W32-NEXT:    s_endpgm
bb:
  %res = call <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu4.v8i32.v2i32(i1 0, <2 x i32> %A, i1 0, <2 x i32> %B, <8 x i32> %C, i1 1)
  %res2 = call <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu4.v8i32.v2i32(i1 0, <2 x i32> %B, i1 0, <2 x i32> %B, <8 x i32> %C, i1 1)
  store <8 x i32> %res, ptr addrspace(1) %out, align 32
  store <8 x i32> %res2, ptr addrspace(1) %out2, align 32
  ret void
}

define amdgpu_ps void @test_wmma_i32_16x16x16_ui4_unsigned_signed_clamp(<2 x i32> %A, <2 x i32> %B, <8 x i32> %C, ptr addrspace(1) %out, ptr addrspace(1) %out2) {
; W32-LABEL: test_wmma_i32_16x16x16_ui4_unsigned_signed_clamp:
; W32:       ; %bb.0: ; %bb
; W32-NEXT:    v_wmma_i32_16x16x16_iu4 v[16:23], v[0:1], v[2:3], v[4:11] neg_lo:[0,1,0] clamp
; W32-NEXT:    v_wmma_i32_16x16x16_iu4 v[4:11], v[2:3], v[2:3], v[4:11] neg_lo:[0,1,0] clamp
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[12:13], v[20:23], off offset:16
; W32-NEXT:    global_store_b128 v[12:13], v[16:19], off
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[14:15], v[8:11], off offset:16
; W32-NEXT:    global_store_b128 v[14:15], v[4:7], off
; W32-NEXT:    s_nop 0
; W32-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; W32-NEXT:    s_endpgm
bb:
  %res = call <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu4.v8i32.v2i32(i1 0, <2 x i32> %A, i1 1, <2 x i32> %B, <8 x i32> %C, i1 1)
  %res2 = call <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu4.v8i32.v2i32(i1 0, <2 x i32> %B, i1 1, <2 x i32> %B, <8 x i32> %C, i1 1)
  store <8 x i32> %res, ptr addrspace(1) %out, align 32
  store <8 x i32> %res2, ptr addrspace(1) %out2, align 32
  ret void
}

define amdgpu_ps void @test_wmma_i32_16x16x16_ui4_signed_unsigned_clamp(<2 x i32> %A, <2 x i32> %B, <8 x i32> %C, ptr addrspace(1) %out, ptr addrspace(1) %out2) {
; W32-LABEL: test_wmma_i32_16x16x16_ui4_signed_unsigned_clamp:
; W32:       ; %bb.0: ; %bb
; W32-NEXT:    v_wmma_i32_16x16x16_iu4 v[16:23], v[0:1], v[2:3], v[4:11] neg_lo:[1,0,0] clamp
; W32-NEXT:    v_wmma_i32_16x16x16_iu4 v[4:11], v[2:3], v[2:3], v[4:11] neg_lo:[1,0,0] clamp
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[12:13], v[20:23], off offset:16
; W32-NEXT:    global_store_b128 v[12:13], v[16:19], off
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[14:15], v[8:11], off offset:16
; W32-NEXT:    global_store_b128 v[14:15], v[4:7], off
; W32-NEXT:    s_nop 0
; W32-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; W32-NEXT:    s_endpgm
bb:
  %res = call <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu4.v8i32.v2i32(i1 1, <2 x i32> %A, i1 0, <2 x i32> %B, <8 x i32> %C, i1 1)
  %res2 = call <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu4.v8i32.v2i32(i1 1, <2 x i32> %B, i1 0, <2 x i32> %B, <8 x i32> %C, i1 1)
  store <8 x i32> %res, ptr addrspace(1) %out, align 32
  store <8 x i32> %res2, ptr addrspace(1) %out2, align 32
  ret void
}

define amdgpu_ps void @test_wmma_i32_16x16x16_ui4_signed_signed_clamp(<2 x i32> %A, <2 x i32> %B, <8 x i32> %C, ptr addrspace(1) %out, ptr addrspace(1) %out2) {
; W32-LABEL: test_wmma_i32_16x16x16_ui4_signed_signed_clamp:
; W32:       ; %bb.0: ; %bb
; W32-NEXT:    v_wmma_i32_16x16x16_iu4 v[16:23], v[0:1], v[2:3], v[4:11] neg_lo:[1,1,0] clamp
; W32-NEXT:    v_wmma_i32_16x16x16_iu4 v[4:11], v[2:3], v[2:3], v[4:11] neg_lo:[1,1,0] clamp
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[12:13], v[20:23], off offset:16
; W32-NEXT:    global_store_b128 v[12:13], v[16:19], off
; W32-NEXT:    s_clause 0x1
; W32-NEXT:    global_store_b128 v[14:15], v[8:11], off offset:16
; W32-NEXT:    global_store_b128 v[14:15], v[4:7], off
; W32-NEXT:    s_nop 0
; W32-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; W32-NEXT:    s_endpgm
bb:
  %res = call <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu4.v8i32.v2i32(i1 1, <2 x i32> %A, i1 1, <2 x i32> %B, <8 x i32> %C, i1 1)
  %res2 = call <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu4.v8i32.v2i32(i1 1, <2 x i32> %B, i1 1, <2 x i32> %B, <8 x i32> %C, i1 1)
  store <8 x i32> %res, ptr addrspace(1) %out, align 32
  store <8 x i32> %res2, ptr addrspace(1) %out2, align 32
  ret void
}

