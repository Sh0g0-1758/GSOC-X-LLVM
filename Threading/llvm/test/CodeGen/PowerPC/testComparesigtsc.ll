; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -relocation-model=pic -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu -O2 \
; RUN:   -ppc-gpr-icmps=all -ppc-asm-full-reg-names -mcpu=pwr8 < %s | FileCheck %s \
; RUN:   --implicit-check-not cmpw --implicit-check-not cmpd --implicit-check-not cmpl
; RUN: llc -relocation-model=pic -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu -O2 \
; RUN:   -ppc-gpr-icmps=all -ppc-asm-full-reg-names -mcpu=pwr8 < %s | FileCheck %s \
; RUN:   --implicit-check-not cmpw --implicit-check-not cmpd --implicit-check-not cmpl

@glob = local_unnamed_addr global i8 0, align 1

; Function Attrs: norecurse nounwind readnone
define signext i32 @test_igtsc(i8 signext %a, i8 signext %b) {
; CHECK-LABEL: test_igtsc:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sub r3, r4, r3
; CHECK-NEXT:    rldicl r3, r3, 1, 63
; CHECK-NEXT:    blr
entry:
  %cmp = icmp sgt i8 %a, %b
  %conv2 = zext i1 %cmp to i32
  ret i32 %conv2
}

; Function Attrs: norecurse nounwind readnone
define signext i32 @test_igtsc_sext(i8 signext %a, i8 signext %b) {
; CHECK-LABEL: test_igtsc_sext:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sub r3, r4, r3
; CHECK-NEXT:    sradi r3, r3, 63
; CHECK-NEXT:    blr
entry:
  %cmp = icmp sgt i8 %a, %b
  %sub = sext i1 %cmp to i32
  ret i32 %sub
}

; FIXME
; Function Attrs: norecurse nounwind readnone
define signext i32 @test_igtsc_z(i8 signext %a) {
; CHECK-LABEL: test_igtsc_z:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    neg r3, r3
; CHECK-NEXT:    rldicl r3, r3, 1, 63
; CHECK-NEXT:    blr
entry:
  %cmp = icmp sgt i8 %a, 0
  %conv1 = zext i1 %cmp to i32
  ret i32 %conv1
}

; Function Attrs: norecurse nounwind readnone
define signext i32 @test_igtsc_sext_z(i8 signext %a) {
; CHECK-LABEL: test_igtsc_sext_z:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    neg r3, r3
; CHECK-NEXT:    sradi r3, r3, 63
; CHECK-NEXT:    blr
entry:
  %cmp = icmp sgt i8 %a, 0
  %sub = sext i1 %cmp to i32
  ret i32 %sub
}

; Function Attrs: norecurse nounwind
define void @test_igtsc_store(i8 signext %a, i8 signext %b) {
; CHECK-LABEL: test_igtsc_store:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sub r3, r4, r3
; CHECK-NEXT:    addis r4, r2, .LC0@toc@ha
; CHECK-NEXT:    ld r4, .LC0@toc@l(r4)
; CHECK-NEXT:    rldicl r3, r3, 1, 63
; CHECK-NEXT:    stb r3, 0(r4)
; CHECK-NEXT:    blr
entry:
  %cmp = icmp sgt i8 %a, %b
  %conv3 = zext i1 %cmp to i8
  store i8 %conv3, ptr @glob, align 1
  ret void
}

; Function Attrs: norecurse nounwind
define void @test_igtsc_sext_store(i8 signext %a, i8 signext %b) {
; CHECK-LABEL: test_igtsc_sext_store:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sub r3, r4, r3
; CHECK-NEXT:    addis r4, r2, .LC0@toc@ha
; CHECK-NEXT:    ld r4, .LC0@toc@l(r4)
; CHECK-NEXT:    sradi r3, r3, 63
; CHECK-NEXT:    stb r3, 0(r4)
; CHECK-NEXT:    blr
entry:
  %cmp = icmp sgt i8 %a, %b
  %conv3 = sext i1 %cmp to i8
  store i8 %conv3, ptr @glob, align 1
  ret void
}

; FIXME
; Function Attrs: norecurse nounwind
define void @test_igtsc_z_store(i8 signext %a) {
; CHECK-LABEL: test_igtsc_z_store:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addis r4, r2, .LC0@toc@ha
; CHECK-NEXT:    neg r3, r3
; CHECK-NEXT:    ld r4, .LC0@toc@l(r4)
; CHECK-NEXT:    rldicl r3, r3, 1, 63
; CHECK-NEXT:    stb r3, 0(r4)
; CHECK-NEXT:    blr
entry:
  %cmp = icmp sgt i8 %a, 0
  %conv2 = zext i1 %cmp to i8
  store i8 %conv2, ptr @glob, align 1
  ret void
}

; Function Attrs: norecurse nounwind
define void @test_igtsc_sext_z_store(i8 signext %a) {
; CHECK-LABEL: test_igtsc_sext_z_store:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addis r4, r2, .LC0@toc@ha
; CHECK-NEXT:    neg r3, r3
; CHECK-NEXT:    ld r4, .LC0@toc@l(r4)
; CHECK-NEXT:    sradi r3, r3, 63
; CHECK-NEXT:    stb r3, 0(r4)
; CHECK-NEXT:    blr
entry:
  %cmp = icmp sgt i8 %a, 0
  %conv2 = sext i1 %cmp to i8
  store i8 %conv2, ptr @glob, align 1
  ret void
}