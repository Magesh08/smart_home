// lib/widgets/add_device_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/smart_devices_provider.dart';
import '../theme/design_system.dart'; // Your design system file

class AddDeviceDialog extends ConsumerStatefulWidget {
  const AddDeviceDialog({super.key});

  @override
  ConsumerState<AddDeviceDialog> createState() => _AddDeviceDialogState();
}

class _AddDeviceDialogState extends ConsumerState<AddDeviceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ipController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _ipController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(smartDevicesProvider.notifier)
          .addDevice(
            deviceName: _nameController.text,
            ipAddress: _ipController.text,
          );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: DesignSystem.backgroundDark.withOpacity(0.95),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignSystem.radiusLarge),
      ),
      title: const Text(
        "Add New Device",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration("Device Name (e.g., Smart TV)"),
              validator: (value) =>
                  value!.isEmpty ? "Please enter a name" : null,
            ),
            const SizedBox(height: DesignSystem.spacing16),
            TextFormField(
              controller: _ipController,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration("IP Address (e.g., 192.168.1.20)"),
              validator: (value) =>
                  value!.isEmpty ? "Please enter an IP address" : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel", style: TextStyle(color: Colors.white70)),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: DesignSystem.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DesignSystem.radiusMedium),
            ),
          ),
          child: const Text("Add", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
      filled: true,
      fillColor: DesignSystem.backgroundLighter.withOpacity(0.3),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: DesignSystem.spacing20,
        vertical: DesignSystem.spacing16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignSystem.radiusMedium),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignSystem.radiusMedium),
        borderSide: const BorderSide(
          color: DesignSystem.primaryColor,
          width: 2.0,
        ),
      ),
    );
  }
}
