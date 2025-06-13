// lib/providers/smart_devices_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/smart_device_model.dart';
import '../services/api_service.dart';

// 1. Define the State class
class SmartDevicesState {
  final List<SmartDevice> devices;
  final bool isLoading;
  final String? errorMessage;

  const SmartDevicesState({
    this.devices = const [],
    this.isLoading = true, // Start in loading state
    this.errorMessage,
  });

  // copyWith for immutable updates
  SmartDevicesState copyWith({
    List<SmartDevice>? devices,
    bool? isLoading,
    String? errorMessage,
  }) {
    return SmartDevicesState(
      devices: devices ?? this.devices,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage, // Allow setting error to null
    );
  }
}

// 2. The StateNotifier
class SmartDevicesNotifier extends StateNotifier<SmartDevicesState> {
  final ApiService _apiService;

  // The notifier now depends on the ApiService
  SmartDevicesNotifier(this._apiService) : super(const SmartDevicesState()) {
    // Fetch devices immediately when the provider is created
    fetchDevices();
  }

  Future<void> fetchDevices() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final devices = await _apiService.getDevices();
      state = state.copyWith(devices: devices, isLoading: false);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<void> addDevice({
    required String deviceName,
    required String ipAddress,
  }) async {
    try {
      // No need to set loading state, this is a quick action
      await _apiService.addDevice(deviceName: deviceName, ipAddress: ipAddress);
      // Refresh the list to get the new device with its ID from the server
      await fetchDevices();
    } catch (e) {
      // Optionally handle specific errors, e.g., show a snackbar
      print("Failed to add device: $e");
    }
  }

  Future<void> toggleDevice(SmartDevice deviceToToggle) async {
    // Optimistic UI update: update state immediately
    final originalState = state;
    final updatedDevice = deviceToToggle.copyWith(isOn: !deviceToToggle.isOn);

    // Update the list in the state
    state = state.copyWith(
      devices: state.devices
          .map((d) => d.id == updatedDevice.id ? updatedDevice : d)
          .toList(),
    );

    // Then, make the API call
    try {
      await _apiService.updateDevice(updatedDevice);
    } catch (e) {
      // If API call fails, revert to the original state
      state = originalState.copyWith(
        errorMessage: "Failed to update. Please try again.",
      );
    }
  }

  Future<void> deleteDevice(String deviceId) async {
    final originalDevices = state.devices;
    // Optimistic UI: remove from list immediately
    state = state.copyWith(
      devices: state.devices.where((d) => d.id != deviceId).toList(),
    );

    try {
      await _apiService.deleteDevice(deviceId);
    } catch (e) {
      // If fails, add it back and show error
      state = state.copyWith(
        devices: originalDevices,
        errorMessage: "Failed to delete device.",
      );
    }
  }
}

// 3. The final StateNotifierProvider
final smartDevicesProvider =
    StateNotifierProvider<SmartDevicesNotifier, SmartDevicesState>((ref) {
      // Pass the ApiService to the notifier
      final apiService = ref.watch(apiServiceProvider);
      return SmartDevicesNotifier(apiService);
    });
