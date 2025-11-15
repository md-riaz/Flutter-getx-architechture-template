import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/voice/entities/call_record.dart';
import '../controllers/call_detail_controller.dart';

class CallDetailScreen extends StatefulWidget {
  const CallDetailScreen({super.key});

  @override
  State<CallDetailScreen> createState() => _CallDetailScreenState();
}

class _CallDetailScreenState extends State<CallDetailScreen> {
  late final CallDetailController _controller;
  late final CallRecord _call;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<CallDetailController>();
    final arguments = Get.arguments;
    if (arguments is! CallRecord) {
      Get.back();
      return;
    }
    _call = arguments;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.ensureLoaded(_call.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_call.contactName),
            Text(
              _call.contactHandle,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
          ],
        ),
      ),
      body: Obx(() {
        final detail = _controller.detailFor(_call.id) ?? _call;
        if (_controller.isLoading.value &&
            _controller.detailFor(_call.id) == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_controller.errorMessage.value != null &&
            _controller.detailFor(_call.id) == null) {
          return Center(child: Text(_controller.errorMessage.value!));
        }
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InfoRow(label: 'Direction', value: detail.direction.name),
              const SizedBox(height: 8),
              _InfoRow(label: 'Status', value: detail.status.name),
              const SizedBox(height: 8),
              _InfoRow(
                label: 'Started at',
                value:
                    '${detail.startedAt.month}/${detail.startedAt.day}/${detail.startedAt.year} ${detail.startedAt.hour.toString().padLeft(2, '0')}:${detail.startedAt.minute.toString().padLeft(2, '0')}',
              ),
              const SizedBox(height: 8),
              _InfoRow(
                label: 'Duration',
                value:
                    '${detail.duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(detail.duration.inSeconds.remainder(60)).toString().padLeft(2, '0')}',
              ),
              const SizedBox(height: 24),
              Text(
                'Call notes',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Mocked call details are provided for demo purposes.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: theme.textTheme.bodyMedium),
        Text(value, style: theme.textTheme.titleMedium),
      ],
    );
  }
}
