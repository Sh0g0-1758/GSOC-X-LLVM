; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 2
; RUN: llc < %s -mtriple=riscv32 -target-abi=ilp32f -mattr=+zfa \
; RUN:   | FileCheck %s --check-prefix=RV32
; RUN: llc < %s -mtriple=riscv64 -target-abi=lp64f -mattr=+zfa \
; RUN:   | FileCheck %s --check-prefix=RV64

; The purpose of this test is to check that an FLI instruction that
; materializes an immediate is not MachineLICM'd out of a loop.

%struct.Node = type { ptr, ptr }

define void @process_nodes(ptr %0) nounwind {
; RV32-LABEL: process_nodes:
; RV32:       # %bb.0: # %entry
; RV32-NEXT:    beqz a0, .LBB0_4
; RV32-NEXT:  # %bb.1: # %loop.preheader
; RV32-NEXT:    addi sp, sp, -16
; RV32-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32-NEXT:    sw s0, 8(sp) # 4-byte Folded Spill
; RV32-NEXT:    mv s0, a0
; RV32-NEXT:  .LBB0_2: # %loop
; RV32-NEXT:    # =>This Inner Loop Header: Depth=1
; RV32-NEXT:    fli.s fa0, 1.0
; RV32-NEXT:    mv a0, s0
; RV32-NEXT:    call do_it
; RV32-NEXT:    lw s0, 0(s0)
; RV32-NEXT:    bnez s0, .LBB0_2
; RV32-NEXT:  # %bb.3:
; RV32-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32-NEXT:    lw s0, 8(sp) # 4-byte Folded Reload
; RV32-NEXT:    addi sp, sp, 16
; RV32-NEXT:  .LBB0_4: # %exit
; RV32-NEXT:    ret
;
; RV64-LABEL: process_nodes:
; RV64:       # %bb.0: # %entry
; RV64-NEXT:    beqz a0, .LBB0_4
; RV64-NEXT:  # %bb.1: # %loop.preheader
; RV64-NEXT:    addi sp, sp, -16
; RV64-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64-NEXT:    sd s0, 0(sp) # 8-byte Folded Spill
; RV64-NEXT:    mv s0, a0
; RV64-NEXT:  .LBB0_2: # %loop
; RV64-NEXT:    # =>This Inner Loop Header: Depth=1
; RV64-NEXT:    fli.s fa0, 1.0
; RV64-NEXT:    mv a0, s0
; RV64-NEXT:    call do_it
; RV64-NEXT:    ld s0, 0(s0)
; RV64-NEXT:    bnez s0, .LBB0_2
; RV64-NEXT:  # %bb.3:
; RV64-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64-NEXT:    ld s0, 0(sp) # 8-byte Folded Reload
; RV64-NEXT:    addi sp, sp, 16
; RV64-NEXT:  .LBB0_4: # %exit
; RV64-NEXT:    ret
entry:
  %1 = icmp eq ptr %0, null
  br i1 %1, label %exit, label %loop

loop:
  %2 = phi ptr [ %4, %loop ], [ %0, %entry ]
  tail call void @do_it(float 1.000000e+00, ptr nonnull %2)
  %3 = getelementptr inbounds %struct.Node, ptr %2, i64 0, i32 0
  %4 = load ptr, ptr %3, align 8
  %5 = icmp eq ptr %4, null
  br i1 %5, label %exit, label %loop

exit:
  ret void
}

declare void @do_it(float, ptr)
