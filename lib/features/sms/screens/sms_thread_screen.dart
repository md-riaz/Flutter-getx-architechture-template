import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/sms/entities/sms_conversation.dart';
import '../../../domain/sms/entities/sms_message.dart';
import '../controllers/sms_thread_controller.dart';

class SmsThreadScreen extends StatefulWidget {
  const SmsThreadScreen({super.key});

  @override
  State<SmsThreadScreen> createState() => _SmsThreadScreenState();
}

class _SmsThreadScreenState extends State<SmsThreadScreen> {
  late final SmsThreadController _controller;
  late final SmsConversation _conversation;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<SmsThreadController>();
    _conversation = Get.arguments as SmsConversation;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.ensureMessagesLoaded(_conversation.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_conversation.contactName),
            Text(
              _conversation.contactHandle,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (_controller.isLoading.value &&
            _controller.messagesFor(_conversation.id).isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_controller.errorMessage.value != null &&
            _controller.messagesFor(_conversation.id).isEmpty) {
          return Center(child: Text(_controller.errorMessage.value!));
        }
        final messages = _controller.messagesFor(_conversation.id);
        if (messages.isEmpty) {
          return const Center(child: Text('No messages in this thread.'));
        }
        return ListView.builder(
          reverse: true,
          padding: const EdgeInsets.all(16),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[messages.length - 1 - index];
            return _MessageBubble(message: message);
          },
        );
      }),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final SmsMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final alignment =
        message.isIncoming ? Alignment.centerLeft : Alignment.centerRight;
    final backgroundColor = message.isIncoming
        ? theme.colorScheme.surfaceVariant
        : theme.colorScheme.primary;
    final foregroundColor = message.isIncoming
        ? theme.colorScheme.onSurfaceVariant
        : theme.colorScheme.onPrimary;

    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.content,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: foregroundColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTimestamp(message.timestamp),
              style: theme.textTheme.labelSmall?.copyWith(
                color: foregroundColor.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }
}
