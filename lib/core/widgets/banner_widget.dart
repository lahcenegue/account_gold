import 'package:flutter/material.dart';

class BannerWidget extends StatelessWidget {
  final String url;
  const BannerWidget({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, left: 8.0),
      child: Container(
        width: MediaQuery.of(context).size.width /1.1,
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 130,
          child: ClipRRect(borderRadius: BorderRadius.circular(20),
              child: Image.network(url, fit: BoxFit.cover,)),
        ),
      ),
    );
  }
}
