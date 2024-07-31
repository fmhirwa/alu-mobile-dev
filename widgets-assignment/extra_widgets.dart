import 'package:flutter/material.dart';

class ExtraWidgets extends StatelessWidget {
  @override
  Widget build(BuildContext contex) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Chip(
              label: Text('Chip Label'),
              avatar: Icon(Icons.security),
            ),
          ),
          SizedBox(height: 20),
          RotatedBox(
            quarterTurns: 1,
            child: Text('Rotated Text'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text('Item $index'),
                  leading: Icon(Icons.list),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
