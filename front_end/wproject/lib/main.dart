import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'conversation.dart';
import 'friend.dart';
import 'myroom.dart';
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          title: Text('메인 화면', style: TextStyle(color: Colors.black)),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
            child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(fixedSize: Size(300, 50), primary: Colors.orange),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MyRoomPage(userId: widget.userId, token: widget.token,)),
                          );
                        },
                        child: Text('마이룸', style: TextStyle(fontSize: 20, color: Colors.white),)
                    ),
                    SizedBox(height: 60),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(fixedSize: Size(300, 50), primary: Colors.orange),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FriendListPage(userId: widget.userId, token: widget.token)),
                          );
                        },
                        child: Text('친구 집 방문', style: TextStyle(fontSize: 20, color: Colors.white),)
                    ),
                    SizedBox(height: 60),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(fixedSize: Size(300, 50), primary: Colors.orange),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ConversationPage()),
                          );
                        },
                        child: Text('인형과의 대화(설명서)', style: TextStyle(fontSize: 20, color: Colors.white),)
                    ),
                    SizedBox(height: 60),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(fixedSize: Size(300, 50), primary: Colors.orange),
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PedometerPage(userId: widget.userId, token: widget.token)),
                        );
                      },
                      child: Text('오늘의 걸음수', style: TextStyle(fontSize: 20, color: Colors.white),),
                    ),
                  ],
                )
            )
        ),
      ),
    );
  }
}