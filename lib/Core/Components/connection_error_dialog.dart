import 'package:PureFit/Core/Components/media_query.dart';
import 'package:PureFit/Core/Shared/app_string.dart';
import 'package:flutter/material.dart';

class ConnectionErrorDialog extends StatelessWidget {
  const ConnectionErrorDialog({
    super.key,
    this.onRetry,
    this.onCancel,
    this.title,
    this.message,
  });

  final VoidCallback? onRetry;
  final VoidCallback? onCancel;
  final String? title;
  final String? message;

  static void show(
    BuildContext context, {
    VoidCallback? onRetry,
    VoidCallback? onCancel,
    String? title,
    String? message,
  }) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConnectionErrorDialog(
        onRetry: onRetry,
        onCancel: onCancel,
        title: title,
        message: message,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(mq.width(4)),
      ),
      contentPadding: EdgeInsets.all(mq.width(5)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Error Icon
          Container(
            padding: EdgeInsets.all(mq.width(4)),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.wifi_off_rounded,
              size: mq.height(6),
              color: Colors.red,
            ),
          ),
          SizedBox(height: mq.height(2)),

          // Title
          Text(
            title ?? 'Connection Error',
            style: TextStyle(
              fontSize: mq.height(2.5),
              fontWeight: FontWeight.bold,
              fontFamily: AppString.font,
              color: theme.textTheme.titleLarge?.color,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: mq.height(1)),

          // Message
          Text(
            message ??
                'Unable to connect to the server. Please check your internet connection and try again.',
            style: TextStyle(
              fontSize: mq.height(1.8),
              fontFamily: AppString.font,
              color: theme.textTheme.bodyMedium?.color,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: mq.height(3)),

          // Action Buttons
          Row(
            children: [
              // Cancel Button
              Expanded(
                child: OutlinedButton(
                  onPressed: onCancel ?? () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey[400]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(mq.width(2)),
                    ),
                    padding: EdgeInsets.symmetric(vertical: mq.height(1.2)),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: mq.height(1.8),
                      fontFamily: AppString.font,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: mq.width(3)),

              // Retry Button
              Expanded(
                child: ElevatedButton(
                  onPressed: onRetry ?? () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(mq.width(2)),
                    ),
                    padding: EdgeInsets.symmetric(vertical: mq.height(1.2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.refresh_rounded,
                        size: mq.height(2),
                        color: Colors.white,
                      ),
                      SizedBox(width: mq.width(1)),
                      Text(
                        'Retry',
                        style: TextStyle(
                          fontSize: mq.height(1.8),
                          fontFamily: AppString.font,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NoConnectionWidget extends StatelessWidget {
  const NoConnectionWidget({
    super.key,
    this.onRetry,
    this.message,
    this.showRetryButton = true,
  });

  final VoidCallback? onRetry;
  final String? message;
  final bool showRetryButton;

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(mq.width(5)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // No Connection Icon
            Container(
              padding: EdgeInsets.all(mq.width(6)),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.wifi_off_rounded,
                size: mq.height(8),
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: mq.height(3)),

            // Title
            Text(
              AppString.noInternetConnection(context),
              style: TextStyle(
                fontSize: mq.height(2.5),
                fontWeight: FontWeight.bold,
                fontFamily: AppString.font,
                color: theme.textTheme.titleLarge?.color,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: mq.height(1)),

            // Message
            Text(
              message ?? AppString.pleaseCheckYourInternetConnectionAndTryAgain(context),
              style: TextStyle(
                fontSize: mq.height(1.8),
                fontFamily: AppString.font,
                color: theme.textTheme.bodyMedium?.color,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),

            if (showRetryButton) ...[
              SizedBox(height: mq.height(4)),

              // Retry Button
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: Icon(
                  Icons.refresh_rounded,
                  color: theme.scaffoldBackgroundColor,
                  size: mq.height(2.2),
                ),
                label: Text(
                  AppString.retry(context),
                  style: TextStyle(
                    fontSize: mq.height(1.8),
                    fontFamily: AppString.font,
                    fontWeight: FontWeight.w600,
                    color: theme.scaffoldBackgroundColor,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(mq.width(2.5)),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: mq.width(6),
                    vertical: mq.height(1.5),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
