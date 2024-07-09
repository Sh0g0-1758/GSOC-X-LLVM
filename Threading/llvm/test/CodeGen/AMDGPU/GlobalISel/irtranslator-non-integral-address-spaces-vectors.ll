; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py UTC_ARGS: --version 2
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdpal -mcpu=gfx900 -o - -stop-after=irtranslator < %s | FileCheck %s

define <2 x ptr addrspace(7)> @no_auto_constfold_gep_vector() {
  ; CHECK-LABEL: name: no_auto_constfold_gep_vector
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   [[C:%[0-9]+]]:_(p8) = G_CONSTANT i128 0
  ; CHECK-NEXT:   [[BUILD_VECTOR:%[0-9]+]]:_(<2 x p8>) = G_BUILD_VECTOR [[C]](p8), [[C]](p8)
  ; CHECK-NEXT:   [[C1:%[0-9]+]]:_(s32) = G_CONSTANT i32 123
  ; CHECK-NEXT:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[C1]](s32), [[C1]](s32)
  ; CHECK-NEXT:   [[UV:%[0-9]+]]:_(s32), [[UV1:%[0-9]+]]:_(s32), [[UV2:%[0-9]+]]:_(s32), [[UV3:%[0-9]+]]:_(s32), [[UV4:%[0-9]+]]:_(s32), [[UV5:%[0-9]+]]:_(s32), [[UV6:%[0-9]+]]:_(s32), [[UV7:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[BUILD_VECTOR]](<2 x p8>)
  ; CHECK-NEXT:   [[UV8:%[0-9]+]]:_(s32), [[UV9:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[BUILD_VECTOR1]](<2 x s32>)
  ; CHECK-NEXT:   $vgpr0 = COPY [[UV]](s32)
  ; CHECK-NEXT:   $vgpr1 = COPY [[UV1]](s32)
  ; CHECK-NEXT:   $vgpr2 = COPY [[UV2]](s32)
  ; CHECK-NEXT:   $vgpr3 = COPY [[UV3]](s32)
  ; CHECK-NEXT:   $vgpr4 = COPY [[UV4]](s32)
  ; CHECK-NEXT:   $vgpr5 = COPY [[UV5]](s32)
  ; CHECK-NEXT:   $vgpr6 = COPY [[UV6]](s32)
  ; CHECK-NEXT:   $vgpr7 = COPY [[UV7]](s32)
  ; CHECK-NEXT:   $vgpr8 = COPY [[UV8]](s32)
  ; CHECK-NEXT:   $vgpr9 = COPY [[UV9]](s32)
  ; CHECK-NEXT:   SI_RETURN implicit $vgpr0, implicit $vgpr1, implicit $vgpr2, implicit $vgpr3, implicit $vgpr4, implicit $vgpr5, implicit $vgpr6, implicit $vgpr7, implicit $vgpr8, implicit $vgpr9
  %gep = getelementptr i8, <2 x ptr addrspace(7)> zeroinitializer, <2 x i32> <i32 123, i32 123>
  ret <2 x ptr addrspace(7)> %gep
}

define <2 x ptr addrspace(7)> @gep_vector_splat(<2 x ptr addrspace(7)> %ptrs, i64 %idx) {
  ; CHECK-LABEL: name: gep_vector_splat
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   liveins: $vgpr0, $vgpr1, $vgpr2, $vgpr3, $vgpr4, $vgpr5, $vgpr6, $vgpr7, $vgpr8, $vgpr9, $vgpr10, $vgpr11
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:_(s32) = COPY $vgpr2
  ; CHECK-NEXT:   [[COPY3:%[0-9]+]]:_(s32) = COPY $vgpr3
  ; CHECK-NEXT:   [[COPY4:%[0-9]+]]:_(s32) = COPY $vgpr4
  ; CHECK-NEXT:   [[COPY5:%[0-9]+]]:_(s32) = COPY $vgpr5
  ; CHECK-NEXT:   [[COPY6:%[0-9]+]]:_(s32) = COPY $vgpr6
  ; CHECK-NEXT:   [[COPY7:%[0-9]+]]:_(s32) = COPY $vgpr7
  ; CHECK-NEXT:   [[MV:%[0-9]+]]:_(p8) = G_MERGE_VALUES [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32)
  ; CHECK-NEXT:   [[MV1:%[0-9]+]]:_(p8) = G_MERGE_VALUES [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; CHECK-NEXT:   [[BUILD_VECTOR:%[0-9]+]]:_(<2 x p8>) = G_BUILD_VECTOR [[MV]](p8), [[MV1]](p8)
  ; CHECK-NEXT:   [[COPY8:%[0-9]+]]:_(s32) = COPY $vgpr8
  ; CHECK-NEXT:   [[COPY9:%[0-9]+]]:_(s32) = COPY $vgpr9
  ; CHECK-NEXT:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY8]](s32), [[COPY9]](s32)
  ; CHECK-NEXT:   [[COPY10:%[0-9]+]]:_(s32) = COPY $vgpr10
  ; CHECK-NEXT:   [[COPY11:%[0-9]+]]:_(s32) = COPY $vgpr11
  ; CHECK-NEXT:   [[MV2:%[0-9]+]]:_(s64) = G_MERGE_VALUES [[COPY10]](s32), [[COPY11]](s32)
  ; CHECK-NEXT:   [[DEF:%[0-9]+]]:_(<2 x s64>) = G_IMPLICIT_DEF
  ; CHECK-NEXT:   [[C:%[0-9]+]]:_(s64) = G_CONSTANT i64 0
  ; CHECK-NEXT:   [[DEF1:%[0-9]+]]:_(<2 x p8>) = G_IMPLICIT_DEF
  ; CHECK-NEXT:   [[DEF2:%[0-9]+]]:_(<2 x s32>) = G_IMPLICIT_DEF
  ; CHECK-NEXT:   [[IVEC:%[0-9]+]]:_(<2 x s64>) = G_INSERT_VECTOR_ELT [[DEF]], [[MV2]](s64), [[C]](s64)
  ; CHECK-NEXT:   [[SHUF:%[0-9]+]]:_(<2 x s64>) = G_SHUFFLE_VECTOR [[IVEC]](<2 x s64>), [[DEF]], shufflemask(0, 0)
  ; CHECK-NEXT:   [[TRUNC:%[0-9]+]]:_(<2 x s32>) = G_TRUNC [[SHUF]](<2 x s64>)
  ; CHECK-NEXT:   [[ADD:%[0-9]+]]:_(<2 x s32>) = G_ADD [[BUILD_VECTOR1]], [[TRUNC]]
  ; CHECK-NEXT:   [[UV:%[0-9]+]]:_(s32), [[UV1:%[0-9]+]]:_(s32), [[UV2:%[0-9]+]]:_(s32), [[UV3:%[0-9]+]]:_(s32), [[UV4:%[0-9]+]]:_(s32), [[UV5:%[0-9]+]]:_(s32), [[UV6:%[0-9]+]]:_(s32), [[UV7:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[BUILD_VECTOR]](<2 x p8>)
  ; CHECK-NEXT:   [[UV8:%[0-9]+]]:_(s32), [[UV9:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[ADD]](<2 x s32>)
  ; CHECK-NEXT:   $vgpr0 = COPY [[UV]](s32)
  ; CHECK-NEXT:   $vgpr1 = COPY [[UV1]](s32)
  ; CHECK-NEXT:   $vgpr2 = COPY [[UV2]](s32)
  ; CHECK-NEXT:   $vgpr3 = COPY [[UV3]](s32)
  ; CHECK-NEXT:   $vgpr4 = COPY [[UV4]](s32)
  ; CHECK-NEXT:   $vgpr5 = COPY [[UV5]](s32)
  ; CHECK-NEXT:   $vgpr6 = COPY [[UV6]](s32)
  ; CHECK-NEXT:   $vgpr7 = COPY [[UV7]](s32)
  ; CHECK-NEXT:   $vgpr8 = COPY [[UV8]](s32)
  ; CHECK-NEXT:   $vgpr9 = COPY [[UV9]](s32)
  ; CHECK-NEXT:   SI_RETURN implicit $vgpr0, implicit $vgpr1, implicit $vgpr2, implicit $vgpr3, implicit $vgpr4, implicit $vgpr5, implicit $vgpr6, implicit $vgpr7, implicit $vgpr8, implicit $vgpr9
  %gep = getelementptr i8, <2 x ptr addrspace(7)> %ptrs, i64 %idx
  ret <2 x ptr addrspace(7)> %gep
}
