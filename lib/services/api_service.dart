// lib/services/api_service.dart

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/smart_device_model.dart';

// Provider to make the ApiService available to the rest of the app
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://smart-home-jblf.onrender.com/smart_home',
      headers: {'accept': '*/*', 'Content-Type': 'application/json'},
    ),
  );

  /// GET all devices from the API.
  Future<List<SmartDevice>> getDevices() async {
    try {
      final response = await _dio.get('/devices');
      // print('response: $response');
    

      final List<dynamic> records = response.data['records'] ?? [];
      return records.map((json) => SmartDevice.fromJson(json)).toList();
    } catch (e) {
      print("Error getting devices: $e");
      rethrow;
    }
  }

  /// POST a new device to the API.
  Future<void> addDevice({
    required String deviceName,
    required String ipAddress,
  }) async {
    try {
      // --- THE FIX IS HERE ---
      // Change the keys from snake_case to camelCase to match the API documentation (curl command).
      final response = await _dio.post(
        '/devices',
        data: {
          'deviceName': deviceName, // Was 'device_name'
          'ipAddress': ipAddress, // Was 'ip_address'
        },
      );
      // The API returns 201 Created but doesn't return a single device object in the body,
      // so we don't need to parse the response here. We will refetch the list instead.
    } on DioException catch (e) {
      // It's good practice to catch DioException specifically to get more details.
      print("Error adding device: ${e.response?.data ?? e.message}");
      rethrow;
    } catch (e) {
      print("Error adding device: $e");
      rethrow;
    }
  }

  /// PUT (update) an existing device.
  Future<void> updateDevice(SmartDevice device) async {
    try {
      await _dio.put('/devices/${device.id}', data: device.toJson());
    } on DioException catch (e) {
      print(
        "Error updating device ${device.id}: ${e.response?.data ?? e.message}",
      );
      rethrow;
    } catch (e) {
      print("Error updating device ${device.id}: $e");
      rethrow;
    }
  }

  /// DELETE a device by its ID.
  Future<void> deleteDevice(String deviceId) async {
    try {
      await _dio.delete('/devices/$deviceId');
    } on DioException catch (e) {
      print(
        "Error deleting device $deviceId: ${e.response?.data ?? e.message}",
      );
      rethrow;
    } catch (e) {
      print("Error deleting device $deviceId: $e");
      rethrow;
    }
  }
}
