import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'gif_progress_bar.dart';

class ImageLoadWidget extends StatefulWidget {
  const ImageLoadWidget({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.fit,
    this.height,
    this.loadingBarRadius,
  });

  final String imageUrl;
  final double width;
  final double? height;
  final BoxFit fit;
  final double? loadingBarRadius;

  @override
  _ImageLoadWidgetState createState() => _ImageLoadWidgetState();
}

class _ImageLoadWidgetState extends State<ImageLoadWidget> {
  double? _aspectRatio;
  ImageStream? _imageStream;
  ImageStreamListener? _imageStreamListener;

  @override
  void initState() {
    super.initState();
    _fetchImageSize();
  }

  void _fetchImageSize() {
    final image = Image.network(widget.imageUrl);
    _imageStream = image.image.resolve(const ImageConfiguration());
    _imageStreamListener =
        ImageStreamListener((ImageInfo info, bool synchronousCall) {
      if (mounted) {
        setState(() {
          _aspectRatio = info.image.height / info.image.width;
        });
      }
    });

    _imageStream?.addListener(_imageStreamListener!);
  }

  @override
  void dispose() {
    _imageStream?.removeListener(_imageStreamListener!);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _aspectRatio == null
        ? Center(
            child: SizedBox(
              width: widget.width,
              height: (widget.width >= 110.w) ? 110.w : widget.width,
              child: GifProgressBar(
                radius: widget.loadingBarRadius,
              ),
            ),
          )
        : CachedNetworkImage(
            width: widget.width,
            height: widget.height ?? widget.width * _aspectRatio!,
            imageUrl: widget.imageUrl,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: widget.fit,
                ),
              ),
            ),
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Center(
              child: GifProgressBar(
                radius: widget.loadingBarRadius,
              ),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          );
  }
}
