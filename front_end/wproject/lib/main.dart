import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'signin.dart';
import 'pedometer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignInPage(),
    );
  }
}

//메인
class MainPage extends StatefulWidget {

  final String userId;
  final String token;

  const MainPage({Key? key, required this.userId, required this.token}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}
//메인
class _MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            ElevatedButton(
                onPressed: (){
                  print('MainPage로 이동, 토큰: ${widget.token}');
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PedometerPage(userId: widget.userId, token: widget.token)),
                  );
                },
                child: Text('산책'),
            ),

          ],
        ),
      ),
    );
  }
}