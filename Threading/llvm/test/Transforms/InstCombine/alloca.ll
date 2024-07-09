; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S -data-layout="E-p:64:64:64-a0:0:8-f32:32:32-f64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-v64:64:64-v128:128:128" | FileCheck %s -check-prefixes=ALL,CHECK
; RUN: opt < %s -passes=instcombine -S -data-layout="E-p:32:32:32-a0:0:8-f32:32:32-f64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-v64:64:64-v128:128:128" | FileCheck %s -check-prefixes=ALL,P32
; RUN: opt < %s -passes=instcombine -S | FileCheck %s -check-prefixes=ALL,NODL

declare void @use(...)

@int = global i32 zeroinitializer

; Zero byte allocas should be merged if they can't be deleted.
define void @test() {
; CHECK-LABEL: @test(
; CHECK-NEXT:    [[X:%.*]] = alloca [0 x i32], align 4
; CHECK-NEXT:    call void (...) @use(ptr nonnull [[X]])
; CHECK-NEXT:    call void (...) @use(ptr nonnull [[X]])
; CHECK-NEXT:    call void (...) @use(ptr nonnull [[X]])
; CHECK-NEXT:    call void (...) @use(ptr nonnull [[X]])
; CHECK-NEXT:    ret void
;
; P32-LABEL: @test(
; P32-NEXT:    [[X:%.*]] = alloca [0 x i32], align 4
; P32-NEXT:    call void (...) @use(ptr nonnull [[X]])
; P32-NEXT:    call void (...) @use(ptr nonnull [[X]])
; P32-NEXT:    call void (...) @use(ptr nonnull [[X]])
; P32-NEXT:    call void (...) @use(ptr nonnull [[X]])
; P32-NEXT:    ret void
;
; NODL-LABEL: @test(
; NODL-NEXT:    [[X:%.*]] = alloca [0 x i32], align 8
; NODL-NEXT:    call void (...) @use(ptr nonnull [[X]])
; NODL-NEXT:    call void (...) @use(ptr nonnull [[X]])
; NODL-NEXT:    call void (...) @use(ptr nonnull [[X]])
; NODL-NEXT:    call void (...) @use(ptr nonnull [[X]])
; NODL-NEXT:    ret void
;
  %X = alloca [0 x i32]           ; <ptr> [#uses=1]
  call void (...) @use( ptr %X )
  %Y = alloca i32, i32 0          ; <ptr> [#uses=1]
  call void (...) @use( ptr %Y )
  %Z = alloca {  }                ; <ptr> [#uses=1]
  call void (...) @use( ptr %Z )
  %size = load i32, ptr @int
  %A = alloca {{}}, i32 %size
  call void (...) @use( ptr %A )
  ret void
}

; Zero byte allocas should be deleted.
define void @test2() {
; ALL-LABEL: @test2(
; ALL-NEXT:    ret void
;
  %A = alloca i32         ; <ptr> [#uses=1]
  store i32 123, ptr %A
  ret void
}

; Zero byte allocas should be deleted.
define void @test3() {
; ALL-LABEL: @test3(
; ALL-NEXT:    ret void
;
  %A = alloca { i32 }             ; <ptr> [#uses=1]
  %B = getelementptr { i32 }, ptr %A, i32 0, i32 0            ; <ptr> [#uses=1]
  store i32 123, ptr %B
  ret void
}

define ptr @test4(i32 %n) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[TMP1:%.*]] = zext i32 [[N:%.*]] to i64
; CHECK-NEXT:    [[A:%.*]] = alloca i32, i64 [[TMP1]], align 4
; CHECK-NEXT:    ret ptr [[A]]
;
; P32-LABEL: @test4(
; P32-NEXT:    [[A:%.*]] = alloca i32, i32 [[N:%.*]], align 4
; P32-NEXT:    ret ptr [[A]]
;
; NODL-LABEL: @test4(
; NODL-NEXT:    [[TMP1:%.*]] = zext i32 [[N:%.*]] to i64
; NODL-NEXT:    [[A:%.*]] = alloca i32, i64 [[TMP1]], align 4
; NODL-NEXT:    ret ptr [[A]]
;
  %A = alloca i32, i32 %n
  ret ptr %A
}

; Allocas which are only used by GEPs, bitcasts, addrspacecasts, and stores
; (transitively) should be deleted.
define void @test5() {
; ALL-LABEL: @test5(
; ALL-NEXT:  entry:
; ALL-NEXT:    ret void
;

entry:
  %a = alloca { i32 }
  %b = alloca ptr
  %c = alloca i32
  store i32 123, ptr %a
  store ptr %a, ptr %b
  store i32 123, ptr %b
  store atomic i32 2, ptr %a unordered, align 4
  store atomic i32 3, ptr %a release, align 4
  store atomic i32 4, ptr %a seq_cst, align 4
  %c.1 = addrspacecast ptr %c to ptr addrspace(1)
  store i32 123, ptr addrspace(1) %c.1
  ret void
}

declare void @f(ptr %p)

; Check that we don't delete allocas in some erroneous cases.
define void @test6() {
; CHECK-LABEL: @test6(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = alloca { i32 }, align 4
; CHECK-NEXT:    [[B:%.*]] = alloca i32, align 4
; CHECK-NEXT:    store volatile i32 123, ptr [[A]], align 4
; CHECK-NEXT:    tail call void @f(ptr nonnull [[B]])
; CHECK-NEXT:    ret void
;
; P32-LABEL: @test6(
; P32-NEXT:  entry:
; P32-NEXT:    [[A:%.*]] = alloca { i32 }, align 4
; P32-NEXT:    [[B:%.*]] = alloca i32, align 4
; P32-NEXT:    store volatile i32 123, ptr [[A]], align 4
; P32-NEXT:    tail call void @f(ptr nonnull [[B]])
; P32-NEXT:    ret void
;
; NODL-LABEL: @test6(
; NODL-NEXT:  entry:
; NODL-NEXT:    [[A:%.*]] = alloca { i32 }, align 8
; NODL-NEXT:    [[B:%.*]] = alloca i32, align 4
; NODL-NEXT:    store volatile i32 123, ptr [[A]], align 4
; NODL-NEXT:    tail call void @f(ptr nonnull [[B]])
; NODL-NEXT:    ret void
;

entry:
  %a = alloca { i32 }
  %b = alloca i32
  store volatile i32 123, ptr %a
  tail call void @f(ptr %b)
  ret void
}

; PR14371
%opaque_type = type opaque
%real_type = type { { i32, ptr } }

@opaque_global = external constant %opaque_type, align 4

define void @test7() {
; ALL-LABEL: @test7(
; ALL-NEXT:  entry:
; ALL-NEXT:    ret void
;
entry:
  %0 = alloca %real_type, align 4
  call void @llvm.memcpy.p0.p0.i32(ptr %0, ptr @opaque_global, i32 8, i1 false)
  ret void
}

declare void @llvm.memcpy.p0.p0.i32(ptr nocapture, ptr nocapture, i32, i1) nounwind


; Check that the GEP indices use the pointer size, or 64 if unknown
define void @test8() {
; ALL-LABEL: @test8(
; ALL-NEXT:    [[X1:%.*]] = alloca [100 x i32], align 4
; ALL-NEXT:    call void (...) @use(ptr nonnull [[X1]])
; ALL-NEXT:    ret void
;


  %x = alloca i32, i32 100
  call void (...) @use(ptr %x)
  ret void
}

; PR19569
%struct_type = type { i32, i32 }
declare void @test9_aux(ptr inalloca(<{ %struct_type }>))
declare ptr @llvm.stacksave()
declare void @llvm.stackrestore(ptr)

define void @test9(ptr %a) {
; CHECK-LABEL: @test9(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ARGMEM:%.*]] = alloca inalloca <{ [[STRUCT_TYPE:%.*]] }>, align 1
; CHECK-NEXT:    [[TMP0:%.*]] = load i64, ptr [[A:%.*]], align 4
; CHECK-NEXT:    store i64 [[TMP0]], ptr [[ARGMEM]], align 4
; CHECK-NEXT:    call void @test9_aux(ptr nonnull inalloca(<{ [[STRUCT_TYPE]] }>) [[ARGMEM]])
; CHECK-NEXT:    ret void
;
; P32-LABEL: @test9(
; P32-NEXT:  entry:
; P32-NEXT:    [[ARGMEM:%.*]] = alloca inalloca <{ [[STRUCT_TYPE:%.*]] }>, align 1
; P32-NEXT:    [[TMP0:%.*]] = load i64, ptr [[A:%.*]], align 4
; P32-NEXT:    store i64 [[TMP0]], ptr [[ARGMEM]], align 4
; P32-NEXT:    call void @test9_aux(ptr nonnull inalloca(<{ [[STRUCT_TYPE]] }>) [[ARGMEM]])
; P32-NEXT:    ret void
;
; NODL-LABEL: @test9(
; NODL-NEXT:  entry:
; NODL-NEXT:    [[ARGMEM:%.*]] = alloca inalloca <{ [[STRUCT_TYPE:%.*]] }>, align 8
; NODL-NEXT:    [[TMP0:%.*]] = load i64, ptr [[A:%.*]], align 4
; NODL-NEXT:    store i64 [[TMP0]], ptr [[ARGMEM]], align 8
; NODL-NEXT:    call void @test9_aux(ptr nonnull inalloca(<{ [[STRUCT_TYPE]] }>) [[ARGMEM]])
; NODL-NEXT:    ret void
;
entry:
  %inalloca.save = call ptr @llvm.stacksave()
  %argmem = alloca inalloca <{ %struct_type }>
  call void @llvm.memcpy.p0.p0.i32(ptr align 4 %argmem, ptr align 4 %a, i32 8, i1 false)
  call void @test9_aux(ptr inalloca(<{ %struct_type }>) %argmem)
  call void @llvm.stackrestore(ptr %inalloca.save)
  ret void
}

define void @test10() {
; ALL-LABEL: @test10(
; ALL-NEXT:  entry:
; ALL-NEXT:    [[V32:%.*]] = alloca i1, align 8
; ALL-NEXT:    [[V64:%.*]] = alloca i1, align 8
; ALL-NEXT:    [[V33:%.*]] = alloca i1, align 8
; ALL-NEXT:    call void (...) @use(ptr nonnull [[V32]], ptr nonnull [[V64]], ptr nonnull [[V33]])
; ALL-NEXT:    ret void
;
entry:
  %v32 = alloca i1, align 8
  %v64 = alloca i1, i64 1, align 8
  %v33 = alloca i1, i33 1, align 8
  call void (...) @use(ptr %v32, ptr %v64, ptr %v33)
  ret void
}

define void @test11() {
; ALL-LABEL: @test11(
; ALL-NEXT:  entry:
; ALL-NEXT:    [[Y:%.*]] = alloca i32, align 4
; ALL-NEXT:    call void (...) @use(ptr nonnull @int) [ "blah"(ptr [[Y]]) ]
; ALL-NEXT:    ret void
;
entry:
  %y = alloca i32
  call void (...) @use(ptr nonnull @int) [ "blah"(ptr %y) ]
  ret void
}

define void @test_inalloca_with_element_count(ptr %a) {
; ALL-LABEL: @test_inalloca_with_element_count(
; ALL-NEXT:    [[ALLOCA1:%.*]] = alloca inalloca [10 x %struct_type], align 4
; ALL-NEXT:    call void @test9_aux(ptr nonnull inalloca([[STRUCT_TYPE:%.*]]) [[ALLOCA1]])
; ALL-NEXT:    ret void
;
  %alloca = alloca inalloca %struct_type, i32 10, align 4
  call void @test9_aux(ptr inalloca(%struct_type) %alloca)
  ret void
}
