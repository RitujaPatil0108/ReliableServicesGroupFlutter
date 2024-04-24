// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBackButton extends StatelessWidget {
  final BuildContext context;

  const CustomBackButton({Key? key, required this.context}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: SvgPicture.asset(
        'assets/images/arrowleft.svg',
        color: Colors.blue, 
      ),
      onPressed: () {
        Navigator.pop(this.context);
      },
    );
  }
}
