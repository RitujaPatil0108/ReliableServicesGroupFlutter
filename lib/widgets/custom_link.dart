import 'package:flutter/material.dart';
import '../constants/colors_constants.dart';

class CustomSignUpLink extends StatelessWidget {
  final Function() onTap;
  final String dontHaveAccountText;
  final String signUpText;

  const CustomSignUpLink({super.key, 
    required this.onTap,
    required this.dontHaveAccountText,
    required this.signUpText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: RichText(
        text: TextSpan(
          text: dontHaveAccountText,
          style: const TextStyle(color: ColorsConstants.authtext),
          children: [
            TextSpan(
              text: signUpText,
              style: const TextStyle(color: ColorsConstants.buttonColor),
            ),
          ],
        ),
      ),
    );
  }
}
