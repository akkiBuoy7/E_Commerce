import 'package:e_commerce/ui/login.dart';
import 'package:e_commerce/ui/product_listing.dart';
import 'package:e_commerce/ui/splash.dart';
import 'package:e_commerce/utility/project_util.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: ProjectUtil.SPLASH_SCREEN_ROUTE,
      routes: {
        ProjectUtil.SPLASH_SCREEN_ROUTE: (context) => SplashScreen(),
        ProjectUtil.LOGIN_SCREEN_ROUTE: (context) => LoginScreen(),
        ProjectUtil.PRODUCTS_LISTING_SCREEN_ROUTE: (context) => ProductListing(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}