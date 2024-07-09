// RUN: llvm-mc -triple=amdgcn -mcpu=gfx1100 -mattr=+wavefrontsize32,-wavefrontsize64 -show-encoding %s | FileCheck --check-prefixes=GFX11 %s
// RUN: llvm-mc -triple=amdgcn -mcpu=gfx1100 -mattr=-wavefrontsize32,+wavefrontsize64 -show-encoding %s | FileCheck --check-prefixes=GFX11 %s

v_fma_mix_f32 v0, v1, v2, v3 dpp8:[2,2,2,2,4,4,4,4]
// GFX11: encoding: [0x00,0x00,0x20,0xcc,0xe9,0x04,0x0e,0x04,0x01,0x92,0x44,0x92]

v_fma_mix_f32 v0, v1, v2, v3 clamp dpp8:[2,2,2,2,4,4,4,4] fi:1
// GFX11: encoding: [0x00,0x80,0x20,0xcc,0xea,0x04,0x0e,0x04,0x01,0x92,0x44,0x92]

v_fma_mixlo_f16 v0, abs(v1), -v2, abs(v3) dpp8:[2,2,2,2,4,4,4,4]
// GFX11: encoding: [0x00,0x05,0x21,0xcc,0xe9,0x04,0x0e,0x44,0x01,0x92,0x44,0x92]

// For test purpose only. OP_SEL has to be set to all 0 and OP_SEL_HI has to be set to all 1
v_fma_mixlo_f16 v0, abs(v1), -v2, abs(v3) op_sel:[1,0,0] op_sel_hi:[1,0,0] dpp8:[2,2,2,2,4,4,4,4]
// GFX11: encoding: [0x00,0x0d,0x21,0xcc,0xe9,0x04,0x0e,0x4c,0x01,0x92,0x44,0x92]

v_dot2_f32_f16_e64_dpp v0, v1, v2, v3 neg_lo:[0,1,1] neg_hi:[1,0,1] dpp8:[7,6,5,4,3,2,1,0]
// GFX11: encoding: [0x00,0x45,0x13,0xcc,0xe9,0x04,0x0e,0xdc,0x01,0x77,0x39,0x05]
