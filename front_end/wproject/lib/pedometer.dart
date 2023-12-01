import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'signin.dart';

class PedometerPage extends StatefulWidget {
  final String userId;
  final String token;

  const PedometerPage({Key? key, required this.userId, required this.token}) : super(key : key);

  @override
  State<PedometerPage> createState() => _PedometerPageState();
}

class _PedometerPageState extends State<PedometerPage> {
  final String apiUrl = 'http://4.194.81.192:80/industry';

  Future<void> _pedometer(String userId, String token) async { //걸음 수 얻기 위해 실시간 보내는 GET 요청
    final Map<String, String> headers = {
      'Authorization': '$token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(
        Uri.parse('$apiUrl/pedometer_get/$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) { //성공
        final data = json.decode(response.body);
        final stepCount = data['step_count'].toString();

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text('$stepCount 걸음을 걸었어요', style: TextStyle(fontSize: 20, color: Colors.black), textAlign: TextAlign.center),
                actions: [
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(fixedSize: Size(120, 20), primary: Colors.orange),
                        onPressed: () async {
                          await _exchangeStepsForCoin(userId, token);
                        },
                        child: Text('코인 받기', style: TextStyle(fontSize: 20, color: Colors.white)),
                      ),
                      SizedBox(width: 60),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(fixedSize: Size(80, 20), primary: Colors.orange),
                        onPressed: () {
                          Navigator.of(context).pop();
                          },
                        child: Text('확인', style: TextStyle(fontSize: 20, color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              );
            }
        );
      }

      else if (response.statusCode == 404 || response.statusCode == 401) {
        final data = json.decode(response.body);
        final message = data['message'];

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(message, style: TextStyle(fontSize: 20, color: Colors.black)),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(fixedSize: Size(80, 20), primary: Colors.orange),
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

    catch (e) { //서버 연결 x
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            content: Text('서버와의 연결에 문제가 발생했습니다.', style: TextStyle(fontSize: 20, color: Colors.black)),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(fixedSize: Size(80, 20), primary: Colors.orange),
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

  Future<void> _exchangeStepsForCoin(String userId, String token) async { // 걸음수와 코인 교환 post 요청

    final Map<String, String> headers = {
      'Authorization': '$token',
      'Content-Type': 'application/json',
    };

    final userData = {
      'user_id': userId,
    };

    try {
      final response = await http.post(
        Uri.parse('$apiUrl/pedometer_coin_exchange'),
        headers: headers,
        body: json.encode(userData),
      );

      if (response.statusCode == 200) { //성공
        final data = json.decode(response.body);
        final message = data['message'];

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(message, style: TextStyle(fontSize: 20, color: Colors.black)),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(fixedSize: Size(80, 20), primary: Colors.orange),
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

      else if(response.statusCode == 422 || response.statusCode == 500  || response.statusCode == 401) { //실패 - 이미 코인을 교환한 경우
        final data = json.decode(response.body);
        final message = data['message'];

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(message, style: TextStyle(fontSize: 15, color: Colors.black)),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(fixedSize: Size(80, 20), primary: Colors.orange),
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
                style: ElevatedButton.styleFrom(fixedSize: Size(80, 20), primary: Colors.orange),
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
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/background_pedometer.png'),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text('산 책', style: TextStyle(color: Colors.black)),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Text('오늘 얼마나 걸었는지 확인해보세요!', style: TextStyle(fontSize: 20, color: Colors.black)),
            Image.asset('assets/pedometer.png', width: 500, height: 500,),
            ElevatedButton(
                style: ElevatedButton.styleFrom(fixedSize: Size(300, 50), primary: Colors.orange),
                onPressed: () {
                  _pedometer(widget.userId, widget.token);
                  },
                child: Text('걸음수 보기', style: TextStyle(fontSize: 20, color: Colors.white))
            ),
            SizedBox(height: 30),
            ElevatedButton(
                style: ElevatedButton.styleFrom(fixedSize: Size(300, 50), primary: Colors.orange),
                onPressed: () {
                  Navigator.pop(context);
                  },
                child: Text('뒤로 가기', style: TextStyle(fontSize: 20, color: Colors.white))
            )
          ],
        ),
      ),
    );
  }
}