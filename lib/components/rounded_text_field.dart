import 'package:flutter/material.dart';

class RoundedTextField extends StatelessWidget {
  final String hintText;
  final Color borderColor;
  final bool obscureText;
  final TextInputType keyboardType;
  final Function onChanged;

  const RoundedTextField({
    Key key,
    this.hintText = "",
    this.borderColor = Colors.lightBlueAccent,
    this.obscureText = false,
    this.keyboardType,
    @required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        // hintStyle: TextStyle(color: Colors.white),
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
