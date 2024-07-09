; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; REQUIRES: aarch64-registered-target
; RUN: opt -S %s -passes=scalarize-masked-mem-intrin -mtriple=aarch64-linux-gnu -mattr=+sve -force-streaming-compatible-sve | FileCheck %s

define <2 x i32> @scalarize_v2i32(<2 x ptr> %p, <2 x i1> %mask, <2 x i32> %passthru) {
; CHECK-LABEL: @scalarize_v2i32(
; CHECK-NEXT:    [[SCALAR_MASK:%.*]] = bitcast <2 x i1> [[MASK:%.*]] to i2
; CHECK-NEXT:    [[TMP1:%.*]] = and i2 [[SCALAR_MASK]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ne i2 [[TMP1]], 0
; CHECK-NEXT:    br i1 [[TMP2]], label [[COND_LOAD:%.*]], label [[ELSE:%.*]]
; CHECK:       cond.load:
; CHECK-NEXT:    [[PTR0:%.*]] = extractelement <2 x ptr> [[P:%.*]], i64 0
; CHECK-NEXT:    [[LOAD0:%.*]] = load i32, ptr [[PTR0]], align 8
; CHECK-NEXT:    [[RES0:%.*]] = insertelement <2 x i32> [[PASSTHRU:%.*]], i32 [[LOAD0]], i64 0
; CHECK-NEXT:    br label [[ELSE]]
; CHECK:       else:
; CHECK-NEXT:    [[RES_PHI_ELSE:%.*]] = phi <2 x i32> [ [[RES0]], [[COND_LOAD]] ], [ [[PASSTHRU]], [[TMP0:%.*]] ]
; CHECK-NEXT:    [[TMP3:%.*]] = and i2 [[SCALAR_MASK]], -2
; CHECK-NEXT:    [[TMP4:%.*]] = icmp ne i2 [[TMP3]], 0
; CHECK-NEXT:    br i1 [[TMP4]], label [[COND_LOAD1:%.*]], label [[ELSE2:%.*]]
; CHECK:       cond.load1:
; CHECK-NEXT:    [[PTR1:%.*]] = extractelement <2 x ptr> [[P]], i64 1
; CHECK-NEXT:    [[LOAD1:%.*]] = load i32, ptr [[PTR1]], align 8
; CHECK-NEXT:    [[RES1:%.*]] = insertelement <2 x i32> [[RES_PHI_ELSE]], i32 [[LOAD1]], i64 1
; CHECK-NEXT:    br label [[ELSE2]]
; CHECK:       else2:
; CHECK-NEXT:    [[RES_PHI_ELSE3:%.*]] = phi <2 x i32> [ [[RES1]], [[COND_LOAD1]] ], [ [[RES_PHI_ELSE]], [[ELSE]] ]
; CHECK-NEXT:    ret <2 x i32> [[RES_PHI_ELSE3]]
;
  %ret = call <2 x i32> @llvm.masked.gather.v2i32.v2p0(<2 x ptr> %p, i32 8, <2 x i1> %mask, <2 x i32> %passthru)
  ret <2 x i32> %ret
}

define void @scalarize_v2i64(<2 x ptr> %p, <2 x i1> %mask, <2 x i64> %value) {
; CHECK-LABEL: @scalarize_v2i64(
; CHECK-NEXT:    [[SCALAR_MASK:%.*]] = bitcast <2 x i1> [[MASK:%.*]] to i2
; CHECK-NEXT:    [[TMP1:%.*]] = and i2 [[SCALAR_MASK]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ne i2 [[TMP1]], 0
; CHECK-NEXT:    br i1 [[TMP2]], label [[COND_STORE:%.*]], label [[ELSE:%.*]]
; CHECK:       cond.store:
; CHECK-NEXT:    [[ELT0:%.*]] = extractelement <2 x i64> [[VALUE:%.*]], i64 0
; CHECK-NEXT:    [[PTR0:%.*]] = extractelement <2 x ptr> [[P:%.*]], i64 0
; CHECK-NEXT:    store i64 [[ELT0]], ptr [[PTR0]], align 8
; CHECK-NEXT:    br label [[ELSE]]
; CHECK:       else:
; CHECK-NEXT:    [[TMP3:%.*]] = and i2 [[SCALAR_MASK]], -2
; CHECK-NEXT:    [[TMP4:%.*]] = icmp ne i2 [[TMP3]], 0
; CHECK-NEXT:    br i1 [[TMP4]], label [[COND_STORE1:%.*]], label [[ELSE2:%.*]]
; CHECK:       cond.store1:
; CHECK-NEXT:    [[ELT1:%.*]] = extractelement <2 x i64> [[VALUE]], i64 1
; CHECK-NEXT:    [[PTR1:%.*]] = extractelement <2 x ptr> [[P]], i64 1
; CHECK-NEXT:    store i64 [[ELT1]], ptr [[PTR1]], align 8
; CHECK-NEXT:    br label [[ELSE2]]
; CHECK:       else2:
; CHECK-NEXT:    ret void
;
  call void @llvm.masked.scatter.v2i64.v2p0(<2 x i64> %value, <2 x ptr> %p, i32 8, <2 x i1> %mask)
  ret void
}

declare <2 x i32> @llvm.masked.gather.v2i32.v2p0(<2 x ptr>, i32, <2 x i1>, <2 x i32>)
declare void @llvm.masked.scatter.v2i64.v2p0(<2 x i64>, <2 x ptr>, i32, <2 x i1>)
