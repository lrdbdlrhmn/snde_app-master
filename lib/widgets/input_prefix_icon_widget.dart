import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InputPrefixIconWidget extends StatelessWidget {
  final IconData? icon;
  const InputPrefixIconWidget({Key? key, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(13), // add padding to adjust icon
      child: FaIcon(icon),
    );
  }
}
