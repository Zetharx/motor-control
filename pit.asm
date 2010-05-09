RAM     equ     $003fa200       ;Start of SRAM
STACK   equ     $003fffff       ;End of SRAM on MPC555
GLOBAL  equ     $003ff000       ;Global Memory - Data

$INCLUDE "mpc555regs.inc"
$INCLUDE "mpc555setup.inc"

$macro  ldreg
        li   %1,0
        oris %1,%1,{%2>16t}
        ori  %1,%1,{%2&$ffff}
$macroend

$macro  bsf
        stwu    r1,-8(r1)       ;;;build a custom ISR stack frame
        mflr    r0
        stw     r0,4(r1)
$macroend

$macro  csf
        lwz     r0,4(r1)
        mtlr    r0
        addi    r1,r1,8
$macroend

        org     RAM
START   ldreg   r4,SYPCR
        ldreg   r3,sypcr_val
        stw     r3,0(r4)
        ldreg   r1,STACK
        ldreg   r8,$306100
        li      r9,$1
        sth     r9,2(r8)
        lhz     r9,0(r8)
        xori    r9,r9,$1
        sth     r9,0(r8)
        bl      PITOFF
        bl      PITINIT
        ;bl      PITON
        li      r18,$0
        ldreg   r21,PISCR
        lhz     r22,4(r21)
MAIN    addi    r18,r18,$1
        lhz     r23,0(r21)
        lhz     r24,8(r21)
        b       MAIN

*****************************************************************
*       turn PIT on                                             *
*****************************************************************

PITON   ldreg   r20,PISCR
        lhz     r0,0(r20)
        ori     r0,r0,$0001     	;start PIT timer
        sth     r0,0(r20)
        blr

*****************************************************************
*       turn PIT off                                            *
*****************************************************************

PITOFF  ldreg   r20,PISCR
        lhz     r0,0(r20)
        andi.   r0,r0,$FFFA     	;stop PIT timer
        sth     r0,0(r20)
        blr

*****************************************************************
*       Initialize PIT                                          *
*****************************************************************

PITINIT ldreg   r20,SCCR
        lhz     r0,0(r20)
        ori     r0,r0,$0100
        sth     r0,0(r20)        	;Set RTDIV to 256 (divide PIT by 256 as opposed to 4)

        ldreg   r20,PISCR
        ldreg   r0,$6F01        	;set count from value
        sth     r0,4(r20)

        ldreg   r0,$0C05            ;enable PIT, IRQ lvl 0
        sth     r0,0(r20)

        ldreg   r20,SIMASK
        ldreg   r0,$0FFF          	;unmask Level 1 int
        sth     r0,0(r20)

        ldreg   r20,PISCR
        lhz     r0,0(r20)
        ori     r0,r0,$0080            ;negate PS
        sth     r0,0(r20)

        mfmsr   r0
        ori     r0,r0,$8002
        mtmsr   r0              	;set EE

        blr


        ldreg   r8,$2FC240       ;PISCR addr
         ldreg   r11,$aaaa        ;7a11----Interrupt every 2 seconds
         sth     r11,4(r8)        ;load PITC

         ldreg   r11,$8005
         sth     r11,0(r8)        ;Enable PTE,PIE,level 0

         ldreg   r8,SIMASK       ;SIMASK
         ldreg   r11,$4000
         sth     r11,0(r8)        ;Enable level 0 interrupt
         ldreg   r8,PISCR         ;Load PISCR again
         lhz     r11,0(r8)
         ori     r11,r11,$0080    ;Change the value for PS bit
         sth     r11,0(r8)        ;Negate PS bit
         mfmsr   r23              ;Load MSR
         ori     r23,r23,$8002    ;Enable EE bit and RI
         mtmsr   r23              ;Change MSR
         blr

ISR     bsf
        lhz     r9,0(r8)
        xori    r9,r9,$1
        sth     r9,0(r8)
        csf
        blr

*****************************************************************
;       ISR code stored at $500                                 *
*****************************************************************

        org     $500
        align_long

PISR    bsf
        bl      ISR
        lhz     r0,0(r20)
        ori     r0,r0,$0080
        sth     r0,0(r20)        ;r20=PISCR -- write 1 to negate PS bit
        csf
        rfi
