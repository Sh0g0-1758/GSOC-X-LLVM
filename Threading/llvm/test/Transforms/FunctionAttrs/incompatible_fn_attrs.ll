; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --check-attributes
; RUN: opt -S -o - -passes=function-attrs < %s | FileCheck %s

; Verify we remove argmemonly/inaccessiblememonly/inaccessiblemem_or_argmemonly
; function attributes when we derive readnone.

define ptr @given_argmem_infer_readnone(ptr %p) #0 {
; CHECK: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; CHECK-LABEL: @given_argmem_infer_readnone(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret ptr [[P:%.*]]
;
entry:
  ret ptr %p
}

define ptr @given_inaccessible_infer_readnone(ptr %p) #1 {
; CHECK: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; CHECK-LABEL: @given_inaccessible_infer_readnone(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret ptr [[P:%.*]]
;
entry:
  ret ptr %p
}

define ptr @given_inaccessible_or_argmem_infer_readnone(ptr %p) #2 {
; CHECK: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; CHECK-LABEL: @given_inaccessible_or_argmem_infer_readnone(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret ptr [[P:%.*]]
;
entry:
  ret ptr %p
}

attributes #0 = { argmemonly }
attributes #1 = { inaccessiblememonly }
attributes #2 = { inaccessiblemem_or_argmemonly }
