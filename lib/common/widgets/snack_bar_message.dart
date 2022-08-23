import 'package:flutter/material.dart';

class SnackBarMessage extends StatelessWidget {
  const SnackBarMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Colors.white,
          ),
    );
  }
}
