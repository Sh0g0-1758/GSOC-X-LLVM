; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+m,+v < %s | FileCheck %s --check-prefix=RV32
; RUN: llc -mtriple=riscv64 -mattr=+m,+v < %s | FileCheck %s --check-prefix=RV64

define <vscale x 1 x i16> @test_urem_vec_even_divisor_eq0(<vscale x 1 x i16> %x) nounwind {
; RV32-LABEL: test_urem_vec_even_divisor_eq0:
; RV32:       # %bb.0:
; RV32-NEXT:    lui a0, 1048571
; RV32-NEXT:    addi a0, a0, -1365
; RV32-NEXT:    vsetvli a1, zero, e16, mf4, ta, ma
; RV32-NEXT:    vmul.vx v8, v8, a0
; RV32-NEXT:    vsll.vi v9, v8, 15
; RV32-NEXT:    vsrl.vi v8, v8, 1
; RV32-NEXT:    vor.vv v8, v8, v9
; RV32-NEXT:    lui a0, 3
; RV32-NEXT:    addi a0, a0, -1366
; RV32-NEXT:    vmsgtu.vx v0, v8, a0
; RV32-NEXT:    vmv.v.i v8, 0
; RV32-NEXT:    vmerge.vim v8, v8, -1, v0
; RV32-NEXT:    ret
;
; RV64-LABEL: test_urem_vec_even_divisor_eq0:
; RV64:       # %bb.0:
; RV64-NEXT:    lui a0, 1048571
; RV64-NEXT:    addi a0, a0, -1365
; RV64-NEXT:    vsetvli a1, zero, e16, mf4, ta, ma
; RV64-NEXT:    vmul.vx v8, v8, a0
; RV64-NEXT:    vsll.vi v9, v8, 15
; RV64-NEXT:    vsrl.vi v8, v8, 1
; RV64-NEXT:    vor.vv v8, v8, v9
; RV64-NEXT:    lui a0, 3
; RV64-NEXT:    addi a0, a0, -1366
; RV64-NEXT:    vmsgtu.vx v0, v8, a0
; RV64-NEXT:    vmv.v.i v8, 0
; RV64-NEXT:    vmerge.vim v8, v8, -1, v0
; RV64-NEXT:    ret
  %ins1 = insertelement <vscale x 1 x i16> poison, i16 6, i32 0
  %splat1 = shufflevector <vscale x 1 x i16> %ins1, <vscale x 1 x i16> poison, <vscale x 1 x i32> zeroinitializer
  %urem = urem <vscale x 1 x i16> %x, %splat1
  %ins2 = insertelement <vscale x 1 x i16> poison, i16 0, i32 0
  %splat2 = shufflevector <vscale x 1 x i16> %ins2, <vscale x 1 x i16> poison, <vscale x 1 x i32> zeroinitializer
  %cmp = icmp ne <vscale x 1 x i16> %urem, %splat2
  %ext = sext <vscale x 1 x i1> %cmp to <vscale x 1 x i16>
  ret <vscale x 1 x i16> %ext
}

define <vscale x 1 x i16> @test_urem_vec_odd_divisor_eq0(<vscale x 1 x i16> %x) nounwind {
; RV32-LABEL: test_urem_vec_odd_divisor_eq0:
; RV32:       # %bb.0:
; RV32-NEXT:    lui a0, 1048573
; RV32-NEXT:    addi a0, a0, -819
; RV32-NEXT:    vsetvli a1, zero, e16, mf4, ta, ma
; RV32-NEXT:    vmul.vx v8, v8, a0
; RV32-NEXT:    lui a0, 3
; RV32-NEXT:    addi a0, a0, 819
; RV32-NEXT:    vmsgtu.vx v0, v8, a0
; RV32-NEXT:    vmv.v.i v8, 0
; RV32-NEXT:    vmerge.vim v8, v8, -1, v0
; RV32-NEXT:    ret
;
; RV64-LABEL: test_urem_vec_odd_divisor_eq0:
; RV64:       # %bb.0:
; RV64-NEXT:    lui a0, 1048573
; RV64-NEXT:    addi a0, a0, -819
; RV64-NEXT:    vsetvli a1, zero, e16, mf4, ta, ma
; RV64-NEXT:    vmul.vx v8, v8, a0
; RV64-NEXT:    lui a0, 3
; RV64-NEXT:    addi a0, a0, 819
; RV64-NEXT:    vmsgtu.vx v0, v8, a0
; RV64-NEXT:    vmv.v.i v8, 0
; RV64-NEXT:    vmerge.vim v8, v8, -1, v0
; RV64-NEXT:    ret
  %ins1 = insertelement <vscale x 1 x i16> poison, i16 5, i32 0
  %splat1 = shufflevector <vscale x 1 x i16> %ins1, <vscale x 1 x i16> poison, <vscale x 1 x i32> zeroinitializer
  %urem = urem <vscale x 1 x i16> %x, %splat1
  %ins2 = insertelement <vscale x 1 x i16> poison, i16 0, i32 0
  %splat2 = shufflevector <vscale x 1 x i16> %ins2, <vscale x 1 x i16> poison, <vscale x 1 x i32> zeroinitializer
  %cmp = icmp ne <vscale x 1 x i16> %urem, %splat2
  %ext = sext <vscale x 1 x i1> %cmp to <vscale x 1 x i16>
  ret <vscale x 1 x i16> %ext
}

define <vscale x 1 x i16> @test_urem_vec_even_divisor_eq1(<vscale x 1 x i16> %x) nounwind {
; RV32-LABEL: test_urem_vec_even_divisor_eq1:
; RV32:       # %bb.0:
; RV32-NEXT:    li a0, 1
; RV32-NEXT:    vsetvli a1, zero, e16, mf4, ta, ma
; RV32-NEXT:    vsub.vx v8, v8, a0
; RV32-NEXT:    lui a0, 1048571
; RV32-NEXT:    addi a0, a0, -1365
; RV32-NEXT:    vmul.vx v8, v8, a0
; RV32-NEXT:    vsll.vi v9, v8, 15
; RV32-NEXT:    vsrl.vi v8, v8, 1
; RV32-NEXT:    vor.vv v8, v8, v9
; RV32-NEXT:    lui a0, 3
; RV32-NEXT:    addi a0, a0, -1366
; RV32-NEXT:    vmsgtu.vx v0, v8, a0
; RV32-NEXT:    vmv.v.i v8, 0
; RV32-NEXT:    vmerge.vim v8, v8, -1, v0
; RV32-NEXT:    ret
;
; RV64-LABEL: test_urem_vec_even_divisor_eq1:
; RV64:       # %bb.0:
; RV64-NEXT:    li a0, 1
; RV64-NEXT:    vsetvli a1, zero, e16, mf4, ta, ma
; RV64-NEXT:    vsub.vx v8, v8, a0
; RV64-NEXT:    lui a0, 1048571
; RV64-NEXT:    addi a0, a0, -1365
; RV64-NEXT:    vmul.vx v8, v8, a0
; RV64-NEXT:    vsll.vi v9, v8, 15
; RV64-NEXT:    vsrl.vi v8, v8, 1
; RV64-NEXT:    vor.vv v8, v8, v9
; RV64-NEXT:    lui a0, 3
; RV64-NEXT:    addi a0, a0, -1366
; RV64-NEXT:    vmsgtu.vx v0, v8, a0
; RV64-NEXT:    vmv.v.i v8, 0
; RV64-NEXT:    vmerge.vim v8, v8, -1, v0
; RV64-NEXT:    ret
  %ins1 = insertelement <vscale x 1 x i16> poison, i16 6, i32 0
  %splat1 = shufflevector <vscale x 1 x i16> %ins1, <vscale x 1 x i16> poison, <vscale x 1 x i32> zeroinitializer
  %urem = urem <vscale x 1 x i16> %x, %splat1
  %ins2 = insertelement <vscale x 1 x i16> poison, i16 1, i32 0
  %splat2 = shufflevector <vscale x 1 x i16> %ins2, <vscale x 1 x i16> poison, <vscale x 1 x i32> zeroinitializer
  %cmp = icmp ne <vscale x 1 x i16> %urem, %splat2
  %ext = sext <vscale x 1 x i1> %cmp to <vscale x 1 x i16>
  ret <vscale x 1 x i16> %ext
}

define <vscale x 1 x i16> @test_urem_vec_odd_divisor_eq1(<vscale x 1 x i16> %x) nounwind {
; RV32-LABEL: test_urem_vec_odd_divisor_eq1:
; RV32:       # %bb.0:
; RV32-NEXT:    li a0, 1
; RV32-NEXT:    vsetvli a1, zero, e16, mf4, ta, ma
; RV32-NEXT:    vsub.vx v8, v8, a0
; RV32-NEXT:    lui a0, 1048573
; RV32-NEXT:    addi a0, a0, -819
; RV32-NEXT:    vmul.vx v8, v8, a0
; RV32-NEXT:    lui a0, 3
; RV32-NEXT:    addi a0, a0, 818
; RV32-NEXT:    vmsgtu.vx v0, v8, a0
; RV32-NEXT:    vmv.v.i v8, 0
; RV32-NEXT:    vmerge.vim v8, v8, -1, v0
; RV32-NEXT:    ret
;
; RV64-LABEL: test_urem_vec_odd_divisor_eq1:
; RV64:       # %bb.0:
; RV64-NEXT:    li a0, 1
; RV64-NEXT:    vsetvli a1, zero, e16, mf4, ta, ma
; RV64-NEXT:    vsub.vx v8, v8, a0
; RV64-NEXT:    lui a0, 1048573
; RV64-NEXT:    addi a0, a0, -819
; RV64-NEXT:    vmul.vx v8, v8, a0
; RV64-NEXT:    lui a0, 3
; RV64-NEXT:    addi a0, a0, 818
; RV64-NEXT:    vmsgtu.vx v0, v8, a0
; RV64-NEXT:    vmv.v.i v8, 0
; RV64-NEXT:    vmerge.vim v8, v8, -1, v0
; RV64-NEXT:    ret
  %ins1 = insertelement <vscale x 1 x i16> poison, i16 5, i32 0
  %splat1 = shufflevector <vscale x 1 x i16> %ins1, <vscale x 1 x i16> poison, <vscale x 1 x i32> zeroinitializer
  %urem = urem <vscale x 1 x i16> %x, %splat1
  %ins2 = insertelement <vscale x 1 x i16> poison, i16 1, i32 0
  %splat2 = shufflevector <vscale x 1 x i16> %ins2, <vscale x 1 x i16> poison, <vscale x 1 x i32> zeroinitializer
  %cmp = icmp ne <vscale x 1 x i16> %urem, %splat2
  %ext = sext <vscale x 1 x i1> %cmp to <vscale x 1 x i16>
  ret <vscale x 1 x i16> %ext
}
