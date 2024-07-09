; RUN: not llc --mtriple=loongarch64 --mattr=+lasx < %s 2>&1 | FileCheck %s

declare <16 x i16> @llvm.loongarch.lasx.xvsllwil.h.b(<32 x i8>, i32)

define <16 x i16> @lasx_xvsllwil_h_b(<32 x i8> %va, i32 %b) nounwind {
; CHECK: immarg operand has non-immediate parameter
entry:
  %res = call <16 x i16> @llvm.loongarch.lasx.xvsllwil.h.b(<32 x i8> %va, i32 %b)
  ret <16 x i16> %res
}

declare <8 x i32> @llvm.loongarch.lasx.xvsllwil.w.h(<16 x i16>, i32)

define <8 x i32> @lasx_xvsllwil_w_h(<16 x i16> %va, i32 %b) nounwind {
; CHECK: immarg operand has non-immediate parameter
entry:
  %res = call <8 x i32> @llvm.loongarch.lasx.xvsllwil.w.h(<16 x i16> %va, i32 %b)
  ret <8 x i32> %res
}

declare <4 x i64> @llvm.loongarch.lasx.xvsllwil.d.w(<8 x i32>, i32)

define <4 x i64> @lasx_xvsllwil_d_w(<8 x i32> %va, i32 %b) nounwind {
; CHECK: immarg operand has non-immediate parameter
entry:
  %res = call <4 x i64> @llvm.loongarch.lasx.xvsllwil.d.w(<8 x i32> %va, i32 %b)
  ret <4 x i64> %res
}

declare <16 x i16> @llvm.loongarch.lasx.xvsllwil.hu.bu(<32 x i8>, i32)

define <16 x i16> @lasx_xvsllwil_hu_bu(<32 x i8> %va, i32 %b) nounwind {
; CHECK: immarg operand has non-immediate parameter
entry:
  %res = call <16 x i16> @llvm.loongarch.lasx.xvsllwil.hu.bu(<32 x i8> %va, i32 %b)
  ret <16 x i16> %res
}

declare <8 x i32> @llvm.loongarch.lasx.xvsllwil.wu.hu(<16 x i16>, i32)

define <8 x i32> @lasx_xvsllwil_wu_hu(<16 x i16> %va, i32 %b) nounwind {
; CHECK: immarg operand has non-immediate parameter
entry:
  %res = call <8 x i32> @llvm.loongarch.lasx.xvsllwil.wu.hu(<16 x i16> %va, i32 %b)
  ret <8 x i32> %res
}

declare <4 x i64> @llvm.loongarch.lasx.xvsllwil.du.wu(<8 x i32>, i32)

define <4 x i64> @lasx_xvsllwil_du_wu(<8 x i32> %va, i32 %b) nounwind {
; CHECK: immarg operand has non-immediate parameter
entry:
  %res = call <4 x i64> @llvm.loongarch.lasx.xvsllwil.du.wu(<8 x i32> %va, i32 %b)
  ret <4 x i64> %res
}
