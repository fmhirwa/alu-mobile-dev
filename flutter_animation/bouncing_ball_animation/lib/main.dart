import 'package:flutter/material.dart';

void main() {
  runApp(BouncingBallApp());
}

class BouncingBallApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BouncingBallPage(),
    );
  }
}

class BouncingBallPage extends StatefulWidget {
  @override
  _BouncingBallPageState createState() => _BouncingBallPageState();
}

class _BouncingBallPageState extends State<BouncingBallPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceIn,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bouncing Ball Animation'),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, -_animation.value * 300),
              child: child,
            );
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
