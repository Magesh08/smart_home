import 'package:flutter/material.dart';
import '../theme/design_system.dart';
import '../util/smart_device_box.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  final TextEditingController _searchController = TextEditingController();

  // List of smart devices
  List mySmartDevices = [
    // [smartDeviceName, iconPath, powerStatus]
    ["Smart Light", "lib/icons/light-bulb.png", true],
    ["Smart AC", "lib/icons/air-conditioner.png", false],
    ["Smart TV", "lib/icons/smart-tv.png", false],
    ["Smart Fan", "lib/icons/fan.png", false],
    ["Smart Speaker", "lib/icons/speaker.png", false],
    ["Smart Camera", "lib/icons/camera.png", false],
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void powerSwitchChanged(bool value, int index) {
    setState(() {
      mySmartDevices[index][2] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(DesignSystem.spacing20),
            child: Text(
              "Control",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignSystem.spacing20,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignSystem.spacing16,
                vertical: DesignSystem.spacing8,
              ),
              decoration: BoxDecoration(
                gradient: DesignSystem.deviceCardGradient,
                borderRadius: BorderRadius.circular(DesignSystem.radiusMedium),
                boxShadow: DesignSystem.cardShadow,
              ),
              child: Row(
                children: [
                  Icon(Icons.search_rounded, color: DesignSystem.primaryColor),
                  const SizedBox(width: DesignSystem.spacing12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Search devices...",
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                        ),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) => setState(() {}),
                    ),
                  ),
                ],
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
              itemCount: mySmartDevices.length,
              itemBuilder: (context, index) {
                return SmartDeviceBox(
                  smartDeviceName: mySmartDevices[index][0],
                  iconPath: mySmartDevices[index][1],
                  powerOn: mySmartDevices[index][2],
                  onChanged: (value) => powerSwitchChanged(value, index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
