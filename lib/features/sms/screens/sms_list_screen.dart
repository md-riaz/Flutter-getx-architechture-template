import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/sms/entities/sms_conversation.dart';
import '../../../util/app_routes.dart';
import '../controllers/sms_controller.dart';

class SmsListScreen extends GetView<SmsController> {
  const SmsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMS Inbox'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.value != null) {
          return Center(
            child: Text(controller.errorMessage.value!),
          );
        }
        final conversations = controller.conversations;
        if (conversations.isEmpty) {
          return const Center(
            child: Text('No conversations yet.'),
          );
        }
        return ListView.builder(
          itemCount: conversations.length,
          itemBuilder: (context, index) {
            final conversation = conversations[index];
            return _ConversationTile(conversation: conversation);
          },
        );
      }),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final SmsConversation conversation;

  const _ConversationTile({required this.conversation});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: CircleAvatar(
        child: Text(
          conversation.contactName.isNotEmpty
              ? conversation.contactName[0].toUpperCase()
              : '?',
        ),
      ),
      title: Text(conversation.contactName),
      subtitle: Text(conversation.lastMessagePreview),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${conversation.lastUpdated.hour.toString().padLeft(2, '0')}:${conversation.lastUpdated.minute.toString().padLeft(2, '0')}',
            style: theme.textTheme.labelSmall,
          ),
          if (conversation.unreadCount > 0)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${conversation.unreadCount}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
        ],
      ),
      onTap: () {
        Get.toNamed(
          AppRoutes.smsThread,
          arguments: conversation,
        );
      },
    );
  }
}
