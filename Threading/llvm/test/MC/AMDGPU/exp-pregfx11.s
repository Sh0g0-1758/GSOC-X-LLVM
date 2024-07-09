// RUN: llvm-mc -triple=amdgcn -show-encoding %s | FileCheck -check-prefix=SI %s
// RUN: llvm-mc -triple=amdgcn -mcpu=tonga -show-encoding %s | FileCheck -check-prefix=GFX89 %s
// RUN: llvm-mc -triple=amdgcn -mcpu=gfx900 -show-encoding %s | FileCheck -check-prefix=GFX89 %s
// RUN: llvm-mc -triple=amdgcn -mcpu=gfx1010 -show-encoding %s | FileCheck -check-prefix=GFX10 %s

exp null v4, v3, v2, v1
// SI: exp null v4, v3, v2, v1 ; encoding: [0x9f,0x00,0x00,0xf8,0x04,0x03,0x02,0x01]
// GFX89: exp null v4, v3, v2, v1 ; encoding: [0x9f,0x00,0x00,0xc4,0x04,0x03,0x02,0x01]
// GFX10: exp null v4, v3, v2, v1 ; encoding: [0x9f,0x00,0x00,0xf8,0x04,0x03,0x02,0x01]

exp null v4, v3, v2, v1 done
// SI: exp null v4, v3, v2, v1 done ; encoding: [0x9f,0x08,0x00,0xf8,0x04,0x03,0x02,0x01]
// GFX89: exp null v4, v3, v2, v1 done ; encoding: [0x9f,0x08,0x00,0xc4,0x04,0x03,0x02,0x01]
// GFX10: exp null v4, v3, v2, v1 done ; encoding: [0x9f,0x08,0x00,0xf8,0x04,0x03,0x02,0x01]

exp param0 v4, v3, v2, v1
// SI: exp param0 v4, v3, v2, v1 ; encoding: [0x0f,0x02,0x00,0xf8,0x04,0x03,0x02,0x01]
// GFX89: exp param0 v4, v3, v2, v1 ; encoding: [0x0f,0x02,0x00,0xc4,0x04,0x03,0x02,0x01]
// GFX10: exp param0 v4, v3, v2, v1 ; encoding: [0x0f,0x02,0x00,0xf8,0x04,0x03,0x02,0x01]

exp param0 v4, v3, v2, v1 done
// SI: exp param0 v4, v3, v2, v1 done ; encoding: [0x0f,0x0a,0x00,0xf8,0x04,0x03,0x02,0x01]
// GFX89: exp param0 v4, v3, v2, v1 done ; encoding: [0x0f,0x0a,0x00,0xc4,0x04,0x03,0x02,0x01]
// GFX10: exp param0 v4, v3, v2, v1 done ; encoding: [0x0f,0x0a,0x00,0xf8,0x04,0x03,0x02,0x01]

exp param31 v4, v3, v2, v1
// SI: exp param31 v4, v3, v2, v1 ; encoding: [0xff,0x03,0x00,0xf8,0x04,0x03,0x02,0x01]
// GFX89: exp param31 v4, v3, v2, v1 ; encoding: [0xff,0x03,0x00,0xc4,0x04,0x03,0x02,0x01]
// GFX10: exp param31 v4, v3, v2, v1 ; encoding: [0xff,0x03,0x00,0xf8,0x04,0x03,0x02,0x01]

exp param31 v4, v3, v2, v1 done
// SI: exp param31 v4, v3, v2, v1 done ; encoding: [0xff,0x0b,0x00,0xf8,0x04,0x03,0x02,0x01]
// GFX89: exp param31 v4, v3, v2, v1 done ; encoding: [0xff,0x0b,0x00,0xc4,0x04,0x03,0x02,0x01]
// GFX10: exp param31 v4, v3, v2, v1 done ; encoding: [0xff,0x0b,0x00,0xf8,0x04,0x03,0x02,0x01]

exp mrt0 v4, v3, v2, v1 vm
// SI: exp mrt0 v4, v3, v2, v1 vm ; encoding: [0x0f,0x10,0x00,0xf8,0x04,0x03,0x02,0x01]
// GFX89: exp mrt0 v4, v3, v2, v1 vm ; encoding: [0x0f,0x10,0x00,0xc4,0x04,0x03,0x02,0x01]
// GFX10: exp mrt0 v4, v3, v2, v1 vm ; encoding: [0x0f,0x10,0x00,0xf8,0x04,0x03,0x02,0x01]

exp mrt0 v4, v3, v2, v1 done vm
// SI: exp mrt0 v4, v3, v2, v1 done vm ; encoding: [0x0f,0x18,0x00,0xf8,0x04,0x03,0x02,0x01]
// GFX89: exp mrt0 v4, v3, v2, v1 done vm ; encoding: [0x0f,0x18,0x00,0xc4,0x04,0x03,0x02,0x01]
// GFX10: exp mrt0 v4, v3, v2, v1 done vm ; encoding: [0x0f,0x18,0x00,0xf8,0x04,0x03,0x02,0x01]

exp mrtz, v3, v3, v7, v7 compr
// SI: exp mrtz v3, v3, v7, v7 compr   ; encoding: [0x8f,0x04,0x00,0xf8,0x03,0x07,0x00,0x00]
// GFX89: exp mrtz v3, v3, v7, v7 compr   ; encoding: [0x8f,0x04,0x00,0xc4,0x03,0x07,0x00,0x00]
// GFX10: exp mrtz v3, v3, v7, v7 compr ; encoding: [0x8f,0x04,0x00,0xf8,0x03,0x07,0x00,0x00]

exp mrtz, off, off, v7, v7 compr
// SI: exp mrtz off, off, v7, v7 compr ; encoding: [0x8c,0x04,0x00,0xf8,0x00,0x07,0x00,0x00]
// GFX89: exp mrtz off, off, v7, v7 compr ; encoding: [0x8c,0x04,0x00,0xc4,0x00,0x07,0x00,0x00]
// GFX10: exp mrtz off, off, v7, v7 compr ; encoding: [0x8c,0x04,0x00,0xf8,0x00,0x07,0x00,0x00]

exp mrtz, v3, v3, off, off compr
// SI: exp mrtz v3, v3, off, off compr ; encoding: [0x83,0x04,0x00,0xf8,0x03,0x00,0x00,0x00]
// GFX89: exp mrtz v3, v3, off, off compr ; encoding: [0x83,0x04,0x00,0xc4,0x03,0x00,0x00,0x00]
// GFX10: exp mrtz v3, v3, off, off compr ; encoding: [0x83,0x04,0x00,0xf8,0x03,0x00,0x00,0x00]
