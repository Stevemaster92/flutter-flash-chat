import 'package:flutter/material.dart';

class RoundedTextField extends StatelessWidget {
  final String hintText;
  final Color borderColor;
  final bool obscureText;
  final TextInputType keyboardType;
  final Function onChanged;
  final Function(String value) onSubmitted;

  const RoundedTextField({
    Key key,
    this.hintText = "",
    this.borderColor = Colors.lightBlueAccent,
    this.obscureText = false,
    this.keyboardType,
    @required this.onChanged,
    this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
      ),
    );
  }
}
