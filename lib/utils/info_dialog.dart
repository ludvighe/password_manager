import 'package:flutter/material.dart';

void infoDialog(BuildContext context, String title, String info) {
  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: Text(title),
            content: Text(info),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Got it'))
            ],
          ));
}

void networkFailureDialog(BuildContext context, String action) {
  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: Text('Network failure'),
            content: Text(
                'Could not $action. Please check your internet connection. Otherwise this might be because the servers are currently down.'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Got it'))
            ],
          ));
}
