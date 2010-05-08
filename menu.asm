*
*       MISL Motor Controller
*       Author: Stephen Peck
*
*       r29 - Frequency
*       r30 - Duty Cycle
*       r31 - RPM
*
$INCLUDE        "mpc555regs.inc"
$INCLUDE        "mpc555setup.inc"

DEFFRQ  equ     5000t           ;default frequency is 5kHz
DEFDC   equ     50t             ;default duty cycle is 50%

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
        stwu    r1,-8(r1)
        mflr    r0
        stw     r0,4(r1)
$macroend
$macro  csf
        lwz     r0,4(r1)
        mtlr    r0
        lwzu    r1,0(r1)
$macroend

;       clear register macro
;       %1 - offset from location
;       %2 - location in memory
;       %3 - mask
$macro  clrr
        lhzx    r0,%1,%2
        and     r0,r0,%3
        sthx    r0,%1,%2
$macroend

;       set register macro
;       %1 - offset from location
;       %2 - location in memory
;       %3 - mask
$macro  setr
        lhzx    r0,%1,%2
        or      r0,r0,%3
        sthx    r0,%1,%2
$macroend

        org     RAM
MAIN    bl      INIT
MLOOP1  ldreg   r3,CMDREF
        bl      OSTR
MLOOP2  li      r3,PROMPT
        bl      OCHR
        bl      RDTORET
        bl      PROCCMD
        b       MLOOP2
END     b       END

*       Main Initialization Sub-routine
*
INIT    ldreg   r1,STACK
        bsf
        ldreg   r3,SYPCR
        ldreg   r0,$FFF0
        stw     r0,0(r3)

        li      r29,DEFFRQ
        li      r30,DEFDC
        li      r31,$00

        bl      ISCI
        bl      ITPU
        bl      IPWM0
        csf
        blr

*       Init SCI
*       r0    - temporary reg
*       r8    - address of SCC1R0
*       2(r8) - address of SCC1R1
*
ISCI    bsf
        li      r0,$00
        ldreg   r8,SCC1R0               ;set r8 to SCC1R0
        sth     r0,2(r8)                ;disable SCI
        li      r0,sc1_baud_reg         ;val for baud of 9600
        sth     r0,0(r8)                ;set baud to 9600
        li      r0,$0C                  ;conf for SCI
        sth     r0,2(r8)                ;set TE and RE
        csf
        blr

*       Output a Character
*       r0     - temporary reg
*       r3     - argument
*       r31    - address of SCC1R0
*       2(r31) - address of SCC1R1
*       4(r31) - address of SCSR
*       6(r31) - address of SCDR
*
OCHR    bsf
        ldreg   r4,SCC1R0
OCHL    lhz     r0,4(r4)                ;grab SCSR
        andi.   r0,r0,$0100             ;mask TDR bit
        beq     0,OCHL                  ;can't transmit, loop
        sth     r3,6(r4)                ;push arg into SCDR
        csf
        blr

*       Output a NULL terminated string
*       r0     - temporary reg
*       r3     - argument
*       r4     - address of SCC1R0
*       2(r4)  - address of SCC1R1
*       4(r4)  - address of SCSR
*       6(r4)  - address of SCDR
*
OSTR    bsf
        ldreg   r4,SCC1R0
OSTL    lhz     r0,4(r4)                ;grab SCSR
        andi.   r0,r0,$0100             ;mask TDR bit
        beq     0,OSTL                  ;can't transmit, loop
        lbz     r0,0(r3)                ;get cur character
        sth     r0,6(r4)                ;output next character
        lbzu    r0,1(r3)                ;get next character and update addr
        cmpi    r0,$0                   ;have we reached NULL char
        beq     0,OSTX                  ;yes, exit
        b       OSTL                    ;no, loop
OSTX    csf
        blr

*       Get character input(will wait)
*       r0    - temporary reg
*       r3    - return
*       r4    - address of SCC1R0
*       2(r4) - address of SCC1R1
*       4(r4) - address of SCSR
*       6(r4) - address of SCDR
*
ICHR    bsf
        ldreg   r4,SCC1R0
ICHL    lhz     r0,4(r4)                ;grab SCSR
        andi.   r0,r0,$0040             ;mask RDRF bit
        beq     0,ICHL                  ;haven't gotten bit, loop
        lhz     r3,6(r4)                ;grab character
        csf
        blr

*       Read and echo
*
RDTORET bsf
        ldreg   r2,{CMDA-1}                 ;command array
NOTRETL bl      ICHR
        bl      OCHR
        stbu    r3,1(r2)
        cmpi    r3,RETKEY
        bne     0,NOTRETL
        li      r3,$0A
        bl      OCHR
        stbu    r3,1(r2)
        li      r3,$00
        stbu    r3,1(r2)
        ldreg   r3,CMDA
        csf
        blr

;       arg r3 -- beginning of cmd string
PROCCMD bsf
        lbz     r0,0(r3)
USCMP   cmpi    r0,'S'
        beq     0,UECMP
        bne     0,lsCMP

lsCMP   cmpi    r0,'s'
        bne     0,UGCMP

UECMP   lbzu    r0,1(r3)
        cmpi    r0,'E'
        bne     0,leCMP
        beql    0,SETCMD
        b       PROCX

leCMP   cmpi    r0,'e'
        bne     0,UTCMP
        beql    0,SETCMD
        b       PROCX

UTCMP   cmpi    r0,'T'
        bne     0,ltCMP
        beql    0,STOPCMD
        b       PROCX

ltCMP   cmpi    r0,'t'
        bne     0,UGCMP
        beql    0,STOPCMD
        b       PROCX

UGCMP   cmpi    r0,'G'
        bne     0,lgCMP
        beql    0,GOCMD
        b       PROCX

lgCMP   cmpi    r0,'g'
        bne     0,UDCMP
        beql    0,GOCMD
        b       PROCX

UDCMP   cmpi    r0,'D'
        bne     0,ldCMP
        beql    0,DISPCMD
        b       PROCX

ldCMP   cmpi    r0,'d'
        bne     0,REFCMP
        beql    0,DISPCMD
        b       PROCX

REFCMP  cmpi    r0,'?'
        bne     0,PROCX
        ldreg   r3,CMDREF
        bl      OSTR

PROCX   csf
        blr

;       command format: SET f,d
;       enter function pointing @ E
;       go to f by inc ptr by
SETCMD  bsf
        mr      r27,r29         ;store frequency
        mr      r28,r30         ;store duty cycle
        li      r29,$00
        li      r30,$00
        addi    r3,r3,$03
        lbz     r0,0(r3)
        add     r29,r29,r0
        subi    r29,r29,48t
PRSPWM  lbzu    r0,1(r3)
        cmpi    r0,','
        beq     0,PRSDC
        MULLI   r29,r29,10t
        add     r29,r29,r0
        subi    r29,r29,48t
        b       PRSPWM
PRSDC   lbzu    r0,1(r3)
        cmpi    r0,$0D
        beq     0,SETX
        MULLI   r30,r30,10t
        add     r30,r30,r0
        subi    r30,r30,48t
        b       PRSDC
SETX    mr      r3,r29
        mr      r4,r30
        bl      UPWM
        ;bl      RAMPFRQ
        ;bl      RAMPDC
        csf
        blr

STOPCMD bsf
        li      r30,$00
        mr      r3,r29
        mr      r4,r30
        bl      UPWM
        bl      TPU0OFF
        csf
        blr

GOCMD   bsf
        bl      TPU0ON
        csf
        blr

DISPCMD bsf
        li      r5,$0A          ;divisor
        ldreg   r3,CMDA
        addi    r3,r3,$1F
        li      r0,$00
        stb     r0,0(r3)
        li      r0,$0A
        stbu    r0,-1(r3)
        li      r0,$0D
        stbu    r0,-1(r3)

        mr      r4,r31          ;grab RPM
RTOA    DIVW    r6,r4,r5        ;RPM10
        mullw   r6,r6,r5        ;quotient*10
        subf    r6,r6,r4        ;r5=remainder
        DIVW    r4,r4,r5        ;
        addi    r6,r6,48t       ;ASCII representation of integer
        stbu    r6,-1(r3)       ;
        cmpi    r4,$00          ;
        bne     0,FTOA          ;
        li      r0,','          ;
        stbu    r0,-1(r3)       ;

        mr      r4,r30          ;grab DC
DTOA    DIVW    r6,r4,r5        ;PWM/10
        mullw   r6,r6,r5        ;quotient*10
        subf    r6,r6,r4        ;r5=remainder
        DIVW    r4,r4,r5        ;
        addi    r6,r6,48t       ;ASCII representation of integer
        stbu    r6,-1(r3)
        cmpi    r4,$00          ;
        bne     0,DTOA
        li      r0,','          ;
        stbu    r0,-1(r3)       ;

        mr      r4,r29          ;grab PWM
FTOA    DIVW    r6,r4,r5        ;PWM/10
        mullw   r6,r6,r5        ;quotient*10
        subf    r6,r6,r4        ;r5=remainder
        DIVW    r4,r4,r5        ;
        addi    r6,r6,48t       ;ASCII representation of integer
        stbu    r6,-1(r3)
        cmpi    r4,$00          ;
        bne     0,FTOA
        bl      OSTR
        csf
        blr

;       Limits: 39Hz - 100000Hz
UPWM    bsf
        ldreg   r5,TPU_PRAM_A   ;TPUA PRAM
        ldreg   r0,2500000t     ;Osc_Freq / 2
        ldreg   r6,100t         ;DC to percent
        DIVW    r0,r0,r3        ;(Osc_Freq / 2) / Des_Freq
        sth     r0,6(r5)        ;Set Frequency

        MULLW   r0,r0,r4        ;PWM_PER * DC
        DIVW    r0,r0,r6        ;DC / 100t == percent * PWM_PER
        sth     r0,4(r5)        ;Set Duty Cycle

        ldreg   r5,HSRR1_A      ;addr to Host Sequence Routine Reg
        lhz     r0,0(r5)        ;get HSRR1
        andi.   r0,r0,$FC       ;Clear TPU CH0 bits
        ori     r0,r0,$02       ;Set bits to Initialize
        sth     r0,0(r5)        ;Store Update in HSRR1
        csf
        blr

ITPU    bsf

        ldreg   r4,TPUMCR_A     ;set r4 to TPUMCR_A register
        ldreg   r3,$2020        ;set r3 to TPUMCR config
        sth     r3,0(r4)        ;store config in TPUMCR
        ldreg   r3,$0040        ;Divide clock by 2
        sth     r3,$2A(r4)      ;store config in TPUMCR3
        ldreg   r3,$0500        ;interrupt level to 5
        sth     r3,$8(r4)       ;store config in TICR

        csf
        blr

TPU0OFF bsf

        li      r3,$00          ;offset from CPR1_A
        ldreg   r4,CPR1_A       ;priority register 1
        ldreg   r5,$FFFC        ;mask for CPR1
        clrr    r3,r4,r5        ;Clear last two bits in CPR1_A

        csf
        blr

TPU0ON  bsf

        li      r3,$00          ;offset from CPR1_A
        ldreg   r4,CPR1_A       ;priority register 1
        ldreg   r5,$0003        ;mask for CPR1
        setr    r3,r4,r5        ;set priority to 3-high priority

        csf
        blr

IPWM0   bsf
	bl	TPU0OFF

        ldreg   r4,TPUMCR_A     ;TPUMCR register
        lhz     r0,$12(r4)      ;get CFSR3 register
        andi.   r0,r0,$FFFC     ;clear CH0
        ori     r0,r0,$0003     ;set CH0 to PWM
        sth     r0,$12(r4)      ;store config

        lhz     r0,$A(r4)       ;get CIER reg
        andi.   r0,r0,$FFFE     ;disable CH0 interrupt
        sth     r0,$A(r4)       ;store config

        ldreg   r3,$91          ;Channel Control
        sth     r3,$100(r4)     ;store config in PWM Channel Control

        ldreg   r3,$0           ;50% DC
        sth     r3,$104(r4)     ;store DC config

        ldreg   r3,$9C4         ;Period = 1kHz
        sth     r3,$106(r4)     ;store period config

        ldreg   r5,HSRR1_A      ;addr to Host Sequence Routine Reg
        lhz     r0,0(r5)        ;get HSRR1
        andi.   r0,r0,$FC       ;Clear TPU CH0 bits
        ori     r0,r0,$02       ;Set bits to Update
        sth     r0,0(r5)        ;Store Update in HSRR1
        csf
        blr

CMDA    ds      $20

CMDREF  db      '+----------------------------------------------+',$0A,$0D
        db      '|              Command Reference               |',$0A,$0D
        db      '+----------------------------------------------+',$0A,$0D
        db      '| SET f,d  - Set freq to f and duty cycle to d |',$0A,$0D
        db      '| GO       - Ramp motor up to set duty cycle   |',$0A,$0D
        db      '| STOP     - Ramp down to duty cycle 0         |',$0A,$0D
        db      '| DISP     - Display FREQ,DC,RPM               |',$0A,$0D
        db      '| ?        - Display this reference            |',$0A,$0D
        db      '+----------------------------------------------+',$0A,$0D,$00

PROMPT  equ     '>'
RETKEY  equ     $0D
