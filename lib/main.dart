import 'package:e_commerce_app/pages/splash_screen.dart';
import 'package:e_commerce_app/viewmodel/cart_viewmodel.dart';
import 'package:e_commerce_app/viewmodel/dashboard_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ), // <-- CartProvider is here
        ChangeNotifierProvider(
          create: (_) => ProductProvider(),
        ), // ProductProvider is here
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Commerce-App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: SplashScreen(),
      ),
    );
  }
}
