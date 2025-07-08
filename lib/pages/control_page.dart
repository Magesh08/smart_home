// lib/screens/control_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/design_system.dart';
import '../util/smart_device_box.dart';
import '../providers/smart_devices_provider.dart';
import '../widgets/add_device_dialog.dart';

class ControlPage extends ConsumerWidget {
  const ControlPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the provider to get the current state
    final state = ref.watch(smartDevicesProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddDeviceDialog(),
          );
        },
        backgroundColor:
            DesignSystem.primaryColor, // Changed for better visibility
        child: const Icon(Icons.add, color: Colors.white),
      ),
      // To prevent the FAB from covering content, we can remove the Scaffold's own background
      // since the parent MainScreen already provides the gradient.
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(DesignSystem.spacing20),
              child: Text(
                "My Smart Home",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: DesignSystem.spacing20),

            // Central content area that shows loading, error, or data
            // CHANGE 2: Pass the 'ref' object to the helper method
            Expanded(child: _buildContent(context, ref, state)),
          ],
        ),
      ),
    );
  }

  // CHANGE 1: Modify the signature to accept WidgetRef
  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    SmartDevicesState state,
  ) {
    if (state.isLoading && state.devices.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: DesignSystem.primaryColor),
      );
    }

    if (state.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: ${state.errorMessage}',
              style: const TextStyle(color: Colors.redAccent, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              // CHANGE 3: Use ref.read instead of context.read
              onPressed: () =>
                  ref.read(smartDevicesProvider.notifier).fetchDevices(),
              style: ElevatedButton.styleFrom(
                backgroundColor: DesignSystem.primaryColor,
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }

    if (state.devices.isEmpty) {
      return const Center(
        child: Text(
          'No devices found.\nTap the + button to add one!',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }

    // The GridView
    return RefreshIndicator(
      // Also use ref.read here for the refresh action
      onRefresh: () => ref.read(smartDevicesProvider.notifier).fetchDevices(),
      child: GridView.builder(
        // Add a bottom padding to avoid the FAB
        padding: const EdgeInsets.fromLTRB(
          DesignSystem.spacing20,
          0,
          DesignSystem.spacing20,
          80,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1 / 1.3,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemCount: state.devices.length,
        itemBuilder: (context, index) {
          final device = state.devices[index];
          return SmartDeviceBox(device: device);
        },
      ),
    );
  }
}
