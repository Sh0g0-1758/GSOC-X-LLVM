; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes=instcombine < %s | FileCheck %s

target triple = "aarch64-unknown-linux-gnu"

; PTEST first can be changed to any if the mask and operand are the same
define i1 @ptest_first_to_any(<vscale x 16 x i1> %a) #0 {
; CHECK-LABEL: @ptest_first_to_any(
; CHECK-NEXT:    [[OUT:%.*]] = call i1 @llvm.aarch64.sve.ptest.any.nxv16i1(<vscale x 16 x i1> [[A:%.*]], <vscale x 16 x i1> [[A]])
; CHECK-NEXT:    ret i1 [[OUT]]
;
  %out = call i1 @llvm.aarch64.sve.ptest.first.nxv16i1(<vscale x 16 x i1> %a, <vscale x 16 x i1> %a)
  ret i1 %out
}

; PTEST last can be changed to any if the mask and operand are the same
define i1 @ptest_last_to_any(<vscale x 16 x i1> %a) #0 {
; CHECK-LABEL: @ptest_last_to_any(
; CHECK-NEXT:    [[OUT:%.*]] = call i1 @llvm.aarch64.sve.ptest.any.nxv16i1(<vscale x 16 x i1> [[A:%.*]], <vscale x 16 x i1> [[A]])
; CHECK-NEXT:    ret i1 [[OUT]]
;
  %out = call i1 @llvm.aarch64.sve.ptest.last.nxv16i1(<vscale x 16 x i1> %a, <vscale x 16 x i1> %a)
  ret i1 %out
}

define i1 @ptest_any1(<vscale x 2 x i1> %a) #0 {
; CHECK-LABEL: @ptest_any1(
; CHECK-NEXT:    [[MASK:%.*]] = tail call <vscale x 2 x i1> @llvm.aarch64.sve.ptrue.nxv2i1(i32 0)
; CHECK-NEXT:    [[OUT:%.*]] = call i1 @llvm.aarch64.sve.ptest.any.nxv2i1(<vscale x 2 x i1> [[MASK]], <vscale x 2 x i1> [[A:%.*]])
; CHECK-NEXT:    ret i1 [[OUT]]
;
  %mask = tail call <vscale x 2 x i1> @llvm.aarch64.sve.ptrue.nxv2i1(i32 0)
  %1 = tail call <vscale x 16 x i1> @llvm.aarch64.sve.convert.to.svbool.nxv2i1(<vscale x 2 x i1> %mask)
  %2 = tail call <vscale x 16 x i1> @llvm.aarch64.sve.convert.to.svbool.nxv2i1(<vscale x 2 x i1> %a)
  %out = call i1 @llvm.aarch64.sve.ptest.any.nxv16i1(<vscale x 16 x i1> %1, <vscale x 16 x i1> %2)
  ret i1 %out
}

; No transform because the ptest is using differently sized operands.
define i1 @ptest_any2(<vscale x 4 x i1> %a) #0 {
; CHECK-LABEL: @ptest_any2(
; CHECK-NEXT:    [[MASK:%.*]] = tail call <vscale x 2 x i1> @llvm.aarch64.sve.ptrue.nxv2i1(i32 31)
; CHECK-NEXT:    [[TMP1:%.*]] = tail call <vscale x 16 x i1> @llvm.aarch64.sve.convert.to.svbool.nxv2i1(<vscale x 2 x i1> [[MASK]])
; CHECK-NEXT:    [[TMP2:%.*]] = tail call <vscale x 16 x i1> @llvm.aarch64.sve.convert.to.svbool.nxv4i1(<vscale x 4 x i1> [[A:%.*]])
; CHECK-NEXT:    [[OUT:%.*]] = call i1 @llvm.aarch64.sve.ptest.any.nxv16i1(<vscale x 16 x i1> [[TMP1]], <vscale x 16 x i1> [[TMP2]])
; CHECK-NEXT:    ret i1 [[OUT]]
;
  %mask = tail call <vscale x 2 x i1> @llvm.aarch64.sve.ptrue.nxv2i1(i32 31)
  %1 = tail call <vscale x 16 x i1> @llvm.aarch64.sve.convert.to.svbool.nxv2i1(<vscale x 2 x i1> %mask)
  %2 = tail call <vscale x 16 x i1> @llvm.aarch64.sve.convert.to.svbool.nxv4i1(<vscale x 4 x i1> %a)
  %out = call i1 @llvm.aarch64.sve.ptest.any.nxv16i1(<vscale x 16 x i1> %1, <vscale x 16 x i1> %2)
  ret i1 %out
}

define i1 @ptest_first(<vscale x 4 x i1> %a) #0 {
; CHECK-LABEL: @ptest_first(
; CHECK-NEXT:    [[MASK:%.*]] = tail call <vscale x 4 x i1> @llvm.aarch64.sve.ptrue.nxv4i1(i32 0)
; CHECK-NEXT:    [[OUT:%.*]] = call i1 @llvm.aarch64.sve.ptest.first.nxv4i1(<vscale x 4 x i1> [[MASK]], <vscale x 4 x i1> [[A:%.*]])
; CHECK-NEXT:    ret i1 [[OUT]]
;
  %mask = tail call <vscale x 4 x i1> @llvm.aarch64.sve.ptrue.nxv4i1(i32 0)
  %1 = tail call <vscale x 16 x i1> @llvm.aarch64.sve.convert.to.svbool.nxv4i1(<vscale x 4 x i1> %mask)
  %2 = tail call <vscale x 16 x i1> @llvm.aarch64.sve.convert.to.svbool.nxv4i1(<vscale x 4 x i1> %a)
  %out = call i1 @llvm.aarch64.sve.ptest.first.nxv16i1(<vscale x 16 x i1> %1, <vscale x 16 x i1> %2)
  ret i1 %out
}

define i1 @ptest_first_same_ops(<vscale x 2 x i1> %a) #0 {
; CHECK-LABEL: @ptest_first_same_ops(
; CHECK-NEXT:    [[TMP1:%.*]] = call i1 @llvm.aarch64.sve.ptest.any.nxv2i1(<vscale x 2 x i1> [[A:%.*]], <vscale x 2 x i1> [[A]])
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %1 = tail call <vscale x 16 x i1> @llvm.aarch64.sve.convert.to.svbool.nxv2i1(<vscale x 2 x i1> %a)
  %2 = tail call i1 @llvm.aarch64.sve.ptest.first.nxv16i1(<vscale x 16 x i1> %1, <vscale x 16 x i1> %1)
  ret i1 %2
}

define i1 @ptest_last(<vscale x 8 x i1> %a) #0 {
; CHECK-LABEL: @ptest_last(
; CHECK-NEXT:    [[MASK:%.*]] = tail call <vscale x 8 x i1> @llvm.aarch64.sve.ptrue.nxv8i1(i32 0)
; CHECK-NEXT:    [[OUT:%.*]] = call i1 @llvm.aarch64.sve.ptest.last.nxv8i1(<vscale x 8 x i1> [[MASK]], <vscale x 8 x i1> [[A:%.*]])
; CHECK-NEXT:    ret i1 [[OUT]]
;
  %mask = tail call <vscale x 8 x i1> @llvm.aarch64.sve.ptrue.nxv8i1(i32 0)
  %1 = tail call <vscale x 16 x i1> @llvm.aarch64.sve.convert.to.svbool.nxv8i1(<vscale x 8 x i1> %mask)
  %2 = tail call <vscale x 16 x i1> @llvm.aarch64.sve.convert.to.svbool.nxv8i1(<vscale x 8 x i1> %a)
  %out = call i1 @llvm.aarch64.sve.ptest.last.nxv16i1(<vscale x 16 x i1> %1, <vscale x 16 x i1> %2)
  ret i1 %out
}

; Rewrite PTEST_ANY(X=OP(PG,...), X) -> PTEST_ANY(PG, X)).

define i1 @ptest_any_brka_z(<vscale x 16 x i1> %pg, <vscale x 16 x i1> %a) {
; CHECK-LABEL: @ptest_any_brka_z(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call <vscale x 16 x i1> @llvm.aarch64.sve.brka.z.nxv16i1(<vscale x 16 x i1> [[PG:%.*]], <vscale x 16 x i1> [[A:%.*]])
; CHECK-NEXT:    [[OUT:%.*]] = call i1 @llvm.aarch64.sve.ptest.any.nxv16i1(<vscale x 16 x i1> [[PG]], <vscale x 16 x i1> [[TMP1]])
; CHECK-NEXT:    ret i1 [[OUT]]
;
  %1 = tail call <vscale x 16 x i1> @llvm.aarch64.sve.brka.z.nxv16i1(<vscale x 16 x i1> %pg, <vscale x 16 x i1> %a)
  %out = call i1 @llvm.aarch64.sve.ptest.any.nxv16i1(<vscale x 16 x i1> %1, <vscale x 16 x i1> %1)
  ret i1 %out
}

define i1 @ptest_any_brkpa_z(<vscale x 16 x i1> %pg, <vscale x 16 x i1> %a, <vscale x 16 x i1> %b) {
; CHECK-LABEL: @ptest_any_brkpa_z(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call <vscale x 16 x i1> @llvm.aarch64.sve.brkpa.z.nxv16i1(<vscale x 16 x i1> [[PG:%.*]], <vscale x 16 x i1> [[A:%.*]], <vscale x 16 x i1> [[B:%.*]])
; CHECK-NEXT:    [[OUT:%.*]] = call i1 @llvm.aarch64.sve.ptest.any.nxv16i1(<vscale x 16 x i1> [[PG]], <vscale x 16 x i1> [[TMP1]])
; CHECK-NEXT:    ret i1 [[OUT]]
;
  %1 = tail call <vscale x 16 x i1> @llvm.aarch64.sve.brkpa.z.nxv16i1(<vscale x 16 x i1> %pg, <vscale x 16 x i1> %a, <vscale x 16 x i1> %b)
  %out = call i1 @llvm.aarch64.sve.ptest.any.nxv16i1(<vscale x 16 x i1> %1, <vscale x 16 x i1> %1)
  ret i1 %out
}

define i1 @ptest_any_brkb_z(<vscale x 16 x i1> %pg, <vscale x 16 x i1> %a) {
; CHECK-LABEL: @ptest_any_brkb_z(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call <vscale x 16 x i1> @llvm.aarch64.sve.brkb.z.nxv16i1(<vscale x 16 x i1> [[PG:%.*]], <vscale x 16 x i1> [[A:%.*]])
; CHECK-NEXT:    [[OUT:%.*]] = call i1 @llvm.aarch64.sve.ptest.any.nxv16i1(<vscale x 16 x i1> [[PG]], <vscale x 16 x i1> [[TMP1]])
; CHECK-NEXT:    ret i1 [[OUT]]
;
  %1 = tail call <vscale x 16 x i1> @llvm.aarch64.sve.brkb.z.nxv16i1(<vscale x 16 x i1> %pg, <vscale x 16 x i1> %a)
  %out = call i1 @llvm.aarch64.sve.ptest.any.nxv16i1(<vscale x 16 x i1> %1, <vscale x 16 x i1> %1)
  ret i1 %out
}

define i1 @ptest_any_brkpb_z(<vscale x 16 x i1> %pg, <vscale x 16 x i1> %a, <vscale x 16 x i1> %b) {
; CHECK-LABEL: @ptest_any_brkpb_z(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call <vscale x 16 x i1> @llvm.aarch64.sve.brkpb.z.nxv16i1(<vscale x 16 x i1> [[PG:%.*]], <vscale x 16 x i1> [[A:%.*]], <vscale x 16 x i1> [[B:%.*]])
; CHECK-NEXT:    [[OUT:%.*]] = call i1 @llvm.aarch64.sve.ptest.any.nxv16i1(<vscale x 16 x i1> [[PG]], <vscale x 16 x i1> [[TMP1]])
; CHECK-NEXT:    ret i1 [[OUT]]
;
  %1 = tail call <vscale x 16 x i1> @llvm.aarch64.sve.brkpb.z.nxv16i1(<vscale x 16 x i1> %pg, <vscale x 16 x i1> %a, <vscale x 16 x i1> %b)
  %out = call i1 @llvm.aarch64.sve.ptest.any.nxv16i1(<vscale x 16 x i1> %1, <vscale x 16 x i1> %1)
  ret i1 %out
}

define i1 @ptest_any_rdffr_z(<vscale x 16 x i1> %pg) {
; CHECK-LABEL: @ptest_any_rdffr_z(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call <vscale x 16 x i1> @llvm.aarch64.sve.rdffr.z(<vscale x 16 x i1> [[PG:%.*]])
; CHECK-NEXT:    [[OUT:%.*]] = call i1 @llvm.aarch64.sve.ptest.any.nxv16i1(<vscale x 16 x i1> [[PG]], <vscale x 16 x i1> [[TMP1]])
; CHECK-NEXT:    ret i1 [[OUT]]
;
  %1 = tail call <vscale x 16 x i1> @llvm.aarch64.sve.rdffr.z(<vscale x 16 x i1> %pg)
  %out = call i1 @llvm.aarch64.sve.ptest.any.nxv16i1(<vscale x 16 x i1> %1, <vscale x 16 x i1> %1)
  ret i1 %out
}

define i1 @ptest_any_and_z(<vscale x 16 x i1> %pg, <vscale x 16 x i1> %a, <vscale x 16 x i1> %b) {
; CHECK-LABEL: @ptest_any_and_z(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call <vscale x 16 x i1> @llvm.aarch64.sve.and.z.nxv16i1(<vscale x 16 x i1> [[PG:%.*]], <vscale x 16 x i1> [[A:%.*]], <vscale x 16 x i1> [[B:%.*]])
; CHECK-NEXT:    [[TMP2:%.*]] = call i1 @llvm.aarch64.sve.ptest.any.nxv16i1(<vscale x 16 x i1> [[PG]], <vscale x 16 x i1> [[TMP1]])
; CHECK-NEXT:    ret i1 [[TMP2]]
;
  %1 = tail call <vscale x 16 x i1> @llvm.aarch64.sve.and.z.nxv16i1(<vscale x 16 x i1> %pg, <vscale x 16 x i1> %a, <vscale x 16 x i1> %b)
  %2 = call i1 @llvm.aarch64.sve.ptest.any.nxv16i1(<vscale x 16 x i1> %1, <vscale x 16 x i1> %1)
  ret i1 %2
}

define i1 @ptest_any_bic_z(<vscale x 16 x i1> %pg, <vscale x 16 x i1> %a, <vscale x 16 x i1> %b) {
; CHECK-LABEL: @ptest_any_bic_z(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call <vscale x 16 x i1> @llvm.aarch64.sve.bic.z.nxv16i1(<vscale x 16 x i1> [[PG:%.*]], <vscale x 16 x i1> [[A:%.*]], <vscale x 16 x i1> [[B:%.*]])
; CHECK-NEXT:    [[TMP2:%.*]] = call i1 @llvm.aarch64.sve.ptest.any.nxv16i1(<vscale x 16 x i1> [[PG]], <vscale x 16 x i1> [[TMP1]])
; CHECK-NEXT:    ret i1 [[TMP2]]
;
  %1 = tail call <vscale x 16 x i1> @llvm.aarch64.sve.bic.z.nxv16i1(<vscale x 16 x i1> %pg, <vscale x 16 x i1> %a, <vscale x 16 x i1> %b)
  %2 = call i1 @llvm.aarch64.sve.ptest.any.nxv16i1(<vscale x 16 x i1> %1, <vscale x 16 x i1> %1)
  ret i1 %2
}

define i1 @ptest_any_eor_z(<vscale x 16 x i1> %pg, <vscale x 16 x i1> %a, <vscale x 16 x i1> %b) {
; CHECK-LABEL: @ptest_any_eor_z(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call <vscale x 16 x i1> @llvm.aarch64.sve.eor.z.nxv16i1(<vscale x 16 x i1> [[PG:%.*]], <vscale x 16 x i1> [[A:%.*]], <vscale x 16 x i1> [[B:%.*]])
; CHECK-NEXT:    [[TMP2:%.*]] = call i1 @llvm.aarch64.sve.ptest.any.nxv16i1(<vscale x 16 x i1> [[PG]], <vscale x 16 x i1> [[TMP1]])
; CHECK-NEXT:    ret i1 [[TMP2]]
;
  %1 = tail call <vscale x 16 x i1> @llvm.aarch64.sve.eor.z.nxv16i1(<vscale x 16 x i1> %pg, <vscale x 16 x i1> %a, <vscale x 16 x i1> %b)
  %2 = call i1 @llvm.aarch64.sve.ptest.any.nxv16i1(<vscale x 16 x i1> %1, <vscale x 16 x i1> %1)
  ret i1 %2
}

define i1 @ptest_any_nand_z(<vscale x 16 x i1> %pg, <vscale x 16 x i1> %a, <vscale x 16 x i1> %b) {
; CHECK-LABEL: @ptest_any_nand_z(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call <vscale x 16 x i1> @llvm.aarch64.sve.nand.z.nxv16i1(<vscale x 16 x i1> [[PG:%.*]], <vscale x 16 x i1> [[A:%.*]], <vscale x 16 x i1> [[B:%.*]])
; CHECK-NEXT:    [[TMP2:%.*]] = call i1 @llvm.aarch64.sve.ptest.any.nxv16i1(<vscale x 16 x i1> [[PG]], <vscale x 16 x i1> [[TMP1]])
; CHECK-NEXT:    ret i1 [[TMP2]]
;
  %1 = tail call <vscale x 16 x i1> @llvm.aarch64.sve.nand.z.nxv16i1(<vscale x 16 x i1> %pg, <vscale x 16 x i1> %a, <vscale x 16 x i1> %b)
  %2 = call i1 @llvm.aarch64.sve.ptest.any.nxv16i1(<vscale x 16 x i1> %1, <vscale x 16 x i1> %1)
  ret i1 %2
}

define i1 @ptest_any_nor_z(<vscale x 16 x i1> %pg, <vscale x 16 x i1> %a, <vscale x 16 x i1> %b) {
; CHECK-LABEL: @ptest_any_nor_z(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call <vscale x 16 x i1> @llvm.aarch64.sve.nor.z.nxv16i1(<vscale x 16 x i1> [[PG:%.*]], <vscale x 16 x i1> [[A:%.*]], <vscale x 16 x i1> [[B:%.*]])
; CHECK-NEXT:    [[TMP2:%.*]] = call i1 @llvm.aarch64.sve.ptest.any.nxv16i1(<vscale x 16 x i1> [[PG]], <vscale x 16 x i1> [[TMP1]])
; CHECK-NEXT:    ret i1 [[TMP2]]
;
  %1 = tail call <vscale x 16 x i1> @llvm.aarch64.sve.nor.z.nxv16i1(<vscale x 16 x i1> %pg, <vscale x 16 x i1> %a, <vscale x 16 x i1> %b)
  %2 = call i1 @llvm.aarch64.sve.ptest.any.nxv16i1(<vscale x 16 x i1> %1, <vscale x 16 x i1> %1)
  ret i1 %2
}

define i1 @ptest_any_orn_z(<vscale x 16 x i1> %pg, <vscale x 16 x i1> %a, <vscale x 16 x i1> %b) {
; CHECK-LABEL: @ptest_any_orn_z(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call <vscale x 16 x i1> @llvm.aarch64.sve.orn.z.nxv16i1(<vscale x 16 x i1> [[PG:%.*]], <vscale x 16 x i1> [[A:%.*]], <vscale x 16 x i1> [[B:%.*]])
; CHECK-NEXT:    [[TMP2:%.*]] = call i1 @llvm.aarch64.sve.ptest.any.nxv16i1(<vscale x 16 x i1> [[PG]], <vscale x 16 x i1> [[TMP1]])
; CHECK-NEXT:    ret i1 [[TMP2]]
;
  %1 = tail call <vscale x 16 x i1> @llvm.aarch64.sve.orn.z.nxv16i1(<vscale x 16 x i1> %pg, <vscale x 16 x i1> %a, <vscale x 16 x i1> %b)
  %2 = call i1 @llvm.aarch64.sve.ptest.any.nxv16i1(<vscale x 16 x i1> %1, <vscale x 16 x i1> %1)
  ret i1 %2
}

define i1 @ptest_any_orr_z(<vscale x 16 x i1> %pg, <vscale x 16 x i1> %a, <vscale x 16 x i1> %b) {
; CHECK-LABEL: @ptest_any_orr_z(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call <vscale x 16 x i1> @llvm.aarch64.sve.orr.z.nxv16i1(<vscale x 16 x i1> [[PG:%.*]], <vscale x 16 x i1> [[A:%.*]], <vscale x 16 x i1> [[B:%.*]])
; CHECK-NEXT:    [[TMP2:%.*]] = call i1 @llvm.aarch64.sve.ptest.any.nxv16i1(<vscale x 16 x i1> [[PG]], <vscale x 16 x i1> [[TMP1]])
; CHECK-NEXT:    ret i1 [[TMP2]]
;
  %1 = tail call <vscale x 16 x i1> @llvm.aarch64.sve.orr.z.nxv16i1(<vscale x 16 x i1> %pg, <vscale x 16 x i1> %a, <vscale x 16 x i1> %b)
  %2 = call i1 @llvm.aarch64.sve.ptest.any.nxv16i1(<vscale x 16 x i1> %1, <vscale x 16 x i1> %1)
  ret i1 %2
}

declare <vscale x 16 x i1> @llvm.aarch64.sve.ptrue.nxv16i1(i32)
declare <vscale x 8 x i1> @llvm.aarch64.sve.ptrue.nxv8i1(i32)
declare <vscale x 4 x i1> @llvm.aarch64.sve.ptrue.nxv4i1(i32)
declare <vscale x 2 x i1> @llvm.aarch64.sve.ptrue.nxv2i1(i32)

declare i1 @llvm.aarch64.sve.ptest.any.nxv16i1(<vscale x 16 x i1>, <vscale x 16 x i1>)
declare i1 @llvm.aarch64.sve.ptest.first.nxv16i1(<vscale x 16 x i1>, <vscale x 16 x i1>)
declare i1 @llvm.aarch64.sve.ptest.last.nxv16i1(<vscale x 16 x i1>, <vscale x 16 x i1>)

declare <vscale x 16 x i1> @llvm.aarch64.sve.convert.to.svbool.nxv8i1(<vscale x 8 x i1>)
declare <vscale x 16 x i1> @llvm.aarch64.sve.convert.to.svbool.nxv4i1(<vscale x 4 x i1>)
declare <vscale x 16 x i1> @llvm.aarch64.sve.convert.to.svbool.nxv2i1(<vscale x 2 x i1>)

declare <vscale x 16 x i1> @llvm.aarch64.sve.brka.z.nxv16i1(<vscale x 16 x i1>, <vscale x 16 x i1>)
declare <vscale x 16 x i1> @llvm.aarch64.sve.brkb.z.nxv16i1(<vscale x 16 x i1>, <vscale x 16 x i1>)
declare <vscale x 16 x i1> @llvm.aarch64.sve.brkpa.z.nxv16i1(<vscale x 16 x i1>, <vscale x 16 x i1>, <vscale x 16 x i1>)
declare <vscale x 16 x i1> @llvm.aarch64.sve.brkpb.z.nxv16i1(<vscale x 16 x i1>, <vscale x 16 x i1>, <vscale x 16 x i1>)
declare <vscale x 16 x i1> @llvm.aarch64.sve.rdffr.z(<vscale x 16 x i1>)

declare <vscale x 16 x i1> @llvm.aarch64.sve.and.z.nxv16i1(<vscale x 16 x i1>, <vscale x 16 x i1>, <vscale x 16 x i1>)
declare <vscale x 16 x i1> @llvm.aarch64.sve.bic.z.nxv16i1(<vscale x 16 x i1>, <vscale x 16 x i1>, <vscale x 16 x i1>)
declare <vscale x 16 x i1> @llvm.aarch64.sve.eor.z.nxv16i1(<vscale x 16 x i1>, <vscale x 16 x i1>, <vscale x 16 x i1>)
declare <vscale x 16 x i1> @llvm.aarch64.sve.nand.z.nxv16i1(<vscale x 16 x i1>, <vscale x 16 x i1>, <vscale x 16 x i1>)
declare <vscale x 16 x i1> @llvm.aarch64.sve.nor.z.nxv16i1(<vscale x 16 x i1>, <vscale x 16 x i1>, <vscale x 16 x i1>)
declare <vscale x 16 x i1> @llvm.aarch64.sve.orn.z.nxv16i1(<vscale x 16 x i1>, <vscale x 16 x i1>, <vscale x 16 x i1>)
declare <vscale x 16 x i1> @llvm.aarch64.sve.orr.z.nxv16i1(<vscale x 16 x i1>, <vscale x 16 x i1>, <vscale x 16 x i1>)

attributes #0 = { "target-features"="+sve" }
