#include <WiFi.h>             
#include <Wire.h>              
#include <LiquidCrystal_I2C.h> 
#include <HX711.h>             // Library for the HX711 load cell amplifier
#include <Keypad.h>            
#include <ESP32Servo.h>        
#include <PubSubClient.h>      
#include <WiFiClientSecure.h>  
// Wi-Fi credentials
const char *ssid = "Redmi Note 9S"; // Your Wi-Fi SSID
const char *password = "12345678";  // Your Wi-Fi password

// MQTT broker settings
const char *mqtt_server = "d69e4464fa1a44a6986ccecfb6183926.s1.eu.hivemq.cloud"; // MQTT broker URL
const int mqtt_port = 8883;                                                      // MQTT broker port
const char *mqtt_user = "hivemq.webclient.1723383548512";                        // MQTT username
const char *mqtt_pass = "7u!6>?4fG,X5BizvNYtL";                                  // MQTT password

// GPIO pins for components
const int homeDoorServoPin = 23;  // GPIO pin connected to the home door servo
const int homeLEDPin = 33;        // GPIO pin connected to the home LED
const int outdoorLEDPin1 = 25;    // GPIO pin connected to the first outdoor LED
const int outdoorLEDPin2 = 26;    // GPIO pin connected to the second outdoor LED
const int LOADCELL_DOUT_PIN = 18; // Data pin for the load cell
const int LOADCELL_SCK_PIN = 19;  // Clock pin for the load cell
const int soundSensorPin = 34;    // Analog pin connected to the sound sensor

// Keypad setup
const byte ROWS = 4;      // Number of rows in the keypad
const byte COLS = 4;      // Number of columns in the keypad
char keys[ROWS][COLS] = { // Keymap of the keypad
    {'1', '2', '3', 'A'},
    {'4', '5', '6', 'B'},
    {'7', '8', '9', 'C'},
    {'*', '0', '#', 'D'}};
byte rowPins[ROWS] = {27, 12, 13, 14};                                  // GPIO pins connected to the rows of the keypad
byte colPins[COLS] = {5, 2, 15, 4};                                     // GPIO pins connected to the columns of the keypad
Keypad keypad = Keypad(makeKeymap(keys), rowPins, colPins, ROWS, COLS); // Initializing the keypad

// HX711 and LCD initialization
HX711 scale;                        // Creating an object for the HX711 load cell amplifier
LiquidCrystal_I2C lcd(0x27, 16, 2); // Creating an object for the LCD with I2C address 0x27 and 16x2 size
Servo homeDoorServo;                // Creating an object for the home door servo motor

// Wi-Fi and MQTT clients
WiFiClientSecure espClient;     // Creating a secure Wi-Fi client
PubSubClient client(espClient); // Creating an MQTT client

// Threshold and password
const float weightThreshold = 0.0; // Example threshold value in grams for the load cell
String password1 = "C";            // Password for keypad access
String enteredPassword = "";       // String to store entered password

// MQTT topics
const char *homeDoorStatusTopic = "home/door/status";          // MQTT topic for home door status
const char *homeLEDStatusTopic = "home/led/status";            // MQTT topic for home LED status
const char *outdoorLEDStatusTopic = "home/outdoor_led/status"; // MQTT topic for outdoor LED status

// Variables for sound sensor
int soundSensorValue = 0;     // Variable to store sound sensor readings
bool homeLightStatus = false; // Tracks the state of the home light

// Function to connect to Wi-Fi
void setup_wifi()
{
  delay(10);
  Serial.print("Connecting to ");
  Serial.println(ssid);

  WiFi.begin(ssid, password); // Start Wi-Fi connection

  while (WiFi.status() != WL_CONNECTED) // Wait until connected
  {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP()); // Print the IP address
}

// Function to handle incoming MQTT messages
void callback(char *topic, byte *payload, unsigned int length)
{
  String messageTemp;
  for (int i = 0; i < length; i++)
  {
    messageTemp += (char)payload[i]; // Convert payload to a string
  }

  // Handle specific topics
  if (String(topic) == homeDoorStatusTopic)
  {
    if (messageTemp == "open")
    {
      homeDoorServo.write(90); // Open home door
    }
    else if (messageTemp == "close")
    {
      homeDoorServo.write(0); // Close home door
    }
  }
  else if (String(topic) == homeLEDStatusTopic)
  {
    if (messageTemp == "on")
    {
      homeLightStatus = true;
      digitalWrite(homeLEDPin, HIGH);    // Turn on home LED
      digitalWrite(outdoorLEDPin1, LOW); // Turn off outdoor LED 1
      digitalWrite(outdoorLEDPin2, LOW); // Turn off outdoor LED 2
    }
    else if (messageTemp == "off")
    {
      homeLightStatus = false;
      digitalWrite(homeLEDPin, LOW);      // Turn off home LED
      digitalWrite(outdoorLEDPin1, HIGH); // Turn on outdoor LED 1
      digitalWrite(outdoorLEDPin2, HIGH); // Turn on outdoor LED 2
    }
  }
}

// Function to reconnect to MQTT if disconnected
void reconnect()
{
  while (!client.connected())
  {
    Serial.print("Attempting MQTT connection...");
    if (client.connect("ESP32_Client_2", mqtt_user, mqtt_pass))
    {
      Serial.println("connected");
      client.subscribe(homeDoorStatusTopic); // Subscribe to home door status topic
      client.subscribe(homeLEDStatusTopic);  // Subscribe to home LED status topic
    }
    else
    {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      delay(5000); // Wait before retrying
    }
  }
}

void setup()
{
  Serial.begin(115200); // Initialize serial communication for debugging

  // Initialize Wi-Fi
  setup_wifi();

  // Initialize HX711 (load cell)
  scale.begin(LOADCELL_DOUT_PIN, LOADCELL_SCK_PIN); // Start the load cell
  scale.set_scale();                                // Set scale factor to default
  scale.tare();                                     // Tare the scale

  // Initialize LCD
  lcd.init();      // Initialize the LCD
  lcd.backlight(); // Turn on the backlight
  lcd.clear();     // Clear the LCD screen

  // Attach the servo motor
  homeDoorServo.attach(homeDoorServoPin); // Attach the servo to the specified pin
  homeDoorServo.write(0);                 // Keep the door closed initially

  // Setup pin modes
  pinMode(homeLEDPin, OUTPUT);        // Set the home LED pin as an output
  pinMode(outdoorLEDPin1, OUTPUT);    // Set the outdoor LED 1 pin as an output
  pinMode(outdoorLEDPin2, OUTPUT);    // Set the outdoor LED 2 pin as an output
  digitalWrite(homeLEDPin, LOW);      // Start with the home LED off
  digitalWrite(outdoorLEDPin1, HIGH); // Start with outdoor LED 1 on
  digitalWrite(outdoorLEDPin2, HIGH); // Start with outdoor LED 2 on

  // Initialize the sound sensor pin
  pinMode(soundSensorPin, INPUT); // Set the sound sensor pin as an input

  // Initialize MQTT
  client.setServer(mqtt_server, mqtt_port); // Set the MQTT broker
  client.setCallback(callback);             // Set the MQTT callback function

  // Setup SSL connection
  espClient.setInsecure(); // Use an insecure connection (no verification of SSL/TLS certificates)
}

void loop()
{
  if (!client.connected()) // Reconnect to MQTT if disconnected
  {
    reconnect();
  }
  client.loop(); // Maintain the connection to the MQTT broker

  // Handle weight sensor (load cell)
  float weight = scale.get_units(); // Get the weight in grams
  if (weight < 0)
  {
    weight = weight * -1; // Convert negative weight to positive (if necessary)
  }
  Serial.print("Weight: ");
  Serial.println(weight);

  // Display couch status based on weight
  lcd.clear();
  lcd.setCursor(0, 0);

  if (weight > weightThreshold) // Check if the weight exceeds the threshold
  {
    lcd.print("Couch occupied");
    client.publish("home/couch/status", "occupied"); // Publish to MQTT topic
  }
  else
  {
    lcd.print("Couch empty");
    client.publish("home/couch/status", "empty"); // Publish to MQTT topic
  }

  // Handle sound sensor
  soundSensorValue = analogRead(soundSensorPin); // Read the sound sensor value
  Serial.print("Sound Level: ");
  Serial.println(soundSensorValue);

  // Check for sound levels (use as needed for additional functionality)

  delay(500); // Small delay to avoid rapid MQTT publishing

  // Handle keypad input
  char key = keypad.getKey();
  if (key)
  {
    Serial.println(key);
    enteredPassword += key; // Add key to the entered password
    lcd.clear();
    lcd.print("Enter Password:");
    lcd.setCursor(0, 1);
    lcd.print(enteredPassword);

    // If correct password entered
    if (enteredPassword == password1)
    {
      lcd.clear();
      lcd.print("Welcome!");
      client.publish("home/keypad/access", "granted"); // Publish to MQTT topic
      delay(2000);
      enteredPassword = ""; // Reset the entered password after success
    }
    // If '*' is pressed, clear the entered password
    else if (key == '*')
    {
      enteredPassword = ""; // Reset the entered password
      lcd.clear();
      lcd.print("Password cleared");
      delay(1000);
    }
  }
}
