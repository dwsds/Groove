import 'package:flutter/material.dart';

class YourLibrary extends StatelessWidget {
  const YourLibrary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Text(
        'YourLibrary',
        style: TextStyle(fontSize: 40, color: Colors.yellow),
      ),
    );
  }
}
