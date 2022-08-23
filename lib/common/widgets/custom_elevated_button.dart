import 'package:flutter/material.dart';
import 'package:notes_app/common/common.dart';

class CustomElevatedButton extends StatelessWidget {
  final Widget widget;
  final Function() onPressed;

  const CustomElevatedButton({
    required this.widget,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(kSidePadding, 16.0, kSidePadding, 16.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: kButtonColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
        child: widget,
      ),
    );
  }
}
