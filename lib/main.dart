import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './models/product_database.dart';
import './contents/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final productDatabase = await ProductDatabase.initialize();
  runApp(MyApp(productDatabase: productDatabase));
}

class MyApp extends StatelessWidget {
  final ProductDatabase productDatabase;

  MyApp({required this.productDatabase});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: productDatabase),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Store Manager',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginScreen(),
      ),
    );
  }
}
