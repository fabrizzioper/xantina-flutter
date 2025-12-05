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

  static Widget buildBusinessLogo(String? base64Image, {double? size}) {
    final logoSize = size ?? 60;
    
    if (base64Image == null || base64Image.isEmpty) {
      return Container(
        width: logoSize,
        height: logoSize,
        decoration: BoxDecoration(
          color: const Color(0xFF4A2C1A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            'M',
            style: TextStyle(
              fontSize: logoSize * 0.3,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFF5F1E8),
            ),
          ),
        ),
      );
    }

    try {
      // Remover el prefijo data:image si existe
      final base64String = base64Image.contains(',')
          ? base64Image.split(',').last
          : base64Image;
      
      final bytes = base64Decode(base64String);
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.memory(
          bytes,
          width: logoSize,
          height: logoSize,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: logoSize,
              height: logoSize,
              decoration: BoxDecoration(
                color: const Color(0xFF4A2C1A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'M',
                  style: TextStyle(
                    fontSize: logoSize * 0.3,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFF5F1E8),
                  ),
                ),
              ),
            );
          },
        ),
      );
    } catch (_) {
      return Container(
        width: logoSize,
        height: logoSize,
        decoration: BoxDecoration(
          color: const Color(0xFF4A2C1A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            'M',
            style: TextStyle(
              fontSize: logoSize * 0.3,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFF5F1E8),
            ),
          ),
        ),
      );
    }
  }
}
