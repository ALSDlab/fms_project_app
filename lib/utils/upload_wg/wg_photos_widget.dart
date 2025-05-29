import 'package:flutter/material.dart';

import '../../view/pages/upload_WG_page/upload_wg_page_view_model.dart';

class WgPhotosWidget extends StatelessWidget {
  const WgPhotosWidget(
      {super.key,
      required this.viewModel,
      required this.photoIndex,
      this.isPrimary = false});

  final UploadWGPageViewModel viewModel;
  final int photoIndex;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isPrimary
          ? (MediaQuery.of(context).size.width) * 0.6
          : (MediaQuery.of(context).size.width - 26) / 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              viewModel.state.wgImageFiles[photoIndex]!,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          (photoIndex == 0)
              ? Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.star, color: Colors.white, size: 14),
                        SizedBox(width: 4),
                        Text(
                          'COVER',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
          Positioned(
            top: 12,
            right: 12,
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    viewModel.removePhoto(photoIndex);
                    viewModel.addWgImagesComplete(viewModel.state.wgImageFiles);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
