
; CC5X Version 3.7A, Copyright (c) B Knudsen Data
; C compiler for the PICmicro family
; ************  21. Mar 2019   8:17  *************

        processor  16F886
        radix  DEC

        __config 0x2007, 0x20D4
        __config 0x2008, 0x3EFF

PORTA       EQU   0x05
TRISA       EQU   0x85
PORTB       EQU   0x06
TRISB       EQU   0x86
Carry       EQU   0
Zero_       EQU   2
RP0         EQU   5
RP1         EQU   6
PORTC       EQU   0x07
PORTE       EQU   0x09
ADRESH      EQU   0x1E
ADCON0      EQU   0x1F
TRISC       EQU   0x87
TRISE       EQU   0x89
ADRESL      EQU   0x9E
ANSEL       EQU   0x188
ANSELH      EQU   0x189
GO          EQU   1
LED1        EQU   0
LED2        EQU   1
LED3        EQU   2
LED4        EQU   3
LED5        EQU   4
LED6        EQU   5
LED7        EQU   6
LED8        EQU   7
S2          EQU   5
S3          EQU   4
S4          EQU   3
S5          EQU   2
entree      EQU   0x20
i           EQU   0x21
registre    EQU   0x23
j           EQU   0x24

        GOTO main

  ; FILE Test_Robot_PIC16F886.c
                        ;#pragma chip PIC16F886
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
                        ;#pragma bit LED1        @ PORTC.0
                        ;#pragma bit LED2        @ PORTC.1
                        ;#pragma bit LED3        @ PORTC.2
                        ;#pragma bit LED4        @ PORTC.3
                        ;#pragma bit LED5        @ PORTC.4
                        ;#pragma bit LED6        @ PORTC.5
                        ;#pragma bit LED7        @ PORTC.6
                        ;#pragma bit LED8        @ PORTC.7
                        ;
                        ;
                        ;#pragma bit S2          @ PORTB.5
                        ;#pragma bit S3          @ PORTB.4
                        ;#pragma bit S4          @ PORTB.3
                        ;#pragma bit S5          @ PORTB.2
                        ;
                        ;void delay_ms(uns16 millisec);
                        ;uns16 CAN(uns8 entree);
                        ;
                        ;uns16 CAN(uns8 entree)	//Fonction CAN()
                        ;   {
CAN
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVWF entree
                        ;    uns16 i;                               //Variable i : Entier non signé 16 bit
                        ;    uns8 registre,j;		//Variable registre et j : Entier non signé 8 bit
                        ;    registre=entree << 3;	//Décalage à gauche de « entree » de 3 bit 
        BCF   0x03,Carry
        RLF   entree,W
        MOVWF registre
        BCF   0x03,Carry
        RLF   registre,1
        BCF   0x03,Carry
        RLF   registre,1
                        ;    registre=registre+129;	//ADON= True et ADCS1 :ADCS0=10   Fosc/64
        MOVLW 129
        ADDWF registre,1
                        ;    ADCON0=registre;	//ADCON0 = registre
        MOVF  registre,W
        MOVWF ADCON0
                        ;    for(j=0;j<100;j++);		//Tempo de quelque µs
        CLRF  j
m001    MOVLW 100
        BCF   0x03,RP0
        BCF   0x03,RP1
        SUBWF j,W
        BTFSC 0x03,Carry
        GOTO  m002
        INCF  j,1
        GOTO  m001
                        ;    GO=1;			//GO=1 Début conversion
m002    BCF   0x03,RP0
        BCF   0x03,RP1
        BSF   0x1F,GO
                        ;    while (GO);			//Attendre GO=0
m003    BCF   0x03,RP0
        BCF   0x03,RP1
        BTFSC 0x1F,GO
        GOTO  m003
                        ;    i=ADRESH * 256;		//Décalage de 8 bit à gauche du résultat et stockage dans i 
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  ADRESH,W
        MOVWF i+1
        CLRF  i
                        ;    i=ADRESL + i;		//Mettre les 8 bit de poids faible dans i
        BSF   0x03,RP0
        MOVF  ADRESL,W
        BCF   0x03,RP0
        ADDWF i,1
        BTFSC 0x03,Carry
        INCF  i+1,1
                        ;    return i;			//Retour de la valeur de la conversion CAN
        MOVF  i,W
        RETURN
                        ;   }
                        ;
                        ;
                        ;void init(void)
                        ;   {
init
                        ;    TRISA=0x01;
        MOVLW 1
        BSF   0x03,RP0
        BCF   0x03,RP1
        MOVWF TRISA
                        ;    ANSEL=0x01;
        MOVLW 1
        BSF   0x03,RP1
        MOVWF ANSEL
                        ;    ANSELH=0x00;
        CLRF  ANSELH
                        ;    PORTA=0x00;
        BCF   0x03,RP0
        BCF   0x03,RP1
        CLRF  PORTA
                        ;    
                        ;    TRISB=0x3F;
        MOVLW 63
        BSF   0x03,RP0
        MOVWF TRISB
                        ;    PORTB=0x00;
        BCF   0x03,RP0
        CLRF  PORTB
                        ;    
                        ;    TRISC=0x00;
        BSF   0x03,RP0
        CLRF  TRISC
                        ;    PORTC=0x00;
        BCF   0x03,RP0
        CLRF  PORTC
                        ;
                        ;    TRISE=0x00;
        BSF   0x03,RP0
        CLRF  TRISE
                        ;    PORTE=0x00;    
        BCF   0x03,RP0
        CLRF  PORTE
                        ;   }
        RETURN
                        ;
                        ;//Programme Principal
                        ;void main(void)
                        ;   {
main
                        ;    init();
        CALL  init
                        ;    while(1)
                        ;    {  
                        ;        if (S2)
m004    BCF   0x03,RP0
        BCF   0x03,RP1
        BTFSS 0x06,S2
        GOTO  m005
                        ;          {
                        ;            LED1=1;
        BSF   0x07,LED1
                        ;            LED2=1;
        BSF   0x07,LED2
                        ;          }
                        ;        else
        GOTO  m006
                        ;          {
                        ;            LED1=0;
m005    BCF   0x03,RP0
        BCF   0x03,RP1
        BCF   0x07,LED1
                        ;            LED2=0;            
        BCF   0x07,LED2
                        ;          }
                        ;        
                        ;        if (S3)
m006    BCF   0x03,RP0
        BCF   0x03,RP1
        BTFSS 0x06,S3
        GOTO  m007
                        ;          {
                        ;            LED3=1;
        BSF   0x07,LED3
                        ;            LED4=1;
        BSF   0x07,LED4
                        ;          }
                        ;        else
        GOTO  m008
                        ;          {
                        ;            LED3=0;
m007    BCF   0x03,RP0
        BCF   0x03,RP1
        BCF   0x07,LED3
                        ;            LED4=0;            
        BCF   0x07,LED4
                        ;          }
                        ;
                        ;        if (S4)
m008    BCF   0x03,RP0
        BCF   0x03,RP1
        BTFSS 0x06,S4
        GOTO  m009
                        ;          {
                        ;            LED5=1;
        BSF   0x07,LED5
                        ;            LED6=1;
        BSF   0x07,LED6
                        ;          }
                        ;        else
        GOTO  m010
                        ;          {
                        ;            LED5=0;
m009    BCF   0x03,RP0
        BCF   0x03,RP1
        BCF   0x07,LED5
                        ;            LED6=0;            
        BCF   0x07,LED6
                        ;          }        
                        ;        
                        ;        if (S5)
m010    BCF   0x03,RP0
        BCF   0x03,RP1
        BTFSS 0x06,S5
        GOTO  m011
                        ;          {
                        ;            LED7=1;
        BSF   0x07,LED7
                        ;          }
                        ;        else
        GOTO  m012
                        ;          {
                        ;            LED7=0;           
m011    BCF   0x03,RP0
        BCF   0x03,RP1
        BCF   0x07,LED7
                        ;          }    
                        ;        
                        ;        if (CAN(0)>500)
m012    MOVLW 0
        CALL  CAN
        MOVLW 1
        BCF   0x03,RP0
        BCF   0x03,RP1
        SUBWF i+1,W
        BTFSS 0x03,Carry
        GOTO  m014
        BTFSS 0x03,Zero_
        GOTO  m013
        MOVLW 245
        SUBWF i,W
        BTFSS 0x03,Carry
        GOTO  m014
                        ;          {
                        ;            LED8=1;
m013    BCF   0x03,RP0
        BCF   0x03,RP1
        BSF   0x07,LED8
                        ;          }
                        ;        else
        GOTO  m004
                        ;          {
                        ;            LED8=0;           
m014    BCF   0x03,RP0
        BCF   0x03,RP1
        BCF   0x07,LED8
                        ;          }                
                        ;                
                        ;        
                        ;        
                        ;    }    
        GOTO  m004

        END


; *** KEY INFO ***

; 0x0001 P0   43 word(s)  2 % : CAN
; 0x002C P0   25 word(s)  1 % : init
; 0x0045 P0   65 word(s)  3 % : main

; RAM usage: 5 bytes (5 local), 363 bytes free
; Maximum call level: 1
;  Codepage 0 has  134 word(s) :   6 %
;  Codepage 1 has    0 word(s) :   0 %
;  Codepage 2 has    0 word(s) :   0 %
;  Codepage 3 has    0 word(s) :   0 %
; Total of 134 code words (1 %)
