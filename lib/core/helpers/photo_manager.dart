import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoManager {
  static const String PHOTO_FOLDER = 'report_photos';
  static const int MAX_FILE_SIZE = 5 * 1024 * 1024; 
  static const int IMAGE_QUALITY = 80;
  static const int MAX_WIDTH = 1024;
  static const int MAX_HEIGHT = 1024;

  static Future<File?> processPhotoFromCamera(XFile pickedFile) async {
    try {
      print('[PhotoManager] Processing photo from camera...');

      final Directory appDir = await getApplicationDocumentsDirectory();
      final Directory photoDir = Directory('${appDir.path}/$PHOTO_FOLDER');
      if (!await photoDir.exists()) {
        await photoDir.create(recursive: true);
      }
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String fileName = 'report_${timestamp}.jpg';
      final String permanentPath = '${photoDir.path}/$fileName';
      final File originalFile = File(pickedFile.path);
      final Uint8List imageBytes = await originalFile.readAsBytes();
      
      print('[PhotoManager] Original file size: ${imageBytes.length} bytes');
      final File compressedFile = await _compressImage(imageBytes, permanentPath);
      
      print('[PhotoManager] Compressed file size: ${await compressedFile.length()} bytes');
      print('[PhotoManager] Saved to: $permanentPath');
      if (await compressedFile.exists() && await compressedFile.length() > 0) {
        return compressedFile;
      } else {
        throw Exception('Failed to save compressed image');
      }
      
    } catch (e) {
      print('[PhotoManager] Error processing photo: $e');
      return null;
    }
  }
  static Future<File> _compressImage(Uint8List imageBytes, String outputPath) async {
    try {
      img.Image? image = img.decodeImage(imageBytes);
      if (image == null) {
        throw Exception('Failed to decode image');
      }
      if (image.width > MAX_WIDTH || image.height > MAX_HEIGHT) {
        image = img.copyResize(
          image,
          width: image.width > image.height ? MAX_WIDTH : null,
          height: image.height > image.width ? MAX_HEIGHT : null,
        );
      }
      final List<int> compressedBytes = img.encodeJpg(image, quality: IMAGE_QUALITY);
      final File outputFile = File(outputPath);
      await outputFile.writeAsBytes(compressedBytes);
      
      return outputFile;
    } catch (e) {
      print('[PhotoManager] Compression error: $e');
      rethrow;
    }
  }
  static Future<bool> validatePhotoFile(File? file) async {
    if (file == null) return false;
    
    try {
      if (!await file.exists()) {
        print('[PhotoManager] File does not exist: ${file.path}');
        return false;
      }
      final int fileSize = await file.length();
      if (fileSize == 0) {
        print('[PhotoManager] File is empty: ${file.path}');
        return false;
      }
      
      if (fileSize > MAX_FILE_SIZE) {
        print('[PhotoManager] File too large: ${fileSize} bytes');
        return false;
      }
      final Uint8List bytes = await file.readAsBytes();
      final img.Image? image = img.decodeImage(bytes);
      if (image == null) {
        print('[PhotoManager] Invalid image format');
        return false;
      }
      
      print('[PhotoManager] File validation passed: ${fileSize} bytes');
      return true;
      
    } catch (e) {
      print('[PhotoManager] Validation error: $e');
      return false;
    }
  }
  static Future<void> cleanupOldPhotos() async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final Directory photoDir = Directory('${appDir.path}/$PHOTO_FOLDER');
      
      if (await photoDir.exists()) {
        final List<FileSystemEntity> files = await photoDir.list().toList();
        final DateTime cutoff = DateTime.now().subtract(Duration(days: 7));
        
        for (FileSystemEntity file in files) {
          if (file is File) {
            final FileStat stat = await file.stat();
            if (stat.modified.isBefore(cutoff)) {
              await file.delete();
              print('[PhotoManager] Deleted old photo: ${file.path}');
            }
          }
        }
      }
    } catch (e) {
      print('[PhotoManager] Cleanup error: $e');
    }
  }
}