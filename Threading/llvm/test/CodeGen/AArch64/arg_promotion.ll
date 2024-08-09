; NOTE: Assertions have been autogenerated by utils/update_test_checks.py

; RUN: opt -S -passes=argpromotion -mtriple=aarch64-unknwon-linux-gnu < %s | FileCheck %s

target triple = "aarch64-unknown-linux-gnu"

; Don't promote a vector pointer argument when the pointee type size is greater
; than 128 bits.

define dso_local void @caller_8xi32(ptr noalias %src, ptr noalias %dst) #0 {
; CHECK-LABEL: define dso_local void @caller_8xi32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call fastcc void @callee_8xi32(ptr noalias [[SRC:%.*]], ptr noalias [[DST:%.*]])
; CHECK-NEXT:    ret void
;
entry:
  call fastcc void @callee_8xi32(ptr noalias %src, ptr noalias %dst)
  ret void
}

define internal fastcc void @callee_8xi32(ptr noalias %src, ptr noalias %dst) #0 {
; CHECK-LABEL: define internal fastcc void @callee_8xi32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <8 x i32>, ptr [[SRC:%.*]], align 16
; CHECK-NEXT:    store <8 x i32> [[TMP0]], ptr [[DST:%.*]], align 16
; CHECK-NEXT:    ret void
;
entry:
  %0 = load <8 x i32>, ptr %src, align 16
  store <8 x i32> %0, ptr %dst, align 16
  ret void
}

; Promote a vector pointer argument when the pointee type size is 128 bits or
; less.

define dso_local void @caller_4xi32(ptr noalias %src, ptr noalias %dst) #1 {
; CHECK-LABEL: define dso_local void @caller_4xi32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SRC_VAL:%.*]] = load <4 x i32>, ptr [[SRC:%.*]], align 16
; CHECK-NEXT:    call fastcc void @callee_4xi32(<4 x i32> [[SRC_VAL]], ptr noalias [[DST:%.*]])
; CHECK-NEXT:    ret void
;
entry:
  call fastcc void @callee_4xi32(ptr noalias %src, ptr noalias %dst)
  ret void
}

define internal fastcc void @callee_4xi32(ptr noalias %src, ptr noalias %dst) #1 {
; CHECK-LABEL: define internal fastcc void @callee_4xi32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store <4 x i32> [[SRC_0_VAL:%.*]], ptr [[DST:%.*]], align 16
; CHECK-NEXT:    ret void
;
entry:
  %0 = load <4 x i32>, ptr %src, align 16
  store <4 x i32> %0, ptr %dst, align 16
  ret void
}

; A scalar pointer argument is promoted even when the pointee type size is
; greater than 128 bits.

define dso_local void @caller_i256(ptr noalias %src, ptr noalias %dst) #0 {
; CHECK-LABEL: define dso_local void @caller_i256(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SRC_VAL:%.*]] = load i256, ptr [[SRC:%.*]], align 16
; CHECK-NEXT:    call fastcc void @callee_i256(i256 [[SRC_VAL]], ptr noalias [[DST:%.*]])
; CHECK-NEXT:    ret void
;
entry:
  call fastcc void @callee_i256(ptr noalias %src, ptr noalias %dst)
  ret void
}

define internal fastcc void @callee_i256(ptr noalias %src, ptr noalias %dst) #0 {
; CHECK-LABEL: define internal fastcc void @callee_i256(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i256 [[SRC_0_VAL:%.*]], ptr [[DST:%.*]], align 16
; CHECK-NEXT:    ret void
;
entry:
  %0 = load i256, ptr %src, align 16
  store i256 %0, ptr %dst, align 16
  ret void
}

; A scalable vector pointer argument is not a target of ArgumentPromotionPass.

define dso_local void @caller_nx4xi32(ptr noalias %src, ptr noalias %dst) #2 {
; CHECK-LABEL: define dso_local void @caller_nx4xi32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call fastcc void @callee_nx4xi32(ptr noalias [[SRC:%.*]], ptr noalias [[DST:%.*]])
; CHECK-NEXT:    ret void
;
entry:
  call fastcc void @callee_nx4xi32(ptr noalias %src, ptr noalias %dst)
  ret void
}

define internal fastcc void @callee_nx4xi32(ptr noalias %src, ptr noalias %dst) #2 {
; CHECK-LABEL: define internal fastcc void @callee_nx4xi32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <vscale x 4 x i32>, ptr [[SRC:%.*]], align 16
; CHECK-NEXT:    store <vscale x 4 x i32> [[TMP0]], ptr [[DST:%.*]], align 16
; CHECK-NEXT:    ret void
;
entry:
  %0 = load <vscale x 4 x i32>, ptr %src, align 16
  store <vscale x 4 x i32> %0, ptr %dst, align 16
  ret void
}

; Don't promote a structure pointer argument when the pointee vector member
; type size is greater than 128 bits.

%struct_8xi32 = type { <8 x i32>, <8 x i32> }

define dso_local void @caller_struct8xi32(ptr noalias %src, ptr noalias %dst) #0 {
; CHECK-LABEL: define dso_local void @caller_struct8xi32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call fastcc void @callee_struct8xi32(ptr noalias [[SRC:%.*]], ptr noalias [[DST:%.*]])
; CHECK-NEXT:    ret void
;
entry:
  call fastcc void @callee_struct8xi32(ptr noalias %src, ptr noalias %dst)
  ret void
}

define internal fastcc void @callee_struct8xi32(ptr noalias %src, ptr noalias %dst) #0 {
; CHECK-LABEL: define internal fastcc void @callee_struct8xi32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <8 x i32>, ptr [[SRC:%.*]], align 16
; CHECK-NEXT:    store <8 x i32> [[TMP0]], ptr [[DST:%.*]], align 16
; CHECK-NEXT:    [[SRC2:%.*]] = getelementptr inbounds [[STRUCT_8XI32:%.*]], ptr [[SRC]], i64 0, i32 1
; CHECK-NEXT:    [[TMP1:%.*]] = load <8 x i32>, ptr [[SRC2]], align 16
; CHECK-NEXT:    [[DST2:%.*]] = getelementptr inbounds [[STRUCT_8XI32]], ptr [[DST]], i64 0, i32 1
; CHECK-NEXT:    store <8 x i32> [[TMP1]], ptr [[DST2]], align 16
; CHECK-NEXT:    ret void
;
entry:
  %0 = load <8 x i32>, ptr %src, align 16
  store <8 x i32> %0, ptr %dst, align 16
  %src2 = getelementptr inbounds %struct_8xi32, ptr %src, i64 0, i32 1
  %1 = load <8 x i32>, ptr %src2, align 16
  %dst2 = getelementptr inbounds %struct_8xi32, ptr %dst, i64 0, i32 1
  store <8 x i32> %1, ptr %dst2, align 16
  ret void
}

; Promote a structure pointer argument when the pointee vector member type size
; is 128 bits or less.

%struct_4xi32 = type { <4 x i32>, <4 x i32> }

define dso_local void @caller_struct4xi32(ptr noalias %src, ptr noalias %dst) #1 {
; CHECK-LABEL: define dso_local void @caller_struct4xi32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SRC_VAL:%.*]] = load <4 x i32>, ptr [[SRC:%.*]], align 16
; CHECK-NEXT:    [[TMP0:%.*]] = getelementptr i8, ptr [[SRC]], i64 16
; CHECK-NEXT:    [[SRC_VAL1:%.*]] = load <4 x i32>, ptr [[TMP0]], align 16
; CHECK-NEXT:    call fastcc void @callee_struct4xi32(<4 x i32> [[SRC_VAL]], <4 x i32> [[SRC_VAL1]], ptr noalias [[DST:%.*]])
; CHECK-NEXT:    ret void
;
entry:
  call fastcc void @callee_struct4xi32(ptr noalias %src, ptr noalias %dst)
  ret void
}

define internal fastcc void @callee_struct4xi32(ptr noalias %src, ptr noalias %dst) #1 {
; CHECK-LABEL: define internal fastcc void @callee_struct4xi32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store <4 x i32> [[SRC_0_VAL:%.*]], ptr [[DST:%.*]], align 16
; CHECK-NEXT:    [[DST2:%.*]] = getelementptr inbounds [[STRUCT_4XI32:%.*]], ptr [[DST]], i64 0, i32 1
; CHECK-NEXT:    store <4 x i32> [[SRC_16_VAL:%.*]], ptr [[DST2]], align 16
; CHECK-NEXT:    ret void
;
entry:
  %0 = load <4 x i32>, ptr %src, align 16
  store <4 x i32> %0, ptr %dst, align 16
  %src2 = getelementptr inbounds %struct_4xi32, ptr %src, i64 0, i32 1
  %1 = load <4 x i32>, ptr %src2, align 16
  %dst2 = getelementptr inbounds %struct_4xi32, ptr %dst, i64 0, i32 1
  store <4 x i32> %1, ptr %dst2, align 16
  ret void
}

attributes #0 = { noinline vscale_range(2,2) "target-features"="+v8.2a,+neon,+sve" }
attributes #1 = { noinline vscale_range(1,1) "target-features"="+v8.2a,+neon,+sve" }
attributes #2 = { noinline "target-features"="+v8.2a,+neon,+sve" }