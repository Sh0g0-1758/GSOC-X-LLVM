; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc --mtriple=loongarch64 --mattr=+lasx < %s | FileCheck %s

;; TREU
define void @v8f32_fcmp_true(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v8f32_fcmp_true:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvrepli.b $xr0, -1
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <8 x float>, ptr %a0
  %v1 = load <8 x float>, ptr %a1
  %cmp = fcmp true <8 x float> %v0, %v1
  %ext = sext <8 x i1> %cmp to <8 x i32>
  store <8 x i32> %ext, ptr %res
  ret void
}

;; FALSE
define void @v4f64_fcmp_false(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v4f64_fcmp_false:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvrepli.b $xr0, 0
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <4 x double>, ptr %a0
  %v1 = load <4 x double>, ptr %a1
  %cmp = fcmp false <4 x double> %v0, %v1
  %ext = sext <4 x i1> %cmp to <4 x i64>
  store <4 x i64> %ext, ptr %res
  ret void
}

;; SETOEQ
define void @v8f32_fcmp_oeq(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v8f32_fcmp_oeq:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvfcmp.ceq.s $xr0, $xr0, $xr1
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <8 x float>, ptr %a0
  %v1 = load <8 x float>, ptr %a1
  %cmp = fcmp oeq <8 x float> %v0, %v1
  %ext = sext <8 x i1> %cmp to <8 x i32>
  store <8 x i32> %ext, ptr %res
  ret void
}

define void @v4f64_fcmp_oeq(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v4f64_fcmp_oeq:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvfcmp.ceq.d $xr0, $xr0, $xr1
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <4 x double>, ptr %a0
  %v1 = load <4 x double>, ptr %a1
  %cmp = fcmp oeq <4 x double> %v0, %v1
  %ext = sext <4 x i1> %cmp to <4 x i64>
  store <4 x i64> %ext, ptr %res
  ret void
}

;; SETUEQ
define void @v8f32_fcmp_ueq(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v8f32_fcmp_ueq:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvfcmp.cueq.s $xr0, $xr0, $xr1
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <8 x float>, ptr %a0
  %v1 = load <8 x float>, ptr %a1
  %cmp = fcmp ueq <8 x float> %v0, %v1
  %ext = sext <8 x i1> %cmp to <8 x i32>
  store <8 x i32> %ext, ptr %res
  ret void
}

define void @v4f64_fcmp_ueq(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v4f64_fcmp_ueq:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvfcmp.cueq.d $xr0, $xr0, $xr1
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <4 x double>, ptr %a0
  %v1 = load <4 x double>, ptr %a1
  %cmp = fcmp ueq <4 x double> %v0, %v1
  %ext = sext <4 x i1> %cmp to <4 x i64>
  store <4 x i64> %ext, ptr %res
  ret void
}

;; SETEQ
define void @v8f32_fcmp_eq(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v8f32_fcmp_eq:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvfcmp.ceq.s $xr0, $xr0, $xr1
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <8 x float>, ptr %a0
  %v1 = load <8 x float>, ptr %a1
  %cmp = fcmp fast oeq <8 x float> %v0, %v1
  %ext = sext <8 x i1> %cmp to <8 x i32>
  store <8 x i32> %ext, ptr %res
  ret void
}

define void @v4f64_fcmp_eq(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v4f64_fcmp_eq:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvfcmp.ceq.d $xr0, $xr0, $xr1
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <4 x double>, ptr %a0
  %v1 = load <4 x double>, ptr %a1
  %cmp = fcmp fast ueq <4 x double> %v0, %v1
  %ext = sext <4 x i1> %cmp to <4 x i64>
  store <4 x i64> %ext, ptr %res
  ret void
}

;; SETOLE
define void @v8f32_fcmp_ole(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v8f32_fcmp_ole:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvfcmp.cle.s $xr0, $xr0, $xr1
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <8 x float>, ptr %a0
  %v1 = load <8 x float>, ptr %a1
  %cmp = fcmp ole <8 x float> %v0, %v1
  %ext = sext <8 x i1> %cmp to <8 x i32>
  store <8 x i32> %ext, ptr %res
  ret void
}

define void @v4f64_fcmp_ole(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v4f64_fcmp_ole:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvfcmp.cle.d $xr0, $xr0, $xr1
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <4 x double>, ptr %a0
  %v1 = load <4 x double>, ptr %a1
  %cmp = fcmp ole <4 x double> %v0, %v1
  %ext = sext <4 x i1> %cmp to <4 x i64>
  store <4 x i64> %ext, ptr %res
  ret void
}

;; SETULE
define void @v8f32_fcmp_ule(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v8f32_fcmp_ule:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvfcmp.cule.s $xr0, $xr0, $xr1
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <8 x float>, ptr %a0
  %v1 = load <8 x float>, ptr %a1
  %cmp = fcmp ule <8 x float> %v0, %v1
  %ext = sext <8 x i1> %cmp to <8 x i32>
  store <8 x i32> %ext, ptr %res
  ret void
}

define void @v4f64_fcmp_ule(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v4f64_fcmp_ule:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvfcmp.cule.d $xr0, $xr0, $xr1
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <4 x double>, ptr %a0
  %v1 = load <4 x double>, ptr %a1
  %cmp = fcmp ule <4 x double> %v0, %v1
  %ext = sext <4 x i1> %cmp to <4 x i64>
  store <4 x i64> %ext, ptr %res
  ret void
}

;; SETLE
define void @v8f32_fcmp_le(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v8f32_fcmp_le:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvfcmp.cle.s $xr0, $xr0, $xr1
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <8 x float>, ptr %a0
  %v1 = load <8 x float>, ptr %a1
  %cmp = fcmp fast ole <8 x float> %v0, %v1
  %ext = sext <8 x i1> %cmp to <8 x i32>
  store <8 x i32> %ext, ptr %res
  ret void
}

define void @v4f64_fcmp_le(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v4f64_fcmp_le:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvfcmp.cle.d $xr0, $xr0, $xr1
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <4 x double>, ptr %a0
  %v1 = load <4 x double>, ptr %a1
  %cmp = fcmp fast ule <4 x double> %v0, %v1
  %ext = sext <4 x i1> %cmp to <4 x i64>
  store <4 x i64> %ext, ptr %res
  ret void
}

;; SETOLT
define void @v8f32_fcmp_olt(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v8f32_fcmp_olt:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvfcmp.clt.s $xr0, $xr0, $xr1
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <8 x float>, ptr %a0
  %v1 = load <8 x float>, ptr %a1
  %cmp = fcmp olt <8 x float> %v0, %v1
  %ext = sext <8 x i1> %cmp to <8 x i32>
  store <8 x i32> %ext, ptr %res
  ret void
}

define void @v4f64_fcmp_olt(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v4f64_fcmp_olt:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvfcmp.clt.d $xr0, $xr0, $xr1
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <4 x double>, ptr %a0
  %v1 = load <4 x double>, ptr %a1
  %cmp = fcmp olt <4 x double> %v0, %v1
  %ext = sext <4 x i1> %cmp to <4 x i64>
  store <4 x i64> %ext, ptr %res
  ret void
}

;; SETULT
define void @v8f32_fcmp_ult(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v8f32_fcmp_ult:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvfcmp.cult.s $xr0, $xr0, $xr1
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <8 x float>, ptr %a0
  %v1 = load <8 x float>, ptr %a1
  %cmp = fcmp ult <8 x float> %v0, %v1
  %ext = sext <8 x i1> %cmp to <8 x i32>
  store <8 x i32> %ext, ptr %res
  ret void
}

define void @v4f64_fcmp_ult(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v4f64_fcmp_ult:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvfcmp.cult.d $xr0, $xr0, $xr1
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <4 x double>, ptr %a0
  %v1 = load <4 x double>, ptr %a1
  %cmp = fcmp ult <4 x double> %v0, %v1
  %ext = sext <4 x i1> %cmp to <4 x i64>
  store <4 x i64> %ext, ptr %res
  ret void
}

;; SETLT
define void @v8f32_fcmp_lt(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v8f32_fcmp_lt:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvfcmp.clt.s $xr0, $xr0, $xr1
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <8 x float>, ptr %a0
  %v1 = load <8 x float>, ptr %a1
  %cmp = fcmp fast olt <8 x float> %v0, %v1
  %ext = sext <8 x i1> %cmp to <8 x i32>
  store <8 x i32> %ext, ptr %res
  ret void
}

define void @v4f64_fcmp_lt(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v4f64_fcmp_lt:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvfcmp.clt.d $xr0, $xr0, $xr1
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <4 x double>, ptr %a0
  %v1 = load <4 x double>, ptr %a1
  %cmp = fcmp fast ult <4 x double> %v0, %v1
  %ext = sext <4 x i1> %cmp to <4 x i64>
  store <4 x i64> %ext, ptr %res
  ret void
}

;; SETONE
define void @v8f32_fcmp_one(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v8f32_fcmp_one:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvfcmp.cne.s $xr0, $xr0, $xr1
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <8 x float>, ptr %a0
  %v1 = load <8 x float>, ptr %a1
  %cmp = fcmp one <8 x float> %v0, %v1
  %ext = sext <8 x i1> %cmp to <8 x i32>
  store <8 x i32> %ext, ptr %res
  ret void
}

define void @v4f64_fcmp_one(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v4f64_fcmp_one:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvfcmp.cne.d $xr0, $xr0, $xr1
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <4 x double>, ptr %a0
  %v1 = load <4 x double>, ptr %a1
  %cmp = fcmp one <4 x double> %v0, %v1
  %ext = sext <4 x i1> %cmp to <4 x i64>
  store <4 x i64> %ext, ptr %res
  ret void
}

;; SETUNE
define void @v8f32_fcmp_une(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v8f32_fcmp_une:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvfcmp.cune.s $xr0, $xr0, $xr1
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <8 x float>, ptr %a0
  %v1 = load <8 x float>, ptr %a1
  %cmp = fcmp une <8 x float> %v0, %v1
  %ext = sext <8 x i1> %cmp to <8 x i32>
  store <8 x i32> %ext, ptr %res
  ret void
}

define void @v4f64_fcmp_une(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v4f64_fcmp_une:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvfcmp.cune.d $xr0, $xr0, $xr1
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <4 x double>, ptr %a0
  %v1 = load <4 x double>, ptr %a1
  %cmp = fcmp une <4 x double> %v0, %v1
  %ext = sext <4 x i1> %cmp to <4 x i64>
  store <4 x i64> %ext, ptr %res
  ret void
}

;; SETNE
define void @v8f32_fcmp_ne(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v8f32_fcmp_ne:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvfcmp.cne.s $xr0, $xr0, $xr1
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <8 x float>, ptr %a0
  %v1 = load <8 x float>, ptr %a1
  %cmp = fcmp fast one <8 x float> %v0, %v1
  %ext = sext <8 x i1> %cmp to <8 x i32>
  store <8 x i32> %ext, ptr %res
  ret void
}

define void @v4f64_fcmp_ne(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v4f64_fcmp_ne:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvfcmp.cne.d $xr0, $xr0, $xr1
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <4 x double>, ptr %a0
  %v1 = load <4 x double>, ptr %a1
  %cmp = fcmp fast une <4 x double> %v0, %v1
  %ext = sext <4 x i1> %cmp to <4 x i64>
  store <4 x i64> %ext, ptr %res
  ret void
}

;; SETO
define void @v8f32_fcmp_ord(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v8f32_fcmp_ord:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvfcmp.cor.s $xr0, $xr0, $xr1
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <8 x float>, ptr %a0
  %v1 = load <8 x float>, ptr %a1
  %cmp = fcmp ord <8 x float> %v0, %v1
  %ext = sext <8 x i1> %cmp to <8 x i32>
  store <8 x i32> %ext, ptr %res
  ret void
}

define void @v4f64_fcmp_ord(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v4f64_fcmp_ord:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvfcmp.cor.d $xr0, $xr0, $xr1
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <4 x double>, ptr %a0
  %v1 = load <4 x double>, ptr %a1
  %cmp = fcmp ord <4 x double> %v0, %v1
  %ext = sext <4 x i1> %cmp to <4 x i64>
  store <4 x i64> %ext, ptr %res
  ret void
}

;; SETUO
define void @v8f32_fcmp_uno(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v8f32_fcmp_uno:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvfcmp.cun.s $xr0, $xr0, $xr1
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <8 x float>, ptr %a0
  %v1 = load <8 x float>, ptr %a1
  %cmp = fcmp uno <8 x float> %v0, %v1
  %ext = sext <8 x i1> %cmp to <8 x i32>
  store <8 x i32> %ext, ptr %res
  ret void
}

define void @v4f64_fcmp_uno(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v4f64_fcmp_uno:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvfcmp.cun.d $xr0, $xr0, $xr1
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <4 x double>, ptr %a0
  %v1 = load <4 x double>, ptr %a1
  %cmp = fcmp uno <4 x double> %v0, %v1
  %ext = sext <4 x i1> %cmp to <4 x i64>
  store <4 x i64> %ext, ptr %res
  ret void
}

;; Expand SETOGT
define void @v8f32_fcmp_ogt(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v8f32_fcmp_ogt:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvfcmp.clt.s $xr0, $xr1, $xr0
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <8 x float>, ptr %a0
  %v1 = load <8 x float>, ptr %a1
  %cmp = fcmp ogt <8 x float> %v0, %v1
  %ext = sext <8 x i1> %cmp to <8 x i32>
  store <8 x i32> %ext, ptr %res
  ret void
}

define void @v4f64_fcmp_ogt(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v4f64_fcmp_ogt:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvfcmp.clt.d $xr0, $xr1, $xr0
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <4 x double>, ptr %a0
  %v1 = load <4 x double>, ptr %a1
  %cmp = fcmp ogt <4 x double> %v0, %v1
  %ext = sext <4 x i1> %cmp to <4 x i64>
  store <4 x i64> %ext, ptr %res
  ret void
}

;; Expand SETUGT
define void @v8f32_fcmp_ugt(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v8f32_fcmp_ugt:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvfcmp.cult.s $xr0, $xr1, $xr0
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <8 x float>, ptr %a0
  %v1 = load <8 x float>, ptr %a1
  %cmp = fcmp ugt <8 x float> %v0, %v1
  %ext = sext <8 x i1> %cmp to <8 x i32>
  store <8 x i32> %ext, ptr %res
  ret void
}

define void @v4f64_fcmp_ugt(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v4f64_fcmp_ugt:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvfcmp.cult.d $xr0, $xr1, $xr0
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <4 x double>, ptr %a0
  %v1 = load <4 x double>, ptr %a1
  %cmp = fcmp ugt <4 x double> %v0, %v1
  %ext = sext <4 x i1> %cmp to <4 x i64>
  store <4 x i64> %ext, ptr %res
  ret void
}

;; Expand SETGT
define void @v8f32_fcmp_gt(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v8f32_fcmp_gt:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvfcmp.clt.s $xr0, $xr1, $xr0
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <8 x float>, ptr %a0
  %v1 = load <8 x float>, ptr %a1
  %cmp = fcmp fast ogt <8 x float> %v0, %v1
  %ext = sext <8 x i1> %cmp to <8 x i32>
  store <8 x i32> %ext, ptr %res
  ret void
}

define void @v4f64_fcmp_gt(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v4f64_fcmp_gt:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvfcmp.clt.d $xr0, $xr1, $xr0
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <4 x double>, ptr %a0
  %v1 = load <4 x double>, ptr %a1
  %cmp = fcmp fast ugt <4 x double> %v0, %v1
  %ext = sext <4 x i1> %cmp to <4 x i64>
  store <4 x i64> %ext, ptr %res
  ret void
}

;; Expand SETOGE
define void @v8f32_fcmp_oge(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v8f32_fcmp_oge:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvfcmp.cle.s $xr0, $xr1, $xr0
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <8 x float>, ptr %a0
  %v1 = load <8 x float>, ptr %a1
  %cmp = fcmp oge <8 x float> %v0, %v1
  %ext = sext <8 x i1> %cmp to <8 x i32>
  store <8 x i32> %ext, ptr %res
  ret void
}

define void @v4f64_fcmp_oge(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v4f64_fcmp_oge:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvfcmp.cle.d $xr0, $xr1, $xr0
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <4 x double>, ptr %a0
  %v1 = load <4 x double>, ptr %a1
  %cmp = fcmp oge <4 x double> %v0, %v1
  %ext = sext <4 x i1> %cmp to <4 x i64>
  store <4 x i64> %ext, ptr %res
  ret void
}

;; Expand SETUGE
define void @v8f32_fcmp_uge(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v8f32_fcmp_uge:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvfcmp.cule.s $xr0, $xr1, $xr0
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <8 x float>, ptr %a0
  %v1 = load <8 x float>, ptr %a1
  %cmp = fcmp uge <8 x float> %v0, %v1
  %ext = sext <8 x i1> %cmp to <8 x i32>
  store <8 x i32> %ext, ptr %res
  ret void
}

define void @v4f64_fcmp_uge(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v4f64_fcmp_uge:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvfcmp.cule.d $xr0, $xr1, $xr0
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <4 x double>, ptr %a0
  %v1 = load <4 x double>, ptr %a1
  %cmp = fcmp uge <4 x double> %v0, %v1
  %ext = sext <4 x i1> %cmp to <4 x i64>
  store <4 x i64> %ext, ptr %res
  ret void
}

;; Expand SETGE
define void @v8f32_fcmp_ge(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v8f32_fcmp_ge:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvfcmp.cle.s $xr0, $xr1, $xr0
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <8 x float>, ptr %a0
  %v1 = load <8 x float>, ptr %a1
  %cmp = fcmp fast oge <8 x float> %v0, %v1
  %ext = sext <8 x i1> %cmp to <8 x i32>
  store <8 x i32> %ext, ptr %res
  ret void
}

define void @v4f64_fcmp_ge(ptr %res, ptr %a0, ptr %a1) nounwind {
; CHECK-LABEL: v4f64_fcmp_ge:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xvld $xr0, $a1, 0
; CHECK-NEXT:    xvld $xr1, $a2, 0
; CHECK-NEXT:    xvfcmp.cle.d $xr0, $xr1, $xr0
; CHECK-NEXT:    xvst $xr0, $a0, 0
; CHECK-NEXT:    ret
  %v0 = load <4 x double>, ptr %a0
  %v1 = load <4 x double>, ptr %a1
  %cmp = fcmp fast uge <4 x double> %v0, %v1
  %ext = sext <4 x i1> %cmp to <4 x i64>
  store <4 x i64> %ext, ptr %res
  ret void
}
