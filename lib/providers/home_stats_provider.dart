import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeStats {
  final double temperature;
  final double humidity;
  final double voltage;
  final String climate;
  final double powerUsage;

  HomeStats({
    required this.temperature,
    required this.humidity,
    required this.voltage,
    required this.climate,
    required this.powerUsage,
  });

  HomeStats copyWith({
    double? temperature,
    double? humidity,
    double? voltage,
    String? climate,
    double? powerUsage,
  }) {
    return HomeStats(
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      voltage: voltage ?? this.voltage,
      climate: climate ?? this.climate,
      powerUsage: powerUsage ?? this.powerUsage,
    );
  }
}

class HomeStatsNotifier extends StateNotifier<HomeStats> {
  HomeStatsNotifier()
      : super(HomeStats(
          temperature: 24.5,
          humidity: 65.0,
          voltage: 220.0,
          climate: "Comfortable",
          powerUsage: 1.2,
        ));

  void updateTemperature(double value) {
    state = state.copyWith(temperature: value);
  }

  void updateHumidity(double value) {
    state = state.copyWith(humidity: value);
  }

  void updateVoltage(double value) {
    state = state.copyWith(voltage: value);
  }

  void updateClimate(String value) {
    state = state.copyWith(climate: value);
  }

  void updatePowerUsage(double value) {
    state = state.copyWith(powerUsage: value);
  }
}

final homeStatsProvider =
    StateNotifierProvider<HomeStatsNotifier, HomeStats>((ref) {
  return HomeStatsNotifier();
}); 