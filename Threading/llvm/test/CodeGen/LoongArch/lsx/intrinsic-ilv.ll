; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc --mtriple=loongarch64 --mattr=+lsx < %s | FileCheck %s

declare <16 x i8> @llvm.loongarch.lsx.vilvl.b(<16 x i8>, <16 x i8>)

define <16 x i8> @lsx_vilvl_b(<16 x i8> %va, <16 x i8> %vb) nounwind {
; CHECK-LABEL: lsx_vilvl_b:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vilvl.b $vr0, $vr0, $vr1
; CHECK-NEXT:    ret
entry:
  %res = call <16 x i8> @llvm.loongarch.lsx.vilvl.b(<16 x i8> %va, <16 x i8> %vb)
  ret <16 x i8> %res
}

declare <8 x i16> @llvm.loongarch.lsx.vilvl.h(<8 x i16>, <8 x i16>)

define <8 x i16> @lsx_vilvl_h(<8 x i16> %va, <8 x i16> %vb) nounwind {
; CHECK-LABEL: lsx_vilvl_h:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vilvl.h $vr0, $vr0, $vr1
; CHECK-NEXT:    ret
entry:
  %res = call <8 x i16> @llvm.loongarch.lsx.vilvl.h(<8 x i16> %va, <8 x i16> %vb)
  ret <8 x i16> %res
}

declare <4 x i32> @llvm.loongarch.lsx.vilvl.w(<4 x i32>, <4 x i32>)

define <4 x i32> @lsx_vilvl_w(<4 x i32> %va, <4 x i32> %vb) nounwind {
; CHECK-LABEL: lsx_vilvl_w:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vilvl.w $vr0, $vr0, $vr1
; CHECK-NEXT:    ret
entry:
  %res = call <4 x i32> @llvm.loongarch.lsx.vilvl.w(<4 x i32> %va, <4 x i32> %vb)
  ret <4 x i32> %res
}

declare <2 x i64> @llvm.loongarch.lsx.vilvl.d(<2 x i64>, <2 x i64>)

define <2 x i64> @lsx_vilvl_d(<2 x i64> %va, <2 x i64> %vb) nounwind {
; CHECK-LABEL: lsx_vilvl_d:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vilvl.d $vr0, $vr0, $vr1
; CHECK-NEXT:    ret
entry:
  %res = call <2 x i64> @llvm.loongarch.lsx.vilvl.d(<2 x i64> %va, <2 x i64> %vb)
  ret <2 x i64> %res
}

declare <16 x i8> @llvm.loongarch.lsx.vilvh.b(<16 x i8>, <16 x i8>)

define <16 x i8> @lsx_vilvh_b(<16 x i8> %va, <16 x i8> %vb) nounwind {
; CHECK-LABEL: lsx_vilvh_b:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vilvh.b $vr0, $vr0, $vr1
; CHECK-NEXT:    ret
entry:
  %res = call <16 x i8> @llvm.loongarch.lsx.vilvh.b(<16 x i8> %va, <16 x i8> %vb)
  ret <16 x i8> %res
}

declare <8 x i16> @llvm.loongarch.lsx.vilvh.h(<8 x i16>, <8 x i16>)

define <8 x i16> @lsx_vilvh_h(<8 x i16> %va, <8 x i16> %vb) nounwind {
; CHECK-LABEL: lsx_vilvh_h:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vilvh.h $vr0, $vr0, $vr1
; CHECK-NEXT:    ret
entry:
  %res = call <8 x i16> @llvm.loongarch.lsx.vilvh.h(<8 x i16> %va, <8 x i16> %vb)
  ret <8 x i16> %res
}

declare <4 x i32> @llvm.loongarch.lsx.vilvh.w(<4 x i32>, <4 x i32>)

define <4 x i32> @lsx_vilvh_w(<4 x i32> %va, <4 x i32> %vb) nounwind {
; CHECK-LABEL: lsx_vilvh_w:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vilvh.w $vr0, $vr0, $vr1
; CHECK-NEXT:    ret
entry:
  %res = call <4 x i32> @llvm.loongarch.lsx.vilvh.w(<4 x i32> %va, <4 x i32> %vb)
  ret <4 x i32> %res
}

declare <2 x i64> @llvm.loongarch.lsx.vilvh.d(<2 x i64>, <2 x i64>)

define <2 x i64> @lsx_vilvh_d(<2 x i64> %va, <2 x i64> %vb) nounwind {
; CHECK-LABEL: lsx_vilvh_d:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vilvh.d $vr0, $vr0, $vr1
; CHECK-NEXT:    ret
entry:
  %res = call <2 x i64> @llvm.loongarch.lsx.vilvh.d(<2 x i64> %va, <2 x i64> %vb)
  ret <2 x i64> %res
}
