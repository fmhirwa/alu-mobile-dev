import 'package:flutter/material.dart';

class HistoryList extends StatelessWidget {
  final List<String> history;

  HistoryList({required this.history});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'History',
            style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),
          ),
          Container(
            height: 200,
            child: ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(history[index], style: TextStyle(fontFamily: 'Roboto')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
