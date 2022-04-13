import 'package:flutter/material.dart';


Container checkup(bool state, String good, String bad) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (state) ...[
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 30.0,
            ),
            Text(good)
          ] else ...[
            Icon(
              Icons.cancel,
              color: Colors.red,
              size: 30.0,
            ),
            Text(bad)
          ]
        ],
      ),
    );
  }
