# RUN: llvm-mc -triple x86_64 -show-encoding %s | FileCheck %s
# RUN: not llvm-mc -triple i386 -show-encoding %s 2>&1 | FileCheck %s --check-prefix=ERROR

# ERROR-COUNT-20: error:
# ERROR-NOT: error:
# CHECK: {evex}	kmovb	%k1, %k2
# CHECK: encoding: [0x62,0xf1,0x7d,0x08,0x90,0xd1]
         {evex}	kmovb	%k1, %k2
# CHECK: {evex}	kmovw	%k1, %k2
# CHECK: encoding: [0x62,0xf1,0x7c,0x08,0x90,0xd1]
         {evex}	kmovw	%k1, %k2
# CHECK: {evex}	kmovd	%k1, %k2
# CHECK: encoding: [0x62,0xf1,0xfd,0x08,0x90,0xd1]
         {evex}	kmovd	%k1, %k2
# CHECK: {evex}	kmovq	%k1, %k2
# CHECK: encoding: [0x62,0xf1,0xfc,0x08,0x90,0xd1]
         {evex}	kmovq	%k1, %k2

# CHECK-NOT: {evex}

# CHECK: kmovb	%r16d, %k1
# CHECK: encoding: [0x62,0xf9,0x7d,0x08,0x92,0xc8]
         kmovb	%r16d, %k1
# CHECK: kmovw	%r16d, %k1
# CHECK: encoding: [0x62,0xf9,0x7c,0x08,0x92,0xc8]
         kmovw	%r16d, %k1
# CHECK: kmovd	%r16d, %k1
# CHECK: encoding: [0x62,0xf9,0x7f,0x08,0x92,0xc8]
         kmovd	%r16d, %k1
# CHECK: kmovq	%r16, %k1
# CHECK: encoding: [0x62,0xf9,0xff,0x08,0x92,0xc8]
         kmovq	%r16, %k1

# CHECK: kmovb	%k1, %r16d
# CHECK: encoding: [0x62,0xe1,0x7d,0x08,0x93,0xc1]
         kmovb	%k1, %r16d
# CHECK: kmovw	%k1, %r16d
# CHECK: encoding: [0x62,0xe1,0x7c,0x08,0x93,0xc1]
         kmovw	%k1, %r16d
# CHECK: kmovd	%k1, %r16d
# CHECK: encoding: [0x62,0xe1,0x7f,0x08,0x93,0xc1]
         kmovd	%k1, %r16d
# CHECK: kmovq	%k1, %r16
# CHECK: encoding: [0x62,0xe1,0xff,0x08,0x93,0xc1]
         kmovq	%k1, %r16

# CHECK: kmovb	(%r16,%r17), %k1
# CHECK: encoding: [0x62,0xf9,0x79,0x08,0x90,0x0c,0x08]
         kmovb	(%r16,%r17), %k1
# CHECK: kmovw	(%r16,%r17), %k1
# CHECK: encoding: [0x62,0xf9,0x78,0x08,0x90,0x0c,0x08]
         kmovw	(%r16,%r17), %k1
# CHECK: kmovd	(%r16,%r17), %k1
# CHECK: encoding: [0x62,0xf9,0xf9,0x08,0x90,0x0c,0x08]
         kmovd	(%r16,%r17), %k1
# CHECK: kmovq	(%r16,%r17), %k1
# CHECK: encoding: [0x62,0xf9,0xf8,0x08,0x90,0x0c,0x08]
         kmovq	(%r16,%r17), %k1

# CHECK: kmovb	%k1, (%r16,%r17)
# CHECK: encoding: [0x62,0xf9,0x79,0x08,0x91,0x0c,0x08]
         kmovb	%k1, (%r16,%r17)
# CHECK: kmovw	%k1, (%r16,%r17)
# CHECK: encoding: [0x62,0xf9,0x78,0x08,0x91,0x0c,0x08]
         kmovw	%k1, (%r16,%r17)
# CHECK: kmovd	%k1, (%r16,%r17)
# CHECK: encoding: [0x62,0xf9,0xf9,0x08,0x91,0x0c,0x08]
         kmovd	%k1, (%r16,%r17)
# CHECK: kmovq	%k1, (%r16,%r17)
# CHECK: encoding: [0x62,0xf9,0xf8,0x08,0x91,0x0c,0x08]
         kmovq	%k1, (%r16,%r17)