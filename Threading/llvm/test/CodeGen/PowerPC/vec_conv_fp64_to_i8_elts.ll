; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu \
; RUN:     -mcpu=pwr8 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN: FileCheck %s --check-prefix=CHECK-P8
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu \
; RUN:     -mcpu=pwr9 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN: FileCheck %s --check-prefix=CHECK-P9
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu \
; RUN:     -mcpu=pwr9 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN: FileCheck %s --check-prefix=CHECK-BE

define i16 @test2elt(<2 x double> %a) local_unnamed_addr #0 {
; CHECK-P8-LABEL: test2elt:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    xscvdpsxws f1, v2
; CHECK-P8-NEXT:    xxswapd vs0, v2
; CHECK-P8-NEXT:    xscvdpsxws f0, f0
; CHECK-P8-NEXT:    mffprwz r3, f1
; CHECK-P8-NEXT:    mtvsrd v2, r3
; CHECK-P8-NEXT:    mffprwz r3, f0
; CHECK-P8-NEXT:    mtvsrd v3, r3
; CHECK-P8-NEXT:    vmrghb v2, v2, v3
; CHECK-P8-NEXT:    xxswapd vs0, v2
; CHECK-P8-NEXT:    mffprd r3, f0
; CHECK-P8-NEXT:    clrldi r3, r3, 48
; CHECK-P8-NEXT:    sth r3, -2(r1)
; CHECK-P8-NEXT:    lhz r3, -2(r1)
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test2elt:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    xscvdpsxws f0, v2
; CHECK-P9-NEXT:    mffprwz r3, f0
; CHECK-P9-NEXT:    xxswapd vs0, v2
; CHECK-P9-NEXT:    mtvsrd v3, r3
; CHECK-P9-NEXT:    xscvdpsxws f0, f0
; CHECK-P9-NEXT:    mffprwz r3, f0
; CHECK-P9-NEXT:    mtvsrd v2, r3
; CHECK-P9-NEXT:    addi r3, r1, -2
; CHECK-P9-NEXT:    vmrghb v2, v3, v2
; CHECK-P9-NEXT:    vsldoi v2, v2, v2, 8
; CHECK-P9-NEXT:    stxsihx v2, 0, r3
; CHECK-P9-NEXT:    lhz r3, -2(r1)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test2elt:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    xxswapd vs2, v2
; CHECK-BE-NEXT:    xscvdpsxws f1, v2
; CHECK-BE-NEXT:    addis r3, r2, .LCPI0_0@toc@ha
; CHECK-BE-NEXT:    addi r3, r3, .LCPI0_0@toc@l
; CHECK-BE-NEXT:    xscvdpsxws f2, f2
; CHECK-BE-NEXT:    lxv vs0, 0(r3)
; CHECK-BE-NEXT:    mffprwz r3, f1
; CHECK-BE-NEXT:    mtfprwz f1, r3
; CHECK-BE-NEXT:    mffprwz r3, f2
; CHECK-BE-NEXT:    mtvsrwz v2, r3
; CHECK-BE-NEXT:    addi r3, r1, -2
; CHECK-BE-NEXT:    xxperm v2, vs1, vs0
; CHECK-BE-NEXT:    vsldoi v2, v2, v2, 10
; CHECK-BE-NEXT:    stxsihx v2, 0, r3
; CHECK-BE-NEXT:    lhz r3, -2(r1)
; CHECK-BE-NEXT:    blr
entry:
  %0 = fptoui <2 x double> %a to <2 x i8>
  %1 = bitcast <2 x i8> %0 to i16
  ret i16 %1
}

define i32 @test4elt(ptr nocapture readonly) local_unnamed_addr #1 {
; CHECK-P8-LABEL: test4elt:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    lxvd2x vs0, 0, r3
; CHECK-P8-NEXT:    li r4, 16
; CHECK-P8-NEXT:    lxvd2x vs2, r3, r4
; CHECK-P8-NEXT:    xxswapd vs1, vs0
; CHECK-P8-NEXT:    xscvdpsxws f0, f0
; CHECK-P8-NEXT:    xscvdpsxws f1, f1
; CHECK-P8-NEXT:    mffprwz r3, f0
; CHECK-P8-NEXT:    xscvdpsxws f0, f2
; CHECK-P8-NEXT:    mffprwz r4, f1
; CHECK-P8-NEXT:    mtvsrd v2, r3
; CHECK-P8-NEXT:    mtvsrd v3, r4
; CHECK-P8-NEXT:    xxswapd vs3, vs2
; CHECK-P8-NEXT:    xscvdpsxws f3, f3
; CHECK-P8-NEXT:    mffprwz r3, f3
; CHECK-P8-NEXT:    mtvsrd v4, r3
; CHECK-P8-NEXT:    mffprwz r3, f0
; CHECK-P8-NEXT:    vmrghb v2, v3, v2
; CHECK-P8-NEXT:    mtvsrd v3, r3
; CHECK-P8-NEXT:    vmrghb v3, v4, v3
; CHECK-P8-NEXT:    vmrglh v2, v3, v2
; CHECK-P8-NEXT:    xxswapd vs0, v2
; CHECK-P8-NEXT:    mffprwz r3, f0
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test4elt:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv vs1, 0(r3)
; CHECK-P9-NEXT:    lxv vs0, 16(r3)
; CHECK-P9-NEXT:    xscvdpsxws f2, f1
; CHECK-P9-NEXT:    xxswapd vs1, vs1
; CHECK-P9-NEXT:    xscvdpsxws f1, f1
; CHECK-P9-NEXT:    mffprwz r3, f2
; CHECK-P9-NEXT:    mtvsrd v2, r3
; CHECK-P9-NEXT:    mffprwz r3, f1
; CHECK-P9-NEXT:    xscvdpsxws f1, f0
; CHECK-P9-NEXT:    xxswapd vs0, vs0
; CHECK-P9-NEXT:    mtvsrd v3, r3
; CHECK-P9-NEXT:    xscvdpsxws f0, f0
; CHECK-P9-NEXT:    vmrghb v2, v2, v3
; CHECK-P9-NEXT:    mffprwz r3, f1
; CHECK-P9-NEXT:    mtvsrd v3, r3
; CHECK-P9-NEXT:    mffprwz r3, f0
; CHECK-P9-NEXT:    mtvsrd v4, r3
; CHECK-P9-NEXT:    li r3, 0
; CHECK-P9-NEXT:    vmrghb v3, v3, v4
; CHECK-P9-NEXT:    vmrglh v2, v3, v2
; CHECK-P9-NEXT:    vextuwrx r3, r3, v2
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test4elt:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs1, 16(r3)
; CHECK-BE-NEXT:    lxv vs0, 0(r3)
; CHECK-BE-NEXT:    addis r3, r2, .LCPI1_0@toc@ha
; CHECK-BE-NEXT:    addi r3, r3, .LCPI1_0@toc@l
; CHECK-BE-NEXT:    lxv vs2, 0(r3)
; CHECK-BE-NEXT:    xscvdpsxws f3, f1
; CHECK-BE-NEXT:    xxswapd vs1, vs1
; CHECK-BE-NEXT:    xscvdpsxws f1, f1
; CHECK-BE-NEXT:    mffprwz r3, f3
; CHECK-BE-NEXT:    mtfprwz f3, r3
; CHECK-BE-NEXT:    mffprwz r3, f1
; CHECK-BE-NEXT:    xscvdpsxws f1, f0
; CHECK-BE-NEXT:    xxswapd vs0, vs0
; CHECK-BE-NEXT:    mtvsrwz v2, r3
; CHECK-BE-NEXT:    xscvdpsxws f0, f0
; CHECK-BE-NEXT:    xxperm v2, vs3, vs2
; CHECK-BE-NEXT:    mffprwz r3, f1
; CHECK-BE-NEXT:    mtfprwz f1, r3
; CHECK-BE-NEXT:    mffprwz r3, f0
; CHECK-BE-NEXT:    mtvsrwz v3, r3
; CHECK-BE-NEXT:    li r3, 0
; CHECK-BE-NEXT:    xxperm v3, vs1, vs2
; CHECK-BE-NEXT:    vmrghh v2, v3, v2
; CHECK-BE-NEXT:    vextuwlx r3, r3, v2
; CHECK-BE-NEXT:    blr
entry:
  %a = load <4 x double>, ptr %0, align 32
  %1 = fptoui <4 x double> %a to <4 x i8>
  %2 = bitcast <4 x i8> %1 to i32
  ret i32 %2
}

define i64 @test8elt(ptr nocapture readonly) local_unnamed_addr #1 {
; CHECK-P8-LABEL: test8elt:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r4, 16
; CHECK-P8-NEXT:    lxvd2x vs1, 0, r3
; CHECK-P8-NEXT:    lxvd2x vs0, r3, r4
; CHECK-P8-NEXT:    li r4, 32
; CHECK-P8-NEXT:    lxvd2x vs4, r3, r4
; CHECK-P8-NEXT:    li r4, 48
; CHECK-P8-NEXT:    lxvd2x vs6, r3, r4
; CHECK-P8-NEXT:    xxswapd vs3, vs1
; CHECK-P8-NEXT:    xscvdpsxws f1, f1
; CHECK-P8-NEXT:    xscvdpsxws f3, f3
; CHECK-P8-NEXT:    mffprwz r3, f1
; CHECK-P8-NEXT:    mtvsrd v2, r3
; CHECK-P8-NEXT:    xxswapd vs2, vs0
; CHECK-P8-NEXT:    xscvdpsxws f0, f0
; CHECK-P8-NEXT:    mffprwz r4, f0
; CHECK-P8-NEXT:    xscvdpsxws f2, f2
; CHECK-P8-NEXT:    xscvdpsxws f0, f6
; CHECK-P8-NEXT:    mtvsrd v3, r4
; CHECK-P8-NEXT:    mffprwz r4, f3
; CHECK-P8-NEXT:    mtvsrd v5, r4
; CHECK-P8-NEXT:    xxswapd vs5, vs4
; CHECK-P8-NEXT:    xscvdpsxws f4, f4
; CHECK-P8-NEXT:    mffprwz r3, f4
; CHECK-P8-NEXT:    xscvdpsxws f5, f5
; CHECK-P8-NEXT:    mtvsrd v4, r3
; CHECK-P8-NEXT:    mffprwz r3, f2
; CHECK-P8-NEXT:    mffprwz r4, f5
; CHECK-P8-NEXT:    xxswapd vs7, vs6
; CHECK-P8-NEXT:    xscvdpsxws f7, f7
; CHECK-P8-NEXT:    vmrghb v2, v5, v2
; CHECK-P8-NEXT:    mtvsrd v5, r3
; CHECK-P8-NEXT:    mffprwz r3, f7
; CHECK-P8-NEXT:    mtvsrd v0, r3
; CHECK-P8-NEXT:    mffprwz r3, f0
; CHECK-P8-NEXT:    vmrghb v3, v5, v3
; CHECK-P8-NEXT:    mtvsrd v5, r4
; CHECK-P8-NEXT:    vmrglh v2, v3, v2
; CHECK-P8-NEXT:    vmrghb v4, v5, v4
; CHECK-P8-NEXT:    mtvsrd v5, r3
; CHECK-P8-NEXT:    vmrghb v5, v0, v5
; CHECK-P8-NEXT:    vmrglh v3, v5, v4
; CHECK-P8-NEXT:    xxmrglw vs0, v3, v2
; CHECK-P8-NEXT:    xxswapd vs0, vs0
; CHECK-P8-NEXT:    mffprd r3, f0
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test8elt:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv vs3, 0(r3)
; CHECK-P9-NEXT:    lxv vs2, 16(r3)
; CHECK-P9-NEXT:    lxv vs0, 48(r3)
; CHECK-P9-NEXT:    lxv vs1, 32(r3)
; CHECK-P9-NEXT:    xscvdpsxws f4, f3
; CHECK-P9-NEXT:    xxswapd vs3, vs3
; CHECK-P9-NEXT:    xscvdpsxws f3, f3
; CHECK-P9-NEXT:    mffprwz r3, f4
; CHECK-P9-NEXT:    mtvsrd v2, r3
; CHECK-P9-NEXT:    mffprwz r3, f3
; CHECK-P9-NEXT:    xscvdpsxws f3, f2
; CHECK-P9-NEXT:    xxswapd vs2, vs2
; CHECK-P9-NEXT:    mtvsrd v3, r3
; CHECK-P9-NEXT:    xscvdpsxws f2, f2
; CHECK-P9-NEXT:    vmrghb v2, v2, v3
; CHECK-P9-NEXT:    mffprwz r3, f3
; CHECK-P9-NEXT:    mtvsrd v3, r3
; CHECK-P9-NEXT:    mffprwz r3, f2
; CHECK-P9-NEXT:    xscvdpsxws f2, f1
; CHECK-P9-NEXT:    xxswapd vs1, vs1
; CHECK-P9-NEXT:    mtvsrd v4, r3
; CHECK-P9-NEXT:    xscvdpsxws f1, f1
; CHECK-P9-NEXT:    vmrghb v3, v3, v4
; CHECK-P9-NEXT:    mffprwz r3, f2
; CHECK-P9-NEXT:    vmrglh v2, v3, v2
; CHECK-P9-NEXT:    mtvsrd v3, r3
; CHECK-P9-NEXT:    mffprwz r3, f1
; CHECK-P9-NEXT:    xscvdpsxws f1, f0
; CHECK-P9-NEXT:    xxswapd vs0, vs0
; CHECK-P9-NEXT:    mtvsrd v4, r3
; CHECK-P9-NEXT:    xscvdpsxws f0, f0
; CHECK-P9-NEXT:    vmrghb v3, v3, v4
; CHECK-P9-NEXT:    mffprwz r3, f1
; CHECK-P9-NEXT:    mtvsrd v4, r3
; CHECK-P9-NEXT:    mffprwz r3, f0
; CHECK-P9-NEXT:    mtvsrd v5, r3
; CHECK-P9-NEXT:    vmrghb v4, v4, v5
; CHECK-P9-NEXT:    vmrglh v3, v4, v3
; CHECK-P9-NEXT:    xxmrglw vs0, v3, v2
; CHECK-P9-NEXT:    mfvsrld r3, vs0
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test8elt:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs3, 48(r3)
; CHECK-BE-NEXT:    lxv vs0, 0(r3)
; CHECK-BE-NEXT:    lxv vs1, 16(r3)
; CHECK-BE-NEXT:    lxv vs2, 32(r3)
; CHECK-BE-NEXT:    addis r3, r2, .LCPI2_0@toc@ha
; CHECK-BE-NEXT:    addi r3, r3, .LCPI2_0@toc@l
; CHECK-BE-NEXT:    lxv vs4, 0(r3)
; CHECK-BE-NEXT:    xscvdpsxws f5, f3
; CHECK-BE-NEXT:    xxswapd vs3, vs3
; CHECK-BE-NEXT:    xscvdpsxws f3, f3
; CHECK-BE-NEXT:    mffprwz r3, f5
; CHECK-BE-NEXT:    mtfprwz f5, r3
; CHECK-BE-NEXT:    mffprwz r3, f3
; CHECK-BE-NEXT:    xscvdpsxws f3, f2
; CHECK-BE-NEXT:    xxswapd vs2, vs2
; CHECK-BE-NEXT:    mtvsrwz v2, r3
; CHECK-BE-NEXT:    xscvdpsxws f2, f2
; CHECK-BE-NEXT:    xxperm v2, vs5, vs4
; CHECK-BE-NEXT:    mffprwz r3, f3
; CHECK-BE-NEXT:    mtfprwz f3, r3
; CHECK-BE-NEXT:    mffprwz r3, f2
; CHECK-BE-NEXT:    xscvdpsxws f2, f1
; CHECK-BE-NEXT:    xxswapd vs1, vs1
; CHECK-BE-NEXT:    mtvsrwz v3, r3
; CHECK-BE-NEXT:    xscvdpsxws f1, f1
; CHECK-BE-NEXT:    xxperm v3, vs3, vs4
; CHECK-BE-NEXT:    mffprwz r3, f2
; CHECK-BE-NEXT:    vmrghh v2, v3, v2
; CHECK-BE-NEXT:    mtfprwz f2, r3
; CHECK-BE-NEXT:    mffprwz r3, f1
; CHECK-BE-NEXT:    xscvdpsxws f1, f0
; CHECK-BE-NEXT:    xxswapd vs0, vs0
; CHECK-BE-NEXT:    mtvsrwz v3, r3
; CHECK-BE-NEXT:    xscvdpsxws f0, f0
; CHECK-BE-NEXT:    xxperm v3, vs2, vs4
; CHECK-BE-NEXT:    mffprwz r3, f1
; CHECK-BE-NEXT:    mtfprwz f1, r3
; CHECK-BE-NEXT:    mffprwz r3, f0
; CHECK-BE-NEXT:    mtvsrwz v4, r3
; CHECK-BE-NEXT:    xxperm v4, vs1, vs4
; CHECK-BE-NEXT:    vmrghh v3, v4, v3
; CHECK-BE-NEXT:    xxmrghw vs0, v3, v2
; CHECK-BE-NEXT:    mffprd r3, f0
; CHECK-BE-NEXT:    blr
entry:
  %a = load <8 x double>, ptr %0, align 64
  %1 = fptoui <8 x double> %a to <8 x i8>
  %2 = bitcast <8 x i8> %1 to i64
  ret i64 %2
}

define <16 x i8> @test16elt(ptr nocapture readonly) local_unnamed_addr #2 {
; CHECK-P8-LABEL: test16elt:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r4, 80
; CHECK-P8-NEXT:    lxvd2x vs4, 0, r3
; CHECK-P8-NEXT:    lxvd2x vs3, r3, r4
; CHECK-P8-NEXT:    li r4, 48
; CHECK-P8-NEXT:    lxvd2x vs6, r3, r4
; CHECK-P8-NEXT:    li r4, 16
; CHECK-P8-NEXT:    lxvd2x vs7, r3, r4
; CHECK-P8-NEXT:    li r4, 32
; CHECK-P8-NEXT:    lxvd2x vs9, r3, r4
; CHECK-P8-NEXT:    li r4, 64
; CHECK-P8-NEXT:    lxvd2x vs12, r3, r4
; CHECK-P8-NEXT:    li r4, 96
; CHECK-P8-NEXT:    lxvd2x vs2, r3, r4
; CHECK-P8-NEXT:    li r4, 112
; CHECK-P8-NEXT:    lxvd2x vs0, r3, r4
; CHECK-P8-NEXT:    xxswapd vs5, vs4
; CHECK-P8-NEXT:    xscvdpsxws f4, f4
; CHECK-P8-NEXT:    mffprwz r3, f4
; CHECK-P8-NEXT:    xscvdpsxws f5, f5
; CHECK-P8-NEXT:    mtvsrd v4, r3
; CHECK-P8-NEXT:    xxswapd vs13, vs3
; CHECK-P8-NEXT:    xscvdpsxws f3, f3
; CHECK-P8-NEXT:    xscvdpsxws f13, f13
; CHECK-P8-NEXT:    xxswapd vs10, vs6
; CHECK-P8-NEXT:    xscvdpsxws f6, f6
; CHECK-P8-NEXT:    xscvdpsxws f10, f10
; CHECK-P8-NEXT:    xxswapd vs8, vs7
; CHECK-P8-NEXT:    xscvdpsxws f7, f7
; CHECK-P8-NEXT:    mffprwz r4, f7
; CHECK-P8-NEXT:    xscvdpsxws f8, f8
; CHECK-P8-NEXT:    mtvsrd v5, r4
; CHECK-P8-NEXT:    mffprwz r4, f6
; CHECK-P8-NEXT:    mtvsrd v1, r4
; CHECK-P8-NEXT:    mffprwz r4, f3
; CHECK-P8-NEXT:    xxswapd vs11, vs9
; CHECK-P8-NEXT:    xscvdpsxws f9, f9
; CHECK-P8-NEXT:    mffprwz r3, f9
; CHECK-P8-NEXT:    mtvsrd v0, r3
; CHECK-P8-NEXT:    xscvdpsxws f11, f11
; CHECK-P8-NEXT:    mtvsrd v7, r4
; CHECK-P8-NEXT:    mffprwz r4, f8
; CHECK-P8-NEXT:    mtvsrd v9, r4
; CHECK-P8-NEXT:    xxswapd v2, vs12
; CHECK-P8-NEXT:    xscvdpsxws f12, f12
; CHECK-P8-NEXT:    mffprwz r3, f12
; CHECK-P8-NEXT:    mtvsrd v6, r3
; CHECK-P8-NEXT:    mffprwz r3, f5
; CHECK-P8-NEXT:    xscvdpsxws v2, v2
; CHECK-P8-NEXT:    mtvsrd v8, r3
; CHECK-P8-NEXT:    mffprwz r3, f11
; CHECK-P8-NEXT:    xxswapd v3, vs2
; CHECK-P8-NEXT:    xscvdpsxws v3, v3
; CHECK-P8-NEXT:    mffprwz r4, f10
; CHECK-P8-NEXT:    xscvdpsxws f2, f2
; CHECK-P8-NEXT:    xxswapd vs1, vs0
; CHECK-P8-NEXT:    xscvdpsxws f1, f1
; CHECK-P8-NEXT:    xscvdpsxws f0, f0
; CHECK-P8-NEXT:    vmrghb v4, v8, v4
; CHECK-P8-NEXT:    mtvsrd v8, r3
; CHECK-P8-NEXT:    mfvsrwz r3, v2
; CHECK-P8-NEXT:    mtvsrd v2, r4
; CHECK-P8-NEXT:    mffprwz r4, f13
; CHECK-P8-NEXT:    vmrghb v5, v9, v5
; CHECK-P8-NEXT:    vmrghb v0, v8, v0
; CHECK-P8-NEXT:    mtvsrd v8, r3
; CHECK-P8-NEXT:    mfvsrwz r3, v3
; CHECK-P8-NEXT:    vmrglh v4, v5, v4
; CHECK-P8-NEXT:    mtvsrd v3, r4
; CHECK-P8-NEXT:    vmrghb v2, v2, v1
; CHECK-P8-NEXT:    vmrghb v1, v8, v6
; CHECK-P8-NEXT:    mtvsrd v6, r3
; CHECK-P8-NEXT:    mffprwz r3, f2
; CHECK-P8-NEXT:    vmrglh v2, v2, v0
; CHECK-P8-NEXT:    vmrghb v3, v3, v7
; CHECK-P8-NEXT:    mtvsrd v7, r3
; CHECK-P8-NEXT:    mffprwz r3, f1
; CHECK-P8-NEXT:    vmrglh v3, v3, v1
; CHECK-P8-NEXT:    vmrghb v6, v6, v7
; CHECK-P8-NEXT:    mtvsrd v7, r3
; CHECK-P8-NEXT:    mffprwz r3, f0
; CHECK-P8-NEXT:    xxmrglw vs0, v2, v4
; CHECK-P8-NEXT:    mtvsrd v8, r3
; CHECK-P8-NEXT:    vmrghb v7, v7, v8
; CHECK-P8-NEXT:    vmrglh v5, v7, v6
; CHECK-P8-NEXT:    xxmrglw vs1, v5, v3
; CHECK-P8-NEXT:    xxmrgld v2, vs1, vs0
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test16elt:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv vs7, 0(r3)
; CHECK-P9-NEXT:    lxv vs6, 16(r3)
; CHECK-P9-NEXT:    lxv vs0, 112(r3)
; CHECK-P9-NEXT:    lxv vs1, 96(r3)
; CHECK-P9-NEXT:    xscvdpsxws f8, f7
; CHECK-P9-NEXT:    xxswapd vs7, vs7
; CHECK-P9-NEXT:    lxv vs2, 80(r3)
; CHECK-P9-NEXT:    lxv vs3, 64(r3)
; CHECK-P9-NEXT:    lxv vs4, 48(r3)
; CHECK-P9-NEXT:    lxv vs5, 32(r3)
; CHECK-P9-NEXT:    xscvdpsxws f7, f7
; CHECK-P9-NEXT:    mffprwz r3, f8
; CHECK-P9-NEXT:    mtvsrd v2, r3
; CHECK-P9-NEXT:    mffprwz r3, f7
; CHECK-P9-NEXT:    xscvdpsxws f7, f6
; CHECK-P9-NEXT:    xxswapd vs6, vs6
; CHECK-P9-NEXT:    mtvsrd v3, r3
; CHECK-P9-NEXT:    xscvdpsxws f6, f6
; CHECK-P9-NEXT:    vmrghb v2, v2, v3
; CHECK-P9-NEXT:    mffprwz r3, f7
; CHECK-P9-NEXT:    mtvsrd v3, r3
; CHECK-P9-NEXT:    mffprwz r3, f6
; CHECK-P9-NEXT:    xscvdpsxws f6, f5
; CHECK-P9-NEXT:    xxswapd vs5, vs5
; CHECK-P9-NEXT:    mtvsrd v4, r3
; CHECK-P9-NEXT:    xscvdpsxws f5, f5
; CHECK-P9-NEXT:    vmrghb v3, v3, v4
; CHECK-P9-NEXT:    mffprwz r3, f6
; CHECK-P9-NEXT:    vmrglh v2, v3, v2
; CHECK-P9-NEXT:    mtvsrd v3, r3
; CHECK-P9-NEXT:    mffprwz r3, f5
; CHECK-P9-NEXT:    xscvdpsxws f5, f4
; CHECK-P9-NEXT:    xxswapd vs4, vs4
; CHECK-P9-NEXT:    mtvsrd v4, r3
; CHECK-P9-NEXT:    xscvdpsxws f4, f4
; CHECK-P9-NEXT:    vmrghb v3, v3, v4
; CHECK-P9-NEXT:    mffprwz r3, f5
; CHECK-P9-NEXT:    xscvdpsxws f5, f3
; CHECK-P9-NEXT:    xxswapd vs3, vs3
; CHECK-P9-NEXT:    mtvsrd v4, r3
; CHECK-P9-NEXT:    mffprwz r3, f4
; CHECK-P9-NEXT:    xscvdpsxws f3, f3
; CHECK-P9-NEXT:    mtvsrd v5, r3
; CHECK-P9-NEXT:    vmrghb v4, v4, v5
; CHECK-P9-NEXT:    mffprwz r3, f5
; CHECK-P9-NEXT:    vmrglh v3, v4, v3
; CHECK-P9-NEXT:    xxmrglw vs4, v3, v2
; CHECK-P9-NEXT:    mtvsrd v2, r3
; CHECK-P9-NEXT:    mffprwz r3, f3
; CHECK-P9-NEXT:    xscvdpsxws f3, f2
; CHECK-P9-NEXT:    xxswapd vs2, vs2
; CHECK-P9-NEXT:    mtvsrd v3, r3
; CHECK-P9-NEXT:    xscvdpsxws f2, f2
; CHECK-P9-NEXT:    vmrghb v2, v2, v3
; CHECK-P9-NEXT:    mffprwz r3, f3
; CHECK-P9-NEXT:    mtvsrd v3, r3
; CHECK-P9-NEXT:    mffprwz r3, f2
; CHECK-P9-NEXT:    xscvdpsxws f2, f1
; CHECK-P9-NEXT:    xxswapd vs1, vs1
; CHECK-P9-NEXT:    mtvsrd v4, r3
; CHECK-P9-NEXT:    xscvdpsxws f1, f1
; CHECK-P9-NEXT:    vmrghb v3, v3, v4
; CHECK-P9-NEXT:    mffprwz r3, f2
; CHECK-P9-NEXT:    vmrglh v2, v3, v2
; CHECK-P9-NEXT:    mtvsrd v3, r3
; CHECK-P9-NEXT:    mffprwz r3, f1
; CHECK-P9-NEXT:    xscvdpsxws f1, f0
; CHECK-P9-NEXT:    xxswapd vs0, vs0
; CHECK-P9-NEXT:    mtvsrd v4, r3
; CHECK-P9-NEXT:    xscvdpsxws f0, f0
; CHECK-P9-NEXT:    vmrghb v3, v3, v4
; CHECK-P9-NEXT:    mffprwz r3, f1
; CHECK-P9-NEXT:    mtvsrd v4, r3
; CHECK-P9-NEXT:    mffprwz r3, f0
; CHECK-P9-NEXT:    mtvsrd v5, r3
; CHECK-P9-NEXT:    vmrghb v4, v4, v5
; CHECK-P9-NEXT:    vmrglh v3, v4, v3
; CHECK-P9-NEXT:    xxmrglw vs0, v3, v2
; CHECK-P9-NEXT:    xxmrgld v2, vs0, vs4
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test16elt:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs7, 112(r3)
; CHECK-BE-NEXT:    lxv vs0, 0(r3)
; CHECK-BE-NEXT:    lxv vs1, 16(r3)
; CHECK-BE-NEXT:    lxv vs2, 32(r3)
; CHECK-BE-NEXT:    xscvdpsxws f9, f7
; CHECK-BE-NEXT:    xxswapd vs7, vs7
; CHECK-BE-NEXT:    lxv vs3, 48(r3)
; CHECK-BE-NEXT:    lxv vs4, 64(r3)
; CHECK-BE-NEXT:    lxv vs5, 80(r3)
; CHECK-BE-NEXT:    lxv vs6, 96(r3)
; CHECK-BE-NEXT:    addis r3, r2, .LCPI3_0@toc@ha
; CHECK-BE-NEXT:    addi r3, r3, .LCPI3_0@toc@l
; CHECK-BE-NEXT:    lxv vs8, 0(r3)
; CHECK-BE-NEXT:    xscvdpsxws f7, f7
; CHECK-BE-NEXT:    mffprwz r3, f9
; CHECK-BE-NEXT:    mtfprwz f9, r3
; CHECK-BE-NEXT:    mffprwz r3, f7
; CHECK-BE-NEXT:    xscvdpsxws f7, f6
; CHECK-BE-NEXT:    xxswapd vs6, vs6
; CHECK-BE-NEXT:    mtvsrwz v2, r3
; CHECK-BE-NEXT:    xscvdpsxws f6, f6
; CHECK-BE-NEXT:    xxperm v2, vs9, vs8
; CHECK-BE-NEXT:    mffprwz r3, f7
; CHECK-BE-NEXT:    mtfprwz f7, r3
; CHECK-BE-NEXT:    mffprwz r3, f6
; CHECK-BE-NEXT:    xscvdpsxws f6, f5
; CHECK-BE-NEXT:    xxswapd vs5, vs5
; CHECK-BE-NEXT:    mtvsrwz v3, r3
; CHECK-BE-NEXT:    xscvdpsxws f5, f5
; CHECK-BE-NEXT:    xxperm v3, vs7, vs8
; CHECK-BE-NEXT:    mffprwz r3, f6
; CHECK-BE-NEXT:    vmrghh v2, v3, v2
; CHECK-BE-NEXT:    mtfprwz f6, r3
; CHECK-BE-NEXT:    mffprwz r3, f5
; CHECK-BE-NEXT:    xscvdpsxws f5, f4
; CHECK-BE-NEXT:    xxswapd vs4, vs4
; CHECK-BE-NEXT:    mtvsrwz v3, r3
; CHECK-BE-NEXT:    xscvdpsxws f4, f4
; CHECK-BE-NEXT:    xxperm v3, vs6, vs8
; CHECK-BE-NEXT:    mffprwz r3, f5
; CHECK-BE-NEXT:    mtfprwz f5, r3
; CHECK-BE-NEXT:    mffprwz r3, f4
; CHECK-BE-NEXT:    mtvsrwz v4, r3
; CHECK-BE-NEXT:    xxperm v4, vs5, vs8
; CHECK-BE-NEXT:    xscvdpsxws f5, f3
; CHECK-BE-NEXT:    xxswapd vs3, vs3
; CHECK-BE-NEXT:    xscvdpsxws f3, f3
; CHECK-BE-NEXT:    vmrghh v3, v4, v3
; CHECK-BE-NEXT:    xxmrghw vs4, v3, v2
; CHECK-BE-NEXT:    mffprwz r3, f5
; CHECK-BE-NEXT:    mtfprwz f5, r3
; CHECK-BE-NEXT:    mffprwz r3, f3
; CHECK-BE-NEXT:    xscvdpsxws f3, f2
; CHECK-BE-NEXT:    xxswapd vs2, vs2
; CHECK-BE-NEXT:    mtvsrwz v2, r3
; CHECK-BE-NEXT:    xscvdpsxws f2, f2
; CHECK-BE-NEXT:    xxperm v2, vs5, vs8
; CHECK-BE-NEXT:    mffprwz r3, f3
; CHECK-BE-NEXT:    mtfprwz f3, r3
; CHECK-BE-NEXT:    mffprwz r3, f2
; CHECK-BE-NEXT:    xscvdpsxws f2, f1
; CHECK-BE-NEXT:    xxswapd vs1, vs1
; CHECK-BE-NEXT:    mtvsrwz v3, r3
; CHECK-BE-NEXT:    xscvdpsxws f1, f1
; CHECK-BE-NEXT:    xxperm v3, vs3, vs8
; CHECK-BE-NEXT:    mffprwz r3, f2
; CHECK-BE-NEXT:    vmrghh v2, v3, v2
; CHECK-BE-NEXT:    mtfprwz f2, r3
; CHECK-BE-NEXT:    mffprwz r3, f1
; CHECK-BE-NEXT:    xscvdpsxws f1, f0
; CHECK-BE-NEXT:    xxswapd vs0, vs0
; CHECK-BE-NEXT:    mtvsrwz v3, r3
; CHECK-BE-NEXT:    xscvdpsxws f0, f0
; CHECK-BE-NEXT:    xxperm v3, vs2, vs8
; CHECK-BE-NEXT:    mffprwz r3, f1
; CHECK-BE-NEXT:    mtfprwz f1, r3
; CHECK-BE-NEXT:    mffprwz r3, f0
; CHECK-BE-NEXT:    mtvsrwz v4, r3
; CHECK-BE-NEXT:    xxperm v4, vs1, vs8
; CHECK-BE-NEXT:    vmrghh v3, v4, v3
; CHECK-BE-NEXT:    xxmrghw vs0, v3, v2
; CHECK-BE-NEXT:    xxmrghd v2, vs0, vs4
; CHECK-BE-NEXT:    blr
entry:
  %a = load <16 x double>, ptr %0, align 128
  %1 = fptoui <16 x double> %a to <16 x i8>
  ret <16 x i8> %1
}

define i16 @test2elt_signed(<2 x double> %a) local_unnamed_addr #0 {
; CHECK-P8-LABEL: test2elt_signed:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    xscvdpsxws f1, v2
; CHECK-P8-NEXT:    xxswapd vs0, v2
; CHECK-P8-NEXT:    xscvdpsxws f0, f0
; CHECK-P8-NEXT:    mffprwz r3, f1
; CHECK-P8-NEXT:    mtvsrd v2, r3
; CHECK-P8-NEXT:    mffprwz r3, f0
; CHECK-P8-NEXT:    mtvsrd v3, r3
; CHECK-P8-NEXT:    vmrghb v2, v2, v3
; CHECK-P8-NEXT:    xxswapd vs0, v2
; CHECK-P8-NEXT:    mffprd r3, f0
; CHECK-P8-NEXT:    clrldi r3, r3, 48
; CHECK-P8-NEXT:    sth r3, -2(r1)
; CHECK-P8-NEXT:    lhz r3, -2(r1)
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test2elt_signed:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    xscvdpsxws f0, v2
; CHECK-P9-NEXT:    mffprwz r3, f0
; CHECK-P9-NEXT:    xxswapd vs0, v2
; CHECK-P9-NEXT:    mtvsrd v3, r3
; CHECK-P9-NEXT:    xscvdpsxws f0, f0
; CHECK-P9-NEXT:    mffprwz r3, f0
; CHECK-P9-NEXT:    mtvsrd v2, r3
; CHECK-P9-NEXT:    addi r3, r1, -2
; CHECK-P9-NEXT:    vmrghb v2, v3, v2
; CHECK-P9-NEXT:    vsldoi v2, v2, v2, 8
; CHECK-P9-NEXT:    stxsihx v2, 0, r3
; CHECK-P9-NEXT:    lhz r3, -2(r1)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test2elt_signed:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    xxswapd vs2, v2
; CHECK-BE-NEXT:    xscvdpsxws f1, v2
; CHECK-BE-NEXT:    addis r3, r2, .LCPI4_0@toc@ha
; CHECK-BE-NEXT:    addi r3, r3, .LCPI4_0@toc@l
; CHECK-BE-NEXT:    xscvdpsxws f2, f2
; CHECK-BE-NEXT:    lxv vs0, 0(r3)
; CHECK-BE-NEXT:    mffprwz r3, f1
; CHECK-BE-NEXT:    mtfprwz f1, r3
; CHECK-BE-NEXT:    mffprwz r3, f2
; CHECK-BE-NEXT:    mtvsrwz v2, r3
; CHECK-BE-NEXT:    addi r3, r1, -2
; CHECK-BE-NEXT:    xxperm v2, vs1, vs0
; CHECK-BE-NEXT:    vsldoi v2, v2, v2, 10
; CHECK-BE-NEXT:    stxsihx v2, 0, r3
; CHECK-BE-NEXT:    lhz r3, -2(r1)
; CHECK-BE-NEXT:    blr
entry:
  %0 = fptosi <2 x double> %a to <2 x i8>
  %1 = bitcast <2 x i8> %0 to i16
  ret i16 %1
}

define i32 @test4elt_signed(ptr nocapture readonly) local_unnamed_addr #1 {
; CHECK-P8-LABEL: test4elt_signed:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    lxvd2x vs0, 0, r3
; CHECK-P8-NEXT:    li r4, 16
; CHECK-P8-NEXT:    lxvd2x vs2, r3, r4
; CHECK-P8-NEXT:    xxswapd vs1, vs0
; CHECK-P8-NEXT:    xscvdpsxws f0, f0
; CHECK-P8-NEXT:    xscvdpsxws f1, f1
; CHECK-P8-NEXT:    mffprwz r3, f0
; CHECK-P8-NEXT:    xscvdpsxws f0, f2
; CHECK-P8-NEXT:    mffprwz r4, f1
; CHECK-P8-NEXT:    mtvsrd v2, r3
; CHECK-P8-NEXT:    mtvsrd v3, r4
; CHECK-P8-NEXT:    xxswapd vs3, vs2
; CHECK-P8-NEXT:    xscvdpsxws f3, f3
; CHECK-P8-NEXT:    mffprwz r3, f3
; CHECK-P8-NEXT:    mtvsrd v4, r3
; CHECK-P8-NEXT:    mffprwz r3, f0
; CHECK-P8-NEXT:    vmrghb v2, v3, v2
; CHECK-P8-NEXT:    mtvsrd v3, r3
; CHECK-P8-NEXT:    vmrghb v3, v4, v3
; CHECK-P8-NEXT:    vmrglh v2, v3, v2
; CHECK-P8-NEXT:    xxswapd vs0, v2
; CHECK-P8-NEXT:    mffprwz r3, f0
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test4elt_signed:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv vs1, 0(r3)
; CHECK-P9-NEXT:    lxv vs0, 16(r3)
; CHECK-P9-NEXT:    xscvdpsxws f2, f1
; CHECK-P9-NEXT:    xxswapd vs1, vs1
; CHECK-P9-NEXT:    xscvdpsxws f1, f1
; CHECK-P9-NEXT:    mffprwz r3, f2
; CHECK-P9-NEXT:    mtvsrd v2, r3
; CHECK-P9-NEXT:    mffprwz r3, f1
; CHECK-P9-NEXT:    xscvdpsxws f1, f0
; CHECK-P9-NEXT:    xxswapd vs0, vs0
; CHECK-P9-NEXT:    mtvsrd v3, r3
; CHECK-P9-NEXT:    xscvdpsxws f0, f0
; CHECK-P9-NEXT:    vmrghb v2, v2, v3
; CHECK-P9-NEXT:    mffprwz r3, f1
; CHECK-P9-NEXT:    mtvsrd v3, r3
; CHECK-P9-NEXT:    mffprwz r3, f0
; CHECK-P9-NEXT:    mtvsrd v4, r3
; CHECK-P9-NEXT:    li r3, 0
; CHECK-P9-NEXT:    vmrghb v3, v3, v4
; CHECK-P9-NEXT:    vmrglh v2, v3, v2
; CHECK-P9-NEXT:    vextuwrx r3, r3, v2
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test4elt_signed:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs1, 16(r3)
; CHECK-BE-NEXT:    lxv vs0, 0(r3)
; CHECK-BE-NEXT:    addis r3, r2, .LCPI5_0@toc@ha
; CHECK-BE-NEXT:    addi r3, r3, .LCPI5_0@toc@l
; CHECK-BE-NEXT:    lxv vs2, 0(r3)
; CHECK-BE-NEXT:    xscvdpsxws f3, f1
; CHECK-BE-NEXT:    xxswapd vs1, vs1
; CHECK-BE-NEXT:    xscvdpsxws f1, f1
; CHECK-BE-NEXT:    mffprwz r3, f3
; CHECK-BE-NEXT:    mtfprwz f3, r3
; CHECK-BE-NEXT:    mffprwz r3, f1
; CHECK-BE-NEXT:    xscvdpsxws f1, f0
; CHECK-BE-NEXT:    xxswapd vs0, vs0
; CHECK-BE-NEXT:    mtvsrwz v2, r3
; CHECK-BE-NEXT:    xscvdpsxws f0, f0
; CHECK-BE-NEXT:    xxperm v2, vs3, vs2
; CHECK-BE-NEXT:    mffprwz r3, f1
; CHECK-BE-NEXT:    mtfprwz f1, r3
; CHECK-BE-NEXT:    mffprwz r3, f0
; CHECK-BE-NEXT:    mtvsrwz v3, r3
; CHECK-BE-NEXT:    li r3, 0
; CHECK-BE-NEXT:    xxperm v3, vs1, vs2
; CHECK-BE-NEXT:    vmrghh v2, v3, v2
; CHECK-BE-NEXT:    vextuwlx r3, r3, v2
; CHECK-BE-NEXT:    blr
entry:
  %a = load <4 x double>, ptr %0, align 32
  %1 = fptosi <4 x double> %a to <4 x i8>
  %2 = bitcast <4 x i8> %1 to i32
  ret i32 %2
}

define i64 @test8elt_signed(ptr nocapture readonly) local_unnamed_addr #1 {
; CHECK-P8-LABEL: test8elt_signed:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r4, 16
; CHECK-P8-NEXT:    lxvd2x vs1, 0, r3
; CHECK-P8-NEXT:    lxvd2x vs0, r3, r4
; CHECK-P8-NEXT:    li r4, 32
; CHECK-P8-NEXT:    lxvd2x vs4, r3, r4
; CHECK-P8-NEXT:    li r4, 48
; CHECK-P8-NEXT:    lxvd2x vs6, r3, r4
; CHECK-P8-NEXT:    xxswapd vs3, vs1
; CHECK-P8-NEXT:    xscvdpsxws f1, f1
; CHECK-P8-NEXT:    xscvdpsxws f3, f3
; CHECK-P8-NEXT:    mffprwz r3, f1
; CHECK-P8-NEXT:    mtvsrd v2, r3
; CHECK-P8-NEXT:    xxswapd vs2, vs0
; CHECK-P8-NEXT:    xscvdpsxws f0, f0
; CHECK-P8-NEXT:    mffprwz r4, f0
; CHECK-P8-NEXT:    xscvdpsxws f2, f2
; CHECK-P8-NEXT:    xscvdpsxws f0, f6
; CHECK-P8-NEXT:    mtvsrd v3, r4
; CHECK-P8-NEXT:    mffprwz r4, f3
; CHECK-P8-NEXT:    mtvsrd v5, r4
; CHECK-P8-NEXT:    xxswapd vs5, vs4
; CHECK-P8-NEXT:    xscvdpsxws f4, f4
; CHECK-P8-NEXT:    mffprwz r3, f4
; CHECK-P8-NEXT:    xscvdpsxws f5, f5
; CHECK-P8-NEXT:    mtvsrd v4, r3
; CHECK-P8-NEXT:    mffprwz r3, f2
; CHECK-P8-NEXT:    mffprwz r4, f5
; CHECK-P8-NEXT:    xxswapd vs7, vs6
; CHECK-P8-NEXT:    xscvdpsxws f7, f7
; CHECK-P8-NEXT:    vmrghb v2, v5, v2
; CHECK-P8-NEXT:    mtvsrd v5, r3
; CHECK-P8-NEXT:    mffprwz r3, f7
; CHECK-P8-NEXT:    mtvsrd v0, r3
; CHECK-P8-NEXT:    mffprwz r3, f0
; CHECK-P8-NEXT:    vmrghb v3, v5, v3
; CHECK-P8-NEXT:    mtvsrd v5, r4
; CHECK-P8-NEXT:    vmrglh v2, v3, v2
; CHECK-P8-NEXT:    vmrghb v4, v5, v4
; CHECK-P8-NEXT:    mtvsrd v5, r3
; CHECK-P8-NEXT:    vmrghb v5, v0, v5
; CHECK-P8-NEXT:    vmrglh v3, v5, v4
; CHECK-P8-NEXT:    xxmrglw vs0, v3, v2
; CHECK-P8-NEXT:    xxswapd vs0, vs0
; CHECK-P8-NEXT:    mffprd r3, f0
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test8elt_signed:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv vs3, 0(r3)
; CHECK-P9-NEXT:    lxv vs2, 16(r3)
; CHECK-P9-NEXT:    lxv vs0, 48(r3)
; CHECK-P9-NEXT:    lxv vs1, 32(r3)
; CHECK-P9-NEXT:    xscvdpsxws f4, f3
; CHECK-P9-NEXT:    xxswapd vs3, vs3
; CHECK-P9-NEXT:    xscvdpsxws f3, f3
; CHECK-P9-NEXT:    mffprwz r3, f4
; CHECK-P9-NEXT:    mtvsrd v2, r3
; CHECK-P9-NEXT:    mffprwz r3, f3
; CHECK-P9-NEXT:    xscvdpsxws f3, f2
; CHECK-P9-NEXT:    xxswapd vs2, vs2
; CHECK-P9-NEXT:    mtvsrd v3, r3
; CHECK-P9-NEXT:    xscvdpsxws f2, f2
; CHECK-P9-NEXT:    vmrghb v2, v2, v3
; CHECK-P9-NEXT:    mffprwz r3, f3
; CHECK-P9-NEXT:    mtvsrd v3, r3
; CHECK-P9-NEXT:    mffprwz r3, f2
; CHECK-P9-NEXT:    xscvdpsxws f2, f1
; CHECK-P9-NEXT:    xxswapd vs1, vs1
; CHECK-P9-NEXT:    mtvsrd v4, r3
; CHECK-P9-NEXT:    xscvdpsxws f1, f1
; CHECK-P9-NEXT:    vmrghb v3, v3, v4
; CHECK-P9-NEXT:    mffprwz r3, f2
; CHECK-P9-NEXT:    vmrglh v2, v3, v2
; CHECK-P9-NEXT:    mtvsrd v3, r3
; CHECK-P9-NEXT:    mffprwz r3, f1
; CHECK-P9-NEXT:    xscvdpsxws f1, f0
; CHECK-P9-NEXT:    xxswapd vs0, vs0
; CHECK-P9-NEXT:    mtvsrd v4, r3
; CHECK-P9-NEXT:    xscvdpsxws f0, f0
; CHECK-P9-NEXT:    vmrghb v3, v3, v4
; CHECK-P9-NEXT:    mffprwz r3, f1
; CHECK-P9-NEXT:    mtvsrd v4, r3
; CHECK-P9-NEXT:    mffprwz r3, f0
; CHECK-P9-NEXT:    mtvsrd v5, r3
; CHECK-P9-NEXT:    vmrghb v4, v4, v5
; CHECK-P9-NEXT:    vmrglh v3, v4, v3
; CHECK-P9-NEXT:    xxmrglw vs0, v3, v2
; CHECK-P9-NEXT:    mfvsrld r3, vs0
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test8elt_signed:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs3, 48(r3)
; CHECK-BE-NEXT:    lxv vs0, 0(r3)
; CHECK-BE-NEXT:    lxv vs1, 16(r3)
; CHECK-BE-NEXT:    lxv vs2, 32(r3)
; CHECK-BE-NEXT:    addis r3, r2, .LCPI6_0@toc@ha
; CHECK-BE-NEXT:    addi r3, r3, .LCPI6_0@toc@l
; CHECK-BE-NEXT:    lxv vs4, 0(r3)
; CHECK-BE-NEXT:    xscvdpsxws f5, f3
; CHECK-BE-NEXT:    xxswapd vs3, vs3
; CHECK-BE-NEXT:    xscvdpsxws f3, f3
; CHECK-BE-NEXT:    mffprwz r3, f5
; CHECK-BE-NEXT:    mtfprwz f5, r3
; CHECK-BE-NEXT:    mffprwz r3, f3
; CHECK-BE-NEXT:    xscvdpsxws f3, f2
; CHECK-BE-NEXT:    xxswapd vs2, vs2
; CHECK-BE-NEXT:    mtvsrwz v2, r3
; CHECK-BE-NEXT:    xscvdpsxws f2, f2
; CHECK-BE-NEXT:    xxperm v2, vs5, vs4
; CHECK-BE-NEXT:    mffprwz r3, f3
; CHECK-BE-NEXT:    mtfprwz f3, r3
; CHECK-BE-NEXT:    mffprwz r3, f2
; CHECK-BE-NEXT:    xscvdpsxws f2, f1
; CHECK-BE-NEXT:    xxswapd vs1, vs1
; CHECK-BE-NEXT:    mtvsrwz v3, r3
; CHECK-BE-NEXT:    xscvdpsxws f1, f1
; CHECK-BE-NEXT:    xxperm v3, vs3, vs4
; CHECK-BE-NEXT:    mffprwz r3, f2
; CHECK-BE-NEXT:    vmrghh v2, v3, v2
; CHECK-BE-NEXT:    mtfprwz f2, r3
; CHECK-BE-NEXT:    mffprwz r3, f1
; CHECK-BE-NEXT:    xscvdpsxws f1, f0
; CHECK-BE-NEXT:    xxswapd vs0, vs0
; CHECK-BE-NEXT:    mtvsrwz v3, r3
; CHECK-BE-NEXT:    xscvdpsxws f0, f0
; CHECK-BE-NEXT:    xxperm v3, vs2, vs4
; CHECK-BE-NEXT:    mffprwz r3, f1
; CHECK-BE-NEXT:    mtfprwz f1, r3
; CHECK-BE-NEXT:    mffprwz r3, f0
; CHECK-BE-NEXT:    mtvsrwz v4, r3
; CHECK-BE-NEXT:    xxperm v4, vs1, vs4
; CHECK-BE-NEXT:    vmrghh v3, v4, v3
; CHECK-BE-NEXT:    xxmrghw vs0, v3, v2
; CHECK-BE-NEXT:    mffprd r3, f0
; CHECK-BE-NEXT:    blr
entry:
  %a = load <8 x double>, ptr %0, align 64
  %1 = fptosi <8 x double> %a to <8 x i8>
  %2 = bitcast <8 x i8> %1 to i64
  ret i64 %2
}

define <16 x i8> @test16elt_signed(ptr nocapture readonly) local_unnamed_addr #2 {
; CHECK-P8-LABEL: test16elt_signed:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r4, 80
; CHECK-P8-NEXT:    lxvd2x vs4, 0, r3
; CHECK-P8-NEXT:    lxvd2x vs3, r3, r4
; CHECK-P8-NEXT:    li r4, 48
; CHECK-P8-NEXT:    lxvd2x vs6, r3, r4
; CHECK-P8-NEXT:    li r4, 16
; CHECK-P8-NEXT:    lxvd2x vs7, r3, r4
; CHECK-P8-NEXT:    li r4, 32
; CHECK-P8-NEXT:    lxvd2x vs9, r3, r4
; CHECK-P8-NEXT:    li r4, 64
; CHECK-P8-NEXT:    lxvd2x vs12, r3, r4
; CHECK-P8-NEXT:    li r4, 96
; CHECK-P8-NEXT:    lxvd2x vs2, r3, r4
; CHECK-P8-NEXT:    li r4, 112
; CHECK-P8-NEXT:    lxvd2x vs0, r3, r4
; CHECK-P8-NEXT:    xxswapd vs5, vs4
; CHECK-P8-NEXT:    xscvdpsxws f4, f4
; CHECK-P8-NEXT:    mffprwz r3, f4
; CHECK-P8-NEXT:    xscvdpsxws f5, f5
; CHECK-P8-NEXT:    mtvsrd v4, r3
; CHECK-P8-NEXT:    xxswapd vs13, vs3
; CHECK-P8-NEXT:    xscvdpsxws f3, f3
; CHECK-P8-NEXT:    xscvdpsxws f13, f13
; CHECK-P8-NEXT:    xxswapd vs10, vs6
; CHECK-P8-NEXT:    xscvdpsxws f6, f6
; CHECK-P8-NEXT:    xscvdpsxws f10, f10
; CHECK-P8-NEXT:    xxswapd vs8, vs7
; CHECK-P8-NEXT:    xscvdpsxws f7, f7
; CHECK-P8-NEXT:    mffprwz r4, f7
; CHECK-P8-NEXT:    xscvdpsxws f8, f8
; CHECK-P8-NEXT:    mtvsrd v5, r4
; CHECK-P8-NEXT:    mffprwz r4, f6
; CHECK-P8-NEXT:    mtvsrd v1, r4
; CHECK-P8-NEXT:    mffprwz r4, f3
; CHECK-P8-NEXT:    xxswapd vs11, vs9
; CHECK-P8-NEXT:    xscvdpsxws f9, f9
; CHECK-P8-NEXT:    mffprwz r3, f9
; CHECK-P8-NEXT:    mtvsrd v0, r3
; CHECK-P8-NEXT:    xscvdpsxws f11, f11
; CHECK-P8-NEXT:    mtvsrd v7, r4
; CHECK-P8-NEXT:    mffprwz r4, f8
; CHECK-P8-NEXT:    mtvsrd v9, r4
; CHECK-P8-NEXT:    xxswapd v2, vs12
; CHECK-P8-NEXT:    xscvdpsxws f12, f12
; CHECK-P8-NEXT:    mffprwz r3, f12
; CHECK-P8-NEXT:    mtvsrd v6, r3
; CHECK-P8-NEXT:    mffprwz r3, f5
; CHECK-P8-NEXT:    xscvdpsxws v2, v2
; CHECK-P8-NEXT:    mtvsrd v8, r3
; CHECK-P8-NEXT:    mffprwz r3, f11
; CHECK-P8-NEXT:    xxswapd v3, vs2
; CHECK-P8-NEXT:    xscvdpsxws v3, v3
; CHECK-P8-NEXT:    mffprwz r4, f10
; CHECK-P8-NEXT:    xscvdpsxws f2, f2
; CHECK-P8-NEXT:    xxswapd vs1, vs0
; CHECK-P8-NEXT:    xscvdpsxws f1, f1
; CHECK-P8-NEXT:    xscvdpsxws f0, f0
; CHECK-P8-NEXT:    vmrghb v4, v8, v4
; CHECK-P8-NEXT:    mtvsrd v8, r3
; CHECK-P8-NEXT:    mfvsrwz r3, v2
; CHECK-P8-NEXT:    mtvsrd v2, r4
; CHECK-P8-NEXT:    mffprwz r4, f13
; CHECK-P8-NEXT:    vmrghb v5, v9, v5
; CHECK-P8-NEXT:    vmrghb v0, v8, v0
; CHECK-P8-NEXT:    mtvsrd v8, r3
; CHECK-P8-NEXT:    mfvsrwz r3, v3
; CHECK-P8-NEXT:    vmrglh v4, v5, v4
; CHECK-P8-NEXT:    mtvsrd v3, r4
; CHECK-P8-NEXT:    vmrghb v2, v2, v1
; CHECK-P8-NEXT:    vmrghb v1, v8, v6
; CHECK-P8-NEXT:    mtvsrd v6, r3
; CHECK-P8-NEXT:    mffprwz r3, f2
; CHECK-P8-NEXT:    vmrglh v2, v2, v0
; CHECK-P8-NEXT:    vmrghb v3, v3, v7
; CHECK-P8-NEXT:    mtvsrd v7, r3
; CHECK-P8-NEXT:    mffprwz r3, f1
; CHECK-P8-NEXT:    vmrglh v3, v3, v1
; CHECK-P8-NEXT:    vmrghb v6, v6, v7
; CHECK-P8-NEXT:    mtvsrd v7, r3
; CHECK-P8-NEXT:    mffprwz r3, f0
; CHECK-P8-NEXT:    xxmrglw vs0, v2, v4
; CHECK-P8-NEXT:    mtvsrd v8, r3
; CHECK-P8-NEXT:    vmrghb v7, v7, v8
; CHECK-P8-NEXT:    vmrglh v5, v7, v6
; CHECK-P8-NEXT:    xxmrglw vs1, v5, v3
; CHECK-P8-NEXT:    xxmrgld v2, vs1, vs0
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test16elt_signed:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv vs7, 0(r3)
; CHECK-P9-NEXT:    lxv vs6, 16(r3)
; CHECK-P9-NEXT:    lxv vs0, 112(r3)
; CHECK-P9-NEXT:    lxv vs1, 96(r3)
; CHECK-P9-NEXT:    xscvdpsxws f8, f7
; CHECK-P9-NEXT:    xxswapd vs7, vs7
; CHECK-P9-NEXT:    lxv vs2, 80(r3)
; CHECK-P9-NEXT:    lxv vs3, 64(r3)
; CHECK-P9-NEXT:    lxv vs4, 48(r3)
; CHECK-P9-NEXT:    lxv vs5, 32(r3)
; CHECK-P9-NEXT:    xscvdpsxws f7, f7
; CHECK-P9-NEXT:    mffprwz r3, f8
; CHECK-P9-NEXT:    mtvsrd v2, r3
; CHECK-P9-NEXT:    mffprwz r3, f7
; CHECK-P9-NEXT:    xscvdpsxws f7, f6
; CHECK-P9-NEXT:    xxswapd vs6, vs6
; CHECK-P9-NEXT:    mtvsrd v3, r3
; CHECK-P9-NEXT:    xscvdpsxws f6, f6
; CHECK-P9-NEXT:    vmrghb v2, v2, v3
; CHECK-P9-NEXT:    mffprwz r3, f7
; CHECK-P9-NEXT:    mtvsrd v3, r3
; CHECK-P9-NEXT:    mffprwz r3, f6
; CHECK-P9-NEXT:    xscvdpsxws f6, f5
; CHECK-P9-NEXT:    xxswapd vs5, vs5
; CHECK-P9-NEXT:    mtvsrd v4, r3
; CHECK-P9-NEXT:    xscvdpsxws f5, f5
; CHECK-P9-NEXT:    vmrghb v3, v3, v4
; CHECK-P9-NEXT:    mffprwz r3, f6
; CHECK-P9-NEXT:    vmrglh v2, v3, v2
; CHECK-P9-NEXT:    mtvsrd v3, r3
; CHECK-P9-NEXT:    mffprwz r3, f5
; CHECK-P9-NEXT:    xscvdpsxws f5, f4
; CHECK-P9-NEXT:    xxswapd vs4, vs4
; CHECK-P9-NEXT:    mtvsrd v4, r3
; CHECK-P9-NEXT:    xscvdpsxws f4, f4
; CHECK-P9-NEXT:    vmrghb v3, v3, v4
; CHECK-P9-NEXT:    mffprwz r3, f5
; CHECK-P9-NEXT:    xscvdpsxws f5, f3
; CHECK-P9-NEXT:    xxswapd vs3, vs3
; CHECK-P9-NEXT:    mtvsrd v4, r3
; CHECK-P9-NEXT:    mffprwz r3, f4
; CHECK-P9-NEXT:    xscvdpsxws f3, f3
; CHECK-P9-NEXT:    mtvsrd v5, r3
; CHECK-P9-NEXT:    vmrghb v4, v4, v5
; CHECK-P9-NEXT:    mffprwz r3, f5
; CHECK-P9-NEXT:    vmrglh v3, v4, v3
; CHECK-P9-NEXT:    xxmrglw vs4, v3, v2
; CHECK-P9-NEXT:    mtvsrd v2, r3
; CHECK-P9-NEXT:    mffprwz r3, f3
; CHECK-P9-NEXT:    xscvdpsxws f3, f2
; CHECK-P9-NEXT:    xxswapd vs2, vs2
; CHECK-P9-NEXT:    mtvsrd v3, r3
; CHECK-P9-NEXT:    xscvdpsxws f2, f2
; CHECK-P9-NEXT:    vmrghb v2, v2, v3
; CHECK-P9-NEXT:    mffprwz r3, f3
; CHECK-P9-NEXT:    mtvsrd v3, r3
; CHECK-P9-NEXT:    mffprwz r3, f2
; CHECK-P9-NEXT:    xscvdpsxws f2, f1
; CHECK-P9-NEXT:    xxswapd vs1, vs1
; CHECK-P9-NEXT:    mtvsrd v4, r3
; CHECK-P9-NEXT:    xscvdpsxws f1, f1
; CHECK-P9-NEXT:    vmrghb v3, v3, v4
; CHECK-P9-NEXT:    mffprwz r3, f2
; CHECK-P9-NEXT:    vmrglh v2, v3, v2
; CHECK-P9-NEXT:    mtvsrd v3, r3
; CHECK-P9-NEXT:    mffprwz r3, f1
; CHECK-P9-NEXT:    xscvdpsxws f1, f0
; CHECK-P9-NEXT:    xxswapd vs0, vs0
; CHECK-P9-NEXT:    mtvsrd v4, r3
; CHECK-P9-NEXT:    xscvdpsxws f0, f0
; CHECK-P9-NEXT:    vmrghb v3, v3, v4
; CHECK-P9-NEXT:    mffprwz r3, f1
; CHECK-P9-NEXT:    mtvsrd v4, r3
; CHECK-P9-NEXT:    mffprwz r3, f0
; CHECK-P9-NEXT:    mtvsrd v5, r3
; CHECK-P9-NEXT:    vmrghb v4, v4, v5
; CHECK-P9-NEXT:    vmrglh v3, v4, v3
; CHECK-P9-NEXT:    xxmrglw vs0, v3, v2
; CHECK-P9-NEXT:    xxmrgld v2, vs0, vs4
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test16elt_signed:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs7, 112(r3)
; CHECK-BE-NEXT:    lxv vs0, 0(r3)
; CHECK-BE-NEXT:    lxv vs1, 16(r3)
; CHECK-BE-NEXT:    lxv vs2, 32(r3)
; CHECK-BE-NEXT:    xscvdpsxws f9, f7
; CHECK-BE-NEXT:    xxswapd vs7, vs7
; CHECK-BE-NEXT:    lxv vs3, 48(r3)
; CHECK-BE-NEXT:    lxv vs4, 64(r3)
; CHECK-BE-NEXT:    lxv vs5, 80(r3)
; CHECK-BE-NEXT:    lxv vs6, 96(r3)
; CHECK-BE-NEXT:    addis r3, r2, .LCPI7_0@toc@ha
; CHECK-BE-NEXT:    addi r3, r3, .LCPI7_0@toc@l
; CHECK-BE-NEXT:    lxv vs8, 0(r3)
; CHECK-BE-NEXT:    xscvdpsxws f7, f7
; CHECK-BE-NEXT:    mffprwz r3, f9
; CHECK-BE-NEXT:    mtfprwz f9, r3
; CHECK-BE-NEXT:    mffprwz r3, f7
; CHECK-BE-NEXT:    xscvdpsxws f7, f6
; CHECK-BE-NEXT:    xxswapd vs6, vs6
; CHECK-BE-NEXT:    mtvsrwz v2, r3
; CHECK-BE-NEXT:    xscvdpsxws f6, f6
; CHECK-BE-NEXT:    xxperm v2, vs9, vs8
; CHECK-BE-NEXT:    mffprwz r3, f7
; CHECK-BE-NEXT:    mtfprwz f7, r3
; CHECK-BE-NEXT:    mffprwz r3, f6
; CHECK-BE-NEXT:    xscvdpsxws f6, f5
; CHECK-BE-NEXT:    xxswapd vs5, vs5
; CHECK-BE-NEXT:    mtvsrwz v3, r3
; CHECK-BE-NEXT:    xscvdpsxws f5, f5
; CHECK-BE-NEXT:    xxperm v3, vs7, vs8
; CHECK-BE-NEXT:    mffprwz r3, f6
; CHECK-BE-NEXT:    vmrghh v2, v3, v2
; CHECK-BE-NEXT:    mtfprwz f6, r3
; CHECK-BE-NEXT:    mffprwz r3, f5
; CHECK-BE-NEXT:    xscvdpsxws f5, f4
; CHECK-BE-NEXT:    xxswapd vs4, vs4
; CHECK-BE-NEXT:    mtvsrwz v3, r3
; CHECK-BE-NEXT:    xscvdpsxws f4, f4
; CHECK-BE-NEXT:    xxperm v3, vs6, vs8
; CHECK-BE-NEXT:    mffprwz r3, f5
; CHECK-BE-NEXT:    mtfprwz f5, r3
; CHECK-BE-NEXT:    mffprwz r3, f4
; CHECK-BE-NEXT:    mtvsrwz v4, r3
; CHECK-BE-NEXT:    xxperm v4, vs5, vs8
; CHECK-BE-NEXT:    xscvdpsxws f5, f3
; CHECK-BE-NEXT:    xxswapd vs3, vs3
; CHECK-BE-NEXT:    xscvdpsxws f3, f3
; CHECK-BE-NEXT:    vmrghh v3, v4, v3
; CHECK-BE-NEXT:    xxmrghw vs4, v3, v2
; CHECK-BE-NEXT:    mffprwz r3, f5
; CHECK-BE-NEXT:    mtfprwz f5, r3
; CHECK-BE-NEXT:    mffprwz r3, f3
; CHECK-BE-NEXT:    xscvdpsxws f3, f2
; CHECK-BE-NEXT:    xxswapd vs2, vs2
; CHECK-BE-NEXT:    mtvsrwz v2, r3
; CHECK-BE-NEXT:    xscvdpsxws f2, f2
; CHECK-BE-NEXT:    xxperm v2, vs5, vs8
; CHECK-BE-NEXT:    mffprwz r3, f3
; CHECK-BE-NEXT:    mtfprwz f3, r3
; CHECK-BE-NEXT:    mffprwz r3, f2
; CHECK-BE-NEXT:    xscvdpsxws f2, f1
; CHECK-BE-NEXT:    xxswapd vs1, vs1
; CHECK-BE-NEXT:    mtvsrwz v3, r3
; CHECK-BE-NEXT:    xscvdpsxws f1, f1
; CHECK-BE-NEXT:    xxperm v3, vs3, vs8
; CHECK-BE-NEXT:    mffprwz r3, f2
; CHECK-BE-NEXT:    vmrghh v2, v3, v2
; CHECK-BE-NEXT:    mtfprwz f2, r3
; CHECK-BE-NEXT:    mffprwz r3, f1
; CHECK-BE-NEXT:    xscvdpsxws f1, f0
; CHECK-BE-NEXT:    xxswapd vs0, vs0
; CHECK-BE-NEXT:    mtvsrwz v3, r3
; CHECK-BE-NEXT:    xscvdpsxws f0, f0
; CHECK-BE-NEXT:    xxperm v3, vs2, vs8
; CHECK-BE-NEXT:    mffprwz r3, f1
; CHECK-BE-NEXT:    mtfprwz f1, r3
; CHECK-BE-NEXT:    mffprwz r3, f0
; CHECK-BE-NEXT:    mtvsrwz v4, r3
; CHECK-BE-NEXT:    xxperm v4, vs1, vs8
; CHECK-BE-NEXT:    vmrghh v3, v4, v3
; CHECK-BE-NEXT:    xxmrghw vs0, v3, v2
; CHECK-BE-NEXT:    xxmrghd v2, vs0, vs4
; CHECK-BE-NEXT:    blr
entry:
  %a = load <16 x double>, ptr %0, align 128
  %1 = fptosi <16 x double> %a to <16 x i8>
  ret <16 x i8> %1
}
