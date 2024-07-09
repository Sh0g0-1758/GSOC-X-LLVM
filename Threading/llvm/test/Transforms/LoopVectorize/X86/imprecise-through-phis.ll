; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes=loop-vectorize -mtriple=x86_64-apple-darwin %s | FileCheck %s --check-prefixes=CHECK,SSE
; RUN: opt -S -passes=loop-vectorize -mtriple=x86_64-apple-darwin -mattr=+avx %s | FileCheck %s --check-prefixes=CHECK,AVX

; Two mostly identical functions. The only difference is the presence of
; fast-math flags on the second. The loop is a pretty simple reduction:

; for (int i = 0; i < 32; ++i)
;   if (arr[i] != 42)
;     tot += arr[i];

define double @sumIfScalar(ptr nocapture readonly %arr) {
; CHECK-LABEL: @sumIfScalar(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[I:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[I_NEXT:%.*]], [[NEXT_ITER:%.*]] ]
; CHECK-NEXT:    [[TOT:%.*]] = phi double [ 0.000000e+00, [[ENTRY]] ], [ [[TOT_NEXT:%.*]], [[NEXT_ITER]] ]
; CHECK-NEXT:    [[ADDR:%.*]] = getelementptr double, ptr [[ARR:%.*]], i32 [[I]]
; CHECK-NEXT:    [[NEXTVAL:%.*]] = load double, ptr [[ADDR]], align 8
; CHECK-NEXT:    [[TST:%.*]] = fcmp une double [[NEXTVAL]], 4.200000e+01
; CHECK-NEXT:    br i1 [[TST]], label [[DO_ADD:%.*]], label [[NO_ADD:%.*]]
; CHECK:       do.add:
; CHECK-NEXT:    [[TOT_NEW:%.*]] = fadd double [[TOT]], [[NEXTVAL]]
; CHECK-NEXT:    br label [[NEXT_ITER]]
; CHECK:       no.add:
; CHECK-NEXT:    br label [[NEXT_ITER]]
; CHECK:       next.iter:
; CHECK-NEXT:    [[TOT_NEXT]] = phi double [ [[TOT]], [[NO_ADD]] ], [ [[TOT_NEW]], [[DO_ADD]] ]
; CHECK-NEXT:    [[I_NEXT]] = add i32 [[I]], 1
; CHECK-NEXT:    [[AGAIN:%.*]] = icmp ult i32 [[I_NEXT]], 32
; CHECK-NEXT:    br i1 [[AGAIN]], label [[LOOP]], label [[DONE:%.*]]
; CHECK:       done:
; CHECK-NEXT:    [[TOT_NEXT_LCSSA:%.*]] = phi double [ [[TOT_NEXT]], [[NEXT_ITER]] ]
; CHECK-NEXT:    ret double [[TOT_NEXT_LCSSA]]
;
entry:
  br label %loop

loop:
  %i = phi i32 [0, %entry], [%i.next, %next.iter]
  %tot = phi double [0.0, %entry], [%tot.next, %next.iter]

  %addr = getelementptr double, ptr %arr, i32 %i
  %nextval = load double, ptr %addr

  %tst = fcmp une double %nextval, 42.0
  br i1 %tst, label %do.add, label %no.add

do.add:
  %tot.new = fadd double %tot, %nextval
  br label %next.iter

no.add:
  br label %next.iter

next.iter:
  %tot.next = phi double [%tot, %no.add], [%tot.new, %do.add]
  %i.next = add i32 %i, 1
  %again = icmp ult i32 %i.next, 32
  br i1 %again, label %loop, label %done

done:
  ret double %tot.next
}

define double @sumIfVector(ptr nocapture readonly %arr) {
; SSE-LABEL: @sumIfVector(
; SSE-NEXT:  entry:
; SSE-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; SSE:       vector.ph:
; SSE-NEXT:    br label [[VECTOR_BODY:%.*]]
; SSE:       vector.body:
; SSE-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; SSE-NEXT:    [[VEC_PHI:%.*]] = phi <2 x double> [ zeroinitializer, [[VECTOR_PH]] ], [ [[PREDPHI:%.*]], [[VECTOR_BODY]] ]
; SSE-NEXT:    [[VEC_PHI1:%.*]] = phi <2 x double> [ zeroinitializer, [[VECTOR_PH]] ], [ [[PREDPHI3:%.*]], [[VECTOR_BODY]] ]
; SSE-NEXT:    [[TMP0:%.*]] = add i32 [[INDEX]], 0
; SSE-NEXT:    [[TMP1:%.*]] = add i32 [[INDEX]], 2
; SSE-NEXT:    [[TMP2:%.*]] = getelementptr double, ptr [[ARR:%.*]], i32 [[TMP0]]
; SSE-NEXT:    [[TMP3:%.*]] = getelementptr double, ptr [[ARR]], i32 [[TMP1]]
; SSE-NEXT:    [[TMP4:%.*]] = getelementptr double, ptr [[TMP2]], i32 0
; SSE-NEXT:    [[TMP5:%.*]] = getelementptr double, ptr [[TMP2]], i32 2
; SSE-NEXT:    [[WIDE_LOAD:%.*]] = load <2 x double>, ptr [[TMP4]], align 8
; SSE-NEXT:    [[WIDE_LOAD2:%.*]] = load <2 x double>, ptr [[TMP5]], align 8
; SSE-NEXT:    [[TMP6:%.*]] = fcmp fast une <2 x double> [[WIDE_LOAD]], <double 4.200000e+01, double 4.200000e+01>
; SSE-NEXT:    [[TMP7:%.*]] = fcmp fast une <2 x double> [[WIDE_LOAD2]], <double 4.200000e+01, double 4.200000e+01>
; SSE-NEXT:    [[TMP8:%.*]] = xor <2 x i1> [[TMP6]], <i1 true, i1 true>
; SSE-NEXT:    [[TMP9:%.*]] = xor <2 x i1> [[TMP7]], <i1 true, i1 true>
; SSE-NEXT:    [[TMP10:%.*]] = fadd fast <2 x double> [[VEC_PHI]], [[WIDE_LOAD]]
; SSE-NEXT:    [[TMP11:%.*]] = fadd fast <2 x double> [[VEC_PHI1]], [[WIDE_LOAD2]]
; SSE-NEXT:    [[PREDPHI]] = select <2 x i1> [[TMP6]], <2 x double> [[TMP10]], <2 x double> [[VEC_PHI]]
; SSE-NEXT:    [[PREDPHI3]] = select <2 x i1> [[TMP7]], <2 x double> [[TMP11]], <2 x double> [[VEC_PHI1]]
; SSE-NEXT:    [[INDEX_NEXT]] = add nuw i32 [[INDEX]], 4
; SSE-NEXT:    [[TMP12:%.*]] = icmp eq i32 [[INDEX_NEXT]], 32
; SSE-NEXT:    br i1 [[TMP12]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; SSE:       middle.block:
; SSE-NEXT:    [[BIN_RDX:%.*]] = fadd fast <2 x double> [[PREDPHI3]], [[PREDPHI]]
; SSE-NEXT:    [[TMP13:%.*]] = call fast double @llvm.vector.reduce.fadd.v2f64(double -0.000000e+00, <2 x double> [[BIN_RDX]])
; SSE-NEXT:    br i1 true, label [[DONE:%.*]], label [[SCALAR_PH]]
; SSE:       scalar.ph:
; SSE-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i32 [ 32, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; SSE-NEXT:    [[BC_MERGE_RDX:%.*]] = phi double [ 0.000000e+00, [[ENTRY]] ], [ [[TMP13]], [[MIDDLE_BLOCK]] ]
; SSE-NEXT:    br label [[LOOP:%.*]]
; SSE:       loop:
; SSE-NEXT:    [[I:%.*]] = phi i32 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[I_NEXT:%.*]], [[NEXT_ITER:%.*]] ]
; SSE-NEXT:    [[TOT:%.*]] = phi double [ [[BC_MERGE_RDX]], [[SCALAR_PH]] ], [ [[TOT_NEXT:%.*]], [[NEXT_ITER]] ]
; SSE-NEXT:    [[ADDR:%.*]] = getelementptr double, ptr [[ARR]], i32 [[I]]
; SSE-NEXT:    [[NEXTVAL:%.*]] = load double, ptr [[ADDR]], align 8
; SSE-NEXT:    [[TST:%.*]] = fcmp fast une double [[NEXTVAL]], 4.200000e+01
; SSE-NEXT:    br i1 [[TST]], label [[DO_ADD:%.*]], label [[NO_ADD:%.*]]
; SSE:       do.add:
; SSE-NEXT:    [[TOT_NEW:%.*]] = fadd fast double [[TOT]], [[NEXTVAL]]
; SSE-NEXT:    br label [[NEXT_ITER]]
; SSE:       no.add:
; SSE-NEXT:    br label [[NEXT_ITER]]
; SSE:       next.iter:
; SSE-NEXT:    [[TOT_NEXT]] = phi double [ [[TOT]], [[NO_ADD]] ], [ [[TOT_NEW]], [[DO_ADD]] ]
; SSE-NEXT:    [[I_NEXT]] = add i32 [[I]], 1
; SSE-NEXT:    [[AGAIN:%.*]] = icmp ult i32 [[I_NEXT]], 32
; SSE-NEXT:    br i1 [[AGAIN]], label [[LOOP]], label [[DONE]], !llvm.loop [[LOOP3:![0-9]+]]
; SSE:       done:
; SSE-NEXT:    [[TOT_NEXT_LCSSA:%.*]] = phi double [ [[TOT_NEXT]], [[NEXT_ITER]] ], [ [[TMP13]], [[MIDDLE_BLOCK]] ]
; SSE-NEXT:    ret double [[TOT_NEXT_LCSSA]]
;
; AVX-LABEL: @sumIfVector(
; AVX-NEXT:  entry:
; AVX-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; AVX:       vector.ph:
; AVX-NEXT:    br label [[VECTOR_BODY:%.*]]
; AVX:       vector.body:
; AVX-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; AVX-NEXT:    [[VEC_PHI:%.*]] = phi <4 x double> [ zeroinitializer, [[VECTOR_PH]] ], [ [[PREDPHI:%.*]], [[VECTOR_BODY]] ]
; AVX-NEXT:    [[VEC_PHI1:%.*]] = phi <4 x double> [ zeroinitializer, [[VECTOR_PH]] ], [ [[PREDPHI7:%.*]], [[VECTOR_BODY]] ]
; AVX-NEXT:    [[VEC_PHI2:%.*]] = phi <4 x double> [ zeroinitializer, [[VECTOR_PH]] ], [ [[PREDPHI8:%.*]], [[VECTOR_BODY]] ]
; AVX-NEXT:    [[VEC_PHI3:%.*]] = phi <4 x double> [ zeroinitializer, [[VECTOR_PH]] ], [ [[PREDPHI9:%.*]], [[VECTOR_BODY]] ]
; AVX-NEXT:    [[TMP0:%.*]] = add i32 [[INDEX]], 0
; AVX-NEXT:    [[TMP1:%.*]] = add i32 [[INDEX]], 4
; AVX-NEXT:    [[TMP2:%.*]] = add i32 [[INDEX]], 8
; AVX-NEXT:    [[TMP3:%.*]] = add i32 [[INDEX]], 12
; AVX-NEXT:    [[TMP4:%.*]] = getelementptr double, ptr [[ARR:%.*]], i32 [[TMP0]]
; AVX-NEXT:    [[TMP5:%.*]] = getelementptr double, ptr [[ARR]], i32 [[TMP1]]
; AVX-NEXT:    [[TMP6:%.*]] = getelementptr double, ptr [[ARR]], i32 [[TMP2]]
; AVX-NEXT:    [[TMP7:%.*]] = getelementptr double, ptr [[ARR]], i32 [[TMP3]]
; AVX-NEXT:    [[TMP8:%.*]] = getelementptr double, ptr [[TMP4]], i32 0
; AVX-NEXT:    [[TMP9:%.*]] = getelementptr double, ptr [[TMP4]], i32 4
; AVX-NEXT:    [[TMP10:%.*]] = getelementptr double, ptr [[TMP4]], i32 8
; AVX-NEXT:    [[TMP11:%.*]] = getelementptr double, ptr [[TMP4]], i32 12
; AVX-NEXT:    [[WIDE_LOAD:%.*]] = load <4 x double>, ptr [[TMP8]], align 8
; AVX-NEXT:    [[WIDE_LOAD4:%.*]] = load <4 x double>, ptr [[TMP9]], align 8
; AVX-NEXT:    [[WIDE_LOAD5:%.*]] = load <4 x double>, ptr [[TMP10]], align 8
; AVX-NEXT:    [[WIDE_LOAD6:%.*]] = load <4 x double>, ptr [[TMP11]], align 8
; AVX-NEXT:    [[TMP12:%.*]] = fcmp fast une <4 x double> [[WIDE_LOAD]], <double 4.200000e+01, double 4.200000e+01, double 4.200000e+01, double 4.200000e+01>
; AVX-NEXT:    [[TMP13:%.*]] = fcmp fast une <4 x double> [[WIDE_LOAD4]], <double 4.200000e+01, double 4.200000e+01, double 4.200000e+01, double 4.200000e+01>
; AVX-NEXT:    [[TMP14:%.*]] = fcmp fast une <4 x double> [[WIDE_LOAD5]], <double 4.200000e+01, double 4.200000e+01, double 4.200000e+01, double 4.200000e+01>
; AVX-NEXT:    [[TMP15:%.*]] = fcmp fast une <4 x double> [[WIDE_LOAD6]], <double 4.200000e+01, double 4.200000e+01, double 4.200000e+01, double 4.200000e+01>
; AVX-NEXT:    [[TMP16:%.*]] = xor <4 x i1> [[TMP12]], <i1 true, i1 true, i1 true, i1 true>
; AVX-NEXT:    [[TMP17:%.*]] = xor <4 x i1> [[TMP13]], <i1 true, i1 true, i1 true, i1 true>
; AVX-NEXT:    [[TMP18:%.*]] = xor <4 x i1> [[TMP14]], <i1 true, i1 true, i1 true, i1 true>
; AVX-NEXT:    [[TMP19:%.*]] = xor <4 x i1> [[TMP15]], <i1 true, i1 true, i1 true, i1 true>
; AVX-NEXT:    [[TMP20:%.*]] = fadd fast <4 x double> [[VEC_PHI]], [[WIDE_LOAD]]
; AVX-NEXT:    [[TMP21:%.*]] = fadd fast <4 x double> [[VEC_PHI1]], [[WIDE_LOAD4]]
; AVX-NEXT:    [[TMP22:%.*]] = fadd fast <4 x double> [[VEC_PHI2]], [[WIDE_LOAD5]]
; AVX-NEXT:    [[TMP23:%.*]] = fadd fast <4 x double> [[VEC_PHI3]], [[WIDE_LOAD6]]
; AVX-NEXT:    [[PREDPHI]] = select <4 x i1> [[TMP12]], <4 x double> [[TMP20]], <4 x double> [[VEC_PHI]]
; AVX-NEXT:    [[PREDPHI7]] = select <4 x i1> [[TMP13]], <4 x double> [[TMP21]], <4 x double> [[VEC_PHI1]]
; AVX-NEXT:    [[PREDPHI8]] = select <4 x i1> [[TMP14]], <4 x double> [[TMP22]], <4 x double> [[VEC_PHI2]]
; AVX-NEXT:    [[PREDPHI9]] = select <4 x i1> [[TMP15]], <4 x double> [[TMP23]], <4 x double> [[VEC_PHI3]]
; AVX-NEXT:    [[INDEX_NEXT]] = add nuw i32 [[INDEX]], 16
; AVX-NEXT:    [[TMP24:%.*]] = icmp eq i32 [[INDEX_NEXT]], 32
; AVX-NEXT:    br i1 [[TMP24]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; AVX:       middle.block:
; AVX-NEXT:    [[BIN_RDX:%.*]] = fadd fast <4 x double> [[PREDPHI7]], [[PREDPHI]]
; AVX-NEXT:    [[BIN_RDX10:%.*]] = fadd fast <4 x double> [[PREDPHI8]], [[BIN_RDX]]
; AVX-NEXT:    [[BIN_RDX11:%.*]] = fadd fast <4 x double> [[PREDPHI9]], [[BIN_RDX10]]
; AVX-NEXT:    [[TMP25:%.*]] = call fast double @llvm.vector.reduce.fadd.v4f64(double -0.000000e+00, <4 x double> [[BIN_RDX11]])
; AVX-NEXT:    br i1 true, label [[DONE:%.*]], label [[SCALAR_PH]]
; AVX:       scalar.ph:
; AVX-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i32 [ 32, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; AVX-NEXT:    [[BC_MERGE_RDX:%.*]] = phi double [ 0.000000e+00, [[ENTRY]] ], [ [[TMP25]], [[MIDDLE_BLOCK]] ]
; AVX-NEXT:    br label [[LOOP:%.*]]
; AVX:       loop:
; AVX-NEXT:    [[I:%.*]] = phi i32 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[I_NEXT:%.*]], [[NEXT_ITER:%.*]] ]
; AVX-NEXT:    [[TOT:%.*]] = phi double [ [[BC_MERGE_RDX]], [[SCALAR_PH]] ], [ [[TOT_NEXT:%.*]], [[NEXT_ITER]] ]
; AVX-NEXT:    [[ADDR:%.*]] = getelementptr double, ptr [[ARR]], i32 [[I]]
; AVX-NEXT:    [[NEXTVAL:%.*]] = load double, ptr [[ADDR]], align 8
; AVX-NEXT:    [[TST:%.*]] = fcmp fast une double [[NEXTVAL]], 4.200000e+01
; AVX-NEXT:    br i1 [[TST]], label [[DO_ADD:%.*]], label [[NO_ADD:%.*]]
; AVX:       do.add:
; AVX-NEXT:    [[TOT_NEW:%.*]] = fadd fast double [[TOT]], [[NEXTVAL]]
; AVX-NEXT:    br label [[NEXT_ITER]]
; AVX:       no.add:
; AVX-NEXT:    br label [[NEXT_ITER]]
; AVX:       next.iter:
; AVX-NEXT:    [[TOT_NEXT]] = phi double [ [[TOT]], [[NO_ADD]] ], [ [[TOT_NEW]], [[DO_ADD]] ]
; AVX-NEXT:    [[I_NEXT]] = add i32 [[I]], 1
; AVX-NEXT:    [[AGAIN:%.*]] = icmp ult i32 [[I_NEXT]], 32
; AVX-NEXT:    br i1 [[AGAIN]], label [[LOOP]], label [[DONE]], !llvm.loop [[LOOP3:![0-9]+]]
; AVX:       done:
; AVX-NEXT:    [[TOT_NEXT_LCSSA:%.*]] = phi double [ [[TOT_NEXT]], [[NEXT_ITER]] ], [ [[TMP25]], [[MIDDLE_BLOCK]] ]
; AVX-NEXT:    ret double [[TOT_NEXT_LCSSA]]
;
entry:
  br label %loop

loop:
  %i = phi i32 [0, %entry], [%i.next, %next.iter]
  %tot = phi double [0.0, %entry], [%tot.next, %next.iter]

  %addr = getelementptr double, ptr %arr, i32 %i
  %nextval = load double, ptr %addr

  %tst = fcmp fast une double %nextval, 42.0
  br i1 %tst, label %do.add, label %no.add

do.add:
  %tot.new = fadd fast double %tot, %nextval
  br label %next.iter

no.add:
  br label %next.iter

next.iter:
  %tot.next = phi double [%tot, %no.add], [%tot.new, %do.add]
  %i.next = add i32 %i, 1
  %again = icmp ult i32 %i.next, 32
  br i1 %again, label %loop, label %done

done:
  ret double %tot.next
}

