import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/fax/entities/fax_conversation.dart';
import '../../../util/app_routes.dart';
import '../controllers/fax_controller.dart';

class FaxListScreen extends GetView<FaxController> {
  const FaxListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fax Inbox'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.value != null) {
          return Center(child: Text(controller.errorMessage.value!));
        }
        final conversations = controller.conversations;
        if (conversations.isEmpty) {
          return const Center(child: Text('No fax documents available.'));
        }
        return ListView.separated(
          itemCount: conversations.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final conversation = conversations[index];
            return _FaxTile(conversation: conversation);
          },
        );
      }),
    );
  }
}

class _FaxTile extends StatelessWidget {
  final FaxConversation conversation;

  const _FaxTile({required this.conversation});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: const Icon(Icons.print),
      title: Text(conversation.subject),
      subtitle: Text('${conversation.company} • ${conversation.pageCount} pages'),
      trailing: Text(
        '${conversation.receivedAt.month}/${conversation.receivedAt.day}',
        style: theme.textTheme.labelMedium,
      ),
      onTap: () => Get.toNamed(
        AppRoutes.faxDetail,
        arguments: conversation,
      ),
    );
  }
}
