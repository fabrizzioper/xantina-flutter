import 'dart:convert';
import 'package:flutter/material.dart';

class ImageHelpers {
  static Widget buildBase64Image(String? base64Image, {double? size}) {
    if (base64Image == null || base64Image.isEmpty) {
      return _buildPlaceholder(size ?? 100);
    }

    try {
      // Remover el prefijo data:image si existe
      final base64String = base64Image.contains(',')
          ? base64Image.split(',').last
          : base64Image;
      
      final bytes = base64Decode(base64String);
      return ClipOval(
        child: Image.memory(
          bytes,
          width: size ?? 100,
          height: size ?? 100,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholder(size ?? 100);
          },
        ),
      );
    } catch (_) {
      return _buildPlaceholder(size ?? 100);
    }
  }

  static Widget _buildPlaceholder(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF4A2C1A),
        border: Border.all(
          color: Colors.white,
          width: 3,
        ),
      ),
      child: Icon(
        Icons.person,
        color: Colors.white,
        size: size * 0.5,
      ),
    );
  }
}
