; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 2
; RUN: llc < %s -O3 -mtriple=arm64-apple-ios -disable-post-ra | FileCheck %s
; <rdar://13463602>

%struct.Counter_Struct = type { i64, i64 }
%struct.Bicubic_Patch_Struct = type { ptr, i32, ptr, ptr, ptr, ptr, ptr, %struct.Bounding_Box_Struct, i64, i32, i32, i32, [4 x [4 x [3 x double]]], [3 x double], double, double, ptr }
%struct.Method_Struct = type { ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr }
%struct.Object_Struct = type { ptr, i32, ptr, ptr, ptr, ptr, ptr, %struct.Bounding_Box_Struct, i64 }
%struct.Texture_Struct = type { i16, i16, i16, i32, float, float, float, ptr, ptr, ptr, %union.anon.9, ptr, ptr, ptr, ptr, ptr, i32 }
%struct.Warps_Struct = type { i16, ptr }
%struct.Pattern_Struct = type { i16, i16, i16, i32, float, float, float, ptr, ptr, ptr, %union.anon.6 }
%struct.Blend_Map_Struct = type { i16, i16, i16, i64, ptr }
%struct.Blend_Map_Entry = type { float, i8, %union.anon }
%union.anon = type { [2 x double], [8 x i8] }
%union.anon.6 = type { %struct.anon.7 }
%struct.anon.7 = type { float, [3 x double] }
%union.anon.9 = type { %struct.anon.10 }
%struct.anon.10 = type { float, [3 x double] }
%struct.Pigment_Struct = type { i16, i16, i16, i32, float, float, float, ptr, ptr, ptr, %union.anon.0, [5 x float] }
%union.anon.0 = type { %struct.anon }
%struct.anon = type { float, [3 x double] }
%struct.Tnormal_Struct = type { i16, i16, i16, i32, float, float, float, ptr, ptr, ptr, %union.anon.3, float }
%union.anon.3 = type { %struct.anon.4 }
%struct.anon.4 = type { float, [3 x double] }
%struct.Finish_Struct = type { float, float, float, float, float, float, float, float, float, float, float, float, float, float, float, [3 x float], [3 x float] }
%struct.Interior_Struct = type { i64, i32, float, float, float, float, float, ptr }
%struct.Media_Struct = type { i32, i32, i32, i32, i32, double, double, i32, i32, i32, i32, [5 x float], [5 x float], [5 x float], [5 x float], double, double, double, ptr, ptr, ptr }
%struct.Bounding_Box_Struct = type { [3 x float], [3 x float] }
%struct.Ray_Struct = type { [3 x double], [3 x double], i32, [100 x ptr] }
%struct.istack_struct = type { ptr, ptr, i32 }
%struct.istk_entry = type { double, [3 x double], [3 x double], ptr, i32, i32, double, double, ptr }
%struct.Transform_Struct = type { [4 x [4 x double]], [4 x [4 x double]] }
%struct.Bezier_Node_Struct = type { i32, [3 x double], double, i32, ptr }

define void @Precompute_Patch_Values(ptr %Shape) {
; CHECK-LABEL: Precompute_Patch_Values:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    sub sp, sp, #400
; CHECK-NEXT:    stp x28, x27, [sp, #384] ; 16-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 400
; CHECK-NEXT:    .cfi_offset w27, -8
; CHECK-NEXT:    .cfi_offset w28, -16
; CHECK-NEXT:    ldr q0, [x0, #272]
; CHECK-NEXT:    ldr x8, [x0, #288]
; CHECK-NEXT:    stur q0, [sp, #216]
; CHECK-NEXT:    str x8, [sp, #232]
; CHECK-NEXT:    ldp x28, x27, [sp, #384] ; 16-byte Folded Reload
; CHECK-NEXT:    add sp, sp, #400
; CHECK-NEXT:    ret
entry:
  %Control_Points = alloca [16 x [3 x double]], align 8
  %arraydecay5.3.1 = getelementptr inbounds [16 x [3 x double]], ptr %Control_Points, i64 0, i64 9, i64 0
  %arraydecay11.3.1 = getelementptr inbounds %struct.Bicubic_Patch_Struct, ptr %Shape, i64 0, i32 12, i64 1, i64 3, i64 0
  call void @llvm.memcpy.p0.p0.i64(ptr %arraydecay5.3.1, ptr %arraydecay11.3.1, i64 24, i1 false)
  ret void
}

; Function Attrs: nounwind
declare void @llvm.memcpy.p0.p0.i64(ptr nocapture, ptr nocapture, i64, i1)
