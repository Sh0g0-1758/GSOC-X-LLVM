; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64 -mattr=+sme < %s | FileCheck %s

declare void @private_za_callee()
declare float @llvm.cos.f32(float)

; Test lazy-save mechanism for a single callee.
define void @test_lazy_save_1_callee() nounwind "aarch64_inout_za" {
; CHECK-LABEL: test_lazy_save_1_callee:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x29, x30, [sp, #-16]! // 16-byte Folded Spill
; CHECK-NEXT:    mov x29, sp
; CHECK-NEXT:    sub sp, sp, #16
; CHECK-NEXT:    rdsvl x8, #1
; CHECK-NEXT:    mov x9, sp
; CHECK-NEXT:    msub x9, x8, x8, x9
; CHECK-NEXT:    mov sp, x9
; CHECK-NEXT:    sub x10, x29, #16
; CHECK-NEXT:    stur wzr, [x29, #-4]
; CHECK-NEXT:    sturh wzr, [x29, #-6]
; CHECK-NEXT:    stur x9, [x29, #-16]
; CHECK-NEXT:    sturh w8, [x29, #-8]
; CHECK-NEXT:    msr TPIDR2_EL0, x10
; CHECK-NEXT:    bl private_za_callee
; CHECK-NEXT:    smstart za
; CHECK-NEXT:    mrs x8, TPIDR2_EL0
; CHECK-NEXT:    sub x0, x29, #16
; CHECK-NEXT:    cbnz x8, .LBB0_2
; CHECK-NEXT:  // %bb.1:
; CHECK-NEXT:    bl __arm_tpidr2_restore
; CHECK-NEXT:  .LBB0_2:
; CHECK-NEXT:    msr TPIDR2_EL0, xzr
; CHECK-NEXT:    mov sp, x29
; CHECK-NEXT:    ldp x29, x30, [sp], #16 // 16-byte Folded Reload
; CHECK-NEXT:    ret
  call void @private_za_callee()
  ret void
}

; Test lazy-save mechanism for multiple callees.
define void @test_lazy_save_2_callees() nounwind "aarch64_inout_za" {
; CHECK-LABEL: test_lazy_save_2_callees:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x29, x30, [sp, #-32]! // 16-byte Folded Spill
; CHECK-NEXT:    stp x20, x19, [sp, #16] // 16-byte Folded Spill
; CHECK-NEXT:    mov x29, sp
; CHECK-NEXT:    sub sp, sp, #16
; CHECK-NEXT:    rdsvl x19, #1
; CHECK-NEXT:    mov x8, sp
; CHECK-NEXT:    msub x8, x19, x19, x8
; CHECK-NEXT:    mov sp, x8
; CHECK-NEXT:    sub x20, x29, #16
; CHECK-NEXT:    stur wzr, [x29, #-4]
; CHECK-NEXT:    sturh wzr, [x29, #-6]
; CHECK-NEXT:    stur x8, [x29, #-16]
; CHECK-NEXT:    sturh w19, [x29, #-8]
; CHECK-NEXT:    msr TPIDR2_EL0, x20
; CHECK-NEXT:    bl private_za_callee
; CHECK-NEXT:    smstart za
; CHECK-NEXT:    mrs x8, TPIDR2_EL0
; CHECK-NEXT:    sub x0, x29, #16
; CHECK-NEXT:    cbnz x8, .LBB1_2
; CHECK-NEXT:  // %bb.1:
; CHECK-NEXT:    bl __arm_tpidr2_restore
; CHECK-NEXT:  .LBB1_2:
; CHECK-NEXT:    msr TPIDR2_EL0, xzr
; CHECK-NEXT:    sturh w19, [x29, #-8]
; CHECK-NEXT:    msr TPIDR2_EL0, x20
; CHECK-NEXT:    bl private_za_callee
; CHECK-NEXT:    smstart za
; CHECK-NEXT:    mrs x8, TPIDR2_EL0
; CHECK-NEXT:    sub x0, x29, #16
; CHECK-NEXT:    cbnz x8, .LBB1_4
; CHECK-NEXT:  // %bb.3:
; CHECK-NEXT:    bl __arm_tpidr2_restore
; CHECK-NEXT:  .LBB1_4:
; CHECK-NEXT:    msr TPIDR2_EL0, xzr
; CHECK-NEXT:    mov sp, x29
; CHECK-NEXT:    ldp x20, x19, [sp, #16] // 16-byte Folded Reload
; CHECK-NEXT:    ldp x29, x30, [sp], #32 // 16-byte Folded Reload
; CHECK-NEXT:    ret
  call void @private_za_callee()
  call void @private_za_callee()
  ret void
}

; Test a call of an intrinsic that gets expanded to a library call.
define float @test_lazy_save_expanded_intrinsic(float %a) nounwind "aarch64_inout_za" {
; CHECK-LABEL: test_lazy_save_expanded_intrinsic:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x29, x30, [sp, #-16]! // 16-byte Folded Spill
; CHECK-NEXT:    mov x29, sp
; CHECK-NEXT:    sub sp, sp, #16
; CHECK-NEXT:    rdsvl x8, #1
; CHECK-NEXT:    mov x9, sp
; CHECK-NEXT:    msub x9, x8, x8, x9
; CHECK-NEXT:    mov sp, x9
; CHECK-NEXT:    sub x10, x29, #16
; CHECK-NEXT:    stur wzr, [x29, #-4]
; CHECK-NEXT:    sturh wzr, [x29, #-6]
; CHECK-NEXT:    stur x9, [x29, #-16]
; CHECK-NEXT:    sturh w8, [x29, #-8]
; CHECK-NEXT:    msr TPIDR2_EL0, x10
; CHECK-NEXT:    bl cosf
; CHECK-NEXT:    smstart za
; CHECK-NEXT:    mrs x8, TPIDR2_EL0
; CHECK-NEXT:    sub x0, x29, #16
; CHECK-NEXT:    cbnz x8, .LBB2_2
; CHECK-NEXT:  // %bb.1:
; CHECK-NEXT:    bl __arm_tpidr2_restore
; CHECK-NEXT:  .LBB2_2:
; CHECK-NEXT:    msr TPIDR2_EL0, xzr
; CHECK-NEXT:    mov sp, x29
; CHECK-NEXT:    ldp x29, x30, [sp], #16 // 16-byte Folded Reload
; CHECK-NEXT:    ret
  %res = call float @llvm.cos.f32(float %a)
  ret float %res
}

; Test a combination of streaming-compatible -> normal call with lazy-save.
define void @test_lazy_save_and_conditional_smstart() nounwind "aarch64_inout_za" "aarch64_pstate_sm_compatible" {
; CHECK-LABEL: test_lazy_save_and_conditional_smstart:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp d15, d14, [sp, #-96]! // 16-byte Folded Spill
; CHECK-NEXT:    stp d13, d12, [sp, #16] // 16-byte Folded Spill
; CHECK-NEXT:    stp d11, d10, [sp, #32] // 16-byte Folded Spill
; CHECK-NEXT:    stp d9, d8, [sp, #48] // 16-byte Folded Spill
; CHECK-NEXT:    stp x29, x30, [sp, #64] // 16-byte Folded Spill
; CHECK-NEXT:    add x29, sp, #64
; CHECK-NEXT:    str x19, [sp, #80] // 8-byte Folded Spill
; CHECK-NEXT:    sub sp, sp, #16
; CHECK-NEXT:    rdsvl x8, #1
; CHECK-NEXT:    mov x9, sp
; CHECK-NEXT:    msub x9, x8, x8, x9
; CHECK-NEXT:    mov sp, x9
; CHECK-NEXT:    sub x10, x29, #80
; CHECK-NEXT:    stur wzr, [x29, #-68]
; CHECK-NEXT:    sturh wzr, [x29, #-70]
; CHECK-NEXT:    stur x9, [x29, #-80]
; CHECK-NEXT:    sturh w8, [x29, #-72]
; CHECK-NEXT:    msr TPIDR2_EL0, x10
; CHECK-NEXT:    bl __arm_sme_state
; CHECK-NEXT:    and x19, x0, #0x1
; CHECK-NEXT:    tbz w19, #0, .LBB3_2
; CHECK-NEXT:  // %bb.1:
; CHECK-NEXT:    smstop sm
; CHECK-NEXT:  .LBB3_2:
; CHECK-NEXT:    bl private_za_callee
; CHECK-NEXT:    tbz w19, #0, .LBB3_4
; CHECK-NEXT:  // %bb.3:
; CHECK-NEXT:    smstart sm
; CHECK-NEXT:  .LBB3_4:
; CHECK-NEXT:    smstart za
; CHECK-NEXT:    mrs x8, TPIDR2_EL0
; CHECK-NEXT:    sub x0, x29, #80
; CHECK-NEXT:    cbnz x8, .LBB3_6
; CHECK-NEXT:  // %bb.5:
; CHECK-NEXT:    bl __arm_tpidr2_restore
; CHECK-NEXT:  .LBB3_6:
; CHECK-NEXT:    msr TPIDR2_EL0, xzr
; CHECK-NEXT:    sub sp, x29, #64
; CHECK-NEXT:    ldp x29, x30, [sp, #64] // 16-byte Folded Reload
; CHECK-NEXT:    ldr x19, [sp, #80] // 8-byte Folded Reload
; CHECK-NEXT:    ldp d9, d8, [sp, #48] // 16-byte Folded Reload
; CHECK-NEXT:    ldp d11, d10, [sp, #32] // 16-byte Folded Reload
; CHECK-NEXT:    ldp d13, d12, [sp, #16] // 16-byte Folded Reload
; CHECK-NEXT:    ldp d15, d14, [sp], #96 // 16-byte Folded Reload
; CHECK-NEXT:    ret
  call void @private_za_callee()
  ret void
}
