; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i386-apple-darwin -mattr=+mmx | FileCheck %s --check-prefix=X86-32
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mattr=+mmx,+sse2 | FileCheck %s --check-prefix=X86-64
;
; On Darwin x86-32, v8i8, v4i16, v2i32 values are passed in MM[0-2].
; On Darwin x86-32, v1i64 values are passed in memory.  In this example, they
;                   are never moved into an MM register at all.
; On Darwin x86-64, v8i8, v4i16, v2i32 values are passed in XMM[0-7].
; On Darwin x86-64, v1i64 values are passed in 64-bit GPRs.

@u1 = external global x86_mmx

define void @t1(x86_mmx %v1) nounwind  {
; X86-32-LABEL: t1:
; X86-32:       ## %bb.0:
; X86-32-NEXT:    movl L_u1$non_lazy_ptr, %eax
; X86-32-NEXT:    movq %mm0, (%eax)
; X86-32-NEXT:    retl
;
; X86-64-LABEL: t1:
; X86-64:       ## %bb.0:
; X86-64-NEXT:    movdq2q %xmm0, %mm0
; X86-64-NEXT:    movq _u1@GOTPCREL(%rip), %rax
; X86-64-NEXT:    movq %mm0, (%rax)
; X86-64-NEXT:    retq
	store x86_mmx %v1, ptr @u1, align 8
	ret void
}

@u2 = external global x86_mmx

define void @t2(<1 x i64> %v1) nounwind  {
; X86-32-LABEL: t2:
; X86-32:       ## %bb.0:
; X86-32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-32-NEXT:    movl L_u2$non_lazy_ptr, %edx
; X86-32-NEXT:    movl %ecx, 4(%edx)
; X86-32-NEXT:    movl %eax, (%edx)
; X86-32-NEXT:    retl
;
; X86-64-LABEL: t2:
; X86-64:       ## %bb.0:
; X86-64-NEXT:    movq _u2@GOTPCREL(%rip), %rax
; X86-64-NEXT:    movq %rdi, (%rax)
; X86-64-NEXT:    retq
        %tmp = bitcast <1 x i64> %v1 to x86_mmx
	store x86_mmx %tmp, ptr @u2, align 8
	ret void
}
