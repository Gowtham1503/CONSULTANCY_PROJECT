#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#include <SoftwareSerial.h>

#define rxPin 2
#define txPin 3
SoftwareSerial sim800L(rxPin, txPin);

int gas_read=0;

const int THRESHOLD_PPM = 250;
boolean fire_flag = false;
LiquidCrystal_I2C lcd(0x27, 16, 2);

#define gas A0
#define Sensor 8
#define Buzzer 10
#define LED 6

void setup() {
  pinMode(Sensor ,INPUT);
  pinMode(gas ,INPUT);
  pinMode(LED , OUTPUT);
  pinMode(Buzzer, OUTPUT);
  Serial.begin(115200);
  sim800L.begin(9600);

  lcd.init();
  lcd.backlight();
  Serial.println("Initializing...");
  sim800L.println("AT");
  delay(1000);
  sim800L.println("AT+CMGF=1");
  delay(1000);
}

void send_sms(String text) {
  Serial.println("sending sms....");
  delay(50);
  sim800L.print("AT+CMGF=1\r");
  delay(1000);
  sim800L.print("AT+CMGS=\+917010677499\"\r");
  delay(1000);
  sim800L.print(text);
  delay(100);
  sim800L.write(0x1A);
  delay(5000);
  Serial.println("Message sent..");  
}

void make_call() {
  Serial.println("calling....");
  sim800L.println("ATD+917010677499;");
  delay(20000);
  sim800L.println("ATH");
  delay(1000);
}


void loop() {
  while (sim800L.available()) {
    Serial.println(sim800L.readString());
  }

  Serial.print("PPM: ");

  gas_read = analogRead(gas);
  Serial.println(gas_read);
  delay(300);
  if( gas_read >= 500)
  {
    digitalWrite(LED, HIGH);
    digitalWrite(Buzzer, HIGH);  
    delay(1000);
    send_sms("Gas Leackage Detected!!....");  
    make_call();
  }
  else{
    digitalWrite(LED, LOW);
    digitalWrite(Buzzer, LOW);
  }

  bool value = digitalRead(Sensor);
    Serial.println(value);

  Serial.println(value);
  delay(1000);

  if (value == 0) {
    digitalWrite(LED, HIGH);
    digitalWrite(Buzzer, HIGH);
    delay(1000);
    if (fire_flag == 0) {
      Serial.println("Fire Detected.");
      fire_flag == 1;
      send_sms("Fire.....!!");
      make_call();
    }
  } else {
    digitalWrite(LED, LOW);
    digitalWrite(Buzzer, LOW);
    fire_flag = 0;
  }
}
int analogToPPM(int analogValue) {
  return analogValue;
}
