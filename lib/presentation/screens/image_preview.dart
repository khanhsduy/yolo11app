import 'dart:io';
import 'package:flutter/material.dart';

import '../../services/api.dart';

class ImagePreviewScreen extends StatelessWidget {
  final String imagePath;
  const ImagePreviewScreen({required this.imagePath, super.key});

  @override
  Widget build(BuildContext context) {
    final api = ApiService(baseUrl: 'https://app.nkduy.me');

    return Scaffold(
      appBar: AppBar(title: const Text('Ảnh chụp')),
      body: Column(
        children: [
          Expanded(
            child: Image.file(File(imagePath), fit: BoxFit.contain),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.upload),
              label: const Text('Gửi lên server'),
              onPressed: () async {
                try {
                  //await api.uploadImage(File(imagePath));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('📤 Đã gửi ảnh lên server!')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('❌ Gửi ảnh thất bại: \$e')),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
