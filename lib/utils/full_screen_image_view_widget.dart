import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:fmsproject/utils/simple_logger.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';

class FullScreenImageViewWidget extends StatefulWidget {
  final String imageUrl;
  final String heroTag;

  const FullScreenImageViewWidget(
      {super.key, required this.imageUrl, required this.heroTag});

  @override _FullScreenImageViewWidgetState createState() =>
      _FullScreenImageViewWidgetState();
}

class _FullScreenImageViewWidgetState extends State<FullScreenImageViewWidget> {
  double _downloadProgress = 0.0;
  int? _totalBytes;
  // int _receivedBytes = 0;

  @override
  void initState() {
    super.initState();
    _downloadImage();
  }

  Future<void> _downloadImage() async {
    try {
      final response = await http.get(Uri.parse(widget.imageUrl));
      _totalBytes = response.contentLength;

      if (_totalBytes != null) {
        setState(() {
          _downloadProgress = 1.0;
          // _receivedBytes = _totalBytes!;
        });
      }
    } catch (e) {
      // 에러 처리
      logger.info('Image download error: $e');
    }
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Hero(
            tag: widget.heroTag,
            child: PhotoView(
              imageProvider: (widget.imageUrl == '')
                  ? const AssetImage('assets/images/person1.png')
                      as ImageProvider<Object>
                  : NetworkImage(widget.imageUrl),
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.covered * 2,
              backgroundDecoration: const BoxDecoration(
                color: Colors.grey,
              ),
              loadingBuilder: (context, event) {
                if (event == null) {
                  return Center(
                    child: CircularProgressIndicator(
                      value: _downloadProgress,
                    ),
                  );
                }

                final receivedBytes = event.cumulativeBytesLoaded;
                final totalBytes = event.expectedTotalBytes;

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: totalBytes != null
                            ? receivedBytes / totalBytes
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        totalBytes != null
                            ? '${_formatBytes(receivedBytes)} / ${_formatBytes(totalBytes)}'
                            : '다운로드 중...',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(BootstrapIcons.x_lg, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
