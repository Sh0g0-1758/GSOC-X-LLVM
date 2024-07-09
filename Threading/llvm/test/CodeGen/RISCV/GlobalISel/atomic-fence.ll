; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -global-isel -verify-machineinstrs < %s \
; RUN:   | FileCheck --check-prefixes=CHECK,WMO %s
; RUN: llc -mtriple=riscv32 -mattr=+a -global-isel -verify-machineinstrs < %s \
; RUN:   | FileCheck --check-prefixes=CHECK,WMO %s
; RUN: llc -mtriple=riscv32 -mattr=+a,+experimental-ztso -global-isel -verify-machineinstrs < %s \
; RUN:   | FileCheck --check-prefixes=CHECK,TSO %s
; RUN: llc -mtriple=riscv64 -global-isel -verify-machineinstrs < %s \
; RUN:   | FileCheck --check-prefixes=CHECK,WMO %s
; RUN: llc -mtriple=riscv64 -mattr=+a -global-isel -verify-machineinstrs < %s \
; RUN:   | FileCheck --check-prefixes=CHECK,WMO %s
; RUN: llc -mtriple=riscv64 -mattr=+a,+experimental-ztso -global-isel -verify-machineinstrs < %s \
; RUN:   | FileCheck --check-prefixes=CHECK,TSO %s

define void @fence_acquire() nounwind {
; WMO-LABEL: fence_acquire:
; WMO:       # %bb.0:
; WMO-NEXT:    fence r, rw
; WMO-NEXT:    ret
;
; TSO-LABEL: fence_acquire:
; TSO:       # %bb.0:
; TSO-NEXT:    #MEMBARRIER
; TSO-NEXT:    ret
  fence acquire
  ret void
}

define void @fence_release() nounwind {
; WMO-LABEL: fence_release:
; WMO:       # %bb.0:
; WMO-NEXT:    fence rw, w
; WMO-NEXT:    ret
;
; TSO-LABEL: fence_release:
; TSO:       # %bb.0:
; TSO-NEXT:    #MEMBARRIER
; TSO-NEXT:    ret
  fence release
  ret void
}

define void @fence_acq_rel() nounwind {
; WMO-LABEL: fence_acq_rel:
; WMO:       # %bb.0:
; WMO-NEXT:    fence.tso
; WMO-NEXT:    ret
;
; TSO-LABEL: fence_acq_rel:
; TSO:       # %bb.0:
; TSO-NEXT:    #MEMBARRIER
; TSO-NEXT:    ret
  fence acq_rel
  ret void
}

define void @fence_seq_cst() nounwind {
; CHECK-LABEL: fence_seq_cst:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fence rw, rw
; CHECK-NEXT:    ret
  fence seq_cst
  ret void
}

define void @fence_singlethread_acquire() nounwind {
; CHECK-LABEL: fence_singlethread_acquire:
; CHECK:       # %bb.0:
; CHECK-NEXT:    #MEMBARRIER
; CHECK-NEXT:    ret
  fence syncscope("singlethread") acquire
  ret void
}

define void @fence_singlethread_release() nounwind {
; CHECK-LABEL: fence_singlethread_release:
; CHECK:       # %bb.0:
; CHECK-NEXT:    #MEMBARRIER
; CHECK-NEXT:    ret
  fence syncscope("singlethread") release
  ret void
}

define void @fence_singlethread_acq_rel() nounwind {
; CHECK-LABEL: fence_singlethread_acq_rel:
; CHECK:       # %bb.0:
; CHECK-NEXT:    #MEMBARRIER
; CHECK-NEXT:    ret
  fence syncscope("singlethread") acq_rel
  ret void
}

define void @fence_singlethread_seq_cst() nounwind {
; CHECK-LABEL: fence_singlethread_seq_cst:
; CHECK:       # %bb.0:
; CHECK-NEXT:    #MEMBARRIER
; CHECK-NEXT:    ret
  fence syncscope("singlethread") seq_cst
  ret void
}
