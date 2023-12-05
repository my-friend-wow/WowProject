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
              content: Text(message, style: TextStyle(fontSize: 20, color: Colors.black),),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(fixedSize: Size(80, 20), primary: Colors.orange),
                  child: Text('확인', style: TextStyle(fontSize: 15, color: Colors.white),),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainPage(userId: userIdController.text, token: token)),
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
              content: Text(message, style: TextStyle(fontSize: 20, color: Colors.black),),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(fixedSize: Size(80, 20), primary: Colors.orange),
                  child: Text('확인', style: TextStyle(fontSize: 15, color: Colors.white),),
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
            content: Text('서버와의 연결에 문제가 발생했습니다.', style: TextStyle(fontSize: 20, color: Colors.black),),
            actions:[
              ElevatedButton(
                style: ElevatedButton.styleFrom(fixedSize: Size(80, 20), primary: Colors.orange),
                child: Text('확인', style: TextStyle(fontSize: 15, color: Colors.white),),
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text('로그인', style: TextStyle(color: Colors.black)),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: userIdController,
              decoration: InputDecoration(labelText:'아이디'),
            ),
            SizedBox(height: 30),
            TextField(
              controller: userPwController,
              obscureText: true,
              decoration: InputDecoration(labelText:'비밀번호'),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 60),
                ElevatedButton(
                    onPressed: _signIn,
                    child: Text('로그인', style: TextStyle(fontSize: 20,
                        color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(300, 50), primary: Colors.orange)
                ),
                SizedBox(height: 16),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpPage()),
                      );
                    },
                    child: Text('회원가입', style: TextStyle(fontSize: 20,
                        color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(300, 50), primary: Colors.orange)
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
        final message = data['message'];

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(message, style: TextStyle(fontSize: 20, color: Colors.black),),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(fixedSize: Size(80, 20), primary: Colors.orange),
                  child: Text('확인', style: TextStyle(fontSize: 15, color: Colors.white),),
                  onPressed: () {
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
              content: Text(message, style: TextStyle(fontSize: 20, color: Colors.black),),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(fixedSize: Size(80, 20), primary: Colors.orange),
                  child: Text('확인', style: TextStyle(fontSize: 15, color: Colors.white),),
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
            content: Text('서버와의 연결에 문제가 발생했습니다.', style: TextStyle(fontSize: 20, color: Colors.black),),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(fixedSize: Size(80, 20), primary: Colors.orange),
                child: Text('확인', style: TextStyle(fontSize: 15, color: Colors.white),),
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
    return Scaffold (
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('회원가입', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: userIdController,
            decoration: InputDecoration(labelText: '아이디'),
          ),
          SizedBox(height: 30),
          TextField(
            controller: userPwController,
            obscureText: true,
            decoration: InputDecoration(labelText: '비밀번호'),
          ),
          SizedBox(height: 30),
          TextField(
            controller: dollNameController,
            decoration: InputDecoration(labelText: '인형이름'),
          ),
          SizedBox(height: 30),
          TextField(
            controller: dollIdController,
            decoration: InputDecoration(labelText: '인형아이디(시리얼넘버)'),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 60),
              ElevatedButton(
                  onPressed: _signUp,
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(300, 50),
                    primary: Colors.orange,
                  ),
                  child: Text('회원 가입', style: TextStyle(fontSize: 20,
                      color: Colors.white),)
              ),
              SizedBox(height: 16),
              ElevatedButton(onPressed: () {
                Navigator.pop(context);
                },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(300, 50),
                    primary: Colors.orange,
                  ),
                  child: Text('뒤로 가기', style: TextStyle(fontSize: 20,
                      color: Colors.white),)
              ),
            ],
          )
        ],
      ),
    );
  }
}