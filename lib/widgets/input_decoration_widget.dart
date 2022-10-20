import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:snde/widgets/input_prefix_icon_widget.dart';

InputDecoration inputDecorationWidget({String text = '', IconData? icon, double padding = 13}) {
  return InputDecoration(
    hintText: text,
    contentPadding: EdgeInsets.all(padding),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0XFFcbcaca), width: 0.5)),
    border: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0XFFcbcaca), width: 0.5)),
    isDense: true,
    prefixIcon: icon == null ? null : InputPrefixIconWidget(icon: icon),
  );
}
