import 'package:flutter/material.dart';

class MessageDisplay extends StatelessWidget {
  final String message;
  final String number;
  const MessageDisplay(
    this.message, {
    this.number,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          if (number != null)
            Text(
              number,
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                message,
                style: const TextStyle(fontSize: 30, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
