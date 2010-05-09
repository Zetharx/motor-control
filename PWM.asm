*
*       MISL Motor Controller
*       Author: Stephen Peck
*
$INCLUDE        "includes/mpc555regs.inc"
$INCLUDE        "includes/mpc555setup.inc"

*
*       Memory Map Setup
*
RAM     equ     $003F9800
STACK   equ     $003FFFFC
FLASH   equ     $00000100

TMR1    equ     5000000t

*
*       Load Register Macro
*
$macro  ldreg
        li      %1,0
        oris    %1,%1,{%2>16t}
        ori     %1,%1,{%2&$FFFF}
$macroend

$macro  bsf
        stwu    r1,-24(r1)
        mflr    r0
        stw     r0,4(r1)
$macroend

$macro  csf
        lwz     r0,4(r1)
        mtlr    r0
        lwzu    r1,0(r1)
$macroend

$macro  CLR
        lhz     r0,0(%1)
        and     r0,r0,%2
        sth     r0,0(%1)
$macroend

$macro  SET
        lhz     r0,0(%1)
        or      r0,r0,%2
        sth     r0,0(%1)
$macroend

        org     RAM
MAIN    bl      INIT
        ldreg   r3,10000t            ;Frequency
        ldreg   r4,50t                ;duty cycle in %
        bl      UPWM
end     b       end

INIT    ldreg   r1,STACK
        bsf
        ldreg   r4,SYPCR        ;store SYPCR address in r4
        ldreg   r3,$FFF0        ;Initial value for SYPCR reg
        stw     r3,0(r4)        ;disable watchdog timer

        bl      ITPU

        ldreg   r4,CPR1_A       ;priority register 1
        li      r3,$FFFC        ;mask for CPR1
        CLR     r4,r3           ;Clear CH0 Priority register in CPR1_A

        ldreg   r3,CFSR3_A      ;Fxn sel reg 3
        li      r4,$FFF3        ;mask for PWM Fxn CH0
        ldreg   r5,$304100      ;PRAM address for CH0
        li      r6,$91          ;channel control mask
        li      r7,$1388        ;freq = 1KHz

        bl      IFXN            ;Initialize PWM to CH0

        ldreg   r4,CPR1_A       ;priority register 1
        li      r3,$0002        ;mask for CPR1
        SET     r4,r3           ;Set CH0 priority register in CPR1_A to $02

        csf
        blr

ITPU    bsf
        ldreg   r4,TPUMCR_A     ;set r4 to TPUMCR_A register
        li      r3,$2020        ;set r3 to TPUMCR config
        sth     r3,0(r4)        ;store config in TPUMCR

        ldreg   r3,$0040        ;Divide clock by 2
        sth     r3,$2A(r4)      ;store config in TPUMCR3

        ldreg   r3,$0500        ;interrupt level to 5
        sth     r3,$8(r4)       ;store config in TICR
        csf
        blr

;       IPWM - Init Channel n to PWM
;       r3 - PWM Fxn select register
;       r4 - PWM FXN Channel Control mask
;       r5 - PWM PRAM memory location CHn
;       r6 - PWM PRAM memory location CHn mask
;       r7 - desired frequency ()
;
IPWM    bsf

        CLR     r3,r4           ;set CHn to desire PWM
        CLR     r5,r6           ;set PWM Channel Control

        addi.   r5,r5,$04       ;PWMHI register/DC
        ldreg   r0,$00          ;set duty cycle register to 0%
        CLR     r5,r0           ;set PWMHI register to r0

        addi.   r5,r5,$02       ;PWMPER register
        CLR     r5,r7           ;set PWMPER to the desired frequency

        csf
        blr

UPWM    bsf
        ldreg   r11,$304100
        ldreg   r12,100t
        ldreg   r0,TMR1
        DIVW    r0,r0,r3
        sth     r0,6(r11)

        MULLW   r0,r0,r4
        DIVW    r0,r0,r12
        sth     r0,4(r11)
        csf
        blr
