import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  static const routename = "image-view";
  const ImageView({super.key});

  @override
  Widget build(BuildContext context) {
    final image = ModalRoute.of(context)!.settings.arguments.toString();
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Image(
          image: NetworkImage(image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
