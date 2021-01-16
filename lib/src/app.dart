import 'package:flutter/material.dart';
import 'package:corazon_customerapp/src/res/app_theme.dart';
import 'package:corazon_customerapp/src/routes/router.gr.dart';
import 'package:corazon_customerapp/src/ui/screens/splash_screen.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.appTheme(),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRouter(),
      initialRoute: Routes.splashScreen,
      home: SplashScreen(),
    );
  }
}
