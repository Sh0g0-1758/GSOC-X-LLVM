; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-linux-gnu | FileCheck %s
; RUN: llc < %s --global-isel=1 -mtriple=aarch64-apple-darwin | FileCheck %s --check-prefix=DARWIN

define win64cc void @pass_va(i32 %count, ...) nounwind {
; CHECK-LABEL: pass_va:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    sub sp, sp, #96
; CHECK-NEXT:    add x8, sp, #40
; CHECK-NEXT:    add x0, sp, #40
; CHECK-NEXT:    stp x30, x18, [sp, #16] // 16-byte Folded Spill
; CHECK-NEXT:    stp x1, x2, [sp, #40]
; CHECK-NEXT:    stp x3, x4, [sp, #56]
; CHECK-NEXT:    stp x5, x6, [sp, #72]
; CHECK-NEXT:    str x7, [sp, #88]
; CHECK-NEXT:    str x8, [sp, #8]
; CHECK-NEXT:    bl other_func
; CHECK-NEXT:    ldp x30, x18, [sp, #16] // 16-byte Folded Reload
; CHECK-NEXT:    add sp, sp, #96
; CHECK-NEXT:    ret
;
; DARWIN-LABEL: pass_va:
; DARWIN:       ; %bb.0: ; %entry
; DARWIN-NEXT:    str x18, [sp, #-96]! ; 8-byte Folded Spill
; DARWIN-NEXT:    add x8, sp, #8
; DARWIN-NEXT:    add x9, sp, #40
; DARWIN-NEXT:    stp x29, x30, [sp, #16] ; 16-byte Folded Spill
; DARWIN-NEXT:    str x9, [x8]
; DARWIN-NEXT:    ldr x0, [sp, #8]
; DARWIN-NEXT:    stp x1, x2, [sp, #40]
; DARWIN-NEXT:    stp x3, x4, [sp, #56]
; DARWIN-NEXT:    stp x5, x6, [sp, #72]
; DARWIN-NEXT:    str x7, [sp, #88]
; DARWIN-NEXT:    bl _other_func
; DARWIN-NEXT:    ldp x29, x30, [sp, #16] ; 16-byte Folded Reload
; DARWIN-NEXT:    ldr x18, [sp], #96 ; 8-byte Folded Reload
; DARWIN-NEXT:    ret
entry:
  %ap = alloca ptr, align 8
  call void @llvm.va_start(ptr %ap)
  %ap2 = load ptr, ptr %ap, align 8
  call void @other_func(ptr %ap2)
  ret void
}

declare void @other_func(ptr) local_unnamed_addr

declare void @llvm.va_start(ptr) nounwind
declare void @llvm.va_copy(ptr, ptr) nounwind

define win64cc ptr @f9(i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, i64 %a8, ...) nounwind {
; CHECK-LABEL: f9:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    str x18, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    add x8, sp, #24
; CHECK-NEXT:    add x0, sp, #24
; CHECK-NEXT:    str x8, [sp, #8]
; CHECK-NEXT:    ldr x18, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
;
; DARWIN-LABEL: f9:
; DARWIN:       ; %bb.0: ; %entry
; DARWIN-NEXT:    str x18, [sp, #-16]! ; 8-byte Folded Spill
; DARWIN-NEXT:    add x8, sp, #8
; DARWIN-NEXT:    add x9, sp, #24
; DARWIN-NEXT:    str x9, [x8]
; DARWIN-NEXT:    ldr x0, [sp, #8]
; DARWIN-NEXT:    ldr x18, [sp], #16 ; 8-byte Folded Reload
; DARWIN-NEXT:    ret
entry:
  %ap = alloca ptr, align 8
  call void @llvm.va_start(ptr %ap)
  %ap2 = load ptr, ptr %ap, align 8
  ret ptr %ap2
}

define win64cc ptr @f8(i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ...) nounwind {
; CHECK-LABEL: f8:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    str x18, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    add x8, sp, #16
; CHECK-NEXT:    add x0, sp, #16
; CHECK-NEXT:    str x8, [sp, #8]
; CHECK-NEXT:    ldr x18, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
;
; DARWIN-LABEL: f8:
; DARWIN:       ; %bb.0: ; %entry
; DARWIN-NEXT:    str x18, [sp, #-16]! ; 8-byte Folded Spill
; DARWIN-NEXT:    add x8, sp, #8
; DARWIN-NEXT:    add x9, sp, #16
; DARWIN-NEXT:    str x9, [x8]
; DARWIN-NEXT:    ldr x0, [sp, #8]
; DARWIN-NEXT:    ldr x18, [sp], #16 ; 8-byte Folded Reload
; DARWIN-NEXT:    ret
entry:
  %ap = alloca ptr, align 8
  call void @llvm.va_start(ptr %ap)
  %ap2 = load ptr, ptr %ap, align 8
  ret ptr %ap2
}

define win64cc ptr @f7(i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, ...) nounwind {
; CHECK-LABEL: f7:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    str x18, [sp, #-32]! // 8-byte Folded Spill
; CHECK-NEXT:    add x8, sp, #24
; CHECK-NEXT:    add x0, sp, #24
; CHECK-NEXT:    str x7, [sp, #24]
; CHECK-NEXT:    str x8, [sp, #8]
; CHECK-NEXT:    ldr x18, [sp], #32 // 8-byte Folded Reload
; CHECK-NEXT:    ret
;
; DARWIN-LABEL: f7:
; DARWIN:       ; %bb.0: ; %entry
; DARWIN-NEXT:    str x18, [sp, #-32]! ; 8-byte Folded Spill
; DARWIN-NEXT:    add x8, sp, #8
; DARWIN-NEXT:    add x9, sp, #24
; DARWIN-NEXT:    str x7, [sp, #24]
; DARWIN-NEXT:    str x9, [x8]
; DARWIN-NEXT:    ldr x0, [sp, #8]
; DARWIN-NEXT:    ldr x18, [sp], #32 ; 8-byte Folded Reload
; DARWIN-NEXT:    ret
entry:
  %ap = alloca ptr, align 8
  call void @llvm.va_start(ptr %ap)
  %ap2 = load ptr, ptr %ap, align 8
  ret ptr %ap2
}
