import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageDetails extends StatelessWidget {
  final String img;
  const ImageDetails({Key? key, required this.img}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
        panEnabled: false, // Set it to false
        boundaryMargin: const EdgeInsets.all(100),
        minScale: 0.5,
        maxScale: 2,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(img, fit: BoxFit.fitHeight),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                          shape: BoxShape.circle
                      ),
                      padding: const EdgeInsets.all(15),
                      child: const Icon(Icons.clear, color: Colors.black,)),),
              ),
            )
          ],
        ));
  }
}
