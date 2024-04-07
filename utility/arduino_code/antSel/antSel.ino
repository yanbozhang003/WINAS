/* Truth Table
 *  ***********************
 *    V1CH2  V1CH3 V2CH2 V2CH3 combination
 *      0      0     0     1        1
 *      0      0     1     0        2
 *      0      0     1     1        3
 *    ......
 *      1      1     1     1        15
 *      0      0     0     0        16
 */
 

/*const int V1CH3 = 9;
const int V2CH3 = 8;
const int V1CH2 = 11;
const int V2CH2 = 10;*/

const int V1CH3 = 6;
const int V2CH3 = 7;
const int V1CH2 = 5;
const int V2CH2 = 4;

boolean state1 = HIGH;
boolean state2 = HIGH;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(V1CH3,OUTPUT);
  pinMode(V2CH3,OUTPUT);
  pinMode(V1CH2,OUTPUT);
  pinMode(V2CH2,OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  if(Serial.available() >0){
    int c = Serial.read();
    switch (c){
      case 1:
        digitalWrite(V1CH2, LOW);
        digitalWrite(V1CH3, LOW);
        digitalWrite(V2CH2, LOW);
        digitalWrite(V2CH3, HIGH);
        Serial.println("CBN1");
        break;

      case 2:
        digitalWrite(V1CH2, LOW);
        digitalWrite(V1CH3, LOW);
        digitalWrite(V2CH2, HIGH);
        digitalWrite(V2CH3, LOW);
        Serial.println("CBN2");
        break;

      case 3:
        digitalWrite(V1CH2, LOW);
        digitalWrite(V1CH3, LOW);
        digitalWrite(V2CH2, HIGH);
        digitalWrite(V2CH3, HIGH);
        Serial.println("CBN3");
        break;

      case 4:
        digitalWrite(V1CH2, LOW);
        digitalWrite(V1CH3, HIGH);
        digitalWrite(V2CH2, LOW);
        digitalWrite(V2CH3, LOW);
        Serial.println("CBN4");
        break;

      case 5:
        digitalWrite(V1CH2, LOW);
        digitalWrite(V1CH3, HIGH);
        digitalWrite(V2CH2, LOW);
        digitalWrite(V2CH3, HIGH);
        Serial.println("CBN5");
        break;

      case 6:
        digitalWrite(V1CH2, LOW);
        digitalWrite(V1CH3, HIGH);
        digitalWrite(V2CH2, HIGH);
        digitalWrite(V2CH3, LOW);
        Serial.println("CBN6");
        break;

      case 7:
        digitalWrite(V1CH2, LOW);
        digitalWrite(V1CH3, HIGH);
        digitalWrite(V2CH2, HIGH);
        digitalWrite(V2CH3, HIGH);
        Serial.println("CBN7");
        break;

      case 8:
        digitalWrite(V1CH2, HIGH);
        digitalWrite(V1CH3, LOW);
        digitalWrite(V2CH2, LOW);
        digitalWrite(V2CH3, LOW);
        Serial.println("CBN8");
        break;

      case 9:
        digitalWrite(V1CH2, HIGH);
        digitalWrite(V1CH3, LOW);
        digitalWrite(V2CH2, LOW);
        digitalWrite(V2CH3, HIGH);
        Serial.println("CBN9");
        break;

      case 10:
        digitalWrite(V1CH2, HIGH);
        digitalWrite(V1CH3, LOW);
        digitalWrite(V2CH2, HIGH);
        digitalWrite(V2CH3, LOW);
        Serial.println("CBN10");
        break;

      case 11:
        digitalWrite(V1CH2, HIGH);
        digitalWrite(V1CH3, LOW);
        digitalWrite(V2CH2, HIGH);
        digitalWrite(V2CH3, HIGH);
        Serial.println("CBN11");
        break;

      case 12:
        digitalWrite(V1CH2, HIGH);
        digitalWrite(V1CH3, HIGH);
        digitalWrite(V2CH2, LOW);
        digitalWrite(V2CH3, LOW);
        Serial.println("CBN12");
        break;

      case 13:
        digitalWrite(V1CH2, HIGH);
        digitalWrite(V1CH3, HIGH);
        digitalWrite(V2CH2, LOW);
        digitalWrite(V2CH3, HIGH);
        Serial.println("CBN13");
        break;

      case 14:
        digitalWrite(V1CH2, HIGH);
        digitalWrite(V1CH3, HIGH);
        digitalWrite(V2CH2, HIGH);
        digitalWrite(V2CH3, LOW);
        Serial.println("CBN14");
        break;

      case 15:
        digitalWrite(V1CH2, HIGH);
        digitalWrite(V1CH3, HIGH);
        digitalWrite(V2CH2, HIGH);
        digitalWrite(V2CH3, HIGH);
        Serial.println("CBN15");
        break;

      case 16:
        digitalWrite(V1CH2, LOW);
        digitalWrite(V1CH3, LOW);
        digitalWrite(V2CH2, LOW);
        digitalWrite(V2CH3, LOW);
        Serial.println("CBN16");
        break;
    } 
  }
}
