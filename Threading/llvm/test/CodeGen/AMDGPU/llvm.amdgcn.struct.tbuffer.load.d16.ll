; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=amdgcn -mcpu=tonga -verify-machineinstrs -show-mc-encoding | FileCheck -enable-var-scope -check-prefixes=PREGFX10-UNPACKED %s
; RUN: llc < %s -mtriple=amdgcn -mcpu=gfx810 -verify-machineinstrs | FileCheck -enable-var-scope -check-prefixes=PREGFX10-PACKED %s
; RUN: llc < %s -mtriple=amdgcn -mcpu=gfx900 -verify-machineinstrs | FileCheck -enable-var-scope -check-prefixes=PREGFX10-PACKED %s
; RUN: llc < %s -mtriple=amdgcn -mcpu=gfx1010 -verify-machineinstrs | FileCheck -enable-var-scope -check-prefixes=GFX10-PACKED %s
; RUN: llc < %s -mtriple=amdgcn -mcpu=gfx1100 -verify-machineinstrs | FileCheck -enable-var-scope -check-prefixes=GFX11-PACKED %s
; RUN: llc < %s -mtriple=amdgcn -mcpu=gfx1200 -verify-machineinstrs | FileCheck -enable-var-scope -check-prefixes=GFX12-PACKED %s

define amdgpu_ps half @tbuffer_load_d16_x(<4 x i32> inreg %rsrc) {
; PREGFX10-UNPACKED-LABEL: tbuffer_load_d16_x:
; PREGFX10-UNPACKED:       ; %bb.0: ; %main_body
; PREGFX10-UNPACKED-NEXT:    v_mov_b32_e32 v0, 0 ; encoding: [0x80,0x02,0x00,0x7e]
; PREGFX10-UNPACKED-NEXT:    tbuffer_load_format_d16_x v0, v0, s[0:3], 0 format:[BUF_DATA_FORMAT_10_11_11,BUF_NUM_FORMAT_SNORM] idxen ; encoding: [0x00,0x20,0xb4,0xe8,0x00,0x00,0x00,0x80]
; PREGFX10-UNPACKED-NEXT:    s_waitcnt vmcnt(0) ; encoding: [0x70,0x0f,0x8c,0xbf]
; PREGFX10-UNPACKED-NEXT:    ; return to shader part epilog
;
; PREGFX10-PACKED-LABEL: tbuffer_load_d16_x:
; PREGFX10-PACKED:       ; %bb.0: ; %main_body
; PREGFX10-PACKED-NEXT:    v_mov_b32_e32 v0, 0
; PREGFX10-PACKED-NEXT:    tbuffer_load_format_d16_x v0, v0, s[0:3], 0 format:[BUF_DATA_FORMAT_10_11_11,BUF_NUM_FORMAT_SNORM] idxen
; PREGFX10-PACKED-NEXT:    s_waitcnt vmcnt(0)
; PREGFX10-PACKED-NEXT:    ; return to shader part epilog
;
; GFX10-PACKED-LABEL: tbuffer_load_d16_x:
; GFX10-PACKED:       ; %bb.0: ; %main_body
; GFX10-PACKED-NEXT:    v_mov_b32_e32 v0, 0
; GFX10-PACKED-NEXT:    tbuffer_load_format_d16_x v0, v0, s[0:3], 0 format:[BUF_FMT_32_FLOAT] idxen
; GFX10-PACKED-NEXT:    s_waitcnt vmcnt(0)
; GFX10-PACKED-NEXT:    ; return to shader part epilog
;
; GFX11-PACKED-LABEL: tbuffer_load_d16_x:
; GFX11-PACKED:       ; %bb.0: ; %main_body
; GFX11-PACKED-NEXT:    v_mov_b32_e32 v0, 0
; GFX11-PACKED-NEXT:    tbuffer_load_d16_format_x v0, v0, s[0:3], 0 format:[BUF_FMT_32_FLOAT] idxen
; GFX11-PACKED-NEXT:    s_waitcnt vmcnt(0)
; GFX11-PACKED-NEXT:    ; return to shader part epilog
;
; GFX12-PACKED-LABEL: tbuffer_load_d16_x:
; GFX12-PACKED:       ; %bb.0: ; %main_body
; GFX12-PACKED-NEXT:    v_mov_b32_e32 v0, 0
; GFX12-PACKED-NEXT:    tbuffer_load_d16_format_x v0, v0, s[0:3], null format:[BUF_FMT_32_FLOAT] idxen
; GFX12-PACKED-NEXT:    s_wait_loadcnt 0x0
; GFX12-PACKED-NEXT:    ; return to shader part epilog
main_body:
  %data = call half @llvm.amdgcn.struct.tbuffer.load.f16(<4 x i32> %rsrc, i32 0, i32 0, i32 0, i32 22, i32 0)
  ret half %data
}

define amdgpu_ps half @tbuffer_load_d16_xy(<4 x i32> inreg %rsrc) {
; PREGFX10-UNPACKED-LABEL: tbuffer_load_d16_xy:
; PREGFX10-UNPACKED:       ; %bb.0: ; %main_body
; PREGFX10-UNPACKED-NEXT:    v_mov_b32_e32 v0, 0 ; encoding: [0x80,0x02,0x00,0x7e]
; PREGFX10-UNPACKED-NEXT:    tbuffer_load_format_d16_xy v[0:1], v0, s[0:3], 0 format:[BUF_DATA_FORMAT_10_11_11,BUF_NUM_FORMAT_SNORM] idxen ; encoding: [0x00,0xa0,0xb4,0xe8,0x00,0x00,0x00,0x80]
; PREGFX10-UNPACKED-NEXT:    s_waitcnt vmcnt(0) ; encoding: [0x70,0x0f,0x8c,0xbf]
; PREGFX10-UNPACKED-NEXT:    v_mov_b32_e32 v0, v1 ; encoding: [0x01,0x03,0x00,0x7e]
; PREGFX10-UNPACKED-NEXT:    ; return to shader part epilog
;
; PREGFX10-PACKED-LABEL: tbuffer_load_d16_xy:
; PREGFX10-PACKED:       ; %bb.0: ; %main_body
; PREGFX10-PACKED-NEXT:    v_mov_b32_e32 v0, 0
; PREGFX10-PACKED-NEXT:    tbuffer_load_format_d16_xy v0, v0, s[0:3], 0 format:[BUF_DATA_FORMAT_10_11_11,BUF_NUM_FORMAT_SNORM] idxen
; PREGFX10-PACKED-NEXT:    s_waitcnt vmcnt(0)
; PREGFX10-PACKED-NEXT:    v_lshrrev_b32_e32 v0, 16, v0
; PREGFX10-PACKED-NEXT:    ; return to shader part epilog
;
; GFX10-PACKED-LABEL: tbuffer_load_d16_xy:
; GFX10-PACKED:       ; %bb.0: ; %main_body
; GFX10-PACKED-NEXT:    v_mov_b32_e32 v0, 0
; GFX10-PACKED-NEXT:    tbuffer_load_format_d16_xy v0, v0, s[0:3], 0 format:[BUF_FMT_32_FLOAT] idxen
; GFX10-PACKED-NEXT:    s_waitcnt vmcnt(0)
; GFX10-PACKED-NEXT:    v_lshrrev_b32_e32 v0, 16, v0
; GFX10-PACKED-NEXT:    ; return to shader part epilog
;
; GFX11-PACKED-LABEL: tbuffer_load_d16_xy:
; GFX11-PACKED:       ; %bb.0: ; %main_body
; GFX11-PACKED-NEXT:    v_mov_b32_e32 v0, 0
; GFX11-PACKED-NEXT:    tbuffer_load_d16_format_xy v0, v0, s[0:3], 0 format:[BUF_FMT_32_FLOAT] idxen
; GFX11-PACKED-NEXT:    s_waitcnt vmcnt(0)
; GFX11-PACKED-NEXT:    v_lshrrev_b32_e32 v0, 16, v0
; GFX11-PACKED-NEXT:    ; return to shader part epilog
;
; GFX12-PACKED-LABEL: tbuffer_load_d16_xy:
; GFX12-PACKED:       ; %bb.0: ; %main_body
; GFX12-PACKED-NEXT:    v_mov_b32_e32 v0, 0
; GFX12-PACKED-NEXT:    tbuffer_load_d16_format_xy v0, v0, s[0:3], null format:[BUF_FMT_32_FLOAT] idxen
; GFX12-PACKED-NEXT:    s_wait_loadcnt 0x0
; GFX12-PACKED-NEXT:    v_lshrrev_b32_e32 v0, 16, v0
; GFX12-PACKED-NEXT:    ; return to shader part epilog
main_body:
  %data = call <2 x half> @llvm.amdgcn.struct.tbuffer.load.v2f16(<4 x i32> %rsrc, i32 0, i32 0, i32 0, i32 22, i32 0)
  %elt = extractelement <2 x half> %data, i32 1
  ret half %elt
}

define amdgpu_ps half @tbuffer_load_d16_xyz(<4 x i32> inreg %rsrc) {
; PREGFX10-UNPACKED-LABEL: tbuffer_load_d16_xyz:
; PREGFX10-UNPACKED:       ; %bb.0: ; %main_body
; PREGFX10-UNPACKED-NEXT:    v_mov_b32_e32 v0, 0 ; encoding: [0x80,0x02,0x00,0x7e]
; PREGFX10-UNPACKED-NEXT:    tbuffer_load_format_d16_xyz v[0:2], v0, s[0:3], 0 format:[BUF_DATA_FORMAT_10_11_11,BUF_NUM_FORMAT_SNORM] idxen ; encoding: [0x00,0x20,0xb5,0xe8,0x00,0x00,0x00,0x80]
; PREGFX10-UNPACKED-NEXT:    s_waitcnt vmcnt(0) ; encoding: [0x70,0x0f,0x8c,0xbf]
; PREGFX10-UNPACKED-NEXT:    v_mov_b32_e32 v0, v2 ; encoding: [0x02,0x03,0x00,0x7e]
; PREGFX10-UNPACKED-NEXT:    ; return to shader part epilog
;
; PREGFX10-PACKED-LABEL: tbuffer_load_d16_xyz:
; PREGFX10-PACKED:       ; %bb.0: ; %main_body
; PREGFX10-PACKED-NEXT:    v_mov_b32_e32 v0, 0
; PREGFX10-PACKED-NEXT:    tbuffer_load_format_d16_xyz v[0:1], v0, s[0:3], 0 format:[BUF_DATA_FORMAT_10_11_11,BUF_NUM_FORMAT_SNORM] idxen
; PREGFX10-PACKED-NEXT:    s_waitcnt vmcnt(0)
; PREGFX10-PACKED-NEXT:    v_mov_b32_e32 v0, v1
; PREGFX10-PACKED-NEXT:    ; return to shader part epilog
;
; GFX10-PACKED-LABEL: tbuffer_load_d16_xyz:
; GFX10-PACKED:       ; %bb.0: ; %main_body
; GFX10-PACKED-NEXT:    v_mov_b32_e32 v0, 0
; GFX10-PACKED-NEXT:    tbuffer_load_format_d16_xyz v[0:1], v0, s[0:3], 0 format:[BUF_FMT_32_FLOAT] idxen
; GFX10-PACKED-NEXT:    s_waitcnt vmcnt(0)
; GFX10-PACKED-NEXT:    v_mov_b32_e32 v0, v1
; GFX10-PACKED-NEXT:    ; return to shader part epilog
;
; GFX11-PACKED-LABEL: tbuffer_load_d16_xyz:
; GFX11-PACKED:       ; %bb.0: ; %main_body
; GFX11-PACKED-NEXT:    v_mov_b32_e32 v0, 0
; GFX11-PACKED-NEXT:    tbuffer_load_d16_format_xyz v[0:1], v0, s[0:3], 0 format:[BUF_FMT_32_FLOAT] idxen
; GFX11-PACKED-NEXT:    s_waitcnt vmcnt(0)
; GFX11-PACKED-NEXT:    v_mov_b32_e32 v0, v1
; GFX11-PACKED-NEXT:    ; return to shader part epilog
;
; GFX12-PACKED-LABEL: tbuffer_load_d16_xyz:
; GFX12-PACKED:       ; %bb.0: ; %main_body
; GFX12-PACKED-NEXT:    v_mov_b32_e32 v0, 0
; GFX12-PACKED-NEXT:    tbuffer_load_d16_format_xyz v[0:1], v0, s[0:3], null format:[BUF_FMT_32_FLOAT] idxen
; GFX12-PACKED-NEXT:    s_wait_loadcnt 0x0
; GFX12-PACKED-NEXT:    v_mov_b32_e32 v0, v1
; GFX12-PACKED-NEXT:    ; return to shader part epilog
main_body:
  %data = call <3 x half> @llvm.amdgcn.struct.tbuffer.load.v3f16(<4 x i32> %rsrc, i32 0, i32 0, i32 0, i32 22, i32 0)
  %elt = extractelement <3 x half> %data, i32 2
  ret half %elt
}

define amdgpu_ps half @tbuffer_load_d16_xyzw(<4 x i32> inreg %rsrc) {
; PREGFX10-UNPACKED-LABEL: tbuffer_load_d16_xyzw:
; PREGFX10-UNPACKED:       ; %bb.0: ; %main_body
; PREGFX10-UNPACKED-NEXT:    v_mov_b32_e32 v0, 0 ; encoding: [0x80,0x02,0x00,0x7e]
; PREGFX10-UNPACKED-NEXT:    tbuffer_load_format_d16_xyzw v[0:3], v0, s[0:3], 0 format:[BUF_DATA_FORMAT_10_11_11,BUF_NUM_FORMAT_SNORM] idxen ; encoding: [0x00,0xa0,0xb5,0xe8,0x00,0x00,0x00,0x80]
; PREGFX10-UNPACKED-NEXT:    s_waitcnt vmcnt(0) ; encoding: [0x70,0x0f,0x8c,0xbf]
; PREGFX10-UNPACKED-NEXT:    v_mov_b32_e32 v0, v3 ; encoding: [0x03,0x03,0x00,0x7e]
; PREGFX10-UNPACKED-NEXT:    ; return to shader part epilog
;
; PREGFX10-PACKED-LABEL: tbuffer_load_d16_xyzw:
; PREGFX10-PACKED:       ; %bb.0: ; %main_body
; PREGFX10-PACKED-NEXT:    v_mov_b32_e32 v0, 0
; PREGFX10-PACKED-NEXT:    tbuffer_load_format_d16_xyzw v[0:1], v0, s[0:3], 0 format:[BUF_DATA_FORMAT_10_11_11,BUF_NUM_FORMAT_SNORM] idxen
; PREGFX10-PACKED-NEXT:    s_waitcnt vmcnt(0)
; PREGFX10-PACKED-NEXT:    v_lshrrev_b32_e32 v0, 16, v1
; PREGFX10-PACKED-NEXT:    ; return to shader part epilog
;
; GFX10-PACKED-LABEL: tbuffer_load_d16_xyzw:
; GFX10-PACKED:       ; %bb.0: ; %main_body
; GFX10-PACKED-NEXT:    v_mov_b32_e32 v0, 0
; GFX10-PACKED-NEXT:    tbuffer_load_format_d16_xyzw v[0:1], v0, s[0:3], 0 format:[BUF_FMT_32_FLOAT] idxen
; GFX10-PACKED-NEXT:    s_waitcnt vmcnt(0)
; GFX10-PACKED-NEXT:    v_lshrrev_b32_e32 v0, 16, v1
; GFX10-PACKED-NEXT:    ; return to shader part epilog
;
; GFX11-PACKED-LABEL: tbuffer_load_d16_xyzw:
; GFX11-PACKED:       ; %bb.0: ; %main_body
; GFX11-PACKED-NEXT:    v_mov_b32_e32 v0, 0
; GFX11-PACKED-NEXT:    tbuffer_load_d16_format_xyzw v[0:1], v0, s[0:3], 0 format:[BUF_FMT_32_FLOAT] idxen
; GFX11-PACKED-NEXT:    s_waitcnt vmcnt(0)
; GFX11-PACKED-NEXT:    v_lshrrev_b32_e32 v0, 16, v1
; GFX11-PACKED-NEXT:    ; return to shader part epilog
;
; GFX12-PACKED-LABEL: tbuffer_load_d16_xyzw:
; GFX12-PACKED:       ; %bb.0: ; %main_body
; GFX12-PACKED-NEXT:    v_mov_b32_e32 v0, 0
; GFX12-PACKED-NEXT:    tbuffer_load_d16_format_xyzw v[0:1], v0, s[0:3], null format:[BUF_FMT_32_FLOAT] idxen
; GFX12-PACKED-NEXT:    s_wait_loadcnt 0x0
; GFX12-PACKED-NEXT:    v_lshrrev_b32_e32 v0, 16, v1
; GFX12-PACKED-NEXT:    ; return to shader part epilog
main_body:
  %data = call <4 x half> @llvm.amdgcn.struct.tbuffer.load.v4f16(<4 x i32> %rsrc, i32 0, i32 0, i32 0, i32 22, i32 0)
  %elt = extractelement <4 x half> %data, i32 3
  ret half %elt
}

declare half @llvm.amdgcn.struct.tbuffer.load.f16(<4 x i32>, i32, i32, i32, i32, i32)
declare <2 x half> @llvm.amdgcn.struct.tbuffer.load.v2f16(<4 x i32>, i32, i32, i32, i32, i32)
declare <3 x half> @llvm.amdgcn.struct.tbuffer.load.v3f16(<4 x i32>, i32, i32, i32, i32, i32)
declare <4 x half> @llvm.amdgcn.struct.tbuffer.load.v4f16(<4 x i32>, i32, i32, i32, i32, i32)
