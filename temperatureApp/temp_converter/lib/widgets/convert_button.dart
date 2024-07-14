import 'package:flutter/material.dart';

class ConvertButton extends StatefulWidget {
  final VoidCallback onPressed;

  ConvertButton({required this.onPressed});

  @override
  _ConvertButtonState createState() => _ConvertButtonState();
}

class _ConvertButtonState extends State<ConvertButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            widget.onPressed();
            _controller.forward(from: 0.0);
            setState(() {
              _isPressed = true;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _isPressed ? Colors.lightBlue : null,
          ),
          child: Text('Convert'),
        ),
        SizeTransition(
          sizeFactor: _animation,
          axisAlignment: -1.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.check, color: Colors.green, size: 50),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
