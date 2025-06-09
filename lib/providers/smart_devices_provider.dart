import 'package:flutter_riverpod/flutter_riverpod.dart';

class SmartDevice {
  final String name;
  final String iconPath;
  final bool isOn;

  SmartDevice({
    required this.name,
    required this.iconPath,
    required this.isOn,
  });

  SmartDevice copyWith({
    String? name,
    String? iconPath,
    bool? isOn,
  }) {
    return SmartDevice(
      name: name ?? this.name,
      iconPath: iconPath ?? this.iconPath,
      isOn: isOn ?? this.isOn,
    );
  }
}

class SmartDevicesNotifier extends StateNotifier<List<SmartDevice>> {
  SmartDevicesNotifier()
      : super([
          SmartDevice(name: "Smart Light", iconPath: "lib/icons/light-bulb.png", isOn: true),
          SmartDevice(name: "Smart AC", iconPath: "lib/icons/air-conditioner.png", isOn: false),
          SmartDevice(name: "Smart TV", iconPath: "lib/icons/smart-tv.png", isOn: false),
          SmartDevice(name: "Smart Fan", iconPath: "lib/icons/fan.png", isOn: false),
          SmartDevice(name: "Smart Speaker", iconPath: "lib/icons/speaker.png", isOn: false),
          SmartDevice(name: "Smart Camera", iconPath: "lib/icons/camera.png", isOn: false),
        ]);

  void toggleDevice(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index)
          state[i].copyWith(isOn: !state[i].isOn)
        else
          state[i],
    ];
  }
}

final smartDevicesProvider =
    StateNotifierProvider<SmartDevicesNotifier, List<SmartDevice>>((ref) {
  return SmartDevicesNotifier();
}); 