#define READ_PIN 7
int ir_out = 2;
int led = 13;

unsigned int data[] = {897,449,55,57,54,168,54,57,54,57,54,57,54,56,55,57,54,168,54,169,54,57,55,168,55,168,55,56,55,168,55,169,54,57,54,168,54,168,54,168,55,169,54,168,54,168,55,57,54,168,55,57,54,57,54,56,55,57,54,57,54,58,54,169,54,57,54,4100,897,224,55,9582,898,222,55};
int last = 0;
unsigned long us = micros();
 
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
   pinMode(ir_out, OUTPUT);
  pinMode(led, OUTPUT);
}

// dataからリモコン信号を送信
void sendSignal() {
  int dataSize = sizeof(data) / sizeof(data[0]);
  for (int cnt = 0; cnt < dataSize; cnt++) {
    unsigned long len = data[cnt]*10;  // dataは10us単位でON/OFF時間を記録している
    unsigned long us = micros();
    do {
      digitalWrite(ir_out, 1 - (cnt&1)); // cntが偶数なら赤外線ON、奇数ならOFFのまま
      delayMicroseconds(8);  // キャリア周波数38kHzでON/OFFするよう時間調整
      digitalWrite(ir_out, 0);
      delayMicroseconds(7);
    } while (long(us + len - micros()) > 0); // 送信時間に達するまでループ
  }
}

void loop() {
  int num = analogRead(0);
  
  // put your main code here, to run repeatedly:
  if(Serial.available() > 0)
  {
    int data = Serial.read();
   if(data == 'a')
   {
    if(num < 650)
    {//点灯時
      sendSignal();
      delay(100);
      sendSignal();
    }
    else if(num > 700)
    {//消灯時
      sendSignal();
    }
   }
  }
}

