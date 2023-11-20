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
    print('서버 요청, 헤더에 포함된 토큰: $token');
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
                content: Text('걸음수: $stepCount'),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('확인'),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        await _exchangeStepsForCoin(userId, token);
                      },
                      child: Text('코인 받기'),
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
              content: Text(message),
              actions: [
                ElevatedButton(
                  child: Text('확인'),
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
            content: Text('서버와의 연결에 문제가 발생했습니다.'),
            actions: [
              ElevatedButton(
                child: Text('확인'),
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
              content: Text(message),
              actions: [
                ElevatedButton(
                  child: Text('확인'),
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
              content: Text(message),
              actions: [
                ElevatedButton(
                  child: Text('확인'),
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
            content: Text('서버와의 연결에 문제가 발생했습니다.'),
            actions: [
              ElevatedButton(
                child: Text('확인'),
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Row(
          children: [
            ElevatedButton(
                onPressed: () {
                  _pedometer(widget.userId, widget.token);
                },
                child: Text('산책 시작')
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  },
                child: Text('뒤로')
            )
          ],
        ),
      ),
    );
  }
}
