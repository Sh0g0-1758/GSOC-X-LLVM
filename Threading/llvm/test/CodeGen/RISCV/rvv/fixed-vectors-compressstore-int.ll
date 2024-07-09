; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 4
; RUN: llc -mtriple=riscv32 -mattr=+m,+v -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,RV32
; RUN: llc -mtriple=riscv64 -mattr=+m,+v -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,RV64

declare void @llvm.masked.compressstore.v1i8(<1 x i8>, ptr, <1 x i1>)
define void @compressstore_v1i8(ptr %base, <1 x i8> %v, <1 x i1> %mask) {
; CHECK-LABEL: compressstore_v1i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e8, mf8, ta, ma
; CHECK-NEXT:    vcompress.vm v9, v8, v0
; CHECK-NEXT:    vcpop.m a1, v0
; CHECK-NEXT:    vsetvli zero, a1, e8, mf8, ta, ma
; CHECK-NEXT:    vse8.v v9, (a0)
; CHECK-NEXT:    ret
  call void @llvm.masked.compressstore.v1i8(<1 x i8> %v, ptr %base, <1 x i1> %mask)
  ret void
}

declare void @llvm.masked.compressstore.v2i8(<2 x i8>, ptr, <2 x i1>)
define void @compressstore_v2i8(ptr %base, <2 x i8> %v, <2 x i1> %mask) {
; CHECK-LABEL: compressstore_v2i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e8, mf8, ta, ma
; CHECK-NEXT:    vcompress.vm v9, v8, v0
; CHECK-NEXT:    vcpop.m a1, v0
; CHECK-NEXT:    vsetvli zero, a1, e8, mf8, ta, ma
; CHECK-NEXT:    vse8.v v9, (a0)
; CHECK-NEXT:    ret
  call void @llvm.masked.compressstore.v2i8(<2 x i8> %v, ptr %base, <2 x i1> %mask)
  ret void
}

declare void @llvm.masked.compressstore.v4i8(<4 x i8>, ptr, <4 x i1>)
define void @compressstore_v4i8(ptr %base, <4 x i8> %v, <4 x i1> %mask) {
; CHECK-LABEL: compressstore_v4i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e8, mf4, ta, ma
; CHECK-NEXT:    vcompress.vm v9, v8, v0
; CHECK-NEXT:    vcpop.m a1, v0
; CHECK-NEXT:    vsetvli zero, a1, e8, mf4, ta, ma
; CHECK-NEXT:    vse8.v v9, (a0)
; CHECK-NEXT:    ret
  call void @llvm.masked.compressstore.v4i8(<4 x i8> %v, ptr %base, <4 x i1> %mask)
  ret void
}

declare void @llvm.masked.compressstore.v8i8(<8 x i8>, ptr, <8 x i1>)
define void @compressstore_v8i8(ptr %base, <8 x i8> %v, <8 x i1> %mask) {
; CHECK-LABEL: compressstore_v8i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, ma
; CHECK-NEXT:    vcompress.vm v9, v8, v0
; CHECK-NEXT:    vcpop.m a1, v0
; CHECK-NEXT:    vsetvli zero, a1, e8, mf2, ta, ma
; CHECK-NEXT:    vse8.v v9, (a0)
; CHECK-NEXT:    ret
  call void @llvm.masked.compressstore.v8i8(<8 x i8> %v, ptr %base, <8 x i1> %mask)
  ret void
}

declare void @llvm.masked.compressstore.v1i16(<1 x i16>, ptr, <1 x i1>)
define void @compressstore_v1i16(ptr %base, <1 x i16> %v, <1 x i1> %mask) {
; CHECK-LABEL: compressstore_v1i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e16, mf4, ta, ma
; CHECK-NEXT:    vcompress.vm v9, v8, v0
; CHECK-NEXT:    vcpop.m a1, v0
; CHECK-NEXT:    vsetvli zero, a1, e16, mf4, ta, ma
; CHECK-NEXT:    vse16.v v9, (a0)
; CHECK-NEXT:    ret
  call void @llvm.masked.compressstore.v1i16(<1 x i16> %v, ptr align 2 %base, <1 x i1> %mask)
  ret void
}

declare void @llvm.masked.compressstore.v2i16(<2 x i16>, ptr, <2 x i1>)
define void @compressstore_v2i16(ptr %base, <2 x i16> %v, <2 x i1> %mask) {
; CHECK-LABEL: compressstore_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e16, mf4, ta, ma
; CHECK-NEXT:    vcompress.vm v9, v8, v0
; CHECK-NEXT:    vcpop.m a1, v0
; CHECK-NEXT:    vsetvli zero, a1, e16, mf4, ta, ma
; CHECK-NEXT:    vse16.v v9, (a0)
; CHECK-NEXT:    ret
  call void @llvm.masked.compressstore.v2i16(<2 x i16> %v, ptr align 2 %base, <2 x i1> %mask)
  ret void
}

declare void @llvm.masked.compressstore.v4i16(<4 x i16>, ptr, <4 x i1>)
define void @compressstore_v4i16(ptr %base, <4 x i16> %v, <4 x i1> %mask) {
; CHECK-LABEL: compressstore_v4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e16, mf2, ta, ma
; CHECK-NEXT:    vcompress.vm v9, v8, v0
; CHECK-NEXT:    vcpop.m a1, v0
; CHECK-NEXT:    vsetvli zero, a1, e16, mf2, ta, ma
; CHECK-NEXT:    vse16.v v9, (a0)
; CHECK-NEXT:    ret
  call void @llvm.masked.compressstore.v4i16(<4 x i16> %v, ptr align 2 %base, <4 x i1> %mask)
  ret void
}

declare void @llvm.masked.compressstore.v8i16(<8 x i16>, ptr, <8 x i1>)
define void @compressstore_v8i16(ptr %base, <8 x i16> %v, <8 x i1> %mask) {
; CHECK-LABEL: compressstore_v8i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e16, m1, ta, ma
; CHECK-NEXT:    vcompress.vm v9, v8, v0
; CHECK-NEXT:    vcpop.m a1, v0
; CHECK-NEXT:    vsetvli zero, a1, e16, m1, ta, ma
; CHECK-NEXT:    vse16.v v9, (a0)
; CHECK-NEXT:    ret
  call void @llvm.masked.compressstore.v8i16(<8 x i16> %v, ptr align 2 %base, <8 x i1> %mask)
  ret void
}

declare void @llvm.masked.compressstore.v1i32(<1 x i32>, ptr, <1 x i1>)
define void @compressstore_v1i32(ptr %base, <1 x i32> %v, <1 x i1> %mask) {
; CHECK-LABEL: compressstore_v1i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e32, mf2, ta, ma
; CHECK-NEXT:    vcompress.vm v9, v8, v0
; CHECK-NEXT:    vcpop.m a1, v0
; CHECK-NEXT:    vsetvli zero, a1, e32, mf2, ta, ma
; CHECK-NEXT:    vse32.v v9, (a0)
; CHECK-NEXT:    ret
  call void @llvm.masked.compressstore.v1i32(<1 x i32> %v, ptr align 4 %base, <1 x i1> %mask)
  ret void
}

declare void @llvm.masked.compressstore.v2i32(<2 x i32>, ptr, <2 x i1>)
define void @compressstore_v2i32(ptr %base, <2 x i32> %v, <2 x i1> %mask) {
; CHECK-LABEL: compressstore_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e32, mf2, ta, ma
; CHECK-NEXT:    vcompress.vm v9, v8, v0
; CHECK-NEXT:    vcpop.m a1, v0
; CHECK-NEXT:    vsetvli zero, a1, e32, mf2, ta, ma
; CHECK-NEXT:    vse32.v v9, (a0)
; CHECK-NEXT:    ret
  call void @llvm.masked.compressstore.v2i32(<2 x i32> %v, ptr align 4 %base, <2 x i1> %mask)
  ret void
}

declare void @llvm.masked.compressstore.v4i32(<4 x i32>, ptr, <4 x i1>)
define void @compressstore_v4i32(ptr %base, <4 x i32> %v, <4 x i1> %mask) {
; CHECK-LABEL: compressstore_v4i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; CHECK-NEXT:    vcompress.vm v9, v8, v0
; CHECK-NEXT:    vcpop.m a1, v0
; CHECK-NEXT:    vsetvli zero, a1, e32, m1, ta, ma
; CHECK-NEXT:    vse32.v v9, (a0)
; CHECK-NEXT:    ret
  call void @llvm.masked.compressstore.v4i32(<4 x i32> %v, ptr align 4 %base, <4 x i1> %mask)
  ret void
}

declare void @llvm.masked.compressstore.v8i32(<8 x i32>, ptr, <8 x i1>)
define void @compressstore_v8i32(ptr %base, <8 x i32> %v, <8 x i1> %mask) {
; CHECK-LABEL: compressstore_v8i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e32, m2, ta, ma
; CHECK-NEXT:    vcompress.vm v10, v8, v0
; CHECK-NEXT:    vcpop.m a1, v0
; CHECK-NEXT:    vsetvli zero, a1, e32, m2, ta, ma
; CHECK-NEXT:    vse32.v v10, (a0)
; CHECK-NEXT:    ret
  call void @llvm.masked.compressstore.v8i32(<8 x i32> %v, ptr align 4 %base, <8 x i1> %mask)
  ret void
}

declare void @llvm.masked.compressstore.v1i64(<1 x i64>, ptr, <1 x i1>)
define void @compressstore_v1i64(ptr %base, <1 x i64> %v, <1 x i1> %mask) {
; CHECK-LABEL: compressstore_v1i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e64, m1, ta, ma
; CHECK-NEXT:    vcompress.vm v9, v8, v0
; CHECK-NEXT:    vcpop.m a1, v0
; CHECK-NEXT:    vsetvli zero, a1, e64, m1, ta, ma
; CHECK-NEXT:    vse64.v v9, (a0)
; CHECK-NEXT:    ret
  call void @llvm.masked.compressstore.v1i64(<1 x i64> %v, ptr align 8 %base, <1 x i1> %mask)
  ret void
}

declare void @llvm.masked.compressstore.v2i64(<2 x i64>, ptr, <2 x i1>)
define void @compressstore_v2i64(ptr %base, <2 x i64> %v, <2 x i1> %mask) {
; CHECK-LABEL: compressstore_v2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e64, m1, ta, ma
; CHECK-NEXT:    vcompress.vm v9, v8, v0
; CHECK-NEXT:    vcpop.m a1, v0
; CHECK-NEXT:    vsetvli zero, a1, e64, m1, ta, ma
; CHECK-NEXT:    vse64.v v9, (a0)
; CHECK-NEXT:    ret
  call void @llvm.masked.compressstore.v2i64(<2 x i64> %v, ptr align 8 %base, <2 x i1> %mask)
  ret void
}

declare void @llvm.masked.compressstore.v4i64(<4 x i64>, ptr, <4 x i1>)
define void @compressstore_v4i64(ptr %base, <4 x i64> %v, <4 x i1> %mask) {
; CHECK-LABEL: compressstore_v4i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e64, m2, ta, ma
; CHECK-NEXT:    vcompress.vm v10, v8, v0
; CHECK-NEXT:    vcpop.m a1, v0
; CHECK-NEXT:    vsetvli zero, a1, e64, m2, ta, ma
; CHECK-NEXT:    vse64.v v10, (a0)
; CHECK-NEXT:    ret
  call void @llvm.masked.compressstore.v4i64(<4 x i64> %v, ptr align 8 %base, <4 x i1> %mask)
  ret void
}

declare void @llvm.masked.compressstore.v8i64(<8 x i64>, ptr, <8 x i1>)
define void @compressstore_v8i64(ptr %base, <8 x i64> %v, <8 x i1> %mask) {
; CHECK-LABEL: compressstore_v8i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e64, m4, ta, ma
; CHECK-NEXT:    vcompress.vm v12, v8, v0
; CHECK-NEXT:    vcpop.m a1, v0
; CHECK-NEXT:    vsetvli zero, a1, e64, m4, ta, ma
; CHECK-NEXT:    vse64.v v12, (a0)
; CHECK-NEXT:    ret
  call void @llvm.masked.compressstore.v8i64(<8 x i64> %v, ptr align 8 %base, <8 x i1> %mask)
  ret void
}
;; NOTE: These prefixes are unused and the list is autogenerated. Do not add tests below this line:
; RV32: {{.*}}
; RV64: {{.*}}
