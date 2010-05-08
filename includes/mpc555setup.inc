******* USER SECTION - Change these settings for your setup ********


cpu_speed       equ  20000000t   ; Set bus rate of the MPC555.
                                 ; Note the "T" represents
                                 ; decimal base

osc_freq        equ  4000000t    ; Oscillator freq of the ext
                                 ; crystal.

sc1_baud_rate   equ  9600T       ; Baud rate for sci 1

uart_irq_lvl    equ  3           ; Sets the SCI interrupt level
                                 ; Can be any value from 0-31t

sypcr_val       equ  $fffffff0   ; Turns off watchdog timer


******* DO NOT CHANGE BELOW THIS LINE *******

sc1_baud_reg    equ  {cpu_speed/64t/sc1_baud_rate}
mfval           equ  {cpu_speed/osc_freq}
pllval          equ  {{mfval-1}<20t}

******* DO NOT CHANGE ABOVE THIS LINE *******
