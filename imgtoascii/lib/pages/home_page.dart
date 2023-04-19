import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imgtoascii/colors.dart';
import 'package:imgtoascii/widgets/gradient_border.dart';
import 'package:imgtoascii/widgets/gradient_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String imageASCII = "Pick an image to start...";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 300),
        child: Column(
          children: [
            const SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GradientText(
                  "Image To ASCII",
                  gradient: const LinearGradient(
                    colors: [
                      kRed,
                      kBlue,
                    ],
                  ),
                  style: GoogleFonts.nunito(
                    fontSize: 75,
                    fontWeight: FontWeight.bold,
                  ),
                ).animate().fadeIn().slideX(),
              ],
            ),
            const SizedBox(height: 30),
            GradientBorderBox(
              strokeWidth: 2,
              radius: 15,
              child: Container(
                padding: const EdgeInsets.all(12),
                height: 500,
                width: double.infinity,
                child: Stack(
                  children: [
                    const Positioned.fill(child: Text("Some text...")),
                    Positioned(
                      bottom: 15,
                      right: 15,
                      child: GradientBorderBox(
                        strokeWidth: 1.5,
                        radius: 15,
                        child: SizedBox(
                          width: 120,
                          height: 50,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                ui.Image? _image;
                                List<int>? _grayscaleValues;

                                // load the image from a URL
                                // load the image from a URL
                                const NetworkImage(
                                  'https://i.pinimg.com/736x/ba/75/57/ba75575657176e3653ea2c5f8096c6ac.jpg',
                                )
                                    .resolve(const ImageConfiguration())
                                    .addListener(
                                        ImageStreamListener((image, _) async {
                                  // decode the image bytes into a ui.Image object
                                  decodeImageFromList(
                                    await image.image.toByteData().then(
                                          (value) =>
                                              value!.buffer.asUint8List(),
                                        ),
                                  ).then((decodedImage) async {
                                    _image = decodedImage;

                                    // iterate over the pixels and get their grayscale values
                                    _grayscaleValues = List<int>.filled(
                                        decodedImage.width *
                                            decodedImage.height,
                                        0);
                                    final pixelBytes =
                                        await decodedImage.toByteData().then(
                                              (value) =>
                                                  value!.buffer.asUint8List(),
                                            );
                                    for (int y = 0;
                                        y < decodedImage.height;
                                        y++) {
                                      for (int x = 0;
                                          x < decodedImage.width;
                                          x++) {
                                        final offset =
                                            (y * decodedImage.width + x) * 4;
                                        final pixelColor = Color.fromARGB(
                                            pixelBytes[offset + 3],
                                            pixelBytes[offset],
                                            pixelBytes[offset + 1],
                                            pixelBytes[offset + 2]);
                                        final grayscaleValue = ((0.2989 *
                                                    pixelColor.red) +
                                                (0.5870 * pixelColor.green) +
                                                (0.1140 * pixelColor.blue))
                                            .round();
                                        _grayscaleValues![
                                                y * decodedImage.width + x] =
                                            grayscaleValue;
                                      }
                                    }
                                  });
                                }));

                                print(_image);
                                print(_grayscaleValues);
                              },
                              borderRadius: BorderRadius.circular(15),
                              child: const Center(child: Text("Pick image")),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(),
          ],
        ),
      ),
    );
  }
}
