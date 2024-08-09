// RUN: llvm-mc -triple=amdgcn -mcpu=gfx908 -show-encoding %s | FileCheck %s
// RUN: llvm-mc -triple=amdgcn -mcpu=gfx90a -show-encoding %s | FileCheck %s
// RUN: llvm-mc -triple=amdgcn -mcpu=gfx940 -show-encoding %s | FileCheck %s

// CHECK: encoding: [0x01,0x05,0x0a,0x6e]
v_dot2c_f32_f16 v5, v1, v2

// CHECK: encoding: [0x01,0x05,0xfe,0x6f]
v_dot2c_f32_f16 v255, v1, v2

// CHECK: encoding: [0xfa,0x04,0x0a,0x6e,0x01,0xe4,0x00,0x00]
v_dot2c_f32_f16_dpp v5, v1, v2 quad_perm:[0,1,2,3] row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0xfe,0x6f,0x01,0xe4,0x00,0x00]
v_dot2c_f32_f16_dpp v255, v1, v2 quad_perm:[0,1,2,3] row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x6e,0xff,0xe4,0x00,0x00]
v_dot2c_f32_f16_dpp v5, v255, v2 quad_perm:[0,1,2,3] row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0xfe,0x0b,0x6e,0x01,0xe4,0x00,0x00]
v_dot2c_f32_f16_dpp v5, v1, v255 quad_perm:[0,1,2,3] row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x6e,0x01,0x1b,0x00,0x00]
v_dot2c_f32_f16_dpp v5, v1, v2 quad_perm:[3,2,1,0] row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x6e,0x01,0x40,0x01,0x00]
v_dot2c_f32_f16_dpp v5, v1, v2 row_mirror row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x6e,0x01,0x41,0x01,0x00]
v_dot2c_f32_f16_dpp v5, v1, v2 row_half_mirror row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x6e,0x01,0x42,0x01,0x00]
v_dot2c_f32_f16_dpp v5, v1, v2 row_bcast:15 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x6e,0x01,0x43,0x01,0x00]
v_dot2c_f32_f16_dpp v5, v1, v2 row_bcast:31 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x6e,0x01,0x30,0x01,0x00]
v_dot2c_f32_f16_dpp v5, v1, v2 wave_shl:1 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x6e,0x01,0x34,0x01,0x00]
v_dot2c_f32_f16_dpp v5, v1, v2 wave_rol:1 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x6e,0x01,0x38,0x01,0x00]
v_dot2c_f32_f16_dpp v5, v1, v2 wave_shr:1 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x6e,0x01,0x3c,0x01,0x00]
v_dot2c_f32_f16_dpp v5, v1, v2 wave_ror:1 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x6e,0x01,0x01,0x01,0x00]
v_dot2c_f32_f16_dpp v5, v1, v2 row_shl:1 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x6e,0x01,0x0f,0x01,0x00]
v_dot2c_f32_f16_dpp v5, v1, v2 row_shl:15 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x6e,0x01,0x11,0x01,0x00]
v_dot2c_f32_f16_dpp v5, v1, v2 row_shr:1 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x6e,0x01,0x1f,0x01,0x00]
v_dot2c_f32_f16_dpp v5, v1, v2 row_shr:15 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x6e,0x01,0x21,0x01,0x00]
v_dot2c_f32_f16_dpp v5, v1, v2 row_ror:1 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x6e,0x01,0x2f,0x01,0x00]
v_dot2c_f32_f16_dpp v5, v1, v2 row_ror:15 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x6e,0x01,0xe4,0x00,0x10]
v_dot2c_f32_f16_dpp v5, v1, v2 quad_perm:[0,1,2,3] row_mask:0x1 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x6e,0x01,0xe4,0x00,0x30]
v_dot2c_f32_f16_dpp v5, v1, v2 quad_perm:[0,1,2,3] row_mask:0x3 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x6e,0x01,0xe4,0x00,0xf0]
v_dot2c_f32_f16_dpp v5, v1, v2 quad_perm:[0,1,2,3] row_mask:0xf bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x6e,0x01,0xe4,0x00,0xf0]
v_dot2c_f32_f16_dpp v5, v1, v2 quad_perm:[0,1,2,3] bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x6e,0x01,0xe4,0x00,0x01]
v_dot2c_f32_f16_dpp v5, v1, v2 quad_perm:[0,1,2,3] row_mask:0x0 bank_mask:0x1

// CHECK: encoding: [0xfa,0x04,0x0a,0x6e,0x01,0xe4,0x00,0x03]
v_dot2c_f32_f16_dpp v5, v1, v2 quad_perm:[0,1,2,3] row_mask:0x0 bank_mask:0x3

// CHECK: encoding: [0xfa,0x04,0x0a,0x6e,0x01,0xe4,0x00,0x0f]
v_dot2c_f32_f16_dpp v5, v1, v2 quad_perm:[0,1,2,3] row_mask:0x0 bank_mask:0xf

// CHECK: encoding: [0xfa,0x04,0x0a,0x6e,0x01,0xe4,0x00,0x0f]
v_dot2c_f32_f16_dpp v5, v1, v2 quad_perm:[0,1,2,3] row_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x6e,0x01,0xe4,0x08,0x00]
v_dot2c_f32_f16_dpp v5, v1, v2 quad_perm:[0,1,2,3] row_mask:0x0 bank_mask:0x0 bound_ctrl:0

// CHECK: encoding: [0xfa,0x04,0x0a,0x6e,0x01,0xe4,0x10,0x00]
v_dot2c_f32_f16_dpp v5, -v1, v2 quad_perm:[0,1,2,3] row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x6e,0x01,0xe4,0x20,0x00]
v_dot2c_f32_f16_dpp v5, |v1|, v2 quad_perm:[0,1,2,3] row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x6e,0x01,0xe4,0x40,0x00]
v_dot2c_f32_f16_dpp v5, v1, -v2 quad_perm:[0,1,2,3] row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x6e,0x01,0xe4,0x80,0x00]
v_dot2c_f32_f16_dpp v5, v1, |v2| quad_perm:[0,1,2,3] row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0x05,0x00,0x37,0xd1,0x01,0xfb,0x01,0x00]
v_dot2c_f32_f16_e64 v5, v1, src_scc

// CHECK: encoding: [0x05,0x00,0x37,0xd1,0xff,0xf9,0x01,0x00]
v_dot2c_f32_f16_e64 v5, v255, src_execz

// CHECK: encoding: [0x05,0x00,0x37,0xd1,0x65,0xca,0x00,0x00]
v_dot2c_f32_f16_e64 v5, s101, s101

// CHECK: encoding: [0x05,0x00,0x37,0xd1,0xc1,0xcc,0x00,0x00]
v_dot2c_f32_f16_e64 v5, -1, flat_scratch_lo

// CHECK: encoding: [0x05,0x02,0x37,0xd1,0xf0,0xce,0x00,0x40]
v_dot2c_f32_f16_e64 v5, 0.5, -|flat_scratch_hi|

// CHECK: encoding: [0x05,0x00,0x37,0xd1,0xfc,0xe0,0x01,0x10]
v_dot2c_f32_f16_e64 v5, src_execz, 0.5 mul:4

// CHECK: encoding: [0xff,0x81,0x37,0xd1,0xfd,0x82,0x01,0x38]
v_dot2c_f32_f16_e64 v255, -|src_scc|, -1 clamp div:2

// CHECK: encoding: [0x01,0x05,0x0a,0x70]
v_dot2c_i32_i16 v5, v1, v2

// CHECK: encoding: [0x01,0x05,0xfe,0x71]
v_dot2c_i32_i16 v255, v1, v2

// CHECK: encoding: [0xfa,0x04,0x0a,0x70,0x01,0xe4,0x00,0x00]
v_dot2c_i32_i16_dpp v5, v1, v2 quad_perm:[0,1,2,3] row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0xfe,0x71,0x01,0xe4,0x00,0x00]
v_dot2c_i32_i16_dpp v255, v1, v2 quad_perm:[0,1,2,3] row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x70,0xff,0xe4,0x00,0x00]
v_dot2c_i32_i16_dpp v5, v255, v2 quad_perm:[0,1,2,3] row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0xfe,0x0b,0x70,0x01,0xe4,0x00,0x00]
v_dot2c_i32_i16_dpp v5, v1, v255 quad_perm:[0,1,2,3] row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x70,0x01,0x1b,0x00,0x00]
v_dot2c_i32_i16_dpp v5, v1, v2 quad_perm:[3,2,1,0] row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x70,0x01,0x40,0x01,0x00]
v_dot2c_i32_i16_dpp v5, v1, v2 row_mirror row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x70,0x01,0x41,0x01,0x00]
v_dot2c_i32_i16_dpp v5, v1, v2 row_half_mirror row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x70,0x01,0x42,0x01,0x00]
v_dot2c_i32_i16_dpp v5, v1, v2 row_bcast:15 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x70,0x01,0x43,0x01,0x00]
v_dot2c_i32_i16_dpp v5, v1, v2 row_bcast:31 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x70,0x01,0x30,0x01,0x00]
v_dot2c_i32_i16_dpp v5, v1, v2 wave_shl:1 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x70,0x01,0x34,0x01,0x00]
v_dot2c_i32_i16_dpp v5, v1, v2 wave_rol:1 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x70,0x01,0x38,0x01,0x00]
v_dot2c_i32_i16_dpp v5, v1, v2 wave_shr:1 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x70,0x01,0x3c,0x01,0x00]
v_dot2c_i32_i16_dpp v5, v1, v2 wave_ror:1 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x70,0x01,0x01,0x01,0x00]
v_dot2c_i32_i16_dpp v5, v1, v2 row_shl:1 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x70,0x01,0x0f,0x01,0x00]
v_dot2c_i32_i16_dpp v5, v1, v2 row_shl:15 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x70,0x01,0x11,0x01,0x00]
v_dot2c_i32_i16_dpp v5, v1, v2 row_shr:1 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x70,0x01,0x1f,0x01,0x00]
v_dot2c_i32_i16_dpp v5, v1, v2 row_shr:15 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x70,0x01,0x21,0x01,0x00]
v_dot2c_i32_i16_dpp v5, v1, v2 row_ror:1 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x70,0x01,0x2f,0x01,0x00]
v_dot2c_i32_i16_dpp v5, v1, v2 row_ror:15 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x70,0x01,0xe4,0x00,0x10]
v_dot2c_i32_i16_dpp v5, v1, v2 quad_perm:[0,1,2,3] row_mask:0x1 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x70,0x01,0xe4,0x00,0x30]
v_dot2c_i32_i16_dpp v5, v1, v2 quad_perm:[0,1,2,3] row_mask:0x3 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x70,0x01,0xe4,0x00,0xf0]
v_dot2c_i32_i16_dpp v5, v1, v2 quad_perm:[0,1,2,3] row_mask:0xf bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x70,0x01,0xe4,0x00,0xf0]
v_dot2c_i32_i16_dpp v5, v1, v2 quad_perm:[0,1,2,3] bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x70,0x01,0xe4,0x00,0x01]
v_dot2c_i32_i16_dpp v5, v1, v2 quad_perm:[0,1,2,3] row_mask:0x0 bank_mask:0x1

// CHECK: encoding: [0xfa,0x04,0x0a,0x70,0x01,0xe4,0x00,0x03]
v_dot2c_i32_i16_dpp v5, v1, v2 quad_perm:[0,1,2,3] row_mask:0x0 bank_mask:0x3

// CHECK: encoding: [0xfa,0x04,0x0a,0x70,0x01,0xe4,0x00,0x0f]
v_dot2c_i32_i16_dpp v5, v1, v2 quad_perm:[0,1,2,3] row_mask:0x0 bank_mask:0xf

// CHECK: encoding: [0xfa,0x04,0x0a,0x70,0x01,0xe4,0x00,0x0f]
v_dot2c_i32_i16_dpp v5, v1, v2 quad_perm:[0,1,2,3] row_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x70,0x01,0xe4,0x08,0x00]
v_dot2c_i32_i16_dpp v5, v1, v2 quad_perm:[0,1,2,3] row_mask:0x0 bank_mask:0x0 bound_ctrl:0

// CHECK: encoding: [0x05,0x00,0x38,0xd1,0x01,0xfb,0x01,0x00]
v_dot2c_i32_i16_e64 v5, v1, src_scc

// CHECK: encoding: [0x05,0x00,0x38,0xd1,0xff,0xf9,0x01,0x00]
v_dot2c_i32_i16_e64 v5, v255, src_execz

// CHECK: encoding: [0x05,0x00,0x38,0xd1,0x65,0xca,0x00,0x00]
v_dot2c_i32_i16_e64 v5, s101, s101

// CHECK: encoding: [0x05,0x00,0x38,0xd1,0xc1,0xcc,0x00,0x00]
v_dot2c_i32_i16_e64 v5, -1, flat_scratch_lo

// CHECK: encoding: [0x05,0x00,0x38,0xd1,0xf0,0xce,0x00,0x00]
v_dot2c_i32_i16_e64 v5, 0.5, flat_scratch_hi

// CHECK: encoding: [0x05,0x00,0x38,0xd1,0xfc,0xe0,0x01,0x00]
v_dot2c_i32_i16_e64 v5, src_execz, 0.5

// CHECK: encoding: [0xff,0x80,0x38,0xd1,0xfd,0x82,0x01,0x00]
v_dot2c_i32_i16_e64 v255, src_scc, -1 clamp

// CHECK: encoding: [0x01,0x05,0x0a,0x72]
v_dot4c_i32_i8 v5, v1, v2

// CHECK: encoding: [0x01,0x05,0xfe,0x73]
v_dot4c_i32_i8 v255, v1, v2

// CHECK: encoding: [0xfa,0x04,0x0a,0x72,0x01,0xe4,0x00,0x00]
v_dot4c_i32_i8_dpp v5, v1, v2 quad_perm:[0,1,2,3] row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0xfe,0x73,0x01,0xe4,0x00,0x00]
v_dot4c_i32_i8_dpp v255, v1, v2 quad_perm:[0,1,2,3] row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x72,0xff,0xe4,0x00,0x00]
v_dot4c_i32_i8_dpp v5, v255, v2 quad_perm:[0,1,2,3] row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0xfe,0x0b,0x72,0x01,0xe4,0x00,0x00]
v_dot4c_i32_i8_dpp v5, v1, v255 quad_perm:[0,1,2,3] row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x72,0x01,0x1b,0x00,0x00]
v_dot4c_i32_i8_dpp v5, v1, v2 quad_perm:[3,2,1,0] row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x72,0x01,0x40,0x01,0x00]
v_dot4c_i32_i8_dpp v5, v1, v2 row_mirror row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x72,0x01,0x41,0x01,0x00]
v_dot4c_i32_i8_dpp v5, v1, v2 row_half_mirror row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x72,0x01,0x42,0x01,0x00]
v_dot4c_i32_i8_dpp v5, v1, v2 row_bcast:15 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x72,0x01,0x43,0x01,0x00]
v_dot4c_i32_i8_dpp v5, v1, v2 row_bcast:31 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x72,0x01,0x30,0x01,0x00]
v_dot4c_i32_i8_dpp v5, v1, v2 wave_shl:1 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x72,0x01,0x34,0x01,0x00]
v_dot4c_i32_i8_dpp v5, v1, v2 wave_rol:1 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x72,0x01,0x38,0x01,0x00]
v_dot4c_i32_i8_dpp v5, v1, v2 wave_shr:1 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x72,0x01,0x3c,0x01,0x00]
v_dot4c_i32_i8_dpp v5, v1, v2 wave_ror:1 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x72,0x01,0x01,0x01,0x00]
v_dot4c_i32_i8_dpp v5, v1, v2 row_shl:1 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x72,0x01,0x0f,0x01,0x00]
v_dot4c_i32_i8_dpp v5, v1, v2 row_shl:15 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x72,0x01,0x11,0x01,0x00]
v_dot4c_i32_i8_dpp v5, v1, v2 row_shr:1 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x72,0x01,0x1f,0x01,0x00]
v_dot4c_i32_i8_dpp v5, v1, v2 row_shr:15 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x72,0x01,0x21,0x01,0x00]
v_dot4c_i32_i8_dpp v5, v1, v2 row_ror:1 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x72,0x01,0x2f,0x01,0x00]
v_dot4c_i32_i8_dpp v5, v1, v2 row_ror:15 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x72,0x01,0xe4,0x00,0x10]
v_dot4c_i32_i8_dpp v5, v1, v2 quad_perm:[0,1,2,3] row_mask:0x1 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x72,0x01,0xe4,0x00,0x30]
v_dot4c_i32_i8_dpp v5, v1, v2 quad_perm:[0,1,2,3] row_mask:0x3 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x72,0x01,0xe4,0x00,0xf0]
v_dot4c_i32_i8_dpp v5, v1, v2 quad_perm:[0,1,2,3] row_mask:0xf bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x72,0x01,0xe4,0x00,0xf0]
v_dot4c_i32_i8_dpp v5, v1, v2 quad_perm:[0,1,2,3] bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x72,0x01,0xe4,0x00,0x01]
v_dot4c_i32_i8_dpp v5, v1, v2 quad_perm:[0,1,2,3] row_mask:0x0 bank_mask:0x1

// CHECK: encoding: [0xfa,0x04,0x0a,0x72,0x01,0xe4,0x00,0x03]
v_dot4c_i32_i8_dpp v5, v1, v2 quad_perm:[0,1,2,3] row_mask:0x0 bank_mask:0x3

// CHECK: encoding: [0xfa,0x04,0x0a,0x72,0x01,0xe4,0x00,0x0f]
v_dot4c_i32_i8_dpp v5, v1, v2 quad_perm:[0,1,2,3] row_mask:0x0 bank_mask:0xf

// CHECK: encoding: [0xfa,0x04,0x0a,0x72,0x01,0xe4,0x00,0x0f]
v_dot4c_i32_i8_dpp v5, v1, v2 quad_perm:[0,1,2,3] row_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x72,0x01,0xe4,0x08,0x00]
v_dot4c_i32_i8_dpp v5, v1, v2 quad_perm:[0,1,2,3] row_mask:0x0 bank_mask:0x0 bound_ctrl:0

// CHECK: encoding: [0x05,0x00,0x39,0xd1,0x01,0xfb,0x01,0x00]
v_dot4c_i32_i8_e64 v5, v1, src_scc

// CHECK: encoding: [0x05,0x00,0x39,0xd1,0xff,0xf9,0x01,0x00]
v_dot4c_i32_i8_e64 v5, v255, src_execz

// CHECK: encoding: [0x05,0x00,0x39,0xd1,0x65,0xca,0x00,0x00]
v_dot4c_i32_i8_e64 v5, s101, s101

// CHECK: encoding: [0x05,0x00,0x39,0xd1,0xc1,0xcc,0x00,0x00]
v_dot4c_i32_i8_e64 v5, -1, flat_scratch_lo

// CHECK: encoding: [0x05,0x00,0x39,0xd1,0xf0,0xce,0x00,0x00]
v_dot4c_i32_i8_e64 v5, 0.5, flat_scratch_hi

// CHECK: encoding: [0x05,0x00,0x39,0xd1,0xfc,0xe0,0x01,0x00]
v_dot4c_i32_i8_e64 v5, src_execz, 0.5

// CHECK: encoding: [0xff,0x80,0x39,0xd1,0xfd,0x82,0x01,0x00]
v_dot4c_i32_i8_e64 v255, src_scc, -1 clamp

// CHECK: encoding: [0x01,0x05,0x0a,0x74]
v_dot8c_i32_i4 v5, v1, v2

// CHECK: encoding: [0x01,0x05,0xfe,0x75]
v_dot8c_i32_i4 v255, v1, v2

// CHECK: encoding: [0xfa,0x04,0x0a,0x74,0x01,0xe4,0x00,0x00]
v_dot8c_i32_i4_dpp v5, v1, v2 quad_perm:[0,1,2,3] row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0xfe,0x75,0x01,0xe4,0x00,0x00]
v_dot8c_i32_i4_dpp v255, v1, v2 quad_perm:[0,1,2,3] row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x74,0xff,0xe4,0x00,0x00]
v_dot8c_i32_i4_dpp v5, v255, v2 quad_perm:[0,1,2,3] row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0xfe,0x0b,0x74,0x01,0xe4,0x00,0x00]
v_dot8c_i32_i4_dpp v5, v1, v255 quad_perm:[0,1,2,3] row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x74,0x01,0x1b,0x00,0x00]
v_dot8c_i32_i4_dpp v5, v1, v2 quad_perm:[3,2,1,0] row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x74,0x01,0x40,0x01,0x00]
v_dot8c_i32_i4_dpp v5, v1, v2 row_mirror row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x74,0x01,0x41,0x01,0x00]
v_dot8c_i32_i4_dpp v5, v1, v2 row_half_mirror row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x74,0x01,0x42,0x01,0x00]
v_dot8c_i32_i4_dpp v5, v1, v2 row_bcast:15 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x74,0x01,0x43,0x01,0x00]
v_dot8c_i32_i4_dpp v5, v1, v2 row_bcast:31 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x74,0x01,0x30,0x01,0x00]
v_dot8c_i32_i4_dpp v5, v1, v2 wave_shl:1 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x74,0x01,0x34,0x01,0x00]
v_dot8c_i32_i4_dpp v5, v1, v2 wave_rol:1 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x74,0x01,0x38,0x01,0x00]
v_dot8c_i32_i4_dpp v5, v1, v2 wave_shr:1 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x74,0x01,0x3c,0x01,0x00]
v_dot8c_i32_i4_dpp v5, v1, v2 wave_ror:1 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x74,0x01,0x01,0x01,0x00]
v_dot8c_i32_i4_dpp v5, v1, v2 row_shl:1 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x74,0x01,0x0f,0x01,0x00]
v_dot8c_i32_i4_dpp v5, v1, v2 row_shl:15 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x74,0x01,0x11,0x01,0x00]
v_dot8c_i32_i4_dpp v5, v1, v2 row_shr:1 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x74,0x01,0x1f,0x01,0x00]
v_dot8c_i32_i4_dpp v5, v1, v2 row_shr:15 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x74,0x01,0x21,0x01,0x00]
v_dot8c_i32_i4_dpp v5, v1, v2 row_ror:1 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x74,0x01,0x2f,0x01,0x00]
v_dot8c_i32_i4_dpp v5, v1, v2 row_ror:15 row_mask:0x0 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x74,0x01,0xe4,0x00,0x10]
v_dot8c_i32_i4_dpp v5, v1, v2 quad_perm:[0,1,2,3] row_mask:0x1 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x74,0x01,0xe4,0x00,0x30]
v_dot8c_i32_i4_dpp v5, v1, v2 quad_perm:[0,1,2,3] row_mask:0x3 bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x74,0x01,0xe4,0x00,0xf0]
v_dot8c_i32_i4_dpp v5, v1, v2 quad_perm:[0,1,2,3] row_mask:0xf bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x74,0x01,0xe4,0x00,0xf0]
v_dot8c_i32_i4_dpp v5, v1, v2 quad_perm:[0,1,2,3] bank_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x74,0x01,0xe4,0x00,0x01]
v_dot8c_i32_i4_dpp v5, v1, v2 quad_perm:[0,1,2,3] row_mask:0x0 bank_mask:0x1

// CHECK: encoding: [0xfa,0x04,0x0a,0x74,0x01,0xe4,0x00,0x03]
v_dot8c_i32_i4_dpp v5, v1, v2 quad_perm:[0,1,2,3] row_mask:0x0 bank_mask:0x3

// CHECK: encoding: [0xfa,0x04,0x0a,0x74,0x01,0xe4,0x00,0x0f]
v_dot8c_i32_i4_dpp v5, v1, v2 quad_perm:[0,1,2,3] row_mask:0x0 bank_mask:0xf

// CHECK: encoding: [0xfa,0x04,0x0a,0x74,0x01,0xe4,0x00,0x0f]
v_dot8c_i32_i4_dpp v5, v1, v2 quad_perm:[0,1,2,3] row_mask:0x0

// CHECK: encoding: [0xfa,0x04,0x0a,0x74,0x01,0xe4,0x08,0x00]
v_dot8c_i32_i4_dpp v5, v1, v2 quad_perm:[0,1,2,3] row_mask:0x0 bank_mask:0x0 bound_ctrl:0

// CHECK: encoding: [0x05,0x00,0x3a,0xd1,0x01,0xfb,0x01,0x00]
v_dot8c_i32_i4_e64 v5, v1, src_scc

// CHECK: encoding: [0x05,0x00,0x3a,0xd1,0xff,0xf9,0x01,0x00]
v_dot8c_i32_i4_e64 v5, v255, src_execz

// CHECK: encoding: [0x05,0x00,0x3a,0xd1,0x65,0xca,0x00,0x00]
v_dot8c_i32_i4_e64 v5, s101, s101

// CHECK: encoding: [0x05,0x00,0x3a,0xd1,0xc1,0xcc,0x00,0x00]
v_dot8c_i32_i4_e64 v5, -1, flat_scratch_lo

// CHECK: encoding: [0x05,0x00,0x3a,0xd1,0xf0,0xce,0x00,0x00]
v_dot8c_i32_i4_e64 v5, 0.5, flat_scratch_hi

// CHECK: encoding: [0x05,0x00,0x3a,0xd1,0xfc,0xe0,0x01,0x00]
v_dot8c_i32_i4_e64 v5, src_execz, 0.5

// CHECK: encoding: [0xff,0x80,0x3a,0xd1,0xfd,0x82,0x01,0x00]
v_dot8c_i32_i4_e64 v255, src_scc, -1 clamp

// CHECK: encoding: [0x01,0x05,0x0a,0x78]
v_pk_fmac_f16 v5, v1, v2

// CHECK: encoding: [0x01,0x05,0xfe,0x79]
v_pk_fmac_f16 v255, v1, v2

// CHECK: encoding: [0xff,0x05,0x0a,0x78]
v_pk_fmac_f16 v5, v255, v2

// CHECK: encoding: [0x01,0x04,0x0a,0x78]
v_pk_fmac_f16 v5, s1, v2

// CHECK: encoding: [0x6a,0x04,0x0a,0x78]
v_pk_fmac_f16 v5, vcc_lo, v2

// CHECK: encoding: [0x6b,0x04,0x0a,0x78]
v_pk_fmac_f16 v5, vcc_hi, v2

// CHECK: encoding: [0x77,0x04,0x0a,0x78]
v_pk_fmac_f16 v5, ttmp11, v2

// CHECK: encoding: [0x7c,0x04,0x0a,0x78]
v_pk_fmac_f16 v5, m0, v2

// CHECK: encoding: [0x7e,0x04,0x0a,0x78]
v_pk_fmac_f16 v5, exec_lo, v2

// CHECK: encoding: [0x7f,0x04,0x0a,0x78]
v_pk_fmac_f16 v5, exec_hi, v2

// CHECK: encoding: [0x80,0x04,0x0a,0x78]
v_pk_fmac_f16 v5, 0, v2

// CHECK: encoding: [0xc1,0x04,0x0a,0x78]
v_pk_fmac_f16 v5, -1, v2

// CHECK: encoding: [0xf0,0x04,0x0a,0x78]
v_pk_fmac_f16 v5, 0.5, v2

// CHECK: encoding: [0xf7,0x04,0x0a,0x78]
v_pk_fmac_f16 v5, -4.0, v2

// CHECK: encoding: [0x01,0xff,0x0b,0x78]
v_pk_fmac_f16 v5, v1, v255