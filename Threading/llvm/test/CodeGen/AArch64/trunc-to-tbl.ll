; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=arm64-apple-ios -o - %s | FileCheck %s
; RUN: llc -mtriple=aarch64_be-unknown-linux -o - %s | FileCheck --check-prefix=CHECK-BE %s
; RUN: llc -mtriple=aarch64_be-unknown-linux -aarch64-enable-ext-to-tbl=false -o - %s | FileCheck --check-prefix=CHECK-DISABLE %s

; CHECK-LABEL: lCPI0_0:
; CHECK-NEXT:	.byte	0                               ; 0x0
; CHECK-NEXT:	.byte	4                               ; 0x4
; CHECK-NEXT:	.byte	8                               ; 0x8
; CHECK-NEXT:	.byte	12                              ; 0xc
; CHECK-NEXT:	.byte	16                              ; 0x10
; CHECK-NEXT:	.byte	20                              ; 0x14
; CHECK-NEXT:	.byte	24                              ; 0x18
; CHECK-NEXT:	.byte	28                              ; 0x1c
; CHECK-NEXT:	.byte	32                              ; 0x20
; CHECK-NEXT:	.byte	36                              ; 0x24
; CHECK-NEXT:	.byte	40                              ; 0x28
; CHECK-NEXT:	.byte	44                              ; 0x2c
; CHECK-NEXT:	.byte	48                              ; 0x30
; CHECK-NEXT:	.byte	52                              ; 0x34
; CHECK-NEXT:	.byte	56                              ; 0x38
; CHECK-NEXT:	.byte	60                              ; 0x3c

; CHECK-BE-LABEL:   .LCPI0_0:
; CHECK-BE-NEXT:   .byte    3                               // 0x3
; CHECK-BE-NEXT:   .byte    7                               // 0x7
; CHECK-BE-NEXT:   .byte    11                              // 0xb
; CHECK-BE-NEXT:   .byte    15                              // 0xf
; CHECK-BE-NEXT:   .byte    19                              // 0x13
; CHECK-BE-NEXT:   .byte    23                              // 0x17
; CHECK-BE-NEXT:   .byte    27                              // 0x1b
; CHECK-BE-NEXT:   .byte    31                              // 0x1f
; CHECK-BE-NEXT:   .byte    35                              // 0x23
; CHECK-BE-NEXT:   .byte    39                              // 0x27
; CHECK-BE-NEXT:   .byte    43                              // 0x2b
; CHECK-BE-NEXT:   .byte    47                              // 0x2f
; CHECK-BE-NEXT:   .byte    51                              // 0x33
; CHECK-BE-NEXT:   .byte    55                              // 0x37
; CHECK-BE-NEXT:   .byte    59                              // 0x3b
; CHECK-BE-NEXT:   .byte    63                              // 0x3f

; It's profitable to use a single tbl.4 instruction to lower the truncate.
define void @trunc_v16i32_to_v16i8_in_loop(ptr %A, ptr %dst) {
; CHECK-LABEL: trunc_v16i32_to_v16i8_in_loop:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:  Lloh0:
; CHECK-NEXT:    adrp x8, lCPI0_0@PAGE
; CHECK-NEXT:  Lloh1:
; CHECK-NEXT:    ldr q0, [x8, lCPI0_0@PAGEOFF]
; CHECK-NEXT:    mov x8, xzr
; CHECK-NEXT:  LBB0_1: ; %loop
; CHECK-NEXT:    ; =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    add x9, x0, x8, lsl #6
; CHECK-NEXT:    ldp q1, q2, [x9]
; CHECK-NEXT:    ldp q3, q4, [x9, #32]
; CHECK-NEXT:    tbl.16b v1, { v1, v2, v3, v4 }, v0
; CHECK-NEXT:    str q1, [x1, x8, lsl #4]
; CHECK-NEXT:    add x8, x8, #1
; CHECK-NEXT:    cmp x8, #1000
; CHECK-NEXT:    b.eq LBB0_1
; CHECK-NEXT:  ; %bb.2: ; %exit
; CHECK-NEXT:    ret
; CHECK-NEXT:    .loh AdrpLdr Lloh0, Lloh1
;
; CHECK-BE-LABEL: trunc_v16i32_to_v16i8_in_loop:
; CHECK-BE:       // %bb.0: // %entry
; CHECK-BE-NEXT:    adrp x8, .LCPI0_0
; CHECK-BE-NEXT:    add x8, x8, :lo12:.LCPI0_0
; CHECK-BE-NEXT:    ld1 { v0.16b }, [x8]
; CHECK-BE-NEXT:    mov x8, xzr
; CHECK-BE-NEXT:  .LBB0_1: // %loop
; CHECK-BE-NEXT:    // =>This Inner Loop Header: Depth=1
; CHECK-BE-NEXT:    add x9, x0, x8, lsl #6
; CHECK-BE-NEXT:    add x10, x9, #16
; CHECK-BE-NEXT:    ld1 { v1.16b }, [x9]
; CHECK-BE-NEXT:    add x11, x9, #32
; CHECK-BE-NEXT:    ld1 { v2.16b }, [x10]
; CHECK-BE-NEXT:    add x9, x9, #48
; CHECK-BE-NEXT:    ld1 { v3.16b }, [x11]
; CHECK-BE-NEXT:    ld1 { v4.16b }, [x9]
; CHECK-BE-NEXT:    add x9, x1, x8, lsl #4
; CHECK-BE-NEXT:    add x8, x8, #1
; CHECK-BE-NEXT:    cmp x8, #1000
; CHECK-BE-NEXT:    tbl v1.16b, { v1.16b, v2.16b, v3.16b, v4.16b }, v0.16b
; CHECK-BE-NEXT:    st1 { v1.16b }, [x9]
; CHECK-BE-NEXT:    b.eq .LBB0_1
; CHECK-BE-NEXT:  // %bb.2: // %exit
; CHECK-BE-NEXT:    ret
;
; CHECK-DISABLE-LABEL: trunc_v16i32_to_v16i8_in_loop:
; CHECK-DISABLE:       // %bb.0: // %entry
; CHECK-DISABLE-NEXT:    mov x8, xzr
; CHECK-DISABLE-NEXT:  .LBB0_1: // %loop
; CHECK-DISABLE-NEXT:    // =>This Inner Loop Header: Depth=1
; CHECK-DISABLE-NEXT:    add x9, x0, x8, lsl #6
; CHECK-DISABLE-NEXT:    ld1 { v0.4s }, [x9]
; CHECK-DISABLE-NEXT:    add x10, x9, #16
; CHECK-DISABLE-NEXT:    add x11, x9, #48
; CHECK-DISABLE-NEXT:    add x9, x9, #32
; CHECK-DISABLE-NEXT:    ld1 { v1.4s }, [x10]
; CHECK-DISABLE-NEXT:    ld1 { v2.4s }, [x11]
; CHECK-DISABLE-NEXT:    ld1 { v3.4s }, [x9]
; CHECK-DISABLE-NEXT:    add x9, x1, x8, lsl #4
; CHECK-DISABLE-NEXT:    add x8, x8, #1
; CHECK-DISABLE-NEXT:    cmp x8, #1000
; CHECK-DISABLE-NEXT:    uzp1 v0.8h, v0.8h, v1.8h
; CHECK-DISABLE-NEXT:    uzp1 v2.8h, v3.8h, v2.8h
; CHECK-DISABLE-NEXT:    uzp1 v0.16b, v0.16b, v2.16b
; CHECK-DISABLE-NEXT:    st1 { v0.16b }, [x9]
; CHECK-DISABLE-NEXT:    b.eq .LBB0_1
; CHECK-DISABLE-NEXT:  // %bb.2: // %exit
; CHECK-DISABLE-NEXT:    ret
entry:
  br label %loop

loop:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %loop ]
  %gep.A = getelementptr inbounds <16 x i32>, ptr %A, i64 %iv
  %l.A = load <16 x i32>, ptr %gep.A
  %trunc = trunc <16 x i32> %l.A to <16 x i8>
  %gep.dst = getelementptr inbounds <16 x i8>, ptr %dst, i64 %iv
  store <16 x i8> %trunc, ptr %gep.dst
  %iv.next = add i64 %iv, 1
  %ec = icmp eq i64 %iv.next, 1000
  br i1 %ec, label %loop, label %exit

exit:
  ret void
}

; Not profitable to use tbl, as materializing the masks requires more
; instructions.
define void @trunc_v16i32_to_v16i8_no_loop(ptr %A, ptr %dst) {
; CHECK-LABEL: trunc_v16i32_to_v16i8_no_loop:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    ldp q1, q0, [x0]
; CHECK-NEXT:    ldp q3, q2, [x0, #32]
; CHECK-NEXT:    uzp1.8h v0, v1, v0
; CHECK-NEXT:    uzp1.8h v2, v3, v2
; CHECK-NEXT:    uzp1.16b v0, v0, v2
; CHECK-NEXT:    str q0, [x1]
; CHECK-NEXT:    ret
;
; CHECK-BE-LABEL: trunc_v16i32_to_v16i8_no_loop:
; CHECK-BE:       // %bb.0: // %entry
; CHECK-BE-NEXT:    add x8, x0, #16
; CHECK-BE-NEXT:    add x9, x0, #48
; CHECK-BE-NEXT:    add x10, x0, #32
; CHECK-BE-NEXT:    ld1 { v0.4s }, [x0]
; CHECK-BE-NEXT:    ld1 { v1.4s }, [x8]
; CHECK-BE-NEXT:    ld1 { v2.4s }, [x9]
; CHECK-BE-NEXT:    ld1 { v3.4s }, [x10]
; CHECK-BE-NEXT:    uzp1 v0.8h, v0.8h, v1.8h
; CHECK-BE-NEXT:    uzp1 v2.8h, v3.8h, v2.8h
; CHECK-BE-NEXT:    uzp1 v0.16b, v0.16b, v2.16b
; CHECK-BE-NEXT:    st1 { v0.16b }, [x1]
; CHECK-BE-NEXT:    ret
;
; CHECK-DISABLE-LABEL: trunc_v16i32_to_v16i8_no_loop:
; CHECK-DISABLE:       // %bb.0: // %entry
; CHECK-DISABLE-NEXT:    add x8, x0, #16
; CHECK-DISABLE-NEXT:    add x9, x0, #48
; CHECK-DISABLE-NEXT:    add x10, x0, #32
; CHECK-DISABLE-NEXT:    ld1 { v0.4s }, [x0]
; CHECK-DISABLE-NEXT:    ld1 { v1.4s }, [x8]
; CHECK-DISABLE-NEXT:    ld1 { v2.4s }, [x9]
; CHECK-DISABLE-NEXT:    ld1 { v3.4s }, [x10]
; CHECK-DISABLE-NEXT:    uzp1 v0.8h, v0.8h, v1.8h
; CHECK-DISABLE-NEXT:    uzp1 v2.8h, v3.8h, v2.8h
; CHECK-DISABLE-NEXT:    uzp1 v0.16b, v0.16b, v2.16b
; CHECK-DISABLE-NEXT:    st1 { v0.16b }, [x1]
; CHECK-DISABLE-NEXT:    ret
entry:
  %l.A = load <16 x i32>, ptr %A
  %trunc = trunc <16 x i32> %l.A to <16 x i8>
  store <16 x i8> %trunc, ptr %dst
  ret void
}


; CHECK-LABEL: lCPI2_0:
; CHECK-NEXT:     .byte    0                               ; 0x0
; CHECK-NEXT:     .byte    4                               ; 0x4
; CHECK-NEXT:     .byte    8                               ; 0x8
; CHECK-NEXT:     .byte    12                              ; 0xc
; CHECK-NEXT:     .byte    16                              ; 0x10
; CHECK-NEXT:     .byte    20                              ; 0x14
; CHECK-NEXT:     .byte    24                              ; 0x18
; CHECK-NEXT:     .byte    28                              ; 0x1c
; CHECK-NEXT:     .byte    255                             ; 0xff
; CHECK-NEXT:     .byte    255                             ; 0xff
; CHECK-NEXT:     .byte    255                             ; 0xff
; CHECK-NEXT:     .byte    255                             ; 0xff
; CHECK-NEXT:     .byte    255                             ; 0xff
; CHECK-NEXT:     .byte    255                             ; 0xff
; CHECK-NEXT:     .byte    255                             ; 0xff
; CHECK-NEXT:     .byte    255                             ; 0xff

; CHECK-BE-LABEL: .LCPI2_0:
; CHECK-BE-NEXT:     .byte    3                               // 0x3
; CHECK-BE-NEXT:     .byte    7                               // 0x7
; CHECK-BE-NEXT:     .byte    11                              // 0xb
; CHECK-BE-NEXT:     .byte    15                              // 0xf
; CHECK-BE-NEXT:     .byte    19                              // 0x13
; CHECK-BE-NEXT:     .byte    23                              // 0x17
; CHECK-BE-NEXT:     .byte    27                              // 0x1b
; CHECK-BE-NEXT:     .byte    31                              // 0x1f
; CHECK-BE-NEXT:     .byte    255                             // 0xff
; CHECK-BE-NEXT:     .byte    255                             // 0xff
; CHECK-BE-NEXT:     .byte    255                             // 0xff
; CHECK-BE-NEXT:     .byte    255                             // 0xff
; CHECK-BE-NEXT:     .byte    255                             // 0xff
; CHECK-BE-NEXT:     .byte    255                             // 0xff
; CHECK-BE-NEXT:     .byte    255                             // 0xff
; CHECK-BE-NEXT:     .byte    255                             // 0xff
; It's profitable to use a single tbl.2 instruction to lower the truncate.
define void @trunc_v8i32_to_v8i8_in_loop(ptr %A, ptr %dst) {
; CHECK-LABEL: trunc_v8i32_to_v8i8_in_loop:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:  Lloh2:
; CHECK-NEXT:    adrp x8, lCPI2_0@PAGE
; CHECK-NEXT:  Lloh3:
; CHECK-NEXT:    ldr q0, [x8, lCPI2_0@PAGEOFF]
; CHECK-NEXT:    mov x8, xzr
; CHECK-NEXT:  LBB2_1: ; %loop
; CHECK-NEXT:    ; =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    add x9, x0, x8, lsl #5
; CHECK-NEXT:    ldp q1, q2, [x9]
; CHECK-NEXT:    tbl.16b v1, { v1, v2 }, v0
; CHECK-NEXT:    str d1, [x1, x8, lsl #3]
; CHECK-NEXT:    add x8, x8, #1
; CHECK-NEXT:    cmp x8, #1000
; CHECK-NEXT:    b.eq LBB2_1
; CHECK-NEXT:  ; %bb.2: ; %exit
; CHECK-NEXT:    ret
; CHECK-NEXT:    .loh AdrpLdr Lloh2, Lloh3
;
; CHECK-BE-LABEL: trunc_v8i32_to_v8i8_in_loop:
; CHECK-BE:       // %bb.0: // %entry
; CHECK-BE-NEXT:    adrp x8, .LCPI2_0
; CHECK-BE-NEXT:    add x8, x8, :lo12:.LCPI2_0
; CHECK-BE-NEXT:    ld1 { v0.16b }, [x8]
; CHECK-BE-NEXT:    mov x8, xzr
; CHECK-BE-NEXT:  .LBB2_1: // %loop
; CHECK-BE-NEXT:    // =>This Inner Loop Header: Depth=1
; CHECK-BE-NEXT:    add x9, x0, x8, lsl #5
; CHECK-BE-NEXT:    add x10, x9, #16
; CHECK-BE-NEXT:    ld1 { v1.16b }, [x9]
; CHECK-BE-NEXT:    add x9, x1, x8, lsl #3
; CHECK-BE-NEXT:    ld1 { v2.16b }, [x10]
; CHECK-BE-NEXT:    add x8, x8, #1
; CHECK-BE-NEXT:    cmp x8, #1000
; CHECK-BE-NEXT:    tbl v1.16b, { v1.16b, v2.16b }, v0.16b
; CHECK-BE-NEXT:    st1 { v1.8b }, [x9]
; CHECK-BE-NEXT:    b.eq .LBB2_1
; CHECK-BE-NEXT:  // %bb.2: // %exit
; CHECK-BE-NEXT:    ret
;
; CHECK-DISABLE-LABEL: trunc_v8i32_to_v8i8_in_loop:
; CHECK-DISABLE:       // %bb.0: // %entry
; CHECK-DISABLE-NEXT:    mov x8, xzr
; CHECK-DISABLE-NEXT:  .LBB2_1: // %loop
; CHECK-DISABLE-NEXT:    // =>This Inner Loop Header: Depth=1
; CHECK-DISABLE-NEXT:    add x9, x0, x8, lsl #5
; CHECK-DISABLE-NEXT:    add x10, x9, #16
; CHECK-DISABLE-NEXT:    ld1 { v0.4s }, [x9]
; CHECK-DISABLE-NEXT:    add x9, x1, x8, lsl #3
; CHECK-DISABLE-NEXT:    ld1 { v1.4s }, [x10]
; CHECK-DISABLE-NEXT:    add x8, x8, #1
; CHECK-DISABLE-NEXT:    cmp x8, #1000
; CHECK-DISABLE-NEXT:    uzp1 v0.8h, v0.8h, v1.8h
; CHECK-DISABLE-NEXT:    xtn v0.8b, v0.8h
; CHECK-DISABLE-NEXT:    st1 { v0.8b }, [x9]
; CHECK-DISABLE-NEXT:    b.eq .LBB2_1
; CHECK-DISABLE-NEXT:  // %bb.2: // %exit
; CHECK-DISABLE-NEXT:    ret
entry:
  br label %loop

loop:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %loop ]
  %gep.A = getelementptr inbounds <8 x i32>, ptr %A, i64 %iv
  %l.A = load <8 x i32>, ptr %gep.A
  %trunc = trunc <8 x i32> %l.A to <8 x i8>
  %gep.dst = getelementptr inbounds <8 x i8>, ptr %dst, i64 %iv
  store <8 x i8> %trunc, ptr %gep.dst
  %iv.next = add i64 %iv, 1
  %ec = icmp eq i64 %iv.next, 1000
  br i1 %ec, label %loop, label %exit

exit:
  ret void
}

; CHECK-LABEL:   lCPI3_0:
; CHECK-NEXT:   	.byte	0                               ; 0x0
; CHECK-NEXT:   	.byte	8                               ; 0x8
; CHECK-NEXT:   	.byte	16                              ; 0x10
; CHECK-NEXT:   	.byte	24                              ; 0x18
; CHECK-NEXT:   	.byte	32                              ; 0x20
; CHECK-NEXT:   	.byte	40                              ; 0x28
; CHECK-NEXT:   	.byte	48                              ; 0x30
; CHECK-NEXT:   	.byte	56                              ; 0x38
; CHECK-NEXT:   	.byte	64                              ; 0x40
; CHECK-NEXT:   	.byte	72                              ; 0x48
; CHECK-NEXT:   	.byte	80                              ; 0x50
; CHECK-NEXT:   	.byte	88                              ; 0x58
; CHECK-NEXT:   	.byte	96                              ; 0x60
; CHECK-NEXT:   	.byte	104                             ; 0x68
; CHECK-NEXT:   	.byte	112                             ; 0x70
; CHECK-NEXT:   	.byte	120                             ; 0x78

; CHECK-BE-LABEL:    .LCPI3_0:
; CHECK-BE-NEXT:    	.byte	7                               // 0x7
; CHECK-BE-NEXT:    	.byte	15                              // 0xf
; CHECK-BE-NEXT:    	.byte	23                              // 0x17
; CHECK-BE-NEXT:    	.byte	31                              // 0x1f
; CHECK-BE-NEXT:    	.byte	39                              // 0x27
; CHECK-BE-NEXT:    	.byte	47                              // 0x2f
; CHECK-BE-NEXT:    	.byte	55                              // 0x37
; CHECK-BE-NEXT:    	.byte	63                              // 0x3f
; CHECK-BE-NEXT:    	.byte	71                              // 0x47
; CHECK-BE-NEXT:    	.byte	79                              // 0x4f
; CHECK-BE-NEXT:    	.byte	87                              // 0x57
; CHECK-BE-NEXT:    	.byte	95                              // 0x5f
; CHECK-BE-NEXT:    	.byte	103                             // 0x67
; CHECK-BE-NEXT:    	.byte	111                             // 0x6f
; CHECK-BE-NEXT:    	.byte	119                             // 0x77
; CHECK-BE-NEXT:    	.byte	127                             // 0x7f
define void @trunc_v16i64_to_v16i8_in_loop(ptr %A, ptr %dst) {
; CHECK-LABEL: trunc_v16i64_to_v16i8_in_loop:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:  Lloh4:
; CHECK-NEXT:    adrp x8, lCPI3_0@PAGE
; CHECK-NEXT:  Lloh5:
; CHECK-NEXT:    ldr q0, [x8, lCPI3_0@PAGEOFF]
; CHECK-NEXT:    mov x8, xzr
; CHECK-NEXT:  LBB3_1: ; %loop
; CHECK-NEXT:    ; =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    add x9, x0, x8, lsl #7
; CHECK-NEXT:    ldp q1, q2, [x9]
; CHECK-NEXT:    ldp q16, q17, [x9, #64]
; CHECK-NEXT:    ldp q3, q4, [x9, #32]
; CHECK-NEXT:    ldp q18, q19, [x9, #96]
; CHECK-NEXT:    tbl.16b v1, { v1, v2, v3, v4 }, v0
; CHECK-NEXT:    tbl.16b v2, { v16, v17, v18, v19 }, v0
; CHECK-NEXT:    mov.d v1[1], v2[0]
; CHECK-NEXT:    str q1, [x1, x8, lsl #4]
; CHECK-NEXT:    add x8, x8, #1
; CHECK-NEXT:    cmp x8, #1000
; CHECK-NEXT:    b.eq LBB3_1
; CHECK-NEXT:  ; %bb.2: ; %exit
; CHECK-NEXT:    ret
; CHECK-NEXT:    .loh AdrpLdr Lloh4, Lloh5
;
; CHECK-BE-LABEL: trunc_v16i64_to_v16i8_in_loop:
; CHECK-BE:       // %bb.0: // %entry
; CHECK-BE-NEXT:    adrp x8, .LCPI3_0
; CHECK-BE-NEXT:    add x8, x8, :lo12:.LCPI3_0
; CHECK-BE-NEXT:    ld1 { v0.16b }, [x8]
; CHECK-BE-NEXT:    mov x8, xzr
; CHECK-BE-NEXT:  .LBB3_1: // %loop
; CHECK-BE-NEXT:    // =>This Inner Loop Header: Depth=1
; CHECK-BE-NEXT:    add x9, x0, x8, lsl #7
; CHECK-BE-NEXT:    add x13, x9, #64
; CHECK-BE-NEXT:    add x12, x9, #80
; CHECK-BE-NEXT:    add x14, x9, #16
; CHECK-BE-NEXT:    ld1 { v1.16b }, [x9]
; CHECK-BE-NEXT:    ld1 { v16.16b }, [x13]
; CHECK-BE-NEXT:    add x11, x9, #96
; CHECK-BE-NEXT:    add x13, x9, #32
; CHECK-BE-NEXT:    ld1 { v2.16b }, [x14]
; CHECK-BE-NEXT:    ld1 { v17.16b }, [x12]
; CHECK-BE-NEXT:    add x10, x9, #112
; CHECK-BE-NEXT:    add x9, x9, #48
; CHECK-BE-NEXT:    ld1 { v3.16b }, [x13]
; CHECK-BE-NEXT:    ld1 { v18.16b }, [x11]
; CHECK-BE-NEXT:    ld1 { v4.16b }, [x9]
; CHECK-BE-NEXT:    add x9, x1, x8, lsl #4
; CHECK-BE-NEXT:    ld1 { v19.16b }, [x10]
; CHECK-BE-NEXT:    add x8, x8, #1
; CHECK-BE-NEXT:    cmp x8, #1000
; CHECK-BE-NEXT:    tbl v1.16b, { v1.16b, v2.16b, v3.16b, v4.16b }, v0.16b
; CHECK-BE-NEXT:    tbl v2.16b, { v16.16b, v17.16b, v18.16b, v19.16b }, v0.16b
; CHECK-BE-NEXT:    mov v1.d[1], v2.d[0]
; CHECK-BE-NEXT:    st1 { v1.16b }, [x9]
; CHECK-BE-NEXT:    b.eq .LBB3_1
; CHECK-BE-NEXT:  // %bb.2: // %exit
; CHECK-BE-NEXT:    ret
;
; CHECK-DISABLE-LABEL: trunc_v16i64_to_v16i8_in_loop:
; CHECK-DISABLE:       // %bb.0: // %entry
; CHECK-DISABLE-NEXT:    mov x8, xzr
; CHECK-DISABLE-NEXT:  .LBB3_1: // %loop
; CHECK-DISABLE-NEXT:    // =>This Inner Loop Header: Depth=1
; CHECK-DISABLE-NEXT:    add x9, x0, x8, lsl #7
; CHECK-DISABLE-NEXT:    add x10, x9, #16
; CHECK-DISABLE-NEXT:    add x11, x9, #48
; CHECK-DISABLE-NEXT:    ld1 { v0.2d }, [x9]
; CHECK-DISABLE-NEXT:    ld1 { v1.2d }, [x10]
; CHECK-DISABLE-NEXT:    add x10, x9, #112
; CHECK-DISABLE-NEXT:    ld1 { v2.2d }, [x11]
; CHECK-DISABLE-NEXT:    ld1 { v3.2d }, [x10]
; CHECK-DISABLE-NEXT:    add x10, x9, #96
; CHECK-DISABLE-NEXT:    add x11, x9, #32
; CHECK-DISABLE-NEXT:    ld1 { v4.2d }, [x10]
; CHECK-DISABLE-NEXT:    add x10, x9, #80
; CHECK-DISABLE-NEXT:    add x9, x9, #64
; CHECK-DISABLE-NEXT:    ld1 { v5.2d }, [x11]
; CHECK-DISABLE-NEXT:    ld1 { v6.2d }, [x10]
; CHECK-DISABLE-NEXT:    ld1 { v7.2d }, [x9]
; CHECK-DISABLE-NEXT:    uzp1 v0.4s, v0.4s, v1.4s
; CHECK-DISABLE-NEXT:    add x9, x1, x8, lsl #4
; CHECK-DISABLE-NEXT:    add x8, x8, #1
; CHECK-DISABLE-NEXT:    uzp1 v3.4s, v4.4s, v3.4s
; CHECK-DISABLE-NEXT:    cmp x8, #1000
; CHECK-DISABLE-NEXT:    uzp1 v4.4s, v7.4s, v6.4s
; CHECK-DISABLE-NEXT:    uzp1 v2.4s, v5.4s, v2.4s
; CHECK-DISABLE-NEXT:    uzp1 v1.8h, v4.8h, v3.8h
; CHECK-DISABLE-NEXT:    uzp1 v0.8h, v0.8h, v2.8h
; CHECK-DISABLE-NEXT:    uzp1 v0.16b, v0.16b, v1.16b
; CHECK-DISABLE-NEXT:    st1 { v0.16b }, [x9]
; CHECK-DISABLE-NEXT:    b.eq .LBB3_1
; CHECK-DISABLE-NEXT:  // %bb.2: // %exit
; CHECK-DISABLE-NEXT:    ret
entry:
  br label %loop

loop:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %loop ]
  %gep.A = getelementptr inbounds <16 x i64>, ptr %A, i64 %iv
  %l.A = load <16 x i64>, ptr %gep.A
  %trunc = trunc <16 x i64> %l.A to <16 x i8>
  %gep.dst = getelementptr inbounds <16 x i8>, ptr %dst, i64 %iv
  store <16 x i8> %trunc, ptr %gep.dst
  %iv.next = add i64 %iv, 1
  %ec = icmp eq i64 %iv.next, 1000
  br i1 %ec, label %loop, label %exit

exit:
  ret void
}

; CHECK-LABEL: lCPI4_0:
; CHECK-NEXT: 	.byte	0                               ; 0x0
; CHECK-NEXT: 	.byte	8                               ; 0x8
; CHECK-NEXT: 	.byte	16                              ; 0x10
; CHECK-NEXT: 	.byte	24                              ; 0x18
; CHECK-NEXT: 	.byte	32                              ; 0x20
; CHECK-NEXT: 	.byte	40                              ; 0x28
; CHECK-NEXT: 	.byte	48                              ; 0x30
; CHECK-NEXT: 	.byte	56                              ; 0x38
; CHECK-NEXT: 	.byte	255                             ; 0xff
; CHECK-NEXT: 	.byte	255                             ; 0xff
; CHECK-NEXT: 	.byte	255                             ; 0xff
; CHECK-NEXT: 	.byte	255                             ; 0xff
; CHECK-NEXT: 	.byte	255                             ; 0xff
; CHECK-NEXT: 	.byte	255                             ; 0xff
; CHECK-NEXT: 	.byte	255                             ; 0xff
; CHECK-NEXT: 	.byte	255                             ; 0xff

; CHECK-BE-LABEL:   .LCPI4_0:
; CHECK-BE-NEXT:   	.byte	7                               // 0x7
; CHECK-BE-NEXT:   	.byte	15                              // 0xf
; CHECK-BE-NEXT:   	.byte	23                              // 0x17
; CHECK-BE-NEXT:   	.byte	31                              // 0x1f
; CHECK-BE-NEXT:   	.byte	39                              // 0x27
; CHECK-BE-NEXT:   	.byte	47                              // 0x2f
; CHECK-BE-NEXT:   	.byte	55                              // 0x37
; CHECK-BE-NEXT:   	.byte	63                              // 0x3f
; CHECK-BE-NEXT:   	.byte	255                             // 0xff
; CHECK-BE-NEXT:   	.byte	255                             // 0xff
; CHECK-BE-NEXT:   	.byte	255                             // 0xff
; CHECK-BE-NEXT:   	.byte	255                             // 0xff
; CHECK-BE-NEXT:   	.byte	255                             // 0xff
; CHECK-BE-NEXT:   	.byte	255                             // 0xff
; CHECK-BE-NEXT:   	.byte	255                             // 0xff
; CHECK-BE-NEXT:   	.byte	255                             // 0xff
define void @trunc_v8i64_to_v8i8_in_loop(ptr %A, ptr %dst) {
; CHECK-LABEL: trunc_v8i64_to_v8i8_in_loop:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:  Lloh6:
; CHECK-NEXT:    adrp x8, lCPI4_0@PAGE
; CHECK-NEXT:  Lloh7:
; CHECK-NEXT:    ldr q0, [x8, lCPI4_0@PAGEOFF]
; CHECK-NEXT:    mov x8, xzr
; CHECK-NEXT:  LBB4_1: ; %loop
; CHECK-NEXT:    ; =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    add x9, x0, x8, lsl #6
; CHECK-NEXT:    ldp q1, q2, [x9]
; CHECK-NEXT:    ldp q3, q4, [x9, #32]
; CHECK-NEXT:    tbl.16b v1, { v1, v2, v3, v4 }, v0
; CHECK-NEXT:    str d1, [x1, x8, lsl #3]
; CHECK-NEXT:    add x8, x8, #1
; CHECK-NEXT:    cmp x8, #1000
; CHECK-NEXT:    b.eq LBB4_1
; CHECK-NEXT:  ; %bb.2: ; %exit
; CHECK-NEXT:    ret
; CHECK-NEXT:    .loh AdrpLdr Lloh6, Lloh7
;
; CHECK-BE-LABEL: trunc_v8i64_to_v8i8_in_loop:
; CHECK-BE:       // %bb.0: // %entry
; CHECK-BE-NEXT:    adrp x8, .LCPI4_0
; CHECK-BE-NEXT:    add x8, x8, :lo12:.LCPI4_0
; CHECK-BE-NEXT:    ld1 { v0.16b }, [x8]
; CHECK-BE-NEXT:    mov x8, xzr
; CHECK-BE-NEXT:  .LBB4_1: // %loop
; CHECK-BE-NEXT:    // =>This Inner Loop Header: Depth=1
; CHECK-BE-NEXT:    add x9, x0, x8, lsl #6
; CHECK-BE-NEXT:    add x10, x9, #16
; CHECK-BE-NEXT:    ld1 { v1.16b }, [x9]
; CHECK-BE-NEXT:    add x11, x9, #32
; CHECK-BE-NEXT:    ld1 { v2.16b }, [x10]
; CHECK-BE-NEXT:    add x9, x9, #48
; CHECK-BE-NEXT:    ld1 { v3.16b }, [x11]
; CHECK-BE-NEXT:    ld1 { v4.16b }, [x9]
; CHECK-BE-NEXT:    add x9, x1, x8, lsl #3
; CHECK-BE-NEXT:    add x8, x8, #1
; CHECK-BE-NEXT:    cmp x8, #1000
; CHECK-BE-NEXT:    tbl v1.16b, { v1.16b, v2.16b, v3.16b, v4.16b }, v0.16b
; CHECK-BE-NEXT:    st1 { v1.8b }, [x9]
; CHECK-BE-NEXT:    b.eq .LBB4_1
; CHECK-BE-NEXT:  // %bb.2: // %exit
; CHECK-BE-NEXT:    ret
;
; CHECK-DISABLE-LABEL: trunc_v8i64_to_v8i8_in_loop:
; CHECK-DISABLE:       // %bb.0: // %entry
; CHECK-DISABLE-NEXT:    mov x8, xzr
; CHECK-DISABLE-NEXT:  .LBB4_1: // %loop
; CHECK-DISABLE-NEXT:    // =>This Inner Loop Header: Depth=1
; CHECK-DISABLE-NEXT:    add x9, x0, x8, lsl #6
; CHECK-DISABLE-NEXT:    ld1 { v0.2d }, [x9]
; CHECK-DISABLE-NEXT:    add x10, x9, #16
; CHECK-DISABLE-NEXT:    add x11, x9, #48
; CHECK-DISABLE-NEXT:    add x9, x9, #32
; CHECK-DISABLE-NEXT:    ld1 { v1.2d }, [x10]
; CHECK-DISABLE-NEXT:    ld1 { v2.2d }, [x11]
; CHECK-DISABLE-NEXT:    ld1 { v3.2d }, [x9]
; CHECK-DISABLE-NEXT:    add x9, x1, x8, lsl #3
; CHECK-DISABLE-NEXT:    add x8, x8, #1
; CHECK-DISABLE-NEXT:    cmp x8, #1000
; CHECK-DISABLE-NEXT:    uzp1 v0.4s, v0.4s, v1.4s
; CHECK-DISABLE-NEXT:    uzp1 v2.4s, v3.4s, v2.4s
; CHECK-DISABLE-NEXT:    uzp1 v0.8h, v0.8h, v2.8h
; CHECK-DISABLE-NEXT:    xtn v0.8b, v0.8h
; CHECK-DISABLE-NEXT:    st1 { v0.8b }, [x9]
; CHECK-DISABLE-NEXT:    b.eq .LBB4_1
; CHECK-DISABLE-NEXT:  // %bb.2: // %exit
; CHECK-DISABLE-NEXT:    ret
entry:
  br label %loop

loop:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %loop ]
  %gep.A = getelementptr inbounds <8 x i64>, ptr %A, i64 %iv
  %l.A = load <8 x i64>, ptr %gep.A
  %trunc = trunc <8 x i64> %l.A to <8 x i8>
  %gep.dst = getelementptr inbounds <8 x i8>, ptr %dst, i64 %iv
  store <8 x i8> %trunc, ptr %gep.dst
  %iv.next = add i64 %iv, 1
  %ec = icmp eq i64 %iv.next, 1000
  br i1 %ec, label %loop, label %exit

exit:
  ret void
}

define void @trunc_v8i19_to_v8i8_in_loop(ptr %A, ptr %dst) {
; CHECK-LABEL: trunc_v8i19_to_v8i8_in_loop:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    mov x8, xzr
; CHECK-NEXT:  LBB5_1: ; %loop
; CHECK-NEXT:    ; =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldp x10, x9, [x0]
; CHECK-NEXT:    ldrb w13, [x0, #18]
; CHECK-NEXT:    ldrh w14, [x0, #16]
; CHECK-NEXT:    add x0, x0, #32
; CHECK-NEXT:    ubfx x12, x9, #12, #20
; CHECK-NEXT:    fmov s0, w10
; CHECK-NEXT:    lsr x11, x10, #19
; CHECK-NEXT:    lsr x15, x9, #31
; CHECK-NEXT:    fmov s1, w12
; CHECK-NEXT:    lsr x12, x9, #50
; CHECK-NEXT:    mov.s v0[1], w11
; CHECK-NEXT:    orr w11, w14, w13, lsl #16
; CHECK-NEXT:    lsr x13, x10, #38
; CHECK-NEXT:    lsr x10, x10, #57
; CHECK-NEXT:    mov.s v1[1], w15
; CHECK-NEXT:    orr w12, w12, w11, lsl #14
; CHECK-NEXT:    orr w9, w10, w9, lsl #7
; CHECK-NEXT:    lsr w10, w11, #5
; CHECK-NEXT:    mov.s v0[2], w13
; CHECK-NEXT:    mov.s v1[2], w12
; CHECK-NEXT:    mov.s v0[3], w9
; CHECK-NEXT:    mov.s v1[3], w10
; CHECK-NEXT:    uzp1.8h v0, v0, v1
; CHECK-NEXT:    xtn.8b v0, v0
; CHECK-NEXT:    str d0, [x1, x8, lsl #3]
; CHECK-NEXT:    add x8, x8, #1
; CHECK-NEXT:    cmp x8, #1000
; CHECK-NEXT:    b.eq LBB5_1
; CHECK-NEXT:  ; %bb.2: ; %exit
; CHECK-NEXT:    ret
;
; CHECK-BE-LABEL: trunc_v8i19_to_v8i8_in_loop:
; CHECK-BE:       // %bb.0: // %entry
; CHECK-BE-NEXT:    mov x8, xzr
; CHECK-BE-NEXT:  .LBB5_1: // %loop
; CHECK-BE-NEXT:    // =>This Inner Loop Header: Depth=1
; CHECK-BE-NEXT:    ldp x10, x9, [x0]
; CHECK-BE-NEXT:    ldrb w16, [x0, #18]
; CHECK-BE-NEXT:    lsr x11, x9, #40
; CHECK-BE-NEXT:    ubfx x12, x9, #33, #7
; CHECK-BE-NEXT:    lsr x15, x10, #45
; CHECK-BE-NEXT:    lsr x13, x10, #40
; CHECK-BE-NEXT:    ubfx x14, x10, #26, #14
; CHECK-BE-NEXT:    orr w11, w12, w11, lsl #7
; CHECK-BE-NEXT:    ldrh w12, [x0, #16]
; CHECK-BE-NEXT:    fmov s0, w15
; CHECK-BE-NEXT:    orr w13, w14, w13, lsl #14
; CHECK-BE-NEXT:    ubfx x14, x9, #14, #18
; CHECK-BE-NEXT:    add x0, x0, #32
; CHECK-BE-NEXT:    fmov s1, w11
; CHECK-BE-NEXT:    orr w11, w16, w12, lsl #8
; CHECK-BE-NEXT:    lsl x12, x9, #24
; CHECK-BE-NEXT:    mov v0.s[1], w13
; CHECK-BE-NEXT:    ubfx x13, x10, #7, #25
; CHECK-BE-NEXT:    extr x9, x10, x9, #40
; CHECK-BE-NEXT:    orr w12, w11, w12
; CHECK-BE-NEXT:    mov v1.s[1], w14
; CHECK-BE-NEXT:    lsr w12, w12, #19
; CHECK-BE-NEXT:    ubfx x9, x9, #12, #20
; CHECK-BE-NEXT:    mov v0.s[2], w13
; CHECK-BE-NEXT:    mov v1.s[2], w12
; CHECK-BE-NEXT:    mov v0.s[3], w9
; CHECK-BE-NEXT:    add x9, x1, x8, lsl #3
; CHECK-BE-NEXT:    add x8, x8, #1
; CHECK-BE-NEXT:    cmp x8, #1000
; CHECK-BE-NEXT:    mov v1.s[3], w11
; CHECK-BE-NEXT:    uzp1 v0.8h, v0.8h, v1.8h
; CHECK-BE-NEXT:    xtn v0.8b, v0.8h
; CHECK-BE-NEXT:    st1 { v0.8b }, [x9]
; CHECK-BE-NEXT:    b.eq .LBB5_1
; CHECK-BE-NEXT:  // %bb.2: // %exit
; CHECK-BE-NEXT:    ret
;
; CHECK-DISABLE-LABEL: trunc_v8i19_to_v8i8_in_loop:
; CHECK-DISABLE:       // %bb.0: // %entry
; CHECK-DISABLE-NEXT:    mov x8, xzr
; CHECK-DISABLE-NEXT:  .LBB5_1: // %loop
; CHECK-DISABLE-NEXT:    // =>This Inner Loop Header: Depth=1
; CHECK-DISABLE-NEXT:    ldp x10, x9, [x0]
; CHECK-DISABLE-NEXT:    ldrb w16, [x0, #18]
; CHECK-DISABLE-NEXT:    lsr x11, x9, #40
; CHECK-DISABLE-NEXT:    ubfx x12, x9, #33, #7
; CHECK-DISABLE-NEXT:    lsr x15, x10, #45
; CHECK-DISABLE-NEXT:    lsr x13, x10, #40
; CHECK-DISABLE-NEXT:    ubfx x14, x10, #26, #14
; CHECK-DISABLE-NEXT:    orr w11, w12, w11, lsl #7
; CHECK-DISABLE-NEXT:    ldrh w12, [x0, #16]
; CHECK-DISABLE-NEXT:    fmov s0, w15
; CHECK-DISABLE-NEXT:    orr w13, w14, w13, lsl #14
; CHECK-DISABLE-NEXT:    ubfx x14, x9, #14, #18
; CHECK-DISABLE-NEXT:    add x0, x0, #32
; CHECK-DISABLE-NEXT:    fmov s1, w11
; CHECK-DISABLE-NEXT:    orr w11, w16, w12, lsl #8
; CHECK-DISABLE-NEXT:    lsl x12, x9, #24
; CHECK-DISABLE-NEXT:    mov v0.s[1], w13
; CHECK-DISABLE-NEXT:    ubfx x13, x10, #7, #25
; CHECK-DISABLE-NEXT:    extr x9, x10, x9, #40
; CHECK-DISABLE-NEXT:    orr w12, w11, w12
; CHECK-DISABLE-NEXT:    mov v1.s[1], w14
; CHECK-DISABLE-NEXT:    lsr w12, w12, #19
; CHECK-DISABLE-NEXT:    ubfx x9, x9, #12, #20
; CHECK-DISABLE-NEXT:    mov v0.s[2], w13
; CHECK-DISABLE-NEXT:    mov v1.s[2], w12
; CHECK-DISABLE-NEXT:    mov v0.s[3], w9
; CHECK-DISABLE-NEXT:    add x9, x1, x8, lsl #3
; CHECK-DISABLE-NEXT:    add x8, x8, #1
; CHECK-DISABLE-NEXT:    cmp x8, #1000
; CHECK-DISABLE-NEXT:    mov v1.s[3], w11
; CHECK-DISABLE-NEXT:    uzp1 v0.8h, v0.8h, v1.8h
; CHECK-DISABLE-NEXT:    xtn v0.8b, v0.8h
; CHECK-DISABLE-NEXT:    st1 { v0.8b }, [x9]
; CHECK-DISABLE-NEXT:    b.eq .LBB5_1
; CHECK-DISABLE-NEXT:  // %bb.2: // %exit
; CHECK-DISABLE-NEXT:    ret
entry:
  br label %loop

loop:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %loop ]
  %gep.A = getelementptr inbounds <8 x i19>, ptr %A, i64 %iv
  %l.A = load <8 x i19>, ptr %gep.A
  %trunc = trunc <8 x i19> %l.A to <8 x i8>
  %gep.dst = getelementptr inbounds <8 x i8>, ptr %dst, i64 %iv
  store <8 x i8> %trunc, ptr %gep.dst
  %iv.next = add i64 %iv, 1
  %ec = icmp eq i64 %iv.next, 1000
  br i1 %ec, label %loop, label %exit

exit:
  ret void
}

define void @trunc_v11i64_to_v11i8_in_loop(ptr %A, ptr %dst) {
; CHECK-LABEL: trunc_v11i64_to_v11i8_in_loop:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    mov w8, #1000 ; =0x3e8
; CHECK-NEXT:  LBB6_1: ; %loop
; CHECK-NEXT:    ; =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldp q4, q1, [x0, #48]
; CHECK-NEXT:    add x9, x1, #10
; CHECK-NEXT:    ldr d0, [x0, #80]
; CHECK-NEXT:    ldp q3, q2, [x0]
; CHECK-NEXT:    ldr q5, [x0, #32]
; CHECK-NEXT:    subs x8, x8, #1
; CHECK-NEXT:    add x0, x0, #128
; CHECK-NEXT:    uzp1.4s v0, v1, v0
; CHECK-NEXT:    uzp1.4s v1, v5, v4
; CHECK-NEXT:    uzp1.4s v2, v3, v2
; CHECK-NEXT:    xtn.4h v0, v0
; CHECK-NEXT:    uzp1.8h v1, v2, v1
; CHECK-NEXT:    uzp1.8b v2, v0, v0
; CHECK-NEXT:    uzp1.16b v0, v1, v0
; CHECK-NEXT:    st1.b { v2 }[2], [x9]
; CHECK-NEXT:    add x9, x1, #8
; CHECK-NEXT:    st1.h { v0 }[4], [x9]
; CHECK-NEXT:    str d0, [x1], #16
; CHECK-NEXT:    b.eq LBB6_1
; CHECK-NEXT:  ; %bb.2: ; %exit
; CHECK-NEXT:    ret
;
; CHECK-BE-LABEL: trunc_v11i64_to_v11i8_in_loop:
; CHECK-BE:       // %bb.0: // %entry
; CHECK-BE-NEXT:    mov w8, #1000 // =0x3e8
; CHECK-BE-NEXT:  .LBB6_1: // %loop
; CHECK-BE-NEXT:    // =>This Inner Loop Header: Depth=1
; CHECK-BE-NEXT:    add x9, x0, #64
; CHECK-BE-NEXT:    add x10, x0, #16
; CHECK-BE-NEXT:    ld1 { v3.2d }, [x0]
; CHECK-BE-NEXT:    ld1 { v0.2d }, [x9]
; CHECK-BE-NEXT:    add x9, x0, #48
; CHECK-BE-NEXT:    ld1 { v1.2d }, [x10]
; CHECK-BE-NEXT:    add x10, x0, #32
; CHECK-BE-NEXT:    ld1 { v2.2d }, [x9]
; CHECK-BE-NEXT:    ldr d5, [x0, #80]
; CHECK-BE-NEXT:    ld1 { v4.2d }, [x10]
; CHECK-BE-NEXT:    add x9, x1, #10
; CHECK-BE-NEXT:    subs x8, x8, #1
; CHECK-BE-NEXT:    uzp1 v1.4s, v3.4s, v1.4s
; CHECK-BE-NEXT:    uzp1 v0.4s, v0.4s, v5.4s
; CHECK-BE-NEXT:    add x0, x0, #128
; CHECK-BE-NEXT:    uzp1 v2.4s, v4.4s, v2.4s
; CHECK-BE-NEXT:    xtn v0.4h, v0.4s
; CHECK-BE-NEXT:    uzp1 v1.8h, v1.8h, v2.8h
; CHECK-BE-NEXT:    uzp1 v1.16b, v1.16b, v0.16b
; CHECK-BE-NEXT:    uzp1 v0.8b, v0.8b, v0.8b
; CHECK-BE-NEXT:    rev16 v2.16b, v1.16b
; CHECK-BE-NEXT:    rev64 v1.16b, v1.16b
; CHECK-BE-NEXT:    st1 { v0.b }[2], [x9]
; CHECK-BE-NEXT:    add x9, x1, #8
; CHECK-BE-NEXT:    st1 { v2.h }[4], [x9]
; CHECK-BE-NEXT:    str d1, [x1], #16
; CHECK-BE-NEXT:    b.eq .LBB6_1
; CHECK-BE-NEXT:  // %bb.2: // %exit
; CHECK-BE-NEXT:    ret
;
; CHECK-DISABLE-LABEL: trunc_v11i64_to_v11i8_in_loop:
; CHECK-DISABLE:       // %bb.0: // %entry
; CHECK-DISABLE-NEXT:    mov w8, #1000 // =0x3e8
; CHECK-DISABLE-NEXT:  .LBB6_1: // %loop
; CHECK-DISABLE-NEXT:    // =>This Inner Loop Header: Depth=1
; CHECK-DISABLE-NEXT:    add x9, x0, #64
; CHECK-DISABLE-NEXT:    add x10, x0, #16
; CHECK-DISABLE-NEXT:    ld1 { v3.2d }, [x0]
; CHECK-DISABLE-NEXT:    ld1 { v0.2d }, [x9]
; CHECK-DISABLE-NEXT:    add x9, x0, #48
; CHECK-DISABLE-NEXT:    ld1 { v1.2d }, [x10]
; CHECK-DISABLE-NEXT:    add x10, x0, #32
; CHECK-DISABLE-NEXT:    ld1 { v2.2d }, [x9]
; CHECK-DISABLE-NEXT:    ldr d5, [x0, #80]
; CHECK-DISABLE-NEXT:    ld1 { v4.2d }, [x10]
; CHECK-DISABLE-NEXT:    add x9, x1, #10
; CHECK-DISABLE-NEXT:    subs x8, x8, #1
; CHECK-DISABLE-NEXT:    uzp1 v1.4s, v3.4s, v1.4s
; CHECK-DISABLE-NEXT:    uzp1 v0.4s, v0.4s, v5.4s
; CHECK-DISABLE-NEXT:    add x0, x0, #128
; CHECK-DISABLE-NEXT:    uzp1 v2.4s, v4.4s, v2.4s
; CHECK-DISABLE-NEXT:    xtn v0.4h, v0.4s
; CHECK-DISABLE-NEXT:    uzp1 v1.8h, v1.8h, v2.8h
; CHECK-DISABLE-NEXT:    uzp1 v1.16b, v1.16b, v0.16b
; CHECK-DISABLE-NEXT:    uzp1 v0.8b, v0.8b, v0.8b
; CHECK-DISABLE-NEXT:    rev16 v2.16b, v1.16b
; CHECK-DISABLE-NEXT:    rev64 v1.16b, v1.16b
; CHECK-DISABLE-NEXT:    st1 { v0.b }[2], [x9]
; CHECK-DISABLE-NEXT:    add x9, x1, #8
; CHECK-DISABLE-NEXT:    st1 { v2.h }[4], [x9]
; CHECK-DISABLE-NEXT:    str d1, [x1], #16
; CHECK-DISABLE-NEXT:    b.eq .LBB6_1
; CHECK-DISABLE-NEXT:  // %bb.2: // %exit
; CHECK-DISABLE-NEXT:    ret
entry:
  br label %loop

loop:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %loop ]
  %gep.A = getelementptr inbounds <11 x i64>, ptr %A, i64 %iv
  %l.A = load <11 x i64>, ptr %gep.A
  %trunc = trunc <11 x i64> %l.A to <11 x i8>
  %gep.dst = getelementptr inbounds <11 x i8>, ptr %dst, i64 %iv
  store <11 x i8> %trunc, ptr %gep.dst
  %iv.next = add i64 %iv, 1
  %ec = icmp eq i64 %iv.next, 1000
  br i1 %ec, label %loop, label %exit

exit:
  ret void
}

define void @trunc_v16i16_to_v16i8_in_loop(ptr %A, ptr %dst) {
; CHECK-LABEL: trunc_v16i16_to_v16i8_in_loop:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    mov x8, xzr
; CHECK-NEXT:  LBB7_1: ; %loop
; CHECK-NEXT:    ; =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    add x9, x0, x8, lsl #5
; CHECK-NEXT:    ldp q1, q0, [x9]
; CHECK-NEXT:    uzp1.16b v0, v1, v0
; CHECK-NEXT:    str q0, [x1, x8, lsl #4]
; CHECK-NEXT:    add x8, x8, #1
; CHECK-NEXT:    cmp x8, #1000
; CHECK-NEXT:    b.eq LBB7_1
; CHECK-NEXT:  ; %bb.2: ; %exit
; CHECK-NEXT:    ret
;
; CHECK-BE-LABEL: trunc_v16i16_to_v16i8_in_loop:
; CHECK-BE:       // %bb.0: // %entry
; CHECK-BE-NEXT:    mov x8, xzr
; CHECK-BE-NEXT:  .LBB7_1: // %loop
; CHECK-BE-NEXT:    // =>This Inner Loop Header: Depth=1
; CHECK-BE-NEXT:    add x9, x0, x8, lsl #5
; CHECK-BE-NEXT:    add x10, x9, #16
; CHECK-BE-NEXT:    ld1 { v0.8h }, [x9]
; CHECK-BE-NEXT:    add x9, x1, x8, lsl #4
; CHECK-BE-NEXT:    ld1 { v1.8h }, [x10]
; CHECK-BE-NEXT:    add x8, x8, #1
; CHECK-BE-NEXT:    cmp x8, #1000
; CHECK-BE-NEXT:    uzp1 v0.16b, v0.16b, v1.16b
; CHECK-BE-NEXT:    st1 { v0.16b }, [x9]
; CHECK-BE-NEXT:    b.eq .LBB7_1
; CHECK-BE-NEXT:  // %bb.2: // %exit
; CHECK-BE-NEXT:    ret
;
; CHECK-DISABLE-LABEL: trunc_v16i16_to_v16i8_in_loop:
; CHECK-DISABLE:       // %bb.0: // %entry
; CHECK-DISABLE-NEXT:    mov x8, xzr
; CHECK-DISABLE-NEXT:  .LBB7_1: // %loop
; CHECK-DISABLE-NEXT:    // =>This Inner Loop Header: Depth=1
; CHECK-DISABLE-NEXT:    add x9, x0, x8, lsl #5
; CHECK-DISABLE-NEXT:    add x10, x9, #16
; CHECK-DISABLE-NEXT:    ld1 { v0.8h }, [x9]
; CHECK-DISABLE-NEXT:    add x9, x1, x8, lsl #4
; CHECK-DISABLE-NEXT:    ld1 { v1.8h }, [x10]
; CHECK-DISABLE-NEXT:    add x8, x8, #1
; CHECK-DISABLE-NEXT:    cmp x8, #1000
; CHECK-DISABLE-NEXT:    uzp1 v0.16b, v0.16b, v1.16b
; CHECK-DISABLE-NEXT:    st1 { v0.16b }, [x9]
; CHECK-DISABLE-NEXT:    b.eq .LBB7_1
; CHECK-DISABLE-NEXT:  // %bb.2: // %exit
; CHECK-DISABLE-NEXT:    ret
entry:
  br label %loop

loop:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %loop ]
  %gep.A = getelementptr inbounds <16 x i16>, ptr %A, i64 %iv
  %l.A = load <16 x i16>, ptr %gep.A
  %trunc = trunc <16 x i16> %l.A to <16 x i8>
  %gep.dst = getelementptr inbounds <16 x i8>, ptr %dst, i64 %iv
  store <16 x i8> %trunc, ptr %gep.dst
  %iv.next = add i64 %iv, 1
  %ec = icmp eq i64 %iv.next, 1000
  br i1 %ec, label %loop, label %exit

exit:
  ret void
}

define void @trunc_v8i16_to_v8i8_in_loop(ptr %A, ptr %dst) {
; CHECK-LABEL: trunc_v8i16_to_v8i8_in_loop:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    mov x8, xzr
; CHECK-NEXT:  LBB8_1: ; %loop
; CHECK-NEXT:    ; =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldr q0, [x0, x8, lsl #4]
; CHECK-NEXT:    xtn.8b v0, v0
; CHECK-NEXT:    str d0, [x1, x8, lsl #3]
; CHECK-NEXT:    add x8, x8, #1
; CHECK-NEXT:    cmp x8, #1000
; CHECK-NEXT:    b.eq LBB8_1
; CHECK-NEXT:  ; %bb.2: ; %exit
; CHECK-NEXT:    ret
;
; CHECK-BE-LABEL: trunc_v8i16_to_v8i8_in_loop:
; CHECK-BE:       // %bb.0: // %entry
; CHECK-BE-NEXT:    mov x8, xzr
; CHECK-BE-NEXT:  .LBB8_1: // %loop
; CHECK-BE-NEXT:    // =>This Inner Loop Header: Depth=1
; CHECK-BE-NEXT:    add x9, x0, x8, lsl #4
; CHECK-BE-NEXT:    ld1 { v0.8h }, [x9]
; CHECK-BE-NEXT:    add x9, x1, x8, lsl #3
; CHECK-BE-NEXT:    add x8, x8, #1
; CHECK-BE-NEXT:    cmp x8, #1000
; CHECK-BE-NEXT:    xtn v0.8b, v0.8h
; CHECK-BE-NEXT:    st1 { v0.8b }, [x9]
; CHECK-BE-NEXT:    b.eq .LBB8_1
; CHECK-BE-NEXT:  // %bb.2: // %exit
; CHECK-BE-NEXT:    ret
;
; CHECK-DISABLE-LABEL: trunc_v8i16_to_v8i8_in_loop:
; CHECK-DISABLE:       // %bb.0: // %entry
; CHECK-DISABLE-NEXT:    mov x8, xzr
; CHECK-DISABLE-NEXT:  .LBB8_1: // %loop
; CHECK-DISABLE-NEXT:    // =>This Inner Loop Header: Depth=1
; CHECK-DISABLE-NEXT:    add x9, x0, x8, lsl #4
; CHECK-DISABLE-NEXT:    ld1 { v0.8h }, [x9]
; CHECK-DISABLE-NEXT:    add x9, x1, x8, lsl #3
; CHECK-DISABLE-NEXT:    add x8, x8, #1
; CHECK-DISABLE-NEXT:    cmp x8, #1000
; CHECK-DISABLE-NEXT:    xtn v0.8b, v0.8h
; CHECK-DISABLE-NEXT:    st1 { v0.8b }, [x9]
; CHECK-DISABLE-NEXT:    b.eq .LBB8_1
; CHECK-DISABLE-NEXT:  // %bb.2: // %exit
; CHECK-DISABLE-NEXT:    ret
entry:
  br label %loop

loop:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %loop ]
  %gep.A = getelementptr inbounds <8 x i16>, ptr %A, i64 %iv
  %l.A = load <8 x i16>, ptr %gep.A
  %trunc = trunc <8 x i16> %l.A to <8 x i8>
  %gep.dst = getelementptr inbounds <8 x i8>, ptr %dst, i64 %iv
  store <8 x i8> %trunc, ptr %gep.dst
  %iv.next = add i64 %iv, 1
  %ec = icmp eq i64 %iv.next, 1000
  br i1 %ec, label %loop, label %exit

exit:
  ret void
}

