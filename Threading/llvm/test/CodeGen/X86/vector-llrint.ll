; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown | FileCheck %s --check-prefix=X64-SSE
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=avx | FileCheck %s --check-prefix=X64-AVX
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=avx512f | FileCheck %s --check-prefix=X64-AVX

define <1 x i64> @llrint_v1i64_v1f32(<1 x float> %x) {
; X64-SSE-LABEL: llrint_v1i64_v1f32:
; X64-SSE:       # %bb.0:
; X64-SSE-NEXT:    cvtss2si %xmm0, %rax
; X64-SSE-NEXT:    retq
;
; X64-AVX-LABEL: llrint_v1i64_v1f32:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vcvtss2si %xmm0, %rax
; X64-AVX-NEXT:    retq
  %a = call <1 x i64> @llvm.llrint.v1i64.v1f32(<1 x float> %x)
  ret <1 x i64> %a
}
declare <1 x i64> @llvm.llrint.v1i64.v1f32(<1 x float>)

define <2 x i64> @llrint_v2i64_v2f32(<2 x float> %x) {
; X64-SSE-LABEL: llrint_v2i64_v2f32:
; X64-SSE:       # %bb.0:
; X64-SSE-NEXT:    cvtss2si %xmm0, %rax
; X64-SSE-NEXT:    movq %rax, %xmm1
; X64-SSE-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,1,1,1]
; X64-SSE-NEXT:    cvtss2si %xmm0, %rax
; X64-SSE-NEXT:    movq %rax, %xmm0
; X64-SSE-NEXT:    punpcklqdq {{.*#+}} xmm1 = xmm1[0],xmm0[0]
; X64-SSE-NEXT:    movdqa %xmm1, %xmm0
; X64-SSE-NEXT:    retq
;
; X64-AVX-LABEL: llrint_v2i64_v2f32:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vcvtss2si %xmm0, %rax
; X64-AVX-NEXT:    vmovq %rax, %xmm1
; X64-AVX-NEXT:    vmovshdup {{.*#+}} xmm0 = xmm0[1,1,3,3]
; X64-AVX-NEXT:    vcvtss2si %xmm0, %rax
; X64-AVX-NEXT:    vmovq %rax, %xmm0
; X64-AVX-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm1[0],xmm0[0]
; X64-AVX-NEXT:    retq
  %a = call <2 x i64> @llvm.llrint.v2i64.v2f32(<2 x float> %x)
  ret <2 x i64> %a
}
declare <2 x i64> @llvm.llrint.v2i64.v2f32(<2 x float>)

define <4 x i64> @llrint_v4i64_v4f32(<4 x float> %x) {
; X64-SSE-LABEL: llrint_v4i64_v4f32:
; X64-SSE:       # %bb.0:
; X64-SSE-NEXT:    cvtss2si %xmm0, %rax
; X64-SSE-NEXT:    movq %rax, %xmm2
; X64-SSE-NEXT:    movaps %xmm0, %xmm1
; X64-SSE-NEXT:    shufps {{.*#+}} xmm1 = xmm1[1,1],xmm0[1,1]
; X64-SSE-NEXT:    cvtss2si %xmm1, %rax
; X64-SSE-NEXT:    movq %rax, %xmm1
; X64-SSE-NEXT:    punpcklqdq {{.*#+}} xmm2 = xmm2[0],xmm1[0]
; X64-SSE-NEXT:    movaps %xmm0, %xmm1
; X64-SSE-NEXT:    shufps {{.*#+}} xmm1 = xmm1[3,3],xmm0[3,3]
; X64-SSE-NEXT:    cvtss2si %xmm1, %rax
; X64-SSE-NEXT:    movq %rax, %xmm3
; X64-SSE-NEXT:    movhlps {{.*#+}} xmm0 = xmm0[1,1]
; X64-SSE-NEXT:    cvtss2si %xmm0, %rax
; X64-SSE-NEXT:    movq %rax, %xmm1
; X64-SSE-NEXT:    punpcklqdq {{.*#+}} xmm1 = xmm1[0],xmm3[0]
; X64-SSE-NEXT:    movdqa %xmm2, %xmm0
; X64-SSE-NEXT:    retq
  %a = call <4 x i64> @llvm.llrint.v4i64.v4f32(<4 x float> %x)
  ret <4 x i64> %a
}
declare <4 x i64> @llvm.llrint.v4i64.v4f32(<4 x float>)

define <8 x i64> @llrint_v8i64_v8f32(<8 x float> %x) {
; X64-SSE-LABEL: llrint_v8i64_v8f32:
; X64-SSE:       # %bb.0:
; X64-SSE-NEXT:    movaps %xmm0, %xmm2
; X64-SSE-NEXT:    cvtss2si %xmm0, %rax
; X64-SSE-NEXT:    movq %rax, %xmm0
; X64-SSE-NEXT:    movaps %xmm2, %xmm3
; X64-SSE-NEXT:    shufps {{.*#+}} xmm3 = xmm3[1,1],xmm2[1,1]
; X64-SSE-NEXT:    cvtss2si %xmm3, %rax
; X64-SSE-NEXT:    movq %rax, %xmm3
; X64-SSE-NEXT:    punpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm3[0]
; X64-SSE-NEXT:    movaps %xmm2, %xmm3
; X64-SSE-NEXT:    shufps {{.*#+}} xmm3 = xmm3[3,3],xmm2[3,3]
; X64-SSE-NEXT:    cvtss2si %xmm3, %rax
; X64-SSE-NEXT:    movq %rax, %xmm3
; X64-SSE-NEXT:    movhlps {{.*#+}} xmm2 = xmm2[1,1]
; X64-SSE-NEXT:    cvtss2si %xmm2, %rax
; X64-SSE-NEXT:    movq %rax, %xmm4
; X64-SSE-NEXT:    punpcklqdq {{.*#+}} xmm4 = xmm4[0],xmm3[0]
; X64-SSE-NEXT:    cvtss2si %xmm1, %rax
; X64-SSE-NEXT:    movq %rax, %xmm2
; X64-SSE-NEXT:    movaps %xmm1, %xmm3
; X64-SSE-NEXT:    shufps {{.*#+}} xmm3 = xmm3[1,1],xmm1[1,1]
; X64-SSE-NEXT:    cvtss2si %xmm3, %rax
; X64-SSE-NEXT:    movq %rax, %xmm3
; X64-SSE-NEXT:    punpcklqdq {{.*#+}} xmm2 = xmm2[0],xmm3[0]
; X64-SSE-NEXT:    movaps %xmm1, %xmm3
; X64-SSE-NEXT:    shufps {{.*#+}} xmm3 = xmm3[3,3],xmm1[3,3]
; X64-SSE-NEXT:    cvtss2si %xmm3, %rax
; X64-SSE-NEXT:    movq %rax, %xmm5
; X64-SSE-NEXT:    movhlps {{.*#+}} xmm1 = xmm1[1,1]
; X64-SSE-NEXT:    cvtss2si %xmm1, %rax
; X64-SSE-NEXT:    movq %rax, %xmm3
; X64-SSE-NEXT:    punpcklqdq {{.*#+}} xmm3 = xmm3[0],xmm5[0]
; X64-SSE-NEXT:    movdqa %xmm4, %xmm1
; X64-SSE-NEXT:    retq
  %a = call <8 x i64> @llvm.llrint.v8i64.v8f32(<8 x float> %x)
  ret <8 x i64> %a
}
declare <8 x i64> @llvm.llrint.v8i64.v8f32(<8 x float>)

define <16 x i64> @llrint_v16i64_v16f32(<16 x float> %x) {
; X64-SSE-LABEL: llrint_v16i64_v16f32:
; X64-SSE:       # %bb.0:
; X64-SSE-NEXT:    movq %rdi, %rax
; X64-SSE-NEXT:    cvtss2si %xmm0, %rcx
; X64-SSE-NEXT:    movq %rcx, %xmm4
; X64-SSE-NEXT:    movaps %xmm0, %xmm5
; X64-SSE-NEXT:    shufps {{.*#+}} xmm5 = xmm5[1,1],xmm0[1,1]
; X64-SSE-NEXT:    cvtss2si %xmm5, %rcx
; X64-SSE-NEXT:    movq %rcx, %xmm5
; X64-SSE-NEXT:    punpcklqdq {{.*#+}} xmm4 = xmm4[0],xmm5[0]
; X64-SSE-NEXT:    movaps %xmm0, %xmm5
; X64-SSE-NEXT:    shufps {{.*#+}} xmm5 = xmm5[3,3],xmm0[3,3]
; X64-SSE-NEXT:    cvtss2si %xmm5, %rcx
; X64-SSE-NEXT:    movq %rcx, %xmm5
; X64-SSE-NEXT:    movhlps {{.*#+}} xmm0 = xmm0[1,1]
; X64-SSE-NEXT:    cvtss2si %xmm0, %rcx
; X64-SSE-NEXT:    movq %rcx, %xmm0
; X64-SSE-NEXT:    punpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm5[0]
; X64-SSE-NEXT:    cvtss2si %xmm1, %rcx
; X64-SSE-NEXT:    movq %rcx, %xmm5
; X64-SSE-NEXT:    movaps %xmm1, %xmm6
; X64-SSE-NEXT:    shufps {{.*#+}} xmm6 = xmm6[1,1],xmm1[1,1]
; X64-SSE-NEXT:    cvtss2si %xmm6, %rcx
; X64-SSE-NEXT:    movq %rcx, %xmm6
; X64-SSE-NEXT:    punpcklqdq {{.*#+}} xmm5 = xmm5[0],xmm6[0]
; X64-SSE-NEXT:    movaps %xmm1, %xmm6
; X64-SSE-NEXT:    shufps {{.*#+}} xmm6 = xmm6[3,3],xmm1[3,3]
; X64-SSE-NEXT:    cvtss2si %xmm6, %rcx
; X64-SSE-NEXT:    movq %rcx, %xmm6
; X64-SSE-NEXT:    movhlps {{.*#+}} xmm1 = xmm1[1,1]
; X64-SSE-NEXT:    cvtss2si %xmm1, %rcx
; X64-SSE-NEXT:    movq %rcx, %xmm1
; X64-SSE-NEXT:    punpcklqdq {{.*#+}} xmm1 = xmm1[0],xmm6[0]
; X64-SSE-NEXT:    cvtss2si %xmm2, %rcx
; X64-SSE-NEXT:    movq %rcx, %xmm6
; X64-SSE-NEXT:    movaps %xmm2, %xmm7
; X64-SSE-NEXT:    shufps {{.*#+}} xmm7 = xmm7[1,1],xmm2[1,1]
; X64-SSE-NEXT:    cvtss2si %xmm7, %rcx
; X64-SSE-NEXT:    movq %rcx, %xmm7
; X64-SSE-NEXT:    punpcklqdq {{.*#+}} xmm6 = xmm6[0],xmm7[0]
; X64-SSE-NEXT:    movaps %xmm2, %xmm7
; X64-SSE-NEXT:    shufps {{.*#+}} xmm7 = xmm7[3,3],xmm2[3,3]
; X64-SSE-NEXT:    cvtss2si %xmm7, %rcx
; X64-SSE-NEXT:    movq %rcx, %xmm7
; X64-SSE-NEXT:    movhlps {{.*#+}} xmm2 = xmm2[1,1]
; X64-SSE-NEXT:    cvtss2si %xmm2, %rcx
; X64-SSE-NEXT:    movq %rcx, %xmm2
; X64-SSE-NEXT:    punpcklqdq {{.*#+}} xmm2 = xmm2[0],xmm7[0]
; X64-SSE-NEXT:    cvtss2si %xmm3, %rcx
; X64-SSE-NEXT:    movq %rcx, %xmm7
; X64-SSE-NEXT:    movaps %xmm3, %xmm8
; X64-SSE-NEXT:    shufps {{.*#+}} xmm8 = xmm8[1,1],xmm3[1,1]
; X64-SSE-NEXT:    cvtss2si %xmm8, %rcx
; X64-SSE-NEXT:    movq %rcx, %xmm8
; X64-SSE-NEXT:    punpcklqdq {{.*#+}} xmm7 = xmm7[0],xmm8[0]
; X64-SSE-NEXT:    movaps %xmm3, %xmm8
; X64-SSE-NEXT:    shufps {{.*#+}} xmm8 = xmm8[3,3],xmm3[3,3]
; X64-SSE-NEXT:    cvtss2si %xmm8, %rcx
; X64-SSE-NEXT:    movq %rcx, %xmm8
; X64-SSE-NEXT:    movhlps {{.*#+}} xmm3 = xmm3[1,1]
; X64-SSE-NEXT:    cvtss2si %xmm3, %rcx
; X64-SSE-NEXT:    movq %rcx, %xmm3
; X64-SSE-NEXT:    punpcklqdq {{.*#+}} xmm3 = xmm3[0],xmm8[0]
; X64-SSE-NEXT:    movdqa %xmm3, 112(%rdi)
; X64-SSE-NEXT:    movdqa %xmm7, 96(%rdi)
; X64-SSE-NEXT:    movdqa %xmm2, 80(%rdi)
; X64-SSE-NEXT:    movdqa %xmm6, 64(%rdi)
; X64-SSE-NEXT:    movdqa %xmm1, 48(%rdi)
; X64-SSE-NEXT:    movdqa %xmm5, 32(%rdi)
; X64-SSE-NEXT:    movdqa %xmm0, 16(%rdi)
; X64-SSE-NEXT:    movdqa %xmm4, (%rdi)
; X64-SSE-NEXT:    retq
  %a = call <16 x i64> @llvm.llrint.v16i64.v16f32(<16 x float> %x)
  ret <16 x i64> %a
}
declare <16 x i64> @llvm.llrint.v16i64.v16f32(<16 x float>)

define <1 x i64> @llrint_v1i64_v1f64(<1 x double> %x) {
; X64-SSE-LABEL: llrint_v1i64_v1f64:
; X64-SSE:       # %bb.0:
; X64-SSE-NEXT:    cvtsd2si %xmm0, %rax
; X64-SSE-NEXT:    retq
;
; X64-AVX-LABEL: llrint_v1i64_v1f64:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vcvtsd2si %xmm0, %rax
; X64-AVX-NEXT:    retq
  %a = call <1 x i64> @llvm.llrint.v1i64.v1f64(<1 x double> %x)
  ret <1 x i64> %a
}
declare <1 x i64> @llvm.llrint.v1i64.v1f64(<1 x double>)

define <2 x i64> @llrint_v2i64_v2f64(<2 x double> %x) {
; X64-SSE-LABEL: llrint_v2i64_v2f64:
; X64-SSE:       # %bb.0:
; X64-SSE-NEXT:    cvtsd2si %xmm0, %rax
; X64-SSE-NEXT:    movq %rax, %xmm1
; X64-SSE-NEXT:    unpckhpd {{.*#+}} xmm0 = xmm0[1,1]
; X64-SSE-NEXT:    cvtsd2si %xmm0, %rax
; X64-SSE-NEXT:    movq %rax, %xmm0
; X64-SSE-NEXT:    punpcklqdq {{.*#+}} xmm1 = xmm1[0],xmm0[0]
; X64-SSE-NEXT:    movdqa %xmm1, %xmm0
; X64-SSE-NEXT:    retq
;
; X64-AVX-LABEL: llrint_v2i64_v2f64:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vcvtsd2si %xmm0, %rax
; X64-AVX-NEXT:    vmovq %rax, %xmm1
; X64-AVX-NEXT:    vshufpd {{.*#+}} xmm0 = xmm0[1,0]
; X64-AVX-NEXT:    vcvtsd2si %xmm0, %rax
; X64-AVX-NEXT:    vmovq %rax, %xmm0
; X64-AVX-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm1[0],xmm0[0]
; X64-AVX-NEXT:    retq
  %a = call <2 x i64> @llvm.llrint.v2i64.v2f64(<2 x double> %x)
  ret <2 x i64> %a
}
declare <2 x i64> @llvm.llrint.v2i64.v2f64(<2 x double>)

define <4 x i64> @llrint_v4i64_v4f64(<4 x double> %x) {
; X64-SSE-LABEL: llrint_v4i64_v4f64:
; X64-SSE:       # %bb.0:
; X64-SSE-NEXT:    cvtsd2si %xmm0, %rax
; X64-SSE-NEXT:    movq %rax, %xmm2
; X64-SSE-NEXT:    unpckhpd {{.*#+}} xmm0 = xmm0[1,1]
; X64-SSE-NEXT:    cvtsd2si %xmm0, %rax
; X64-SSE-NEXT:    movq %rax, %xmm0
; X64-SSE-NEXT:    punpcklqdq {{.*#+}} xmm2 = xmm2[0],xmm0[0]
; X64-SSE-NEXT:    cvtsd2si %xmm1, %rax
; X64-SSE-NEXT:    movq %rax, %xmm3
; X64-SSE-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1,1]
; X64-SSE-NEXT:    cvtsd2si %xmm1, %rax
; X64-SSE-NEXT:    movq %rax, %xmm0
; X64-SSE-NEXT:    punpcklqdq {{.*#+}} xmm3 = xmm3[0],xmm0[0]
; X64-SSE-NEXT:    movdqa %xmm2, %xmm0
; X64-SSE-NEXT:    movdqa %xmm3, %xmm1
; X64-SSE-NEXT:    retq
  %a = call <4 x i64> @llvm.llrint.v4i64.v4f64(<4 x double> %x)
  ret <4 x i64> %a
}
declare <4 x i64> @llvm.llrint.v4i64.v4f64(<4 x double>)

define <8 x i64> @llrint_v8i64_v8f64(<8 x double> %x) {
; X64-SSE-LABEL: llrint_v8i64_v8f64:
; X64-SSE:       # %bb.0:
; X64-SSE-NEXT:    cvtsd2si %xmm0, %rax
; X64-SSE-NEXT:    movq %rax, %xmm4
; X64-SSE-NEXT:    unpckhpd {{.*#+}} xmm0 = xmm0[1,1]
; X64-SSE-NEXT:    cvtsd2si %xmm0, %rax
; X64-SSE-NEXT:    movq %rax, %xmm0
; X64-SSE-NEXT:    punpcklqdq {{.*#+}} xmm4 = xmm4[0],xmm0[0]
; X64-SSE-NEXT:    cvtsd2si %xmm1, %rax
; X64-SSE-NEXT:    movq %rax, %xmm5
; X64-SSE-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1,1]
; X64-SSE-NEXT:    cvtsd2si %xmm1, %rax
; X64-SSE-NEXT:    movq %rax, %xmm0
; X64-SSE-NEXT:    punpcklqdq {{.*#+}} xmm5 = xmm5[0],xmm0[0]
; X64-SSE-NEXT:    cvtsd2si %xmm2, %rax
; X64-SSE-NEXT:    movq %rax, %xmm6
; X64-SSE-NEXT:    unpckhpd {{.*#+}} xmm2 = xmm2[1,1]
; X64-SSE-NEXT:    cvtsd2si %xmm2, %rax
; X64-SSE-NEXT:    movq %rax, %xmm0
; X64-SSE-NEXT:    punpcklqdq {{.*#+}} xmm6 = xmm6[0],xmm0[0]
; X64-SSE-NEXT:    cvtsd2si %xmm3, %rax
; X64-SSE-NEXT:    movq %rax, %xmm7
; X64-SSE-NEXT:    unpckhpd {{.*#+}} xmm3 = xmm3[1,1]
; X64-SSE-NEXT:    cvtsd2si %xmm3, %rax
; X64-SSE-NEXT:    movq %rax, %xmm0
; X64-SSE-NEXT:    punpcklqdq {{.*#+}} xmm7 = xmm7[0],xmm0[0]
; X64-SSE-NEXT:    movdqa %xmm4, %xmm0
; X64-SSE-NEXT:    movdqa %xmm5, %xmm1
; X64-SSE-NEXT:    movdqa %xmm6, %xmm2
; X64-SSE-NEXT:    movdqa %xmm7, %xmm3
; X64-SSE-NEXT:    retq
  %a = call <8 x i64> @llvm.llrint.v8i64.v8f64(<8 x double> %x)
  ret <8 x i64> %a
}
declare <8 x i64> @llvm.llrint.v8i64.v8f64(<8 x double>)
