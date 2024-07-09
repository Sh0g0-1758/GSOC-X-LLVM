; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --check-globals
; RUN: opt -S -passes=openmp-opt < %s | FileCheck %s

; void foo1(int i) {
;   #pragma omp parallel
;     i++;
; }

; void foo(int i) {
;   #pragma omp parallel
;     foo1(i);
; }

; int main() {
;   int i=0;
;   #pragma omp target
;     foo(i);

;   #pragma omp target
;     foo1(i);
; }

target triple = "nvptx64"

%struct.ident_t = type { i32, i32, i32, i32, ptr }
%struct.KernelEnvironmentTy = type { %struct.ConfigurationEnvironmentTy, ptr, ptr }
%struct.ConfigurationEnvironmentTy = type { i8, i8, i8, i32, i32, i32, i32, i32, i32 }

@0 = private unnamed_addr constant [23 x i8] c";unknown;unknown;0;0;;\00", align 1
@1 = private unnamed_addr constant %struct.ident_t { i32 0, i32 2, i32 0, i32 22, ptr @0 }, align 8
@i_shared = internal addrspace(3) global [4 x i8] undef, align 16
@i.i_shared = internal addrspace(3) global [4 x i8] undef, align 16

@__omp_offloading_10302_bd7e0_main_l13_kernel_environment = local_unnamed_addr constant %struct.KernelEnvironmentTy { %struct.ConfigurationEnvironmentTy { i8 0, i8 0, i8 2, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0 }, ptr @1, ptr null }
@__omp_offloading_10302_bd7e0_main_l16_kernel_environment = local_unnamed_addr constant %struct.KernelEnvironmentTy { %struct.ConfigurationEnvironmentTy { i8 1, i8 0, i8 1, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0 }, ptr @1, ptr null }


;.
; CHECK: @[[GLOB0:[0-9]+]] = private unnamed_addr constant [23 x i8] c"
; CHECK: @[[GLOB1:[0-9]+]] = private unnamed_addr constant [[STRUCT_IDENT_T:%.*]] { i32 0, i32 2, i32 0, i32 22, ptr @[[GLOB0]] }, align 8
; CHECK: @[[I_SHARED:[a-zA-Z0-9_$"\\.-]+]] = internal addrspace(3) global [4 x i8] undef, align 16
; CHECK: @[[I_I_SHARED:[a-zA-Z0-9_$"\\.-]+]] = internal addrspace(3) global [4 x i8] undef, align 16
; CHECK: @[[__OMP_OFFLOADING_10302_BD7E0_MAIN_L13_KERNEL_ENVIRONMENT:[a-zA-Z0-9_$"\\.-]+]] = local_unnamed_addr constant [[STRUCT_KERNELENVIRONMENTTY:%.*]] { [[STRUCT_CONFIGURATIONENVIRONMENTTY:%.*]] { i8 0, i8 0, i8 2, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0 }, ptr @[[GLOB1]], ptr null }
; CHECK: @[[__OMP_OFFLOADING_10302_BD7E0_MAIN_L16_KERNEL_ENVIRONMENT:[a-zA-Z0-9_$"\\.-]+]] = local_unnamed_addr constant [[STRUCT_KERNELENVIRONMENTTY:%.*]] { [[STRUCT_CONFIGURATIONENVIRONMENTTY:%.*]] { i8 1, i8 0, i8 1, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0 }, ptr @[[GLOB1]], ptr null }
;.
define weak_odr protected void @__omp_offloading_10302_bd7e0_main_l13(ptr %dyn, i64 noundef %i) local_unnamed_addr "kernel" {
; CHECK-LABEL: @__omp_offloading_10302_bd7e0_main_l13(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CAPTURED_VARS_ADDRS_I:%.*]] = alloca [1 x ptr], align 8
; CHECK-NEXT:    [[TMP0:%.*]] = tail call i32 @__kmpc_target_init(ptr @__omp_offloading_10302_bd7e0_main_l13_kernel_environment, ptr [[DYN:%.*]])
; CHECK-NEXT:    [[EXEC_USER_CODE:%.*]] = icmp eq i32 [[TMP0]], -1
; CHECK-NEXT:    br i1 [[EXEC_USER_CODE]], label [[USER_CODE_ENTRY:%.*]], label [[COMMON_RET:%.*]]
; CHECK:       common.ret:
; CHECK-NEXT:    ret void
; CHECK:       user_code.entry:
; CHECK-NEXT:    call void @llvm.lifetime.start.p0(i64 8, ptr nonnull [[CAPTURED_VARS_ADDRS_I]])
; CHECK-NEXT:    [[TMP1:%.*]] = tail call i32 @__kmpc_global_thread_num(ptr nonnull @[[GLOB1]]) #[[ATTR2:[0-9]+]]
; CHECK-NEXT:    [[TMP2:%.*]] = tail call i32 @__kmpc_get_hardware_thread_id_in_block() #[[ATTR2]]
; CHECK-NEXT:    [[TMP3:%.*]] = icmp eq i32 [[TMP2]], 0
; CHECK-NEXT:    br i1 [[TMP3]], label [[REGION_GUARDED_I:%.*]], label [[_Z3FOOI_INTERNALIZED_EXIT:%.*]]
; CHECK:       region.guarded.i:
; CHECK-NEXT:    [[I_ADDR_SROA_0_0_EXTRACT_TRUNC:%.*]] = trunc i64 [[I:%.*]] to i32
; CHECK-NEXT:    store i32 [[I_ADDR_SROA_0_0_EXTRACT_TRUNC]], ptr addrspacecast (ptr addrspace(3) @i_shared to ptr), align 16
; CHECK-NEXT:    br label [[_Z3FOOI_INTERNALIZED_EXIT]]
; CHECK:       _Z3fooi.internalized.exit:
; CHECK-NEXT:    tail call void @__kmpc_barrier_simple_spmd(ptr nonnull @[[GLOB1]], i32 [[TMP2]]) #[[ATTR2]]
; CHECK-NEXT:    store ptr addrspacecast (ptr addrspace(3) @i_shared to ptr), ptr [[CAPTURED_VARS_ADDRS_I]], align 8
; CHECK-NEXT:    call void @__kmpc_parallel_51(ptr nonnull @[[GLOB1]], i32 [[TMP1]], i32 1, i32 -1, i32 -1, ptr nonnull @__omp_outlined__, ptr nonnull @__omp_outlined___wrapper, ptr nonnull [[CAPTURED_VARS_ADDRS_I]], i64 1)
; CHECK-NEXT:    call void @llvm.lifetime.end.p0(i64 8, ptr nonnull [[CAPTURED_VARS_ADDRS_I]])
; CHECK-NEXT:    call void @__kmpc_target_deinit()
; CHECK-NEXT:    br label [[COMMON_RET]]
;
entry:
  %captured_vars_addrs.i = alloca [1 x ptr], align 8
  %0 = tail call i32 @__kmpc_target_init(ptr @__omp_offloading_10302_bd7e0_main_l13_kernel_environment, ptr %dyn) #6
  %exec_user_code = icmp eq i32 %0, -1
  br i1 %exec_user_code, label %user_code.entry, label %common.ret

common.ret:                                       ; preds = %entry, %_Z3fooi.internalized.exit
  ret void

user_code.entry:                                  ; preds = %entry
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %captured_vars_addrs.i)
  %1 = tail call i32 @__kmpc_global_thread_num(ptr nonnull @1) #6
  %2 = tail call i32 @__kmpc_get_hardware_thread_id_in_block() #6
  %3 = icmp eq i32 %2, 0
  br i1 %3, label %region.guarded.i, label %_Z3fooi.internalized.exit

region.guarded.i:                                 ; preds = %user_code.entry
  %i.addr.sroa.0.0.extract.trunc = trunc i64 %i to i32
  store i32 %i.addr.sroa.0.0.extract.trunc, ptr addrspacecast (ptr addrspace(3) @i_shared to ptr), align 16
  br label %_Z3fooi.internalized.exit

_Z3fooi.internalized.exit:                        ; preds = %user_code.entry, %region.guarded.i
  tail call void @__kmpc_barrier_simple_spmd(ptr nonnull @1, i32 %2)
  store ptr addrspacecast (ptr addrspace(3) @i_shared to ptr), ptr %captured_vars_addrs.i, align 8
  call void @__kmpc_parallel_51(ptr nonnull @1, i32 %1, i32 1, i32 -1, i32 -1, ptr nonnull @__omp_outlined__, ptr nonnull @__omp_outlined___wrapper, ptr nonnull %captured_vars_addrs.i, i64 1) #6
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %captured_vars_addrs.i)
  call void @__kmpc_target_deinit() #6
  br label %common.ret
}

declare i32 @__kmpc_target_init(ptr, ptr) local_unnamed_addr

define hidden void @_Z3fooi(i32 noundef %i1) local_unnamed_addr #1 {
; CHECK-LABEL: @_Z3fooi(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CAPTURED_VARS_ADDRS:%.*]] = alloca [1 x ptr], align 8
; CHECK-NEXT:    [[TMP0:%.*]] = tail call i32 @__kmpc_global_thread_num(ptr nonnull @[[GLOB1]]) #[[ATTR2]]
; CHECK-NEXT:    [[I:%.*]] = tail call align 16 dereferenceable_or_null(4) ptr @__kmpc_alloc_shared(i64 4) #[[ATTR2]]
; CHECK-NEXT:    store i32 [[I1:%.*]], ptr [[I]], align 16
; CHECK-NEXT:    store ptr [[I]], ptr [[CAPTURED_VARS_ADDRS]], align 8
; CHECK-NEXT:    call void @__kmpc_parallel_51(ptr nonnull @[[GLOB1]], i32 [[TMP0]], i32 1, i32 -1, i32 -1, ptr nonnull @__omp_outlined__, ptr nonnull @__omp_outlined___wrapper, ptr nonnull [[CAPTURED_VARS_ADDRS]], i64 1)
; CHECK-NEXT:    call void @__kmpc_free_shared(ptr [[I]], i64 4) #[[ATTR2]]
; CHECK-NEXT:    ret void
;
entry:
  %captured_vars_addrs = alloca [1 x ptr], align 8
  %0 = tail call i32 @__kmpc_global_thread_num(ptr nonnull @1) #6
  %i = tail call align 16 dereferenceable_or_null(4) ptr @__kmpc_alloc_shared(i64 4)
  store i32 %i1, ptr %i, align 16
  store ptr %i, ptr %captured_vars_addrs, align 8
  call void @__kmpc_parallel_51(ptr nonnull @1, i32 %0, i32 1, i32 -1, i32 -1, ptr nonnull @__omp_outlined__, ptr nonnull @__omp_outlined___wrapper, ptr nonnull %captured_vars_addrs, i64 1) #6
  call void @__kmpc_free_shared(ptr %i, i64 4)
  ret void
}

declare void @__kmpc_target_deinit(ptr, i8) local_unnamed_addr

define weak_odr protected void @__omp_offloading_10302_bd7e0_main_l16(ptr %dyn, i64 noundef %i) local_unnamed_addr "kernel" {
; CHECK-LABEL: @__omp_offloading_10302_bd7e0_main_l16(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CAPTURED_VARS_ADDRS_I:%.*]] = alloca [1 x ptr], align 8
; CHECK-NEXT:    [[TMP0:%.*]] = tail call i32 @__kmpc_target_init(ptr @__omp_offloading_10302_bd7e0_main_l16_kernel_environment, ptr [[DYN:%.*]])
; CHECK-NEXT:    [[EXEC_USER_CODE:%.*]] = icmp eq i32 [[TMP0]], -1
; CHECK-NEXT:    br i1 [[EXEC_USER_CODE]], label [[USER_CODE_ENTRY:%.*]], label [[COMMON_RET:%.*]]
; CHECK:       common.ret:
; CHECK-NEXT:    ret void
; CHECK:       user_code.entry:
; CHECK-NEXT:    [[I_ADDR_SROA_0_0_EXTRACT_TRUNC:%.*]] = trunc i64 [[I:%.*]] to i32
; CHECK-NEXT:    call void @llvm.lifetime.start.p0(i64 8, ptr nonnull [[CAPTURED_VARS_ADDRS_I]])
; CHECK-NEXT:    [[TMP1:%.*]] = tail call i32 @__kmpc_global_thread_num(ptr nonnull @[[GLOB1]]) #[[ATTR2]]
; CHECK-NEXT:    store i32 [[I_ADDR_SROA_0_0_EXTRACT_TRUNC]], ptr addrspacecast (ptr addrspace(3) @i.i_shared to ptr), align 16
; CHECK-NEXT:    store ptr addrspacecast (ptr addrspace(3) @i.i_shared to ptr), ptr [[CAPTURED_VARS_ADDRS_I]], align 8
; CHECK-NEXT:    call void @__kmpc_parallel_51(ptr nonnull @[[GLOB1]], i32 [[TMP1]], i32 1, i32 -1, i32 -1, ptr nonnull @__omp_outlined__1, ptr nonnull @__omp_outlined__1_wrapper, ptr nonnull [[CAPTURED_VARS_ADDRS_I]], i64 1)
; CHECK-NEXT:    call void @llvm.lifetime.end.p0(i64 8, ptr nonnull [[CAPTURED_VARS_ADDRS_I]])
; CHECK-NEXT:    call void @__kmpc_target_deinit()
; CHECK-NEXT:    br label [[COMMON_RET]]
;
entry:
  %captured_vars_addrs.i = alloca [1 x ptr], align 8
  %0 = tail call i32 @__kmpc_target_init(ptr @__omp_offloading_10302_bd7e0_main_l16_kernel_environment, ptr %dyn) #6
  %exec_user_code = icmp eq i32 %0, -1
  br i1 %exec_user_code, label %user_code.entry, label %common.ret

common.ret:                                       ; preds = %entry, %user_code.entry
  ret void

user_code.entry:                                  ; preds = %entry
  %i.addr.sroa.0.0.extract.trunc = trunc i64 %i to i32
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %captured_vars_addrs.i)
  %1 = tail call i32 @__kmpc_global_thread_num(ptr nonnull @1) #6
  store i32 %i.addr.sroa.0.0.extract.trunc, ptr addrspacecast (ptr addrspace(3) @i.i_shared to ptr), align 16
  store ptr addrspacecast (ptr addrspace(3) @i.i_shared to ptr), ptr %captured_vars_addrs.i, align 8
  call void @__kmpc_parallel_51(ptr nonnull @1, i32 %1, i32 1, i32 -1, i32 -1, ptr nonnull @__omp_outlined__1, ptr nonnull @__omp_outlined__1_wrapper, ptr nonnull %captured_vars_addrs.i, i64 1) #6
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %captured_vars_addrs.i)
  call void @__kmpc_target_deinit() #6
  br label %common.ret
}

define hidden void @_Z4foo1i(i32 noundef %i1) local_unnamed_addr #1 {
; CHECK-LABEL: @_Z4foo1i(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CAPTURED_VARS_ADDRS:%.*]] = alloca [1 x ptr], align 8
; CHECK-NEXT:    [[TMP0:%.*]] = tail call i32 @__kmpc_global_thread_num(ptr nonnull @[[GLOB1]]) #[[ATTR2]]
; CHECK-NEXT:    [[I:%.*]] = tail call align 16 dereferenceable_or_null(4) ptr @__kmpc_alloc_shared(i64 4) #[[ATTR2]]
; CHECK-NEXT:    store i32 [[I1:%.*]], ptr [[I]], align 16
; CHECK-NEXT:    store ptr [[I]], ptr [[CAPTURED_VARS_ADDRS]], align 8
; CHECK-NEXT:    call void @__kmpc_parallel_51(ptr nonnull @[[GLOB1]], i32 [[TMP0]], i32 1, i32 -1, i32 -1, ptr nonnull @__omp_outlined__1, ptr nonnull @__omp_outlined__1_wrapper, ptr nonnull [[CAPTURED_VARS_ADDRS]], i64 1)
; CHECK-NEXT:    call void @__kmpc_free_shared(ptr [[I]], i64 4) #[[ATTR2]]
; CHECK-NEXT:    ret void
;
entry:
  %captured_vars_addrs = alloca [1 x ptr], align 8
  %0 = tail call i32 @__kmpc_global_thread_num(ptr nonnull @1) #6
  %i = tail call align 16 dereferenceable_or_null(4) ptr @__kmpc_alloc_shared(i64 4)
  store i32 %i1, ptr %i, align 16
  store ptr %i, ptr %captured_vars_addrs, align 8
  call void @__kmpc_parallel_51(ptr nonnull @1, i32 %0, i32 1, i32 -1, i32 -1, ptr nonnull @__omp_outlined__1, ptr nonnull @__omp_outlined__1_wrapper, ptr nonnull %captured_vars_addrs, i64 1) #6
  call void @__kmpc_free_shared(ptr %i, i64 4)
  ret void
}

declare ptr @__kmpc_alloc_shared(i64) local_unnamed_addr #3

define internal void @__omp_outlined__(ptr noalias nocapture readnone %.global_tid., ptr noalias nocapture readnone %.bound_tid., ptr nocapture noundef nonnull readonly align 4 dereferenceable(4) %i) #4 {
; CHECK-LABEL: @__omp_outlined__(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CAPTURED_VARS_ADDRS_I:%.*]] = alloca [1 x ptr], align 8
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, ptr [[I:%.*]], align 4
; CHECK-NEXT:    call void @llvm.lifetime.start.p0(i64 8, ptr nonnull [[CAPTURED_VARS_ADDRS_I]])
; CHECK-NEXT:    [[TMP1:%.*]] = tail call i32 @__kmpc_global_thread_num(ptr nonnull @[[GLOB1]]) #[[ATTR2]]
; CHECK-NEXT:    [[I_I:%.*]] = tail call align 16 dereferenceable_or_null(4) ptr @__kmpc_alloc_shared(i64 4) #[[ATTR2]]
; CHECK-NEXT:    store i32 [[TMP0]], ptr [[I_I]], align 16
; CHECK-NEXT:    store ptr [[I_I]], ptr [[CAPTURED_VARS_ADDRS_I]], align 8
; CHECK-NEXT:    call void @__kmpc_parallel_51(ptr nonnull @[[GLOB1]], i32 [[TMP1]], i32 1, i32 -1, i32 -1, ptr nonnull @__omp_outlined__1, ptr nonnull @__omp_outlined__1_wrapper, ptr nonnull [[CAPTURED_VARS_ADDRS_I]], i64 1)
; CHECK-NEXT:    call void @__kmpc_free_shared(ptr [[I_I]], i64 4) #[[ATTR2]]
; CHECK-NEXT:    call void @llvm.lifetime.end.p0(i64 8, ptr nonnull [[CAPTURED_VARS_ADDRS_I]])
; CHECK-NEXT:    ret void
;
entry:
  %captured_vars_addrs.i = alloca [1 x ptr], align 8
  %0 = load i32, ptr %i, align 4
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %captured_vars_addrs.i)
  %1 = tail call i32 @__kmpc_global_thread_num(ptr nonnull @1) #6
  %i.i = tail call align 16 dereferenceable_or_null(4) ptr @__kmpc_alloc_shared(i64 4) #6
  store i32 %0, ptr %i.i, align 16
  store ptr %i.i, ptr %captured_vars_addrs.i, align 8
  call void @__kmpc_parallel_51(ptr nonnull @1, i32 %1, i32 1, i32 -1, i32 -1, ptr nonnull @__omp_outlined__1, ptr nonnull @__omp_outlined__1_wrapper, ptr nonnull %captured_vars_addrs.i, i64 1) #6
  call void @__kmpc_free_shared(ptr %i.i, i64 4) #6
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %captured_vars_addrs.i)
  ret void
}

define internal void @__omp_outlined___wrapper(i16 zeroext %0, i32 %1) #5 {
; CHECK-LABEL: @__omp_outlined___wrapper(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CAPTURED_VARS_ADDRS_I_I:%.*]] = alloca [1 x ptr], align 8
; CHECK-NEXT:    [[GLOBAL_ARGS:%.*]] = alloca ptr, align 8
; CHECK-NEXT:    call void @__kmpc_get_shared_variables(ptr nonnull [[GLOBAL_ARGS]])
; CHECK-NEXT:    [[TMP2:%.*]] = load ptr, ptr [[GLOBAL_ARGS]], align 8
; CHECK-NEXT:    [[TMP3:%.*]] = load ptr, ptr [[TMP2]], align 8
; CHECK-NEXT:    [[TMP4:%.*]] = load i32, ptr [[TMP3]], align 4
; CHECK-NEXT:    call void @llvm.lifetime.start.p0(i64 8, ptr nonnull [[CAPTURED_VARS_ADDRS_I_I]])
; CHECK-NEXT:    [[TMP5:%.*]] = call i32 @__kmpc_global_thread_num(ptr nonnull @[[GLOB1]]) #[[ATTR2]]
; CHECK-NEXT:    [[I_I_I:%.*]] = call align 16 dereferenceable_or_null(4) ptr @__kmpc_alloc_shared(i64 4) #[[ATTR2]]
; CHECK-NEXT:    store i32 [[TMP4]], ptr [[I_I_I]], align 16
; CHECK-NEXT:    store ptr [[I_I_I]], ptr [[CAPTURED_VARS_ADDRS_I_I]], align 8
; CHECK-NEXT:    call void @__kmpc_parallel_51(ptr nonnull @[[GLOB1]], i32 [[TMP5]], i32 1, i32 -1, i32 -1, ptr nonnull @__omp_outlined__1, ptr nonnull @__omp_outlined__1_wrapper, ptr nonnull [[CAPTURED_VARS_ADDRS_I_I]], i64 1)
; CHECK-NEXT:    call void @__kmpc_free_shared(ptr [[I_I_I]], i64 4) #[[ATTR2]]
; CHECK-NEXT:    call void @llvm.lifetime.end.p0(i64 8, ptr nonnull [[CAPTURED_VARS_ADDRS_I_I]])
; CHECK-NEXT:    ret void
;
entry:
  %captured_vars_addrs.i.i = alloca [1 x ptr], align 8
  %global_args = alloca ptr, align 8
  call void @__kmpc_get_shared_variables(ptr nonnull %global_args) #6
  %2 = load ptr, ptr %global_args, align 8
  %3 = load ptr, ptr %2, align 8
  %4 = load i32, ptr %3, align 4
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %captured_vars_addrs.i.i)
  %5 = call i32 @__kmpc_global_thread_num(ptr nonnull @1) #6
  %i.i.i = call align 16 dereferenceable_or_null(4) ptr @__kmpc_alloc_shared(i64 4) #6
  store i32 %4, ptr %i.i.i, align 16
  store ptr %i.i.i, ptr %captured_vars_addrs.i.i, align 8
  call void @__kmpc_parallel_51(ptr nonnull @1, i32 %5, i32 1, i32 -1, i32 -1, ptr nonnull @__omp_outlined__1, ptr nonnull @__omp_outlined__1_wrapper, ptr nonnull %captured_vars_addrs.i.i, i64 1) #6
  call void @__kmpc_free_shared(ptr %i.i.i, i64 4) #6
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %captured_vars_addrs.i.i)
  ret void
}

declare void @__kmpc_get_shared_variables(ptr) local_unnamed_addr

declare i32 @__kmpc_global_thread_num(ptr) local_unnamed_addr #6

declare void @__kmpc_parallel_51(ptr, i32, i32, i32, i32, ptr, ptr, ptr, i64) local_unnamed_addr #7

declare void @__kmpc_free_shared(ptr allocptr nocapture, i64) local_unnamed_addr #8

define internal void @__omp_outlined__1(ptr noalias nocapture readnone %.global_tid., ptr noalias nocapture readnone %.bound_tid., ptr nocapture noundef nonnull align 4 dereferenceable(4) %i) #9 {
; CHECK-LABEL: @__omp_outlined__1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, ptr [[I:%.*]], align 4
; CHECK-NEXT:    [[INC:%.*]] = add nsw i32 [[TMP0]], 1
; CHECK-NEXT:    store i32 [[INC]], ptr [[I]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %0 = load i32, ptr %i, align 4
  %inc = add nsw i32 %0, 1
  store i32 %inc, ptr %i, align 4
  ret void
}

define internal void @__omp_outlined__1_wrapper(i16 zeroext %0, i32 %1) #5 {
; CHECK-LABEL: @__omp_outlined__1_wrapper(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[GLOBAL_ARGS:%.*]] = alloca ptr, align 8
; CHECK-NEXT:    call void @__kmpc_get_shared_variables(ptr nonnull [[GLOBAL_ARGS]])
; CHECK-NEXT:    [[TMP2:%.*]] = load ptr, ptr [[GLOBAL_ARGS]], align 8
; CHECK-NEXT:    [[TMP3:%.*]] = load ptr, ptr [[TMP2]], align 8
; CHECK-NEXT:    [[TMP4:%.*]] = load i32, ptr [[TMP3]], align 4
; CHECK-NEXT:    [[INC_I:%.*]] = add nsw i32 [[TMP4]], 1
; CHECK-NEXT:    store i32 [[INC_I]], ptr [[TMP3]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %global_args = alloca ptr, align 8
  call void @__kmpc_get_shared_variables(ptr nonnull %global_args) #6
  %2 = load ptr, ptr %global_args, align 8
  %3 = load ptr, ptr %2, align 8
  %4 = load i32, ptr %3, align 4
  %inc.i = add nsw i32 %4, 1
  store i32 %inc.i, ptr %3, align 4
  ret void
}

declare i32 @__kmpc_get_hardware_thread_id_in_block() local_unnamed_addr

declare void @__kmpc_barrier_simple_spmd(ptr, i32) local_unnamed_addr #10

declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #11

declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #11


!omp_offload.info = !{!0, !1}
!nvvm.annotations = !{!2, !3}
!llvm.module.flags = !{!4, !5}

!0 = !{i32 0, i32 66306, i32 776160, !"main", i32 13, i32 0, i32 0}
!1 = !{i32 0, i32 66306, i32 776160, !"main", i32 16, i32 0, i32 1}
!2 = !{ptr @__omp_offloading_10302_bd7e0_main_l13, !"kernel", i32 1}
!3 = !{ptr @__omp_offloading_10302_bd7e0_main_l16, !"kernel", i32 1}

!4 = !{i32 7, !"openmp", i32 50}
!5 = !{i32 7, !"openmp-device", i32 50}
;.
; CHECK: attributes #[[ATTR0:[0-9]+]] = { "kernel" }
; CHECK: attributes #[[ATTR1:[0-9]+]] = { nosync nounwind allocsize(0) }
; CHECK: attributes #[[ATTR2]] = { nounwind }
; CHECK: attributes #[[ATTR3:[0-9]+]] = { alwaysinline }
; CHECK: attributes #[[ATTR4:[0-9]+]] = { nosync nounwind }
; CHECK: attributes #[[ATTR5:[0-9]+]] = { convergent nounwind }
; CHECK: attributes #[[ATTR6:[0-9]+]] = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
;.
; CHECK: [[META0:![0-9]+]] = !{i32 0, i32 66306, i32 776160, !"main", i32 13, i32 0, i32 0}
; CHECK: [[META1:![0-9]+]] = !{i32 0, i32 66306, i32 776160, !"main", i32 16, i32 0, i32 1}
; CHECK: [[META2:![0-9]+]] = !{ptr @__omp_offloading_10302_bd7e0_main_l13, !"kernel", i32 1}
; CHECK: [[META3:![0-9]+]] = !{ptr @__omp_offloading_10302_bd7e0_main_l16, !"kernel", i32 1}
; CHECK: [[META4:![0-9]+]] = !{i32 7, !"openmp", i32 50}
; CHECK: [[META5:![0-9]+]] = !{i32 7, !"openmp-device", i32 50}
;.
