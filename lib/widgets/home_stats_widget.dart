import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Assuming your provider and design system files are in these locations
import '../providers/home_stats_provider.dart';
import '../theme/design_system.dart';

/// A widget that displays a grid of key home statistics.
/// It consumes the `homeStatsProvider` to get the data and uses the
/// `DesignSystem` for consistent styling.
class HomeStatsWidget extends ConsumerWidget {
  const HomeStatsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the provider. The widget will rebuild whenever the stats change.
    final stats = ref.watch(homeStatsProvider);

    // Use a GridView for a responsive layout that works well on
    // different screen sizes.
    return GridView(
      padding: const EdgeInsets.all(DesignSystem.spacing16),
      shrinkWrap: true, // Important for use within a Column or ListView
      physics:
          const NeverScrollableScrollPhysics(), // Disable scrolling on the grid itself
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Display two cards per row
        crossAxisSpacing: DesignSystem.spacing16,
        mainAxisSpacing: DesignSystem.spacing16,
        childAspectRatio: 1.2, // Make cards slightly taller than they are wide
      ),
      children: [
        _StatCard(
          label: 'Temperature',
          value: '${stats.temperature.toStringAsFixed(1)} °C',
          icon: Icons.thermostat,
          iconColor: _getTemperatureColor(stats.temperature),
        ),
        _StatCard(
          label: 'Humidity',
          value: '${stats.humidity.toStringAsFixed(0)} %',
          icon: Icons.water_drop_outlined,
          iconColor: _getHumidityColor(stats.humidity),
        ),
        _StatCard(
          label: 'Power Usage',
          value: '${stats.powerUsage.toStringAsFixed(2)} kWh',
          icon: Icons.power_outlined,
          iconColor: _getPowerUsageColor(stats.powerUsage),
        ),
        _StatCard(
          label: 'Voltage',
          value: '${stats.voltage.toStringAsFixed(1)} V',
          icon: Icons.bolt_outlined,
          iconColor: _getVoltageColor(stats.voltage),
        ),
      ],
    );
  }

  // --- Helper methods to determine status colors ---

  Color _getTemperatureColor(double temp) {
    if (temp > 28.0) {
      return DesignSystem.warning; // Hot
    } else if (temp < 18.0) {
      return DesignSystem.info; // Cold
    }
    return DesignSystem.success; // Comfortable
  }

  Color _getHumidityColor(double humidity) {
    if (humidity > 70.0) {
      return DesignSystem.info; // High humidity
    } else if (humidity < 40.0) {
      return DesignSystem.warning; // Too dry
    }
    return DesignSystem.success; // Comfortable
  }

  Color _getPowerUsageColor(double power) {
    if (power > 3.0) {
      return DesignSystem.errorColor; // High usage
    } else if (power > 1.5) {
      return DesignSystem.warning; // Moderate usage
    }
    return DesignSystem.success; // Low usage
  }

  Color _getVoltageColor(double voltage) {
    if (voltage > 240.0 || voltage < 200.0) {
      return DesignSystem.errorColor; // Unsafe voltage
    }
    return DesignSystem.success; // Normal
  }
}

/// A private helper widget to display a single statistic card.
/// This prevents code duplication and keeps the main build method clean.
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DesignSystem.spacing16),
      decoration: BoxDecoration(
        color: DesignSystem.backgroundLight,
        borderRadius: BorderRadius.circular(DesignSystem.radiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icon with a colored background circle
          Container(
            padding: const EdgeInsets.all(DesignSystem.spacing8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 28,
            ),
          ),
          // Value and Label
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: DesignSystem.textTheme.headlineSmall,
              ),
              const SizedBox(height: DesignSystem.spacing4),
              Text(
                label,
                style: DesignSystem.textTheme.bodyMedium?.copyWith(
                  color: DesignSystem.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}