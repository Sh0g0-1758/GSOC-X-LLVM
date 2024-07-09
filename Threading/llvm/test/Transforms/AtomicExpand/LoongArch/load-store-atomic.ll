; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S --mtriple=loongarch32 --passes=atomic-expand %s | FileCheck %s --check-prefix=LA32
; RUN: opt -S --mtriple=loongarch64 --passes=atomic-expand %s | FileCheck %s --check-prefix=LA64

define i8 @load_acquire_i8(ptr %ptr) {
; LA32-LABEL: @load_acquire_i8(
; LA32-NEXT:    [[VAL:%.*]] = load atomic i8, ptr [[PTR:%.*]] monotonic, align 1
; LA32-NEXT:    fence acquire
; LA32-NEXT:    ret i8 [[VAL]]
;
; LA64-LABEL: @load_acquire_i8(
; LA64-NEXT:    [[VAL:%.*]] = load atomic i8, ptr [[PTR:%.*]] monotonic, align 1
; LA64-NEXT:    fence acquire
; LA64-NEXT:    ret i8 [[VAL]]
;
  %val = load atomic i8, ptr %ptr acquire, align 1
  ret i8 %val
}

define i16 @load_acquire_i16(ptr %ptr) {
; LA32-LABEL: @load_acquire_i16(
; LA32-NEXT:    [[VAL:%.*]] = load atomic i16, ptr [[PTR:%.*]] monotonic, align 2
; LA32-NEXT:    fence acquire
; LA32-NEXT:    ret i16 [[VAL]]
;
; LA64-LABEL: @load_acquire_i16(
; LA64-NEXT:    [[VAL:%.*]] = load atomic i16, ptr [[PTR:%.*]] monotonic, align 2
; LA64-NEXT:    fence acquire
; LA64-NEXT:    ret i16 [[VAL]]
;
  %val = load atomic i16, ptr %ptr acquire, align 2
  ret i16 %val
}

define i32 @load_acquire_i32(ptr %ptr) {
; LA32-LABEL: @load_acquire_i32(
; LA32-NEXT:    [[VAL:%.*]] = load atomic i32, ptr [[PTR:%.*]] monotonic, align 4
; LA32-NEXT:    fence acquire
; LA32-NEXT:    ret i32 [[VAL]]
;
; LA64-LABEL: @load_acquire_i32(
; LA64-NEXT:    [[VAL:%.*]] = load atomic i32, ptr [[PTR:%.*]] monotonic, align 4
; LA64-NEXT:    fence acquire
; LA64-NEXT:    ret i32 [[VAL]]
;
  %val = load atomic i32, ptr %ptr acquire, align 4
  ret i32 %val
}

define i64 @load_acquire_i64(ptr %ptr) {
; LA32-LABEL: @load_acquire_i64(
; LA32-NEXT:    [[TMP1:%.*]] = call i64 @__atomic_load_8(ptr [[PTR:%.*]], i32 2)
; LA32-NEXT:    ret i64 [[TMP1]]
;
; LA64-LABEL: @load_acquire_i64(
; LA64-NEXT:    [[VAL:%.*]] = load atomic i64, ptr [[PTR:%.*]] monotonic, align 8
; LA64-NEXT:    fence acquire
; LA64-NEXT:    ret i64 [[VAL]]
;
  %val = load atomic i64, ptr %ptr acquire, align 8
  ret i64 %val
}

define void @store_release_i8(ptr %ptr, i8 signext %v) {
; LA32-LABEL: @store_release_i8(
; LA32-NEXT:    fence release
; LA32-NEXT:    store atomic i8 [[V:%.*]], ptr [[PTR:%.*]] monotonic, align 1
; LA32-NEXT:    ret void
;
; LA64-LABEL: @store_release_i8(
; LA64-NEXT:    fence release
; LA64-NEXT:    store atomic i8 [[V:%.*]], ptr [[PTR:%.*]] monotonic, align 1
; LA64-NEXT:    ret void
;
  store atomic i8 %v, ptr %ptr release, align 1
  ret void
}

define void @store_release_i16(ptr %ptr, i16 signext %v) {
; LA32-LABEL: @store_release_i16(
; LA32-NEXT:    fence release
; LA32-NEXT:    store atomic i16 [[V:%.*]], ptr [[PTR:%.*]] monotonic, align 2
; LA32-NEXT:    ret void
;
; LA64-LABEL: @store_release_i16(
; LA64-NEXT:    fence release
; LA64-NEXT:    store atomic i16 [[V:%.*]], ptr [[PTR:%.*]] monotonic, align 2
; LA64-NEXT:    ret void
;
  store atomic i16 %v, ptr %ptr release, align 2
  ret void
}

define void @store_release_i32(ptr %ptr, i32 signext %v) {
; LA32-LABEL: @store_release_i32(
; LA32-NEXT:    fence release
; LA32-NEXT:    store atomic i32 [[V:%.*]], ptr [[PTR:%.*]] monotonic, align 4
; LA32-NEXT:    ret void
;
; LA64-LABEL: @store_release_i32(
; LA64-NEXT:    store atomic i32 [[V:%.*]], ptr [[PTR:%.*]] release, align 4
; LA64-NEXT:    ret void
;
  store atomic i32 %v, ptr %ptr release, align 4
  ret void
}

define void @store_release_i64(ptr %ptr, i64 %v) {
; LA32-LABEL: @store_release_i64(
; LA32-NEXT:    call void @__atomic_store_8(ptr [[PTR:%.*]], i64 [[V:%.*]], i32 3)
; LA32-NEXT:    ret void
;
; LA64-LABEL: @store_release_i64(
; LA64-NEXT:    store atomic i64 [[V:%.*]], ptr [[PTR:%.*]] release, align 8
; LA64-NEXT:    ret void
;
  store atomic i64 %v, ptr %ptr release, align 8
  ret void
}
