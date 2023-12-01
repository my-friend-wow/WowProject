import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold (
      backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text('인형과 대화', style: TextStyle(color: Colors.black)),
          centerTitle: true,
        ),
        body: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: 300, height: 100,
                      decoration: BoxDecoration(
                        color: Colors.orange, borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("인형 버튼을 누르고 말을 걸면", style: TextStyle(fontSize: 20, color: Colors.white),),
                            Text("인형과 대화할 수 있어요!", style: TextStyle(fontSize: 20, color: Colors.white),),
                          ]
                      )
                  ),
                  SizedBox(height:10),
                  Image.asset('assets/conversation1.png'),
                  SizedBox(height:10),
                  Image.asset('assets/conversation2.png'),
                  SizedBox(height: 30),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(fixedSize: Size(300, 50), primary: Colors.orange),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('뒤로 가기', style: TextStyle(fontSize: 20, color: Colors.white))
                  ),
                ],
              ),
            )
        )
    );
  }
}