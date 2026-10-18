import 'package:flutter/material.dart';
import '../../../../data/image_path.dart';
import '../../../../utils/app_size.dart';
import '../../../../widgets/app_image/app_image.dart';
import '../../../../widgets/default_custom_clipper.dart';

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ClipPath(
            clipper: DefaultCustomClipper(),
            child: AppImage(
              path: ImagePath.onboardingImage,
              height: 0.65.sh,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
