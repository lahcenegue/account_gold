import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String value;
  const TextWidget({Key? key, required this.value}) : super(key: key);


  String replaceBrTags(String inputString) {
    // Replace <br> with newline character \n
    String outputString = inputString.replaceAll('<br>', '\n');
    return outputString;
  }

  @override
  Widget build(BuildContext context) {
    return Text(replaceBrTags(value));
  }
}
