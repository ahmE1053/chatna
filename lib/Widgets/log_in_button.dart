import 'package:flutter/material.dart';
import 'package:cross_connectivity/cross_connectivity.dart' as connect;

class LogInButton extends StatelessWidget {
  final Function() function;
  const LogInButton({
    Key? key,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return connect.ConnectivityBuilder(builder: (context, isConnected, status) {
      return ElevatedButton(
        onPressed: isConnected == false ||
                status == connect.ConnectivityStatus.unknown
            ? () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content:
                        Text('Please connect to a network then try again')));
              }
            : () async {
                await function();
              },
        child: const Text(
          'Enter',
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
            const EdgeInsets.all(20),
          ),
          backgroundColor: isConnected == false ||
                  status == connect.ConnectivityStatus.unknown
              ? MaterialStateProperty.all(Colors.grey)
              : MaterialStateProperty.all(Colors.red),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      );
    });
  }
}
