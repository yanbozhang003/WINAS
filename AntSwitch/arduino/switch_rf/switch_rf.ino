/* Truth Table
 *  ***********************
 *    V1  V2  State
 *    0   0   RF1
 *    1   0   RF2
 *    0   1   RF3
 *    1   1   RF4
 */

const int V1 = 5;
const int V2 = 6;

unsigned long t1;
unsigned long t2;

boolean state1 = HIGH;
boolean state2 = HIGH;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(V1,OUTPUT);
  pinMode(V2, OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  if(Serial.available() >0){
    int c = Serial.read();
    switch (c){
      case '0':
        digitalWrite(V1, LOW);
        digitalWrite(V2, LOW);
        //Serial.println("RF1");
        break;

      case '1':
        digitalWrite(V1, HIGH);
        digitalWrite(V2, LOW);
        //Serial.println("RF2");
        break;

      case '2':
        digitalWrite(V1, LOW);
        digitalWrite(V2, HIGH);
        //Serial.println("RF3");
        break;

      case '3':
        digitalWrite(V1, HIGH);
        digitalWrite(V2, HIGH);
        //Serial.println("RF4");
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
