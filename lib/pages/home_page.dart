import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:wifi_ip_details/wifi_ip_details.dart';
import '../util/smart_device_box.dart';
import '../theme/design_system.dart';
import '../providers/smart_devices_provider.dart';
import '../providers/home_stats_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  // ignore: unused_field
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _checkWifiAccess();
  // }

  // Future<void> _checkWifiAccess() async {
  //   try {
  //     final ipDetails = await WifiIPDetails.getMyWIFIDetails();
  //     final ipAddress = ipDetails?.ip;
  //     // Compare the retrieved IP address with the desired value
  //     if (ipAddress == "49.205.216.40") {
  //       setState(() {
  //         isConnectedToDesiredNetwork = true;
  //       });
  //     } else {
  //       _showWifiAccessAlertDialog();
  //     }
  //   } catch (e) {
  //     print('Error checking Wi-Fi access: $e');
  //     // Handle error (e.g., Wi-Fi not connected)
  //     _showWifiAccessAlertDialog();
  //   }
  // }

  // Future<void> _showWifiAccessAlertDialog() async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Wi-Fi Access Required'),
  //         content: const SingleChildScrollView(
  //           child: ListBody(
  //             children: <Widget>[
  //               Text(
  //                   'Please connect to the correct Wi-Fi network to access this app.'),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               // Close the dialog and recheck Wi-Fi access
  //               Navigator.of(context).pop();
  //               _checkWifiAccess();
  //             },
  //             child: const Text('OK'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final smartDevices = ref.watch(smartDevicesProvider);
    final homeStats = ref.watch(homeStatsProvider);
    final activeDevices = smartDevices.where((device) => device.isOn).length;

    return SafeArea(
      child: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(DesignSystem.spacing20),
            decoration: BoxDecoration(
              gradient: DesignSystem.deviceCardGradient,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(DesignSystem.radiusLarge),
                bottomRight: Radius.circular(DesignSystem.radiusLarge),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome back!",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: Colors.white.withOpacity(0.8)),
                        ),
                        const SizedBox(height: DesignSystem.spacing4),
                        Text(
                          "Magesh Varan",
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(DesignSystem.spacing8),
                      decoration: BoxDecoration(
                        color: DesignSystem.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                          DesignSystem.radiusMedium,
                        ),
                      ),
                      child: Icon(
                        Icons.notifications_outlined,
                        color: DesignSystem.primaryColor,
                        size: 28,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: DesignSystem.spacing20),
                // Quick Stats Row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignSystem.spacing8,
                    ),
                    child: Row(
                      children: [
                        _buildQuickStat(
                          context,
                          icon: Icons.power,
                          value: "${activeDevices}/${smartDevices.length}",
                          label: "Devices Active",
                        ),
                        const SizedBox(width: DesignSystem.spacing12),
                        _buildQuickStat(
                          context,
                          icon: Icons.thermostat_outlined,
                          value: "${homeStats.temperature}°C",
                          label: "Temperature",
                        ),
                        const SizedBox(width: DesignSystem.spacing12),
                        _buildQuickStat(
                          context,
                          icon: Icons.water_drop_outlined,
                          value: "${homeStats.humidity}%",
                          label: "Humidity",
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: DesignSystem.spacing20),

                  // Power Usage Section
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignSystem.spacing20,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(DesignSystem.spacing20),
                      decoration: BoxDecoration(
                        gradient: DesignSystem.activeDeviceGradient,
                        borderRadius: BorderRadius.circular(
                          DesignSystem.radiusLarge,
                        ),
                        boxShadow: DesignSystem.cardShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Power Usage",
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(color: Colors.white),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: DesignSystem.spacing12,
                                  vertical: DesignSystem.spacing4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(
                                    DesignSystem.radiusMedium,
                                  ),
                                ),
                                child: Text(
                                  "Last 24h",
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: DesignSystem.spacing20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildPowerStat(
                                context,
                                title: "Current",
                                value: "${homeStats.voltage}V",
                                icon: Icons.power,
                              ),
                              _buildPowerStat(
                                context,
                                title: "Usage",
                                value: "${homeStats.powerUsage} kW",
                                icon: Icons.electric_bolt,
                              ),
                              _buildPowerStat(
                                context,
                                title: "Status",
                                value: homeStats.climate,
                                icon: Icons.check_circle_outline,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: DesignSystem.spacing20),

                  // Devices Section
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignSystem.spacing20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Smart Devices",
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(color: Colors.white),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: DesignSystem.spacing12,
                            vertical: DesignSystem.spacing4,
                          ),
                          decoration: BoxDecoration(
                            color: DesignSystem.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(
                              DesignSystem.radiusMedium,
                            ),
                          ),
                          child: Text(
                            "$activeDevices Active",
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: DesignSystem.primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: DesignSystem.spacing16),

                  // Device Grid
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignSystem.spacing20,
                    ),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                            ref
                                .read(smartDevicesProvider.notifier)
                                .toggleDevice(index);
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: DesignSystem.spacing20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(
        horizontal: DesignSystem.spacing12,
        vertical: DesignSystem.spacing12,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(DesignSystem.radiusMedium),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: DesignSystem.primaryColor, size: 24),
          const SizedBox(height: DesignSystem.spacing8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: DesignSystem.spacing4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
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
            Icon(icon, color: Colors.white.withOpacity(0.6), size: 16),
            const SizedBox(width: DesignSystem.spacing4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ],
        ),
        const SizedBox(height: DesignSystem.spacing4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
