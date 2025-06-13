import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Import all the necessary files
import '../providers/home_stats_provider.dart';
import '../providers/smart_devices_provider.dart';
import '../theme/design_system.dart';
import '../util/smart_device_box.dart'; // Make sure this path is correct

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch both providers to get the latest data
    final smartDevicesState = ref.watch(smartDevicesProvider);
    final homeStats = ref.watch(homeStatsProvider);

    // Calculate derived values safely
    final devices = smartDevicesState.devices;
    final activeDevicesCount = devices.where((d) => d.isOn).length;

    return Scaffold(
      backgroundColor: DesignSystem.backgroundDark,
      body: SafeArea(
        // Use a Column to stack your fixed header on top of a scrollable list
        child: Column(
          children: [
            // --- FIXED HEADER SECTION (Your preferred UI) ---
            Container(
              padding: const EdgeInsets.all(DesignSystem.spacing20),
              // Using a solid color that matches the gradient start for simplicity
              color: DesignSystem.backgroundLight,
              child: Column(
                children: [
                  // Welcome Text Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome back!",
                            style: DesignSystem.textTheme.titleMedium?.copyWith(
                              color: DesignSystem.textSecondary,
                            ),
                          ),
                          const SizedBox(height: DesignSystem.spacing4),
                          Text(
                            "Magesh Varan",
                            style: DesignSystem.textTheme.headlineLarge,
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.notifications_outlined,
                        color: DesignSystem.textPrimary,
                        size: 28,
                      ),
                    ],
                  ),
                  const SizedBox(height: DesignSystem.spacing20),
                  // Quick Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildQuickStat(
                        context,
                        icon: Icons.power,
                        // Show loading indicator if data is not ready
                        value: smartDevicesState.isLoading
                            ? "--"
                            : "$activeDevicesCount/${devices.length}",
                        label: "Devices",
                      ),
                      _buildQuickStat(
                        context,
                        icon: Icons.thermostat_outlined,
                        value: "${homeStats.temperature.toStringAsFixed(0)}°C",
                        label: "Temperature",
                      ),
                      _buildQuickStat(
                        context,
                        icon: Icons.water_drop_outlined,
                        value: "${homeStats.humidity.toStringAsFixed(0)}%",
                        label: "Humidity",
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // --- SCROLLABLE MAIN CONTENT ---
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(DesignSystem.spacing20),
                children: [
                  // --- POWER USAGE SECTION ---
                  Container(
                    padding: const EdgeInsets.all(DesignSystem.spacing20),
                    decoration: BoxDecoration(
                      gradient: DesignSystem.activeDeviceGradient,
                      borderRadius: BorderRadius.circular(
                        DesignSystem.radiusLarge,
                      ),
                      boxShadow: DesignSystem.activeDeviceShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Live Stats",
                          style: DesignSystem.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: DesignSystem.spacing16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildPowerStat(
                              context,
                              title: "Voltage",
                              value: "${homeStats.voltage.toStringAsFixed(1)}V",
                              icon: Icons.flash_on,
                            ),
                            _buildPowerStat(
                              context,
                              title: "Usage",
                              value: "${homeStats.powerUsage} kW",
                              icon: Icons.electric_bolt,
                            ),
                            _buildPowerStat(
                              context,
                              title: "Climate",
                              value: homeStats.climate,
                              icon: Icons.cloud_outlined,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: DesignSystem.spacing24),

                  // --- DEVICES HEADER ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Smart Devices",
                        style: DesignSystem.textTheme.headlineMedium,
                      ),
                      if (!smartDevicesState.isLoading &&
                          activeDevicesCount > 0)
                        Text(
                          "$activeDevicesCount Active",
                          style: DesignSystem.textTheme.bodyMedium?.copyWith(
                            color: DesignSystem.success,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: DesignSystem.spacing16),

                  // --- DEVICE GRID (Handles loading/error/data states) ---
                  _buildDeviceGrid(context, smartDevicesState),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS FROM YOUR OLD UI, NOW CONNECTED AND WORKING ---

  Widget _buildQuickStat(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: DesignSystem.textSecondary, size: 28),
        const SizedBox(height: DesignSystem.spacing8),
        Text(
          value,
          style: DesignSystem.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: DesignSystem.spacing4),
        Text(
          label,
          style: DesignSystem.textTheme.bodySmall?.copyWith(
            color: DesignSystem.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildPowerStat(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white.withOpacity(0.7), size: 16),
            const SizedBox(width: DesignSystem.spacing8),
            Text(
              title,
              style: DesignSystem.textTheme.bodySmall?.copyWith(
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
        const SizedBox(height: DesignSystem.spacing4),
        Text(
          value,
          style: DesignSystem.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// A helper method to build the UI for the device list.
  /// This keeps the main `build` method clean.
  Widget _buildDeviceGrid(BuildContext context, SmartDevicesState state) {
    if (state.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40.0),
          child: CircularProgressIndicator(color: DesignSystem.primaryColor),
        ),
      );
    }

    if (state.errorMessage != null) {
      return Center(
        child: Text(
          'Error: ${state.errorMessage}',
          style: DesignSystem.textTheme.bodyLarge?.copyWith(
            color: DesignSystem.errorColor,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (state.devices.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: Text(
            'No smart devices found.',
            style: DesignSystem.textTheme.bodyLarge?.copyWith(
              color: DesignSystem.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: DesignSystem.spacing16,
        mainAxisSpacing: DesignSystem.spacing16,
        childAspectRatio: 1 / 1.35,
      ),
      itemCount: state.devices.length,
      itemBuilder: (context, index) {
        final device = state.devices[index];
        return SmartDeviceBox(device: device);
      },
    );
  }
}
