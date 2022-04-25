
; CC5X Version 3.7C, Copyright (c) B Knudsen Data
; C compiler for the PICmicro family
; ************  11. Jun 2021  16:09  *************

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
T2CON       EQU   0x12
CCPR1L      EQU   0x15
CCP1CON     EQU   0x17
CCPR2L      EQU   0x1B
CCP2CON     EQU   0x1D
ADRESH      EQU   0x1E
ADCON0      EQU   0x1F
TRISC       EQU   0x87
TRISE       EQU   0x89
PR2         EQU   0x92
ADRESL      EQU   0x9E
ADCON1      EQU   0x9F
ANSEL       EQU   0x188
ANSELH      EQU   0x189
TMR2ON      EQU   2
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
S1          EQU   2
millisec    EQU   0x26
i           EQU   0x28
i2          EQU   0x2A
entree      EQU   0x26
i_2         EQU   0x27
registre    EQU   0x29
j           EQU   0x2A
alpha1      EQU   0x26
var         EQU   0x28
C1cnt       EQU   0x2A
C2tmp       EQU   0x2B
C3cnt       EQU   0x2A
C4tmp       EQU   0x2B
C5rem       EQU   0x2D
alpha1_2    EQU   0x26
var_2       EQU   0x28
C6cnt       EQU   0x2A
C7tmp       EQU   0x2B
C8cnt       EQU   0x2A
C9tmp       EQU   0x2B
C10rem      EQU   0x2D
RC0         EQU   0x20
RC3         EQU   0x21
valeur      EQU   0x22
avance      EQU   0x24
recule      EQU   0x25
C11cnt      EQU   0x26
C12tmp      EQU   0x27
C13rem      EQU   0x29

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
                        ;
                        ;
                        ;#pragma bit S2          @ PORTB.5
                        ;#pragma bit S3          @ PORTB.4
                        ;#pragma bit S4          @ PORTB.3
                        ;#pragma bit S1          @ PORTB.2
                        ;
                        ;void delay_ms (uns16 millisec)
                        ;{
delay_ms
                        ;    uns16 i,i2;
                        ;    for (i2=0;i2<millisec;i2++)
        BCF   0x03,RP0
        BCF   0x03,RP1
        CLRF  i2
        CLRF  i2+1
m001    BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  millisec+1,W
        SUBWF i2+1,W
        BTFSS 0x03,Carry
        GOTO  m002
        BTFSS 0x03,Zero_
        GOTO  m006
        MOVF  millisec,W
        SUBWF i2,W
        BTFSC 0x03,Carry
        GOTO  m006
                        ;        for(i=0;i<350;i++);
m002    BCF   0x03,RP0
        BCF   0x03,RP1
        CLRF  i
        CLRF  i+1
m003    MOVLW 1
        BCF   0x03,RP0
        BCF   0x03,RP1
        SUBWF i+1,W
        BTFSS 0x03,Carry
        GOTO  m004
        BTFSS 0x03,Zero_
        GOTO  m005
        MOVLW 94
        SUBWF i,W
        BTFSC 0x03,Carry
        GOTO  m005
m004    BCF   0x03,RP0
        BCF   0x03,RP1
        INCF  i,1
        BTFSC 0x03,Zero_
        INCF  i+1,1
        GOTO  m003
m005    BCF   0x03,RP0
        BCF   0x03,RP1
        INCF  i2,1
        BTFSC 0x03,Zero_
        INCF  i2+1,1
        GOTO  m001
                        ;}
m006    RETURN
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
m007    MOVLW 100
        BCF   0x03,RP0
        BCF   0x03,RP1
        SUBWF j,W
        BTFSC 0x03,Carry
        GOTO  m008
        INCF  j,1
        GOTO  m007
                        ;    GO=1;			//GO=1 Début conversion
m008    BCF   0x03,RP0
        BCF   0x03,RP1
        BSF   0x1F,GO
                        ;    while (GO);			//Attendre GO=0
m009    BCF   0x03,RP0
        BCF   0x03,RP1
        BTFSC 0x1F,GO
        GOTO  m009
                        ;    i=ADRESH * 256;		//Décalage de 8 bit à gauche du résultat et stockage dans i 
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  ADRESH,W
        MOVWF i_2+1
        CLRF  i_2
                        ;    i=ADRESL + i;		//Mettre les 8 bit de poids faible dans i
        BSF   0x03,RP0
        MOVF  ADRESL,W
        BCF   0x03,RP0
        ADDWF i_2,1
        BTFSC 0x03,Carry
        INCF  i_2+1,1
                        ;    return i;			//Retour de la valeur de la conversion CAN
        MOVF  i_2,W
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
                        ;    
                        ;    
                        ;    
                        ;    T2CON.0=0;
        BCF   T2CON,0
                        ;    T2CON.1=1;
        BSF   T2CON,1
                        ;    PR2=127;
        MOVLW 127
        BSF   0x03,RP0
        MOVWF PR2
                        ;    CCP1CON=0x0C;
        MOVLW 12
        BCF   0x03,RP0
        MOVWF CCP1CON
                        ;    CCP2CON=0x0C;
        MOVLW 12
        MOVWF CCP2CON
                        ;    TMR2ON=1;
        BSF   0x12,TMR2ON
                        ;    ADCON1=0x80;
        MOVLW 128
        BSF   0x03,RP0
        MOVWF ADCON1
                        ;   }
        RETURN
                        ; void PWM1 (uns16 alpha1)
                        ; {
PWM1
                        ;     uns16 var;
                        ;     var=alpha1*PR2;
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  alpha1,W
        MOVWF C2tmp
        MOVF  alpha1+1,W
        MOVWF C2tmp+1
        MOVLW 16
        MOVWF C1cnt
m010    BCF   0x03,Carry
        BCF   0x03,RP0
        BCF   0x03,RP1
        RLF   var,1
        RLF   var+1,1
        RLF   C2tmp,1
        RLF   C2tmp+1,1
        BTFSS 0x03,Carry
        GOTO  m011
        BSF   0x03,RP0
        MOVF  PR2,W
        BCF   0x03,RP0
        ADDWF var,1
        BTFSC 0x03,Carry
        INCF  var+1,1
m011    BCF   0x03,RP0
        BCF   0x03,RP1
        DECFSZ C1cnt,1
        GOTO  m010
                        ;     var=var/100;
        MOVF  var,W
        MOVWF C4tmp
        MOVF  var+1,W
        MOVWF C4tmp+1
        CLRF  C5rem
        MOVLW 16
        MOVWF C3cnt
m012    BCF   0x03,RP0
        BCF   0x03,RP1
        RLF   C4tmp,1
        RLF   C4tmp+1,1
        RLF   C5rem,1
        BTFSC 0x03,Carry
        GOTO  m013
        MOVLW 100
        SUBWF C5rem,W
        BTFSS 0x03,Carry
        GOTO  m014
m013    MOVLW 100
        BCF   0x03,RP0
        BCF   0x03,RP1
        SUBWF C5rem,1
        BSF   0x03,Carry
m014    BCF   0x03,RP0
        BCF   0x03,RP1
        RLF   var,1
        RLF   var+1,1
        DECFSZ C3cnt,1
        GOTO  m012
                        ;     CCPR1L=var;
        MOVF  var,W
        MOVWF CCPR1L
                        ; }
        RETURN
                        ; void PWM2 (uns16 alpha1)
                        ; {
PWM2
                        ;     uns16 var;
                        ;     var=alpha1*PR2;
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  alpha1_2,W
        MOVWF C7tmp
        MOVF  alpha1_2+1,W
        MOVWF C7tmp+1
        MOVLW 16
        MOVWF C6cnt
m015    BCF   0x03,Carry
        BCF   0x03,RP0
        BCF   0x03,RP1
        RLF   var_2,1
        RLF   var_2+1,1
        RLF   C7tmp,1
        RLF   C7tmp+1,1
        BTFSS 0x03,Carry
        GOTO  m016
        BSF   0x03,RP0
        MOVF  PR2,W
        BCF   0x03,RP0
        ADDWF var_2,1
        BTFSC 0x03,Carry
        INCF  var_2+1,1
m016    BCF   0x03,RP0
        BCF   0x03,RP1
        DECFSZ C6cnt,1
        GOTO  m015
                        ;     var=var/100;
        MOVF  var_2,W
        MOVWF C9tmp
        MOVF  var_2+1,W
        MOVWF C9tmp+1
        CLRF  C10rem
        MOVLW 16
        MOVWF C8cnt
m017    BCF   0x03,RP0
        BCF   0x03,RP1
        RLF   C9tmp,1
        RLF   C9tmp+1,1
        RLF   C10rem,1
        BTFSC 0x03,Carry
        GOTO  m018
        MOVLW 100
        SUBWF C10rem,W
        BTFSS 0x03,Carry
        GOTO  m019
m018    MOVLW 100
        BCF   0x03,RP0
        BCF   0x03,RP1
        SUBWF C10rem,1
        BSF   0x03,Carry
m019    BCF   0x03,RP0
        BCF   0x03,RP1
        RLF   var_2,1
        RLF   var_2+1,1
        DECFSZ C8cnt,1
        GOTO  m017
                        ;     CCPR2L=var;
        MOVF  var_2,W
        MOVWF CCPR2L
                        ; }
        RETURN
                        ; 
                        ;//Programme Principal
                        ;void main(void)
                        ;   {
main
                        ;    init();
        CALL  init
                        ;    
                        ;    while(1)
                        ;    {  
                        ;        int RC0;
                        ;        int RC3;
                        ;       
                        ;        uns16 valeur;
                        ;        int avance;
                        ;        int recule;
                        ;        
                        ;        
                        ;        LED1=1;
m020    BCF   0x03,RP0
        BCF   0x03,RP1
        BSF   0x07,LED1
                        ;        LED2=1;
        BSF   0x07,LED2
                        ;        LED3=1;
        BSF   0x07,LED3
                        ;        LED4=1;
        BSF   0x07,LED4
                        ;        valeur=CAN(0);
        MOVLW 0
        CALL  CAN
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  i_2,W
        MOVWF valeur
        MOVF  i_2+1,W
        MOVWF valeur+1
                        ;        valeur=valeur/20;
        MOVF  valeur,W
        MOVWF C12tmp
        MOVF  valeur+1,W
        MOVWF C12tmp+1
        CLRF  C13rem
        MOVLW 16
        MOVWF C11cnt
m021    BCF   0x03,RP0
        BCF   0x03,RP1
        RLF   C12tmp,1
        RLF   C12tmp+1,1
        RLF   C13rem,1
        BTFSC 0x03,Carry
        GOTO  m022
        MOVLW 20
        SUBWF C13rem,W
        BTFSS 0x03,Carry
        GOTO  m023
m022    MOVLW 20
        BCF   0x03,RP0
        BCF   0x03,RP1
        SUBWF C13rem,1
        BSF   0x03,Carry
m023    BCF   0x03,RP0
        BCF   0x03,RP1
        RLF   valeur,1
        RLF   valeur+1,1
        DECFSZ C11cnt,1
        GOTO  m021
                        ;        avance=valeur+50;
        MOVLW 50
        ADDWF valeur,W
        MOVWF avance
                        ;        recule=50-valeur;
        MOVF  valeur,W
        SUBLW 50
        MOVWF recule
                        ;                
                        ;                
                        ;         if (S2==1){
        BTFSS 0x06,S2
        GOTO  m024
                        ;            RC0=1;
        MOVLW 1
        MOVWF RC0
                        ;            
                        ;            RC3=1;
        MOVLW 1
        MOVWF RC3
                        ;           
                        ;            
                        ;            PWM1(recule);
        MOVF  recule,W
        MOVWF alpha1
        CLRF  alpha1+1
        BTFSC alpha1,7
        DECF  alpha1+1,1
        CALL  PWM1
                        ;            
                        ;            PWM2(recule);
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  recule,W
        MOVWF alpha1_2
        CLRF  alpha1_2+1
        BTFSC alpha1_2,7
        DECF  alpha1_2+1,1
        CALL  PWM2
                        ;            delay_ms(500);
        MOVLW 244
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVWF millisec
        MOVLW 1
        MOVWF millisec+1
        CALL  delay_ms
                        ;
                        ;}
                        ;        else {
        GOTO  m025
                        ;            RC0=1;
m024    MOVLW 1
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVWF RC0
                        ;            PWM1(avance);
        MOVF  avance,W
        MOVWF alpha1
        CLRF  alpha1+1
        BTFSC alpha1,7
        DECF  alpha1+1,1
        CALL  PWM1
                        ;            PWM2(avance);
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  avance,W
        MOVWF alpha1_2
        CLRF  alpha1_2+1
        BTFSC alpha1_2,7
        DECF  alpha1_2+1,1
        CALL  PWM2
                        ;            RC3=1;
        MOVLW 1
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVWF RC3
                        ;
                        ;           
                        ;            
                        ;        }
                        ;        if (S3==1){
m025    BCF   0x03,RP0
        BCF   0x03,RP1
        BTFSS 0x06,S3
        GOTO  m026
                        ;            RC0=0;
        CLRF  RC0
                        ;            
                        ;            RC3=0;
        CLRF  RC3
                        ;            
                        ;            PWM2(recule);
        MOVF  recule,W
        MOVWF alpha1_2
        CLRF  alpha1_2+1
        BTFSC alpha1_2,7
        DECF  alpha1_2+1,1
        CALL  PWM2
                        ;            PWM1(recule);
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  recule,W
        MOVWF alpha1
        CLRF  alpha1+1
        BTFSC alpha1,7
        DECF  alpha1+1,1
        CALL  PWM1
                        ;	    delay_ms(500);
        MOVLW 244
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVWF millisec
        MOVLW 1
        MOVWF millisec+1
        CALL  delay_ms
                        ;             }
                        ;        else {
        GOTO  m027
                        ;            RC0=1;
m026    MOVLW 1
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVWF RC0
                        ;            PWM1(avance);
        MOVF  avance,W
        MOVWF alpha1
        CLRF  alpha1+1
        BTFSC alpha1,7
        DECF  alpha1+1,1
        CALL  PWM1
                        ;	    PWM2(avance);
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  avance,W
        MOVWF alpha1_2
        CLRF  alpha1_2+1
        BTFSC alpha1_2,7
        DECF  alpha1_2+1,1
        CALL  PWM2
                        ;            RC3=1;
        MOVLW 1
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVWF RC3
                        ;            
                        ;        } 
                        ;         if (S4==1){
m027    BCF   0x03,RP0
        BCF   0x03,RP1
        BTFSS 0x06,S4
        GOTO  m028
                        ;            RC0=0;
        CLRF  RC0
                        ;            
                        ;            RC3=0;
        CLRF  RC3
                        ;            
                        ;            PWM2(recule);
        MOVF  recule,W
        MOVWF alpha1_2
        CLRF  alpha1_2+1
        BTFSC alpha1_2,7
        DECF  alpha1_2+1,1
        CALL  PWM2
                        ;            PWM1(recule);
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  recule,W
        MOVWF alpha1
        CLRF  alpha1+1
        BTFSC alpha1,7
        DECF  alpha1+1,1
        CALL  PWM1
                        ;	    delay_ms(500);
        MOVLW 244
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVWF millisec
        MOVLW 1
        MOVWF millisec+1
        CALL  delay_ms
                        ;            
                        ;             }
                        ;        else {
        GOTO  m029
                        ;            RC0=1;
m028    MOVLW 1
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVWF RC0
                        ;            PWM1(avance);
        MOVF  avance,W
        MOVWF alpha1
        CLRF  alpha1+1
        BTFSC alpha1,7
        DECF  alpha1+1,1
        CALL  PWM1
                        ;	    PWM2(avance);
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  avance,W
        MOVWF alpha1_2
        CLRF  alpha1_2+1
        BTFSC alpha1_2,7
        DECF  alpha1_2+1,1
        CALL  PWM2
                        ;            RC3=1;
        MOVLW 1
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVWF RC3
                        ;            
                        ;        }
                        ;         if (S1==1){
m029    BCF   0x03,RP0
        BCF   0x03,RP1
        BTFSS 0x06,S1
        GOTO  m030
                        ;            RC0=0;
        CLRF  RC0
                        ;            
                        ;            RC3=0;
        CLRF  RC3
                        ;            
                        ;            PWM2(recule);
        MOVF  recule,W
        MOVWF alpha1_2
        CLRF  alpha1_2+1
        BTFSC alpha1_2,7
        DECF  alpha1_2+1,1
        CALL  PWM2
                        ;            PWM1(recule);
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  recule,W
        MOVWF alpha1
        CLRF  alpha1+1
        BTFSC alpha1,7
        DECF  alpha1+1,1
        CALL  PWM1
                        ;	    delay_ms(500);
        MOVLW 244
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVWF millisec
        MOVLW 1
        MOVWF millisec+1
        CALL  delay_ms
                        ;             }
                        ;        else {
        GOTO  m031
                        ;            RC0=1;
m030    MOVLW 1
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVWF RC0
                        ;            PWM1(avance);
        MOVF  avance,W
        MOVWF alpha1
        CLRF  alpha1+1
        BTFSC alpha1,7
        DECF  alpha1+1,1
        CALL  PWM1
                        ;	    PWM2(avance);
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVF  avance,W
        MOVWF alpha1_2
        CLRF  alpha1_2+1
        BTFSC alpha1_2,7
        DECF  alpha1_2+1,1
        CALL  PWM2
                        ;            RC3=1;
        MOVLW 1
        BCF   0x03,RP0
        BCF   0x03,RP1
        MOVWF RC3
                        ;            
                        ;        } 
                        ;        if (S2)
m031    BCF   0x03,RP0
        BCF   0x03,RP1
        BTFSS 0x06,S2
        GOTO  m032
                        ;          {
                        ;            LED1=1;
        BSF   0x07,LED1
                        ;            LED2=1;
        BSF   0x07,LED2
                        ;          }
                        ;        else
        GOTO  m033
                        ;          {
                        ;            LED1=0;
m032    BCF   0x03,RP0
        BCF   0x03,RP1
        BCF   0x07,LED1
                        ;            LED2=0;            
        BCF   0x07,LED2
                        ;          }
                        ;        
                        ;        if (S3)
m033    BCF   0x03,RP0
        BCF   0x03,RP1
        BTFSS 0x06,S3
        GOTO  m034
                        ;          {
                        ;            LED3=1;
        BSF   0x07,LED3
                        ;            LED4=1;
        BSF   0x07,LED4
                        ;          }
                        ;        else
        GOTO  m035
                        ;          {
                        ;            LED3=0;
m034    BCF   0x03,RP0
        BCF   0x03,RP1
        BCF   0x07,LED3
                        ;            LED4=0;            
        BCF   0x07,LED4
                        ;          }
                        ;
                        ;        if (S4)
m035    BCF   0x03,RP0
        BCF   0x03,RP1
        BTFSS 0x06,S4
        GOTO  m036
                        ;          {
                        ;            LED5=1;
        BSF   0x07,LED5
                        ;            LED6=1;
        BSF   0x07,LED6
                        ;          }
                        ;        else
        GOTO  m037
                        ;          {
                        ;            LED5=0;
m036    BCF   0x03,RP0
        BCF   0x03,RP1
        BCF   0x07,LED5
                        ;            LED6=0;            
        BCF   0x07,LED6
                        ;          }        
                        ;        
                        ;        if (S1)
m037    BCF   0x03,RP0
        BCF   0x03,RP1
        BTFSS 0x06,S1
        GOTO  m038
                        ;          {
                        ;            LED7=1;
        BSF   0x07,LED7
                        ;          }
                        ;        else
        GOTO  m039
                        ;          {
                        ;            LED7=0;           
m038    BCF   0x03,RP0
        BCF   0x03,RP1
        BCF   0x07,LED7
                        ;          }    
                        ;        
                        ;        if (CAN(0)>500)
m039    MOVLW 0
        CALL  CAN
        MOVLW 1
        BCF   0x03,RP0
        BCF   0x03,RP1
        SUBWF i_2+1,W
        BTFSS 0x03,Carry
        GOTO  m041
        BTFSS 0x03,Zero_
        GOTO  m040
        MOVLW 245
        SUBWF i_2,W
        BTFSS 0x03,Carry
        GOTO  m041
                        ;          {
                        ;            LED8=1;
m040    BCF   0x03,RP0
        BCF   0x03,RP1
        BSF   0x07,LED8
                        ;          }
                        ;        else
        GOTO  m020
                        ;          {
                        ;            LED8=0;           
m041    BCF   0x03,RP0
        BCF   0x03,RP1
        BCF   0x07,LED8
                        ;          }                
                        ;                
                        ;        
                        ;        
                        ;    }    
        GOTO  m020

        END


; *** KEY INFO ***

; 0x0001 P0   45 word(s)  2 % : delay_ms
; 0x002E P0   43 word(s)  2 % : CAN
; 0x0059 P0   38 word(s)  1 % : init
; 0x007F P0   59 word(s)  2 % : PWM1
; 0x00BA P0   59 word(s)  2 % : PWM2
; 0x00F5 P0  314 word(s) 15 % : main

; RAM usage: 14 bytes (14 local), 354 bytes free
; Maximum call level: 1
;  Codepage 0 has  559 word(s) :  27 %
;  Codepage 1 has    0 word(s) :   0 %
;  Codepage 2 has    0 word(s) :   0 %
;  Codepage 3 has    0 word(s) :   0 %
; Total of 559 code words (6 %)
