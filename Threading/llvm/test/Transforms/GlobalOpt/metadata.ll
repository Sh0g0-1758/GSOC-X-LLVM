; RUN: opt -S -passes=globalopt < %s | FileCheck %s

; PR6112 - When globalopt does RAUW(@G, %G), the metadata reference should drop
; to null.  Function local metadata that references @G from a different function
; to that containing %G should likewise drop to null.
@G = internal global ptr null

define i32 @main(i32 %argc, ptr %argv) norecurse {
; CHECK-LABEL: @main(
; CHECK: %G = alloca
  store ptr %argv, ptr @G
  ret i32 0
}

define void @foo(i32 %x) {
; Note: these arguments look like MDNodes, but they're really syntactic sugar
; for 'MetadataAsValue::get(ValueAsMetadata::get(Value*))'.  When @G drops to
; null, the ValueAsMetadata instance gets replaced by metadata !{}, or
; MDNode::get({}).
  call void @llvm.foo(metadata ptr @G, metadata i32 %x)
; CHECK: call void @llvm.foo(metadata ![[EMPTY:[0-9]+]], metadata i32 %x)
  ret void
}

declare void @llvm.foo(metadata, metadata) nounwind readnone

!named = !{!0}
; CHECK: !named = !{![[NULL:[0-9]+]]}

!0 = !{ptr @G}
; CHECK-DAG: ![[NULL]] = distinct !{null}
; CHECK-DAG: ![[EMPTY]] = !{}
