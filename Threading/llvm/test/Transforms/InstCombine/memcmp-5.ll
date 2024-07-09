; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s
;
; Exercise folding of memcmp calls with constant arrays and nonconstant
; sizes.

declare i32 @memcmp(ptr, ptr, i64)

@ax = external constant [8 x i8]
@a01230123 = constant [8 x i8] c"01230123"
@b01230123 = constant [8 x i8] c"01230123"
@c01230129 = constant [8 x i8] c"01230129"
@d9123012  = constant [7 x i8] c"9123012"


; Exercise memcmp(A, B, N) folding of arrays with the same bytes.

define void @fold_memcmp_a_b_n(ptr %pcmp, i64 %n) {
; CHECK-LABEL: @fold_memcmp_a_b_n(
; CHECK-NEXT:    store i32 0, ptr [[PCMP:%.*]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ne i64 [[N:%.*]], 0
; CHECK-NEXT:    [[C0_1:%.*]] = sext i1 [[TMP1]] to i32
; CHECK-NEXT:    [[S0_1:%.*]] = getelementptr i8, ptr [[PCMP]], i64 4
; CHECK-NEXT:    store i32 [[C0_1]], ptr [[S0_1]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ne i64 [[N]], 0
; CHECK-NEXT:    [[C0_2:%.*]] = sext i1 [[TMP2]] to i32
; CHECK-NEXT:    [[S0_2:%.*]] = getelementptr i8, ptr [[PCMP]], i64 8
; CHECK-NEXT:    store i32 [[C0_2]], ptr [[S0_2]], align 4
; CHECK-NEXT:    [[TMP3:%.*]] = icmp ne i64 [[N]], 0
; CHECK-NEXT:    [[C0_3:%.*]] = sext i1 [[TMP3]] to i32
; CHECK-NEXT:    [[S0_3:%.*]] = getelementptr i8, ptr [[PCMP]], i64 12
; CHECK-NEXT:    store i32 [[C0_3]], ptr [[S0_3]], align 4
; CHECK-NEXT:    [[S0_4:%.*]] = getelementptr i8, ptr [[PCMP]], i64 16
; CHECK-NEXT:    store i32 0, ptr [[S0_4]], align 4
; CHECK-NEXT:    [[TMP4:%.*]] = icmp ne i64 [[N]], 0
; CHECK-NEXT:    [[C0_5:%.*]] = sext i1 [[TMP4]] to i32
; CHECK-NEXT:    [[S0_5:%.*]] = getelementptr i8, ptr [[PCMP]], i64 20
; CHECK-NEXT:    store i32 [[C0_5]], ptr [[S0_5]], align 4
; CHECK-NEXT:    ret void
;


  %q1 = getelementptr [8 x i8], ptr @b01230123, i64 0, i64 1
  %q2 = getelementptr [8 x i8], ptr @b01230123, i64 0, i64 2
  %q3 = getelementptr [8 x i8], ptr @b01230123, i64 0, i64 3
  %q4 = getelementptr [8 x i8], ptr @b01230123, i64 0, i64 4
  %q5 = getelementptr [8 x i8], ptr @b01230123, i64 0, i64 5

  ; Fold memcmp(a, b, n) to 0.
  %c0_0 = call i32 @memcmp(ptr @a01230123, ptr @b01230123, i64 %n)
  store i32 %c0_0, ptr %pcmp

  ; Fold memcmp(a, b + 1, n) to N != 0 ? -1 : 0.
  %c0_1 = call i32 @memcmp(ptr @a01230123, ptr %q1, i64 %n)
  %s0_1 = getelementptr i32, ptr %pcmp, i64 1
  store i32 %c0_1, ptr %s0_1

  ; Fold memcmp(a, b + 2, n) to N != 0 ? -1 : 0.
  %c0_2 = call i32 @memcmp(ptr @a01230123, ptr %q2, i64 %n)
  %s0_2 = getelementptr i32, ptr %pcmp, i64 2
  store i32 %c0_2, ptr %s0_2

  ; Fold memcmp(a, b + 3, n) to N != 0 ? -1 : 0.
  %c0_3 = call i32 @memcmp(ptr @a01230123, ptr %q3, i64 %n)
  %s0_3 = getelementptr i32, ptr %pcmp, i64 3
  store i32 %c0_3, ptr %s0_3

  ; Fold memcmp(a, b + 4, n) to 0.
  %c0_4 = call i32 @memcmp(ptr @a01230123, ptr %q4, i64 %n)
  %s0_4 = getelementptr i32, ptr %pcmp, i64 4
  store i32 %c0_4, ptr %s0_4

  ; Fold memcmp(a, b + 5, n) to N != 0 ? -1 : 0.
  %c0_5 = call i32 @memcmp(ptr @a01230123, ptr %q5, i64 %n)
  %s0_5 = getelementptr i32, ptr %pcmp, i64 5
  store i32 %c0_5, ptr %s0_5

  ret void
}

; Vefify that a memcmp() call involving a constant array with unknown
; contents is not folded.

define void @call_memcmp_a_ax_n(ptr %pcmp, i64 %n) {
; CHECK-LABEL: @call_memcmp_a_ax_n(
; CHECK-NEXT:    [[C0_0:%.*]] = call i32 @memcmp(ptr nonnull @a01230123, ptr nonnull @ax, i64 [[N:%.*]])
; CHECK-NEXT:    store i32 [[C0_0]], ptr [[PCMP:%.*]], align 4
; CHECK-NEXT:    ret void
;


  ; Do not fold memcmp(a, ax, n).
  %c0_0 = call i32 @memcmp(ptr @a01230123, ptr @ax, i64 %n)
  store i32 %c0_0, ptr %pcmp

  ret void
}


; Exercise memcmp(A, C, N) folding of arrays with the same leading bytes
; but a difference in the trailing byte.

define void @fold_memcmp_a_c_n(ptr %pcmp, i64 %n) {
; CHECK-LABEL: @fold_memcmp_a_c_n(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ugt i64 [[N:%.*]], 7
; CHECK-NEXT:    [[C0_0:%.*]] = sext i1 [[TMP1]] to i32
; CHECK-NEXT:    store i32 [[C0_0]], ptr [[PCMP:%.*]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ne i64 [[N]], 0
; CHECK-NEXT:    [[C0_1:%.*]] = sext i1 [[TMP2]] to i32
; CHECK-NEXT:    [[S0_1:%.*]] = getelementptr i8, ptr [[PCMP]], i64 4
; CHECK-NEXT:    store i32 [[C0_1]], ptr [[S0_1]], align 4
; CHECK-NEXT:    [[TMP3:%.*]] = icmp ne i64 [[N]], 0
; CHECK-NEXT:    [[C0_2:%.*]] = sext i1 [[TMP3]] to i32
; CHECK-NEXT:    [[S0_2:%.*]] = getelementptr i8, ptr [[PCMP]], i64 8
; CHECK-NEXT:    store i32 [[C0_2]], ptr [[S0_2]], align 4
; CHECK-NEXT:    [[TMP4:%.*]] = icmp ne i64 [[N]], 0
; CHECK-NEXT:    [[C0_3:%.*]] = sext i1 [[TMP4]] to i32
; CHECK-NEXT:    [[S0_3:%.*]] = getelementptr i8, ptr [[PCMP]], i64 12
; CHECK-NEXT:    store i32 [[C0_3]], ptr [[S0_3]], align 4
; CHECK-NEXT:    [[TMP5:%.*]] = icmp ugt i64 [[N]], 3
; CHECK-NEXT:    [[C0_4:%.*]] = sext i1 [[TMP5]] to i32
; CHECK-NEXT:    [[S0_4:%.*]] = getelementptr i8, ptr [[PCMP]], i64 16
; CHECK-NEXT:    store i32 [[C0_4]], ptr [[S0_4]], align 4
; CHECK-NEXT:    [[TMP6:%.*]] = icmp ugt i64 [[N]], 3
; CHECK-NEXT:    [[C0_5:%.*]] = sext i1 [[TMP6]] to i32
; CHECK-NEXT:    [[S0_5:%.*]] = getelementptr i8, ptr [[PCMP]], i64 20
; CHECK-NEXT:    store i32 [[C0_5]], ptr [[S0_5]], align 4
; CHECK-NEXT:    ret void
;


  %q1 = getelementptr [8 x i8], ptr @c01230129, i64 0, i64 1
  %q2 = getelementptr [8 x i8], ptr @c01230129, i64 0, i64 2
  %q3 = getelementptr [8 x i8], ptr @c01230129, i64 0, i64 3
  %q4 = getelementptr [8 x i8], ptr @c01230129, i64 0, i64 4
  %q5 = getelementptr [8 x i8], ptr @c01230129, i64 0, i64 5

  ; Fold memcmp(a, c, n) to N > 7 ? -1 : 0.
  %c0_0 = call i32 @memcmp(ptr @a01230123, ptr @c01230129, i64 %n)
  store i32 %c0_0, ptr %pcmp

  ; Fold memcmp(a, c + 1, n) to N != 0 ? -1 : 0.
  %c0_1 = call i32 @memcmp(ptr @a01230123, ptr %q1, i64 %n)
  %s0_1 = getelementptr i32, ptr %pcmp, i64 1
  store i32 %c0_1, ptr %s0_1

  ; Fold memcmp(a, c + 2, n) to N != 0 ? -1 : 0.
  %c0_2 = call i32 @memcmp(ptr @a01230123, ptr %q2, i64 %n)
  %s0_2 = getelementptr i32, ptr %pcmp, i64 2
  store i32 %c0_2, ptr %s0_2

  ; Fold memcmp(a, c + 3, n) to N != 0 ? -1 : 0.
  %c0_3 = call i32 @memcmp(ptr @a01230123, ptr %q3, i64 %n)
  %s0_3 = getelementptr i32, ptr %pcmp, i64 3
  store i32 %c0_3, ptr %s0_3

  ; Fold memcmp(a, c + 4, n) to N > 3 ? -1 : 0.
  %c0_4 = call i32 @memcmp(ptr @a01230123, ptr %q4, i64 %n)
  %s0_4 = getelementptr i32, ptr %pcmp, i64 4
  store i32 %c0_4, ptr %s0_4

  ; Fold memcmp(a, c + 5, n) to N != 0 ? -1 : 0.
  %c0_5 = call i32 @memcmp(ptr @a01230123, ptr %q4, i64 %n)
  %s0_5 = getelementptr i32, ptr %pcmp, i64 5
  store i32 %c0_5, ptr %s0_5

  ret void
}


; Exercise memcmp(A, D, N) folding of arrays of different sizes and
; a difference in the leading byte.

define void @fold_memcmp_a_d_n(ptr %pcmp, i64 %n) {
; CHECK-LABEL: @fold_memcmp_a_d_n(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ne i64 [[N:%.*]], 0
; CHECK-NEXT:    [[C0_0:%.*]] = sext i1 [[TMP1]] to i32
; CHECK-NEXT:    store i32 [[C0_0]], ptr [[PCMP:%.*]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ne i64 [[N]], 0
; CHECK-NEXT:    [[C0_1:%.*]] = sext i1 [[TMP2]] to i32
; CHECK-NEXT:    [[S0_1:%.*]] = getelementptr i8, ptr [[PCMP]], i64 4
; CHECK-NEXT:    store i32 [[C0_1]], ptr [[S0_1]], align 4
; CHECK-NEXT:    [[S1_1:%.*]] = getelementptr i8, ptr [[PCMP]], i64 8
; CHECK-NEXT:    store i32 0, ptr [[S1_1]], align 4
; CHECK-NEXT:    [[S6_6:%.*]] = getelementptr i8, ptr [[PCMP]], i64 12
; CHECK-NEXT:    store i32 0, ptr [[S6_6]], align 4
; CHECK-NEXT:    ret void
;

  %p1 = getelementptr [8 x i8], ptr @a01230123, i64 0, i64 1
  %p6 = getelementptr [8 x i8], ptr @a01230123, i64 0, i64 6

  %q1 = getelementptr [7 x i8], ptr @d9123012, i64 0, i64 1
  %q6 = getelementptr [7 x i8], ptr @d9123012, i64 0, i64 6

  ; Fold memcmp(a, d, n) to N != 0 ? -1 : 0.
  %c0_0 = call i32 @memcmp(ptr @a01230123, ptr @d9123012, i64 %n)
  store i32 %c0_0, ptr %pcmp

  ; Fold memcmp(a, d + 1, n) to N != 0 -1 : 0.
  %c0_1 = call i32 @memcmp(ptr @a01230123, ptr %q1, i64 %n)
  %s0_1 = getelementptr i32, ptr %pcmp, i64 1
  store i32 %c0_1, ptr %s0_1

  ; Fold memcmp(a + 1, d + 1, n) to 0.
  %c1_1 = call i32 @memcmp(ptr %p1, ptr %q1, i64 %n)
  %s1_1 = getelementptr i32, ptr %pcmp, i64 2
  store i32 %c1_1, ptr %s1_1

  ; Fold memcmp(a + 6, d + 6, n) to 0.
  %c6_6 = call i32 @memcmp(ptr %p6, ptr %q6, i64 %n)
  %s6_6 = getelementptr i32, ptr %pcmp, i64 3
  store i32 %c6_6, ptr %s6_6

  ret void
}


; Exercise memcmp(A, D, N) folding of arrays with the same bytes and
; a nonzero size.

define void @fold_memcmp_a_d_nz(ptr %pcmp, i64 %n) {
; CHECK-LABEL: @fold_memcmp_a_d_nz(
; CHECK-NEXT:    store i32 -1, ptr [[PCMP:%.*]], align 4
; CHECK-NEXT:    ret void
;

  %nz = or i64 %n, 1

  %c0_0 = call i32 @memcmp(ptr @a01230123, ptr @d9123012, i64 %nz)
  store i32 %c0_0, ptr %pcmp

  ret void
}
