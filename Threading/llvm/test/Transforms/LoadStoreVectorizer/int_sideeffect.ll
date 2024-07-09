; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S < %s -passes=load-store-vectorizer | FileCheck %s
; RUN: opt -S < %s -passes='function(load-store-vectorizer)' | FileCheck %s

declare void @llvm.sideeffect()

; load-store vectorization across a @llvm.sideeffect.

define void @test_sideeffect(ptr %p) {
; CHECK-LABEL: @test_sideeffect(
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x float>, ptr [[P:%.*]], align 16
; CHECK-NEXT:    [[L01:%.*]] = extractelement <4 x float> [[TMP2]], i32 0
; CHECK-NEXT:    [[L12:%.*]] = extractelement <4 x float> [[TMP2]], i32 1
; CHECK-NEXT:    [[L23:%.*]] = extractelement <4 x float> [[TMP2]], i32 2
; CHECK-NEXT:    [[L34:%.*]] = extractelement <4 x float> [[TMP2]], i32 3
; CHECK-NEXT:    call void @llvm.sideeffect()
; CHECK-NEXT:    call void @llvm.sideeffect()
; CHECK-NEXT:    [[TMP3:%.*]] = insertelement <4 x float> poison, float [[L01]], i32 0
; CHECK-NEXT:    [[TMP4:%.*]] = insertelement <4 x float> [[TMP3]], float [[L12]], i32 1
; CHECK-NEXT:    [[TMP5:%.*]] = insertelement <4 x float> [[TMP4]], float [[L23]], i32 2
; CHECK-NEXT:    [[TMP6:%.*]] = insertelement <4 x float> [[TMP5]], float [[L34]], i32 3
; CHECK-NEXT:    store <4 x float> [[TMP6]], ptr [[P]], align 16
; CHECK-NEXT:    ret void
;
  %p1 = getelementptr float, ptr %p, i64 1
  %p2 = getelementptr float, ptr %p, i64 2
  %p3 = getelementptr float, ptr %p, i64 3
  %l0 = load float, ptr %p, align 16
  %l1 = load float, ptr %p1
  %l2 = load float, ptr %p2
  call void @llvm.sideeffect()
  %l3 = load float, ptr %p3
  store float %l0, ptr %p, align 16
  call void @llvm.sideeffect()
  store float %l1, ptr %p1
  store float %l2, ptr %p2
  store float %l3, ptr %p3
  ret void
}

declare void @foo()

define void @test_inaccessiblememonly_nounwind_willreturn(ptr %p) {
; CHECK-LABEL: @test_inaccessiblememonly_nounwind_willreturn(
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x float>, ptr [[P:%.*]], align 16
; CHECK-NEXT:    [[L01:%.*]] = extractelement <4 x float> [[TMP2]], i32 0
; CHECK-NEXT:    [[L12:%.*]] = extractelement <4 x float> [[TMP2]], i32 1
; CHECK-NEXT:    [[L23:%.*]] = extractelement <4 x float> [[TMP2]], i32 2
; CHECK-NEXT:    [[L34:%.*]] = extractelement <4 x float> [[TMP2]], i32 3
; CHECK-NEXT:    call void @foo() #[[ATTR1:[0-9]+]]
; CHECK-NEXT:    call void @foo() #[[ATTR1]]
; CHECK-NEXT:    [[TMP3:%.*]] = insertelement <4 x float> poison, float [[L01]], i32 0
; CHECK-NEXT:    [[TMP4:%.*]] = insertelement <4 x float> [[TMP3]], float [[L12]], i32 1
; CHECK-NEXT:    [[TMP5:%.*]] = insertelement <4 x float> [[TMP4]], float [[L23]], i32 2
; CHECK-NEXT:    [[TMP6:%.*]] = insertelement <4 x float> [[TMP5]], float [[L34]], i32 3
; CHECK-NEXT:    store <4 x float> [[TMP6]], ptr [[P]], align 16
; CHECK-NEXT:    ret void
;
  %p1 = getelementptr float, ptr %p, i64 1
  %p2 = getelementptr float, ptr %p, i64 2
  %p3 = getelementptr float, ptr %p, i64 3
  %l0 = load float, ptr %p, align 16
  %l1 = load float, ptr %p1
  %l2 = load float, ptr %p2
  call void @foo() inaccessiblememonly nounwind willreturn
  %l3 = load float, ptr %p3
  store float %l0, ptr %p, align 16
  call void @foo() inaccessiblememonly nounwind willreturn
  store float %l1, ptr %p1
  store float %l2, ptr %p2
  store float %l3, ptr %p3
  ret void
}

define void @test_inaccessiblememonly_not_willreturn(ptr %p) {
; CHECK-LABEL: @test_inaccessiblememonly_not_willreturn(
; CHECK-NEXT:    [[P1:%.*]] = getelementptr float, ptr [[P:%.*]], i64 1
; CHECK-NEXT:    [[P2:%.*]] = getelementptr float, ptr [[P]], i64 2
; CHECK-NEXT:    [[P3:%.*]] = getelementptr float, ptr [[P]], i64 3
; CHECK-NEXT:    [[L0:%.*]] = load float, ptr [[P]], align 16
; CHECK-NEXT:    call void @foo() #[[ATTR2:[0-9]+]]
; CHECK-NEXT:    [[L1:%.*]] = load float, ptr [[P1]], align 4
; CHECK-NEXT:    [[L2:%.*]] = load float, ptr [[P2]], align 4
; CHECK-NEXT:    [[L3:%.*]] = load float, ptr [[P3]], align 4
; CHECK-NEXT:    store float [[L0]], ptr [[P]], align 16
; CHECK-NEXT:    call void @foo() #[[ATTR2]]
; CHECK-NEXT:    store float [[L1]], ptr [[P1]], align 4
; CHECK-NEXT:    store float [[L2]], ptr [[P2]], align 4
; CHECK-NEXT:    store float [[L3]], ptr [[P3]], align 4
; CHECK-NEXT:    ret void
;
  %p1 = getelementptr float, ptr %p, i64 1
  %p2 = getelementptr float, ptr %p, i64 2
  %p3 = getelementptr float, ptr %p, i64 3
  %l0 = load float, ptr %p, align 16
  call void @foo() inaccessiblememonly nounwind
  %l1 = load float, ptr %p1
  %l2 = load float, ptr %p2
  %l3 = load float, ptr %p3
  store float %l0, ptr %p, align 16
  call void @foo() inaccessiblememonly nounwind
  store float %l1, ptr %p1
  store float %l2, ptr %p2
  store float %l3, ptr %p3
  ret void
}

define void @test_inaccessiblememonly_not_nounwind(ptr %p) {
; CHECK-LABEL: @test_inaccessiblememonly_not_nounwind(
; CHECK-NEXT:    [[P1:%.*]] = getelementptr float, ptr [[P:%.*]], i64 1
; CHECK-NEXT:    [[P2:%.*]] = getelementptr float, ptr [[P]], i64 2
; CHECK-NEXT:    [[P3:%.*]] = getelementptr float, ptr [[P]], i64 3
; CHECK-NEXT:    [[L0:%.*]] = load float, ptr [[P]], align 16
; CHECK-NEXT:    call void @foo() #[[ATTR3:[0-9]+]]
; CHECK-NEXT:    [[L1:%.*]] = load float, ptr [[P1]], align 4
; CHECK-NEXT:    [[L2:%.*]] = load float, ptr [[P2]], align 4
; CHECK-NEXT:    [[L3:%.*]] = load float, ptr [[P3]], align 4
; CHECK-NEXT:    store float [[L0]], ptr [[P]], align 16
; CHECK-NEXT:    call void @foo() #[[ATTR3]]
; CHECK-NEXT:    store float [[L1]], ptr [[P1]], align 4
; CHECK-NEXT:    store float [[L2]], ptr [[P2]], align 4
; CHECK-NEXT:    store float [[L3]], ptr [[P3]], align 4
; CHECK-NEXT:    ret void
;
  %p1 = getelementptr float, ptr %p, i64 1
  %p2 = getelementptr float, ptr %p, i64 2
  %p3 = getelementptr float, ptr %p, i64 3
  %l0 = load float, ptr %p, align 16
  call void @foo() inaccessiblememonly willreturn
  %l1 = load float, ptr %p1
  %l2 = load float, ptr %p2
  %l3 = load float, ptr %p3
  store float %l0, ptr %p, align 16
  call void @foo() inaccessiblememonly willreturn
  store float %l1, ptr %p1
  store float %l2, ptr %p2
  store float %l3, ptr %p3
  ret void
}
