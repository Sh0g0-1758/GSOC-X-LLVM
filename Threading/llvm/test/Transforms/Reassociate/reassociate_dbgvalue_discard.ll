; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=reassociate -S -o - | FileCheck %s

; After reassociation m1 and m2 aren't calculated as m1=c*a and m2=c*b any longer.
; So let's verify that the dbg.value nodes for m1 and m3 are invalidated.

source_filename = "reassociate_dbgvalue_discard.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define dso_local i32 @test1(i32 %a, i32 %b, i32 %c, i32 %d) local_unnamed_addr #0 !dbg !7 {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @llvm.dbg.value(metadata i32 poison, metadata !16, metadata !DIExpression()), !dbg !20
; CHECK-NEXT:    call void @llvm.dbg.value(metadata i32 poison, metadata !17, metadata !DIExpression()), !dbg !21
; CHECK-NEXT:    [[M1:%.*]] = mul i32 [[D:%.*]], [[C:%.*]], !dbg !22
; CHECK-NEXT:    [[M3:%.*]] = mul i32 [[M1]], [[A:%.*]], !dbg !23
; CHECK-NEXT:    call void @llvm.dbg.value(metadata i32 [[M3]], metadata !18, metadata !DIExpression()), !dbg !24
; CHECK-NEXT:    [[M2:%.*]] = mul i32 [[D]], [[C]], !dbg !25
; CHECK-NEXT:    [[M4:%.*]] = mul i32 [[M2]], [[B:%.*]], !dbg !26
; CHECK-NEXT:    call void @llvm.dbg.value(metadata i32 [[M4]], metadata !19, metadata !DIExpression()), !dbg !27
; CHECK-NEXT:    [[RES:%.*]] = xor i32 [[M3]], [[M4]]
; CHECK-NEXT:    ret i32 [[RES]], !dbg !28
;
entry:
  %m1 = mul i32 %c, %a, !dbg !24
  call void @llvm.dbg.value(metadata i32 %m1, metadata !16, metadata !DIExpression()), !dbg !25
  %m2 = mul i32 %c, %b, !dbg !26
  call void @llvm.dbg.value(metadata i32 %m2, metadata !17, metadata !DIExpression()), !dbg !27
  %m3 = mul i32 %m1, %d, !dbg !28
  call void @llvm.dbg.value(metadata i32 %m3, metadata !18, metadata !DIExpression()), !dbg !29
  %m4 = mul i32 %m2, %d, !dbg !30
  call void @llvm.dbg.value(metadata i32 %m4, metadata !19, metadata !DIExpression()), !dbg !31
  %res = xor i32 %m3, %m4
  ret i32 %res, !dbg !32
}

declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { nounwind readnone uwtable }
attributes #1 = { nounwind readnone speculatable }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 7.0.0 (trunk 330596) (llvm/trunk 330594)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !2)
!1 = !DIFile(filename: "reassociate_dbgvalue_discard.c", directory: "")
!2 = !{}
!3 = !{i32 2, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"clang version 7.0.0 (trunk 330596) (llvm/trunk 330594)"}
!7 = distinct !DISubprogram(name: "test1", scope: !1, file: !1, line: 3, type: !8, isLocal: false, isDefinition: true, scopeLine: 3, flags: DIFlagPrototyped, isOptimized: true, unit: !0, retainedNodes: !11)
!8 = !DISubroutineType(types: !9)
!9 = !{!10, !10, !10, !10, !10}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !{!12, !13, !14, !15, !16, !17, !18, !19}
!12 = !DILocalVariable(name: "a", arg: 1, scope: !7, file: !1, line: 3, type: !10)
!13 = !DILocalVariable(name: "b", arg: 2, scope: !7, file: !1, line: 3, type: !10)
!14 = !DILocalVariable(name: "c", arg: 3, scope: !7, file: !1, line: 3, type: !10)
!15 = !DILocalVariable(name: "d", arg: 4, scope: !7, file: !1, line: 3, type: !10)
!16 = !DILocalVariable(name: "t1", scope: !7, file: !1, line: 4, type: !10)
!17 = !DILocalVariable(name: "t2", scope: !7, file: !1, line: 5, type: !10)
!18 = !DILocalVariable(name: "t3", scope: !7, file: !1, line: 6, type: !10)
!19 = !DILocalVariable(name: "t4", scope: !7, file: !1, line: 7, type: !10)
!20 = !DILocation(line: 3, column: 15, scope: !7)
!21 = !DILocation(line: 3, column: 22, scope: !7)
!22 = !DILocation(line: 3, column: 29, scope: !7)
!23 = !DILocation(line: 3, column: 36, scope: !7)
!24 = !DILocation(line: 4, column: 14, scope: !7)
!25 = !DILocation(line: 4, column: 7, scope: !7)
!26 = !DILocation(line: 5, column: 14, scope: !7)
!27 = !DILocation(line: 5, column: 7, scope: !7)
!28 = !DILocation(line: 6, column: 15, scope: !7)
!29 = !DILocation(line: 6, column: 7, scope: !7)
!30 = !DILocation(line: 7, column: 15, scope: !7)
!31 = !DILocation(line: 7, column: 7, scope: !7)
!32 = !DILocation(line: 8, column: 3, scope: !7)
