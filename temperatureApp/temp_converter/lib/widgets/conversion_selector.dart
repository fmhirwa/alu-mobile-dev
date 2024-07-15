import 'package:flutter/material.dart';

class ConversionSelector extends StatelessWidget {
  final bool isFahrenheitToCelsius;
  final ValueChanged<bool> onChanged;

  ConversionSelector({required this.isFahrenheitToCelsius, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.primary),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Radio<bool>(
            value: true,
            groupValue: isFahrenheitToCelsius,
            onChanged: (bool? value) {
              if (value != null) {
                onChanged(value);
              }
            },
          ),
          Flexible(child: Text('Fahrenheit to Celsius', style: TextStyle(fontFamily: 'Roboto', fontSize: 16))),
          Radio<bool>(
            value: false,
            groupValue: isFahrenheitToCelsius,
            onChanged: (bool? value) {
              if (value != null) {
                onChanged(value);
              }
            },
          ),
          Flexible(child: Text('Celsius to Fahrenheit', style: TextStyle(fontFamily: 'Roboto', fontSize: 16))),
        ],
      ),
    );
  }
}
