/*  Rutina de setari pentru Power-Meter
    Setarea tensiunii de referinta a procesorului- Vref[5000]mV masurata pe pin <21>
    Setarea factorului de divizare la puterea masurata de 1W
    Setarea factorului de divizare la puterea de 10W
*/
void setari()
{
    lcd_clear();                                            //sterge lcd-ul
    if ( Uref > 5000 ) Uref = 4960;                         //'Valoare initiala Uref=5000mV
    ADC_1W=416;                                             //Valoare initiala de calibrare
    ADC_10W=465;                                            //Valori initiale pentru calibrare putere
    Cal_power(ADC_1W,ADC_10W);                              //executa calibrarea aparatului!
    lcd_gotoxy(0,0);                                        //Locate Home U
    lcd_putsf ("Release button! ");                         //Afiseaza text
    while (! BUTON_TUNE_SWR);                               //asteapta daca butonul mai este apasat

Ureflbl1:
    lcd_clear();                                            //sterge ecranul
    lcd_putsf (" Uref = ");
    Formateaza(Uref);                                       //afiseaza valoarea Uref de forma [5000]
    lcd_putsf ("mV  ");
    lcd_gotoxy(0,1);lcd_putsf("OFF = fact.reset");
  if (! BUTON_BAND_UP)                                      //daca se apasa butonul UP
    {
    if (Uref<5500) Uref ++;                                 //creste valoarea Uref
    }
  if(! BUTON_BAND_DOWN)                                     //daca se apasa butonul DOWN
    {
    if (Uref>4500) Uref --;                                 //descreste valoarea Uref
    }
  delay_ms (200);
  if (!BUTON_TUNE_SWR) goto ADC_1W_LBL;
  goto Ureflbl1;
//----------------------------------------------------------------------------------------------------
ADC_1W_LBL:
    while (! BUTON_TUNE_SWR);
    Samples();                                           //citeste tensiunile pe intrarile ADC
    lcd_gotoxy(0,0);                                     //Locate Home U
    lcd_putsf (" 1W level=");
    Formateaza(Pwr);                                   //afiseaza valoarea analogica ADC de pe intrarea POWER_input =(0...1023)
    lcd_putsf ("  ");
    lcd_gotoxy(0,1);                                    //Locate Home L
    lcd_putsf ("Press Button OK ");                     //afiseaza mesaj
    if (!BUTON_TUNE_SWR) goto ADC_1W_end;               //DACA SE APASA BUTONUL, trece la urmatorul meniu
    goto ADC_1W_LBL;                                    //daca nu, reia procesul din nou

ADC_1W_end:
  ADC_1W = Pwr;                                         //salveaza noua valoare in memoria EEprom
  delay_ms(200);
//-----------------------------------------------------------------------------------------
ADC_10W_LBL:
 while (! BUTON_TUNE_SWR);
    Samples();                                          //'citeste valorile pe intrarile ADC
    lcd_gotoxy(0,0);                                    //Locate Home U
    lcd_putsf (" 10W level=");
    Formateaza(Pwr);                                   //afiseaza valoarea analogica citita pe intrarea POWER_input=(0...1023)
    lcd_putsf ("  ");
    lcd_gotoxy(0,1);                                    //Locate Home L
    lcd_putsf ("Press Button OK ");
    if (!BUTON_TUNE_SWR) goto ADC_10W_end;              //DACA SE APASA BUTONUL, trece la urmatorul meniu
    goto ADC_10W_LBL;                                   //daca nu, reia procesul din nou

ADC_10W_end:
  ADC_10W = Pwr;                                       //salveaza noua valoare in memoria EEprom
  delay_ms(200);
  lcd_gotoxy(0,0);
  lcd_putsf("   ...Saved!    ");                        //afiseaza mesaj
  Cal_power(ADC_1W,ADC_10W);                            //executa calibrarea aparatului!
  delay_ms(1500);                                       //asteapta un moment pana la restart
  lcd_clear();                                          //sterge ecranul
}                                                       //si da restart.