import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ImagePreviewScreen extends StatefulWidget {
  final String imagePath;
  final Rect boundingBox;

  const ImagePreviewScreen({
    required this.imagePath,
    required this.boundingBox,
    super.key,
  });

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  Uint8List? _croppedImageBytes;
  bool _isUploading = false;

  Future<void> _uploadImage() async {
    try {
      setState(() => _isUploading = true);

      final uri = Uri.parse('https://app.nkduy.me/upload-crop-image/');
      final request = http.MultipartRequest('POST', uri)
        ..files.add(
          await http.MultipartFile.fromPath(
            'file',
            widget.imagePath,
            contentType: MediaType('image', 'jpeg'),
          ),
        )
        ..fields['x'] = widget.boundingBox.left.toInt().toString()
        ..fields['y'] = widget.boundingBox.top.toInt().toString()
        ..fields['width'] = widget.boundingBox.width.toInt().toString()
        ..fields['height'] = widget.boundingBox.height.toInt().toString();

      final response = await request.send();

      if (response.statusCode == 200) {
        final bytes = await response.stream.toBytes();
        setState(() {
          _croppedImageBytes = bytes;
          _isUploading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Gửi ảnh và nhận ảnh cắt thành công!'),
          ),
        );
      } else {
        throw Exception('Lỗi ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _isUploading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Upload lỗi: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ảnh chụp & kết quả')),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Image.file(
                    File(widget.imagePath),
                    fit: BoxFit.contain,
                  ),
                ),
                const Divider(height: 16, color: Colors.grey),
                if (_croppedImageBytes != null)
                  Expanded(
                    child: Image.memory(
                      _croppedImageBytes!,
                      fit: BoxFit.contain,
                    ),
                  )
                else if (_isUploading)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: _isUploading ? null : _uploadImage,
              icon: const Icon(Icons.cloud_upload),
              label: const Text('GỬI & HIỂN THỊ ẢNH CẮT'),
            ),
          ),
        ],
      ),
    );
  }
}
