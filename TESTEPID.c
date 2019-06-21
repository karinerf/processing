                                   //
#include <16F877A.h>                                                          //Inclui a biblioteca do PIC <16F877A.h>
#device ADC=10                                                                //Configura conversor AD para 10 Bits
//------------------   FUSES  ------------------------------------------------//
#FUSES NOWDT                                                                  //Desativa o Whatch dog
#FUSES NOBROWNOUT                                                             //Desativa reset brownout 
#FUSES NOLVP                                                                  //No low voltage prgming, B3(PIC16) or B5(PIC18) used for I/O

#use delay(crystal=20000000)                                                  //Configura o clock para 20MHz
#use rs232(baud=115200,parity=N,xmit=PIN_C6,rcv=PIN_C7,bits=8,stream=Serial)  //COnfigura a porta serial

void Controle_PID();                                                          //Declara a função Controle PID
void Temperatura();                                                           //Função para a leitura daTemperatura
                                                     //armazena largura do pulso
int16 tempo;                                                                    //Define a variavel tempo como inteiro
int16 tempo2;                                                                 //Define a variavel tempo como inteiro
int16 tempo3;                                                                 //Define a variavel tempo como inteiro
float ADRef=5;                                                              //Define a variavel tempo como inteiro
float TempMedia = 0.0;                                                        //Armazena a temperatura em graus Celsius
float  T = 0.01;                                                        //Armazena a temperatura em graus Celsius
float  T_an = 10;                                                        //Armazena a temperatura em graus Celsius
float Erro;
float ErroAnterior;
float Setpoint = 50;      
float Kp = 100;
float SaidaAnterior;
float Saida;
boolean Gatilho=False;       
   
//  Detecção do Zero pela Interrupção Externa
#INT_EXT                                                                      //Interrupção Externa
void  EXT_isr(void)                                                           //Função interrupção externa
{   
    Gatilho=true;                                                             //Desabilita gatilho
    output_low(PIN_D2);                                                     //Desliga a saida D2
    tempo2=0;     
}
//  Interrupção Interna                                                                     //Interrupção Externa
#INT_RTCC                                                                      //função de chamada do timer 0
void  RTCC_isr(void)                                                           //a cada 100us
{
  if(Gatilho)                                                                  //Se passou pelo zero
  {
   if(tempo2++>84-Saida)                                                    //Se a contagem for maior que o gatilho
   {
      output_high(PIN_D2);                                                      //Liga a saida D1      
      Gatilho=false;                                                           //Reseta o gatilho
      tempo2=0;                                                                //Zera a contagem de tempo
   }
  }
  if(tempo++>100)                                                               //Aciona mais ou menos de segundo em segundo       10m
    {
     // Temperatura();                                                           //Calcula a temperatura a cada 500ms
      Controle_PID();
      tempo=0;                                                                 //Zera a contagem de tempo
    }      
     if(tempo3++>1000)                                                           //Aciona mais ou menos de segundo em segundo   100m     
    {
      Temperatura();                                                           //Calcula a temperatura a cada 500ms
      tempo3=0;                                                                 //Zera a contagem de tempo
    }      
}    
 
// Interrupção para dados recebebidos no buffer                                 //Interrupção Externa
void main()
   {
      setup_adc_ports(AN0);                                        //Configura as portas de entrada analógica com tensão de referência externa
      setup_adc(ADC_CLOCK_DIV_64);                                               //Configura o clock do conversor A/D                                                
      setup_timer_0(RTCC_INTERNAL|RTCC_DIV_2|RTCC_8_bit);                        //Entra na interrupção Timer0(RTCC) a cada 102 us     
      setup_timer_2(T2_DIV_BY_16,255,1);                                         //819 us overflow, 819 us interrupt
      enable_interrupts(INT_EXT);                                                //Habilita a interrupção externa
      enable_interrupts(INT_RTCC);
      enable_interrupts(INT_RDA);                                                //Habilita a interrupção de receber dados da serial
      enable_interrupts(GLOBAL);                                                 //Habilita as interrupção Global
      while(TRUE)
   {
   
    }
}
void Controle_PID()                             //Controle PID
{
    
    Erro = Setpoint - TempMedia;
    SaidaAnterior = Saida;
    Saida =Kp*(Erro+(ErroAnterior*(T_an-T))/T)+SaidaAnterior;
    
    ErroAnterior=Erro;
    if(Saida >84)Saida =84;
    if(Saida<0) Saida  =0;
}

void Temperatura()                                 //Temperatura em Celsius
{
   set_adc_channel(0);                                                  //Seleciona o Canal 0
   delay_us(40);                                                        //Aguarda 40us(Tempo para conversão AD)
   TempMedia=read_adc();
   TempMedia=(TempMedia*ADRef*100)/1024.;
   printf ("%.2f %.2f %.2f \n", TempMedia, Setpoint, Erro);
}


