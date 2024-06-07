#include <Wire.h>
#include <Adafruit_MLX90614.h>
#include <WiFi.h>
#include "PubSubClient.h"
#include <ESP32Servo.h>
#include <ezButton.h>
#include <HTTPClient.h>

// Pengaturan MLX90614
Adafruit_MLX90614 mlx = Adafruit_MLX90614();

// Pengaturan WiFi dan MQTT
WiFiClient wifiClient;
PubSubClient mqttClient(wifiClient);

const char* ssid = "ssid";
const char* password = "password";
char *mqttServer = "broker.hivemq.com";
int mqttPort = 1883;
char* clientId = "catfeeder";

#define SENSOR_PIN 18
int currentState;

Servo myServo;
int servoPin = 12;

ezButton button(14);
int servoAngle = 0;
unsigned long lastButtonPress = 0;
unsigned long lastDataSendTime = 0;
const unsigned long dataSendInterval = 600000;

void callback(char* topic, byte* message, unsigned int length) {
  Serial.print("Callback - Topic:");
  Serial.println(topic);
  
  Serial.print("Pesan:");
  for (int i = 0; i < length; i++) {
    Serial.print((char)message[i]);
  }
  
  if (strcmp(topic, "control_servo_iot_d2") == 0) {
    if ((char)message[0] == '1') {
      Serial.println("Menerima pesan untuk menggerakkan servo");
      moveServo(180);
      sendServoData();
      moveServo(0);
    }
  }
}

void sendServoData() {
  String apiUrl = "https://kelompokd2iot.000webhostapp.com/petfeeder/api/insertservo.php";
  
  HTTPClient http;
  http.begin(apiUrl);

  int httpCode = http.GET();
  if (httpCode > 0) {
    Serial.printf("HTTP GET request berhasil (Servo), kode status: %d\n", httpCode);

    if (httpCode == HTTP_CODE_OK) {
      Serial.println("Data servo berhasil dimasukkan ke dalam database.");
    } else {
      Serial.println("Gagal memasukkan data servo ke dalam database.");
    }
  } else {
    Serial.printf("HTTP GET request gagal (Servo), kode status: %d\n", httpCode);
  }

  http.end();
}

void setup() {
  Serial.begin(115200);

  Wire.begin(22, 21);

  if (!mlx.begin()) {
    Serial.println("Sensor MLX90614 tidak ditemukan. Periksa koneksi dan alamat sensor.");
    while (1);
  }

  Serial.println("Sensor MLX90614 ditemukan!");

  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  } 
  Serial.println("");
  Serial.println("Terhubung ke Wi-Fi");

  setupMQTT();

  lastDataSendTime = 0;

  float tempAmbient = mlx.readAmbientTempC();
  float tempObject = mlx.readObjectTempC();
  sendData(tempAmbient, tempObject);

  pinMode(SENSOR_PIN, INPUT);

  myServo.setPeriodHertz(50);
  myServo.attach(servoPin, 1000, 2000);
}

void setupMQTT() {
  mqttClient.setServer(mqttServer, mqttPort);
  mqttClient.setCallback(callback);
}

void reconnect() {
  Serial.println("Menghubungkan ke Broker MQTT...");
  while (!mqttClient.connected()) {
    Serial.println("Menghubungkan kembali ke Broker MQTT..");
    if (mqttClient.connect(clientId)) {
      Serial.println("Terhubung.");
      mqttClient.subscribe("control_servo_iot_d2");
    } else {
      Serial.print("Gagal terhubung ke Broker MQTT, status = ");
      Serial.print(mqttClient.state());
      Serial.println(" coba lagi dalam 5 detik");
      delay(5000);
    }
  }
}

void loop() {
 if (!mqttClient.connected())
   reconnect();

 mqttClient.loop();

  float tempAmbient = mlx.readAmbientTempC();
  float tempObject = mlx.readObjectTempC();

  Serial.print("Suhu Lingkungan: ");
  Serial.print(tempAmbient);
  Serial.print(" derajat Celsius\t");

  Serial.print("Suhu Objek: ");
  Serial.print(tempObject);
  Serial.println(" derajat Celsius");

  char tempString[8];
  dtostrf(tempAmbient, 1, 2, tempString);
  mqttClient.publish("catfeeder-iot-klmpk2-datasuhulingkungan", tempString);

  dtostrf(tempObject, 1, 2, tempString);
  mqttClient.publish("catfeeder-iot-klmpk2-datasuhuhewan", tempString);

  currentState = digitalRead(SENSOR_PIN);

  Serial.print("Status Sensor Infrared: ");
  Serial.println(currentState);

  if (currentState == HIGH) {
    mqttClient.publish("catfeeder-iot-klmpk2-datainfrared", "0");
  } else {
    mqttClient.publish("catfeeder-iot-klmpk2-datainfrared", "1");
  }

  button.loop();
  if (button.isPressed()) {
    moveServo(180);
    sendServoData();
    moveServo(0);
  }

  if (millis() - lastDataSendTime >= dataSendInterval) {
    Serial.println("Mengirim data ke API...");
    sendData(tempAmbient, tempObject);
    lastDataSendTime = millis();
  }

  delay(1000);
}

void moveServo(int angle) {
  myServo.write(angle);
  delay(15);
}

void sendData(float ambient, float object) {
  String apiUrl = "https://kelompokd2iot.000webhostapp.com/petfeeder/api/insertdata.php?lingkungan=";
  apiUrl += ambient;
  apiUrl += "&hewan=";
  apiUrl += object;

  HTTPClient http;
  http.begin(apiUrl);

  int httpCode = http.GET();
  if (httpCode > 0) {
    Serial.printf("HTTP GET request berhasil, kode status: %d\n", httpCode);

    if (httpCode == HTTP_CODE_OK) {
      Serial.println("Data berhasil dimasukkan ke dalam database.");
    } else {
      Serial.println("Gagal memasukkan data ke dalam database.");
    }
  } else {
    Serial.printf("HTTP GET request gagal, kode status: %d\n", httpCode);
  }

  http.end();
}
