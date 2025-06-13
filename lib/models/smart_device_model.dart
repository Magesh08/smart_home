// lib/models/smart_device_model.dart

import 'package:flutter/material.dart';

class SmartDevice {
  final String id;
  final String deviceName;
  final String ipAddress;
  final bool isOn;
  final String iconPath; // This is generated locally

  SmartDevice({
    required this.id,
    required this.deviceName,
    required this.ipAddress,
    required this.isOn,
    required this.iconPath,
  });

  /// Factory constructor to create a SmartDevice from a JSON map.
  factory SmartDevice.fromJson(Map<String, dynamic> json) {
    String name = json['device_name'] ?? 'Unknown Device';

    return SmartDevice(
      // --- FIX: The key in your JSON is 'id', not '_id' ---
      id: json['id'] ?? '', // Use '' as a fallback to prevent null errors

      deviceName: name,

      ipAddress: json['ip_address'] ?? '0.0.0.0', // Provide a fallback
      // The API uses 'is_connected', which is mapped to 'isOn'
      isOn: json['is_connected'] ?? false,

      // The icon path is determined locally based on the device name
      iconPath: _getIconPathForDevice(name),
    );
  }

  /// Helper method to convert the SmartDevice object to a JSON map.
  /// Useful for POST/PUT requests.
  Map<String, dynamic> toJson() {
    return {
      'device_name': deviceName,
      'ip_address': ipAddress,
      'is_connected': isOn,
    };
  }

  /// Helper function to map device names to local icon asset paths.
  static String _getIconPathForDevice(String deviceName) {
    switch (deviceName.toLowerCase()) {
      case 'smart light':
      case 'smart bulb':
        return "lib/icons/light-bulb.png";
      case 'smart ac':
        return "lib/icons/air-conditioner.png";
      case 'smart tv':
        return "lib/icons/smart-tv.png";
      case 'smart fan':
        return "lib/icons/fan.png";
      case 'smart speaker':
        return "lib/icons/speaker.png";
      case 'smart camera':
        return "lib/icons/camera.png";
      case 'smart radio':
        return "lib/icons/radio.png";
      default:
        return "lib/icons/smart-device.png"; // A generic fallback icon
    }
  }

  /// Creates a copy of the current SmartDevice instance with optional new values.
  /// This is useful for immutable state management.
  SmartDevice copyWith({
    String? id,
    String? deviceName,
    String? ipAddress,
    bool? isOn,
  }) {
    final newName = deviceName ?? this.deviceName;
    return SmartDevice(
      id: id ?? this.id,
      deviceName: newName,
      ipAddress: ipAddress ?? this.ipAddress,
      isOn: isOn ?? this.isOn,
      // Recalculate icon path in case the name changed
      iconPath: _getIconPathForDevice(newName),
    );
  }
}
