;r18 - POS - FQD Position (Current)
;r19 - FQD POS
;r9 -  FQDActual
;r22 - DC Hex value from inputted decimal value
;r6 -  RPM hex value

RAM         equ     $003fa200       ;Start of SRAM
STACK       equ     $003fffff       ;End of SRAM on MPC555
FQD0        equ     $3041C0         ;FQD 0
FQD1        equ     $3041D0         ;FQD 1
PSTN        equ     $8000           ;FQD init position

$INCLUDE "includes/mpc555regs.inc"
$INCLUDE "includes/mpc555setup.inc"

        org     RAM

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


START   ;ldreg   r4,SYPCR
        ;ldreg   r3,sypcr_val
        ;stw     r3,0(r4)
        ldreg   r1,STACK
        bl      INITFQD
        ldreg   r2,FQD0
MAIN    lhz     r11,2(r2)
        b       MAIN



***************INITFQD - Init FQD

INITFQD bsf

        ldreg   r2,CPR0_A         ;turn off FQD
        lhz     r0,0(r2)
        andi.   r0,r0,$F0FF
        sth     r0,0(r2)        	;disable FQD0 & 1

        bl      FQDOFF
        ldreg   r2,CFSR0_A
        ldreg   r0,$0066        	;set 6 into ch 13,12
        sth     r0,0(r2)

        ldreg   r2,FQD0           ;Channel 12
        ldreg   r0,PSTN          ;Position = $8000
        sth     r0,2(r2)
        ldreg   r0,$00D6          ;CORR_PINSTATE_ADDR = $D6
        sth     r0,8(r2)
        ldreg   r0,$00C1          ;EDGE_TIME_LSB_ADDR = $C1
        sth     r0,$A(r2)

        ldreg   r2,FQD1           ;Channel 13
        ldreg   r0,$00C6          ;CORR_PINSTATE_ADDR = $C6
        sth     r0,8(r2)
        ldreg   r0,$00C1          ;EDGE_TIME_LSB_ADDR = $C1
        sth     r0,$A(r2)

        ldreg   r2,HSQR0_A
        ldreg   r0,$0400          ;Ch12 is Primary 0E00
        sth     r0,0(r2)          ;Ch13 is secondary

        ldreg   r2,HSRR0_A
        lhz     r0,0(r2)
        ori     r0,r0,$0F00       ;set Ch12,13 init FQD
        sth     r0,0(r2)

        ldreg   r2,CPR0_A         ;turn on FQD
        lhz     r0,0(r2)
        ori     r0,r0,$0F00     	;high priority
        sth     r0,0(r2)        	;enable FQD0 & 1

        csf
        blr
        
       
***************CALCRPM - Reads the FQD Value and Calculates RPM
;       r6 - current position
;       r7 - calculated RPM

RPM     bsf
        ldreg  r0,PSTN
        sub    r7,r6,r0        ;r7 = (current - 8000)
        cmpi   r7,0t           ;if result is negative, reverse operands
        bgt    0,RPM1
        subf   r7,r6,r0        ;r7 = (8000 - current)
RPM1    mulli  r7,r7,4t        ;r7 = delta * 4Hz (this is frequency of pit)
        mulli  r7,r7,60t       ;r7 = delta * 4Hz * 60s (yeilding pulses per minute)
        ldreg  r0,19t
        divw   r7,r7,r0        ;div by 19 (1:19 gear ratio)
        ldreg  r0,111t         ;r0 contains a constant X (pulses per revolution)
        divw   r7,r7,r0        ;r7 = (pulses per minute) / X (pulses per revolution) == RPM

;       r8 - mod result
;       r9 - write offset counter
;       r10- zero
;       r11- 16t

        li     r9,2            ;offset init
        ldreg  r0,CMDA         ;point to temp storage
        li     r11,16          ;load a 16 for division
        li     r10,0           ;load zero for store
        stb    r10,r9,r0       ;write cutoff zero
        subi   r9,r9,1         ;decrement offset
RPM2    mod    r8,r7,16t       ;mod 16
        sub.   r7,r7,r8        ;sub mod
        addi   r8,r8,30t       ;make ascii
        stb    r8,r9,r0        ;store mod at offset
        beq    0,RPM3          ;if 0 branch out
        divw   r7,r7,r11       ;div by 16
        subi   r9,r9,1         ;dec offset
        b      RPM2            ;repeat until there is nothing left
RPM3    cmpi   r9,0            ;have all bytes been written to?
        beq    RPM4            ;output if yes
        subic. r9,r9,1         ;dec offset
        li     r8,30t          ; ascii 0
        stb    r8,r9,r0        ;store ascii 0
        bgt    0,RPM3          ;keep filling until offset is 0

RPM4    b OUTPUTRPM            ;push text located at memstore

        csf
        blr



        ***************FQDREAD - Reads value of FQD and reinit - called in ISR
FQDREAD lhz     r6,0(r19)
        ldreg   r0,PSTN
        sth     r0,0(r19)
        blr
