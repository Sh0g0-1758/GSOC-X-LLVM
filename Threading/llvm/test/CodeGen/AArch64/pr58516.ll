; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-pc-windows-msvc %s -o - | FileCheck %s


$osfx = comdat any

declare dso_local i32 @__CxxFrameHandler3(...)

define void @osfx(ptr %this) comdat personality ptr @__CxxFrameHandler3 {
; CHECK-LABEL: osfx:
; CHECK:       .Lfunc_begin0:
; CHECK-NEXT:  .seh_proc osfx
; CHECK-NEXT:    .seh_handler __CxxFrameHandler3, @unwind, @except
; CHECK-NEXT:  // %bb.0: // %invoke.cont
; CHECK-NEXT:    stp x19, x20, [sp, #-64]! // 16-byte Folded Spill
; CHECK-NEXT:    .seh_save_regp_x x19, 64
; CHECK-NEXT:    str x21, [sp, #16] // 8-byte Folded Spill
; CHECK-NEXT:    .seh_save_reg x21, 16
; CHECK-NEXT:    stp x29, x30, [sp, #24] // 16-byte Folded Spill
; CHECK-NEXT:    .seh_save_fplr 24
; CHECK-NEXT:    add x29, sp, #24
; CHECK-NEXT:    .seh_add_fp 24
; CHECK-NEXT:    .seh_endprologue
; CHECK-NEXT:    sub x9, sp, #32
; CHECK-NEXT:    and sp, x9, #0xffffffffffffffe0
; CHECK-NEXT:    mov x19, sp
; CHECK-NEXT:    mov x1, #-2 // =0xfffffffffffffffe
; CHECK-NEXT:    mov x20, x0
; CHECK-NEXT:    add x8, x19, #0
; CHECK-NEXT:    stur x1, [x29, #24]
; CHECK-NEXT:    lsr x21, x8, #3
; CHECK-NEXT:    adrp x8, osfx
; CHECK-NEXT:    add x8, x8, :lo12:osfx
; CHECK-NEXT:    str x8, [x0]
; CHECK-NEXT:    str wzr, [x21]
; CHECK-NEXT:    ldr x0, [x0]
; CHECK-NEXT:  .Ltmp0:
; CHECK-NEXT:    blr x0
; CHECK-NEXT:  .Ltmp1:
; CHECK-NEXT:  // %bb.1: // %invoke.cont12
; CHECK-NEXT:    str wzr, [x20]
; CHECK-NEXT:    str wzr, [x21]
; CHECK-NEXT:  .LBB0_2: // %try.cont
; CHECK-NEXT:  $ehgcr_0_2:
; CHECK-NEXT:    .seh_startepilogue
; CHECK-NEXT:    sub sp, x29, #24
; CHECK-NEXT:    .seh_add_fp 24
; CHECK-NEXT:    ldp x29, x30, [sp, #24] // 16-byte Folded Reload
; CHECK-NEXT:    .seh_save_fplr 24
; CHECK-NEXT:    ldr x21, [sp, #16] // 8-byte Folded Reload
; CHECK-NEXT:    .seh_save_reg x21, 16
; CHECK-NEXT:    ldp x19, x20, [sp], #64 // 16-byte Folded Reload
; CHECK-NEXT:    .seh_save_regp_x x19, 64
; CHECK-NEXT:    .seh_endepilogue
; CHECK-NEXT:    ret
; CHECK-NEXT:    .seh_endfunclet
; CHECK-NEXT:    .seh_handlerdata
; CHECK-NEXT:    .word ($cppxdata$osfx)@IMGREL
; CHECK-NEXT:    .section .text,"xr",discard,osfx
; CHECK-NEXT:    .seh_endproc
; CHECK-NEXT:    .def "?catch$3@?0?osfx@4HA";
; CHECK-NEXT:    .scl 3;
; CHECK-NEXT:    .type 32;
; CHECK-NEXT:    .endef
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  "?catch$3@?0?osfx@4HA":
; CHECK-NEXT:  .seh_proc "?catch$3@?0?osfx@4HA"
; CHECK-NEXT:    .seh_handler __CxxFrameHandler3, @unwind, @except
; CHECK-NEXT:  .LBB0_3: // %catch
; CHECK-NEXT:    stp x19, x20, [sp, #-48]! // 16-byte Folded Spill
; CHECK-NEXT:    .seh_save_regp_x x19, 48
; CHECK-NEXT:    str x21, [sp, #16] // 8-byte Folded Spill
; CHECK-NEXT:    .seh_save_reg x21, 16
; CHECK-NEXT:    stp x29, x30, [sp, #24] // 16-byte Folded Spill
; CHECK-NEXT:    .seh_save_fplr 24
; CHECK-NEXT:    .seh_endprologue
; CHECK-NEXT:    adrp x0, .LBB0_2
; CHECK-NEXT:    add x0, x0, .LBB0_2
; CHECK-NEXT:    .seh_startepilogue
; CHECK-NEXT:    ldp x29, x30, [sp, #24] // 16-byte Folded Reload
; CHECK-NEXT:    .seh_save_fplr 24
; CHECK-NEXT:    ldr x21, [sp, #16] // 8-byte Folded Reload
; CHECK-NEXT:    .seh_save_reg x21, 16
; CHECK-NEXT:    ldp x19, x20, [sp], #48 // 16-byte Folded Reload
; CHECK-NEXT:    .seh_save_regp_x x19, 48
; CHECK-NEXT:    .seh_endepilogue
; CHECK-NEXT:    ret
invoke.cont:
  %MyAlloca2 = alloca [32 x i8], align 32
  %0 = ptrtoint ptr %MyAlloca2 to i64
  store i64 ptrtoint (ptr @osfx to i64), ptr %this
  %1 = lshr exact i64 %0, 3
  %2 = inttoptr i64 %1 to ptr
  store i32 0, ptr %2
  %vbtable = load ptr, ptr %this
  %call.i21 = invoke noundef i32 %vbtable(ptr %vbtable)
          to label %invoke.cont12 unwind label %catch.dispatch

invoke.cont12:                                    ; preds = %invoke.cont
  store i32 0, ptr %this
  store i32 0, ptr %2
  br label %try.cont

catch.dispatch:                                   ; preds = %invoke.cont
  %3 = catchswitch within none [label %catch] unwind to caller

catch:                                            ; preds = %catch.dispatch
  %4 = catchpad within %3 [ptr null, i32 64, ptr null]
  catchret from %4 to label %try.cont

try.cont:                                         ; preds = %catch, %invoke.cont12
  ret void
}
