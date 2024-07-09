; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=s390x-linux-gnu -mcpu=z13 < %s  | FileCheck %s

; Store a <4 x i31> vector.
define void @fun0(<4 x i31> %src, ptr %p)
; CHECK-LABEL: fun0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vlgvf %r0, %v24, 0
; CHECK-NEXT:    vlvgp %v0, %r0, %r0
; CHECK-NEXT:    vrepib %v1, 93
; CHECK-NEXT:    vlgvf %r0, %v24, 1
; CHECK-NEXT:    vslb %v0, %v0, %v1
; CHECK-NEXT:    larl %r1, .LCPI0_0
; CHECK-NEXT:    vl %v2, 0(%r1), 3
; CHECK-NEXT:    vsl %v0, %v0, %v1
; CHECK-NEXT:    vlvgp %v1, %r0, %r0
; CHECK-NEXT:    vn %v1, %v1, %v2
; CHECK-NEXT:    vrepib %v3, 62
; CHECK-NEXT:    vslb %v1, %v1, %v3
; CHECK-NEXT:    vlgvf %r0, %v24, 2
; CHECK-NEXT:    vsl %v1, %v1, %v3
; CHECK-NEXT:    vo %v0, %v0, %v1
; CHECK-NEXT:    vlvgp %v1, %r0, %r0
; CHECK-NEXT:    vn %v1, %v1, %v2
; CHECK-NEXT:    vrepib %v3, 31
; CHECK-NEXT:    vslb %v1, %v1, %v3
; CHECK-NEXT:    vlgvf %r0, %v24, 3
; CHECK-NEXT:    vsl %v1, %v1, %v3
; CHECK-NEXT:    vo %v0, %v0, %v1
; CHECK-NEXT:    vlvgp %v1, %r0, %r0
; CHECK-NEXT:    larl %r1, .LCPI0_1
; CHECK-NEXT:    vn %v1, %v1, %v2
; CHECK-NEXT:    vo %v0, %v0, %v1
; CHECK-NEXT:    vl %v1, 0(%r1), 3
; CHECK-NEXT:    vn %v0, %v0, %v1
; CHECK-NEXT:    vst %v0, 0(%r2), 4
; CHECK-NEXT:    br %r14
{
  store <4 x i31> %src, ptr %p
  ret void
}

; Store a <16 x i1> vector.
define i16 @fun1(<16 x i1> %src)
; CHECK-LABEL: fun1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    aghi %r15, -168
; CHECK-NEXT:    .cfi_def_cfa_offset 328
; CHECK-NEXT:    vlgvb %r0, %v24, 0
; CHECK-NEXT:    vlgvb %r1, %v24, 1
; CHECK-NEXT:    risblg %r0, %r0, 16, 144, 15
; CHECK-NEXT:    rosbg %r0, %r1, 49, 49, 14
; CHECK-NEXT:    vlgvb %r1, %v24, 2
; CHECK-NEXT:    rosbg %r0, %r1, 50, 50, 13
; CHECK-NEXT:    vlgvb %r1, %v24, 3
; CHECK-NEXT:    rosbg %r0, %r1, 51, 51, 12
; CHECK-NEXT:    vlgvb %r1, %v24, 4
; CHECK-NEXT:    rosbg %r0, %r1, 52, 52, 11
; CHECK-NEXT:    vlgvb %r1, %v24, 5
; CHECK-NEXT:    rosbg %r0, %r1, 53, 53, 10
; CHECK-NEXT:    vlgvb %r1, %v24, 6
; CHECK-NEXT:    rosbg %r0, %r1, 54, 54, 9
; CHECK-NEXT:    vlgvb %r1, %v24, 7
; CHECK-NEXT:    rosbg %r0, %r1, 55, 55, 8
; CHECK-NEXT:    vlgvb %r1, %v24, 8
; CHECK-NEXT:    rosbg %r0, %r1, 56, 56, 7
; CHECK-NEXT:    vlgvb %r1, %v24, 9
; CHECK-NEXT:    rosbg %r0, %r1, 57, 57, 6
; CHECK-NEXT:    vlgvb %r1, %v24, 10
; CHECK-NEXT:    rosbg %r0, %r1, 58, 58, 5
; CHECK-NEXT:    vlgvb %r1, %v24, 11
; CHECK-NEXT:    rosbg %r0, %r1, 59, 59, 4
; CHECK-NEXT:    vlgvb %r1, %v24, 12
; CHECK-NEXT:    rosbg %r0, %r1, 60, 60, 3
; CHECK-NEXT:    vlgvb %r1, %v24, 13
; CHECK-NEXT:    rosbg %r0, %r1, 61, 61, 2
; CHECK-NEXT:    vlgvb %r1, %v24, 14
; CHECK-NEXT:    rosbg %r0, %r1, 62, 62, 1
; CHECK-NEXT:    vlgvb %r1, %v24, 15
; CHECK-NEXT:    rosbg %r0, %r1, 63, 63, 0
; CHECK-NEXT:    llhr %r2, %r0
; CHECK-NEXT:    aghi %r15, 168
; CHECK-NEXT:    br %r14
{
  %res = bitcast <16 x i1> %src to i16
  ret i16 %res
}

; Truncate a <8 x i32> vector to <8 x i31> and store it (test splitting).
define void @fun2(<8 x i32> %src, ptr %p)
; CHECK-LABEL: fun2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vlgvf %r0, %v26, 3
; CHECK-NEXT:    vlvgp %v0, %r0, %r0
; CHECK-NEXT:    srl %r0, 8
; CHECK-NEXT:    vsteb %v0, 30(%r2), 15
; CHECK-NEXT:    vlvgp %v1, %r0, %r0
; CHECK-NEXT:    vsteh %v1, 28(%r2), 7
; CHECK-NEXT:    larl %r1, .LCPI2_0
; CHECK-NEXT:    vl %v1, 0(%r1), 3
; CHECK-NEXT:    vlgvf %r0, %v26, 2
; CHECK-NEXT:    larl %r1, .LCPI2_1
; CHECK-NEXT:    vl %v2, 0(%r1), 3
; CHECK-NEXT:    vn %v0, %v0, %v1
; CHECK-NEXT:    vlvgp %v1, %r0, %r0
; CHECK-NEXT:    vn %v1, %v1, %v2
; CHECK-NEXT:    vrepib %v3, 31
; CHECK-NEXT:    vslb %v1, %v1, %v3
; CHECK-NEXT:    vsl %v1, %v1, %v3
; CHECK-NEXT:    vo %v0, %v1, %v0
; CHECK-NEXT:    vrepib %v3, 24
; CHECK-NEXT:    vlgvf %r0, %v24, 3
; CHECK-NEXT:    vsrlb %v0, %v0, %v3
; CHECK-NEXT:    vstef %v0, 24(%r2), 3
; CHECK-NEXT:    vlvgp %v0, %r0, %r0
; CHECK-NEXT:    vrepib %v3, 124
; CHECK-NEXT:    vlgvf %r0, %v26, 0
; CHECK-NEXT:    vslb %v4, %v0, %v3
; CHECK-NEXT:    vsl %v3, %v4, %v3
; CHECK-NEXT:    vlvgp %v4, %r0, %r0
; CHECK-NEXT:    vn %v4, %v4, %v2
; CHECK-NEXT:    vlgvf %r0, %v26, 1
; CHECK-NEXT:    larl %r1, .LCPI2_2
; CHECK-NEXT:    vrepib %v5, 93
; CHECK-NEXT:    vslb %v4, %v4, %v5
; CHECK-NEXT:    vsl %v4, %v4, %v5
; CHECK-NEXT:    vo %v3, %v3, %v4
; CHECK-NEXT:    vlvgp %v4, %r0, %r0
; CHECK-NEXT:    vlgvf %r0, %v24, 0
; CHECK-NEXT:    vn %v4, %v4, %v2
; CHECK-NEXT:    vrepib %v5, 62
; CHECK-NEXT:    vslb %v4, %v4, %v5
; CHECK-NEXT:    vsl %v4, %v4, %v5
; CHECK-NEXT:    vo %v4, %v3, %v4
; CHECK-NEXT:    vo %v1, %v4, %v1
; CHECK-NEXT:    vrepib %v4, 56
; CHECK-NEXT:    vrepib %v5, 58
; CHECK-NEXT:    vsrlb %v1, %v1, %v4
; CHECK-NEXT:    vsteg %v1, 16(%r2), 1
; CHECK-NEXT:    vrepib %v1, 120
; CHECK-NEXT:    vrepib %v4, 89
; CHECK-NEXT:    vsrlb %v1, %v3, %v1
; CHECK-NEXT:    vlvgp %v3, %r0, %r0
; CHECK-NEXT:    vlgvf %r0, %v24, 1
; CHECK-NEXT:    vslb %v3, %v3, %v4
; CHECK-NEXT:    vsl %v3, %v3, %v4
; CHECK-NEXT:    vlvgp %v4, %r0, %r0
; CHECK-NEXT:    vlgvf %r0, %v24, 2
; CHECK-NEXT:    vn %v4, %v4, %v2
; CHECK-NEXT:    vslb %v4, %v4, %v5
; CHECK-NEXT:    vsl %v4, %v4, %v5
; CHECK-NEXT:    vo %v3, %v3, %v4
; CHECK-NEXT:    vlvgp %v4, %r0, %r0
; CHECK-NEXT:    vn %v2, %v4, %v2
; CHECK-NEXT:    vrepib %v4, 27
; CHECK-NEXT:    vslb %v2, %v2, %v4
; CHECK-NEXT:    vsl %v2, %v2, %v4
; CHECK-NEXT:    vo %v2, %v3, %v2
; CHECK-NEXT:    vl %v3, 0(%r1), 3
; CHECK-NEXT:    vn %v0, %v0, %v3
; CHECK-NEXT:    vrepib %v3, 4
; CHECK-NEXT:    vsrl %v0, %v0, %v3
; CHECK-NEXT:    vo %v0, %v2, %v0
; CHECK-NEXT:    vrepib %v2, 8
; CHECK-NEXT:    vslb %v0, %v0, %v2
; CHECK-NEXT:    vo %v0, %v0, %v1
; CHECK-NEXT:    vst %v0, 0(%r2), 4
; CHECK-NEXT:    br %r14
{
  %tmp = trunc <8 x i32> %src to <8 x i31>
  store <8 x i31> %tmp, ptr %p
  ret void
}

; Load and store a <3 x i31> vector (test widening).
define void @fun3(ptr %src, ptr %p)
; CHECK-LABEL: fun3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vgbm %v0, 0
; CHECK-NEXT:    vleg %v0, 0(%r2), 1
; CHECK-NEXT:    vgbm %v1, 0
; CHECK-NEXT:    vlef %v1, 8(%r2), 3
; CHECK-NEXT:    vrepib %v2, 32
; CHECK-NEXT:    vslb %v0, %v0, %v2
; CHECK-NEXT:    vo %v0, %v1, %v0
; CHECK-NEXT:    vstef %v0, 8(%r3), 3
; CHECK-NEXT:    vsrlb %v0, %v0, %v2
; CHECK-NEXT:    vsteg %v0, 0(%r3), 1
; CHECK-NEXT:    br %r14
{
  %tmp = load <3 x i31>, ptr %src
  store <3 x i31> %tmp, ptr %p
  ret void
}
