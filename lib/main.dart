import 'package:flutter/material.dart';
import 'package:password_manager/providers/User.dart';
import 'package:password_manager/providers/master_password.dart';
import 'package:password_manager/providers/password_data_list.dart';
import 'package:password_manager/screens/start_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => MasterPassword()),
    ChangeNotifierProvider(create: (_) => PasswordDataList()),
    ChangeNotifierProvider(create: (_) => User.empty())
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StartScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
