import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/design_system.dart';

class SmartDeviceBox extends StatefulWidget {
  final String smartDeviceName;
  final String iconPath;
  final bool powerOn;
  final void Function(bool)? onChanged;

  const SmartDeviceBox({
    super.key,
    required this.smartDeviceName,
    required this.iconPath,
    required this.powerOn,
    required this.onChanged,
  });

  @override
  State<SmartDeviceBox> createState() => _SmartDeviceBoxState();
}

class _SmartDeviceBoxState extends State<SmartDeviceBox>
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
    return MouseRegion(
      onEnter: (_) => _onHoverChanged(true),
      onExit: (_) => _onHoverChanged(false),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.all(DesignSystem.spacing16),
          decoration: BoxDecoration(
            gradient: widget.powerOn
                ? DesignSystem.activeDeviceGradient
                : DesignSystem.deviceCardGradient,
            borderRadius: BorderRadius.circular(DesignSystem.radiusLarge),
            boxShadow: widget.powerOn
                ? DesignSystem.activeDeviceShadow
                : DesignSystem.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Icon(
                widget.powerOn ? Icons.power_settings_new : Icons.power_off,
                color: widget.powerOn
                    ? Colors.white
                    : DesignSystem.textSecondary,
                size: 32,
              ),
              const Spacer(),
              // Device Name
              Text(
                widget.smartDeviceName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: widget.powerOn
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
                    widget.powerOn ? "On" : "Off",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: widget.powerOn
                          ? Colors.white.withOpacity(0.8)
                          : DesignSystem.textSecondary,
                    ),
                  ),
                  Switch.adaptive(
                    value: widget.powerOn,
                    onChanged: widget.onChanged,
                    activeColor: Colors.white,
                    activeTrackColor: Colors.white.withOpacity(0.5),
                    inactiveThumbColor: DesignSystem.textSecondary,
                    inactiveTrackColor: DesignSystem.textSecondary.withOpacity(
                      0.3,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
