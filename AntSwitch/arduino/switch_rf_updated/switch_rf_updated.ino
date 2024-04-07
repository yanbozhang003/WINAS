/* Truth Table
 *  ***********************
 *    V1  V2  State
 *    0   0   RF1
 *    1   0   RF2
 *    0   1   RF3
 *    1   1   RF4
 */

const int AV1 = 8;
const int AV2 = 9;
const int BV1 = 6;
const int BV2 = 7;
const int CV1 = 4;
const int CV2 = 5;
const int DV1 = 2;
const int DV2 = 3;

boolean state1 = HIGH;
boolean state2 = HIGH;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(AV1,OUTPUT);
  pinMode(AV2, OUTPUT);
  pinMode(BV1,OUTPUT);
  pinMode(BV2, OUTPUT);
  pinMode(CV1,OUTPUT);
  pinMode(CV2, OUTPUT);
  pinMode(DV1,OUTPUT);
  pinMode(DV2, OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  if(Serial.available() >0){
    int c = Serial.read();
    switch (c){
      case '1':
        digitalWrite(AV1, LOW);
        digitalWrite(AV2, LOW);
        Serial.println("RF1_A");
        break;

      case '2':
        digitalWrite(AV1, HIGH);
        digitalWrite(AV2, LOW);
        Serial.println("RF2_A");
        break;

      case '3':
        digitalWrite(AV1, LOW);
        digitalWrite(AV2, HIGH);
        Serial.println("RF3_A");
        break;

      case '4':
        digitalWrite(AV1, HIGH);
        digitalWrite(AV2, HIGH);
        Serial.println("RF4_A");
        break;
        
      case '5':
        digitalWrite(BV1, LOW);
        digitalWrite(BV2, LOW);
        Serial.println("RF1_B");
        break;

      case '6':
        digitalWrite(BV1, HIGH);
        digitalWrite(BV2, LOW);
        Serial.println("RF2_B");
        break;

      case '7':
        digitalWrite(BV1, LOW);
        digitalWrite(BV2, HIGH);
        Serial.println("RF3_B");
        break;

      case '8':
        digitalWrite(BV1, HIGH);
        digitalWrite(BV2, HIGH);
        Serial.println("RF4_B");
        break;  

      case 'a':
        digitalWrite(CV1, LOW);
        digitalWrite(CV2, LOW);
        Serial.println("RF1_C");
        break;

      case 'b':
        digitalWrite(CV1, HIGH);
        digitalWrite(CV2, LOW);
        Serial.println("RF2_C");
        break;

      case 'c':
        digitalWrite(CV1, LOW);
        digitalWrite(CV2, HIGH);
        Serial.println("RF3_C");
        break;

      case 'd':
        digitalWrite(CV1, HIGH);
        digitalWrite(CV2, HIGH);
        Serial.println("RF4_C");
        break;
        
      case 'e':
        digitalWrite(DV1, LOW);
        digitalWrite(DV2, LOW);
        Serial.println("RF1_D");
        break;

      case 'f':
        digitalWrite(DV1, HIGH);
        digitalWrite(DV2, LOW);
        Serial.println("RF2_D");
        break;

      case 'g':
        digitalWrite(DV1, LOW);
        digitalWrite(DV2, HIGH);
        Serial.println("RF3_D");
        break;

      case 'h':
        digitalWrite(DV1, HIGH);
        digitalWrite(DV2, HIGH);
        Serial.println("RF4_D");
        break;

        
      /*  
      case '0':
        state1 = !state1;
        digitalWrite(V1, state1);
        if(state1 == HIGH)
          Serial.println("V1: I");
        else
          Serial.println("V1: O");
        break;
        
      case '9':
        state2 = !state2;
        digitalWrite(V2, state2);
        if(state2 == HIGH)
          Serial.println("V2: I");
        else
          Serial.println("V2: O");
        break;
        */
    } 
  }
}
