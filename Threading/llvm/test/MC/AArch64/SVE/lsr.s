// RUN: llvm-mc -triple=aarch64 -show-encoding -mattr=+sve < %s \
// RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
// RUN: llvm-mc -triple=aarch64 -show-encoding -mattr=+sme < %s \
// RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
// RUN: not llvm-mc -triple=aarch64 -show-encoding < %s 2>&1 \
// RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve < %s \
// RUN:        | llvm-objdump --no-print-imm-hex -d --mattr=+sve - | FileCheck %s --check-prefix=CHECK-INST
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve < %s \
// RUN:   | llvm-objdump --no-print-imm-hex -d --mattr=-sve - | FileCheck %s --check-prefix=CHECK-UNKNOWN

lsr     z0.b, z0.b, #1
// CHECK-INST: lsr	z0.b, z0.b, #1
// CHECK-ENCODING: [0x00,0x94,0x2f,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 042f9400 <unknown>

lsr     z31.b, z31.b, #8
// CHECK-INST: lsr	z31.b, z31.b, #8
// CHECK-ENCODING: [0xff,0x97,0x28,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 042897ff <unknown>

lsr     z0.h, z0.h, #1
// CHECK-INST: lsr	z0.h, z0.h, #1
// CHECK-ENCODING: [0x00,0x94,0x3f,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 043f9400 <unknown>

lsr     z31.h, z31.h, #16
// CHECK-INST: lsr	z31.h, z31.h, #16
// CHECK-ENCODING: [0xff,0x97,0x30,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 043097ff <unknown>

lsr     z0.s, z0.s, #1
// CHECK-INST: lsr	z0.s, z0.s, #1
// CHECK-ENCODING: [0x00,0x94,0x7f,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 047f9400 <unknown>

lsr     z31.s, z31.s, #32
// CHECK-INST: lsr	z31.s, z31.s, #32
// CHECK-ENCODING: [0xff,0x97,0x60,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 046097ff <unknown>

lsr     z0.d, z0.d, #1
// CHECK-INST: lsr	z0.d, z0.d, #1
// CHECK-ENCODING: [0x00,0x94,0xff,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 04ff9400 <unknown>

lsr     z31.d, z31.d, #64
// CHECK-INST: lsr	z31.d, z31.d, #64
// CHECK-ENCODING: [0xff,0x97,0xa0,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 04a097ff <unknown>

lsr     z0.b, p0/m, z0.b, #1
// CHECK-INST: lsr	z0.b, p0/m, z0.b, #1
// CHECK-ENCODING: [0xe0,0x81,0x01,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 040181e0 <unknown>

lsr     z31.b, p0/m, z31.b, #8
// CHECK-INST: lsr	z31.b, p0/m, z31.b, #8
// CHECK-ENCODING: [0x1f,0x81,0x01,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0401811f <unknown>

lsr     z0.h, p0/m, z0.h, #1
// CHECK-INST: lsr	z0.h, p0/m, z0.h, #1
// CHECK-ENCODING: [0xe0,0x83,0x01,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 040183e0 <unknown>

lsr     z31.h, p0/m, z31.h, #16
// CHECK-INST: lsr	z31.h, p0/m, z31.h, #16
// CHECK-ENCODING: [0x1f,0x82,0x01,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0401821f <unknown>

lsr     z0.s, p0/m, z0.s, #1
// CHECK-INST: lsr	z0.s, p0/m, z0.s, #1
// CHECK-ENCODING: [0xe0,0x83,0x41,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 044183e0 <unknown>

lsr     z31.s, p0/m, z31.s, #32
// CHECK-INST: lsr	z31.s, p0/m, z31.s, #32
// CHECK-ENCODING: [0x1f,0x80,0x41,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0441801f <unknown>

lsr     z0.d, p0/m, z0.d, #1
// CHECK-INST: lsr	z0.d, p0/m, z0.d, #1
// CHECK-ENCODING: [0xe0,0x83,0xc1,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 04c183e0 <unknown>

lsr     z31.d, p0/m, z31.d, #64
// CHECK-INST: lsr	z31.d, p0/m, z31.d, #64
// CHECK-ENCODING: [0x1f,0x80,0x81,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0481801f <unknown>

lsr     z0.b, p0/m, z0.b, z0.b
// CHECK-INST: lsr	z0.b, p0/m, z0.b, z0.b
// CHECK-ENCODING: [0x00,0x80,0x11,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 04118000 <unknown>

lsr     z0.h, p0/m, z0.h, z0.h
// CHECK-INST: lsr	z0.h, p0/m, z0.h, z0.h
// CHECK-ENCODING: [0x00,0x80,0x51,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 04518000 <unknown>

lsr     z0.s, p0/m, z0.s, z0.s
// CHECK-INST: lsr	z0.s, p0/m, z0.s, z0.s
// CHECK-ENCODING: [0x00,0x80,0x91,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 04918000 <unknown>

lsr     z0.d, p0/m, z0.d, z0.d
// CHECK-INST: lsr	z0.d, p0/m, z0.d, z0.d
// CHECK-ENCODING: [0x00,0x80,0xd1,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 04d18000 <unknown>

lsr     z0.b, p0/m, z0.b, z1.d
// CHECK-INST: lsr	z0.b, p0/m, z0.b, z1.d
// CHECK-ENCODING: [0x20,0x80,0x19,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 04198020 <unknown>

lsr     z0.h, p0/m, z0.h, z1.d
// CHECK-INST: lsr	z0.h, p0/m, z0.h, z1.d
// CHECK-ENCODING: [0x20,0x80,0x59,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 04598020 <unknown>

lsr     z0.s, p0/m, z0.s, z1.d
// CHECK-INST: lsr	z0.s, p0/m, z0.s, z1.d
// CHECK-ENCODING: [0x20,0x80,0x99,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 04998020 <unknown>

lsr     z0.b, z1.b, z2.d
// CHECK-INST: lsr	z0.b, z1.b, z2.d
// CHECK-ENCODING: [0x20,0x84,0x22,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 04228420 <unknown>

lsr     z0.h, z1.h, z2.d
// CHECK-INST: lsr	z0.h, z1.h, z2.d
// CHECK-ENCODING: [0x20,0x84,0x62,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 04628420 <unknown>

lsr     z0.s, z1.s, z2.d
// CHECK-INST: lsr	z0.s, z1.s, z2.d
// CHECK-ENCODING: [0x20,0x84,0xa2,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 04a28420 <unknown>


// --------------------------------------------------------------------------//
// Test compatibility with MOVPRFX instruction.

movprfx z31.d, p0/z, z6.d
// CHECK-INST: movprfx	z31.d, p0/z, z6.d
// CHECK-ENCODING: [0xdf,0x20,0xd0,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 04d020df <unknown>

lsr     z31.d, p0/m, z31.d, #64
// CHECK-INST: lsr	z31.d, p0/m, z31.d, #64
// CHECK-ENCODING: [0x1f,0x80,0x81,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0481801f <unknown>

movprfx z31, z6
// CHECK-INST: movprfx	z31, z6
// CHECK-ENCODING: [0xdf,0xbc,0x20,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0420bcdf <unknown>

lsr     z31.d, p0/m, z31.d, #64
// CHECK-INST: lsr	z31.d, p0/m, z31.d, #64
// CHECK-ENCODING: [0x1f,0x80,0x81,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0481801f <unknown>

movprfx z0.s, p0/z, z7.s
// CHECK-INST: movprfx	z0.s, p0/z, z7.s
// CHECK-ENCODING: [0xe0,0x20,0x90,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 049020e0 <unknown>

lsr     z0.s, p0/m, z0.s, z1.d
// CHECK-INST: lsr	z0.s, p0/m, z0.s, z1.d
// CHECK-ENCODING: [0x20,0x80,0x99,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 04998020 <unknown>

movprfx z0, z7
// CHECK-INST: movprfx	z0, z7
// CHECK-ENCODING: [0xe0,0xbc,0x20,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0420bce0 <unknown>

lsr     z0.s, p0/m, z0.s, z1.d
// CHECK-INST: lsr	z0.s, p0/m, z0.s, z1.d
// CHECK-ENCODING: [0x20,0x80,0x99,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 04998020 <unknown>
