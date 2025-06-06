import 'package:flutter/material.dart';
import '../theme/design_system.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(DesignSystem.spacing20),
              decoration: BoxDecoration(
                gradient: DesignSystem.activeDeviceGradient,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(DesignSystem.radiusXSmall),
                  bottomRight: Radius.circular(DesignSystem.radiusLarge),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(
                        'https://cdn3d.iconscout.com/3d/premium/thumb/mature-businessman-avatar-3d-icon-download-in-png-blend-fbx-gltf-file-formats--business-finance-man-pack-professionals-icons-8264141.png',
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              color: Colors.white,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: DesignSystem.spacing16),
                  Text(
                    "Magesh Varan",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: DesignSystem.spacing8),
                  Text(
                    "mageshvaran16@gmail.com",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withOpacity(0.8),
                        ),
                  ),
                ],
              ),
            ),

            // Settings List
            Padding(
              padding: const EdgeInsets.all(DesignSystem.spacing20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Settings",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: DesignSystem.spacing16),
                  _buildSettingsItem(
                    context,
                    icon: Icons.notifications_outlined,
                    title: "Notifications",
                    subtitle: "Manage notification preferences",
                  ),
                  _buildSettingsItem(
                    context,
                    icon: Icons.security_outlined,
                    title: "Security",
                    subtitle: "Password and security settings",
                  ),
                  _buildSettingsItem(
                    context,
                    icon: Icons.devices_outlined,
                    title: "Connected Devices",
                    subtitle: "Manage your smart devices",
                  ),
                  _buildSettingsItem(
                    context,
                    icon: Icons.palette_outlined,
                    title: "Appearance",
                    subtitle: "Customize app theme and colors",
                  ),
                  _buildSettingsItem(
                    context,
                    icon: Icons.help_outline,
                    title: "Help & Support",
                    subtitle: "Get help and contact support",
                  ),
                ],
              ),
            ),

            // Logout Button
            Padding(
              padding: const EdgeInsets.all(DesignSystem.spacing20),
              child: ElevatedButton(
                onPressed: () {
                  // Handle logout
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: DesignSystem.primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(DesignSystem.radiusMedium),
                  ),
                ),
                child: const Text("Logout"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: DesignSystem.spacing12),
      decoration: BoxDecoration(
        gradient: DesignSystem.deviceCardGradient,
        borderRadius: BorderRadius.circular(DesignSystem.radiusMedium),
        boxShadow: DesignSystem.cardShadow,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: DesignSystem.primaryColor,
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Colors.white.withOpacity(0.6),
        ),
        onTap: () {
          // Handle settings item tap
        },
      ),
    );
  }
}
