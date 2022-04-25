
; CC5X Version 3.7C, Copyright (c) B Knudsen Data
; C compiler for the PICmicro family
; ************  16. Jan 2019  17:07  *************

        processor  16F887
        radix  DEC

        __config 0x2007, 0x20D4
        __config 0x2008, 0x3EFF

STATUS      EQU   0x03
FSR         EQU   0x04
PORTA       EQU   0x05
TRISA       EQU   0x85
PORTB       EQU   0x06
TRISB       EQU   0x86
PCLATH      EQU   0x0A
INTEDG      EQU   6
Carry       EQU   0
Zero_       EQU   2
RP0         EQU   5
RP1         EQU   6
RBIF        EQU   0
INTE        EQU   4
GIE         EQU   7
PORTC       EQU   0x07
TRISC       EQU   0x87
IOCB        EQU   0x96
ANSEL       EQU   0x188
ANSELH      EQU   0x189
S_M1_Valid  EQU   0
S_M1_Sens   EQU   1
S_M2_Valid  EQU   3
S_M2_Sens   EQU   2
compteur1   EQU   0x23
compteur2   EQU   0x24
mem_portb   EQU   0x25
etat_rb0    EQU   0
etat_rb1    EQU   1
svrWREG     EQU   0x70
svrSTATUS   EQU   0x20
svrPCLATH   EQU   0x21
sv_FSR      EQU   0x22
millisec    EQU   0x7F
i           EQU   0x7F
i2          EQU   0x7F
microsec    EQU   0x7F
i2_2        EQU   0x7F
i_2         EQU   0x7F

        GOTO main

  ; FILE Test_PIC16F887.c
                        ;#pragma chip PIC16F887
                        ;#pragma config=0x20D4     //Bit13   Debug=1  Sans //20D4
                        ;                          //Bit12   LVP=0
                        ;                          //Bit11   FCMEN=0
                        ;                          //Bit10   IESO=0
                        ;                          //Bit9-8  BOR=00
                        ;                          //Bit7    CPD=1
                        ;                          //Bit6    CP=1
                        ;                          //Bit5    MCLRE=0    MCLR=RE3
                        ;                          //Bit4    PWRTE=1
                        ;                          //Bit3    WDTE=0     //WachDOG=0
                        ;                          //Bit2-0  FOSC=010      HS:010     Interne:100        
                        ;#pragma config reg2=0x3EFF    //Bit13-11  111
                        ;                          //Bit10-9   11
                        ;                          //Bit8      0
                        ;                          //Bit7-0    11111111
                        ;
                        ;#include <int16CXX.H>
                        ;
                        ;#pragma bit S_M1_Valid        @ PORTC.0
                        ;#pragma bit S_M1_Sens         @ PORTC.1
                        ;#pragma bit S_M2_Valid        @ PORTC.3
                        ;#pragma bit S_M2_Sens         @ PORTC.2
                        ;
                        ;uns8 compteur1,compteur2;
                        ;uns8 mem_portb;
                        ;bit etat_rb0,etat_rb1;
                        ;
                        ;#pragma library 0
                        ;
                        ;#pragma origin 4
        ORG 0x0004
                        ;interrupt int_server(void)
                        ;   {
int_server
                        ;    int_save_registers
        MOVWF svrWREG
        SWAPF STATUS,W
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVWF svrSTATUS
        MOVF  PCLATH,W
        MOVWF svrPCLATH
        CLRF  PCLATH
                        ;    char sv_FSR = FSR;
        MOVF  FSR,W
        MOVWF sv_FSR
                        ;
                        ;    if (RBIF)
        BTFSS 0x0B,RBIF
        GOTO  m007
                        ;      {
                        ;        RBIF=0;
        BCF   0x0B,RBIF
                        ;        mem_portb=PORTB;
        MOVF  PORTB,W
        MOVWF mem_portb
                        ;        
                        ;        if (mem_portb.0!=etat_rb0)
        BTFSC mem_portb,0
        GOTO  m001
        BTFSC 0x26,etat_rb0
        GOTO  m002
        GOTO  m003
m001    BCF   0x03,RP0
        BCF   0x03,RP1
        BTFSC 0x26,etat_rb0
        GOTO  m003
                        ;            compteur1++;
m002    BCF   0x03,RP0
        BCF   0x03,RP1
        INCF  compteur1,1
                        ;        if (mem_portb.1!=etat_rb1)
m003    BCF   0x03,RP0
        BCF   0x03,RP1
        BTFSC mem_portb,1
        GOTO  m004
        BTFSC 0x26,etat_rb1
        GOTO  m005
        GOTO  m006
m004    BCF   0x03,RP0
        BCF   0x03,RP1
        BTFSC 0x26,etat_rb1
        GOTO  m006
                        ;            compteur2++;        
m005    BCF   0x03,RP0
        BCF   0x03,RP1
        INCF  compteur2,1
                        ;        
                        ;        etat_rb0=mem_portb.0;
m006    BCF   0x03,RP0
        BCF   0x03,RP1
        BCF   0x26,etat_rb0
        BTFSC mem_portb,0
        BSF   0x26,etat_rb0
                        ;        etat_rb1=mem_portb.1;
        BCF   0x26,etat_rb1
        BTFSC mem_portb,1
        BSF   0x26,etat_rb1
                        ;        
                        ;        
                        ;   }
                        ;
                        ;    FSR = sv_FSR;
m007    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  sv_FSR,W
        MOVWF FSR
                        ;    int_restore_registers
        MOVF  svrPCLATH,W
        MOVWF PCLATH
        SWAPF svrSTATUS,W
        MOVWF STATUS
        SWAPF svrWREG,1
        SWAPF svrWREG,W
                        ;   }
        RETFIE
                        ;
                        ;
                        ;
                        ;//Déclaration des différentes variables
                        ;
                        ;void delay_ms(uns16 millisec);
                        ;void delay_us(uns16 microsec);
                        ;
                        ;void delay_ms(uns16 millisec)
                        ;   {
delay_ms
                        ;    uns16 i,i2;
                        ;    for (i2=0;i2<millisec;i2++)
        CLRF  i2
        CLRF  i2+1
m008    MOVF  millisec+1,W
        SUBWF i2+1,W
        BTFSS 0x03,Carry
        GOTO  m009
        BTFSS 0x03,Zero_
        GOTO  m013
        MOVF  millisec,W
        SUBWF i2,W
        BTFSC 0x03,Carry
        GOTO  m013
                        ;      for (i=0;i<350;i++);
m009    CLRF  i
        CLRF  i+1
m010    MOVLW 1
        SUBWF i+1,W
        BTFSS 0x03,Carry
        GOTO  m011
        BTFSS 0x03,Zero_
        GOTO  m012
        MOVLW 94
        SUBWF i,W
        BTFSC 0x03,Carry
        GOTO  m012
m011    INCF  i,1
        BTFSC 0x03,Zero_
        INCF  i+1,1
        GOTO  m010
m012    INCF  i2,1
        BTFSC 0x03,Zero_
        INCF  i2+1,1
        GOTO  m008
                        ;   }
m013    RETURN
                        ;
                        ;void delay_us(uns16 microsec)
                        ;   {
delay_us
                        ;    uns16 i2,i;
                        ;    i=microsec/4;
        BCF   0x03,Carry
        RRF   microsec+1,W
        MOVWF i_2+1
        RRF   microsec,W
        MOVWF i_2
        BCF   0x03,Carry
        RRF   i_2+1,1
        RRF   i_2,1
                        ;    for (i2=0;i2<i;i2++);
        CLRF  i2_2
        CLRF  i2_2+1
m014    MOVF  i_2+1,W
        SUBWF i2_2+1,W
        BTFSS 0x03,Carry
        GOTO  m015
        BTFSS 0x03,Zero_
        GOTO  m016
        MOVF  i_2,W
        SUBWF i2_2,W
        BTFSC 0x03,Carry
        GOTO  m016
m015    INCF  i2_2,1
        BTFSC 0x03,Zero_
        INCF  i2_2+1,1
        GOTO  m014
                        ;   }
m016    RETURN
                        ;
                        ;
                        ;void init(void)
                        ;   {
init
                        ;    //OSCCON=0x79;    //bit7=0  
                        ;                    //Bit6-4 8MHz:111  
                        ;                    //Bit3  Osts=1   
                        ;                    //Bit2  HTS=0
                        ;                    //Bit1  LTS=0
                        ;                    //Bit0  SCS=1
                        ;    
                        ;    TRISA=0x00;
        BSF   0x03,RP0
        BCF   0x03,RP1
        CLRF  TRISA
                        ;    ANSEL=0x00;
        BSF   0x03,RP1
        CLRF  ANSEL
                        ;    ANSELH=0x00;
        CLRF  ANSELH
                        ;    PORTA=0x00;
        BCF   0x03,RP0
        BCF   0x03,RP1
        CLRF  PORTA
                        ;    
                        ;    TRISB=0xFF;
        MOVLW 255
        BSF   0x03,RP0
        MOVWF TRISB
                        ;    PORTB=0x00;
        BCF   0x03,RP0
        CLRF  PORTB
                        ;    IOCB=0x03;
        MOVLW 3
        BSF   0x03,RP0
        MOVWF IOCB
                        ;    
                        ;    TRISC=0x00;
        CLRF  TRISC
                        ;    PORTC=0x00;
        BCF   0x03,RP0
        CLRF  PORTC
                        ;    //TRISD=0x00;
                        ;    //PORTD=0x00;
                        ;    //TRISE=0x00;
                        ;    //PORTE=0x00;
                        ;    
                        ;    //GIE = 1;                //Validation de l'ensemble des interruptions              
                        ;    //RBIE=1;
                        ;
                        ;    GIE = 1;			//Validation des interruptions
        BSF   0x0B,GIE
                        ;    INTE = 1;			//Validation de l?interruption INT0 (RB0)
        BSF   0x0B,INTE
                        ;    INTEDG = 1;		//Déclenchement sur Front montant 
        BSF   0x03,RP0
        BSF   0x81,INTEDG
                        ;
                        ;   }
        RETURN
                        ;
                        ;//Programme Principal
                        ;void main(void)
                        ;   {
main
                        ;    
                        ;    
                        ;    
                        ;    
                        ;    
                        ;    compteur1=1;
        MOVLW 1
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVWF compteur1
                        ;    compteur2=2;
        MOVLW 2
        MOVWF compteur2
                        ;    etat_rb0=0;
        BCF   0x26,etat_rb0
                        ;    etat_rb1=0;
        BCF   0x26,etat_rb1
                        ;    init();
        CALL  init
                        ;    while(1)
                        ;    {  
                        ;        PORTC=PORTB;
m017    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  PORTB,W
        MOVWF PORTC
                        ;        S_M1_Valid=1;        
        BSF   0x07,S_M1_Valid
                        ;        S_M1_Sens=1;         
        BSF   0x07,S_M1_Sens
                        ;        S_M2_Valid=1;        
        BSF   0x07,S_M2_Valid
                        ;        S_M2_Sens=1;
        BSF   0x07,S_M2_Sens
                        ;        PORTC=0xAA;
        MOVLW 170
        MOVWF PORTC
                        ;        
                        ;    }
        GOTO  m017

        END


; *** KEY INFO ***

; 0x0004 P0   60 word(s)  2 % : int_server
; 0x0040 P0   33 word(s)  1 % : delay_ms
; 0x0061 P0   25 word(s)  1 % : delay_us
; 0x007A P0   25 word(s)  1 % : init
; 0x0093 P0   20 word(s)  0 % : main

; RAM usage: 8 bytes (4 local), 360 bytes free
; Maximum call level: 1 (+1 for interrupt)
;  Codepage 0 has  164 word(s) :   8 %
;  Codepage 1 has    0 word(s) :   0 %
;  Codepage 2 has    0 word(s) :   0 %
;  Codepage 3 has    0 word(s) :   0 %
; Total of 164 code words (2 %)
