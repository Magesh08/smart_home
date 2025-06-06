import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:wifi_ip_details/wifi_ip_details.dart';
import '../util/smart_device_box.dart';
import '../theme/design_system.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

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

  // Power button switched
  void powerSwitchChanged(bool value, int index) {
    setState(() {
      mySmartDevices[index][2] = value;
    });
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
    return SafeArea(
      child: Column(
        children: [
          // Fixed Header Section
          Padding(
            padding: const EdgeInsets.all(DesignSystem.spacing20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome back!",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
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
          ),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Room Stats
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignSystem.spacing20,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            context,
                            icon: Icons.thermostat_outlined,
                            title: "Temperature",
                            value: "24°C",
                            subtitle: "Comfortable",
                          ),
                        ),
                        const SizedBox(width: DesignSystem.spacing16),
                        Expanded(
                          child: _buildStatCard(
                            context,
                            icon: Icons.air_outlined,
                            title: "Air Quality",
                            value: "Good",
                            subtitle: "AQI 45",
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: DesignSystem.spacing20),

                  // Power Usage
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
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Power Usage",
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: DesignSystem.spacing16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildPowerStat(
                                context,
                                title: "Current",
                                value: "2.4 kW",
                              ),
                              _buildPowerStat(
                                context,
                                title: "Today",
                                value: "18.2 kWh",
                              ),
                              _buildPowerStat(
                                context,
                                title: "This Month",
                                value: "245 kWh",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: DesignSystem.spacing20),

                  // Active Devices
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignSystem.spacing20,
                    ),
                    child: Text(
                      "Active Devices",
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.white),
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
                      itemCount: mySmartDevices.length,
                      itemBuilder: (context, index) {
                        return SmartDeviceBox(
                          smartDeviceName: mySmartDevices[index][0],
                          iconPath: mySmartDevices[index][1],
                          powerOn: mySmartDevices[index][2],
                          onChanged: (value) =>
                              powerSwitchChanged(value, index),
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

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(DesignSystem.spacing16),
      decoration: BoxDecoration(
        gradient: DesignSystem.deviceCardGradient,
        borderRadius: BorderRadius.circular(DesignSystem.radiusLarge),
        boxShadow: DesignSystem.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: DesignSystem.primaryColor, size: 28),
          const SizedBox(height: DesignSystem.spacing12),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: DesignSystem.spacing4),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.white),
          ),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPowerStat(
    BuildContext context, {
    required String title,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: DesignSystem.spacing4),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: Colors.white),
        ),
      ],
    );
  }
}
