#include <WiFi.h>
#include <PubSubClient.h>
#include <ESP32Servo.h>
#include <WiFiClientSecure.h>

// Wi-Fi and MQTT configuration
const char *ssid = "TEdata8BD8EF";                // WiFi SSID
const char *password = "21908922";                // WiFi Password
const char *mqtt_server = "d69e4464fa1a44a6986ccecfb6183926.s1.eu.hivemq.cloud"; // MQTT broker address
const int mqtt_port = 8883;                       // MQTT broker port
const char *mqtt_user = "hivemq.webclient.1723383548512"; // MQTT username
const char *mqtt_pass = "7u!6>?4fG,X5BizvNYtL";   // MQTT password

// Pin definitions
#define relayPin 2                                // Pin for controlling the water pump relay
#define garageServoPin 13                         // Pin for the garage door servo motor
#define IRPin 27                                  // Pin for the IR sensor
#define roofServoPin 23                           // Pin for the roof servo motor
#define flameSensorPin 34                         // Pin for the flame sensor
#define garageLEDPin 32                           // Pin for the garage LED
#define buzzerPin 33                              // Pin for the buzzer
#define lightSensorPin 36                         // Pin for the light sensor (LDR)

// Servo objects for controlling the servo motors
Servo garageServo;
Servo roofServo;

// WiFi and MQTT clients
WiFiClientSecure espClient;
PubSubClient client(espClient);

// Function to connect to WiFi
void connectToWiFi() {
  Serial.println("Connecting to WiFi...");
  WiFi.begin(ssid, password);
  // Wait until the ESP32 is connected to WiFi
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting...");
  }
  Serial.println("WiFi connected.");
}

// Function to connect to the MQTT broker
void connectToMQTT() {
  Serial.println("Connecting to MQTT...");
  // Loop until the connection is successful
  while (!client.connected()) {
    if (client.connect("ESP32Client", mqtt_user, mqtt_pass)) {
      Serial.println("Connected to MQTT broker.");
      // Subscribe to MQTT topics here, if needed
    } else {
      Serial.print("Failed to connect to MQTT broker. State: ");
      Serial.println(client.state());
      delay(2000); // Wait before retrying
    }
  }
}

// Callback function to handle incoming MQTT messages
void mqttCallback(char *topic, byte *payload, unsigned int length) {
  Serial.print("Message arrived on topic: ");
  Serial.println(topic);

  String message;
  for (int i = 0; i < length; i++) {
    message += (char)payload[i]; // Convert payload to string
  }
  Serial.print("Message: ");
  Serial.println(message);

  // Control garage LED based on the message
  if (String(topic) == "home/garage/light") {
    if (message == "on") {
      Serial.println("Turning on garage LED");
      digitalWrite(garageLEDPin, HIGH); // Turn on LED
    } else if (message == "off") {
      Serial.println("Turning off garage LED");
      digitalWrite(garageLEDPin, LOW); // Turn off LED
    }
  }

  // Control garage door servo based on the message
  if (String(topic) == "home/garage/door") {
    if (message == "open") {
      Serial.println("Opening garage door");
      garageServo.write(90); // Set servo to open position
    } else if (message == "close") {
      Serial.println("Closing garage door");
      garageServo.write(0); // Set servo to close position
    }
  }

  // Control water pump based on the message
  if (String(topic) == "home/kitchen/water") {
    if (message == "on") {
      Serial.println("Turning on water pump");
      digitalWrite(relayPin, HIGH); // Activate water pump
    } else if (message == "off") {
      Serial.println("Turning off water pump");
      digitalWrite(relayPin, LOW); // Deactivate water pump
    }
  }
}

void setup() {
  // Initialize serial communication for debugging
  Serial.begin(115200);

  // Setup pin modes for inputs and outputs
  pinMode(garageLEDPin, OUTPUT);
  pinMode(IRPin, INPUT);
  pinMode(flameSensorPin, INPUT);
  pinMode(lightSensorPin, INPUT);
  pinMode(buzzerPin, OUTPUT);
  pinMode(relayPin, OUTPUT);

  // Attach servo motors to their respective pins
  garageServo.attach(garageServoPin);
  roofServo.attach(roofServoPin);

  // Connect to Wi-Fi
  connectToWiFi();

  // Setup MQTT server and callback function
  client.setServer(mqtt_server, mqtt_port);
  client.setCallback(mqttCallback);
  espClient.setInsecure(); // Disables certificate verification for the secure client

  // Connect to MQTT broker
  connectToMQTT();
}

void loop() {
  // Ensure the client remains connected to the MQTT broker
  if (!client.connected()) {
    connectToMQTT();
  }
  client.loop(); // Process incoming MQTT messages

  // Read and print IR sensor value
  int irValue = digitalRead(IRPin);
  Serial.print("IR Sensor Value: ");
  Serial.println(irValue);

  // Read and print flame sensor value
  int flameValue = analogRead(flameSensorPin);
  Serial.print("Flame Sensor Analog Value: ");
  Serial.println(flameValue);

  // Read and print LDR (light sensor) value
  int lightValue = analogRead(lightSensorPin);
  Serial.print("LDR Value: ");
  Serial.println(lightValue);

  // Temporary test for garage LED
  digitalWrite(garageLEDPin, HIGH); // Turn on LED
  delay(1000);
  digitalWrite(garageLEDPin, LOW);  // Turn off LED
  delay(1000);

  // Temporary test for garage servo
  garageServo.write(90); // Open door
  delay(1000);
  garageServo.write(0);  // Close door
  delay(1000);

  // Flame detection logic with buzzer and water pump activation
  int flameThreshold = 500; // Adjust threshold based on testing
  if (flameValue < flameThreshold) {
    Serial.println("Flame detected! Activating buzzer and water pump.");
    digitalWrite(buzzerPin, HIGH);  // Activate buzzer
    digitalWrite(relayPin, HIGH);   // Turn on water pump for fire
  } else {
    digitalWrite(buzzerPin, LOW);   // Deactivate buzzer
    digitalWrite(relayPin, LOW);    // Turn off water pump
  }

  // Light detection logic with roof servo movement
  int lightThreshold = 500; // Adjust threshold based on testing
  if (lightValue > lightThreshold) {
    Serial.println("Light detected! Moving roof servo.");
    roofServo.write(90); // Move roof servo
  } else {
    roofServo.write(0);  // Reset roof servo
  }

  // IR sensor logic for automatic garage door operation
  if (irValue == LOW) {
    Serial.println("IR sensor triggered! Opening garage door.");
    garageServo.write(90); // Open door
  } else {
    garageServo.write(0);  // Close door
  }

  delay(2000); // Adjust delay for readability in serial monitor
}
