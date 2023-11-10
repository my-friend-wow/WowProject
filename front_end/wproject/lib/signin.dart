import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

// 로그인
class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  TextEditingController userIdController = TextEditingController();
  TextEditingController userPwController = TextEditingController();

  Future<void> _signIn() async {
    final String apiUrl = 'http://4.194.81.192:80/industry/signin';

    final userData = {
      'user_id': userIdController.text,
      'user_pw': userPwController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );

      if (response.statusCode == 200) {  // 로그인 성공
        final data = json.decode(response.body);
        final message = data['message'];
        final token = data['token'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(message),
              actions: [
                TextButton(
                  child: Text('확인'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainPage()),
                    );
                  },
                ),
              ],
            );
          },
        );
      }

      else if (response.statusCode == 404 || response.statusCode == 401) { // 로그인 실패(아이디 존재 X)
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
            actions:[
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
    return MaterialApp( // 디자인
      home: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            TextField(
              controller: userIdController,
              decoration: InputDecoration(labelText:'아이디'),
            ),
            TextField(
              controller: userPwController,
              obscureText: true,
              decoration: InputDecoration(labelText:'비밀번호'),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _signIn,
                  child: Text('로그인'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUpPage()),
                    );
                  },
                  child: Text('회원가입'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//회원가입
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

//회원가입
class _SignUpPageState extends State<SignUpPage> {

  TextEditingController userIdController = TextEditingController();
  TextEditingController userPwController = TextEditingController();
  TextEditingController dollNameController = TextEditingController();
  TextEditingController dollIdController = TextEditingController();

  Future<void> _signUp() async {
    final String apiUrl = 'http://4.194.81.192:80/industry/signup';

    final userData = {
      'user_id': userIdController.text,
      'user_pw': userPwController.text,
      'doll_name': dollNameController.text,
      'doll_id': dollIdController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );

      if (response.statusCode == 201) { //회원가입 성공
        final data = json.decode(response.body);
        final message = data['mesage'];

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(message),
              actions: [
                TextButton(
                  child: Text('확인'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignInPage())
                    );
                  },
                ),
              ],
            );
          },
        );
      }

      else if (response.statusCode == 400 || response.statusCode == 422 ||
          response.statusCode == 500) { //회원가입 실패(이미 회원가입한 적이 있을 때)
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

    catch(e) {
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
        appBar: AppBar(

        ),
        body: Column(
          children: [
            TextField(
              controller: userIdController,
              decoration: InputDecoration(labelText: '아이디'),
            ),
            TextField(
              controller: userPwController,
              obscureText: true,
              decoration: InputDecoration(labelText: '비밀번호'),
            ),
            TextField(
              controller: dollNameController,
              decoration: InputDecoration(labelText: '인형이름'),
            ),
            TextField(
              controller: dollIdController,
              decoration: InputDecoration(labelText: '인형아이디'),
            ),
            Row(
              children: [
                ElevatedButton(onPressed: () {
                  Navigator.pop(context);
                },
                    child: Text('뒤로')
                ),
                ElevatedButton(
                    onPressed: _signUp,
                    child: Text('회원가입')
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
