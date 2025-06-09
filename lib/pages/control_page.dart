import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/design_system.dart';
import '../util/smart_device_box.dart';
import '../providers/smart_devices_provider.dart';

class ControlPage extends ConsumerStatefulWidget {
  const ControlPage({super.key});

  @override
  ConsumerState<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends ConsumerState<ControlPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final smartDevices = ref.watch(smartDevicesProvider);

    return SafeArea(
      child: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(DesignSystem.spacing20),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search devices...",
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.white.withOpacity(0.5),
                ),
                filled: true,
                fillColor: DesignSystem.backgroundLight.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(DesignSystem.radiusLarge),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: DesignSystem.spacing20),

          // Device Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignSystem.spacing20,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1 / 1.3,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: smartDevices.length,
              itemBuilder: (context, index) {
                final device = smartDevices[index];
                return SmartDeviceBox(
                  smartDeviceName: device.name,
                  iconPath: device.iconPath,
                  powerOn: device.isOn,
                  onChanged: (value) {
                    ref.read(smartDevicesProvider.notifier).toggleDevice(index);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
