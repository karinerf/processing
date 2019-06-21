import processing.serial.*;

PFont fonte2, fonte, fonte3;   // declaracao das fontes
Serial port;     // porta serial
float posicaoSX=700, xAnteriorS=200, yAnteriorS=460;      // posicao setpoint
float posicaoTX=200, xAnteriorT=200, yAnteriorT=350;      // posicao temperatura
float posicaoEX=200, xAnteriorE=200, yAnteriorE=350;      //posicao erro
float setp, setpa, setp_escala, temp, tempa, temp_escala, erro, erroa, erro_escala, zero=0, a, TEMP1, SETP1;
String[] valores;        // receber os 3 valores

void setup() {
  background(#344E5C);
  size(900, 650);
  fonte = createFont("Arial", 23);
  fonte2 = createFont("Arial", 15);
  fonte3 = createFont("Arial", 13);
  port = new Serial(this,Serial.list()[0], 115200);
  port.bufferUntil('\n'); 

   grafico();
}
void draw() {
  textFont(fonte);
  fill(255);
  strokeWeight(1);
  text("INSTITUTO FEDERAL DE MATO GROSSO - IFMT", 185, 50);
  text("MICROCONTROLADORES", 300, 80);
  text("Discentes: Alexandre Fabricio e Karine Ferreira", 200, 110);
  text("Docente: Prof. Dr. Alberto Mascarenhas", 240, 140);
  fill(1);
  textFont(fonte2);
  
  fill(255);
  text("Gráfico do erro", 395, 192);
     if(erro != erroa){
       a= erro;
       fill(#344E5C);
       noStroke();
     //  rect(238, 160, 50, 30);
       rect(140, 200, 52, 150);
       fill(255);
     //  text(erro, 233, 180);
       text(erro, 140, 279-erro);
  }
  erroa = erro;
  
  fill(255);
  text("Temperatura:             °", 450, 390);
     if(temp != tempa){
       fill(#344E5C);
       noStroke();
       rect(540, 370, 50, 30);
       fill(255);
       text(temp, 540, 390);
  }
  tempa = temp;
  
  fill(255);
  text("SetPoint:             °", 200, 390);
   if(setp != setpa){
      fill(#344E5C);
      noStroke();
      rect(262, 370, 50, 30);
      fill(255);
      text(setp, 260, 390);
  }
  setpa = setp;
  
  //linha setpoint
  stroke(#EF3D59); 
  strokeWeight(2);

  posicaoSX = posicaoSX + 1;
  if (posicaoSX >= 700)         //  volta ao inicio
  {
    posicaoSX = 200;
    xAnteriorS = 200;         // horizontal position of the graph
    grafico();
  }

  line(xAnteriorS, (560-(setp*2)), posicaoSX, (560-(setp*2))); // line(ponto inicial em x, ponto inicial em y, ponto final em x, ponto final em y);

  xAnteriorS = posicaoSX; 
  yAnteriorS = (setp_escala);
  
  //linha temp
  stroke(#EFC958); 
  strokeWeight(2);

  posicaoTX = posicaoTX + 1;
  if (posicaoTX >= 700)         //  volta ao inicio
  {
    posicaoTX = 200;
    xAnteriorT = 200;         // horizontal position of the graph
    grafico();
  }

  line(xAnteriorT, (560-(temp*2)), posicaoTX, (560-(temp*2))); // line(ponto inicial em x, ponto inicial em y, ponto final em x, ponto final em y);

  xAnteriorT = posicaoTX; 
  yAnteriorT = (temp_escala);
  
                              //linha erro
  stroke(#E17A47); 
  strokeWeight(2);

  posicaoEX = posicaoEX + 1;
  if (posicaoEX >= 700)         //  volta ao inicio
  {
    posicaoEX = 200;
    xAnteriorE = 200;         // horizontal position of the graph
    grafico();
  }

  line(xAnteriorE, (275-erro), posicaoEX, (275-erro)); // line(ponto inicial em x, ponto inicial em y, ponto final em x, ponto final em y);

  xAnteriorE = posicaoEX; 
  yAnteriorE = (erro_escala);
}
void grafico() {

  fill(#4AB19D); 
  stroke(255);
  strokeWeight(1);
  rect(200, 200, 500, 150);
  rect(200, 410, 500, 150);
  
    fill(#344E5C);
    noStroke();
    rect(140,410, 52, 155);
  for(int i=563; i>=413;i-=20){
    textFont(fonte3);
    fill(255); 
    text((563-i)/2 +"º", 166, i);
  }
}
void serialEvent (Serial porta) {

  String valorLidoSerial = porta.readStringUntil('\n');
  valorLidoSerial = trim(valorLidoSerial);
  valores = split(valorLidoSerial, ' ');
  
  setp = float(valores[1]);
  temp = float(valores[0]);
  erro = float(valores[2]);
    
  print("Valor lido = " + valorLidoSerial + " \n");
 
  setp_escala = map(setp, 0, 1023, 450, 900);
  temp_escala = map(temp, 0, 1023, 450, 900);
  erro_escala = map(erro, 0, 1023, 450, 900);

}
