; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes=instsimplify < %s | FileCheck %s

target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"

%struct.A = type { [7 x i8] }

define ptr @test1(ptr %b, ptr %e) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[E_PTR:%.*]] = ptrtoint ptr [[E:%.*]] to i64
; CHECK-NEXT:    [[B_PTR:%.*]] = ptrtoint ptr [[B:%.*]] to i64
; CHECK-NEXT:    [[SUB:%.*]] = sub i64 [[E_PTR]], [[B_PTR]]
; CHECK-NEXT:    [[SDIV:%.*]] = sdiv exact i64 [[SUB]], 7
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds [[STRUCT_A:%.*]], ptr [[B]], i64 [[SDIV]]
; CHECK-NEXT:    ret ptr [[GEP]]
;
  %e_ptr = ptrtoint ptr %e to i64
  %b_ptr = ptrtoint ptr %b to i64
  %sub = sub i64 %e_ptr, %b_ptr
  %sdiv = sdiv exact i64 %sub, 7
  %gep = getelementptr inbounds %struct.A, ptr %b, i64 %sdiv
  ret ptr %gep
}

define ptr @test2(ptr %b, ptr %e) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[E_PTR:%.*]] = ptrtoint ptr [[E:%.*]] to i64
; CHECK-NEXT:    [[B_PTR:%.*]] = ptrtoint ptr [[B:%.*]] to i64
; CHECK-NEXT:    [[SUB:%.*]] = sub i64 [[E_PTR]], [[B_PTR]]
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds i8, ptr [[B]], i64 [[SUB]]
; CHECK-NEXT:    ret ptr [[GEP]]
;
  %e_ptr = ptrtoint ptr %e to i64
  %b_ptr = ptrtoint ptr %b to i64
  %sub = sub i64 %e_ptr, %b_ptr
  %gep = getelementptr inbounds i8, ptr %b, i64 %sub
  ret ptr %gep
}

define ptr @test3(ptr %b, ptr %e) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[E_PTR:%.*]] = ptrtoint ptr [[E:%.*]] to i64
; CHECK-NEXT:    [[B_PTR:%.*]] = ptrtoint ptr [[B:%.*]] to i64
; CHECK-NEXT:    [[SUB:%.*]] = sub i64 [[E_PTR]], [[B_PTR]]
; CHECK-NEXT:    [[ASHR:%.*]] = ashr exact i64 [[SUB]], 3
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds i64, ptr [[B]], i64 [[ASHR]]
; CHECK-NEXT:    ret ptr [[GEP]]
;
  %e_ptr = ptrtoint ptr %e to i64
  %b_ptr = ptrtoint ptr %b to i64
  %sub = sub i64 %e_ptr, %b_ptr
  %ashr = ashr exact i64 %sub, 3
  %gep = getelementptr inbounds i64, ptr %b, i64 %ashr
  ret ptr %gep
}

; The following tests should not be folded to null, because this would
; lose provenance of the base pointer %b.

define ptr @test4(ptr %b) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[B_PTR:%.*]] = ptrtoint ptr [[B:%.*]] to i64
; CHECK-NEXT:    [[SUB:%.*]] = sub i64 0, [[B_PTR]]
; CHECK-NEXT:    [[SDIV:%.*]] = sdiv exact i64 [[SUB]], 7
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr [[STRUCT_A:%.*]], ptr [[B]], i64 [[SDIV]]
; CHECK-NEXT:    ret ptr [[GEP]]
;
  %b_ptr = ptrtoint ptr %b to i64
  %sub = sub i64 0, %b_ptr
  %sdiv = sdiv exact i64 %sub, 7
  %gep = getelementptr %struct.A, ptr %b, i64 %sdiv
  ret ptr %gep
}

define ptr @test4_inbounds(ptr %b) {
; CHECK-LABEL: @test4_inbounds(
; CHECK-NEXT:    [[B_PTR:%.*]] = ptrtoint ptr [[B:%.*]] to i64
; CHECK-NEXT:    [[SUB:%.*]] = sub i64 0, [[B_PTR]]
; CHECK-NEXT:    [[SDIV:%.*]] = sdiv exact i64 [[SUB]], 7
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds [[STRUCT_A:%.*]], ptr [[B]], i64 [[SDIV]]
; CHECK-NEXT:    ret ptr [[GEP]]
;
  %b_ptr = ptrtoint ptr %b to i64
  %sub = sub i64 0, %b_ptr
  %sdiv = sdiv exact i64 %sub, 7
  %gep = getelementptr inbounds %struct.A, ptr %b, i64 %sdiv
  ret ptr %gep
}

define ptr @test5(ptr %b) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    [[B_PTR:%.*]] = ptrtoint ptr [[B:%.*]] to i64
; CHECK-NEXT:    [[SUB:%.*]] = sub i64 0, [[B_PTR]]
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr i8, ptr [[B]], i64 [[SUB]]
; CHECK-NEXT:    ret ptr [[GEP]]
;
  %b_ptr = ptrtoint ptr %b to i64
  %sub = sub i64 0, %b_ptr
  %gep = getelementptr i8, ptr %b, i64 %sub
  ret ptr %gep
}

define ptr @test5_inbounds(ptr %b) {
; CHECK-LABEL: @test5_inbounds(
; CHECK-NEXT:    [[B_PTR:%.*]] = ptrtoint ptr [[B:%.*]] to i64
; CHECK-NEXT:    [[SUB:%.*]] = sub i64 0, [[B_PTR]]
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds i8, ptr [[B]], i64 [[SUB]]
; CHECK-NEXT:    ret ptr [[GEP]]
;
  %b_ptr = ptrtoint ptr %b to i64
  %sub = sub i64 0, %b_ptr
  %gep = getelementptr inbounds i8, ptr %b, i64 %sub
  ret ptr %gep
}

define ptr @test6(ptr %b) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    [[B_PTR:%.*]] = ptrtoint ptr [[B:%.*]] to i64
; CHECK-NEXT:    [[SUB:%.*]] = sub i64 0, [[B_PTR]]
; CHECK-NEXT:    [[ASHR:%.*]] = ashr exact i64 [[SUB]], 3
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr i64, ptr [[B]], i64 [[ASHR]]
; CHECK-NEXT:    ret ptr [[GEP]]
;
  %b_ptr = ptrtoint ptr %b to i64
  %sub = sub i64 0, %b_ptr
  %ashr = ashr exact i64 %sub, 3
  %gep = getelementptr i64, ptr %b, i64 %ashr
  ret ptr %gep
}

define ptr @test6_inbounds(ptr %b) {
; CHECK-LABEL: @test6_inbounds(
; CHECK-NEXT:    [[B_PTR:%.*]] = ptrtoint ptr [[B:%.*]] to i64
; CHECK-NEXT:    [[SUB:%.*]] = sub i64 0, [[B_PTR]]
; CHECK-NEXT:    [[ASHR:%.*]] = ashr exact i64 [[SUB]], 3
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds i64, ptr [[B]], i64 [[ASHR]]
; CHECK-NEXT:    ret ptr [[GEP]]
;
  %b_ptr = ptrtoint ptr %b to i64
  %sub = sub i64 0, %b_ptr
  %ashr = ashr exact i64 %sub, 3
  %gep = getelementptr inbounds i64, ptr %b, i64 %ashr
  ret ptr %gep
}

define ptr @test7(ptr %b, ptr %e) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    [[E_PTR:%.*]] = ptrtoint ptr [[E:%.*]] to i64
; CHECK-NEXT:    [[B_PTR:%.*]] = ptrtoint ptr [[B:%.*]] to i64
; CHECK-NEXT:    [[SUB:%.*]] = sub i64 [[E_PTR]], [[B_PTR]]
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds i8, ptr [[B]], i64 [[SUB]]
; CHECK-NEXT:    ret ptr [[GEP]]
;
  %e_ptr = ptrtoint ptr %e to i64
  %b_ptr = ptrtoint ptr %b to i64
  %sub = sub i64 %e_ptr, %b_ptr
  %gep = getelementptr inbounds i8, ptr %b, i64 %sub
  ret ptr %gep
}

define ptr @undef_inbounds_var_idx(i64 %idx) {
; CHECK-LABEL: @undef_inbounds_var_idx(
; CHECK-NEXT:    ret ptr undef
;
  %el = getelementptr inbounds i64, ptr undef, i64 %idx
  ret ptr %el
}

define ptr @undef_no_inbounds_var_idx(i64 %idx) {
; CHECK-LABEL: @undef_no_inbounds_var_idx(
; CHECK-NEXT:    ret ptr undef
;
  %el = getelementptr i64, ptr undef, i64 %idx
  ret ptr %el
}

define <8 x ptr> @undef_vec1() {
; CHECK-LABEL: @undef_vec1(
; CHECK-NEXT:    ret <8 x ptr> undef
;
  %el = getelementptr inbounds i64, ptr undef, <8 x i64> undef
  ret <8 x ptr> %el
}

define <8 x ptr> @undef_vec2() {
; CHECK-LABEL: @undef_vec2(
; CHECK-NEXT:    ret <8 x ptr> undef
;
  %el = getelementptr i64, <8 x ptr> undef, <8 x i64> undef
  ret <8 x ptr> %el
}

; Check ConstantExpr::getGetElementPtr() using ElementCount for size queries - begin.

; Constant ptr

define ptr @ptr_idx_scalar() {
; CHECK-LABEL: @ptr_idx_scalar(
; CHECK-NEXT:    ret ptr inttoptr (i64 4 to ptr)
;
  %gep = getelementptr <4 x i32>, ptr null, i64 0, i64 1
  ret ptr %gep
}

define <2 x ptr> @ptr_idx_vector() {
; CHECK-LABEL: @ptr_idx_vector(
; CHECK-NEXT:    ret <2 x ptr> getelementptr (i32, ptr null, <2 x i64> <i64 1, i64 1>)
;
  %gep = getelementptr i32, ptr null, <2 x i64> <i64 1, i64 1>
  ret <2 x ptr> %gep
}

define <4 x ptr> @ptr_idx_mix_scalar_vector(){
; CHECK-LABEL: @ptr_idx_mix_scalar_vector(
; CHECK-NEXT:    ret <4 x ptr> getelementptr ([42 x [3 x i32]], ptr null, <4 x i64> zeroinitializer, <4 x i64> <i64 0, i64 1, i64 2, i64 3>, <4 x i64> zeroinitializer)
;
  %gep = getelementptr [42 x [3 x i32]], ptr null, i64 0, <4 x i64> <i64 0, i64 1, i64 2, i64 3>, i64 0
  ret <4 x ptr> %gep
}

; Constant vector

define <4 x ptr> @vector_idx_scalar() {
; CHECK-LABEL: @vector_idx_scalar(
; CHECK-NEXT:    ret <4 x ptr> getelementptr (i32, <4 x ptr> zeroinitializer, <4 x i64> <i64 1, i64 1, i64 1, i64 1>)
;
  %gep = getelementptr i32, <4 x ptr> zeroinitializer, i64 1
  ret <4 x ptr> %gep
}

define <4 x ptr> @vector_idx_vector() {
; CHECK-LABEL: @vector_idx_vector(
; CHECK-NEXT:    ret <4 x ptr> getelementptr (i32, <4 x ptr> zeroinitializer, <4 x i64> <i64 1, i64 1, i64 1, i64 1>)
;
  %gep = getelementptr i32, <4 x ptr> zeroinitializer, <4 x i64> <i64 1, i64 1, i64 1, i64 1>
  ret <4 x ptr> %gep
}

%struct = type { double, float }
define <4 x ptr> @vector_idx_mix_scalar_vector() {
; CHECK-LABEL: @vector_idx_mix_scalar_vector(
; CHECK-NEXT:    ret <4 x ptr> getelementptr ([[STRUCT:%.*]], <4 x ptr> zeroinitializer, <4 x i64> zeroinitializer, i32 1)
;
  %gep = getelementptr %struct, <4 x ptr> zeroinitializer, i32 0, <4 x i32> <i32 1, i32 1, i32 1, i32 1>
  ret <4 x ptr> %gep
}

; Constant scalable

define <vscale x 4 x ptr> @scalable_idx_scalar() {
; CHECK-LABEL: @scalable_idx_scalar(
; CHECK-NEXT:    ret <vscale x 4 x ptr> getelementptr (i32, <vscale x 4 x ptr> zeroinitializer, <vscale x 4 x i64> shufflevector (<vscale x 4 x i64> insertelement (<vscale x 4 x i64> poison, i64 1, i64 0), <vscale x 4 x i64> poison, <vscale x 4 x i32> zeroinitializer))
;
  %gep = getelementptr i32, <vscale x 4 x ptr> zeroinitializer, i64 1
  ret <vscale x 4 x ptr> %gep
}

define <vscale x 4 x ptr> @scalable_vector_idx_mix_scalar_vector() {
; CHECK-LABEL: @scalable_vector_idx_mix_scalar_vector(
; CHECK-NEXT:    ret <vscale x 4 x ptr> getelementptr ([[STRUCT:%.*]], <vscale x 4 x ptr> zeroinitializer, <vscale x 4 x i64> zeroinitializer, i32 1)
;
  %gep = getelementptr %struct, <vscale x 4 x ptr> zeroinitializer, i32 0, i32 1
  ret <vscale x 4 x ptr> %gep
}

define <vscale x 2 x ptr> @ptr_idx_mix_scalar_scalable_vector() {
; CHECK-LABEL: @ptr_idx_mix_scalar_scalable_vector(
; CHECK-NEXT:    ret <vscale x 2 x ptr> zeroinitializer
;
  %v = getelementptr [2 x i64], ptr null, i64 0, <vscale x 2 x i64> zeroinitializer
  ret <vscale x 2 x ptr> %v
}

; Check ConstantExpr::getGetElementPtr() using ElementCount for size queries - end.

define ptr @poison() {
; CHECK-LABEL: @poison(
; CHECK-NEXT:    ret ptr poison
;
  %v = getelementptr i8, ptr poison, i64 1
  ret ptr %v
}

define ptr @poison2(ptr %baseptr) {
; CHECK-LABEL: @poison2(
; CHECK-NEXT:    ret ptr poison
;
  %v = getelementptr i8, ptr %baseptr, i64 poison
  ret ptr %v
}

define ptr @D98611_1(ptr %c1, i64 %offset) {
; CHECK-LABEL: @D98611_1(
; CHECK-NEXT:    [[C2:%.*]] = getelementptr inbounds i8, ptr [[C1:%.*]], i64 [[OFFSET:%.*]]
; CHECK-NEXT:    ret ptr [[C2]]
;
  %c2 = getelementptr inbounds i8, ptr %c1, i64 %offset
  %ptrtoint1 = ptrtoint ptr %c1 to i64
  %ptrtoint2 = ptrtoint ptr %c2 to i64
  %sub = sub i64 %ptrtoint2, %ptrtoint1
  %gep = getelementptr inbounds i8, ptr %c1, i64 %sub
  ret ptr %gep
}

define ptr @D98611_2(ptr %c1, i64 %offset) {
; CHECK-LABEL: @D98611_2(
; CHECK-NEXT:    [[C2:%.*]] = getelementptr inbounds [[STRUCT_A:%.*]], ptr [[C1:%.*]], i64 [[OFFSET:%.*]]
; CHECK-NEXT:    ret ptr [[C2]]
;
  %c2 = getelementptr inbounds %struct.A, ptr %c1, i64 %offset
  %ptrtoint1 = ptrtoint ptr %c1 to i64
  %ptrtoint2 = ptrtoint ptr %c2 to i64
  %sub = sub i64 %ptrtoint2, %ptrtoint1
  %sdiv = sdiv exact i64 %sub, 7
  %gep = getelementptr inbounds %struct.A, ptr %c1, i64 %sdiv
  ret ptr %gep
}

define ptr @D98611_3(ptr %c1, i64 %offset) {
; CHECK-LABEL: @D98611_3(
; CHECK-NEXT:    [[C2:%.*]] = getelementptr inbounds i32, ptr [[C1:%.*]], i64 [[OFFSET:%.*]]
; CHECK-NEXT:    ret ptr [[C2]]
;
  %c2 = getelementptr inbounds i32, ptr %c1, i64 %offset
  %ptrtoint1 = ptrtoint ptr %c1 to i64
  %ptrtoint2 = ptrtoint ptr %c2 to i64
  %sub = sub i64 %ptrtoint2, %ptrtoint1
  %ashr = ashr exact i64 %sub, 2
  %gep = getelementptr inbounds i32, ptr %c1, i64 %ashr
  ret ptr %gep
}

define <8 x ptr> @gep_vector_index_op2_poison(ptr %ptr) {
; CHECK-LABEL: @gep_vector_index_op2_poison(
; CHECK-NEXT:    ret <8 x ptr> poison
;
  %res = getelementptr inbounds [144 x i32], ptr %ptr, i64 0, <8 x i64> poison
  ret <8 x ptr> %res
}

%t.1 = type { i32, [144 x i32] }

define <8 x ptr> @gep_vector_index_op3_poison(ptr %ptr) {
; CHECK-LABEL: @gep_vector_index_op3_poison(
; CHECK-NEXT:    ret <8 x ptr> poison
;
  %res = getelementptr inbounds %t.1, ptr %ptr, i64 0, i32 1, <8 x i64> poison
  ret <8 x ptr> %res
}

%t.2 = type { i32, i32 }
%t.3 = type { i32, [144 x %t.2 ] }

define <8 x ptr> @gep_vector_index_op3_poison_constant_index_afterwards(ptr %ptr) {
; CHECK-LABEL: @gep_vector_index_op3_poison_constant_index_afterwards(
; CHECK-NEXT:    ret <8 x ptr> poison
;
  %res = getelementptr inbounds %t.3, ptr %ptr, i64 0, i32 1, <8 x i64> poison, i32 1
  ret <8 x ptr> %res
}

define i64 @gep_array_of_scalable_vectors_ptrdiff(ptr %ptr) {
  %c1 = getelementptr inbounds [8 x <vscale x 4 x i32>], ptr %ptr, i64 4
  %c2 = getelementptr inbounds [8 x <vscale x 4 x i32>], ptr %ptr, i64 6
  %c1.int = ptrtoint ptr %c1 to i64
  %c2.int = ptrtoint ptr %c2 to i64
  %diff = sub i64 %c2.int, %c1.int
  ret i64 %diff
}
