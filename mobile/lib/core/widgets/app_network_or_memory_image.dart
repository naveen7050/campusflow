import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AppNetworkOrMemoryImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? height;
  final double? width;
  final Widget? placeholder;

  const AppNetworkOrMemoryImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.height,
    this.width,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    final trimmed = imageUrl.trim();

    if (trimmed.startsWith('data:image')) {
      try {
        final commaIndex = trimmed.indexOf(',');
        final base64Data = commaIndex != -1 ? trimmed.substring(commaIndex + 1) : trimmed;
        final Uint8List bytes = base64Decode(base64Data);
        return Image.memory(
          bytes,
          fit: fit,
          height: height,
          width: width,
          errorBuilder: (context, error, stackTrace) => _buildError(),
        );
      } catch (_) {
        return _buildError();
      }
    }

    return Image.network(
      trimmed,
      fit: fit,
      height: height,
      width: width,
      errorBuilder: (context, error, stackTrace) => _buildError(),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return placeholder ??
            Container(
              height: height,
              width: width,
              color: const Color(0xFFF3F4F6),
              child: const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0F5132)),
                ),
              ),
            );
      },
    );
  }

  Widget _buildError() {
    return Container(
      height: height,
      width: width,
      color: const Color(0xFFF3F4F6),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LucideIcons.image, size: 28, color: Color(0xFF9CA3AF)),
            const SizedBox(height: 4),
            Text(
              'Cannot load image',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
