import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputNumber extends StatelessWidget {
  InputNumber(
      {@required this.labelText,
      @required this.validatorText,
      @required this.onSaved});

  final String labelText;
  final String validatorText;
  final Function onSaved;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(fontSize: 18.0, color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(fontSize: 18.0, color: Colors.white),
        enabledBorder: const UnderlineInputBorder(
          // width: 0.0 produces a thin "hairline" border
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
      validator: (input) => input.trim().isEmpty ? validatorText : null,
      onSaved: onSaved,
    );
  }
}
