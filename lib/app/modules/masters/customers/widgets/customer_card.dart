import 'package:flutter/material.dart';
import '../../../../data/models/customer.dart';
import '../../../../core/theme/tokens.dart';

/// Customer card widget
class CustomerCard extends StatelessWidget {
  final Customer customer;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CustomerCard({
    super.key,
    required this.customer,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTokens.spacing16,
        vertical: AppTokens.spacing8,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTokens.radius16),
        child: Padding(
          padding: const EdgeInsets.all(AppTokens.spacing16),
          child: Row(
            children: [
              // Icon
              CircleAvatar(
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(
                  Icons.person,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: AppTokens.spacing16),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppTokens.spacing4),
                    if (customer.gst != null) ...[
                      Text(
                        'GST: ${customer.gst}',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: AppTokens.spacing4),
                    ],
                    Row(
                      children: [
                        if (customer.phone != null) ...[
                          Icon(
                            Icons.phone,
                            size: AppTokens.iconSizeSmall,
                            color: theme.colorScheme.secondary,
                          ),
                          const SizedBox(width: AppTokens.spacing4),
                          Text(
                            customer.phone!,
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                        if (customer.phone != null && customer.email != null)
                          const SizedBox(width: AppTokens.spacing12),
                        if (customer.email != null) ...[
                          Icon(
                            Icons.email,
                            size: AppTokens.iconSizeSmall,
                            color: theme.colorScheme.secondary,
                          ),
                          const SizedBox(width: AppTokens.spacing4),
                          Flexible(
                            child: Text(
                              customer.email!,
                              style: theme.textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              
              // Actions
              if (onEdit != null || onDelete != null)
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit' && onEdit != null) {
                      onEdit!();
                    } else if (value == 'delete' && onDelete != null) {
                      onDelete!();
                    }
                  },
                  itemBuilder: (context) => [
                    if (onEdit != null)
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: AppTokens.spacing8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                    if (onDelete != null)
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete),
                            SizedBox(width: AppTokens.spacing8),
                            Text('Delete'),
                          ],
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
