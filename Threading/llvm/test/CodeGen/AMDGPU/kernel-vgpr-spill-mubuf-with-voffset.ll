; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx906 -O0 -verify-machineinstrs %s -o - | FileCheck %s

; The forced spill to preserve the scratch VGPR require the voffset to hold the large offset
; value in the MUBUF instruction being emitted before s_cbranch_scc1 as it clobbers the SCC.

define amdgpu_kernel void @test_kernel(i32 %val) #0 {
; CHECK-LABEL: test_kernel:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    s_mov_b32 s32, 0x180000
; CHECK-NEXT:    s_mov_b32 s33, 0
; CHECK-NEXT:    s_add_u32 flat_scratch_lo, s10, s15
; CHECK-NEXT:    s_addc_u32 flat_scratch_hi, s11, 0
; CHECK-NEXT:    s_add_u32 s0, s0, s15
; CHECK-NEXT:    s_addc_u32 s1, s1, 0
; CHECK-NEXT:    ; implicit-def: $vgpr3 : SGPR spill to VGPR lane
; CHECK-NEXT:    s_mov_b64 s[10:11], s[8:9]
; CHECK-NEXT:    v_mov_b32_e32 v3, v2
; CHECK-NEXT:    v_mov_b32_e32 v2, v1
; CHECK-NEXT:    v_mov_b32_e32 v1, v0
; CHECK-NEXT:    s_or_saveexec_b64 s[34:35], -1
; CHECK-NEXT:    s_add_i32 s8, s33, 0x100200
; CHECK-NEXT:    buffer_load_dword v0, off, s[0:3], s8 ; 4-byte Folded Reload
; CHECK-NEXT:    s_mov_b64 exec, s[34:35]
; CHECK-NEXT:    s_load_dword s8, s[6:7], 0x0
; CHECK-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; CHECK-NEXT:    v_writelane_b32 v0, s8, 0
; CHECK-NEXT:    s_or_saveexec_b64 s[34:35], -1
; CHECK-NEXT:    s_add_i32 s8, s33, 0x100200
; CHECK-NEXT:    buffer_store_dword v0, off, s[0:3], s8 ; 4-byte Folded Spill
; CHECK-NEXT:    s_mov_b64 exec, s[34:35]
; CHECK-NEXT:    ;;#ASMSTART
; CHECK-NEXT:    ; def vgpr10
; CHECK-NEXT:    ;;#ASMEND
; CHECK-NEXT:    s_add_i32 s8, s33, 0x100100
; CHECK-NEXT:    buffer_store_dword v10, off, s[0:3], s8 ; 4-byte Folded Spill
; CHECK-NEXT:    s_mov_b64 s[16:17], 8
; CHECK-NEXT:    s_mov_b32 s8, s6
; CHECK-NEXT:    s_mov_b32 s6, s7
; CHECK-NEXT:    s_mov_b32 s9, s16
; CHECK-NEXT:    s_mov_b32 s7, s17
; CHECK-NEXT:    s_add_u32 s8, s8, s9
; CHECK-NEXT:    s_addc_u32 s6, s6, s7
; CHECK-NEXT:    ; kill: def $sgpr8 killed $sgpr8 def $sgpr8_sgpr9
; CHECK-NEXT:    s_mov_b32 s9, s6
; CHECK-NEXT:    v_mov_b32_e32 v0, 0x2000
; CHECK-NEXT:    ; implicit-def: $sgpr6
; CHECK-NEXT:    s_getpc_b64 s[6:7]
; CHECK-NEXT:    s_add_u32 s6, s6, device_func@gotpcrel32@lo+4
; CHECK-NEXT:    s_addc_u32 s7, s7, device_func@gotpcrel32@hi+12
; CHECK-NEXT:    s_load_dwordx2 s[16:17], s[6:7], 0x0
; CHECK-NEXT:    s_mov_b64 s[22:23], s[2:3]
; CHECK-NEXT:    s_mov_b64 s[20:21], s[0:1]
; CHECK-NEXT:    s_mov_b32 s6, 20
; CHECK-NEXT:    v_lshlrev_b32_e64 v3, s6, v3
; CHECK-NEXT:    s_mov_b32 s6, 10
; CHECK-NEXT:    v_lshlrev_b32_e64 v2, s6, v2
; CHECK-NEXT:    v_or3_b32 v31, v1, v2, v3
; CHECK-NEXT:    ; implicit-def: $sgpr6_sgpr7
; CHECK-NEXT:    ; implicit-def: $sgpr15
; CHECK-NEXT:    s_mov_b64 s[0:1], s[20:21]
; CHECK-NEXT:    s_mov_b64 s[2:3], s[22:23]
; CHECK-NEXT:    ; implicit-def: $sgpr18_sgpr19
; CHECK-NEXT:    s_waitcnt lgkmcnt(0)
; CHECK-NEXT:    s_swappc_b64 s[30:31], s[16:17]
; CHECK-NEXT:    s_or_saveexec_b64 s[34:35], -1
; CHECK-NEXT:    s_add_i32 s4, s33, 0x100200
; CHECK-NEXT:    buffer_load_dword v0, off, s[0:3], s4 ; 4-byte Folded Reload
; CHECK-NEXT:    s_mov_b64 exec, s[34:35]
; CHECK-NEXT:    s_add_i32 s4, s33, 0x100100
; CHECK-NEXT:    buffer_load_dword v10, off, s[0:3], s4 ; 4-byte Folded Reload
; CHECK-NEXT:    s_waitcnt vmcnt(1)
; CHECK-NEXT:    v_readlane_b32 s4, v0, 0
; CHECK-NEXT:    s_mov_b32 s5, 0
; CHECK-NEXT:    s_cmp_eq_u32 s4, s5
; CHECK-NEXT:    v_mov_b32_e32 v0, 0x4000
; CHECK-NEXT:    s_waitcnt vmcnt(0)
; CHECK-NEXT:    buffer_store_dword v10, v0, s[0:3], s33 offen ; 4-byte Folded Spill
; CHECK-NEXT:    s_cbranch_scc1 .LBB0_2
; CHECK-NEXT:  ; %bb.1: ; %store
; CHECK-NEXT:    s_or_saveexec_b64 s[34:35], -1
; CHECK-NEXT:    s_add_i32 s4, s33, 0x100200
; CHECK-NEXT:    buffer_load_dword v0, off, s[0:3], s4 ; 4-byte Folded Reload
; CHECK-NEXT:    s_mov_b64 exec, s[34:35]
; CHECK-NEXT:    s_add_i32 s4, s33, 0x100000
; CHECK-NEXT:    buffer_load_dword v2, off, s[0:3], s4 ; 4-byte Folded Reload
; CHECK-NEXT:    ; implicit-def: $sgpr4
; CHECK-NEXT:    v_mov_b32_e32 v1, s4
; CHECK-NEXT:    s_waitcnt vmcnt(0)
; CHECK-NEXT:    ds_write_b32 v1, v2
; CHECK-NEXT:    ; kill: killed $vgpr0
; CHECK-NEXT:    s_endpgm
; CHECK-NEXT:  .LBB0_2: ; %end
; CHECK-NEXT:    s_or_saveexec_b64 s[34:35], -1
; CHECK-NEXT:    s_add_i32 s4, s33, 0x100200
; CHECK-NEXT:    buffer_load_dword v0, off, s[0:3], s4 ; 4-byte Folded Reload
; CHECK-NEXT:    s_mov_b64 exec, s[34:35]
; CHECK-NEXT:    ; kill: killed $vgpr0
; CHECK-NEXT:    s_endpgm
  %arr = alloca < 1339 x i32>, align 8192, addrspace(5)
  %cmp = icmp ne i32 %val, 0
  %vreg = call i32 asm sideeffect "; def vgpr10", "={v10}"()
  call void @device_func(ptr addrspace(5) %arr)
  br i1 %cmp, label %store, label %end

store:
  store volatile i32 %vreg, ptr addrspace(3) undef
  ret void

end:
  ret void
}

declare void @device_func(ptr addrspace(5))

attributes #0 = { nounwind "frame-pointer"="all" }

!llvm.module.flags = !{!0}
!0 = !{i32 1, !"amdhsa_code_object_version", i32 500}