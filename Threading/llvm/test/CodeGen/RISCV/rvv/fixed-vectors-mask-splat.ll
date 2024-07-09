; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+v -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,RV32
; RUN: llc -mtriple=riscv64 -mattr=+v -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,RV64

define void @splat_ones_v1i1(ptr %x) {
; CHECK-LABEL: splat_ones_v1i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li a1, 1
; CHECK-NEXT:    sb a1, 0(a0)
; CHECK-NEXT:    ret
  store <1 x i1> <i1 1>, ptr %x
  ret void
}

define void @splat_zeros_v2i1(ptr %x) {
; CHECK-LABEL: splat_zeros_v2i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    sb zero, 0(a0)
; CHECK-NEXT:    ret
  store <2 x i1> zeroinitializer, ptr %x
  ret void
}

define void @splat_v1i1(ptr %x, i1 %y) {
; CHECK-LABEL: splat_v1i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e8, mf8, ta, ma
; CHECK-NEXT:    andi a1, a1, 1
; CHECK-NEXT:    vmv.s.x v8, a1
; CHECK-NEXT:    vmsne.vi v0, v8, 0
; CHECK-NEXT:    vmv.s.x v8, zero
; CHECK-NEXT:    vmerge.vim v8, v8, 1, v0
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, ma
; CHECK-NEXT:    vmv.v.i v9, 0
; CHECK-NEXT:    vsetivli zero, 1, e8, mf2, tu, ma
; CHECK-NEXT:    vmv.v.v v9, v8
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, ma
; CHECK-NEXT:    vmsne.vi v8, v9, 0
; CHECK-NEXT:    vsm.v v8, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <1 x i1> poison, i1 %y, i32 0
  %b = shufflevector <1 x i1> %a, <1 x i1> poison, <1 x i32> zeroinitializer
  store <1 x i1> %b, ptr %x
  ret void
}

define void @splat_v1i1_icmp(ptr %x, i32 signext %y, i32 signext %z) {
; CHECK-LABEL: splat_v1i1_icmp:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xor a1, a1, a2
; CHECK-NEXT:    seqz a1, a1
; CHECK-NEXT:    vsetivli zero, 1, e8, mf8, ta, ma
; CHECK-NEXT:    vmv.s.x v8, a1
; CHECK-NEXT:    vmsne.vi v0, v8, 0
; CHECK-NEXT:    vmv.s.x v8, zero
; CHECK-NEXT:    vmerge.vim v8, v8, 1, v0
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, ma
; CHECK-NEXT:    vmv.v.i v9, 0
; CHECK-NEXT:    vsetivli zero, 1, e8, mf2, tu, ma
; CHECK-NEXT:    vmv.v.v v9, v8
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, ma
; CHECK-NEXT:    vmsne.vi v8, v9, 0
; CHECK-NEXT:    vsm.v v8, (a0)
; CHECK-NEXT:    ret
  %c = icmp eq i32 %y, %z
  %a = insertelement <1 x i1> poison, i1 %c, i32 0
  %b = shufflevector <1 x i1> %a, <1 x i1> poison, <1 x i32> zeroinitializer
  store <1 x i1> %b, ptr %x
  ret void
}

define void @splat_ones_v4i1(ptr %x) {
; CHECK-LABEL: splat_ones_v4i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li a1, 15
; CHECK-NEXT:    sb a1, 0(a0)
; CHECK-NEXT:    ret
  store <4 x i1> <i1 1, i1 1, i1 1, i1 1>, ptr %x
  ret void
}

define void @splat_v4i1(ptr %x, i1 %y) {
; CHECK-LABEL: splat_v4i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    andi a1, a1, 1
; CHECK-NEXT:    vsetivli zero, 4, e8, mf4, ta, ma
; CHECK-NEXT:    vmv.v.x v8, a1
; CHECK-NEXT:    vmsne.vi v0, v8, 0
; CHECK-NEXT:    vmv.v.i v8, 0
; CHECK-NEXT:    vmerge.vim v8, v8, 1, v0
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, ma
; CHECK-NEXT:    vmv.v.i v9, 0
; CHECK-NEXT:    vsetivli zero, 4, e8, mf2, tu, ma
; CHECK-NEXT:    vmv.v.v v9, v8
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, ma
; CHECK-NEXT:    vmsne.vi v8, v9, 0
; CHECK-NEXT:    vsm.v v8, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <4 x i1> poison, i1 %y, i32 0
  %b = shufflevector <4 x i1> %a, <4 x i1> poison, <4 x i32> zeroinitializer
  store <4 x i1> %b, ptr %x
  ret void
}

define void @splat_zeros_v8i1(ptr %x) {
; CHECK-LABEL: splat_zeros_v8i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    sb zero, 0(a0)
; CHECK-NEXT:    ret
  store <8 x i1> zeroinitializer, ptr %x
  ret void
}

define void @splat_v8i1(ptr %x, i1 %y) {
; CHECK-LABEL: splat_v8i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    andi a1, a1, 1
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, ma
; CHECK-NEXT:    vmv.v.x v8, a1
; CHECK-NEXT:    vmsne.vi v8, v8, 0
; CHECK-NEXT:    vsm.v v8, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <8 x i1> poison, i1 %y, i32 0
  %b = shufflevector <8 x i1> %a, <8 x i1> poison, <8 x i32> zeroinitializer
  store <8 x i1> %b, ptr %x
  ret void
}

define void @splat_ones_v16i1(ptr %x) {
; CHECK-LABEL: splat_ones_v16i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li a1, -1
; CHECK-NEXT:    sh a1, 0(a0)
; CHECK-NEXT:    ret
  store <16 x i1> <i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1>, ptr %x
  ret void
}

define void @splat_v16i1(ptr %x, i1 %y) {
; CHECK-LABEL: splat_v16i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    andi a1, a1, 1
; CHECK-NEXT:    vsetivli zero, 16, e8, m1, ta, ma
; CHECK-NEXT:    vmv.v.x v8, a1
; CHECK-NEXT:    vmsne.vi v8, v8, 0
; CHECK-NEXT:    vsm.v v8, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <16 x i1> poison, i1 %y, i32 0
  %b = shufflevector <16 x i1> %a, <16 x i1> poison, <16 x i32> zeroinitializer
  store <16 x i1> %b, ptr %x
  ret void
}

define void @splat_zeros_v32i1(ptr %x) {
; CHECK-LABEL: splat_zeros_v32i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    sw zero, 0(a0)
; CHECK-NEXT:    ret
  store <32 x i1> zeroinitializer, ptr %x
  ret void
}

define void @splat_v32i1(ptr %x, i1 %y) {
; CHECK-LABEL: splat_v32i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    andi a1, a1, 1
; CHECK-NEXT:    li a2, 32
; CHECK-NEXT:    vsetvli zero, a2, e8, m2, ta, ma
; CHECK-NEXT:    vmv.v.x v8, a1
; CHECK-NEXT:    vmsne.vi v10, v8, 0
; CHECK-NEXT:    vsm.v v10, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <32 x i1> poison, i1 %y, i32 0
  %b = shufflevector <32 x i1> %a, <32 x i1> poison, <32 x i32> zeroinitializer
  store <32 x i1> %b, ptr %x
  ret void
}

define void @splat_ones_v64i1(ptr %x) {
; RV32-LABEL: splat_ones_v64i1:
; RV32:       # %bb.0:
; RV32-NEXT:    li a1, 64
; RV32-NEXT:    vsetvli zero, a1, e8, m4, ta, ma
; RV32-NEXT:    vmset.m v8
; RV32-NEXT:    vsm.v v8, (a0)
; RV32-NEXT:    ret
;
; RV64-LABEL: splat_ones_v64i1:
; RV64:       # %bb.0:
; RV64-NEXT:    li a1, -1
; RV64-NEXT:    sd a1, 0(a0)
; RV64-NEXT:    ret
  store <64 x i1> <i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1, i1 1>, ptr %x
  ret void
}

define void @splat_v64i1(ptr %x, i1 %y) {
; CHECK-LABEL: splat_v64i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    andi a1, a1, 1
; CHECK-NEXT:    li a2, 64
; CHECK-NEXT:    vsetvli zero, a2, e8, m4, ta, ma
; CHECK-NEXT:    vmv.v.x v8, a1
; CHECK-NEXT:    vmsne.vi v12, v8, 0
; CHECK-NEXT:    vsm.v v12, (a0)
; CHECK-NEXT:    ret
  %a = insertelement <64 x i1> poison, i1 %y, i32 0
  %b = shufflevector <64 x i1> %a, <64 x i1> poison, <64 x i32> zeroinitializer
  store <64 x i1> %b, ptr %x
  ret void
}
