import 'package:flutter/material.dart';
import 'package:inventory_app/screens/models/cart.dart';
import 'package:inventory_app/screens/providers/user_provider.dart';
import 'package:provider/provider.dart';

import 'constants/routes.dart';
import 'screens/SplashScreens/splashscreen.dart';
import 'screens/providers/invoice_form_provider.dart';

void main() {
  runApp(
     MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => InvoiceFormData()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: Routes.routes,
    );
  }
}
