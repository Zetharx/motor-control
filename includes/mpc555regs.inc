* MPC555 Peripheral Register Equates

* Unified System Integration Unit
SIUMCR      EQU      002FC000
SYPCR       EQU      002FC004
SWSR        EQU      002FC00E
SIPEND      EQU      002FC010
SIMASK      EQU      002FC014
SIEL        EQU      002FC018
SIVEC       EQU      002FC01C
TESR        EQU      002FC020
SGPIODT1    EQU      002FC024
SGPIODT2    EQU      002FC028
SGPIOCR     EQU      002FC02C
EMCR        EQU      002FC030
PDMCR       EQU      002FC03C

* Memory Controller Registers
BR0         EQU      002FC100 
OR0         EQU      002FC104 
BR1         EQU      002FC108 
OR1         EQU      002FC10C 
BR2         EQU      002FC110 
OR2         EQU      002FC114 
BR3         EQU      002FC118 
OR3         EQU      002FC11C 
DMBR        EQU      002FC140 
DMOR        EQU      002FC144 
MSTAT       EQU      002FC178

* System Integraion Timer Registers
TBSCR       EQU      002FC200
TBREF0      EQU      002FC204 
TBREF1      EQU      002FC208 
RTCSC       EQU      002FC220 
RTC         EQU      002FC224 
RTSEC       EQU      002FC228 
RTCAL       EQU      002FC22C 
PISCR       EQU      002FC240
PITC        EQU      002FC244 
PITR        EQU      002FC248 

* Clock and Reset Registers
SCCR        EQU      002FC280 
PLPRCR      EQU      002FC284 
RSR         EQU      002FC288 
COLIR       EQU      002FC28C 
VSRMCR      EQU      002FC290

* System Integraion Timer Key Registers
TBSCRK      EQU      002FC300
TBREF0K     EQU      002FC304 
TBREF1K     EQU      002FC308 
TBK         EQU      002FC30C 
RTCSCK      EQU      002FC320 
RTCK        EQU      002FC324 
RTSECK      EQU      002FC328 
RTCALK      EQU      002FC32C 
PISCRIK     EQU      002FC340 
PITCK       EQU      002FC344

* Clock and Reset Key Registers
SCCRK       EQU      002FC380 
PLPRCRK     EQU      002FC384 
RSRK        EQU      002FC388 

* Flash EEPROM Registers
CMFMCRA     EQU      002FC800
CMFTSTA     EQU      002FC804
CMFCTLA     EQU      002FC808
CMFMCRB     EQU      002FC840 
CMFTSTB     EQU      002FC844 
CMFCTLB     EQU      002FC848

* Dual-Port TPU RAM Registers
DPTMCR      EQU      00300000 
RAMTST      EQU      00300002 
RAMBAR      EQU      00300004 
MISRH       EQU      00300006 
MISRL       EQU      00300008 
MISCNT      EQU      0030000A

* Timer Processor Unit A Registers
TPUMCR_A    EQU      00304000 
TCR_A       EQU      00304002 
DSCR_A      EQU      00304004 
DSSR_A      EQU      00304006 
TICR_A      EQU      00304008 
CIER_A      EQU      0030400A 
CFSR0_A     EQU      0030400C 
CFSR1_A     EQU      0030400E 
CFSR2_A     EQU      00304010 
CFSR3_A     EQU      00304012 
HSQR0_A     EQU      00304014 
HSQR1_A     EQU      00304016 
HSRR0_A     EQU      00304018 
HSRR1_A     EQU      0030401A 
CPR0_A      EQU      0030401C 
CPR1_A      EQU      0030401E 
CISR_A      EQU      00304020
LR_A        EQU      00304022
SGLR_A      EQU      00304024
DCNR_A      EQU      00304026
TPUMCR2_A   EQU      00304028
TPUMCR3_A   EQU      0030402A
ISDR_A      EQU      0030402C
ISCR_A      EQU      0030402E

* Timer Processor Unit B Registers
TPUMCR_B    EQU      00304400
TCR_B       EQU      00304402 
DSCR_B      EQU      00304404 
DSSR_B      EQU      00304406 
TICR_B      EQU      00304408
CIER_B      EQU      0030440A             
CFSR0_B     EQU      0030440C             
CFSR1_B     EQU      0030440E             
CFSR2_B     EQU      00304410             
CFSR3_B     EQU      00304412             
HSQR0_B     EQU      00304414             
HSQR1_B     EQU      00304416             
HSRR0_B     EQU      00304418             
HSRR1_B     EQU      0030441A
CPR0_B      EQU      0030441C
CPR1_B      EQU      0030441E             
CISR_B      EQU      00304420             
LR_B        EQU      00304422
SGLR_B      EQU      00304424
DCNR_B      EQU      00304426
TPUMCR2_B   EQU      00304428             
TPUMCR3_B   EQU      0030442A
ISDR_B      EQU      0030442C
ISCR_B      EQU      0030442E

* Queued A/D Converter Registers
QADCMCRA    EQU      00304800
QADCINTA    EQU      00304804
PORTQA      EQU      00304806            
DDRQA       EQU      00304808            
QACR0_A     EQU      0030480A            
QACR1_A     EQU      0030480C            
QACR2_A     EQU      0030480E            
QASR0_A     EQU      00304810
QASR1_A     EQU      00304812
QADCMCRB    EQU      00304C00            
QADCINTB    EQU      00304C04            
PORTQB      EQU      00304C06            
DDRQB       EQU      00304C08            
QACR0_B     EQU      00304C0A            
QACR1_B     EQU      00304C0C            
QACR2_B     EQU      00304C0E 
QASR0_B     EQU      00304C10 
QASR1_B     EQU      00304C12

* Queued Serial Multi-Channel Registers
QSMCMMCR    EQU      00305000 
QTEST       EQU      00305002 
QDSCI_IL    EQU      00305004 
QSPI_IL     EQU      00305006
SCC1R0      EQU      00305008
SCC1R1      EQU      0030500A 
SC1SR       EQU      0030500C 
SC1DR       EQU      0030500E 
PORTQS      EQU      00305014 
DDRQST      EQU      00305016 
SPCR0       EQU      00305018 
SPCR1       EQU      0030501A 
SPCR2       EQU      0030501C             
SPCR3       EQU      0030501E             
SPSR        EQU      0030501F             
SCC2R0      EQU      00305020             
SCC2R1      EQU      00305022 
SC2SR       EQU      00305024 
SC2DR       EQU      00305026
QSCI1CR     EQU      00305028
QSCI1SR     EQU      0030502A

* Modular Input/Output Registers
MPPERR0     EQU      00306000 
MPPULR0     EQU      00306002 
MPCNTR0     EQU      00306004 
MPSCR0      EQU      00306006 
MPPERR1     EQU      00306008 
MPPULR1     EQU      0030600A 
MPCNTR1     EQU      0030600C 
MPSCR1      EQU      0030600E 
MPPERR2     EQU      00306010 
MPPULR2     EQU      00306012 
MPCNTR2     EQU      00306014
MPSCR2      EQU      00306016
MPPERR3     EQU      00306018 
MPPULR3     EQU      0030601A             
MPCNTR3     EQU      0030601C             
MPSCR3      EQU      0030601E 
MPPERR16    EQU      00306080             
MPPULR16    EQU      00306082             
MPCNTR16    EQU      00306084             
MPSCR16     EQU      00306086             
MPPERR17    EQU      00306088             
MPPULR17    EQU      0030608A             
MPCNTR17    EQU      0030608C             
MPSCR17     EQU      0030608E             
MPPERR18    EQU      00306090             
MPPULR18    EQU      00306092
MPCNTR18    EQU      00306094
MPSCR18     EQU      00306096             
MPPERR19    EQU      00306098             
MPPULR19    EQU      0030609A             
MPCNTR19    EQU      0030609C 
MPSCR19     EQU      0030609E             
MCCNT6      EQU      00306030             
MCML6       EQU      00306032             
MCSCRD6     EQU      00306034             
MCSCR6      EQU      00306036             
MCCNT22     EQU      003060B0             
MCML22      EQU      003060B2             
MCSCRD22    EQU      003060B4             
MCSCR22     EQU      003060B6             
MDAR11      EQU      00306058
MDBR11      EQU      0030605A
MDSCRD11    EQU      0030605C             
MDSCR11     EQU      0030605E             
MDAR12      EQU      00306060             
MDBR12      EQU      00306062 
MDSCRD12    EQU      00306064             
MDSCR12     EQU      00306066             
MDAR13      EQU      00306068             
MDBR13      EQU      0030606A             
MDSCRD13    EQU      0030606C             
MDSCR13     EQU      0030606E             
MDAR14      EQU      00306070             
MDBR14      EQU      00306072             
MDSCRD14    EQU      00306074             
MDSCR14     EQU      00306076
MDAR15      EQU      00306078
MDBR15      EQU      0030607A             
MDSCRD15    EQU      0030607C             
MDSCR15     EQU      0030607E             
MDAR27      EQU      003060D8 
MDBR27      EQU      003060DA             
MDSCRD27    EQU      003060DC             
MDSCR27     EQU      003060DE             
MDAR28      EQU      003060E0             
MDBR28      EQU      003060E2             
MDSCRD28    EQU      003060E4             
MDSCR28     EQU      003060E6             
MDAR29      EQU      003060E8             
MDBR29      EQU      003060EA             
MDSCRD29    EQU      003060EC
MDSCR29     EQU      003060EE
MDAR30      EQU      003060F0             
MDBR30      EQU      003060F2             
MDSCRD30    EQU      003060F4             
MDSCR30     EQU      003060F6 
MDAR31      EQU      003060F8             
MDBR31      EQU      003060FA             
MDSCRD31    EQU      003060FC             
MDSCR31     EQU      003060FE             
MPIOSMDR    EQU      00306100             
MPIOSMDDR   EQU      00306102             
MIOS1TPC    EQU      00306800             
MIOS1VNR    EQU      00306804             
MIOS1MCR    EQU      00306806             
MCPSCR      EQU      00306816
MIOS1LV0    EQU      00306C30
MIOS1LV1    EQU      00306C70             
MIOS1SR0    EQU      00306C00             
MIOS1ER0    EQU      00306C04             
MIOS1RP0    EQU      00306C06 
MIOS1SR1    EQU      00306C40 
MIOS1ER1    EQU      00306C44 
MIOS1RP1    EQU      00306C46

* CAN Controller Module A Registers
TCNMCR_A    EQU      00307080 
CANICR_A    EQU      00307084 
CTRL0_1A    EQU      00307086          
PD_CTR2A    EQU      00307088          
TIMER_A     EQU      0030708A
RXGMHI_A    EQU      00307090
RXGMLO_A    EQU      00307092          
RX14MHIA    EQU      00307094          
RX14MLOA    EQU      00307096          
RX15MHIA    EQU      00307098          
RX15MLOA    EQU      0030709A          
ESTAT_A     EQU      003070A0          
IMASK_A     EQU      003070A2          
IFLAG_A     EQU      003070A4          
RXTXER_A    EQU      003070A6

* CAN Controller Module B Registers
TCNMCR_B    EQU      00307480 
CANICR_B    EQU      00307484 
CTRL0_1B    EQU      00307486
PD_CTR2B    EQU      00307488
TIMER_B     EQU      0030748A 
RXGMHI_B    EQU      00307490 
RXGMLO_B    EQU      00307492 
RX14MHIB    EQU      00307494 
RX14MLOB    EQU      00307496 
RX15MHIB    EQU      00307498 
RX15MLOB    EQU      0030749A 
ESTAT_B     EQU      003074A0 
IMASK_B     EQU      003074A2 
IFLAG_B     EQU      003074A4          
RXTXER_B    EQU      003074A6

* UIMB Module Registers
UMCR        EQU      00307F80
UIPEND      EQU      00307FA0

* Static RAM Registers
SRAMMCR_A   EQU      00380000 
SRAMTST_A   EQU      00380004 
SRAMMCR_B   EQU      00380008
SRAMTST_B   EQU      0038000C 


