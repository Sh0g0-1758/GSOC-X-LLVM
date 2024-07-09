; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 4
; RUN: llc --mtriple=loongarch64 --mattr=+lasx < %s | FileCheck %s

define void @sub_v32i8(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: sub_v32i8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvsub.b $xr0, $xr0, $xr1
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
entry:
  %v0 = load <32 x i8>, ptr %a0
  %v1 = load <32 x i8>, ptr %a1
  %v2 = sub <32 x i8> %v0, %v1
  store <32 x i8> %v2, ptr %res
  ret void
}

define void @sub_v16i16(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: sub_v16i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvsub.h $xr0, $xr0, $xr1
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
entry:
  %v0 = load <16 x i16>, ptr %a0
  %v1 = load <16 x i16>, ptr %a1
  %v2 = sub <16 x i16> %v0, %v1
  store <16 x i16> %v2, ptr %res
  ret void
}

define void @sub_v8i32(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: sub_v8i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvsub.w $xr0, $xr0, $xr1
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
entry:
  %v0 = load <8 x i32>, ptr %a0
  %v1 = load <8 x i32>, ptr %a1
  %v2 = sub <8 x i32> %v0, %v1
  store <8 x i32> %v2, ptr %res
  ret void
}

define void @sub_v4i64(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: sub_v4i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvsub.d $xr0, $xr0, $xr1
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
entry:
  %v0 = load <4 x i64>, ptr %a0
  %v1 = load <4 x i64>, ptr %a1
  %v2 = sub <4 x i64> %v0, %v1
  store <4 x i64> %v2, ptr %res
  ret void
}

define void @sub_v32i8_31(ptr %res, ptr %a0) nounwind {
; CHECK-LABEL: sub_v32i8_31:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvsubi.bu $xr0, $xr0, 31
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
entry:
  %v0 = load <32 x i8>, ptr %a0
  %v1 = sub <32 x i8> %v0, <i8 31, i8 31, i8 31, i8 31, i8 31, i8 31, i8 31, i8 31, i8 31, i8 31, i8 31, i8 31, i8 31, i8 31, i8 31, i8 31, i8 31, i8 31, i8 31, i8 31, i8 31, i8 31, i8 31, i8 31, i8 31, i8 31, i8 31, i8 31, i8 31, i8 31, i8 31, i8 31>
  store <32 x i8> %v1, ptr %res
  ret void
}

define void @sub_v16i16_31(ptr %res, ptr %a0) nounwind {
; CHECK-LABEL: sub_v16i16_31:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvsubi.hu $xr0, $xr0, 31
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
entry:
  %v0 = load <16 x i16>, ptr %a0
  %v1 = sub <16 x i16> %v0, <i16 31, i16 31, i16 31, i16 31, i16 31, i16 31, i16 31, i16 31, i16 31, i16 31, i16 31, i16 31, i16 31, i16 31, i16 31, i16 31>
  store <16 x i16> %v1, ptr %res
  ret void
}

define void @sub_v8i32_31(ptr %res, ptr %a0) nounwind {
; CHECK-LABEL: sub_v8i32_31:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvsubi.wu $xr0, $xr0, 31
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
entry:
  %v0 = load <8 x i32>, ptr %a0
  %v1 = sub <8 x i32> %v0, <i32 31, i32 31, i32 31, i32 31, i32 31, i32 31, i32 31, i32 31>
  store <8 x i32> %v1, ptr %res
  ret void
}

define void @sub_v4i64_31(ptr %res, ptr %a0) nounwind {
; CHECK-LABEL: sub_v4i64_31:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvsubi.du $xr0, $xr0, 31
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
entry:
  %v0 = load <4 x i64>, ptr %a0
  %v1 = sub <4 x i64> %v0, <i64 31, i64 31, i64 31, i64 31>
  store <4 x i64> %v1, ptr %res
  ret void
}
