import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class Helpers {
  static Future<String?> imageToBase64(XFile? imageFile) async {
    if (imageFile == null) return null;
    
    final Uint8List bytes = await imageFile.readAsBytes();
    return base64Encode(bytes);
  }
  
  static String? formatBase64Image(String? base64Image) {
    if (base64Image == null) return null;
    
    // Si ya tiene el prefijo data:image, retornarlo tal cual
    if (base64Image.startsWith('data:image')) {
      return base64Image;
    }
    
    // Si no tiene prefijo, agregarlo
    return 'data:image/jpeg;base64,$base64Image';
  }
}
