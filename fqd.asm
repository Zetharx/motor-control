r18 - POS - FQD Position (Current)
r19 - FQD POS
r9 -  FQDActual
r22 - DC Hex value from inputted decimal value
r6 -  RPM hex value 


FQDInit      equ     $8000           ;FQD Inital Value
FQD0         equ     $3041C0         ;FQD 0
FQD1         equ     $3041D0         ;FQD 1



***************INITFQD - Init FQD 

param ram -- zero it out
 - set init count
set function select to fqd


INITFQD bsf
        bl      FQDOFF
        ldreg   r2,CFSR0_A
        ldreg   r0,$0066        	;set 6 into ch 13,12
        sth     r0,0(r2)

        ldreg   r2,FQD0           ;Channel 12
        ldreg   r0,$8000          ;Position = $8000
        sth     r0,2(r2)
        ldreg   r0,$00D6          ;CORR_PINSTATE_ADDR = $D6
        sth     r0,8(r2)
        ldreg   r0,$00C1          ;EDGE_TIME_LSB_ADDR = $C1
        sth     r0,$A(r2)

        ldreg   r2,FQD1           ;Channel 13
        ldreg   r0,$8000          ;Position = $8000
        sth     r0,2(r2)
        ldreg   r0,$00C6          ;CORR_PINSTATE_ADDR = $C6
        sth     r0,8(r2)
        ldreg   r0,$00C1          ;EDGE_TIME_LSB_ADDR = $C1
        sth     r0,$A(r2)

        ldreg   r2,HSQR0_A
        ldreg   r0,$0400          ;Ch12 is Primary
        sth     r0,0(r2)          ;Ch13 is secondary

        ldreg   r2,HSRR0_A
        lhz     r0,0(r2)
        ori     r0,r0,$0F00       ;set Ch12,13 init FQD
        sth     r0,0(r2)
        bl      FQDON
        csf
        blr


***************FQDOFF

FQDOFF  ldreg   r2,CPR0_A
        lhz     r0,0(r2)
        andi.   r0,r0,$F0FF
        sth     r0,0(r2)        	;disable FQD0 & 1
        blr

***************FQDON

FQDON   ldreg   r2,CPR0_A
        lhz     r0,0(r2)
        ori     r0,r0,$0F00     	;high priority
        sth     r0,0(r2)        	;enable FQD0 & 1
        blr



***************CALCRPM - Reads the FQD Value and Calculates RPM

CALCRPM	bsf
        ldreg  r2,FQDInit
        sub    r21,r9,r2        ;r21 = (FQDActual - FQDInitial)
        cmpi   r21,0t
        bgt    0,CA1
        sub    r21,r2,r9        ;r21 = (FQDInitial - FQDActual)
CA1     ldreg  r0,$4            ;r0 contains a constant 4
        mullw  r21,r21,r0       ;r21 = (FQDActual - FQDInitial) * 4[1/sec]
        ldreg  r0,60t           ;r0 contains a constant 60t
        mullw  r21,r21,r0       ;r21 = (FQDActual - FQDInitial) * 4[1/sec]) * 60 [sec]
        ldreg  r0,19t
        divw   r21,r21,r0       ; div by 19 (1:19 gear ratio)
        ldreg  r0,Xt           ;r0 contains a constant Xt
        divw   r21,r21,r0       ;r21 = (FQDActual - FQDInitial) / X pulses per revolution)

        addi   r6,r21,$0        ;RPM Hex = calculated value in r21
        csf
        blr





***************FQDREAD - Reads value of FQD and reinit
FQDREAD lhz     r0,0(r19)
        mr      r9,r0           ; r9 = current count
        ldreg   r0,$8000
        sth     r0,0(r19)
        blr



