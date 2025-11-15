import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/voice/entities/call_record.dart';
import '../../../util/app_routes.dart';
import '../controllers/voice_controller.dart';

class VoiceHistoryScreen extends GetView<VoiceController> {
  const VoiceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Calls'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.value != null) {
          return Center(child: Text(controller.errorMessage.value!));
        }
        final history = controller.history;
        if (history.isEmpty) {
          return const Center(child: Text('No call history available.'));
        }
        return ListView.builder(
          itemCount: history.length,
          itemBuilder: (context, index) {
            final call = history[index];
            return _CallTile(call: call);
          },
        );
      }),
    );
  }
}

class _CallTile extends StatelessWidget {
  final CallRecord call;

  const _CallTile({required this.call});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final icon = call.direction == CallDirection.incoming
        ? Icons.call_received
        : Icons.call_made;
    final color = call.status == CallStatus.missed
        ? theme.colorScheme.error
        : theme.colorScheme.primary;
    final statusText = call.status.name.toUpperCase();

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(call.contactName),
      subtitle: Text('${call.contactHandle} • $statusText'),
      trailing: Text(
        _formatTimestamp(call.startedAt),
        style: theme.textTheme.labelMedium,
      ),
      onTap: () => Get.toNamed(
        AppRoutes.callDetail,
        arguments: call,
      ),
    );
  }

  String _formatTimestamp(DateTime time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }
}
