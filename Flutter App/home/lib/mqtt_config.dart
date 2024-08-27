import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:mqtt_client/mqtt_server_client.dart' as mqtt;

class MQTTManager {
  mqtt.MqttServerClient? _client;

  final String broker = 'd69e4464fa1a44a6986ccecfb6183926.s1.eu.hivemq.cloud';
  final String username = 'hivemq.webclient.1723383548512';
  final String password = '7u!6>?4fG,X5BizvNYtL';
  final String clientIdentifier = 'flutter_client';

  MQTTManager() {
    _client = mqtt.MqttServerClient.withPort(broker, clientIdentifier, 8883);
    _client!.logging(on: true);
    _client!.onConnected = onConnected;
    _client!.onDisconnected = onDisconnected;
    _client!.onSubscribed = onSubscribed;
    _client!.onSubscribeFail = onSubscribeFail;
    _client!.onUnsubscribed = onUnsubscribed;
  }

  void connect() async {
    _client!.connectionMessage = mqtt.MqttConnectMessage()
        .withClientIdentifier(clientIdentifier)
        .authenticateAs(username, password)
        .withWillTopic('willtopic')
        .withWillMessage('My Will message')
        .startClean()
        .withWillQos(mqtt.MqttQos.atMostOnce);

    try {
      await _client!.connect();
    } catch (e) {
      print('Exception: $e');
      disconnect();
    }
  }

  void disconnect() {
    _client!.disconnect();
  }

  void publishMessage(String topic, String message) {
    final builder = mqtt.MqttClientPayloadBuilder();
    builder.addString(message);
    _client!.publishMessage(topic, mqtt.MqttQos.atLeastOnce, builder.payload!);
  }

  void subscribeToTopic(String topic) {
    _client!.subscribe(topic, mqtt.MqttQos.atLeastOnce);
  }

  // Callbacks for MQTT
  void onConnected() {
    print('Connected');
  }

  void onDisconnected() {
    print('Disconnected');
  }

  void onSubscribed(String topic) {
    print('Subscribed to $topic');
  }

  void onSubscribeFail(String topic) {
    print('Failed to subscribe $topic');
  }

  void onUnsubscribed(String? topic) {
    print('Unsubscribed to $topic');
  }
}
