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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          imageUrl,
          height: 250,
          width: 200,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Text('Image not available');
          },
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 250,
              width: 200,
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              child: SizedBox(
                height: 40, // or any size you want
                width: 40,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3, // thinner circle if needed
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );

          },
        ),
      ),
    );
  }
}