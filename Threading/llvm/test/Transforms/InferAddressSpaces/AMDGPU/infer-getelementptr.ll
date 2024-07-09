; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -mtriple=amdgcn-amd-amdhsa -passes=infer-address-spaces %s | FileCheck %s

; Test that pure GetElementPtr instructions not directly connected to
; a memory operation are inferred.

@lds = internal unnamed_addr addrspace(3) global [648 x double] undef, align 8

define void @simplified_constexpr_gep_addrspacecast(i64 %idx0, i64 %idx1) {
; CHECK-LABEL: @simplified_constexpr_gep_addrspacecast(
; CHECK-NEXT:    [[GEP0:%.*]] = getelementptr inbounds double, ptr addrspace(3) getelementptr inbounds ([648 x double], ptr addrspace(3) @lds, i64 0, i64 384), i64 [[IDX0:%.*]]
; CHECK-NEXT:    store double 1.000000e+00, ptr addrspace(3) [[GEP0]], align 8
; CHECK-NEXT:    ret void
;
  %gep0 = getelementptr inbounds double, ptr addrspacecast (ptr addrspace(3) getelementptr inbounds ([648 x double], ptr addrspace(3) @lds, i64 0, i64 384) to ptr), i64 %idx0
  %asc = addrspacecast ptr %gep0 to ptr addrspace(3)
  store double 1.000000e+00, ptr addrspace(3) %asc, align 8
  ret void
}

define void @constexpr_gep_addrspacecast(i64 %idx0, i64 %idx1) {
; CHECK-LABEL: @constexpr_gep_addrspacecast(
; CHECK-NEXT:    [[GEP0:%.*]] = getelementptr inbounds double, ptr addrspace(3) getelementptr inbounds ([648 x double], ptr addrspace(3) @lds, i64 0, i64 384), i64 [[IDX0:%.*]]
; CHECK-NEXT:    store double 1.000000e+00, ptr addrspace(3) [[GEP0]], align 8
; CHECK-NEXT:    ret void
;
  %gep0 = getelementptr inbounds double, ptr getelementptr ([648 x double], ptr addrspacecast (ptr addrspace(3) @lds to ptr), i64 0, i64 384), i64 %idx0
  %asc = addrspacecast ptr %gep0 to ptr addrspace(3)
  store double 1.0, ptr addrspace(3) %asc, align 8
  ret void
}

define void @constexpr_gep_gep_addrspacecast(i64 %idx0, i64 %idx1) {
; CHECK-LABEL: @constexpr_gep_gep_addrspacecast(
; CHECK-NEXT:    [[GEP0:%.*]] = getelementptr inbounds double, ptr addrspace(3) getelementptr inbounds ([648 x double], ptr addrspace(3) @lds, i64 0, i64 384), i64 [[IDX0:%.*]]
; CHECK-NEXT:    [[GEP1:%.*]] = getelementptr inbounds double, ptr addrspace(3) [[GEP0]], i64 [[IDX1:%.*]]
; CHECK-NEXT:    store double 1.000000e+00, ptr addrspace(3) [[GEP1]], align 8
; CHECK-NEXT:    ret void
;
  %gep0 = getelementptr inbounds double, ptr getelementptr ([648 x double], ptr addrspacecast (ptr addrspace(3) @lds to ptr), i64 0, i64 384), i64 %idx0
  %gep1 = getelementptr inbounds double, ptr %gep0, i64 %idx1
  %asc = addrspacecast ptr %gep1 to ptr addrspace(3)
  store double 1.0, ptr addrspace(3) %asc, align 8
  ret void
}

; Don't crash
define amdgpu_kernel void @vector_gep(<4 x ptr addrspace(3)> %array) nounwind {
; CHECK-LABEL: @vector_gep(
; CHECK-NEXT:    [[CAST:%.*]] = addrspacecast <4 x ptr addrspace(3)> [[ARRAY:%.*]] to <4 x ptr>
; CHECK-NEXT:    [[P:%.*]] = getelementptr [1024 x i32], <4 x ptr> [[CAST]], <4 x i16> zeroinitializer, <4 x i16> <i16 16, i16 16, i16 16, i16 16>
; CHECK-NEXT:    [[P0:%.*]] = extractelement <4 x ptr> [[P]], i32 0
; CHECK-NEXT:    [[P1:%.*]] = extractelement <4 x ptr> [[P]], i32 1
; CHECK-NEXT:    [[P2:%.*]] = extractelement <4 x ptr> [[P]], i32 2
; CHECK-NEXT:    [[P3:%.*]] = extractelement <4 x ptr> [[P]], i32 3
; CHECK-NEXT:    store i32 99, ptr [[P0]], align 4
; CHECK-NEXT:    store i32 99, ptr [[P1]], align 4
; CHECK-NEXT:    store i32 99, ptr [[P2]], align 4
; CHECK-NEXT:    store i32 99, ptr [[P3]], align 4
; CHECK-NEXT:    ret void
;
  %cast = addrspacecast <4 x ptr addrspace(3)> %array to <4 x ptr>
  %p = getelementptr [1024 x i32], <4 x ptr> %cast, <4 x i16> zeroinitializer, <4 x i16> <i16 16, i16 16, i16 16, i16 16>
  %p0 = extractelement <4 x ptr> %p, i32 0
  %p1 = extractelement <4 x ptr> %p, i32 1
  %p2 = extractelement <4 x ptr> %p, i32 2
  %p3 = extractelement <4 x ptr> %p, i32 3
  store i32 99, ptr %p0
  store i32 99, ptr %p1
  store i32 99, ptr %p2
  store i32 99, ptr %p3
  ret void
}

define void @repeated_constexpr_gep_addrspacecast(i64 %idx0, i64 %idx1) {
; CHECK-LABEL: @repeated_constexpr_gep_addrspacecast(
; CHECK-NEXT:    [[GEP0:%.*]] = getelementptr inbounds double, ptr addrspace(3) getelementptr inbounds ([648 x double], ptr addrspace(3) @lds, i64 0, i64 384), i64 [[IDX0:%.*]]
; CHECK-NEXT:    store double 1.000000e+00, ptr addrspace(3) [[GEP0]], align 8
; CHECK-NEXT:    [[GEP1:%.*]] = getelementptr inbounds double, ptr addrspace(3) getelementptr inbounds ([648 x double], ptr addrspace(3) @lds, i64 0, i64 384), i64 [[IDX1:%.*]]
; CHECK-NEXT:    store double 1.000000e+00, ptr addrspace(3) [[GEP1]], align 8
; CHECK-NEXT:    ret void
;
  %gep0 = getelementptr inbounds double, ptr getelementptr ([648 x double], ptr addrspacecast (ptr addrspace(3) @lds to ptr), i64 0, i64 384), i64 %idx0
  %asc0 = addrspacecast ptr %gep0 to ptr addrspace(3)
  store double 1.0, ptr addrspace(3) %asc0, align 8

  %gep1 = getelementptr inbounds double, ptr getelementptr ([648 x double], ptr addrspacecast (ptr addrspace(3) @lds to ptr), i64 0, i64 384), i64 %idx1
  %asc1 = addrspacecast ptr %gep1 to ptr addrspace(3)
  store double 1.0, ptr addrspace(3) %asc1, align 8

  ret void
}

define void @unorder_constexpr_gep_bitcast() {
; CHECK-LABEL: @unorder_constexpr_gep_bitcast(
; CHECK-NEXT:    [[X0:%.*]] = load i32, ptr addrspace(3) @lds, align 4
; CHECK-NEXT:    [[X1:%.*]] = load i32, ptr addrspace(3) getelementptr (i32, ptr addrspace(3) @lds, i32 1), align 4
; CHECK-NEXT:    call void @use(i32 [[X0]], i32 [[X1]])
; CHECK-NEXT:    ret void
;
  %x0 = load i32, ptr addrspacecast (ptr addrspace(3) @lds to ptr), align 4
  %x1 = load i32, ptr getelementptr (i32, ptr addrspacecast (ptr addrspace(3) @lds to ptr), i32 1), align 4
  call void @use(i32 %x0, i32 %x1)
  ret void
}

declare void @use(i32, i32)
