; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn -mcpu=gfx1010 -verify-machineinstrs < %s | FileCheck -check-prefix=GFX10 %s

define amdgpu_ps <4 x float> @sample_cd_1d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, half %dsdh, half %dsdv, float %s) {
; GFX10-LABEL: sample_cd_1d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    image_sample_cd_g16 v[0:3], v[0:2], s[0:7], s[8:11] dmask:0xf dim:SQ_RSRC_IMG_1D
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.sample.cd.1d.v4f32.f16.f32(i32 15, half %dsdh, half %dsdv, float %s, <8 x i32> %rsrc, <4 x i32> %samp, i1 0, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @sample_cd_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, half %dsdh, half %dtdh, half %dsdv, half %dtdv, float %s, float %t) {
; GFX10-LABEL: sample_cd_2d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    v_perm_b32 v2, v3, v2, 0x5040100
; GFX10-NEXT:    v_perm_b32 v0, v1, v0, 0x5040100
; GFX10-NEXT:    image_sample_cd_g16 v[0:3], [v0, v2, v4, v5], s[0:7], s[8:11] dmask:0xf dim:SQ_RSRC_IMG_2D
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.sample.cd.2d.v4f32.f16.f32(i32 15, half %dsdh, half %dtdh, half %dsdv, half %dtdv, float %s, float %t, <8 x i32> %rsrc, <4 x i32> %samp, i1 0, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @sample_c_cd_1d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, float %zcompare, half %dsdh, half %dsdv, float %s) {
; GFX10-LABEL: sample_c_cd_1d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    image_sample_c_cd_g16 v[0:3], v[0:3], s[0:7], s[8:11] dmask:0xf dim:SQ_RSRC_IMG_1D
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.sample.c.cd.1d.v4f32.f16.f32(i32 15, float %zcompare, half %dsdh, half %dsdv, float %s, <8 x i32> %rsrc, <4 x i32> %samp, i1 0, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @sample_c_cd_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, float %zcompare, half %dsdh, half %dtdh, half %dsdv, half %dtdv, float %s, float %t) {
; GFX10-LABEL: sample_c_cd_2d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    v_perm_b32 v3, v4, v3, 0x5040100
; GFX10-NEXT:    v_perm_b32 v1, v2, v1, 0x5040100
; GFX10-NEXT:    image_sample_c_cd_g16 v[0:3], [v0, v1, v3, v5, v6], s[0:7], s[8:11] dmask:0xf dim:SQ_RSRC_IMG_2D
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.sample.c.cd.2d.v4f32.f16.f32(i32 15, float %zcompare, half %dsdh, half %dtdh, half %dsdv, half %dtdv, float %s, float %t, <8 x i32> %rsrc, <4 x i32> %samp, i1 0, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @sample_cd_cl_1d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, half %dsdh, half %dsdv, float %s, float %clamp) {
; GFX10-LABEL: sample_cd_cl_1d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    image_sample_cd_cl_g16 v[0:3], v[0:3], s[0:7], s[8:11] dmask:0xf dim:SQ_RSRC_IMG_1D
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.sample.cd.cl.1d.v4f32.f16.f32(i32 15, half %dsdh, half %dsdv, float %s, float %clamp, <8 x i32> %rsrc, <4 x i32> %samp, i1 0, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @sample_cd_cl_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, half %dsdh, half %dtdh, half %dsdv, half %dtdv, float %s, float %t, float %clamp) {
; GFX10-LABEL: sample_cd_cl_2d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    v_perm_b32 v2, v3, v2, 0x5040100
; GFX10-NEXT:    v_perm_b32 v0, v1, v0, 0x5040100
; GFX10-NEXT:    image_sample_cd_cl_g16 v[0:3], [v0, v2, v4, v5, v6], s[0:7], s[8:11] dmask:0xf dim:SQ_RSRC_IMG_2D
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.sample.cd.cl.2d.v4f32.f16.f32(i32 15, half %dsdh, half %dtdh, half %dsdv, half %dtdv, float %s, float %t, float %clamp, <8 x i32> %rsrc, <4 x i32> %samp, i1 0, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @sample_c_cd_cl_1d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, float %zcompare, half %dsdh, half %dsdv, float %s, float %clamp) {
; GFX10-LABEL: sample_c_cd_cl_1d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    image_sample_c_cd_cl_g16 v[0:3], v[0:4], s[0:7], s[8:11] dmask:0xf dim:SQ_RSRC_IMG_1D
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.sample.c.cd.cl.1d.v4f32.f16.f32(i32 15, float %zcompare, half %dsdh, half %dsdv, float %s, float %clamp, <8 x i32> %rsrc, <4 x i32> %samp, i1 0, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @sample_c_cd_cl_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, float %zcompare, half %dsdh, half %dtdh, half %dsdv, half %dtdv, float %s, float %t, float %clamp) {
; GFX10-LABEL: sample_c_cd_cl_2d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    v_mov_b32_e32 v8, v2
; GFX10-NEXT:    v_mov_b32_e32 v2, v0
; GFX10-NEXT:    v_perm_b32 v4, v4, v3, 0x5040100
; GFX10-NEXT:    v_perm_b32 v3, v8, v1, 0x5040100
; GFX10-NEXT:    image_sample_c_cd_cl_g16 v[0:3], v[2:7], s[0:7], s[8:11] dmask:0xf dim:SQ_RSRC_IMG_2D
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.sample.c.cd.cl.2d.v4f32.f16.f32(i32 15, float %zcompare, half %dsdh, half %dtdh, half %dsdv, half %dtdv, float %s, float %t, float %clamp, <8 x i32> %rsrc, <4 x i32> %samp, i1 0, i32 0, i32 0)
  ret <4 x float> %v
}

declare <4 x float> @llvm.amdgcn.image.sample.cd.1d.v4f32.f16.f32(i32, half, half, float, <8 x i32>, <4 x i32>, i1, i32, i32) #1
declare <4 x float> @llvm.amdgcn.image.sample.cd.2d.v4f32.f16.f32(i32, half, half, half, half, float, float, <8 x i32>, <4 x i32>, i1, i32, i32) #1
declare <4 x float> @llvm.amdgcn.image.sample.c.cd.1d.v4f32.f16.f32(i32, float, half, half, float, <8 x i32>, <4 x i32>, i1, i32, i32) #1
declare <4 x float> @llvm.amdgcn.image.sample.c.cd.2d.v4f32.f16.f32(i32, float, half, half, half, half, float, float, <8 x i32>, <4 x i32>, i1, i32, i32) #1
declare <4 x float> @llvm.amdgcn.image.sample.cd.cl.1d.v4f32.f16.f32(i32, half, half, float, float, <8 x i32>, <4 x i32>, i1, i32, i32) #1
declare <4 x float> @llvm.amdgcn.image.sample.cd.cl.2d.v4f32.f16.f32(i32, half, half, half, half, float, float, float, <8 x i32>, <4 x i32>, i1, i32, i32) #1
declare <4 x float> @llvm.amdgcn.image.sample.c.cd.cl.1d.v4f32.f16.f32(i32, float, half, half, float, float, <8 x i32>, <4 x i32>, i1, i32, i32) #1
declare <4 x float> @llvm.amdgcn.image.sample.c.cd.cl.2d.v4f32.f16.f32(i32, float, half, half, half, half, float, float, float, <8 x i32>, <4 x i32>, i1, i32, i32) #1

attributes #0 = { nounwind }
attributes #1 = { nounwind readonly }
attributes #2 = { nounwind readnone }
