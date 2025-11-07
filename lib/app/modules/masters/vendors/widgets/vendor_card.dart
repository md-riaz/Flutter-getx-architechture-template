import 'package:flutter/material.dart';
import '../../../../data/models/vendor.dart';
import '../../../../core/theme/tokens.dart';

/// Vendor card widget
/// Displays vendor information in a card format
class VendorCard extends StatelessWidget {
  final Vendor vendor;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const VendorCard({
    super.key,
    required this.vendor,
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
                  Icons.business,
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
                      vendor.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppTokens.spacing4),
                    if (vendor.gst != null) ...[
                      Text(
                        'GST: ${vendor.gst}',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: AppTokens.spacing4),
                    ],
                    Row(
                      children: [
                        if (vendor.phone != null) ...[
                          Icon(
                            Icons.phone,
                            size: AppTokens.iconSizeSmall,
                            color: theme.colorScheme.secondary,
                          ),
                          const SizedBox(width: AppTokens.spacing4),
                          Text(
                            vendor.phone!,
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                        if (vendor.phone != null && vendor.email != null)
                          const SizedBox(width: AppTokens.spacing12),
                        if (vendor.email != null) ...[
                          Icon(
                            Icons.email,
                            size: AppTokens.iconSizeSmall,
                            color: theme.colorScheme.secondary,
                          ),
                          const SizedBox(width: AppTokens.spacing4),
                          Flexible(
                            child: Text(
                              vendor.email!,
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
