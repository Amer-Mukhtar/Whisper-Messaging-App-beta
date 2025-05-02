import 'package:flutter/material.dart';
import 'package:whisper/widgets/fullscreen_image.dart';

class ZoomableImageScreen extends StatelessWidget {
  final String imageUrl;

  const ZoomableImageScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => FullScreenImage(imageUrl: imageUrl),
        ));
      },
      child: Image.network(
        imageUrl,
        height: 100,
        width: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Text('Image not available');
        },
        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;
          return SizedBox(
            height: 100,
            width: 100,
            child: CircularProgressIndicator(
              color: Colors.white,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      ),
    );
  }
}
