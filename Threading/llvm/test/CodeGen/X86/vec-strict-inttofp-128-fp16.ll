; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=avx512fp16,avx512vl -O3 | FileCheck %s --check-prefixes=CHECK,X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=avx512fp16,avx512vl -O3 | FileCheck %s --check-prefixes=CHECK,X64

declare <8 x half> @llvm.experimental.constrained.sitofp.v8f16.v8i1(<8 x i1>, metadata, metadata)
declare <8 x half> @llvm.experimental.constrained.uitofp.v8f16.v8i1(<8 x i1>, metadata, metadata)
declare <8 x half> @llvm.experimental.constrained.sitofp.v8f16.v8i8(<8 x i8>, metadata, metadata)
declare <8 x half> @llvm.experimental.constrained.uitofp.v8f16.v8i8(<8 x i8>, metadata, metadata)
declare <8 x half> @llvm.experimental.constrained.sitofp.v8f16.v8i16(<8 x i16>, metadata, metadata)
declare <8 x half> @llvm.experimental.constrained.uitofp.v8f16.v8i16(<8 x i16>, metadata, metadata)
declare <4 x half> @llvm.experimental.constrained.sitofp.v4f16.v4i32(<4 x i32>, metadata, metadata)
declare <4 x half> @llvm.experimental.constrained.uitofp.v4f16.v4i32(<4 x i32>, metadata, metadata)
declare <2 x half> @llvm.experimental.constrained.sitofp.v2f16.v2i64(<2 x i64>, metadata, metadata)
declare <2 x half> @llvm.experimental.constrained.uitofp.v2f16.v2i64(<2 x i64>, metadata, metadata)

define <4 x half> @sitofp_v4i32_v4f16(<4 x i32> %x) #0 {
; CHECK-LABEL: sitofp_v4i32_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtdq2ph %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
 %result = call <4 x half> @llvm.experimental.constrained.sitofp.v4f16.v4i32(<4 x i32> %x,
                                                              metadata !"round.dynamic",
                                                              metadata !"fpexcept.strict") #0
  ret <4 x half> %result
}

define <4 x half> @uitofp_v4i32_v4f16(<4 x i32> %x) #0 {
; CHECK-LABEL: uitofp_v4i32_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtudq2ph %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
 %result = call <4 x half> @llvm.experimental.constrained.uitofp.v4f16.v4i32(<4 x i32> %x,
                                                              metadata !"round.dynamic",
                                                              metadata !"fpexcept.strict") #0
  ret <4 x half> %result
}

define <2 x half> @sitofp_v2i64_v2f16(<2 x i64> %x) #0 {
; CHECK-LABEL: sitofp_v2i64_v2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtqq2ph %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
 %result = call <2 x half> @llvm.experimental.constrained.sitofp.v2f16.v2i64(<2 x i64> %x,
                                                              metadata !"round.dynamic",
                                                              metadata !"fpexcept.strict") #0
  ret <2 x half> %result
}

define <2 x half> @uitofp_v2i64_v2f16(<2 x i64> %x) #0 {
; CHECK-LABEL: uitofp_v2i64_v2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtuqq2ph %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
 %result = call <2 x half> @llvm.experimental.constrained.uitofp.v2f16.v2i64(<2 x i64> %x,
                                                              metadata !"round.dynamic",
                                                              metadata !"fpexcept.strict") #0
  ret <2 x half> %result
}

define <8 x half> @sitofp_v8i1_v8f16(<8 x i1> %x) #0 {
; CHECK-LABEL: sitofp_v8i1_v8f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpsllw $15, %xmm0, %xmm0
; CHECK-NEXT:    vpsraw $15, %xmm0, %xmm0
; CHECK-NEXT:    vcvtw2ph %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
 %result = call <8 x half> @llvm.experimental.constrained.sitofp.v8f16.v8i1(<8 x i1> %x,
                                                              metadata !"round.dynamic",
                                                              metadata !"fpexcept.strict") #0
  ret <8 x half> %result
}

define <8 x half> @uitofp_v8i1_v8f16(<8 x i1> %x) #0 {
; X86-LABEL: uitofp_v8i1_v8f16:
; X86:       # %bb.0:
; X86-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}{1to4}, %xmm0, %xmm0
; X86-NEXT:    vcvtw2ph %xmm0, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: uitofp_v8i1_v8f16:
; X64:       # %bb.0:
; X64-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to4}, %xmm0, %xmm0
; X64-NEXT:    vcvtw2ph %xmm0, %xmm0
; X64-NEXT:    retq
 %result = call <8 x half> @llvm.experimental.constrained.uitofp.v8f16.v8i1(<8 x i1> %x,
                                                              metadata !"round.dynamic",
                                                              metadata !"fpexcept.strict") #0
  ret <8 x half> %result
}

define <8 x half> @sitofp_v8i8_v8f16(<8 x i8> %x) #0 {
; CHECK-LABEL: sitofp_v8i8_v8f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmovsxbw %xmm0, %xmm0
; CHECK-NEXT:    vcvtw2ph %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
 %result = call <8 x half> @llvm.experimental.constrained.sitofp.v8f16.v8i8(<8 x i8> %x,
                                                              metadata !"round.dynamic",
                                                              metadata !"fpexcept.strict") #0
  ret <8 x half> %result
}

define <8 x half> @uitofp_v8i8_v8f16(<8 x i8> %x) #0 {
; CHECK-LABEL: uitofp_v8i8_v8f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmovzxbw {{.*#+}} xmm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; CHECK-NEXT:    vcvtw2ph %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
 %result = call <8 x half> @llvm.experimental.constrained.uitofp.v8f16.v8i8(<8 x i8> %x,
                                                              metadata !"round.dynamic",
                                                              metadata !"fpexcept.strict") #0
  ret <8 x half> %result
}

define <8 x half> @sitofp_v8i16_v8f16(<8 x i16> %x) #0 {
; CHECK-LABEL: sitofp_v8i16_v8f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtw2ph %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
 %result = call <8 x half> @llvm.experimental.constrained.sitofp.v8f16.v8i16(<8 x i16> %x,
                                                              metadata !"round.dynamic",
                                                              metadata !"fpexcept.strict") #0
  ret <8 x half> %result
}

define <8 x half> @uitofp_v8i16_v8f16(<8 x i16> %x) #0 {
; CHECK-LABEL: uitofp_v8i16_v8f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtuw2ph %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
 %result = call <8 x half> @llvm.experimental.constrained.uitofp.v8f16.v8i16(<8 x i16> %x,
                                                              metadata !"round.dynamic",
                                                              metadata !"fpexcept.strict") #0
  ret <8 x half> %result
}

attributes #0 = { strictfp }
