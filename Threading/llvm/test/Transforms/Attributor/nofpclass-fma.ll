; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 2
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal -S < %s | FileCheck %s --check-prefixes=CHECK,TUNIT

declare float @llvm.fma.f32(float, float, float)
declare float @llvm.fmuladd.f32(float, float, float)

define float @ret_fma_same_mul_arg(float %arg0, float %arg1) {
; CHECK-LABEL: define nofpclass(nzero) float @ret_fma_same_mul_arg
; CHECK-SAME: (float nofpclass(nzero) [[ARG0:%.*]], float nofpclass(nzero) [[ARG1:%.*]]) #[[ATTR1:[0-9]+]] {
; CHECK-NEXT:    [[CALL:%.*]] = call nofpclass(nzero) float @llvm.fma.f32(float [[ARG0]], float [[ARG0]], float [[ARG1]]) #[[ATTR2:[0-9]+]]
; CHECK-NEXT:    ret float [[CALL]]
;
  %call = call float @llvm.fma.f32(float %arg0, float %arg0, float %arg1)
  ret float %call
}

define float @ret_fma_same_mul_arg_positive_addend(float %arg0, float nofpclass(ninf nsub nnorm) %arg1) {
; CHECK-LABEL: define nofpclass(ninf nzero nsub nnorm) float @ret_fma_same_mul_arg_positive_addend
; CHECK-SAME: (float nofpclass(ninf nzero nsub nnorm) [[ARG0:%.*]], float nofpclass(ninf nzero nsub nnorm) [[ARG1:%.*]]) #[[ATTR1]] {
; CHECK-NEXT:    [[CALL:%.*]] = call nofpclass(ninf nzero nsub nnorm) float @llvm.fma.f32(float [[ARG0]], float [[ARG0]], float [[ARG1]]) #[[ATTR2]]
; CHECK-NEXT:    ret float [[CALL]]
;
  %call = call float @llvm.fma.f32(float %arg0, float %arg0, float %arg1)
  ret float %call
}

define float @ret_fma_different_mul_arg_positive_addend(float %arg0, float %arg1, float nofpclass(ninf nsub nnorm) %arg2) {
; CHECK-LABEL: define float @ret_fma_different_mul_arg_positive_addend
; CHECK-SAME: (float [[ARG0:%.*]], float [[ARG1:%.*]], float nofpclass(ninf nsub nnorm) [[ARG2:%.*]]) #[[ATTR1]] {
; CHECK-NEXT:    [[CALL:%.*]] = call float @llvm.fma.f32(float [[ARG0]], float [[ARG1]], float [[ARG2]]) #[[ATTR2]]
; CHECK-NEXT:    ret float [[CALL]]
;
  %call = call float @llvm.fma.f32(float %arg0, float %arg1, float %arg2)
  ret float %call
}

define float @ret_fmuladd_different_same_arg_positive_addend(float %arg0, float nofpclass(ninf nsub nnorm) %arg1) {
; CHECK-LABEL: define nofpclass(ninf nzero nsub nnorm) float @ret_fmuladd_different_same_arg_positive_addend
; CHECK-SAME: (float nofpclass(ninf nzero nsub nnorm) [[ARG0:%.*]], float nofpclass(ninf nzero nsub nnorm) [[ARG1:%.*]]) #[[ATTR1]] {
; CHECK-NEXT:    [[CALL:%.*]] = call nofpclass(ninf nzero nsub nnorm) float @llvm.fmuladd.f32(float [[ARG0]], float [[ARG0]], float [[ARG1]]) #[[ATTR2]]
; CHECK-NEXT:    ret float [[CALL]]
;
  %call = call float @llvm.fmuladd.f32(float %arg0, float %arg0, float %arg1)
  ret float %call
}

;; NOTE: These prefixes are unused and the list is autogenerated. Do not add tests below this line:
; TUNIT: {{.*}}
