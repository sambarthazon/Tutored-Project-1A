#pragma chip PIC16F886
#pragma config=0x20D4     //Bit13   Debug=1  Sans //20D4
                          //Bit12   LVP=0
                          //Bit11   FCMEN=0
                          //Bit10   IESO=0
                          //Bit9-8  BOR=00
                          //Bit7    CPD=1
                          //Bit6    CP=1
                          //Bit5    MCLRE=0    MCLR=RE3
                          //Bit4    PWRTE=1
                          //Bit3    WDTE=0     //WachDOG=0
                          //Bit2-0  FOSC=010      HS:010     Interne:100        
#pragma config reg2=0x3EFF    //Bit13-11  111
                          //Bit10-9   11
                          //Bit8      0
                          //Bit7-0    11111111

//Led --> Port of microPic
#pragma bit LED1        @ PORTC.0
#pragma bit LED2        @ PORTC.1
#pragma bit LED3        @ PORTC.2
#pragma bit LED4        @ PORTC.3
#pragma bit LED5        @ PORTC.4
#pragma bit LED6        @ PORTC.5
#pragma bit LED7        @ PORTC.6
#pragma bit LED8        @ PORTC.7

//Detector --> Port of microPic
#pragma bit S2          @ PORTB.5
#pragma bit S3          @ PORTB.4
#pragma bit S4          @ PORTB.3
#pragma bit S1          @ PORTB.2

//Program delay
void delay_ms (uns16 millisec){
  uns16 i,i2;
  for (i2 = 0; i2 < millisec; i2++)
    for(i = 0; i < 350; i++);
}

//Program of CAN
uns16 CAN(uns8 entree){     //Fonction CAN()
  uns16 i;                //Variable i : Entier non signé 16 bit
  uns8 registre, j;        //Variable registre et j : Entier non signé 8 bit
  registre = entree << 3;   //Décalage à gauche de � entree � de 3 bit 
  registre = registre+129;	//ADON= True et ADCS1 :ADCS0=10   Fosc/64
  ADCON0 = registre;	      //ADCON0 = registre
  for(j=0;j<100;j++);     //Tempo de quelques secondes
  GO = 1;                   //GO=1 Début conversion
  while (GO);             //Attendre GO=0
  i = ADRESH * 256;         //Décalage de 8 bit à gauche du résultat et stockage dans i 
  i = ADRESL + i;           //Mettre les 8 bit de poids faible dans i
  return i;               //Retour de la valeur de la conversion CAN
}

//Initialization
void init(void){
  TRISA = 0x01;
  ANSEL = 0x00;
  ANSELH = 0x00;
  PORTA = 0x00;

  TRISB = 0x3F;
  PORTB = 0x00;

  TRISC = 0x00;
  PORTC = 0x00;

  TRISE = 0x00;
  PORTE = 0x00;

  T2CON.0 = 0;
  T2CON.1 = 1;
  PR2 = 127;
  CCP1CON = 0x0C;
  CCP2CON = 0x0C;
  TMR2ON = 1;
  ADCON1 = 0x80;
}

//Program of the first motor
void PWM1 (uns16 alpha1){
  uns16 var;
  var = alpha1*PR2;
  var = var/100;
  CCPR1L = var;
}

//Program of the second motor
void PWM2 (uns16 alpha1){
  uns16 var;
  var = alpha1*PR2;
  var = var/100;
  CCPR2L = var;
}
 
//Main Program
void main(void){
  init();                  //Call of initialization
    
  while(1){
    // Declaration of var
    int RC0;
    int RC3;
       
    uns16 value;
    int avance;
    int recule;
        
    LED1 = LED2 = LED3 = LED4 = 1;
    value = CAN(0);
    value = value/20;
    avance = value+50;
    recule = 50 - value;
    
    //Conditions of detetcors
    if (S2 == 1){
      RC0=1;
      RC3=1;
      PWM1(recule);
      PWM2(recule);
      delay_ms(100);
    } else {
      RC0=1;
      PWM1(avance);
      PWM2(avance);
      RC3=1;
    }

    if (S3==1){
      RC0=0;
      RC3=0;
      PWM2(recule);
      PWM1(recule);
	    delay_ms(100);
    } else {
      RC0=1;
      PWM1(avance);
	    PWM2(avance);
      RC3=1;
    }

    if (S4==1){
      RC0=0;
      RC3=0;
      PWM2(recule);
      PWM1(recule);
	    delay_ms(100);
    } else {
      RC0=1;
      PWM1(avance);
	    PWM2(avance);
      RC3=1;
    }

    if (S1==1){
      RC0=0;
      RC3=0;
      PWM2(recule);
      PWM1(recule);
	    delay_ms(100);
    } else {
      RC0=1;
      PWM1(avance);
	    PWM2(avance);
      RC3=1;
    }
    //End of conditions 

    //Conditions of LEDs
    if (S2){
      LED1=1;
      LED2=1;
    } else{
      LED1=0;
      LED2=0;            
    }
        
    if (S3){
      LED3=1;
      LED4=1;
    } else{
      LED3=0;
      LED4=0;            
    }

    if (S4){
      LED5=1;
      LED6=1;
    } else{
      LED5=0;
      LED6=0;            
    }        
        
    if (S1){
      LED7=1;
    } else{
      LED7=0;           
    }    
        
    if (CAN(0)>500){
      LED8=1;
    } else{
      LED8=0;           
    }
    //End of conditions
  }
}