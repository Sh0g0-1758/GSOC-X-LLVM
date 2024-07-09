// RUN: llvm-mc -triple=amdgcn -mcpu=gfx1010 -show-encoding %s | FileCheck -check-prefix=GFX10 %s

v_mad_i16 v5, v1, 4.0, v3
// GFX10: v_mad_i16 v5, v1, 4.0, v3 ; encoding: [0x05,0x00,0x5e,0xd7,0x01,0xed,0x0d,0x04]

v_mad_i16 v5, v1, 0x4400, v3
// GFX10: v_mad_i16 v5, v1, 0x4400, v3    ; encoding: [0x05,0x00,0x5e,0xd7,0x01,0xff,0x0d,0x04,0x00,0x44,0x00,0x00]

v_mad_i16 v5, v1, -4.0, v3
// GFX10: v_mad_i16 v5, v1, -4.0, v3 ; encoding: [0x05,0x00,0x5e,0xd7,0x01,0xef,0x0d,0x04]

v_mad_i16 v5, v1, 0xc400, v3
// GFX10: v_mad_i16 v5, v1, 0xc400, v3    ; encoding: [0x05,0x00,0x5e,0xd7,0x01,0xff,0x0d,0x04,0x00,0xc4,0x00,0x00]
