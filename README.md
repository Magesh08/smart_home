# 🏠 Smart Home Automation

A complete Smart Home Automation system built using **Flutter**, **Node.js**, **ESP32**, and **MQTT** message broker. This project enables real-time control and monitoring of home appliances using a mobile or web application.

## 🚀 Features

- 📱 Cross-platform Flutter app (Android, iOS, Web)
- 🌐 Backend powered by Node.js & Express
- 🔌 Device communication using MQTT protocol
- 🧠 Real-time appliance control and feedback
- 📶 ESP32-based IoT device integration
- 📊 Device status monitoring and live updates
- 🔒 Secure API access and authentication

---

## 🔧 Tech Stack

| Component        | Technology                  |
|------------------|-----------------------------|
| Frontend         | Flutter                     |
| Backend API      | Node.js + Express           |
| IoT Controller   | ESP32 (Wi-Fi enabled)       |
| Communication    | MQTT (Mosquitto Broker)     |
| Hosting          | Render / Localhost          |
| State Management | Provider / Riverpod         |

---

## 📱 Flutter App

The Flutter app serves as the user interface, allowing users to:

- View connected devices
- Toggle device states (ON/OFF)
- Monitor device statuses in real-time via MQTT

### Run App

```bash
flutter pub get
flutter run
