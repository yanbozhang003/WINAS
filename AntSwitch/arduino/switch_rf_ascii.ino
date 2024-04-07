/* Truth Table
 *  ***********************
 *    V1  V2  State
 *    0   0   RF1
 *    1   0   RF2
 *    0   1   RF3
 *    1   1   RF4
 */

const int V1SW1 = 9;
const int V2SW1 = 8;
const int V1SW2 = 11;
const int V2SW2 = 10;

boolean state1 = HIGH;
boolean state2 = HIGH;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(V1SW1,OUTPUT);
  pinMode(V2SW1,OUTPUT);
  pinMode(V1SW2,OUTPUT);
  pinMode(V2SW2,OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  if(Serial.available() >0){
    int c = Serial.read();
    switch (c){
      case 1:
        digitalWrite(V1SW1, LOW);
        digitalWrite(V2SW1, LOW);
        digitalWrite(V1SW2, LOW);
        digitalWrite(V2SW2, LOW);
        Serial.println("RF1");
        break;

      case 2:
        digitalWrite(V1SW1, HIGH);
        digitalWrite(V1SW2, HIGH);
        digitalWrite(V2SW1, LOW);
        digitalWrite(V2SW2, LOW);
        Serial.println("RF2");
        break;

      case 3:
        digitalWrite(V1SW1, LOW);
        digitalWrite(V1SW2, LOW);
        digitalWrite(V2SW1, HIGH);
        digitalWrite(V2SW2, HIGH);
        Serial.println("RF3");
        break;

      case 4:
        digitalWrite(V1SW1, HIGH);
        digitalWrite(V1SW2, HIGH);
        digitalWrite(V2SW1, HIGH);
        digitalWrite(V2SW2, HIGH);
        Serial.println("RF4");
        break;
    } 
  }
}
