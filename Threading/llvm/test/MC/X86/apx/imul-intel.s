# RUN: llvm-mc -triple x86_64 -show-encoding -x86-asm-syntax=intel -output-asm-variant=1 %s | FileCheck %s

# CHECK: {evex}	imul	dx, dx, 123
# CHECK: encoding: [0x62,0xf4,0x7d,0x08,0x6b,0xd2,0x7b]
         {evex}	imul	dx, dx, 123
# CHECK: {nf}	imul	dx, dx, 123
# CHECK: encoding: [0x62,0xf4,0x7d,0x0c,0x6b,0xd2,0x7b]
         {nf}	imul	dx, dx, 123
# CHECK: {evex}	imul	ecx, ecx, 123
# CHECK: encoding: [0x62,0xf4,0x7c,0x08,0x6b,0xc9,0x7b]
         {evex}	imul	ecx, ecx, 123
# CHECK: {nf}	imul	ecx, ecx, 123
# CHECK: encoding: [0x62,0xf4,0x7c,0x0c,0x6b,0xc9,0x7b]
         {nf}	imul	ecx, ecx, 123
# CHECK: {evex}	imul	r9, r9, 123
# CHECK: encoding: [0x62,0x54,0xfc,0x08,0x6b,0xc9,0x7b]
         {evex}	imul	r9, r9, 123
# CHECK: {nf}	imul	r9, r9, 123
# CHECK: encoding: [0x62,0x54,0xfc,0x0c,0x6b,0xc9,0x7b]
         {nf}	imul	r9, r9, 123
# CHECK: {evex}	imul	dx, word ptr [r8 + 4*rax + 291], 123
# CHECK: encoding: [0x62,0xd4,0x7d,0x08,0x6b,0x94,0x80,0x23,0x01,0x00,0x00,0x7b]
         {evex}	imul	dx, word ptr [r8 + 4*rax + 291], 123
# CHECK: {nf}	imul	dx, word ptr [r8 + 4*rax + 291], 123
# CHECK: encoding: [0x62,0xd4,0x7d,0x0c,0x6b,0x94,0x80,0x23,0x01,0x00,0x00,0x7b]
         {nf}	imul	dx, word ptr [r8 + 4*rax + 291], 123
# CHECK: {evex}	imul	ecx, dword ptr [r8 + 4*rax + 291], 123
# CHECK: encoding: [0x62,0xd4,0x7c,0x08,0x6b,0x8c,0x80,0x23,0x01,0x00,0x00,0x7b]
         {evex}	imul	ecx, dword ptr [r8 + 4*rax + 291], 123
# CHECK: {nf}	imul	ecx, dword ptr [r8 + 4*rax + 291], 123
# CHECK: encoding: [0x62,0xd4,0x7c,0x0c,0x6b,0x8c,0x80,0x23,0x01,0x00,0x00,0x7b]
         {nf}	imul	ecx, dword ptr [r8 + 4*rax + 291], 123
# CHECK: {evex}	imul	r9, qword ptr [r8 + 4*rax + 291], 123
# CHECK: encoding: [0x62,0x54,0xfc,0x08,0x6b,0x8c,0x80,0x23,0x01,0x00,0x00,0x7b]
         {evex}	imul	r9, qword ptr [r8 + 4*rax + 291], 123
# CHECK: {nf}	imul	r9, qword ptr [r8 + 4*rax + 291], 123
# CHECK: encoding: [0x62,0x54,0xfc,0x0c,0x6b,0x8c,0x80,0x23,0x01,0x00,0x00,0x7b]
         {nf}	imul	r9, qword ptr [r8 + 4*rax + 291], 123
# CHECK: {evex}	imul	dx, dx, 1234
# CHECK: encoding: [0x62,0xf4,0x7d,0x08,0x69,0xd2,0xd2,0x04]
         {evex}	imul	dx, dx, 1234
# CHECK: {nf}	imul	dx, dx, 1234
# CHECK: encoding: [0x62,0xf4,0x7d,0x0c,0x69,0xd2,0xd2,0x04]
         {nf}	imul	dx, dx, 1234
# CHECK: {evex}	imul	dx, word ptr [r8 + 4*rax + 291], 1234
# CHECK: encoding: [0x62,0xd4,0x7d,0x08,0x69,0x94,0x80,0x23,0x01,0x00,0x00,0xd2,0x04]
         {evex}	imul	dx, word ptr [r8 + 4*rax + 291], 1234
# CHECK: {nf}	imul	dx, word ptr [r8 + 4*rax + 291], 1234
# CHECK: encoding: [0x62,0xd4,0x7d,0x0c,0x69,0x94,0x80,0x23,0x01,0x00,0x00,0xd2,0x04]
         {nf}	imul	dx, word ptr [r8 + 4*rax + 291], 1234
# CHECK: {evex}	imul	ecx, ecx, 123456
# CHECK: encoding: [0x62,0xf4,0x7c,0x08,0x69,0xc9,0x40,0xe2,0x01,0x00]
         {evex}	imul	ecx, ecx, 123456
# CHECK: {nf}	imul	ecx, ecx, 123456
# CHECK: encoding: [0x62,0xf4,0x7c,0x0c,0x69,0xc9,0x40,0xe2,0x01,0x00]
         {nf}	imul	ecx, ecx, 123456
# CHECK: {evex}	imul	r9, r9, 123456
# CHECK: encoding: [0x62,0x54,0xfc,0x08,0x69,0xc9,0x40,0xe2,0x01,0x00]
         {evex}	imul	r9, r9, 123456
# CHECK: {nf}	imul	r9, r9, 123456
# CHECK: encoding: [0x62,0x54,0xfc,0x0c,0x69,0xc9,0x40,0xe2,0x01,0x00]
         {nf}	imul	r9, r9, 123456
# CHECK: {evex}	imul	ecx, dword ptr [r8 + 4*rax + 291], 123456
# CHECK: encoding: [0x62,0xd4,0x7c,0x08,0x69,0x8c,0x80,0x23,0x01,0x00,0x00,0x40,0xe2,0x01,0x00]
         {evex}	imul	ecx, dword ptr [r8 + 4*rax + 291], 123456
# CHECK: {nf}	imul	ecx, dword ptr [r8 + 4*rax + 291], 123456
# CHECK: encoding: [0x62,0xd4,0x7c,0x0c,0x69,0x8c,0x80,0x23,0x01,0x00,0x00,0x40,0xe2,0x01,0x00]
         {nf}	imul	ecx, dword ptr [r8 + 4*rax + 291], 123456
# CHECK: {evex}	imul	r9, qword ptr [r8 + 4*rax + 291], 123456
# CHECK: encoding: [0x62,0x54,0xfc,0x08,0x69,0x8c,0x80,0x23,0x01,0x00,0x00,0x40,0xe2,0x01,0x00]
         {evex}	imul	r9, qword ptr [r8 + 4*rax + 291], 123456
# CHECK: {nf}	imul	r9, qword ptr [r8 + 4*rax + 291], 123456
# CHECK: encoding: [0x62,0x54,0xfc,0x0c,0x69,0x8c,0x80,0x23,0x01,0x00,0x00,0x40,0xe2,0x01,0x00]
         {nf}	imul	r9, qword ptr [r8 + 4*rax + 291], 123456
# CHECK: {evex}	imul	bl
# CHECK: encoding: [0x62,0xf4,0x7c,0x08,0xf6,0xeb]
         {evex}	imul	bl
# CHECK: {nf}	imul	bl
# CHECK: encoding: [0x62,0xf4,0x7c,0x0c,0xf6,0xeb]
         {nf}	imul	bl
# CHECK: {evex}	imul	dx
# CHECK: encoding: [0x62,0xf4,0x7d,0x08,0xf7,0xea]
         {evex}	imul	dx
# CHECK: {nf}	imul	dx
# CHECK: encoding: [0x62,0xf4,0x7d,0x0c,0xf7,0xea]
         {nf}	imul	dx
# CHECK: {evex}	imul	dx, dx
# CHECK: encoding: [0x62,0xf4,0x7d,0x08,0xaf,0xd2]
         {evex}	imul	dx, dx
# CHECK: {nf}	imul	dx, dx
# CHECK: encoding: [0x62,0xf4,0x7d,0x0c,0xaf,0xd2]
         {nf}	imul	dx, dx
# CHECK: imul	dx, dx, dx
# CHECK: encoding: [0x62,0xf4,0x6d,0x18,0xaf,0xd2]
         imul	dx, dx, dx
# CHECK: {nf}	imul	dx, dx, dx
# CHECK: encoding: [0x62,0xf4,0x6d,0x1c,0xaf,0xd2]
         {nf}	imul	dx, dx, dx
# CHECK: {evex}	imul	ecx
# CHECK: encoding: [0x62,0xf4,0x7c,0x08,0xf7,0xe9]
         {evex}	imul	ecx
# CHECK: {nf}	imul	ecx
# CHECK: encoding: [0x62,0xf4,0x7c,0x0c,0xf7,0xe9]
         {nf}	imul	ecx
# CHECK: {evex}	imul	ecx, ecx
# CHECK: encoding: [0x62,0xf4,0x7c,0x08,0xaf,0xc9]
         {evex}	imul	ecx, ecx
# CHECK: {nf}	imul	ecx, ecx
# CHECK: encoding: [0x62,0xf4,0x7c,0x0c,0xaf,0xc9]
         {nf}	imul	ecx, ecx
# CHECK: imul	ecx, ecx, ecx
# CHECK: encoding: [0x62,0xf4,0x74,0x18,0xaf,0xc9]
         imul	ecx, ecx, ecx
# CHECK: {nf}	imul	ecx, ecx, ecx
# CHECK: encoding: [0x62,0xf4,0x74,0x1c,0xaf,0xc9]
         {nf}	imul	ecx, ecx, ecx
# CHECK: {evex}	imul	r9
# CHECK: encoding: [0x62,0xd4,0xfc,0x08,0xf7,0xe9]
         {evex}	imul	r9
# CHECK: {nf}	imul	r9
# CHECK: encoding: [0x62,0xd4,0xfc,0x0c,0xf7,0xe9]
         {nf}	imul	r9
# CHECK: {evex}	imul	r9, r9
# CHECK: encoding: [0x62,0x54,0xfc,0x08,0xaf,0xc9]
         {evex}	imul	r9, r9
# CHECK: {nf}	imul	r9, r9
# CHECK: encoding: [0x62,0x54,0xfc,0x0c,0xaf,0xc9]
         {nf}	imul	r9, r9
# CHECK: imul	r9, r9, r9
# CHECK: encoding: [0x62,0x54,0xb4,0x18,0xaf,0xc9]
         imul	r9, r9, r9
# CHECK: {nf}	imul	r9, r9, r9
# CHECK: encoding: [0x62,0x54,0xb4,0x1c,0xaf,0xc9]
         {nf}	imul	r9, r9, r9
# CHECK: {evex}	imul	byte ptr [r8 + 4*rax + 291]
# CHECK: encoding: [0x62,0xd4,0x7c,0x08,0xf6,0xac,0x80,0x23,0x01,0x00,0x00]
         {evex}	imul	byte ptr [r8 + 4*rax + 291]
# CHECK: {nf}	imul	byte ptr [r8 + 4*rax + 291]
# CHECK: encoding: [0x62,0xd4,0x7c,0x0c,0xf6,0xac,0x80,0x23,0x01,0x00,0x00]
         {nf}	imul	byte ptr [r8 + 4*rax + 291]
# CHECK: {evex}	imul	word ptr [r8 + 4*rax + 291]
# CHECK: encoding: [0x62,0xd4,0x7d,0x08,0xf7,0xac,0x80,0x23,0x01,0x00,0x00]
         {evex}	imul	word ptr [r8 + 4*rax + 291]
# CHECK: {nf}	imul	word ptr [r8 + 4*rax + 291]
# CHECK: encoding: [0x62,0xd4,0x7d,0x0c,0xf7,0xac,0x80,0x23,0x01,0x00,0x00]
         {nf}	imul	word ptr [r8 + 4*rax + 291]
# CHECK: {evex}	imul	dx, word ptr [r8 + 4*rax + 291]
# CHECK: encoding: [0x62,0xd4,0x7d,0x08,0xaf,0x94,0x80,0x23,0x01,0x00,0x00]
         {evex}	imul	dx, word ptr [r8 + 4*rax + 291]
# CHECK: {nf}	imul	dx, word ptr [r8 + 4*rax + 291]
# CHECK: encoding: [0x62,0xd4,0x7d,0x0c,0xaf,0x94,0x80,0x23,0x01,0x00,0x00]
         {nf}	imul	dx, word ptr [r8 + 4*rax + 291]
# CHECK: imul	dx, dx, word ptr [r8 + 4*rax + 291]
# CHECK: encoding: [0x62,0xd4,0x6d,0x18,0xaf,0x94,0x80,0x23,0x01,0x00,0x00]
         imul	dx, dx, word ptr [r8 + 4*rax + 291]
# CHECK: {nf}	imul	dx, dx, word ptr [r8 + 4*rax + 291]
# CHECK: encoding: [0x62,0xd4,0x6d,0x1c,0xaf,0x94,0x80,0x23,0x01,0x00,0x00]
         {nf}	imul	dx, dx, word ptr [r8 + 4*rax + 291]
# CHECK: {evex}	imul	dword ptr [r8 + 4*rax + 291]
# CHECK: encoding: [0x62,0xd4,0x7c,0x08,0xf7,0xac,0x80,0x23,0x01,0x00,0x00]
         {evex}	imul	dword ptr [r8 + 4*rax + 291]
# CHECK: {nf}	imul	dword ptr [r8 + 4*rax + 291]
# CHECK: encoding: [0x62,0xd4,0x7c,0x0c,0xf7,0xac,0x80,0x23,0x01,0x00,0x00]
         {nf}	imul	dword ptr [r8 + 4*rax + 291]
# CHECK: {evex}	imul	ecx, dword ptr [r8 + 4*rax + 291]
# CHECK: encoding: [0x62,0xd4,0x7c,0x08,0xaf,0x8c,0x80,0x23,0x01,0x00,0x00]
         {evex}	imul	ecx, dword ptr [r8 + 4*rax + 291]
# CHECK: {nf}	imul	ecx, dword ptr [r8 + 4*rax + 291]
# CHECK: encoding: [0x62,0xd4,0x7c,0x0c,0xaf,0x8c,0x80,0x23,0x01,0x00,0x00]
         {nf}	imul	ecx, dword ptr [r8 + 4*rax + 291]
# CHECK: imul	ecx, ecx, dword ptr [r8 + 4*rax + 291]
# CHECK: encoding: [0x62,0xd4,0x74,0x18,0xaf,0x8c,0x80,0x23,0x01,0x00,0x00]
         imul	ecx, ecx, dword ptr [r8 + 4*rax + 291]
# CHECK: {nf}	imul	ecx, ecx, dword ptr [r8 + 4*rax + 291]
# CHECK: encoding: [0x62,0xd4,0x74,0x1c,0xaf,0x8c,0x80,0x23,0x01,0x00,0x00]
         {nf}	imul	ecx, ecx, dword ptr [r8 + 4*rax + 291]
# CHECK: {evex}	imul	qword ptr [r8 + 4*rax + 291]
# CHECK: encoding: [0x62,0xd4,0xfc,0x08,0xf7,0xac,0x80,0x23,0x01,0x00,0x00]
         {evex}	imul	qword ptr [r8 + 4*rax + 291]
# CHECK: {nf}	imul	qword ptr [r8 + 4*rax + 291]
# CHECK: encoding: [0x62,0xd4,0xfc,0x0c,0xf7,0xac,0x80,0x23,0x01,0x00,0x00]
         {nf}	imul	qword ptr [r8 + 4*rax + 291]
# CHECK: {evex}	imul	r9, qword ptr [r8 + 4*rax + 291]
# CHECK: encoding: [0x62,0x54,0xfc,0x08,0xaf,0x8c,0x80,0x23,0x01,0x00,0x00]
         {evex}	imul	r9, qword ptr [r8 + 4*rax + 291]
# CHECK: {nf}	imul	r9, qword ptr [r8 + 4*rax + 291]
# CHECK: encoding: [0x62,0x54,0xfc,0x0c,0xaf,0x8c,0x80,0x23,0x01,0x00,0x00]
         {nf}	imul	r9, qword ptr [r8 + 4*rax + 291]
# CHECK: imul	r9, r9, qword ptr [r8 + 4*rax + 291]
# CHECK: encoding: [0x62,0x54,0xb4,0x18,0xaf,0x8c,0x80,0x23,0x01,0x00,0x00]
         imul	r9, r9, qword ptr [r8 + 4*rax + 291]
# CHECK: {nf}	imul	r9, r9, qword ptr [r8 + 4*rax + 291]
# CHECK: encoding: [0x62,0x54,0xb4,0x1c,0xaf,0x8c,0x80,0x23,0x01,0x00,0x00]
         {nf}	imul	r9, r9, qword ptr [r8 + 4*rax + 291]