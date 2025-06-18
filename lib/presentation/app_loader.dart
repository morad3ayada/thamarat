import 'package:flutter/material.dart';

class AppLoader extends StatelessWidget {
  final String? message;
  final double size;
  final Color? color;

  const AppLoader({Key? key, this.message, this.size = 48.0, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? const Color.fromARGB(255, 28, 98, 32),
              ),
              strokeWidth: 4.0,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ]
        ],
      ),
    );
  }
} 