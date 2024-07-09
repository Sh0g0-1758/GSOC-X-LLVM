; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc --mtriple=loongarch64 --mattr=+lasx < %s | FileCheck %s

declare <16 x i16> @llvm.loongarch.lasx.xvaddwev.h.b(<32 x i8>, <32 x i8>)

define <16 x i16> @lasx_xvaddwev_h_b(<32 x i8> %va, <32 x i8> %vb) nounwind {
; CHECK-LABEL: lasx_xvaddwev_h_b:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvaddwev.h.b $xr0, $xr0, $xr1
; CHECK-NEXT:    ret
entry:
  %res = call <16 x i16> @llvm.loongarch.lasx.xvaddwev.h.b(<32 x i8> %va, <32 x i8> %vb)
  ret <16 x i16> %res
}

declare <8 x i32> @llvm.loongarch.lasx.xvaddwev.w.h(<16 x i16>, <16 x i16>)

define <8 x i32> @lasx_xvaddwev_w_h(<16 x i16> %va, <16 x i16> %vb) nounwind {
; CHECK-LABEL: lasx_xvaddwev_w_h:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvaddwev.w.h $xr0, $xr0, $xr1
; CHECK-NEXT:    ret
entry:
  %res = call <8 x i32> @llvm.loongarch.lasx.xvaddwev.w.h(<16 x i16> %va, <16 x i16> %vb)
  ret <8 x i32> %res
}

declare <4 x i64> @llvm.loongarch.lasx.xvaddwev.d.w(<8 x i32>, <8 x i32>)

define <4 x i64> @lasx_xvaddwev_d_w(<8 x i32> %va, <8 x i32> %vb) nounwind {
; CHECK-LABEL: lasx_xvaddwev_d_w:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvaddwev.d.w $xr0, $xr0, $xr1
; CHECK-NEXT:    ret
entry:
  %res = call <4 x i64> @llvm.loongarch.lasx.xvaddwev.d.w(<8 x i32> %va, <8 x i32> %vb)
  ret <4 x i64> %res
}

declare <4 x i64> @llvm.loongarch.lasx.xvaddwev.q.d(<4 x i64>, <4 x i64>)

define <4 x i64> @lasx_xvaddwev_q_d(<4 x i64> %va, <4 x i64> %vb) nounwind {
; CHECK-LABEL: lasx_xvaddwev_q_d:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvaddwev.q.d $xr0, $xr0, $xr1
; CHECK-NEXT:    ret
entry:
  %res = call <4 x i64> @llvm.loongarch.lasx.xvaddwev.q.d(<4 x i64> %va, <4 x i64> %vb)
  ret <4 x i64> %res
}

declare <16 x i16> @llvm.loongarch.lasx.xvaddwev.h.bu(<32 x i8>, <32 x i8>)

define <16 x i16> @lasx_xvaddwev_h_bu(<32 x i8> %va, <32 x i8> %vb) nounwind {
; CHECK-LABEL: lasx_xvaddwev_h_bu:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvaddwev.h.bu $xr0, $xr0, $xr1
; CHECK-NEXT:    ret
entry:
  %res = call <16 x i16> @llvm.loongarch.lasx.xvaddwev.h.bu(<32 x i8> %va, <32 x i8> %vb)
  ret <16 x i16> %res
}

declare <8 x i32> @llvm.loongarch.lasx.xvaddwev.w.hu(<16 x i16>, <16 x i16>)

define <8 x i32> @lasx_xvaddwev_w_hu(<16 x i16> %va, <16 x i16> %vb) nounwind {
; CHECK-LABEL: lasx_xvaddwev_w_hu:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvaddwev.w.hu $xr0, $xr0, $xr1
; CHECK-NEXT:    ret
entry:
  %res = call <8 x i32> @llvm.loongarch.lasx.xvaddwev.w.hu(<16 x i16> %va, <16 x i16> %vb)
  ret <8 x i32> %res
}

declare <4 x i64> @llvm.loongarch.lasx.xvaddwev.d.wu(<8 x i32>, <8 x i32>)

define <4 x i64> @lasx_xvaddwev_d_wu(<8 x i32> %va, <8 x i32> %vb) nounwind {
; CHECK-LABEL: lasx_xvaddwev_d_wu:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvaddwev.d.wu $xr0, $xr0, $xr1
; CHECK-NEXT:    ret
entry:
  %res = call <4 x i64> @llvm.loongarch.lasx.xvaddwev.d.wu(<8 x i32> %va, <8 x i32> %vb)
  ret <4 x i64> %res
}

declare <4 x i64> @llvm.loongarch.lasx.xvaddwev.q.du(<4 x i64>, <4 x i64>)

define <4 x i64> @lasx_xvaddwev_q_du(<4 x i64> %va, <4 x i64> %vb) nounwind {
; CHECK-LABEL: lasx_xvaddwev_q_du:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvaddwev.q.du $xr0, $xr0, $xr1
; CHECK-NEXT:    ret
entry:
  %res = call <4 x i64> @llvm.loongarch.lasx.xvaddwev.q.du(<4 x i64> %va, <4 x i64> %vb)
  ret <4 x i64> %res
}

declare <16 x i16> @llvm.loongarch.lasx.xvaddwev.h.bu.b(<32 x i8>, <32 x i8>)

define <16 x i16> @lasx_xvaddwev_h_bu_b(<32 x i8> %va, <32 x i8> %vb) nounwind {
; CHECK-LABEL: lasx_xvaddwev_h_bu_b:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvaddwev.h.bu.b $xr0, $xr0, $xr1
; CHECK-NEXT:    ret
entry:
  %res = call <16 x i16> @llvm.loongarch.lasx.xvaddwev.h.bu.b(<32 x i8> %va, <32 x i8> %vb)
  ret <16 x i16> %res
}

declare <8 x i32> @llvm.loongarch.lasx.xvaddwev.w.hu.h(<16 x i16>, <16 x i16>)

define <8 x i32> @lasx_xvaddwev_w_hu_h(<16 x i16> %va, <16 x i16> %vb) nounwind {
; CHECK-LABEL: lasx_xvaddwev_w_hu_h:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvaddwev.w.hu.h $xr0, $xr0, $xr1
; CHECK-NEXT:    ret
entry:
  %res = call <8 x i32> @llvm.loongarch.lasx.xvaddwev.w.hu.h(<16 x i16> %va, <16 x i16> %vb)
  ret <8 x i32> %res
}

declare <4 x i64> @llvm.loongarch.lasx.xvaddwev.d.wu.w(<8 x i32>, <8 x i32>)

define <4 x i64> @lasx_xvaddwev_d_wu_w(<8 x i32> %va, <8 x i32> %vb) nounwind {
; CHECK-LABEL: lasx_xvaddwev_d_wu_w:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvaddwev.d.wu.w $xr0, $xr0, $xr1
; CHECK-NEXT:    ret
entry:
  %res = call <4 x i64> @llvm.loongarch.lasx.xvaddwev.d.wu.w(<8 x i32> %va, <8 x i32> %vb)
  ret <4 x i64> %res
}

declare <4 x i64> @llvm.loongarch.lasx.xvaddwev.q.du.d(<4 x i64>, <4 x i64>)

define <4 x i64> @lasx_xvaddwev_q_du_d(<4 x i64> %va, <4 x i64> %vb) nounwind {
; CHECK-LABEL: lasx_xvaddwev_q_du_d:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvaddwev.q.du.d $xr0, $xr0, $xr1
; CHECK-NEXT:    ret
entry:
  %res = call <4 x i64> @llvm.loongarch.lasx.xvaddwev.q.du.d(<4 x i64> %va, <4 x i64> %vb)
  ret <4 x i64> %res
}

declare <16 x i16> @llvm.loongarch.lasx.xvaddwod.h.b(<32 x i8>, <32 x i8>)

define <16 x i16> @lasx_xvaddwod_h_b(<32 x i8> %va, <32 x i8> %vb) nounwind {
; CHECK-LABEL: lasx_xvaddwod_h_b:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvaddwod.h.b $xr0, $xr0, $xr1
; CHECK-NEXT:    ret
entry:
  %res = call <16 x i16> @llvm.loongarch.lasx.xvaddwod.h.b(<32 x i8> %va, <32 x i8> %vb)
  ret <16 x i16> %res
}

declare <8 x i32> @llvm.loongarch.lasx.xvaddwod.w.h(<16 x i16>, <16 x i16>)

define <8 x i32> @lasx_xvaddwod_w_h(<16 x i16> %va, <16 x i16> %vb) nounwind {
; CHECK-LABEL: lasx_xvaddwod_w_h:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvaddwod.w.h $xr0, $xr0, $xr1
; CHECK-NEXT:    ret
entry:
  %res = call <8 x i32> @llvm.loongarch.lasx.xvaddwod.w.h(<16 x i16> %va, <16 x i16> %vb)
  ret <8 x i32> %res
}

declare <4 x i64> @llvm.loongarch.lasx.xvaddwod.d.w(<8 x i32>, <8 x i32>)

define <4 x i64> @lasx_xvaddwod_d_w(<8 x i32> %va, <8 x i32> %vb) nounwind {
; CHECK-LABEL: lasx_xvaddwod_d_w:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvaddwod.d.w $xr0, $xr0, $xr1
; CHECK-NEXT:    ret
entry:
  %res = call <4 x i64> @llvm.loongarch.lasx.xvaddwod.d.w(<8 x i32> %va, <8 x i32> %vb)
  ret <4 x i64> %res
}

declare <4 x i64> @llvm.loongarch.lasx.xvaddwod.q.d(<4 x i64>, <4 x i64>)

define <4 x i64> @lasx_xvaddwod_q_d(<4 x i64> %va, <4 x i64> %vb) nounwind {
; CHECK-LABEL: lasx_xvaddwod_q_d:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvaddwod.q.d $xr0, $xr0, $xr1
; CHECK-NEXT:    ret
entry:
  %res = call <4 x i64> @llvm.loongarch.lasx.xvaddwod.q.d(<4 x i64> %va, <4 x i64> %vb)
  ret <4 x i64> %res
}

declare <16 x i16> @llvm.loongarch.lasx.xvaddwod.h.bu(<32 x i8>, <32 x i8>)

define <16 x i16> @lasx_xvaddwod_h_bu(<32 x i8> %va, <32 x i8> %vb) nounwind {
; CHECK-LABEL: lasx_xvaddwod_h_bu:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvaddwod.h.bu $xr0, $xr0, $xr1
; CHECK-NEXT:    ret
entry:
  %res = call <16 x i16> @llvm.loongarch.lasx.xvaddwod.h.bu(<32 x i8> %va, <32 x i8> %vb)
  ret <16 x i16> %res
}

declare <8 x i32> @llvm.loongarch.lasx.xvaddwod.w.hu(<16 x i16>, <16 x i16>)

define <8 x i32> @lasx_xvaddwod_w_hu(<16 x i16> %va, <16 x i16> %vb) nounwind {
; CHECK-LABEL: lasx_xvaddwod_w_hu:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvaddwod.w.hu $xr0, $xr0, $xr1
; CHECK-NEXT:    ret
entry:
  %res = call <8 x i32> @llvm.loongarch.lasx.xvaddwod.w.hu(<16 x i16> %va, <16 x i16> %vb)
  ret <8 x i32> %res
}

declare <4 x i64> @llvm.loongarch.lasx.xvaddwod.d.wu(<8 x i32>, <8 x i32>)

define <4 x i64> @lasx_xvaddwod_d_wu(<8 x i32> %va, <8 x i32> %vb) nounwind {
; CHECK-LABEL: lasx_xvaddwod_d_wu:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvaddwod.d.wu $xr0, $xr0, $xr1
; CHECK-NEXT:    ret
entry:
  %res = call <4 x i64> @llvm.loongarch.lasx.xvaddwod.d.wu(<8 x i32> %va, <8 x i32> %vb)
  ret <4 x i64> %res
}

declare <4 x i64> @llvm.loongarch.lasx.xvaddwod.q.du(<4 x i64>, <4 x i64>)

define <4 x i64> @lasx_xvaddwod_q_du(<4 x i64> %va, <4 x i64> %vb) nounwind {
; CHECK-LABEL: lasx_xvaddwod_q_du:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvaddwod.q.du $xr0, $xr0, $xr1
; CHECK-NEXT:    ret
entry:
  %res = call <4 x i64> @llvm.loongarch.lasx.xvaddwod.q.du(<4 x i64> %va, <4 x i64> %vb)
  ret <4 x i64> %res
}

declare <16 x i16> @llvm.loongarch.lasx.xvaddwod.h.bu.b(<32 x i8>, <32 x i8>)

define <16 x i16> @lasx_xvaddwod_h_bu_b(<32 x i8> %va, <32 x i8> %vb) nounwind {
; CHECK-LABEL: lasx_xvaddwod_h_bu_b:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvaddwod.h.bu.b $xr0, $xr0, $xr1
; CHECK-NEXT:    ret
entry:
  %res = call <16 x i16> @llvm.loongarch.lasx.xvaddwod.h.bu.b(<32 x i8> %va, <32 x i8> %vb)
  ret <16 x i16> %res
}

declare <8 x i32> @llvm.loongarch.lasx.xvaddwod.w.hu.h(<16 x i16>, <16 x i16>)

define <8 x i32> @lasx_xvaddwod_w_hu_h(<16 x i16> %va, <16 x i16> %vb) nounwind {
; CHECK-LABEL: lasx_xvaddwod_w_hu_h:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvaddwod.w.hu.h $xr0, $xr0, $xr1
; CHECK-NEXT:    ret
entry:
  %res = call <8 x i32> @llvm.loongarch.lasx.xvaddwod.w.hu.h(<16 x i16> %va, <16 x i16> %vb)
  ret <8 x i32> %res
}

declare <4 x i64> @llvm.loongarch.lasx.xvaddwod.d.wu.w(<8 x i32>, <8 x i32>)

define <4 x i64> @lasx_xvaddwod_d_wu_w(<8 x i32> %va, <8 x i32> %vb) nounwind {
; CHECK-LABEL: lasx_xvaddwod_d_wu_w:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvaddwod.d.wu.w $xr0, $xr0, $xr1
; CHECK-NEXT:    ret
entry:
  %res = call <4 x i64> @llvm.loongarch.lasx.xvaddwod.d.wu.w(<8 x i32> %va, <8 x i32> %vb)
  ret <4 x i64> %res
}

declare <4 x i64> @llvm.loongarch.lasx.xvaddwod.q.du.d(<4 x i64>, <4 x i64>)

define <4 x i64> @lasx_xvaddwod_q_du_d(<4 x i64> %va, <4 x i64> %vb) nounwind {
; CHECK-LABEL: lasx_xvaddwod_q_du_d:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvaddwod.q.du.d $xr0, $xr0, $xr1
; CHECK-NEXT:    ret
entry:
  %res = call <4 x i64> @llvm.loongarch.lasx.xvaddwod.q.du.d(<4 x i64> %va, <4 x i64> %vb)
  ret <4 x i64> %res
}
