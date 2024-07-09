; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+v -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -mtriple=riscv64 -mattr=+v -verify-machineinstrs < %s | FileCheck %s

define <vscale x 1 x i8> @masked_load_nxv1i8(ptr %a, <vscale x 1 x i1> %mask) nounwind {
; CHECK-LABEL: masked_load_nxv1i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8, mf8, ta, ma
; CHECK-NEXT:    vle8.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  %load = call <vscale x 1 x i8> @llvm.masked.load.nxv1i8(ptr %a, i32 1, <vscale x 1 x i1> %mask, <vscale x 1 x i8> undef)
  ret <vscale x 1 x i8> %load
}
declare <vscale x 1 x i8> @llvm.masked.load.nxv1i8(ptr, i32, <vscale x 1 x i1>, <vscale x 1 x i8>)

define <vscale x 1 x i16> @masked_load_nxv1i16(ptr %a, <vscale x 1 x i1> %mask) nounwind {
; CHECK-LABEL: masked_load_nxv1i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16, mf4, ta, ma
; CHECK-NEXT:    vle16.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  %load = call <vscale x 1 x i16> @llvm.masked.load.nxv1i16(ptr %a, i32 2, <vscale x 1 x i1> %mask, <vscale x 1 x i16> undef)
  ret <vscale x 1 x i16> %load
}
declare <vscale x 1 x i16> @llvm.masked.load.nxv1i16(ptr, i32, <vscale x 1 x i1>, <vscale x 1 x i16>)

define <vscale x 1 x i32> @masked_load_nxv1i32(ptr %a, <vscale x 1 x i1> %mask) nounwind {
; CHECK-LABEL: masked_load_nxv1i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, mf2, ta, ma
; CHECK-NEXT:    vle32.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  %load = call <vscale x 1 x i32> @llvm.masked.load.nxv1i32(ptr %a, i32 4, <vscale x 1 x i1> %mask, <vscale x 1 x i32> undef)
  ret <vscale x 1 x i32> %load
}
declare <vscale x 1 x i32> @llvm.masked.load.nxv1i32(ptr, i32, <vscale x 1 x i1>, <vscale x 1 x i32>)

define <vscale x 1 x i64> @masked_load_nxv1i64(ptr %a, <vscale x 1 x i1> %mask) nounwind {
; CHECK-LABEL: masked_load_nxv1i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e64, m1, ta, ma
; CHECK-NEXT:    vle64.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  %load = call <vscale x 1 x i64> @llvm.masked.load.nxv1i64(ptr %a, i32 8, <vscale x 1 x i1> %mask, <vscale x 1 x i64> undef)
  ret <vscale x 1 x i64> %load
}
declare <vscale x 1 x i64> @llvm.masked.load.nxv1i64(ptr, i32, <vscale x 1 x i1>, <vscale x 1 x i64>)

define <vscale x 2 x i8> @masked_load_nxv2i8(ptr %a, <vscale x 2 x i1> %mask) nounwind {
; CHECK-LABEL: masked_load_nxv2i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8, mf4, ta, ma
; CHECK-NEXT:    vle8.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  %load = call <vscale x 2 x i8> @llvm.masked.load.nxv2i8(ptr %a, i32 1, <vscale x 2 x i1> %mask, <vscale x 2 x i8> undef)
  ret <vscale x 2 x i8> %load
}
declare <vscale x 2 x i8> @llvm.masked.load.nxv2i8(ptr, i32, <vscale x 2 x i1>, <vscale x 2 x i8>)

define <vscale x 2 x i16> @masked_load_nxv2i16(ptr %a, <vscale x 2 x i1> %mask) nounwind {
; CHECK-LABEL: masked_load_nxv2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16, mf2, ta, ma
; CHECK-NEXT:    vle16.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  %load = call <vscale x 2 x i16> @llvm.masked.load.nxv2i16(ptr %a, i32 2, <vscale x 2 x i1> %mask, <vscale x 2 x i16> undef)
  ret <vscale x 2 x i16> %load
}
declare <vscale x 2 x i16> @llvm.masked.load.nxv2i16(ptr, i32, <vscale x 2 x i1>, <vscale x 2 x i16>)

define <vscale x 2 x i32> @masked_load_nxv2i32(ptr %a, <vscale x 2 x i1> %mask) nounwind {
; CHECK-LABEL: masked_load_nxv2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, m1, ta, ma
; CHECK-NEXT:    vle32.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  %load = call <vscale x 2 x i32> @llvm.masked.load.nxv2i32(ptr %a, i32 4, <vscale x 2 x i1> %mask, <vscale x 2 x i32> undef)
  ret <vscale x 2 x i32> %load
}
declare <vscale x 2 x i32> @llvm.masked.load.nxv2i32(ptr, i32, <vscale x 2 x i1>, <vscale x 2 x i32>)

define <vscale x 2 x i64> @masked_load_nxv2i64(ptr %a, <vscale x 2 x i1> %mask) nounwind {
; CHECK-LABEL: masked_load_nxv2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e64, m2, ta, ma
; CHECK-NEXT:    vle64.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  %load = call <vscale x 2 x i64> @llvm.masked.load.nxv2i64(ptr %a, i32 8, <vscale x 2 x i1> %mask, <vscale x 2 x i64> undef)
  ret <vscale x 2 x i64> %load
}
declare <vscale x 2 x i64> @llvm.masked.load.nxv2i64(ptr, i32, <vscale x 2 x i1>, <vscale x 2 x i64>)

define <vscale x 4 x i8> @masked_load_nxv4i8(ptr %a, <vscale x 4 x i1> %mask) nounwind {
; CHECK-LABEL: masked_load_nxv4i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8, mf2, ta, ma
; CHECK-NEXT:    vle8.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  %load = call <vscale x 4 x i8> @llvm.masked.load.nxv4i8(ptr %a, i32 1, <vscale x 4 x i1> %mask, <vscale x 4 x i8> undef)
  ret <vscale x 4 x i8> %load
}
declare <vscale x 4 x i8> @llvm.masked.load.nxv4i8(ptr, i32, <vscale x 4 x i1>, <vscale x 4 x i8>)

define <vscale x 4 x i16> @masked_load_nxv4i16(ptr %a, <vscale x 4 x i1> %mask) nounwind {
; CHECK-LABEL: masked_load_nxv4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16, m1, ta, ma
; CHECK-NEXT:    vle16.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  %load = call <vscale x 4 x i16> @llvm.masked.load.nxv4i16(ptr %a, i32 2, <vscale x 4 x i1> %mask, <vscale x 4 x i16> undef)
  ret <vscale x 4 x i16> %load
}
declare <vscale x 4 x i16> @llvm.masked.load.nxv4i16(ptr, i32, <vscale x 4 x i1>, <vscale x 4 x i16>)

define <vscale x 4 x i32> @masked_load_nxv4i32(ptr %a, <vscale x 4 x i1> %mask) nounwind {
; CHECK-LABEL: masked_load_nxv4i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, m2, ta, ma
; CHECK-NEXT:    vle32.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  %load = call <vscale x 4 x i32> @llvm.masked.load.nxv4i32(ptr %a, i32 4, <vscale x 4 x i1> %mask, <vscale x 4 x i32> undef)
  ret <vscale x 4 x i32> %load
}
declare <vscale x 4 x i32> @llvm.masked.load.nxv4i32(ptr, i32, <vscale x 4 x i1>, <vscale x 4 x i32>)

define <vscale x 4 x i64> @masked_load_nxv4i64(ptr %a, <vscale x 4 x i1> %mask) nounwind {
; CHECK-LABEL: masked_load_nxv4i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e64, m4, ta, ma
; CHECK-NEXT:    vle64.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  %load = call <vscale x 4 x i64> @llvm.masked.load.nxv4i64(ptr %a, i32 8, <vscale x 4 x i1> %mask, <vscale x 4 x i64> undef)
  ret <vscale x 4 x i64> %load
}
declare <vscale x 4 x i64> @llvm.masked.load.nxv4i64(ptr, i32, <vscale x 4 x i1>, <vscale x 4 x i64>)

define <vscale x 8 x i8> @masked_load_nxv8i8(ptr %a, <vscale x 8 x i1> %mask) nounwind {
; CHECK-LABEL: masked_load_nxv8i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8, m1, ta, ma
; CHECK-NEXT:    vle8.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  %load = call <vscale x 8 x i8> @llvm.masked.load.nxv8i8(ptr %a, i32 1, <vscale x 8 x i1> %mask, <vscale x 8 x i8> undef)
  ret <vscale x 8 x i8> %load
}
declare <vscale x 8 x i8> @llvm.masked.load.nxv8i8(ptr, i32, <vscale x 8 x i1>, <vscale x 8 x i8>)

define <vscale x 8 x i16> @masked_load_nxv8i16(ptr %a, <vscale x 8 x i1> %mask) nounwind {
; CHECK-LABEL: masked_load_nxv8i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16, m2, ta, ma
; CHECK-NEXT:    vle16.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  %load = call <vscale x 8 x i16> @llvm.masked.load.nxv8i16(ptr %a, i32 2, <vscale x 8 x i1> %mask, <vscale x 8 x i16> undef)
  ret <vscale x 8 x i16> %load
}
declare <vscale x 8 x i16> @llvm.masked.load.nxv8i16(ptr, i32, <vscale x 8 x i1>, <vscale x 8 x i16>)

define <vscale x 8 x i32> @masked_load_nxv8i32(ptr %a, <vscale x 8 x i1> %mask) nounwind {
; CHECK-LABEL: masked_load_nxv8i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, m4, ta, ma
; CHECK-NEXT:    vle32.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  %load = call <vscale x 8 x i32> @llvm.masked.load.nxv8i32(ptr %a, i32 4, <vscale x 8 x i1> %mask, <vscale x 8 x i32> undef)
  ret <vscale x 8 x i32> %load
}
declare <vscale x 8 x i32> @llvm.masked.load.nxv8i32(ptr, i32, <vscale x 8 x i1>, <vscale x 8 x i32>)

define <vscale x 8 x i64> @masked_load_nxv8i64(ptr %a, <vscale x 8 x i1> %mask) nounwind {
; CHECK-LABEL: masked_load_nxv8i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e64, m8, ta, ma
; CHECK-NEXT:    vle64.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  %load = call <vscale x 8 x i64> @llvm.masked.load.nxv8i64(ptr %a, i32 8, <vscale x 8 x i1> %mask, <vscale x 8 x i64> undef)
  ret <vscale x 8 x i64> %load
}
declare <vscale x 8 x i64> @llvm.masked.load.nxv8i64(ptr, i32, <vscale x 8 x i1>, <vscale x 8 x i64>)

define <vscale x 16 x i8> @masked_load_nxv16i8(ptr %a, <vscale x 16 x i1> %mask) nounwind {
; CHECK-LABEL: masked_load_nxv16i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8, m2, ta, ma
; CHECK-NEXT:    vle8.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  %load = call <vscale x 16 x i8> @llvm.masked.load.nxv16i8(ptr %a, i32 1, <vscale x 16 x i1> %mask, <vscale x 16 x i8> undef)
  ret <vscale x 16 x i8> %load
}
declare <vscale x 16 x i8> @llvm.masked.load.nxv16i8(ptr, i32, <vscale x 16 x i1>, <vscale x 16 x i8>)

define <vscale x 16 x i16> @masked_load_nxv16i16(ptr %a, <vscale x 16 x i1> %mask) nounwind {
; CHECK-LABEL: masked_load_nxv16i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16, m4, ta, ma
; CHECK-NEXT:    vle16.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  %load = call <vscale x 16 x i16> @llvm.masked.load.nxv16i16(ptr %a, i32 2, <vscale x 16 x i1> %mask, <vscale x 16 x i16> undef)
  ret <vscale x 16 x i16> %load
}
declare <vscale x 16 x i16> @llvm.masked.load.nxv16i16(ptr, i32, <vscale x 16 x i1>, <vscale x 16 x i16>)

define <vscale x 16 x i32> @masked_load_nxv16i32(ptr %a, <vscale x 16 x i1> %mask) nounwind {
; CHECK-LABEL: masked_load_nxv16i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32, m8, ta, ma
; CHECK-NEXT:    vle32.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  %load = call <vscale x 16 x i32> @llvm.masked.load.nxv16i32(ptr %a, i32 4, <vscale x 16 x i1> %mask, <vscale x 16 x i32> undef)
  ret <vscale x 16 x i32> %load
}
declare <vscale x 16 x i32> @llvm.masked.load.nxv16i32(ptr, i32, <vscale x 16 x i1>, <vscale x 16 x i32>)

define <vscale x 32 x i8> @masked_load_nxv32i8(ptr %a, <vscale x 32 x i1> %mask) nounwind {
; CHECK-LABEL: masked_load_nxv32i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8, m4, ta, ma
; CHECK-NEXT:    vle8.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  %load = call <vscale x 32 x i8> @llvm.masked.load.nxv32i8(ptr %a, i32 1, <vscale x 32 x i1> %mask, <vscale x 32 x i8> undef)
  ret <vscale x 32 x i8> %load
}
declare <vscale x 32 x i8> @llvm.masked.load.nxv32i8(ptr, i32, <vscale x 32 x i1>, <vscale x 32 x i8>)

define <vscale x 32 x i16> @masked_load_nxv32i16(ptr %a, <vscale x 32 x i1> %mask) nounwind {
; CHECK-LABEL: masked_load_nxv32i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16, m8, ta, ma
; CHECK-NEXT:    vle16.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  %load = call <vscale x 32 x i16> @llvm.masked.load.nxv32i16(ptr %a, i32 2, <vscale x 32 x i1> %mask, <vscale x 32 x i16> undef)
  ret <vscale x 32 x i16> %load
}
declare <vscale x 32 x i16> @llvm.masked.load.nxv32i16(ptr, i32, <vscale x 32 x i1>, <vscale x 32 x i16>)

define <vscale x 64 x i8> @masked_load_nxv64i8(ptr %a, <vscale x 64 x i1> %mask) nounwind {
; CHECK-LABEL: masked_load_nxv64i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8, m8, ta, ma
; CHECK-NEXT:    vle8.v v8, (a0), v0.t
; CHECK-NEXT:    ret
  %load = call <vscale x 64 x i8> @llvm.masked.load.nxv64i8(ptr %a, i32 1, <vscale x 64 x i1> %mask, <vscale x 64 x i8> undef)
  ret <vscale x 64 x i8> %load
}
declare <vscale x 64 x i8> @llvm.masked.load.nxv64i8(ptr, i32, <vscale x 64 x i1>, <vscale x 64 x i8>)

define <vscale x 2 x i8> @masked_load_zero_mask(ptr %a) nounwind {
; CHECK-LABEL: masked_load_zero_mask:
; CHECK:       # %bb.0:
; CHECK-NEXT:    ret
  %load = call <vscale x 2 x i8> @llvm.masked.load.nxv2i8(ptr %a, i32 1, <vscale x 2 x i1> zeroinitializer, <vscale x 2 x i8> undef)
  ret <vscale x 2 x i8> %load
}

define <vscale x 2 x i8> @masked_load_allones_mask(ptr %a, <vscale x 2 x i8> %maskedoff) nounwind {
; CHECK-LABEL: masked_load_allones_mask:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8, mf4, ta, ma
; CHECK-NEXT:    vle8.v v8, (a0)
; CHECK-NEXT:    ret
  %insert = insertelement <vscale x 2 x i1> poison, i1 1, i32 0
  %mask = shufflevector <vscale x 2 x i1> %insert, <vscale x 2 x i1> poison, <vscale x 2 x i32> zeroinitializer
  %load = call <vscale x 2 x i8> @llvm.masked.load.nxv2i8(ptr %a, i32 1, <vscale x 2 x i1> %mask, <vscale x 2 x i8> %maskedoff)
  ret <vscale x 2 x i8> %load
}
