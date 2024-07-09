; RUN: opt -passes=sroa -S %s -o - | FileCheck %s
; RUN: opt --try-experimental-debuginfo-iterators -passes=sroa -S %s -o - | FileCheck %s

;; Check that multiple dbg.assign intrinsics linked to a store that is getting
;; split (or at least that is touched by SROA, causing a replacement store to
;; be generated) are still both linked to the new store(s).
;;
;; Additionally, check that SROA inserts new dbg.assign intrinsics by the
;; originals.

;; $ cat test.cpp
;; class a {
;; public:
;;   a(int, float &) {}
;; };
;; float b, d;
;; int c;
;; void f() {
;;   float e;
;;   if (c)
;;     e = b;
;;   else
;;     e = b / d;
;;   a(c, e);
;; }
;;
;; Generated by grabbing IR before sroa in:
;; $ clang++ -O2 -g -c test.cpp -Xclang -fexperimental-assignment-tracking 

; CHECK: if.then:
; CHECK-NEXT: %1 = load float
; CHECK-NEXT: call void @llvm.dbg.value(metadata float %storemerge, metadata ![[var:[0-9]+]], metadata !DIExpression())

; CHECK: if.else:
; CHECK-NEXT: %2 = load float
; CHECK-NEXT: %3 = load float
; CHECK-NEXT: %div = fdiv float
; CHECK: call void @llvm.dbg.value(metadata float %storemerge, metadata ![[var]], metadata !DIExpression())

%class.a = type { i8 }

$_ZN1aC2EiRf = comdat any

@b = dso_local local_unnamed_addr global float 0.000000e+00, align 4, !dbg !0
@d = dso_local local_unnamed_addr global float 0.000000e+00, align 4, !dbg !6
@c = dso_local local_unnamed_addr global i32 0, align 4, !dbg !9

; Function Attrs: nounwind readonly uwtable
define dso_local void @_Z1fv() local_unnamed_addr #0 !dbg !16 {
entry:
  %e = alloca float, align 4, !DIAssignID !21
  call void @llvm.dbg.assign(metadata i1 undef, metadata !20, metadata !DIExpression(), metadata !21, metadata ptr %e, metadata !DIExpression()), !dbg !22
  %agg.tmp.ensured = alloca %class.a, align 1
  %0 = bitcast ptr %e to ptr, !dbg !23
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %0) #4, !dbg !23
  %1 = load i32, ptr @c, align 4, !dbg !24
  %tobool.not = icmp eq i32 %1, 0, !dbg !24
  br i1 %tobool.not, label %if.else, label %if.then, !dbg !30

if.then:                                          ; preds = %entry
  %2 = load float, ptr @b, align 4, !dbg !31
  call void @llvm.dbg.assign(metadata float %2, metadata !20, metadata !DIExpression(), metadata !34, metadata ptr %e, metadata !DIExpression()), !dbg !22
  br label %if.end, !dbg !35

if.else:                                          ; preds = %entry
  %3 = load float, ptr @b, align 4, !dbg !36
  %4 = load float, ptr @d, align 4, !dbg !37
  %div = fdiv float %3, %4, !dbg !38
  call void @llvm.dbg.assign(metadata float %div, metadata !20, metadata !DIExpression(), metadata !34, metadata ptr %e, metadata !DIExpression()), !dbg !22
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %storemerge = phi float [ %div, %if.else ], [ %2, %if.then ], !dbg !39
  store float %storemerge, ptr %e, align 4, !dbg !39, !DIAssignID !34
  %5 = load i32, ptr @c, align 4, !dbg !40
  call void @llvm.dbg.assign(metadata i1 undef, metadata !41, metadata !DIExpression(), metadata !54, metadata ptr undef, metadata !DIExpression()), !dbg !55
  call void @llvm.dbg.assign(metadata i1 undef, metadata !51, metadata !DIExpression(), metadata !57, metadata ptr undef, metadata !DIExpression()), !dbg !55
  call void @llvm.dbg.assign(metadata i1 undef, metadata !52, metadata !DIExpression(), metadata !58, metadata ptr undef, metadata !DIExpression()), !dbg !55
  call void @llvm.dbg.assign(metadata ptr %agg.tmp.ensured, metadata !41, metadata !DIExpression(), metadata !59, metadata ptr undef, metadata !DIExpression()), !dbg !55
  call void @llvm.dbg.assign(metadata i32 %5, metadata !51, metadata !DIExpression(), metadata !60, metadata ptr undef, metadata !DIExpression()), !dbg !55
  call void @llvm.dbg.assign(metadata ptr %e, metadata !52, metadata !DIExpression(), metadata !61, metadata ptr undef, metadata !DIExpression()), !dbg !55
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %0) #4, !dbg !62
  ret void, !dbg !62
}

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: nounwind uwtable
define linkonce_odr dso_local void @_ZN1aC2EiRf(ptr %this, i32 %0, ptr nonnull align 4 dereferenceable(4) %1) unnamed_addr #2 comdat align 2 !dbg !42 {
entry:
  call void @llvm.dbg.assign(metadata i1 undef, metadata !41, metadata !DIExpression(), metadata !63, metadata ptr undef, metadata !DIExpression()), !dbg !64
  call void @llvm.dbg.assign(metadata i1 undef, metadata !51, metadata !DIExpression(), metadata !65, metadata ptr undef, metadata !DIExpression()), !dbg !64
  call void @llvm.dbg.assign(metadata i1 undef, metadata !52, metadata !DIExpression(), metadata !66, metadata ptr undef, metadata !DIExpression()), !dbg !64
  call void @llvm.dbg.assign(metadata ptr %this, metadata !41, metadata !DIExpression(), metadata !67, metadata ptr undef, metadata !DIExpression()), !dbg !64
  call void @llvm.dbg.assign(metadata i32 %0, metadata !51, metadata !DIExpression(), metadata !68, metadata ptr undef, metadata !DIExpression()), !dbg !64
  call void @llvm.dbg.assign(metadata ptr %1, metadata !52, metadata !DIExpression(), metadata !69, metadata ptr undef, metadata !DIExpression()), !dbg !64
  ret void, !dbg !70
}

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.assign(metadata, metadata, metadata, metadata, metadata, metadata) #3

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!12, !13, !14, !1000}
!llvm.ident = !{!15}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "b", scope: !2, file: !3, line: 5, type: !8, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !3, producer: "clang version 12.0.0", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "reduce.cpp", directory: "")
!4 = !{}
!5 = !{!0, !6, !9}
!6 = !DIGlobalVariableExpression(var: !7, expr: !DIExpression())
!7 = distinct !DIGlobalVariable(name: "d", scope: !2, file: !3, line: 5, type: !8, isLocal: false, isDefinition: true)
!8 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!9 = !DIGlobalVariableExpression(var: !10, expr: !DIExpression())
!10 = distinct !DIGlobalVariable(name: "c", scope: !2, file: !3, line: 6, type: !11, isLocal: false, isDefinition: true)
!11 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!12 = !{i32 7, !"Dwarf Version", i32 4}
!13 = !{i32 2, !"Debug Info Version", i32 3}
!14 = !{i32 1, !"wchar_size", i32 4}
!15 = !{!"clang version 12.0.0"}
!16 = distinct !DISubprogram(name: "f", linkageName: "_Z1fv", scope: !3, file: !3, line: 7, type: !17, scopeLine: 7, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !19)
!17 = !DISubroutineType(types: !18)
!18 = !{null}
!19 = !{!20}
!20 = !DILocalVariable(name: "e", scope: !16, file: !3, line: 8, type: !8)
!21 = distinct !DIAssignID()
!22 = !DILocation(line: 0, scope: !16)
!23 = !DILocation(line: 8, column: 3, scope: !16)
!24 = !DILocation(line: 9, column: 7, scope: !25)
!25 = distinct !DILexicalBlock(scope: !16, file: !3, line: 9, column: 7)
!30 = !DILocation(line: 9, column: 7, scope: !16)
!31 = !DILocation(line: 10, column: 9, scope: !25)
!34 = distinct !DIAssignID()
!35 = !DILocation(line: 10, column: 5, scope: !25)
!36 = !DILocation(line: 12, column: 9, scope: !25)
!37 = !DILocation(line: 12, column: 13, scope: !25)
!38 = !DILocation(line: 12, column: 11, scope: !25)
!39 = !DILocation(line: 0, scope: !25)
!40 = !DILocation(line: 13, column: 5, scope: !16)
!41 = !DILocalVariable(name: "this", arg: 1, scope: !42, type: !53, flags: DIFlagArtificial | DIFlagObjectPointer)
!42 = distinct !DISubprogram(name: "a", linkageName: "_ZN1aC2EiRf", scope: !43, file: !3, line: 3, type: !46, scopeLine: 3, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, declaration: !45, retainedNodes: !50)
!43 = distinct !DICompositeType(tag: DW_TAG_class_type, name: "a", file: !3, line: 1, size: 8, flags: DIFlagTypePassByValue | DIFlagNonTrivial, elements: !44, identifier: "_ZTS1a")
!44 = !{!45}
!45 = !DISubprogram(name: "a", scope: !43, file: !3, line: 3, type: !46, scopeLine: 3, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!46 = !DISubroutineType(types: !47)
!47 = !{null, !48, !11, !49}
!48 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !43, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!49 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !8, size: 64)
!50 = !{!41, !51, !52}
!51 = !DILocalVariable(arg: 2, scope: !42, file: !3, line: 3, type: !11)
!52 = !DILocalVariable(arg: 3, scope: !42, file: !3, line: 3, type: !49)
!53 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !43, size: 64)
!54 = distinct !DIAssignID()
!55 = !DILocation(line: 0, scope: !42, inlinedAt: !56)
!56 = distinct !DILocation(line: 13, column: 3, scope: !16)
!57 = distinct !DIAssignID()
!58 = distinct !DIAssignID()
!59 = distinct !DIAssignID()
!60 = distinct !DIAssignID()
!61 = distinct !DIAssignID()
!62 = !DILocation(line: 14, column: 1, scope: !16)
!63 = distinct !DIAssignID()
!64 = !DILocation(line: 0, scope: !42)
!65 = distinct !DIAssignID()
!66 = distinct !DIAssignID()
!67 = distinct !DIAssignID()
!68 = distinct !DIAssignID()
!69 = distinct !DIAssignID()
!70 = !DILocation(line: 3, column: 20, scope: !42)
!1000 = !{i32 7, !"debug-info-assignment-tracking", i1 true}
