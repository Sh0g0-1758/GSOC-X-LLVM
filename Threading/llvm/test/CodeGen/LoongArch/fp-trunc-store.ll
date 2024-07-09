; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc --mtriple=loongarch32 --mattr=+f,-d < %s | FileCheck %s --check-prefix=LA32F
; RUN: llc --mtriple=loongarch32 --mattr=+d < %s | FileCheck %s --check-prefix=LA32D
; RUN: llc --mtriple=loongarch64 --mattr=+f,-d < %s | FileCheck %s --check-prefix=LA64F
; RUN: llc --mtriple=loongarch64 --mattr=+d < %s | FileCheck %s --check-prefix=LA64D

define void @fp_trunc(ptr %a, double %b) nounwind {
; LA32F-LABEL: fp_trunc:
; LA32F:       # %bb.0:
; LA32F-NEXT:    addi.w $sp, $sp, -16
; LA32F-NEXT:    st.w $ra, $sp, 12 # 4-byte Folded Spill
; LA32F-NEXT:    st.w $fp, $sp, 8 # 4-byte Folded Spill
; LA32F-NEXT:    move $fp, $a0
; LA32F-NEXT:    move $a0, $a1
; LA32F-NEXT:    move $a1, $a2
; LA32F-NEXT:    bl %plt(__truncdfsf2)
; LA32F-NEXT:    fst.s $fa0, $fp, 0
; LA32F-NEXT:    ld.w $fp, $sp, 8 # 4-byte Folded Reload
; LA32F-NEXT:    ld.w $ra, $sp, 12 # 4-byte Folded Reload
; LA32F-NEXT:    addi.w $sp, $sp, 16
; LA32F-NEXT:    ret
;
; LA32D-LABEL: fp_trunc:
; LA32D:       # %bb.0:
; LA32D-NEXT:    fcvt.s.d $fa0, $fa0
; LA32D-NEXT:    fst.s $fa0, $a0, 0
; LA32D-NEXT:    ret
;
; LA64F-LABEL: fp_trunc:
; LA64F:       # %bb.0:
; LA64F-NEXT:    addi.d $sp, $sp, -16
; LA64F-NEXT:    st.d $ra, $sp, 8 # 8-byte Folded Spill
; LA64F-NEXT:    st.d $fp, $sp, 0 # 8-byte Folded Spill
; LA64F-NEXT:    move $fp, $a0
; LA64F-NEXT:    move $a0, $a1
; LA64F-NEXT:    bl %plt(__truncdfsf2)
; LA64F-NEXT:    fst.s $fa0, $fp, 0
; LA64F-NEXT:    ld.d $fp, $sp, 0 # 8-byte Folded Reload
; LA64F-NEXT:    ld.d $ra, $sp, 8 # 8-byte Folded Reload
; LA64F-NEXT:    addi.d $sp, $sp, 16
; LA64F-NEXT:    ret
;
; LA64D-LABEL: fp_trunc:
; LA64D:       # %bb.0:
; LA64D-NEXT:    fcvt.s.d $fa0, $fa0
; LA64D-NEXT:    fst.s $fa0, $a0, 0
; LA64D-NEXT:    ret
  %1 = fptrunc double %b to float
  store float %1, ptr %a, align 4
  ret void
}