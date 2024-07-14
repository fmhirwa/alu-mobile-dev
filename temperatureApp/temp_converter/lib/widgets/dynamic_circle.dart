import 'package:flutter/material.dart';

class DynamicCircle extends StatefulWidget {
  final ValueChanged<double> onChanged;

  DynamicCircle({required this.onChanged});

  @override
  _DynamicCircleState createState() => _DynamicCircleState();
}

class _DynamicCircleState extends State<DynamicCircle> {
  double _currentValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              _currentValue = (details.localPosition.dy / 200).clamp(-1.0, 1.0) * 50;
              widget.onChanged(_currentValue);
            });
          },
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Theme.of(context).colorScheme.primary, width: 4),
            ),
            child: Center(
              child: Text(
                '${_currentValue.toStringAsFixed(1)}°',
                style: TextStyle(fontSize: 24, fontFamily: 'Roboto'),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Adjust the temperature by moving along the circle',
            style: TextStyle(fontFamily: 'Roboto', fontSize: 16),
          ),
        ),
      ],
    );
  }
}
