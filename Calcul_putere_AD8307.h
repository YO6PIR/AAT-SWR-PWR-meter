/*
inainte de un calcul de putere, avem nevoie de doua lucruri:
    1) o valoare de referinta, adica ce tensiune de iesire (volti DC) furnizeaza AD8307
la o anumita putere de transmisie (dBm)
    2) dimensiunea pasului în volti/dB la iesirea din cuplor (iesirile de putere si SWR sunt identice)
Din aceste doua valori, se poate calcula cu usurinta orice putere dorita.

Exemplu:
Puterea transmisa la 9 Watt / 39,54 dBm ... Tensiunea la iesire din cuplor = 0,95 Volt
Puterea transmisa la 0,563 Watt / 27,5 dBm ... Tensiunea la iesirea din cuplor =0,825 Volt
Marimea pasului este: 0,95 - 0,825 = 0,125V împartit la 12,04 dBm (39,54 - 27,5)
Resulta: 0,01038 V sau 10,38 mV per dBm.

De aici putem determina cu usurinta fiecare putere de transmisie:

Puterea transmisiei în dBm = 39,54 + (tensiune de iesire - 0,95) / 0,01038

Conversia puterii de transmisie de la dBm la Watt:
Putere [watt] = (10 high (dBm / 10)) / 1000
*/
//'***********************[ DC Function ]***********************************
//' Functia de calculare tensiune[V] in functie de Uadc[1024], Div_rez[0,1282] si Uref[mV]:
//' Valoarea Uref[mV] = 2651mV variabila setata la intrare in meniul setari
//' Divizorul rezistiv: Div_Rez[(r1+r2)/r2=(6,8+1)/1] = 7,8

    float Volt_masurat;                                                 //rezultatul functiei (Tensiune)
    float Step_size;                                                    //pas pentru calcul factor de putere
    float SW;                                                           //diferenta de tensiune la (10W-1W)
    float U_1W;                                                         //tensiunea in Volti la puterea de 1W
    float U_10W;                                                        //tensiunea in Volti la puterea de 10W
    unsigned int RF_power;                                              //Puterea in WATTI calculata
    float dBm_zec;                                                      //nivelul de putere in dBm
    float S10W;                                                         //variabila de calcul pentru putere
    float pow(float x,float y);                                         // Functia de calcul pentru putere
// Variabile de calibrare pentru factorul de putere stocate in EEprom
    unsigned int eeprom ADC_1W;                                         //diviziuni calibrare pt.1W
    unsigned int eeprom ADC_10W;                                        //diviziuni calibrare 10W
    unsigned int eeprom Uref;                                           //tensiunea de referinta uC pe terminalul Uref <21>
    float eeprom S10W_cal;                                              //valoarea memorata a U_10W dupa efectuarea calibrarii
    float eeprom Step_size_cal;                                         //val.memorata a pasului dupa calibrare
//Functia de calcul a tensiunii, rezultatul in [mV]
void Tensiune(unsigned int Uref , float Div_rez ,unsigned int Uadc)     //Tensiunea (as float)
    {
    Volt_masurat = (unsigned int)(Uref / 1023) * (Uadc / Div_rez);      //Ex: '2,5*7979.71= 19949,275
    }
// Functia de calibrare a puterii masurate in functie de [ADC_1W , ADC_10W]
void Cal_power(unsigned int ADC_1W , unsigned int ADC_10W)              //Functia de (Calibrare Putere)
    {
    Tensiune(Uref , 1 , ADC_1W);                                        // masoara tensiunea in functie de ADC la 1 Watt
    U_1W = Volt_masurat;                                                //preia valoarea masurata pt calcule
    Tensiune(Uref , 1 , ADC_10W);                                       // masoara tensiunea in functie de ADC la 10 Watt
    U_10W = Volt_masurat;                                               // preia valoarea pt.calcule
    S10W = U_10W / 1000;                                                //Conversie din [mV]-->[V]
    S10W_cal=S10W;                                                      // salveaza in EEprom
    SW = (U_10W/1000) - (U_1W/1000);                                    //calculeaza diferenta dintre tensiunile la (10W - 1W)in [V]
    Step_size = SW/(40-30);                                             //valoarea pasului de calcul  (10W - 1W)/(dBm.10W-dBm.1W)
    Step_size_cal=Step_size;                                            // memoreaza in EEprom
    }
// Functia de calcul a puterii masurate in functie de [ADC_pwr] masurat la ADC_input, PortC.0
void Putere(unsigned int ADC_pwr)                                       //Result as Integer
    {
    Tensiune(Uref , 1 , ADC_pwr);                                       //calculeaza tensiunea pe intrarea ADC
    dBm_zec = 40 + (((Volt_masurat / 1000) - S10W_cal)/Step_size_cal);  //calculeaza puterea in [dBm]
    RF_power = pow(10,(dBm_zec/10))/1000;                               //calculeaza puterea in [W] conversie in Word
    if(RF_power>999) RF_power=999;                                      //puterea maxima masurata limitata la 999W!
    }
