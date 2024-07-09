; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn -mcpu=gfx1200 -verify-machineinstrs -global-isel=0 < %s | FileCheck -check-prefixes=GCN %s
; RUN: llc -mtriple=amdgcn -mcpu=gfx1200 -verify-machineinstrs -global-isel=1 < %s | FileCheck -check-prefixes=GCN %s

declare void @llvm.amdgcn.s.sleep.var(i32)

define void @test_s_sleep_var1(i32 %arg) {
; GCN-LABEL: test_s_sleep_var1:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_wait_loadcnt_dscnt 0x0
; GCN-NEXT:    s_wait_expcnt 0x0
; GCN-NEXT:    s_wait_samplecnt 0x0
; GCN-NEXT:    s_wait_bvhcnt 0x0
; GCN-NEXT:    s_wait_kmcnt 0x0
; GCN-NEXT:    v_readfirstlane_b32 s0, v0
; GCN-NEXT:    s_delay_alu instid0(VALU_DEP_1)
; GCN-NEXT:    s_sleep_var s0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  call void @llvm.amdgcn.s.sleep.var(i32 %arg)
  ret void
}

define void @test_s_sleep_var2() {
; GCN-LABEL: test_s_sleep_var2:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_wait_loadcnt_dscnt 0x0
; GCN-NEXT:    s_wait_expcnt 0x0
; GCN-NEXT:    s_wait_samplecnt 0x0
; GCN-NEXT:    s_wait_bvhcnt 0x0
; GCN-NEXT:    s_wait_kmcnt 0x0
; GCN-NEXT:    s_sleep_var 10
; GCN-NEXT:    s_setpc_b64 s[30:31]
  call void @llvm.amdgcn.s.sleep.var(i32 10)
  ret void
}

define amdgpu_kernel void @test_s_sleep_var3(i32 %arg) {
; GCN-LABEL: test_s_sleep_var3:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_b32 s0, s[0:1], 0x24
; GCN-NEXT:    s_wait_kmcnt 0x0
; GCN-NEXT:    s_sleep_var s0
; GCN-NEXT:    s_endpgm
  call void @llvm.amdgcn.s.sleep.var(i32 %arg)
  ret void
}
