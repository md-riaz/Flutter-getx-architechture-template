import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/fax/entities/fax_conversation.dart';
import '../../../domain/fax/entities/fax_message.dart';
import '../controllers/fax_detail_controller.dart';

class FaxDetailScreen extends StatefulWidget {
  const FaxDetailScreen({super.key});

  @override
  State<FaxDetailScreen> createState() => _FaxDetailScreenState();
}

class _FaxDetailScreenState extends State<FaxDetailScreen> {
  late final FaxDetailController _controller;
  late final FaxConversation _conversation;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<FaxDetailController>();
    final args = Get.arguments;
    if (args is! FaxConversation) {
      // Handle invalid arguments gracefully
      Get.back();
      return;
    }
    _conversation = args;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.ensureLoaded(_conversation.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_conversation.subject),
            Text(
              _conversation.company,
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
        final pages = _controller.messagesFor(_conversation.id);
        if (pages.isEmpty) {
          return const Center(child: Text('No pages for this fax.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: pages.length,
          itemBuilder: (context, index) {
            final page = pages[index];
            return _FaxPageCard(page: page, index: index + 1);
          },
        );
      }),
    );
  }
}

class _FaxPageCard extends StatelessWidget {
  final FaxMessage page;
  final int index;

  const _FaxPageCard({required this.page, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Page $index',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(page.content),
            const SizedBox(height: 12),
            Text(
              _formatTimestamp(page.timestamp),
              style: theme.textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime time) {
    final date = '${time.month}/${time.day}/${time.year}';
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$date • $hours:$minutes';
  }
}
