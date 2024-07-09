; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 4
; RUN: opt -passes=slp-vectorizer -mtriple=x86_64-unknown-linux-gnu -mcpu=x86-64-v3 -S < %s | FileCheck %s

define void @foo(double %i) {
; CHECK-LABEL: define void @foo(
; CHECK-SAME: double [[I:%.*]]) #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[TMP0:%.*]] = insertelement <4 x double> <double 0.000000e+00, double 0.000000e+00, double poison, double 0.000000e+00>, double [[I]], i32 2
; CHECK-NEXT:    [[TMP1:%.*]] = fsub <4 x double> zeroinitializer, [[TMP0]]
; CHECK-NEXT:    [[TMP2:%.*]] = extractelement <4 x double> [[TMP1]], i32 1
; CHECK-NEXT:    [[TMP3:%.*]] = insertelement <2 x double> poison, double [[I]], i32 0
; CHECK-NEXT:    [[TMP4:%.*]] = fsub <2 x double> zeroinitializer, [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <2 x double> [[TMP4]], i32 1
; CHECK-NEXT:    [[TMP6:%.*]] = shufflevector <2 x double> [[TMP4]], <2 x double> poison, <8 x i32> <i32 poison, i32 poison, i32 1, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
; CHECK-NEXT:    [[TMP7:%.*]] = shufflevector <8 x double> [[TMP6]], <8 x double> <double 0.000000e+00, double poison, double poison, double poison, double poison, double 0.000000e+00, double 0.000000e+00, double 0.000000e+00>, <8 x i32> <i32 8, i32 poison, i32 2, i32 poison, i32 poison, i32 13, i32 14, i32 15>
; CHECK-NEXT:    [[TMP8:%.*]] = insertelement <8 x double> [[TMP7]], double [[TMP2]], i32 3
; CHECK-NEXT:    [[TMP9:%.*]] = shufflevector <4 x double> [[TMP1]], <4 x double> poison, <8 x i32> <i32 0, i32 poison, i32 poison, i32 poison, i32 poison, i32 0, i32 poison, i32 1>
; CHECK-NEXT:    [[TMP10:%.*]] = shufflevector <8 x double> [[TMP9]], <8 x double> <double poison, double 0.000000e+00, double 0.000000e+00, double 0.000000e+00, double 0.000000e+00, double poison, double poison, double poison>, <8 x i32> <i32 0, i32 9, i32 10, i32 11, i32 12, i32 5, i32 poison, i32 7>
; CHECK-NEXT:    [[TMP11:%.*]] = insertelement <8 x double> [[TMP10]], double [[TMP5]], i32 6
; CHECK-NEXT:    [[TMP12:%.*]] = fmul <8 x double> [[TMP8]], [[TMP11]]
; CHECK-NEXT:    [[TMP13:%.*]] = fadd <8 x double> zeroinitializer, [[TMP12]]
; CHECK-NEXT:    [[TMP14:%.*]] = fadd <8 x double> [[TMP13]], zeroinitializer
; CHECK-NEXT:    [[TMP15:%.*]] = fcmp ult <8 x double> [[TMP14]], zeroinitializer
; CHECK-NEXT:    [[TMP16:%.*]] = freeze <8 x i1> [[TMP15]]
; CHECK-NEXT:    [[TMP17:%.*]] = call i1 @llvm.vector.reduce.and.v8i1(<8 x i1> [[TMP16]])
; CHECK-NEXT:    br i1 [[TMP17]], label [[BB58:%.*]], label [[BB115:%.*]]
; CHECK:       bb115:
; CHECK-NEXT:    [[TMP18:%.*]] = fmul <2 x double> zeroinitializer, [[TMP4]]
; CHECK-NEXT:    [[TMP19:%.*]] = extractelement <2 x double> [[TMP18]], i32 0
; CHECK-NEXT:    [[TMP20:%.*]] = extractelement <2 x double> [[TMP18]], i32 1
; CHECK-NEXT:    [[I118:%.*]] = fadd double [[TMP19]], [[TMP20]]
; CHECK-NEXT:    [[TMP21:%.*]] = fmul <4 x double> zeroinitializer, [[TMP1]]
; CHECK-NEXT:    [[TMP22:%.*]] = shufflevector <2 x double> [[TMP4]], <2 x double> poison, <4 x i32> <i32 0, i32 1, i32 poison, i32 poison>
; CHECK-NEXT:    [[TMP23:%.*]] = shufflevector <4 x double> <double 0.000000e+00, double 0.000000e+00, double 0.000000e+00, double poison>, <4 x double> [[TMP22]], <4 x i32> <i32 0, i32 1, i32 2, i32 5>
; CHECK-NEXT:    [[TMP24:%.*]] = fadd <4 x double> [[TMP21]], [[TMP23]]
; CHECK-NEXT:    [[TMP25:%.*]] = fadd <4 x double> [[TMP24]], zeroinitializer
; CHECK-NEXT:    [[TMP26:%.*]] = select <4 x i1> zeroinitializer, <4 x double> zeroinitializer, <4 x double> [[TMP25]]
; CHECK-NEXT:    [[TMP27:%.*]] = fmul <4 x double> [[TMP26]], zeroinitializer
; CHECK-NEXT:    [[TMP28:%.*]] = fmul <4 x double> [[TMP27]], zeroinitializer
; CHECK-NEXT:    [[TMP29:%.*]] = fptosi <4 x double> [[TMP28]] to <4 x i32>
; CHECK-NEXT:    [[TMP30:%.*]] = or <4 x i32> zeroinitializer, [[TMP29]]
; CHECK-NEXT:    [[TMP31:%.*]] = call i32 @llvm.vector.reduce.smin.v4i32(<4 x i32> [[TMP30]])
; CHECK-NEXT:    [[OP_RDX:%.*]] = icmp slt i32 [[TMP31]], 32000
; CHECK-NEXT:    [[OP_RDX1:%.*]] = select i1 [[OP_RDX]], i32 [[TMP31]], i32 32000
; CHECK-NEXT:    [[I163:%.*]] = fcmp ogt double [[I118]], 0.000000e+00
; CHECK-NEXT:    [[I164:%.*]] = icmp slt i32 0, [[OP_RDX1]]
; CHECK-NEXT:    unreachable
; CHECK:       bb58:
; CHECK-NEXT:    ret void
;
bb:
  %i75 = fsub double 0.000000e+00, 0.000000e+00
  %i76 = fsub double 0.000000e+00, 0.000000e+00
  %i77 = fmul double 0.000000e+00, %i75
  %i78 = fmul double 0.000000e+00, %i76
  %i79 = fadd double %i78, 0.000000e+00
  %i80 = fadd double %i79, 0.000000e+00
  %i81 = fcmp ult double %i80, 0.000000e+00
  %i82 = fsub double 0.000000e+00, poison
  %i83 = fmul double 0.000000e+00, %i82
  %i84 = fadd double 0.000000e+00, %i83
  %i85 = fadd double %i84, 0.000000e+00
  %i86 = fcmp ult double %i85, 0.000000e+00
  %i87 = fsub double 0.000000e+00, %i
  %i88 = fadd double 0.000000e+00, %i77
  %i89 = fadd double %i88, 0.000000e+00
  %i90 = fcmp ult double %i89, 0.000000e+00
  %i91 = fsub double 0.000000e+00, 0.000000e+00
  %i92 = fmul double poison, 0.000000e+00
  %i93 = fadd double %i92, 0.000000e+00
  %i94 = fadd double %i93, 0.000000e+00
  %i95 = fcmp ult double %i94, 0.000000e+00
  %i96 = fadd double %i79, 0.000000e+00
  %i97 = fcmp ult double %i96, 0.000000e+00
  %i98 = fadd double %i84, 0.000000e+00
  %i99 = fcmp ult double %i98, 0.000000e+00
  %i100 = fadd double 0.000000e+00, %i77
  %i101 = fadd double %i100, 0.000000e+00
  %i102 = fcmp ult double %i101, 0.000000e+00
  %i103 = fsub double 0.000000e+00, %i
  %i104 = fmul double poison, 0.000000e+00
  %i105 = fadd double %i104, 0.000000e+00
  %i106 = fadd double %i105, 0.000000e+00
  %i107 = fcmp ult double %i106, 0.000000e+00
  %i108 = select i1 %i107, i1 %i102, i1 false
  %i109 = select i1 %i108, i1 %i99, i1 false
  %i110 = select i1 %i109, i1 %i97, i1 false
  %i111 = select i1 %i110, i1 %i95, i1 false
  %i112 = select i1 %i111, i1 %i90, i1 false
  %i113 = select i1 %i112, i1 %i86, i1 false
  %i114 = select i1 %i113, i1 %i81, i1 false
  br i1 %i114, label %bb58, label %bb115

bb115:
  %i116 = fmul double 0.000000e+00, %i103
  %i117 = fmul double 0.000000e+00, %i82
  %i118 = fadd double %i116, %i117
  %i120 = fmul double 0.000000e+00, %i75
  %i121 = fmul double 0.000000e+00, %i76
  %i122 = fadd double %i121, 0.000000e+00
  %i123 = fadd double 0.000000e+00, %i120
  %i124 = fmul double 0.000000e+00, %i91
  %i125 = fadd double %i124, %i82
  %i126 = fadd double %i125, 0.000000e+00
  %i127 = fmul double 0.000000e+00, %i87
  %i128 = fadd double %i127, 0.000000e+00
  %i129 = fadd double %i128, 0.000000e+00
  %i130 = fadd double %i122, 0.000000e+00
  %i131 = fadd double %i123, 0.000000e+00
  %i132 = select i1 false, double 0.000000e+00, double %i131
  %i133 = fmul double %i132, 0.000000e+00
  %i134 = fmul double %i133, 0.000000e+00
  %i135 = fptosi double %i134 to i32
  %i136 = or i32 0, %i135
  %i137 = icmp slt i32 %i136, 32000
  %i138 = select i1 %i137, i32 %i136, i32 32000
  %i139 = select i1 false, double 0.000000e+00, double %i130
  %i140 = fmul double %i139, 0.000000e+00
  %i141 = fmul double %i140, 0.000000e+00
  %i142 = fptosi double %i141 to i32
  %i143 = or i32 0, %i142
  %i144 = icmp slt i32 %i143, %i138
  %i145 = select i1 %i144, i32 %i143, i32 %i138
  %i146 = select i1 false, double 0.000000e+00, double %i129
  %i147 = fmul double %i146, 0.000000e+00
  %i148 = fmul double %i147, 0.000000e+00
  %i149 = fptosi double %i148 to i32
  %i150 = or i32 0, %i149
  %i151 = icmp slt i32 %i150, %i145
  %i152 = select i1 %i151, i32 %i150, i32 %i145
  %i153 = select i1 false, double 0.000000e+00, double %i126
  %i154 = fmul double %i153, 0.000000e+00
  %i155 = fmul double %i154, 0.000000e+00
  %i156 = fptosi double %i155 to i32
  %i157 = or i32 0, %i156
  %i158 = icmp slt i32 %i157, %i152
  %i159 = select i1 %i158, i32 %i157, i32 %i152
  %i163 = fcmp ogt double %i118, 0.000000e+00
  %i164 = icmp slt i32 0, %i159
  unreachable

bb58:
  ret void
}
