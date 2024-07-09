; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 2
; Test basic address sanitizer instrumentation.
; Generic code is covered by ../basic.ll, only the x86_64 specific code is
; tested here.
;
; RUN: opt < %s -passes=hwasan -S | FileCheck %s
; RUN: opt < %s -passes=hwasan -hwasan-inline-fast-path-checks=0 -S | FileCheck %s --check-prefixes=NOFASTPATH
; RUN: opt < %s -passes=hwasan -hwasan-inline-fast-path-checks=1 -S | FileCheck %s --check-prefixes=FASTPATH
; RUN: opt < %s -passes=hwasan -hwasan-recover=0 -S | FileCheck %s  --check-prefixes=ABORT
; RUN: opt < %s -passes=hwasan -hwasan-recover=1 -S | FileCheck %s  --check-prefixes=RECOVER
; RUN: opt < %s -passes=hwasan -hwasan-recover=0 -hwasan-instrument-with-calls=0 -S | FileCheck %s  --check-prefixes=ABORT-INLINE
; RUN: opt < %s -passes=hwasan -hwasan-recover=1 -hwasan-instrument-with-calls=0 -S | FileCheck %s  --check-prefixes=RECOVER-INLINE

target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define i8 @test_load8(ptr %a) sanitize_hwaddress {
; CHECK-LABEL: define i8 @test_load8
; CHECK-SAME: (ptr [[A:%.*]]) #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[DOTHWASAN_SHADOW:%.*]] = call ptr asm "", "=r,0"(ptr null)
; CHECK-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[A]] to i64
; CHECK-NEXT:    call void @__hwasan_load1(i64 [[TMP0]])
; CHECK-NEXT:    [[B:%.*]] = load i8, ptr [[A]], align 4
; CHECK-NEXT:    ret i8 [[B]]
;
; NOFASTPATH-LABEL: define i8 @test_load8
; NOFASTPATH-SAME: (ptr [[A:%.*]]) #[[ATTR0:[0-9]+]] {
; NOFASTPATH-NEXT:  entry:
; NOFASTPATH-NEXT:    [[DOTHWASAN_SHADOW:%.*]] = call ptr asm "", "=r,0"(ptr null)
; NOFASTPATH-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[A]] to i64
; NOFASTPATH-NEXT:    call void @__hwasan_load1(i64 [[TMP0]])
; NOFASTPATH-NEXT:    [[B:%.*]] = load i8, ptr [[A]], align 4
; NOFASTPATH-NEXT:    ret i8 [[B]]
;
; FASTPATH-LABEL: define i8 @test_load8
; FASTPATH-SAME: (ptr [[A:%.*]]) #[[ATTR0:[0-9]+]] {
; FASTPATH-NEXT:  entry:
; FASTPATH-NEXT:    [[DOTHWASAN_SHADOW:%.*]] = call ptr asm "", "=r,0"(ptr null)
; FASTPATH-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[A]] to i64
; FASTPATH-NEXT:    call void @__hwasan_load1(i64 [[TMP0]])
; FASTPATH-NEXT:    [[B:%.*]] = load i8, ptr [[A]], align 4
; FASTPATH-NEXT:    ret i8 [[B]]
;
; ABORT-LABEL: define i8 @test_load8
; ABORT-SAME: (ptr [[A:%.*]]) #[[ATTR0:[0-9]+]] {
; ABORT-NEXT:  entry:
; ABORT-NEXT:    [[DOTHWASAN_SHADOW:%.*]] = call ptr asm "", "=r,0"(ptr null)
; ABORT-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[A]] to i64
; ABORT-NEXT:    call void @__hwasan_load1(i64 [[TMP0]])
; ABORT-NEXT:    [[B:%.*]] = load i8, ptr [[A]], align 4
; ABORT-NEXT:    ret i8 [[B]]
;
; RECOVER-LABEL: define i8 @test_load8
; RECOVER-SAME: (ptr [[A:%.*]]) #[[ATTR0:[0-9]+]] {
; RECOVER-NEXT:  entry:
; RECOVER-NEXT:    [[DOTHWASAN_SHADOW:%.*]] = call ptr asm "", "=r,0"(ptr null)
; RECOVER-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[A]] to i64
; RECOVER-NEXT:    call void @__hwasan_load1_noabort(i64 [[TMP0]])
; RECOVER-NEXT:    [[B:%.*]] = load i8, ptr [[A]], align 4
; RECOVER-NEXT:    ret i8 [[B]]
;
; ABORT-INLINE-LABEL: define i8 @test_load8
; ABORT-INLINE-SAME: (ptr [[A:%.*]]) #[[ATTR0:[0-9]+]] {
; ABORT-INLINE-NEXT:  entry:
; ABORT-INLINE-NEXT:    [[TMP0:%.*]] = load i64, ptr @__hwasan_tls, align 8
; ABORT-INLINE-NEXT:    [[TMP1:%.*]] = and i64 [[TMP0]], -9079256848778919937
; ABORT-INLINE-NEXT:    [[TMP2:%.*]] = or i64 [[TMP1]], 4294967295
; ABORT-INLINE-NEXT:    [[HWASAN_SHADOW:%.*]] = add i64 [[TMP2]], 1
; ABORT-INLINE-NEXT:    [[TMP3:%.*]] = inttoptr i64 [[HWASAN_SHADOW]] to ptr
; ABORT-INLINE-NEXT:    [[TMP4:%.*]] = ptrtoint ptr [[A]] to i64
; ABORT-INLINE-NEXT:    [[TMP5:%.*]] = lshr i64 [[TMP4]], 57
; ABORT-INLINE-NEXT:    [[TMP6:%.*]] = trunc i64 [[TMP5]] to i8
; ABORT-INLINE-NEXT:    [[TMP7:%.*]] = and i64 [[TMP4]], -9079256848778919937
; ABORT-INLINE-NEXT:    [[TMP8:%.*]] = lshr i64 [[TMP7]], 4
; ABORT-INLINE-NEXT:    [[TMP9:%.*]] = getelementptr i8, ptr [[TMP3]], i64 [[TMP8]]
; ABORT-INLINE-NEXT:    [[TMP10:%.*]] = load i8, ptr [[TMP9]], align 1
; ABORT-INLINE-NEXT:    [[TMP11:%.*]] = icmp ne i8 [[TMP6]], [[TMP10]]
; ABORT-INLINE-NEXT:    br i1 [[TMP11]], label [[TMP12:%.*]], label [[TMP26:%.*]], !prof [[PROF1:![0-9]+]]
; ABORT-INLINE:       12:
; ABORT-INLINE-NEXT:    [[TMP13:%.*]] = icmp ugt i8 [[TMP10]], 15
; ABORT-INLINE-NEXT:    br i1 [[TMP13]], label [[TMP14:%.*]], label [[TMP15:%.*]], !prof [[PROF1]]
; ABORT-INLINE:       14:
; ABORT-INLINE-NEXT:    call void asm sideeffect "int3\0Anopl 64([[RAX:%.*]])", "{rdi}"(i64 [[TMP4]])
; ABORT-INLINE-NEXT:    unreachable
; ABORT-INLINE:       15:
; ABORT-INLINE-NEXT:    [[TMP16:%.*]] = and i64 [[TMP4]], 15
; ABORT-INLINE-NEXT:    [[TMP17:%.*]] = trunc i64 [[TMP16]] to i8
; ABORT-INLINE-NEXT:    [[TMP18:%.*]] = add i8 [[TMP17]], 0
; ABORT-INLINE-NEXT:    [[TMP19:%.*]] = icmp uge i8 [[TMP18]], [[TMP10]]
; ABORT-INLINE-NEXT:    br i1 [[TMP19]], label [[TMP14]], label [[TMP20:%.*]], !prof [[PROF1]]
; ABORT-INLINE:       20:
; ABORT-INLINE-NEXT:    [[TMP21:%.*]] = or i64 [[TMP7]], 15
; ABORT-INLINE-NEXT:    [[TMP22:%.*]] = inttoptr i64 [[TMP21]] to ptr
; ABORT-INLINE-NEXT:    [[TMP23:%.*]] = load i8, ptr [[TMP22]], align 1
; ABORT-INLINE-NEXT:    [[TMP24:%.*]] = icmp ne i8 [[TMP6]], [[TMP23]]
; ABORT-INLINE-NEXT:    br i1 [[TMP24]], label [[TMP14]], label [[TMP25:%.*]], !prof [[PROF1]]
; ABORT-INLINE:       25:
; ABORT-INLINE-NEXT:    br label [[TMP26]]
; ABORT-INLINE:       26:
; ABORT-INLINE-NEXT:    [[B:%.*]] = load i8, ptr [[A]], align 4
; ABORT-INLINE-NEXT:    ret i8 [[B]]
;
; RECOVER-INLINE-LABEL: define i8 @test_load8
; RECOVER-INLINE-SAME: (ptr [[A:%.*]]) #[[ATTR0:[0-9]+]] {
; RECOVER-INLINE-NEXT:  entry:
; RECOVER-INLINE-NEXT:    [[TMP0:%.*]] = load i64, ptr @__hwasan_tls, align 8
; RECOVER-INLINE-NEXT:    [[TMP1:%.*]] = and i64 [[TMP0]], -9079256848778919937
; RECOVER-INLINE-NEXT:    [[TMP2:%.*]] = or i64 [[TMP1]], 4294967295
; RECOVER-INLINE-NEXT:    [[HWASAN_SHADOW:%.*]] = add i64 [[TMP2]], 1
; RECOVER-INLINE-NEXT:    [[TMP3:%.*]] = inttoptr i64 [[HWASAN_SHADOW]] to ptr
; RECOVER-INLINE-NEXT:    [[TMP4:%.*]] = ptrtoint ptr [[A]] to i64
; RECOVER-INLINE-NEXT:    [[TMP5:%.*]] = lshr i64 [[TMP4]], 57
; RECOVER-INLINE-NEXT:    [[TMP6:%.*]] = trunc i64 [[TMP5]] to i8
; RECOVER-INLINE-NEXT:    [[TMP7:%.*]] = and i64 [[TMP4]], -9079256848778919937
; RECOVER-INLINE-NEXT:    [[TMP8:%.*]] = lshr i64 [[TMP7]], 4
; RECOVER-INLINE-NEXT:    [[TMP9:%.*]] = getelementptr i8, ptr [[TMP3]], i64 [[TMP8]]
; RECOVER-INLINE-NEXT:    [[TMP10:%.*]] = load i8, ptr [[TMP9]], align 1
; RECOVER-INLINE-NEXT:    [[TMP11:%.*]] = icmp ne i8 [[TMP6]], [[TMP10]]
; RECOVER-INLINE-NEXT:    br i1 [[TMP11]], label [[TMP12:%.*]], label [[TMP26:%.*]], !prof [[PROF1:![0-9]+]]
; RECOVER-INLINE:       12:
; RECOVER-INLINE-NEXT:    [[TMP13:%.*]] = icmp ugt i8 [[TMP10]], 15
; RECOVER-INLINE-NEXT:    br i1 [[TMP13]], label [[TMP14:%.*]], label [[TMP15:%.*]], !prof [[PROF1]]
; RECOVER-INLINE:       14:
; RECOVER-INLINE-NEXT:    call void asm sideeffect "int3\0Anopl 96([[RAX:%.*]])", "{rdi}"(i64 [[TMP4]])
; RECOVER-INLINE-NEXT:    br label [[TMP25:%.*]]
; RECOVER-INLINE:       15:
; RECOVER-INLINE-NEXT:    [[TMP16:%.*]] = and i64 [[TMP4]], 15
; RECOVER-INLINE-NEXT:    [[TMP17:%.*]] = trunc i64 [[TMP16]] to i8
; RECOVER-INLINE-NEXT:    [[TMP18:%.*]] = add i8 [[TMP17]], 0
; RECOVER-INLINE-NEXT:    [[TMP19:%.*]] = icmp uge i8 [[TMP18]], [[TMP10]]
; RECOVER-INLINE-NEXT:    br i1 [[TMP19]], label [[TMP14]], label [[TMP20:%.*]], !prof [[PROF1]]
; RECOVER-INLINE:       20:
; RECOVER-INLINE-NEXT:    [[TMP21:%.*]] = or i64 [[TMP7]], 15
; RECOVER-INLINE-NEXT:    [[TMP22:%.*]] = inttoptr i64 [[TMP21]] to ptr
; RECOVER-INLINE-NEXT:    [[TMP23:%.*]] = load i8, ptr [[TMP22]], align 1
; RECOVER-INLINE-NEXT:    [[TMP24:%.*]] = icmp ne i8 [[TMP6]], [[TMP23]]
; RECOVER-INLINE-NEXT:    br i1 [[TMP24]], label [[TMP14]], label [[TMP25]], !prof [[PROF1]]
; RECOVER-INLINE:       25:
; RECOVER-INLINE-NEXT:    br label [[TMP26]]
; RECOVER-INLINE:       26:
; RECOVER-INLINE-NEXT:    [[B:%.*]] = load i8, ptr [[A]], align 4
; RECOVER-INLINE-NEXT:    ret i8 [[B]]
;
entry:
  %b = load i8, ptr %a, align 4
  ret i8 %b
}

define i40 @test_load40(ptr %a) sanitize_hwaddress {
; CHECK-LABEL: define i40 @test_load40
; CHECK-SAME: (ptr [[A:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[DOTHWASAN_SHADOW:%.*]] = call ptr asm "", "=r,0"(ptr null)
; CHECK-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[A]] to i64
; CHECK-NEXT:    call void @__hwasan_loadN(i64 [[TMP0]], i64 5)
; CHECK-NEXT:    [[B:%.*]] = load i40, ptr [[A]], align 4
; CHECK-NEXT:    ret i40 [[B]]
;
; NOFASTPATH-LABEL: define i40 @test_load40
; NOFASTPATH-SAME: (ptr [[A:%.*]]) #[[ATTR0]] {
; NOFASTPATH-NEXT:  entry:
; NOFASTPATH-NEXT:    [[DOTHWASAN_SHADOW:%.*]] = call ptr asm "", "=r,0"(ptr null)
; NOFASTPATH-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[A]] to i64
; NOFASTPATH-NEXT:    call void @__hwasan_loadN(i64 [[TMP0]], i64 5)
; NOFASTPATH-NEXT:    [[B:%.*]] = load i40, ptr [[A]], align 4
; NOFASTPATH-NEXT:    ret i40 [[B]]
;
; FASTPATH-LABEL: define i40 @test_load40
; FASTPATH-SAME: (ptr [[A:%.*]]) #[[ATTR0]] {
; FASTPATH-NEXT:  entry:
; FASTPATH-NEXT:    [[DOTHWASAN_SHADOW:%.*]] = call ptr asm "", "=r,0"(ptr null)
; FASTPATH-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[A]] to i64
; FASTPATH-NEXT:    call void @__hwasan_loadN(i64 [[TMP0]], i64 5)
; FASTPATH-NEXT:    [[B:%.*]] = load i40, ptr [[A]], align 4
; FASTPATH-NEXT:    ret i40 [[B]]
;
; ABORT-LABEL: define i40 @test_load40
; ABORT-SAME: (ptr [[A:%.*]]) #[[ATTR0]] {
; ABORT-NEXT:  entry:
; ABORT-NEXT:    [[DOTHWASAN_SHADOW:%.*]] = call ptr asm "", "=r,0"(ptr null)
; ABORT-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[A]] to i64
; ABORT-NEXT:    call void @__hwasan_loadN(i64 [[TMP0]], i64 5)
; ABORT-NEXT:    [[B:%.*]] = load i40, ptr [[A]], align 4
; ABORT-NEXT:    ret i40 [[B]]
;
; RECOVER-LABEL: define i40 @test_load40
; RECOVER-SAME: (ptr [[A:%.*]]) #[[ATTR0]] {
; RECOVER-NEXT:  entry:
; RECOVER-NEXT:    [[DOTHWASAN_SHADOW:%.*]] = call ptr asm "", "=r,0"(ptr null)
; RECOVER-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[A]] to i64
; RECOVER-NEXT:    call void @__hwasan_loadN_noabort(i64 [[TMP0]], i64 5)
; RECOVER-NEXT:    [[B:%.*]] = load i40, ptr [[A]], align 4
; RECOVER-NEXT:    ret i40 [[B]]
;
; ABORT-INLINE-LABEL: define i40 @test_load40
; ABORT-INLINE-SAME: (ptr [[A:%.*]]) #[[ATTR0]] {
; ABORT-INLINE-NEXT:  entry:
; ABORT-INLINE-NEXT:    [[TMP0:%.*]] = load i64, ptr @__hwasan_tls, align 8
; ABORT-INLINE-NEXT:    [[TMP1:%.*]] = and i64 [[TMP0]], -9079256848778919937
; ABORT-INLINE-NEXT:    [[TMP2:%.*]] = or i64 [[TMP1]], 4294967295
; ABORT-INLINE-NEXT:    [[HWASAN_SHADOW:%.*]] = add i64 [[TMP2]], 1
; ABORT-INLINE-NEXT:    [[TMP3:%.*]] = inttoptr i64 [[HWASAN_SHADOW]] to ptr
; ABORT-INLINE-NEXT:    [[TMP4:%.*]] = ptrtoint ptr [[A]] to i64
; ABORT-INLINE-NEXT:    call void @__hwasan_loadN(i64 [[TMP4]], i64 5)
; ABORT-INLINE-NEXT:    [[B:%.*]] = load i40, ptr [[A]], align 4
; ABORT-INLINE-NEXT:    ret i40 [[B]]
;
; RECOVER-INLINE-LABEL: define i40 @test_load40
; RECOVER-INLINE-SAME: (ptr [[A:%.*]]) #[[ATTR0]] {
; RECOVER-INLINE-NEXT:  entry:
; RECOVER-INLINE-NEXT:    [[TMP0:%.*]] = load i64, ptr @__hwasan_tls, align 8
; RECOVER-INLINE-NEXT:    [[TMP1:%.*]] = and i64 [[TMP0]], -9079256848778919937
; RECOVER-INLINE-NEXT:    [[TMP2:%.*]] = or i64 [[TMP1]], 4294967295
; RECOVER-INLINE-NEXT:    [[HWASAN_SHADOW:%.*]] = add i64 [[TMP2]], 1
; RECOVER-INLINE-NEXT:    [[TMP3:%.*]] = inttoptr i64 [[HWASAN_SHADOW]] to ptr
; RECOVER-INLINE-NEXT:    [[TMP4:%.*]] = ptrtoint ptr [[A]] to i64
; RECOVER-INLINE-NEXT:    call void @__hwasan_loadN_noabort(i64 [[TMP4]], i64 5)
; RECOVER-INLINE-NEXT:    [[B:%.*]] = load i40, ptr [[A]], align 4
; RECOVER-INLINE-NEXT:    ret i40 [[B]]
;
entry:
  %b = load i40, ptr %a, align 4
  ret i40 %b
}

define void @test_store8(ptr %a, i8 %b) sanitize_hwaddress {
; CHECK-LABEL: define void @test_store8
; CHECK-SAME: (ptr [[A:%.*]], i8 [[B:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[DOTHWASAN_SHADOW:%.*]] = call ptr asm "", "=r,0"(ptr null)
; CHECK-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[A]] to i64
; CHECK-NEXT:    call void @__hwasan_store1(i64 [[TMP0]])
; CHECK-NEXT:    store i8 [[B]], ptr [[A]], align 4
; CHECK-NEXT:    ret void
;
; NOFASTPATH-LABEL: define void @test_store8
; NOFASTPATH-SAME: (ptr [[A:%.*]], i8 [[B:%.*]]) #[[ATTR0]] {
; NOFASTPATH-NEXT:  entry:
; NOFASTPATH-NEXT:    [[DOTHWASAN_SHADOW:%.*]] = call ptr asm "", "=r,0"(ptr null)
; NOFASTPATH-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[A]] to i64
; NOFASTPATH-NEXT:    call void @__hwasan_store1(i64 [[TMP0]])
; NOFASTPATH-NEXT:    store i8 [[B]], ptr [[A]], align 4
; NOFASTPATH-NEXT:    ret void
;
; FASTPATH-LABEL: define void @test_store8
; FASTPATH-SAME: (ptr [[A:%.*]], i8 [[B:%.*]]) #[[ATTR0]] {
; FASTPATH-NEXT:  entry:
; FASTPATH-NEXT:    [[DOTHWASAN_SHADOW:%.*]] = call ptr asm "", "=r,0"(ptr null)
; FASTPATH-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[A]] to i64
; FASTPATH-NEXT:    call void @__hwasan_store1(i64 [[TMP0]])
; FASTPATH-NEXT:    store i8 [[B]], ptr [[A]], align 4
; FASTPATH-NEXT:    ret void
;
; ABORT-LABEL: define void @test_store8
; ABORT-SAME: (ptr [[A:%.*]], i8 [[B:%.*]]) #[[ATTR0]] {
; ABORT-NEXT:  entry:
; ABORT-NEXT:    [[DOTHWASAN_SHADOW:%.*]] = call ptr asm "", "=r,0"(ptr null)
; ABORT-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[A]] to i64
; ABORT-NEXT:    call void @__hwasan_store1(i64 [[TMP0]])
; ABORT-NEXT:    store i8 [[B]], ptr [[A]], align 4
; ABORT-NEXT:    ret void
;
; RECOVER-LABEL: define void @test_store8
; RECOVER-SAME: (ptr [[A:%.*]], i8 [[B:%.*]]) #[[ATTR0]] {
; RECOVER-NEXT:  entry:
; RECOVER-NEXT:    [[DOTHWASAN_SHADOW:%.*]] = call ptr asm "", "=r,0"(ptr null)
; RECOVER-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[A]] to i64
; RECOVER-NEXT:    call void @__hwasan_store1_noabort(i64 [[TMP0]])
; RECOVER-NEXT:    store i8 [[B]], ptr [[A]], align 4
; RECOVER-NEXT:    ret void
;
; ABORT-INLINE-LABEL: define void @test_store8
; ABORT-INLINE-SAME: (ptr [[A:%.*]], i8 [[B:%.*]]) #[[ATTR0]] {
; ABORT-INLINE-NEXT:  entry:
; ABORT-INLINE-NEXT:    [[TMP0:%.*]] = load i64, ptr @__hwasan_tls, align 8
; ABORT-INLINE-NEXT:    [[TMP1:%.*]] = and i64 [[TMP0]], -9079256848778919937
; ABORT-INLINE-NEXT:    [[TMP2:%.*]] = or i64 [[TMP1]], 4294967295
; ABORT-INLINE-NEXT:    [[HWASAN_SHADOW:%.*]] = add i64 [[TMP2]], 1
; ABORT-INLINE-NEXT:    [[TMP3:%.*]] = inttoptr i64 [[HWASAN_SHADOW]] to ptr
; ABORT-INLINE-NEXT:    [[TMP4:%.*]] = ptrtoint ptr [[A]] to i64
; ABORT-INLINE-NEXT:    [[TMP5:%.*]] = lshr i64 [[TMP4]], 57
; ABORT-INLINE-NEXT:    [[TMP6:%.*]] = trunc i64 [[TMP5]] to i8
; ABORT-INLINE-NEXT:    [[TMP7:%.*]] = and i64 [[TMP4]], -9079256848778919937
; ABORT-INLINE-NEXT:    [[TMP8:%.*]] = lshr i64 [[TMP7]], 4
; ABORT-INLINE-NEXT:    [[TMP9:%.*]] = getelementptr i8, ptr [[TMP3]], i64 [[TMP8]]
; ABORT-INLINE-NEXT:    [[TMP10:%.*]] = load i8, ptr [[TMP9]], align 1
; ABORT-INLINE-NEXT:    [[TMP11:%.*]] = icmp ne i8 [[TMP6]], [[TMP10]]
; ABORT-INLINE-NEXT:    br i1 [[TMP11]], label [[TMP12:%.*]], label [[TMP26:%.*]], !prof [[PROF1]]
; ABORT-INLINE:       12:
; ABORT-INLINE-NEXT:    [[TMP13:%.*]] = icmp ugt i8 [[TMP10]], 15
; ABORT-INLINE-NEXT:    br i1 [[TMP13]], label [[TMP14:%.*]], label [[TMP15:%.*]], !prof [[PROF1]]
; ABORT-INLINE:       14:
; ABORT-INLINE-NEXT:    call void asm sideeffect "int3\0Anopl 80([[RAX:%.*]])", "{rdi}"(i64 [[TMP4]])
; ABORT-INLINE-NEXT:    unreachable
; ABORT-INLINE:       15:
; ABORT-INLINE-NEXT:    [[TMP16:%.*]] = and i64 [[TMP4]], 15
; ABORT-INLINE-NEXT:    [[TMP17:%.*]] = trunc i64 [[TMP16]] to i8
; ABORT-INLINE-NEXT:    [[TMP18:%.*]] = add i8 [[TMP17]], 0
; ABORT-INLINE-NEXT:    [[TMP19:%.*]] = icmp uge i8 [[TMP18]], [[TMP10]]
; ABORT-INLINE-NEXT:    br i1 [[TMP19]], label [[TMP14]], label [[TMP20:%.*]], !prof [[PROF1]]
; ABORT-INLINE:       20:
; ABORT-INLINE-NEXT:    [[TMP21:%.*]] = or i64 [[TMP7]], 15
; ABORT-INLINE-NEXT:    [[TMP22:%.*]] = inttoptr i64 [[TMP21]] to ptr
; ABORT-INLINE-NEXT:    [[TMP23:%.*]] = load i8, ptr [[TMP22]], align 1
; ABORT-INLINE-NEXT:    [[TMP24:%.*]] = icmp ne i8 [[TMP6]], [[TMP23]]
; ABORT-INLINE-NEXT:    br i1 [[TMP24]], label [[TMP14]], label [[TMP25:%.*]], !prof [[PROF1]]
; ABORT-INLINE:       25:
; ABORT-INLINE-NEXT:    br label [[TMP26]]
; ABORT-INLINE:       26:
; ABORT-INLINE-NEXT:    store i8 [[B]], ptr [[A]], align 4
; ABORT-INLINE-NEXT:    ret void
;
; RECOVER-INLINE-LABEL: define void @test_store8
; RECOVER-INLINE-SAME: (ptr [[A:%.*]], i8 [[B:%.*]]) #[[ATTR0]] {
; RECOVER-INLINE-NEXT:  entry:
; RECOVER-INLINE-NEXT:    [[TMP0:%.*]] = load i64, ptr @__hwasan_tls, align 8
; RECOVER-INLINE-NEXT:    [[TMP1:%.*]] = and i64 [[TMP0]], -9079256848778919937
; RECOVER-INLINE-NEXT:    [[TMP2:%.*]] = or i64 [[TMP1]], 4294967295
; RECOVER-INLINE-NEXT:    [[HWASAN_SHADOW:%.*]] = add i64 [[TMP2]], 1
; RECOVER-INLINE-NEXT:    [[TMP3:%.*]] = inttoptr i64 [[HWASAN_SHADOW]] to ptr
; RECOVER-INLINE-NEXT:    [[TMP4:%.*]] = ptrtoint ptr [[A]] to i64
; RECOVER-INLINE-NEXT:    [[TMP5:%.*]] = lshr i64 [[TMP4]], 57
; RECOVER-INLINE-NEXT:    [[TMP6:%.*]] = trunc i64 [[TMP5]] to i8
; RECOVER-INLINE-NEXT:    [[TMP7:%.*]] = and i64 [[TMP4]], -9079256848778919937
; RECOVER-INLINE-NEXT:    [[TMP8:%.*]] = lshr i64 [[TMP7]], 4
; RECOVER-INLINE-NEXT:    [[TMP9:%.*]] = getelementptr i8, ptr [[TMP3]], i64 [[TMP8]]
; RECOVER-INLINE-NEXT:    [[TMP10:%.*]] = load i8, ptr [[TMP9]], align 1
; RECOVER-INLINE-NEXT:    [[TMP11:%.*]] = icmp ne i8 [[TMP6]], [[TMP10]]
; RECOVER-INLINE-NEXT:    br i1 [[TMP11]], label [[TMP12:%.*]], label [[TMP26:%.*]], !prof [[PROF1]]
; RECOVER-INLINE:       12:
; RECOVER-INLINE-NEXT:    [[TMP13:%.*]] = icmp ugt i8 [[TMP10]], 15
; RECOVER-INLINE-NEXT:    br i1 [[TMP13]], label [[TMP14:%.*]], label [[TMP15:%.*]], !prof [[PROF1]]
; RECOVER-INLINE:       14:
; RECOVER-INLINE-NEXT:    call void asm sideeffect "int3\0Anopl 112([[RAX:%.*]])", "{rdi}"(i64 [[TMP4]])
; RECOVER-INLINE-NEXT:    br label [[TMP25:%.*]]
; RECOVER-INLINE:       15:
; RECOVER-INLINE-NEXT:    [[TMP16:%.*]] = and i64 [[TMP4]], 15
; RECOVER-INLINE-NEXT:    [[TMP17:%.*]] = trunc i64 [[TMP16]] to i8
; RECOVER-INLINE-NEXT:    [[TMP18:%.*]] = add i8 [[TMP17]], 0
; RECOVER-INLINE-NEXT:    [[TMP19:%.*]] = icmp uge i8 [[TMP18]], [[TMP10]]
; RECOVER-INLINE-NEXT:    br i1 [[TMP19]], label [[TMP14]], label [[TMP20:%.*]], !prof [[PROF1]]
; RECOVER-INLINE:       20:
; RECOVER-INLINE-NEXT:    [[TMP21:%.*]] = or i64 [[TMP7]], 15
; RECOVER-INLINE-NEXT:    [[TMP22:%.*]] = inttoptr i64 [[TMP21]] to ptr
; RECOVER-INLINE-NEXT:    [[TMP23:%.*]] = load i8, ptr [[TMP22]], align 1
; RECOVER-INLINE-NEXT:    [[TMP24:%.*]] = icmp ne i8 [[TMP6]], [[TMP23]]
; RECOVER-INLINE-NEXT:    br i1 [[TMP24]], label [[TMP14]], label [[TMP25]], !prof [[PROF1]]
; RECOVER-INLINE:       25:
; RECOVER-INLINE-NEXT:    br label [[TMP26]]
; RECOVER-INLINE:       26:
; RECOVER-INLINE-NEXT:    store i8 [[B]], ptr [[A]], align 4
; RECOVER-INLINE-NEXT:    ret void
;
entry:
  store i8 %b, ptr %a, align 4
  ret void
}

define void @test_store40(ptr %a, i40 %b) sanitize_hwaddress {
; CHECK-LABEL: define void @test_store40
; CHECK-SAME: (ptr [[A:%.*]], i40 [[B:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[DOTHWASAN_SHADOW:%.*]] = call ptr asm "", "=r,0"(ptr null)
; CHECK-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[A]] to i64
; CHECK-NEXT:    call void @__hwasan_storeN(i64 [[TMP0]], i64 5)
; CHECK-NEXT:    store i40 [[B]], ptr [[A]], align 4
; CHECK-NEXT:    ret void
;
; NOFASTPATH-LABEL: define void @test_store40
; NOFASTPATH-SAME: (ptr [[A:%.*]], i40 [[B:%.*]]) #[[ATTR0]] {
; NOFASTPATH-NEXT:  entry:
; NOFASTPATH-NEXT:    [[DOTHWASAN_SHADOW:%.*]] = call ptr asm "", "=r,0"(ptr null)
; NOFASTPATH-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[A]] to i64
; NOFASTPATH-NEXT:    call void @__hwasan_storeN(i64 [[TMP0]], i64 5)
; NOFASTPATH-NEXT:    store i40 [[B]], ptr [[A]], align 4
; NOFASTPATH-NEXT:    ret void
;
; FASTPATH-LABEL: define void @test_store40
; FASTPATH-SAME: (ptr [[A:%.*]], i40 [[B:%.*]]) #[[ATTR0]] {
; FASTPATH-NEXT:  entry:
; FASTPATH-NEXT:    [[DOTHWASAN_SHADOW:%.*]] = call ptr asm "", "=r,0"(ptr null)
; FASTPATH-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[A]] to i64
; FASTPATH-NEXT:    call void @__hwasan_storeN(i64 [[TMP0]], i64 5)
; FASTPATH-NEXT:    store i40 [[B]], ptr [[A]], align 4
; FASTPATH-NEXT:    ret void
;
; ABORT-LABEL: define void @test_store40
; ABORT-SAME: (ptr [[A:%.*]], i40 [[B:%.*]]) #[[ATTR0]] {
; ABORT-NEXT:  entry:
; ABORT-NEXT:    [[DOTHWASAN_SHADOW:%.*]] = call ptr asm "", "=r,0"(ptr null)
; ABORT-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[A]] to i64
; ABORT-NEXT:    call void @__hwasan_storeN(i64 [[TMP0]], i64 5)
; ABORT-NEXT:    store i40 [[B]], ptr [[A]], align 4
; ABORT-NEXT:    ret void
;
; RECOVER-LABEL: define void @test_store40
; RECOVER-SAME: (ptr [[A:%.*]], i40 [[B:%.*]]) #[[ATTR0]] {
; RECOVER-NEXT:  entry:
; RECOVER-NEXT:    [[DOTHWASAN_SHADOW:%.*]] = call ptr asm "", "=r,0"(ptr null)
; RECOVER-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[A]] to i64
; RECOVER-NEXT:    call void @__hwasan_storeN_noabort(i64 [[TMP0]], i64 5)
; RECOVER-NEXT:    store i40 [[B]], ptr [[A]], align 4
; RECOVER-NEXT:    ret void
;
; ABORT-INLINE-LABEL: define void @test_store40
; ABORT-INLINE-SAME: (ptr [[A:%.*]], i40 [[B:%.*]]) #[[ATTR0]] {
; ABORT-INLINE-NEXT:  entry:
; ABORT-INLINE-NEXT:    [[TMP0:%.*]] = load i64, ptr @__hwasan_tls, align 8
; ABORT-INLINE-NEXT:    [[TMP1:%.*]] = and i64 [[TMP0]], -9079256848778919937
; ABORT-INLINE-NEXT:    [[TMP2:%.*]] = or i64 [[TMP1]], 4294967295
; ABORT-INLINE-NEXT:    [[HWASAN_SHADOW:%.*]] = add i64 [[TMP2]], 1
; ABORT-INLINE-NEXT:    [[TMP3:%.*]] = inttoptr i64 [[HWASAN_SHADOW]] to ptr
; ABORT-INLINE-NEXT:    [[TMP4:%.*]] = ptrtoint ptr [[A]] to i64
; ABORT-INLINE-NEXT:    call void @__hwasan_storeN(i64 [[TMP4]], i64 5)
; ABORT-INLINE-NEXT:    store i40 [[B]], ptr [[A]], align 4
; ABORT-INLINE-NEXT:    ret void
;
; RECOVER-INLINE-LABEL: define void @test_store40
; RECOVER-INLINE-SAME: (ptr [[A:%.*]], i40 [[B:%.*]]) #[[ATTR0]] {
; RECOVER-INLINE-NEXT:  entry:
; RECOVER-INLINE-NEXT:    [[TMP0:%.*]] = load i64, ptr @__hwasan_tls, align 8
; RECOVER-INLINE-NEXT:    [[TMP1:%.*]] = and i64 [[TMP0]], -9079256848778919937
; RECOVER-INLINE-NEXT:    [[TMP2:%.*]] = or i64 [[TMP1]], 4294967295
; RECOVER-INLINE-NEXT:    [[HWASAN_SHADOW:%.*]] = add i64 [[TMP2]], 1
; RECOVER-INLINE-NEXT:    [[TMP3:%.*]] = inttoptr i64 [[HWASAN_SHADOW]] to ptr
; RECOVER-INLINE-NEXT:    [[TMP4:%.*]] = ptrtoint ptr [[A]] to i64
; RECOVER-INLINE-NEXT:    call void @__hwasan_storeN_noabort(i64 [[TMP4]], i64 5)
; RECOVER-INLINE-NEXT:    store i40 [[B]], ptr [[A]], align 4
; RECOVER-INLINE-NEXT:    ret void
;
entry:
  store i40 %b, ptr %a, align 4
  ret void
}

define void @test_store_unaligned(ptr %a, i64 %b) sanitize_hwaddress {
; CHECK-LABEL: define void @test_store_unaligned
; CHECK-SAME: (ptr [[A:%.*]], i64 [[B:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[DOTHWASAN_SHADOW:%.*]] = call ptr asm "", "=r,0"(ptr null)
; CHECK-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[A]] to i64
; CHECK-NEXT:    call void @__hwasan_storeN(i64 [[TMP0]], i64 8)
; CHECK-NEXT:    store i64 [[B]], ptr [[A]], align 4
; CHECK-NEXT:    ret void
;
; NOFASTPATH-LABEL: define void @test_store_unaligned
; NOFASTPATH-SAME: (ptr [[A:%.*]], i64 [[B:%.*]]) #[[ATTR0]] {
; NOFASTPATH-NEXT:  entry:
; NOFASTPATH-NEXT:    [[DOTHWASAN_SHADOW:%.*]] = call ptr asm "", "=r,0"(ptr null)
; NOFASTPATH-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[A]] to i64
; NOFASTPATH-NEXT:    call void @__hwasan_storeN(i64 [[TMP0]], i64 8)
; NOFASTPATH-NEXT:    store i64 [[B]], ptr [[A]], align 4
; NOFASTPATH-NEXT:    ret void
;
; FASTPATH-LABEL: define void @test_store_unaligned
; FASTPATH-SAME: (ptr [[A:%.*]], i64 [[B:%.*]]) #[[ATTR0]] {
; FASTPATH-NEXT:  entry:
; FASTPATH-NEXT:    [[DOTHWASAN_SHADOW:%.*]] = call ptr asm "", "=r,0"(ptr null)
; FASTPATH-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[A]] to i64
; FASTPATH-NEXT:    call void @__hwasan_storeN(i64 [[TMP0]], i64 8)
; FASTPATH-NEXT:    store i64 [[B]], ptr [[A]], align 4
; FASTPATH-NEXT:    ret void
;
; ABORT-LABEL: define void @test_store_unaligned
; ABORT-SAME: (ptr [[A:%.*]], i64 [[B:%.*]]) #[[ATTR0]] {
; ABORT-NEXT:  entry:
; ABORT-NEXT:    [[DOTHWASAN_SHADOW:%.*]] = call ptr asm "", "=r,0"(ptr null)
; ABORT-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[A]] to i64
; ABORT-NEXT:    call void @__hwasan_storeN(i64 [[TMP0]], i64 8)
; ABORT-NEXT:    store i64 [[B]], ptr [[A]], align 4
; ABORT-NEXT:    ret void
;
; RECOVER-LABEL: define void @test_store_unaligned
; RECOVER-SAME: (ptr [[A:%.*]], i64 [[B:%.*]]) #[[ATTR0]] {
; RECOVER-NEXT:  entry:
; RECOVER-NEXT:    [[DOTHWASAN_SHADOW:%.*]] = call ptr asm "", "=r,0"(ptr null)
; RECOVER-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[A]] to i64
; RECOVER-NEXT:    call void @__hwasan_storeN_noabort(i64 [[TMP0]], i64 8)
; RECOVER-NEXT:    store i64 [[B]], ptr [[A]], align 4
; RECOVER-NEXT:    ret void
;
; ABORT-INLINE-LABEL: define void @test_store_unaligned
; ABORT-INLINE-SAME: (ptr [[A:%.*]], i64 [[B:%.*]]) #[[ATTR0]] {
; ABORT-INLINE-NEXT:  entry:
; ABORT-INLINE-NEXT:    [[TMP0:%.*]] = load i64, ptr @__hwasan_tls, align 8
; ABORT-INLINE-NEXT:    [[TMP1:%.*]] = and i64 [[TMP0]], -9079256848778919937
; ABORT-INLINE-NEXT:    [[TMP2:%.*]] = or i64 [[TMP1]], 4294967295
; ABORT-INLINE-NEXT:    [[HWASAN_SHADOW:%.*]] = add i64 [[TMP2]], 1
; ABORT-INLINE-NEXT:    [[TMP3:%.*]] = inttoptr i64 [[HWASAN_SHADOW]] to ptr
; ABORT-INLINE-NEXT:    [[TMP4:%.*]] = ptrtoint ptr [[A]] to i64
; ABORT-INLINE-NEXT:    call void @__hwasan_storeN(i64 [[TMP4]], i64 8)
; ABORT-INLINE-NEXT:    store i64 [[B]], ptr [[A]], align 4
; ABORT-INLINE-NEXT:    ret void
;
; RECOVER-INLINE-LABEL: define void @test_store_unaligned
; RECOVER-INLINE-SAME: (ptr [[A:%.*]], i64 [[B:%.*]]) #[[ATTR0]] {
; RECOVER-INLINE-NEXT:  entry:
; RECOVER-INLINE-NEXT:    [[TMP0:%.*]] = load i64, ptr @__hwasan_tls, align 8
; RECOVER-INLINE-NEXT:    [[TMP1:%.*]] = and i64 [[TMP0]], -9079256848778919937
; RECOVER-INLINE-NEXT:    [[TMP2:%.*]] = or i64 [[TMP1]], 4294967295
; RECOVER-INLINE-NEXT:    [[HWASAN_SHADOW:%.*]] = add i64 [[TMP2]], 1
; RECOVER-INLINE-NEXT:    [[TMP3:%.*]] = inttoptr i64 [[HWASAN_SHADOW]] to ptr
; RECOVER-INLINE-NEXT:    [[TMP4:%.*]] = ptrtoint ptr [[A]] to i64
; RECOVER-INLINE-NEXT:    call void @__hwasan_storeN_noabort(i64 [[TMP4]], i64 8)
; RECOVER-INLINE-NEXT:    store i64 [[B]], ptr [[A]], align 4
; RECOVER-INLINE-NEXT:    ret void
;
entry:
  store i64 %b, ptr %a, align 4
  ret void
}
