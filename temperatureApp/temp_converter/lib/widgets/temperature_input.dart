import 'package:flutter/material.dart';

class TemperatureInput extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  TemperatureInput({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Enter Temperature',
        ),
        onChanged: onChanged,
        controller: TextEditingController.fromValue(
          TextEditingValue(
            text: value,
            selection: TextSelection.collapsed(offset: value.length),
          ),
        ),
      ),
    );
  }
}
