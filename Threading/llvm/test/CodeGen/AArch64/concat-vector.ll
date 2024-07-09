; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64--linux-gnu | FileCheck %s

define <4 x i8> @concat1(<2 x i8> %A, <2 x i8> %B) {
; CHECK-LABEL: concat1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uzp1 v0.4h, v0.4h, v1.4h
; CHECK-NEXT:    ret
   %v4i8 = shufflevector <2 x i8> %A, <2 x i8> %B, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
   ret <4 x i8> %v4i8
}

define <8 x i8> @concat2(<4 x i8> %A, <4 x i8> %B) {
; CHECK-LABEL: concat2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uzp1 v0.8b, v0.8b, v1.8b
; CHECK-NEXT:    ret
   %v8i8 = shufflevector <4 x i8> %A, <4 x i8> %B, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
   ret <8 x i8> %v8i8
}

define <16 x i8> @concat3(<8 x i8> %A, <8 x i8> %B) {
; CHECK-LABEL: concat3:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $q1
; CHECK-NEXT:    mov v0.d[1], v1.d[0]
; CHECK-NEXT:    ret
   %v16i8 = shufflevector <8 x i8> %A, <8 x i8> %B, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
   ret <16 x i8> %v16i8
}

define <4 x i16> @concat4(<2 x i16> %A, <2 x i16> %B) {
; CHECK-LABEL: concat4:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uzp1 v0.4h, v0.4h, v1.4h
; CHECK-NEXT:    ret
   %v4i16 = shufflevector <2 x i16> %A, <2 x i16> %B, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
   ret <4 x i16> %v4i16
}

define <8 x i16> @concat5(<4 x i16> %A, <4 x i16> %B) {
; CHECK-LABEL: concat5:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $q1
; CHECK-NEXT:    mov v0.d[1], v1.d[0]
; CHECK-NEXT:    ret
   %v8i16 = shufflevector <4 x i16> %A, <4 x i16> %B, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
   ret <8 x i16> %v8i16
}

define <16 x i16> @concat6(ptr %A, ptr %B) {
; CHECK-LABEL: concat6:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr q0, [x0]
; CHECK-NEXT:    ldr q1, [x1]
; CHECK-NEXT:    ret
   %tmp1 = load <8 x i16>, ptr %A
   %tmp2 = load <8 x i16>, ptr %B
   %v16i16 = shufflevector <8 x i16> %tmp1, <8 x i16> %tmp2, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
   ret <16 x i16> %v16i16
}

define <4 x i32> @concat7(<2 x i32> %A, <2 x i32> %B) {
; CHECK-LABEL: concat7:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $q1
; CHECK-NEXT:    mov v0.d[1], v1.d[0]
; CHECK-NEXT:    ret
   %v4i32 = shufflevector <2 x i32> %A, <2 x i32> %B, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
   ret <4 x i32> %v4i32
}

define <8 x i32> @concat8(ptr %A, ptr %B) {
; CHECK-LABEL: concat8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr q0, [x0]
; CHECK-NEXT:    ldr q1, [x1]
; CHECK-NEXT:    ret
   %tmp1 = load <4 x i32>, ptr %A
   %tmp2 = load <4 x i32>, ptr %B
   %v8i32 = shufflevector <4 x i32> %tmp1, <4 x i32> %tmp2, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
   ret <8 x i32> %v8i32
}

define <4 x half> @concat9(<2 x half> %A, <2 x half> %B) {
; CHECK-LABEL: concat9:
; CHECK:       // %bb.0:
; CHECK-NEXT:    zip1 v0.2s, v0.2s, v1.2s
; CHECK-NEXT:    ret
   %v4half= shufflevector <2 x half> %A, <2 x half> %B, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
   ret <4 x half> %v4half
}

define <8 x half> @concat10(<4 x half> %A, <4 x half> %B) {
; CHECK-LABEL: concat10:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $q1
; CHECK-NEXT:    mov v0.d[1], v1.d[0]
; CHECK-NEXT:    ret
   %v8half= shufflevector <4 x half> %A, <4 x half> %B, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
   ret <8 x half> %v8half
}

define <16 x half> @concat11(<8 x half> %A, <8 x half> %B) {
; CHECK-LABEL: concat11:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
   %v16half= shufflevector <8 x half> %A, <8 x half> %B, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
   ret <16 x half> %v16half
}
