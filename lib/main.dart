import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:may_protect/view/dashboard.dart';
import 'package:may_protect/view/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final String title = '';
  final storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<String>(
        future: _getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Some error has Occurred');
          } else if (snapshot.hasData && snapshot.data != null) {
            final token = snapshot.data;
            if (token != null && token.isNotEmpty) {
              return Dashboard(title: title);
            } else {
              return Login();
            }
          } else {
            return Login();
          }
        },
      ),
    );
  }

  Future<String> _getToken() async {
    return await storage.read(key: 'token') ?? '';
  }
}
