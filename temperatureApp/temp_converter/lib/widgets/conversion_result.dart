import 'package:flutter/material.dart';

class ConversionResult extends StatelessWidget {
  final String result;

  ConversionResult({required this.result});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Converted Value:',
            style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.only(top: 8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.primary),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              result,
              style: TextStyle(fontSize: 48, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
