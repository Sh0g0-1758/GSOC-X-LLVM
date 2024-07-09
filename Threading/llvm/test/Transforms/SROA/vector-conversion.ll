; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes='sroa<preserve-cfg>' -S | FileCheck %s --check-prefixes=CHECK,CHECK-PRESERVE-CFG
; RUN: opt < %s -passes='sroa<modify-cfg>' -S | FileCheck %s --check-prefixes=CHECK,CHECK-MODIFY-CFG
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-n8:16:32:64"

define <4 x i64> @vector_ptrtoint({<2 x ptr>, <2 x ptr>} %x) {
; CHECK-LABEL: @vector_ptrtoint(
; CHECK-NEXT:    [[X_FCA_0_EXTRACT:%.*]] = extractvalue { <2 x ptr>, <2 x ptr> } [[X:%.*]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = ptrtoint <2 x ptr> [[X_FCA_0_EXTRACT]] to <2 x i64>
; CHECK-NEXT:    [[A_SROA_0_0_VEC_EXPAND:%.*]] = shufflevector <2 x i64> [[TMP1]], <2 x i64> poison, <4 x i32> <i32 0, i32 1, i32 poison, i32 poison>
; CHECK-NEXT:    [[A_SROA_0_0_VECBLEND:%.*]] = select <4 x i1> <i1 true, i1 true, i1 false, i1 false>, <4 x i64> [[A_SROA_0_0_VEC_EXPAND]], <4 x i64> undef
; CHECK-NEXT:    [[X_FCA_1_EXTRACT:%.*]] = extractvalue { <2 x ptr>, <2 x ptr> } [[X]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = ptrtoint <2 x ptr> [[X_FCA_1_EXTRACT]] to <2 x i64>
; CHECK-NEXT:    [[A_SROA_0_16_VEC_EXPAND:%.*]] = shufflevector <2 x i64> [[TMP2]], <2 x i64> poison, <4 x i32> <i32 poison, i32 poison, i32 0, i32 1>
; CHECK-NEXT:    [[A_SROA_0_16_VECBLEND:%.*]] = select <4 x i1> <i1 false, i1 false, i1 true, i1 true>, <4 x i64> [[A_SROA_0_16_VEC_EXPAND]], <4 x i64> [[A_SROA_0_0_VECBLEND]]
; CHECK-NEXT:    ret <4 x i64> [[A_SROA_0_16_VECBLEND]]
;
  %a = alloca {<2 x ptr>, <2 x ptr>}

  store {<2 x ptr>, <2 x ptr>} %x, ptr %a

  %vec = load <4 x i64>, ptr %a

  ret <4 x i64> %vec
}

define <4 x ptr> @vector_inttoptr({<2 x i64>, <2 x i64>} %x) {
; CHECK-LABEL: @vector_inttoptr(
; CHECK-NEXT:    [[X_FCA_0_EXTRACT:%.*]] = extractvalue { <2 x i64>, <2 x i64> } [[X:%.*]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = inttoptr <2 x i64> [[X_FCA_0_EXTRACT]] to <2 x ptr>
; CHECK-NEXT:    [[A_SROA_0_0_VEC_EXPAND:%.*]] = shufflevector <2 x ptr> [[TMP1]], <2 x ptr> poison, <4 x i32> <i32 0, i32 1, i32 poison, i32 poison>
; CHECK-NEXT:    [[A_SROA_0_0_VECBLEND:%.*]] = select <4 x i1> <i1 true, i1 true, i1 false, i1 false>, <4 x ptr> [[A_SROA_0_0_VEC_EXPAND]], <4 x ptr> undef
; CHECK-NEXT:    [[X_FCA_1_EXTRACT:%.*]] = extractvalue { <2 x i64>, <2 x i64> } [[X]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = inttoptr <2 x i64> [[X_FCA_1_EXTRACT]] to <2 x ptr>
; CHECK-NEXT:    [[A_SROA_0_16_VEC_EXPAND:%.*]] = shufflevector <2 x ptr> [[TMP2]], <2 x ptr> poison, <4 x i32> <i32 poison, i32 poison, i32 0, i32 1>
; CHECK-NEXT:    [[A_SROA_0_16_VECBLEND:%.*]] = select <4 x i1> <i1 false, i1 false, i1 true, i1 true>, <4 x ptr> [[A_SROA_0_16_VEC_EXPAND]], <4 x ptr> [[A_SROA_0_0_VECBLEND]]
; CHECK-NEXT:    ret <4 x ptr> [[A_SROA_0_16_VECBLEND]]
;
  %a = alloca {<2 x i64>, <2 x i64>}

  store {<2 x i64>, <2 x i64>} %x, ptr %a

  %vec = load <4 x ptr>, ptr %a

  ret <4 x ptr> %vec
}

define <2 x i64> @vector_ptrtointbitcast({<1 x ptr>, <1 x ptr>} %x) {
; CHECK-LABEL: @vector_ptrtointbitcast(
; CHECK-NEXT:    [[X_FCA_0_EXTRACT:%.*]] = extractvalue { <1 x ptr>, <1 x ptr> } [[X:%.*]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = ptrtoint <1 x ptr> [[X_FCA_0_EXTRACT]] to <1 x i64>
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast <1 x i64> [[TMP1]] to i64
; CHECK-NEXT:    [[A_SROA_0_0_VEC_INSERT:%.*]] = insertelement <2 x i64> undef, i64 [[TMP2]], i32 0
; CHECK-NEXT:    [[X_FCA_1_EXTRACT:%.*]] = extractvalue { <1 x ptr>, <1 x ptr> } [[X]], 1
; CHECK-NEXT:    [[TMP3:%.*]] = ptrtoint <1 x ptr> [[X_FCA_1_EXTRACT]] to <1 x i64>
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast <1 x i64> [[TMP3]] to i64
; CHECK-NEXT:    [[A_SROA_0_8_VEC_INSERT:%.*]] = insertelement <2 x i64> [[A_SROA_0_0_VEC_INSERT]], i64 [[TMP4]], i32 1
; CHECK-NEXT:    ret <2 x i64> [[A_SROA_0_8_VEC_INSERT]]
;
  %a = alloca {<1 x ptr>, <1 x ptr>}

  store {<1 x ptr>, <1 x ptr>} %x, ptr %a

  %vec = load <2 x i64>, ptr %a

  ret <2 x i64> %vec
}

define <2 x ptr> @vector_inttoptrbitcast_vector({<16 x i8>, <16 x i8>} %x) {
; CHECK-LABEL: @vector_inttoptrbitcast_vector(
; CHECK-NEXT:    [[X_FCA_0_EXTRACT:%.*]] = extractvalue { <16 x i8>, <16 x i8> } [[X:%.*]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <16 x i8> [[X_FCA_0_EXTRACT]] to <2 x i64>
; CHECK-NEXT:    [[TMP2:%.*]] = inttoptr <2 x i64> [[TMP1]] to <2 x ptr>
; CHECK-NEXT:    [[X_FCA_1_EXTRACT:%.*]] = extractvalue { <16 x i8>, <16 x i8> } [[X]], 1
; CHECK-NEXT:    ret <2 x ptr> [[TMP2]]
;
  %a = alloca {<16 x i8>, <16 x i8>}

  store {<16 x i8>, <16 x i8>} %x, ptr %a

  %vec = load <2 x ptr>, ptr %a

  ret <2 x ptr> %vec
}

define <16 x i8> @vector_ptrtointbitcast_vector({<2 x ptr>, <2 x ptr>} %x) {
; CHECK-LABEL: @vector_ptrtointbitcast_vector(
; CHECK-NEXT:    [[X_FCA_0_EXTRACT:%.*]] = extractvalue { <2 x ptr>, <2 x ptr> } [[X:%.*]], 0
; CHECK-NEXT:    [[X_FCA_1_EXTRACT:%.*]] = extractvalue { <2 x ptr>, <2 x ptr> } [[X]], 1
; CHECK-NEXT:    [[TMP1:%.*]] = ptrtoint <2 x ptr> [[X_FCA_0_EXTRACT]] to <2 x i64>
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast <2 x i64> [[TMP1]] to <16 x i8>
; CHECK-NEXT:    ret <16 x i8> [[TMP2]]
;
  %a = alloca {<2 x ptr>, <2 x ptr>}

  store {<2 x ptr>, <2 x ptr>} %x, ptr %a

  %vec = load <16 x i8>, ptr %a

  ret <16 x i8> %vec
}
;; NOTE: These prefixes are unused and the list is autogenerated. Do not add tests below this line:
; CHECK-MODIFY-CFG: {{.*}}
; CHECK-PRESERVE-CFG: {{.*}}
