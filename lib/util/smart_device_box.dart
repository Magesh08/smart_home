// lib/util/smart_device_box.dart (Updated)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import '../models/smart_device_model.dart'; // Import your model
import '../providers/smart_devices_provider.dart'; // Import your provider
import '../theme/design_system.dart';

// 1. Change to a ConsumerStatefulWidget
class SmartDeviceBox extends ConsumerStatefulWidget {
  // 2. Accept the full device object instead of individual properties
  final SmartDevice device;

  const SmartDeviceBox({super.key, required this.device});

  @override
  // Update the State type
  ConsumerState<SmartDeviceBox> createState() => _SmartDeviceBoxState();
}

// And change the State to a ConsumerState
class _SmartDeviceBoxState extends ConsumerState<SmartDeviceBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: DesignSystem.durationFast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: DesignSystem.curveDefault),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHoverChanged(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
      if (isHovered) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 3. Wrap everything in a Dismissible for swipe-to-delete
    return Dismissible(
      key: ValueKey(widget.device.id), // Unique key for the widget
      direction: DismissDirection.endToStart, // Swipe from right to left
      onDismissed: (_) {
        // Call the delete method from the provider
        ref.read(smartDevicesProvider.notifier).deleteDevice(widget.device.id);
        // Show a confirmation snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.device.deviceName} deleted'),
            backgroundColor: Colors.redAccent,
          ),
        );
      },
      // This is the background that appears when swiping
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        decoration: BoxDecoration(
          color: Colors.redAccent.withOpacity(0.8),
          borderRadius: BorderRadius.circular(DesignSystem.radiusLarge),
        ),
        child: const Icon(Icons.delete_sweep, color: Colors.white, size: 32),
      ),
      // Your original widget is the child
      child: MouseRegion(
        onEnter: (_) => _onHoverChanged(true),
        onExit: (_) => _onHoverChanged(false),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            padding: const EdgeInsets.all(DesignSystem.spacing16),
            decoration: BoxDecoration(
              // 4. Use properties from `widget.device`
              gradient: widget.device.isOn
                  ? DesignSystem.activeDeviceGradient
                  : DesignSystem.deviceCardGradient,
              borderRadius: BorderRadius.circular(DesignSystem.radiusLarge),
              boxShadow: widget.device.isOn
                  ? DesignSystem.activeDeviceShadow
                  : DesignSystem.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display the device's icon
                Image.asset(
                  widget.device.iconPath,
                  width: 35,
                  height: 35,
                  color: widget.device.isOn
                      ? Colors.white
                      : DesignSystem.textSecondary,
                ),
                const Spacer(),
                // Device Name
                Text(
                  widget.device.deviceName, // Use from device object
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: widget.device.isOn
                        ? Colors.white
                        : DesignSystem.textSecondary,
                  ),
                ),
                const SizedBox(height: DesignSystem.spacing8),
                // Power Switch
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.device.isOn
                          ? "On"
                          : "Off", // Use from device object
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: widget.device.isOn
                            ? Colors.white.withOpacity(0.8)
                            : DesignSystem.textSecondary,
                      ),
                    ),
                    Switch.adaptive(
                      value: widget.device.isOn, // Use from device object
                      // 5. Call the provider's toggle method
                      onChanged: (value) {
                        ref
                            .read(smartDevicesProvider.notifier)
                            .toggleDevice(widget.device);
                      },
                      activeColor: Colors.white,
                      activeTrackColor: Colors.white.withOpacity(0.5),
                      inactiveThumbColor: DesignSystem.textSecondary,
                      inactiveTrackColor: DesignSystem.textSecondary
                          .withOpacity(0.3),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
