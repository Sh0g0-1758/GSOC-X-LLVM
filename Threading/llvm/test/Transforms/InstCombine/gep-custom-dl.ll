; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

target datalayout = "e-m:m-p:40:64:64:32-i32:32-i16:16-i8:8-n32"

%struct.B = type { double }
%struct.A = type { %struct.B, i32, i32 }
%struct.C = type { [7 x i8] }


@Global = external global [10 x i8]

; Test that two array indexing geps fold
define ptr @test1(ptr %I) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[B:%.*]] = getelementptr i8, ptr [[I:%.*]], i32 84
; CHECK-NEXT:    ret ptr [[B]]
;
  %A = getelementptr i32, ptr %I, i8 17
  %B = getelementptr i32, ptr %A, i16 4
  ret ptr %B
}

; Test that two getelementptr insts fold
define ptr @test2(ptr %I) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[A:%.*]] = getelementptr i8, ptr [[I:%.*]], i32 4
; CHECK-NEXT:    ret ptr [[A]]
;
  %A = getelementptr { i32 }, ptr %I, i32 1
  ret ptr %A
}

define void @test3(i8 %B) {
; This should be turned into a constexpr instead of being an instruction
; CHECK-LABEL: @test3(
; CHECK-NEXT:    store i8 [[B:%.*]], ptr getelementptr inbounds ([10 x i8], ptr @Global, i32 0, i32 4), align 1
; CHECK-NEXT:    ret void
;
  %A = getelementptr [10 x i8], ptr @Global, i32 0, i32 4
  store i8 %B, ptr %A
  ret void
}

%as1_ptr_struct = type { ptr addrspace(1) }
%as2_ptr_struct = type { ptr addrspace(2) }

@global_as2 = addrspace(2) global i32 zeroinitializer
@global_as1_as2_ptr = addrspace(1) global %as2_ptr_struct { ptr addrspace(2) @global_as2 }

; This should be turned into a constexpr instead of being an instruction
define void @test_evaluate_gep_nested_as_ptrs(ptr addrspace(2) %B) {
; CHECK-LABEL: @test_evaluate_gep_nested_as_ptrs(
; CHECK-NEXT:    store ptr addrspace(2) [[B:%.*]], ptr addrspace(1) @global_as1_as2_ptr, align 8
; CHECK-NEXT:    ret void
;
  store ptr addrspace(2) %B, ptr addrspace(1) @global_as1_as2_ptr
  ret void
}

@arst = addrspace(1) global [4 x ptr addrspace(2)] zeroinitializer

define void @test_evaluate_gep_as_ptrs_array(ptr addrspace(2) %B) {
; CHECK-LABEL: @test_evaluate_gep_as_ptrs_array(
; CHECK-NEXT:    store ptr addrspace(2) [[B:%.*]], ptr addrspace(1) getelementptr inbounds ([4 x ptr addrspace(2)], ptr addrspace(1) @arst, i32 0, i32 2), align 8
; CHECK-NEXT:    ret void
;

  %A = getelementptr [4 x ptr addrspace(2)], ptr addrspace(1) @arst, i16 0, i16 2
  store ptr addrspace(2) %B, ptr addrspace(1) %A
  ret void
}

define ptr @test4(ptr %I, i32 %C, i32 %D) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[A:%.*]] = getelementptr i32, ptr [[I:%.*]], i32 [[C:%.*]]
; CHECK-NEXT:    [[B:%.*]] = getelementptr i32, ptr [[A]], i32 [[D:%.*]]
; CHECK-NEXT:    ret ptr [[B]]
;
  %A = getelementptr i32, ptr %I, i32 %C
  %B = getelementptr i32, ptr %A, i32 %D
  ret ptr %B
}


define i1 @test5(ptr %x, ptr %y) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    [[TMP_4:%.*]] = icmp eq ptr [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[TMP_4]]
;
  %tmp.1 = getelementptr { i32, i32 }, ptr %x, i32 0, i32 1
  %tmp.3 = getelementptr { i32, i32 }, ptr %y, i32 0, i32 1
  ;; seteq x, y
  %tmp.4 = icmp eq ptr %tmp.1, %tmp.3
  ret i1 %tmp.4
}

%S = type { i32, [ 100 x i32] }

define <2 x i1> @test6(<2 x i32> %X, <2 x ptr> %P) nounwind {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    [[C:%.*]] = icmp eq <2 x i32> [[X:%.*]], <i32 -1, i32 -1>
; CHECK-NEXT:    ret <2 x i1> [[C]]
;
  %A = getelementptr inbounds %S, <2 x ptr> %P, <2 x i32> zeroinitializer, <2 x i32> <i32 1, i32 1>, <2 x i32> %X
  %B = getelementptr inbounds %S, <2 x ptr> %P, <2 x i32> <i32 0, i32 0>, <2 x i32> <i32 0, i32 0>
  %C = icmp eq <2 x ptr> %A, %B
  ret <2 x i1> %C
}

; Same as above, but indices scalarized.
define <2 x i1> @test6b(<2 x i32> %X, <2 x ptr> %P) nounwind {
; CHECK-LABEL: @test6b(
; CHECK-NEXT:    [[C:%.*]] = icmp eq <2 x i32> [[X:%.*]], <i32 -1, i32 -1>
; CHECK-NEXT:    ret <2 x i1> [[C]]
;
  %A = getelementptr inbounds %S, <2 x ptr> %P, i32 0, i32 1, <2 x i32> %X
  %B = getelementptr inbounds %S, <2 x ptr> %P, i32 0, i32 0
  %C = icmp eq <2 x ptr> %A, %B
  ret <2 x i1> %C
}

@G = external global [3 x i8]
define ptr @test7(i16 %Idx) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    [[ZE_IDX:%.*]] = zext i16 [[IDX:%.*]] to i32
; CHECK-NEXT:    [[TMP:%.*]] = getelementptr i8, ptr @G, i32 [[ZE_IDX]]
; CHECK-NEXT:    ret ptr [[TMP]]
;
  %ZE_Idx = zext i16 %Idx to i32
  %tmp = getelementptr i8, ptr @G, i32 %ZE_Idx
  ret ptr %tmp
}


; Test folding of constantexpr geps into normal geps.
@Array = external global [40 x i32]
define ptr @test8(i32 %X) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    [[A:%.*]] = getelementptr i32, ptr @Array, i32 [[X:%.*]]
; CHECK-NEXT:    ret ptr [[A]]
;
  %A = getelementptr i32, ptr @Array, i32 %X
  ret ptr %A
}

define ptr @test9(ptr %base, i8 %ind) {
; CHECK-LABEL: @test9(
; CHECK-NEXT:    [[TMP1:%.*]] = sext i8 [[IND:%.*]] to i32
; CHECK-NEXT:    [[RES:%.*]] = getelementptr i32, ptr [[BASE:%.*]], i32 [[TMP1]]
; CHECK-NEXT:    ret ptr [[RES]]
;
  %res = getelementptr i32, ptr %base, i8 %ind
  ret ptr %res
}

define i32 @test10() {
; CHECK-LABEL: @test10(
; CHECK-NEXT:    ret i32 8
;
  %A = getelementptr { i32, double }, ptr null, i32 0, i32 1
  %B = ptrtoint ptr %A to i32
  ret i32 %B
}

@X_as1 = addrspace(1) global [1000 x i8] zeroinitializer, align 16

define i16 @constant_fold_custom_dl() {
; CHECK-LABEL: @constant_fold_custom_dl(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret i16 ptrtoint (ptr addrspace(1) getelementptr (i8, ptr addrspace(1) getelementptr inbounds ([1000 x i8], ptr addrspace(1) @X_as1, i32 1, i32 0), i16 sub (i16 0, i16 ptrtoint (ptr addrspace(1) @X_as1 to i16))) to i16)
;

entry:
  %A = bitcast ptr addrspace(1) getelementptr inbounds ([1000 x i8], ptr addrspace(1) @X_as1, i64 1, i64 0) to ptr addrspace(1)

  %B2 = ptrtoint ptr addrspace(1) @X_as1 to i16
  %C = sub i16 0, %B2
  %D = getelementptr i8, ptr addrspace(1) %A, i16 %C
  %E = ptrtoint ptr addrspace(1) %D to i16

  ret i16 %E
}

