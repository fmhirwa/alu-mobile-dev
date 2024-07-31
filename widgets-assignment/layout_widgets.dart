import 'package:flutter/material.dart';

class LayoutWidgets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 50,
            left: 10,
            child: Text('Top Positioned Text'),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.blue,
              height: 50,
              width: double.infinit,
              child: Center(
                child: Text('Bottom Bar'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
