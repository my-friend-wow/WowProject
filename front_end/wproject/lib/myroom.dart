import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class MyRoomPage extends StatefulWidget {
  final String userId;
  final String token;
  const MyRoomPage({Key? key, required this.userId, required this.token}) : super(key : key);

  @override
  State<MyRoomPage> createState() => _MyRoomPageState();
}

class _MyRoomPageState extends State<MyRoomPage> {
  final String apiUrl = 'http://4.194.81.192:80/industry';
  Future<List<String>>? characterInfoFuture;

  Future<List<String>> _myRoom (String userId, String token) async {
    List<String> characterInfo = [];
    final Map<String, String> headers = {
      'Authorization': '$token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(
        Uri.parse('$apiUrl/my_room_get/$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final userCoin = data['user_coin'].toString();
        final userLevel = data['user_level'].toString();
        characterInfo = [userCoin, userLevel];
      }
      else {
        showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              content: Text('연결에 문제가 발생했습니다.', style: TextStyle(fontSize: 20, color: Colors.black)),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(fixedSize: Size(300, 50), primary: Colors.orange),
                  child: Text('확인', style: TextStyle(fontSize: 20, color: Colors.white)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      }
    }

    catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            content: Text('서버와의 연결에 문제가 발생했습니다.', style: TextStyle(fontSize: 20, color: Colors.black)),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(fixedSize: Size(300, 50), primary: Colors.orange),
                child: Text('확인', style: TextStyle(fontSize: 20, color: Colors.white)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
    return characterInfo;
  }

  @override
  void initState() {
    super.initState();
    characterInfoFuture = _myRoom(widget.userId, widget.token);
  }

    @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/background.png'),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text('마이룸', style: TextStyle(color: Colors.black)),
          centerTitle: true,
        ),
        body: FutureBuilder<List<String>> (
          future: characterInfoFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            else if (snapshot.hasError) {
              return Text('오류가 발생했습니다.');
            }
            else {
              String userCoin = snapshot.data?[0] ?? '';
              String userLevel = snapshot.data?[1] ?? '';
              return Column(
                children: [
                  Image.asset('assets/$userLevel.png'),
                  SizedBox(height: 100),
                  Container(
                      width: 300, height: 100,
                      decoration: BoxDecoration(
                        color: Colors.orange, borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("나의 코인수: $userCoin", style: TextStyle(fontSize: 20, color: Colors.white),),
                            Text("나의 레벨: $userLevel", style: TextStyle(fontSize: 20, color: Colors.white),),
                          ]
                      )
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(fixedSize: Size(300, 50), primary: Colors.orange),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('뒤로 가기', style: TextStyle(fontSize: 20, color: Colors.white))
                  )
                ]
              );
            }
          },
        ),
      ),
    );
  }
}