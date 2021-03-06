/*****************************************************
This program was produced by the
CodeWizardAVR V3.14 Advanced
� Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : AAT-SWR-PWR meter
Version : 10.2020
Date    : 14.10.2020
Author  : Chiorean Ovidiu
Company : YO6PIR
Comments: Program refacut dupa criterii personale
incorporeaza bargraf cu doua randuri compactate pe o linie de LCD, dupa varianta de la SWR11 Ver.2

Chip type           : ATmega8A
Clock frequency     : 8,000000 MHz INT_OSC
*****************************************************/
#include <mega8.h>
#include <math.h>                                       //rutina de calcule matematice exponentiale
#include <lcd.h>
#include <delay.h>
#include <Calcul_putere_AD8307.h>                       //rutina de calculare a tensiunii, Puterea in [dBm] si [W] si Calibrare
// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x12 ;PORTD
#endasm

#define K1_relay            PORTD.3
#define PWR_input           PORTC.0
#define ON                  1
#define OFF                 0
#define L_clk               PORTC.3
#define L_data              PORTC.4
#define C_clk               PORTC.5
#define C_data              PORTC.4
#define SHIFT_register      8
#define C_steps_coarse      32
#define L_steps_coarse      32
#define DELAY_MANUAL_TUNING 200
#define DELAY_AFTER_RELAY   13
#define DELAY_BEFORE_RELAY  5
#define DELAY_SET_RELAY     20
//	---------- ADCSRA ----------
#define ADC_INIT		0b10010111
/*                        |||||\|/________ PRESCALER - Fclk / 128
                          |||||___________ ADIE interupt enable - DISABLE
                          |||\____________ ADIF complete convertion flag -CLEAR
                          ||\_____________ ADFR free runing mode - DISABLE
						  |\______________ ADSC start convertion - DISABLE
                          \_______________ ADEN enable ADC - ENABLE */

#define ADC_START_CONVERTION	0b11010101
/*                                |||||\|/_PRESCALER - Fclk / 32
                                  |||||____ADIE interupt enable - DISABLE
                                  |||\_____ADIF complete convertion flag -CLEAR
                                  ||\______ADFR free runing mode - DISABLE
						          |\_______ADSC start convertion - ENABLE
                                  \________ADEN enable ADC - ENABLE*/
#define ADC_FLAG_READY		0b00010000
//                               \_________ADIF complete convertion flag -CHECK
//---------------- ADMUX   -------
#define ADC_CHANELL_Vrew	0b01000010	   //PortC.2 -Reflectata
#define ADC_CHANELL_Vfwd	0b01000001	   //PortC.1 -Directa
#define ADC_CHANELL_Pwr     0b01000000     //PortC.0 -Putere
//                            \|___________tensiunea de referinta Vcc cu cond ext.la Vref

#define BUTON_C_UP          PINB.6
#define BUTON_C_DOWN		PINB.1
#define BUTON_TUNE_SWR		PINB.5
#define BUTON_L_UP			PINB.0
#define BUTON_L_DOWN		PINB.7
#define BUTON_MODE			PINB.2
#define BUTON_BAND_UP		PINB.3
#define BUTON_BAND_DOWN		PINB.4

unsigned long Vfwd;                        //tensiunea citita pe intrarea Dir
unsigned long Vrew;                        //tensiunea citita pe intrarea Ref
unsigned long swr;                         //valoarea SWR calculata
unsigned int Pwr, Pwr_old=0;                          //tensiunea de la AD8507 citita pe intrarea PWR_input
//caracterul F/R miniatura care precede bargraful
char flash char0 [ 8 ] =
        {
        0b10011100,
        0b10011000,
        0b10010000,
	    0b10000000,
        0b10011000,
        0b10010100,
        0b10011000,
        0b10010100
        };
//Spatiu gol fara semnal doua rand.pct
char flash char1 [ 8 ] =
        {
        0b10000000,
        0b10000000,
        0b10010101,
        0b10000000,
	    0b10000000,
        0b10000000,
        0b10010101,
        0b10000000
        };
//Sus plin, jos gol
char flash char2 [ 8 ] =
        {
        0b10000000,
	    0b10010101,
        0b10010101,
        0b10010101,
        0b10000000,
        0b10000000,
        0b10010101,
        0b10000000
        };
//Sus gol, Jos plin
char flash char3 [ 8 ] =
        {
        0b10000000,
	    0b10000000,
        0b10010101,
        0b10000000,
        0b10000000,
        0b10010101,
        0b10010101,
        0b10010101
        };
//Sus plin, Jos plin
char flash char4 [ 8 ] =
        {
        0b10000000,
	    0b10010101,
        0b10010101,
        0b10010101,
        0b10000000,
        0b10010101,
        0b10010101,
        0b10010101
        };

unsigned char eeprom DELAY_BEFORE_ADC = 20 ;
unsigned eeprom  Band_selector;
unsigned eeprom Ind_min[11]={1,1,1,1,1,1,1,1,1,1,1};        //Inductor minim initial pe fiecare banda (11 benzi de frecventa)
unsigned eeprom Cap_min[11]={1,1,1,1,1,1,1,1,1,1,1};                                     //Capacitor minim initial pe fiecare banda
unsigned eeprom k1_min[11]={1,1,1,1,1,1,1,1,1,1,1};
unsigned long eeprom swr_min[11]={102,102,102,102,102,102,102,102,102,102,102};             // SWR minim initial pe fiecare banda
unsigned C = 0, L = 0, sweep_relay= 0;
//unsigned int t=0;
unsigned send=0;                            //variabila de sistem folosita la selectia transmisiei seriale 0=semd_C; 1=send_L; 2=sendLC;
char const L_table_coarsie[32] = {0, 1, 2, 4, 5, 8, 11, 14, 18, 23, 28, 33, 39, 46, 53, 60, 68, 77, 86, 95, 105, 116, 127, 138, 150, 163, 176, 189, 203, 218, 233, 248 };
char const C_table_coarsie[32] = {0, 1, 2, 4, 5, 8, 11, 14, 18, 23, 28, 33, 39, 46, 53, 60, 68, 77, 86, 95, 105, 116, 127, 138, 150, 163, 176, 189, 203, 218, 233, 248 };

//******************************** incarca caracterele speciale in Flash ********************************
void define_char ( char flash *pc, char char_code )
	{
    char i, a;
    a = ( char_code << 3 ) | 0x40;
    for ( i = 0; i < 8; i ++ )
        lcd_write_byte ( a ++, *pc ++);
    }
//******** rutina de transmisie date catre grupele de relee LC ***************
void Send_LC (char tmp1, char tmp)
        {
        char i;
        delay_ms ( DELAY_BEFORE_RELAY);
        if (send==0) goto Send_C;                                       //selectie transmisie numai Capacitor [C]
        for ( i=0;i< SHIFT_register; i++)
            {
            if( tmp1 & 0x80 ) L_data = ON; else L_data = OFF;
            tmp1 = tmp1 << 1;
 		    L_clk = OFF;
            delay_us (DELAY_SET_RELAY);
		    L_clk = ON;
            delay_us (DELAY_SET_RELAY);
            }
        Send_C:
        if (send==1) goto exit_do;                                      //selectie transmisie numai Inductor [L]
        for ( i=0;i< SHIFT_register; i++)
            {
            if( tmp & 0x80 ) C_data = ON; else C_data = OFF;
            tmp = tmp << 1;
 		    C_clk = 0;
            delay_us (DELAY_SET_RELAY);
		    C_clk = 1;
            delay_us (DELAY_SET_RELAY);
            }
        delay_ms ( DELAY_AFTER_RELAY);
        exit_do:
        }
//*************** Rutina de calculare SWR si citire semnale analogice ADC ************************
void Samples (void)
        {
        char i;
        Pwr = Vfwd = Vrew = 0;
		delay_ms ( DELAY_BEFORE_ADC );
        for ( i = 0; i < 1; i ++ )
                {
				ADMUX = ADC_CHANELL_Vfwd;          //GetADC(chanel 1)
                ADCSRA = ADC_START_CONVERTION;
                while ((ADCSRA & 0x10) == 1 );     //wait until adc is ready
                while ((ADCSRA & 0x10) == 0 );     //wait until adc is ready
                Vfwd = ADCW;                       //salveaza valoarea [Vfwd]
				ADMUX = ADC_CHANELL_Vrew;          //GetADC(chanel 2)
                ADCSRA = ADC_START_CONVERTION;
                while ((ADCSRA & 0x10) == 1 );     //wait until adc is ready
                while ((ADCSRA & 0x10) == 0 );     //wait until adc is ready
                Vrew =  ADCW;                      //salveaza valoarea [Vrew]
                ADMUX = ADC_CHANELL_Pwr;           //GetADC(chanel 0)
                ADCSRA = ADC_START_CONVERTION;
                while ((ADCSRA & 0x10) == 1 );     //wait until adc is ready
                while ((ADCSRA & 0x10) == 0 );     //wait until adc is ready
                Pwr =  ADCW;                       //salveaza valoarea [Pwr]
                };
	   //calculeaza valoarea VSWR in functie de valorile citite
        swr=(((Vfwd+Vrew)*100)/(Vfwd-Vrew));
        if ( ( swr > 999 ) || ( Vfwd == 0 )) swr = 999;
        if (Pwr==0) Pwr_old=0;
        }
//********************** Rutina de afisare bargraf dublu pe doua randuri ************************
//                         Versiunea preluata de la SWR11 Ver.2.2019                            *
//***********************************************************************************************
void bargraf(char Pos, char Row , char Maxbar , unsigned int Adc1 , unsigned int Adc2 )
{
    char Aplin;                           //nr.bare pline pe randul de sus
    char Bplin;                           //nr.bare pline pe randul jos
    char Aplin2;                          //nr.bare pline+1  sus
    char Bplin2;                                                    //nr.bare pline+1 jos
    char Agol ;                                                     //spatii goale sus
    char Bgol;                                                      // spatii goale jos
    char X , Y;                                                     // variabila de afisare
    unsigned int Barval_sus;                                        //val. bargraf sus
    unsigned int Barval_jos;                                        //val.bargraf jos
    unsigned int Scala;                                             //val.scala

    Scala = 1023 / Maxbar;                                          // variabila de scalare pe bargraf
    Barval_sus = Adc1 / Scala;                                      //calculeaza nr.de casute pline sus
    Aplin = Barval_sus;                                             //conversie
    Agol = Maxbar - Aplin;                                          //calculeaza nr.de casute goale sus
    Barval_jos = Adc2 / Scala;                                      //calculeaza nr.de casute pline jos
    Bplin = Barval_jos;                                             //conversie
    Bgol = Maxbar - Bplin;                                          //calculeaza nr.de casute goale jos
    Aplin2 = Aplin + 1;                                             //var.casute pline+1 sus
    Bplin2 = Bplin + 1;                                             //var.casute pline+1 jos
    lcd_gotoxy(Pos,Row);                                            //localizeaza pozitia bargrafului
    lcd_putchar(0);                                                 //afiseaza caracterul special <F/R>
    lcd_gotoxy(Pos+1,Row);                                          //localizeaza pozitia bargrafului pe ecran

     if ((Aplin) || (Bplin))                                        //daca se detecteaza semnal pe oricare canal A sau B
     {
     // 'CONDITIA No.1: A > B
     if (Aplin > Bplin)
            { //caractere egale sus-jos pana la B (cel mai mic)
            for ( X=1; X <= Bplin; X ++ ) lcd_putchar ( 4 );
            //'In continuare completeaza cu caractere pline pe A pana la nivel incepand de la B+1(bplin2)
            for ( X = Bplin2; X <= Aplin; X ++) lcd_putchar( 2 );
            //'Apoi completeaza pana la capat cu caractere goale
            for (Y = 1; Y<= Agol; Y ++) lcd_putchar( 1 );
            }
     //'CONDITIA No.2: B > A
     if (Bplin > Aplin)
            {//'caractere egale sus-jos pana la A (cel mai mic)
            for (X = 1; X<= Aplin; X ++) lcd_putchar( 4 );
            //'In continuare completeaza cu caractere pline pe B pana la nivel incepand de la A+1(aplin2)
            for (X = Aplin2; X <= Bplin; X ++)  lcd_putchar( 3 );
            //'Apoi completeaza cu casute goale pana la capat
            for (Y = 1; Y <= Bgol; Y ++) lcd_putchar( 1 );
            }
     //'CONDITIA No.3: A = B
     if (Aplin == Bplin)
            {//afiseaza ambele caractere pline
            for (X = 1; X <= Aplin; X ++)  lcd_putchar( 4 );
            //pana la nivelul lui A(ambele nivele sunt egale!)
            // 'completeaza cu casute goale pana la capat
            for (Y = 1; Y <= Agol; Y ++)  lcd_putchar( 1 );
            }
     }
     else
     {
     //'Daca nu este semnal pe niciun canal afiseaza bargraf gol pe ambele canale pana la maxim bargraf
     for (X = 1; X <= Maxbar; X ++) lcd_putchar( 1 );
     }
}
//******************** Rutina de afisare SWR in valoare numerica pe ecran *********************
void swr_out(void)
        {
        if ( swr > 900 | swr < 1 )                                              //daca SWR este mai mare de 9 sau ne-semnificativ
            {
		    lcd_putsf(">>>>");                                                  //afiseaza "HIGH" in loc de valoarea numerica
           	swr=999;
            }
        else
            {
		    if (swr/100)
		        lcd_putchar ((swr/100%10)+0x30);                                // afiseaza numar intreg
		        lcd_putsf (",");                                                // virgula
		        lcd_putchar (((swr/10)%10)+0x30);                               // prima zecimala
		        lcd_putchar ((swr%10)+0x30);                                    // a doua zecimala
            }
         }
//********* Rutina de Formatare pentru afisare analogica cu 4 cifre [0000] **************************
      bit sar;
void Formateaza( int tmp )
      {
      if (sar) goto trei_cifre;
      if (tmp/1000) lcd_putchar(tmp / 1000+0x30); else lcd_putsf(" ");          //mii sau simbolul ":" daca valoarea=0
      trei_cifre:
      if ((tmp/100)) lcd_putchar((tmp/100)%10+0x30); else lcd_putsf(" ");       //sute
      if ((tmp/10)) lcd_putchar ((tmp/10)%10+0x30); else lcd_putsf(" ");        //zeci
      lcd_putchar (tmp%10+0x30);                                                //unitati
      sar = OFF;
      }
//******************** Rutina de formatare si afisare valoare L (inductor) *************************
void l_out(char inductor)
        {
        if (sweep_relay) lcd_gotoxy(5,0); else lcd_gotoxy (0,0);
        lcd_putsf ("L");
        if (inductor/100) lcd_putchar ((inductor/100)%10+0x30); else lcd_putsf("0");
        if (inductor/10) lcd_putchar ((inductor/10)%10+0x30); else lcd_putsf("0");
        lcd_putchar (inductor%10+0x30);
        }
//******************* Rutina de formatare si afisare C (capacitor) **************************
void c_out(char capacity)
        {
        if ( sweep_relay ) lcd_gotoxy(0,0); else lcd_gotoxy ( 5, 0 );
        lcd_putsf ("C");
        if (capacity/100) lcd_putchar ((capacity/100)%10+0x30); else lcd_putsf("0");
        if (capacity/10) lcd_putchar ((capacity/10)%10+0x30); else lcd_putsf("0");
        lcd_putchar (capacity%10+0x30);
        }
void tunner(void)
        {
        swr = swr_min [ Band_selector ];                            //citeste SWR minim memorat pt.banda selectata
        C = Cap_min [ Band_selector ];                              //citeste Capacitor minim memorat pt.banda selectata
        L = Ind_min [ Band_selector ];                              //citeste Capacitor minim memorat pt.banda selectata
        sweep_relay = k1_min [ Band_selector ];                     //citeste pozitia releului pt.banda selectata
        K1_relay = sweep_relay;                                     //seteaza releul
        send=2;
        Send_LC ( L_table_coarsie [ L ],C_table_coarsie [ C ] );    //comuta releele L/C in functie de valorile L si C citite
        c_out (C_table_coarsie [ C ] );                             //afiseaza valoarea condensatorului citit
        l_out (L_table_coarsie [ L ] );                             //afiseaza valoarea inductorului citit
        lcd_gotoxy(4,0);
        lcd_putsf("-");}
//**************** Rutina de comutare a benzii de lucru ***********************
void band_out(void)
        {
        lcd_gotoxy(10,0);

		if ( Band_selector == 0 )
 			 lcd_putsf("B:3,58");
		else if ( Band_selector == 1 )
 			 lcd_putsf("B:3,70");
		else if ( Band_selector == 2 )
 			 lcd_putsf("B:7,04");
		else if ( Band_selector == 3 )
 			 lcd_putsf("B:7,10");
		else if ( Band_selector == 4 )
 			 lcd_putsf("B:10,1");
		else if ( Band_selector == 5 )
 			 lcd_putsf("B:14,0");
		else if ( Band_selector == 6 )
 			 lcd_putsf("B:14,2");
		else if ( Band_selector == 7 )
 			 lcd_putsf("B:18,1");
		else if ( Band_selector == 8 )
 			 lcd_putsf("B:21,0");
		else if ( Band_selector == 9 )
 			 lcd_putsf("B:27,2");
		else if ( Band_selector == 10 )
 			 lcd_putsf("B:28,5");
        else
            {
 			Band_selector = 1;
 			lcd_putsf("B:3,70");
            }
        tunner();                                                           //executa noile ajustari in functie de banda selectata
        }
//rutina de setare a nivelului de putere pentru [Vref, ADC_1W, ADC_10W]
#include <setari.h>
//*****************************************************************************************
//**************************** RUTINA PRINCIPALA DE PROGRAM  ******************************
//*****************************************************************************************
void main(void)
        {
        DDRB = 0b00000000;  //configure PortB intrari
        PORTB = 0b11111111;  //pull-up PortB pt butoane
        DDRC =  0b11111000;  //configure PortC(0,1,2) intrari, restul (3,4,5,6,7)iesiri
        DDRD =  0b11111111;  //configure portD iesiri

        lcd_init(16);
        lcd_clear();
        lcd_putsf("AAT-SWR-PWRmeter");
        lcd_putsf(" YO6PIR-2020(C) ");
        delay_ms(2000);
        if (! BUTON_TUNE_SWR) setari();                                  //daca se apasa butonul TUNE se intra in setari
        lcd_clear();
        define_char ( char0, 0 );
        define_char ( char1, 1 );
        define_char ( char2, 2 );
        define_char ( char3, 3 );
        define_char ( char4, 4 );
        goto StandBy_Menu;
        // Verifica apasarea butonului TUNE
        tune_swr_key:
                         delay_ms(300);
                         if ( BUTON_TUNE_SWR )
                                {
                                lcd_gotoxy(12,1);
                                lcd_putsf("    ");
                                band_out();
                                goto StandBy_Menu;
                                }
                         else goto tune;

        //-----------------------------------------------------------
        // MODUL DE ACORDARE AUTOMATA - <Automatik Antenna Tunning>  |
        //-----------------------------------------------------------
        tune:
                send=2;                                                                 //seteaza ambele seturi de relee
                Send_LC ( L_table_coarsie [ L ],C_table_coarsie [ C ] );                //comuta releele L/C
                swr_min [ Band_selector ] = swr;
                while ( ! BUTON_TUNE_SWR );
                        lcd_gotoxy(10,0);
                        lcd_putsf("  AUTO");
                 for (C=0; C<32; C ++)
                        {
                        if (C==31)
                            {
                            if (sweep_relay) sweep_relay=0; else sweep_relay=1;
                            C=0;
                            }

                        for  (L=0;L<32; L ++ )
                            {
                            send=2;
                            Send_LC ( L_table_coarsie [ L ],C_table_coarsie [ C ] );    //comuta releele L/C
                            c_out ( C_table_coarsie [ C ] );                            //afiseaza valoarea C
                            l_out (L_table_coarsie [ L ] );                             //afiseaza valoarea L
                            Samples ( );                                                //verifica semnalele ADC
                            bargraf (0,1,11,Vfwd,Vrew );                                //afiseaza bargraf

                            if ( (swr_min [ Band_selector ] >= swr) && ( swr >= 100) )
                                {
                                swr_min [ Band_selector ] = swr;                        //salveaza noua valoare swr
                                swr_out();                                              //afiseaza valoarea Min. SWR
                                Cap_min [ Band_selector ] = C;                          //salveaza noua valoare C
                                Ind_min [ Band_selector ] = L;                          //salveaza noua valoare L
                                k1_min [ Band_selector ] = sweep_relay;                 //salveaza noua valoare releu KL
                                }
                            //daca se apasa scurt butonul TUNE sau SWR este mai mic de 1,09....
                            if (! BUTON_TUNE_SWR || swr == 102 ) goto StandBy_Menu;
                            }
                        }
        //------------------------------------------------------
        // MODUL DE ACORDARE MANUALA - <Manual Antenna Tunning> |
        //------------------------------------------------------
        manual:
                 while (1)
                        {
                        lcd_gotoxy(4,0);
                        lcd_putchar(0xEE);                          //afiseaza caracter special
                        lcd_gotoxy(10,0);
                        lcd_putsf("  MANU");
                        Samples ();                                 //citeste semnale analogice si calculeaza SWR
                        bargraf (0,1,11,Vfwd,Vrew );                //afiseaza bargraf pe linia 2
                        swr_out();                                  //afiseaza SWR
                        c_out( C_table_coarsie[C] );                //afiseaza valoarea C
                		l_out(L_table_coarsie[L] );                 //afiseaza valoarea L

                        if ( ! BUTON_C_UP )
                               {
                               if (C < 31) C ++; else C = 0;
                               send = 0;                                                //selecteaza releele de Condensatori
                               Send_LC ( L_table_coarsie [ L ],C_table_coarsie [ C ] ); //comuta releele L/C
                               Cap_min[ Band_selector ] = C;                            //salveaza valoarea setata in EEprom
		                       delay_ms(DELAY_MANUAL_TUNING);
                               };

                        if ( ! BUTON_C_DOWN )
                            {
                            if (C > 0) C --; else C = 31;
                            send=0;                                                     //selecteaza releele de Condensatori
                            Send_LC ( L_table_coarsie [ L ],C_table_coarsie [ C ] );    //comuta releele L/C
                            Cap_min[ Band_selector ]=C;                                 //salveaza valoarea setata in EEprom
		                    delay_ms(DELAY_MANUAL_TUNING);
                            };

                        if ( ! BUTON_L_UP )
                           {
                           if (L < 31) L ++; else L = 0;
                           send=1;                                                      //selecteaza releele de Inductori
                           Send_LC ( L_table_coarsie [ L ],C_table_coarsie [ C ] );     //comuta releele L/C
                           Ind_min[ Band_selector ]= L;                                 //salveaza valoarea setata in EEprom
		                   delay_ms(DELAY_MANUAL_TUNING);
                           };

                        if (! BUTON_L_DOWN )
                            {
                            if (L > 0) --L; else L = 31;
                            send=1;                                                     //selecteaza releele de Inductori
                            Send_LC ( L_table_coarsie [ L ],C_table_coarsie [ C ] );    //comuta releele L/C
                            Ind_min[ Band_selector ] = L;                               //salveaza valoarea setata in EEprom
		                    delay_ms(DELAY_MANUAL_TUNING);
                            };

                        if ( ! BUTON_BAND_UP )
                            {
                                do
                                {
                                if ( sweep_relay ) sweep_relay = 0; else sweep_relay = 1;
                                }
                            while ( BUTON_BAND_UP );
                            while ( ! BUTON_BAND_UP );
                            k1_min [ Band_selector ] = sweep_relay;                     //salveaza valoarea setata in EEprom
		                    K1_relay = sweep_relay;                                     //comuta releul L/C la noua valoare
                            };

                        if ( ! BUTON_MODE )
                            {
                            lcd_gotoxy(4,0);
                            lcd_putsf(" ");
                            while (! BUTON_MODE);
                            goto StandBy_Menu;
                            }
                        if ( ! BUTON_TUNE_SWR ) goto tune_swr_key;
                        }

StandBy_Menu:
        band_out();                                                 //afiseaza banda
        tunner();                                                   //acordeaza tunerul
            while (1)                                               //executa o bucla inchisa de program
                 {
        again:
                 Samples();                                         //verifica semnalele analogice
                 bargraf (0,1,11,Vfwd,Vrew );                       //afiseaza bargraf pe linia de jos HOME L
                 swr_out();                                         //afiseaza valoarea SWR
                 if ( ! BUTON_TUNE_SWR ){delay_ms(50); goto tune_swr_key;};

                 if ( ! BUTON_BAND_UP )                              //butonul BAND-UP apasat
                    {
                    if ( Band_selector < 10) Band_selector ++; else Band_selector = 0;
                    band_out();
                    while (! BUTON_BAND_UP);
                    };

                 if ( ! BUTON_BAND_DOWN )                   //butonul BAND-DOWN apasat
                    {
                    if (Band_selector > 0) Band_selector --; else Band_selector = 10;
                    band_out();
                    while (! BUTON_BAND_DOWN);
                    };

                 if (! BUTON_C_UP ){delay_ms(50); goto DirRef;}

                 if ( ! BUTON_C_DOWN ) {delay_ms(50); goto SWR11;}

                 if (! BUTON_L_UP ) {delay_ms(50); goto TunnerOff;}

                 if (! BUTON_L_DOWN ){delay_ms(50); goto DelayRelay;}

                 if ( ! BUTON_MODE ){while (! BUTON_MODE); goto manual;}
                 goto again;
        DirRef:
                    {
                    while (! BUTON_C_UP);
                        do
                        {
                        Samples ();                         //verifica semnale analogice si calc.SWR
                        lcd_gotoxy ( 0, 0 );
                        lcd_putsf ("Fwd");
                        Formateaza ( Vfwd);                 //afiseaza valoarea numerica Vfwd
                        lcd_putsf ("  Rew");
                        Formateaza ( Vrew);                 //afiseaza valoarea numerica Vref
                        bargraf (0,1,15,Vfwd,Vrew);         //bargraf pe un rand intreg
                        delay_ms(10);
                        }
                    while (  BUTON_TUNE_SWR );              //asteapta apasarea butonului <TUNE>
                    while ( ! BUTON_TUNE_SWR );              //daca butonul <TUNE> a fost apasat...
                    lcd_gotoxy ( 0, 0 );
                    lcd_putsf("                ");          //sterge caracterele afisate pe linia de sus
                    band_out();                             //afiseaza banda
                    c_out (C_table_coarsie [ C ] );         //afiseaza condensator
                    l_out (L_table_coarsie [ L ] );         //afiseaza inductor
                    goto again;
                    };
        SWR11:
                  {
                    while ( ! BUTON_C_DOWN );               //asteapta cat este apasat butonul
                    lcd_gotoxy (0,0);
                    lcd_putsf("SWR:");
                    lcd_gotoxy(8,0);
                    lcd_putsf("  P=");
                        do
                        {
                        Samples ();                       //verifica semnale analogice si calculeaza SWR
                        Putere(Pwr);                     //calculeaza puterea in functie de semnalul ADC.0
                        lcd_gotoxy(4,0);
                        swr_out();
                        lcd_gotoxy(12,0);
                        sar=ON;                          //activeaza Bitul de afisare cu 3 cifre
                        Formateaza(RF_power);            //afiseaza PUTEREA cu 3 cifre
                        lcd_putsf("W");
                        bargraf (0,1,15,Vfwd,Vrew);      //afiseaza bargraf
                        delay_ms(10);
                        }
                    while( BUTON_TUNE_SWR );              //asteapta apasarea butonului <TUNE>
                    while(! BUTON_TUNE_SWR);               //daca butonul <TUNE> a fost apasat...
                    lcd_gotoxy ( 0, 0 );
                    lcd_putsf("                ");        //sterge linia de sus HOME U
                    band_out();                           //afiseaza Banda
                    c_out (C_table_coarsie [ C ] );       //afiseaza Capacitor
                    l_out (L_table_coarsie [ L ] );       //afiseaza Inductor
                    goto again;
                    }
        TunnerOff:
                    {
                    lcd_gotoxy ( 0, 0 );
                    lcd_putsf("Tuner OFF   ");
                    send=2;
                    Send_LC(0,0);                        //relaxeaza toate  releele L/C
                    while ( ! BUTON_L_UP );
                        do
                        {
                        Samples();                       //masoara semnale analogice si calcul SWR
                        bargraf (0,1,15,Vfwd,Vrew);      //afiseaza bargraf
                        lcd_gotoxy(12,0);
                        swr_out();                       //afiseaza valoarea numerica SWR
                        delay_ms(10);
                        }
                    while (  BUTON_TUNE_SWR );           //asteapta apasarea butonului <TUNE>
                    while ( ! BUTON_TUNE_SWR );          //daca butonul <TUNE> a fost apasat...
                    lcd_gotoxy ( 0, 0 );
                    lcd_putsf("                ");        //sterge linia de sus pe afisaj
                    band_out();                           //afiseaza Banda
                    tunner();
                    goto again;
                    };
        DelayRelay:
                    {
                    lcd_gotoxy ( 0, 0 );
                    lcd_putsf("Delay Time Relay");
                    lcd_putsf("                ");
                    while ( ! BUTON_L_DOWN );
                        do
                        {
                        if ( ! BUTON_BAND_DOWN )   //
                            {
                            DELAY_BEFORE_ADC = DELAY_BEFORE_ADC - 5;
                            if (  DELAY_BEFORE_ADC < 5 )
                                {
                                DELAY_BEFORE_ADC =  5;
                                }
                            }
                        delay_ms(150);
                            if ( ! BUTON_BAND_UP )
                                {
                                DELAY_BEFORE_ADC = DELAY_BEFORE_ADC + 5;
                                if (  DELAY_BEFORE_ADC > 50 )
                                    DELAY_BEFORE_ADC =  50;
                                }
                        lcd_gotoxy ( 4, 1 );
                        Formateaza ( DELAY_BEFORE_ADC );
                        lcd_putsf(" ms");
                        }
                    while (  BUTON_TUNE_SWR );                              //asteapta apasarea butonului <TUNE>
                    while ( ! BUTON_TUNE_SWR );                             //daca butonul <TUNE> a fost apasat...
                    lcd_gotoxy ( 0, 0 );
                    lcd_putsf("                ");
                    band_out();
                    goto again;
                    };
                 }
         }
