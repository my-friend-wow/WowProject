import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'friend.dart';

class VisitFriendRoomPage extends StatefulWidget {
  final String userId;
  final String token;
  final String friendId;
  final String friendDollName;

  const VisitFriendRoomPage({Key? key, required this.userId, required this.token, required this.friendId, required this.friendDollName}) : super(key : key);

  @override
  State<VisitFriendRoomPage> createState() => _VisitFriendRoomPageState();
}

class _VisitFriendRoomPageState extends State<VisitFriendRoomPage> {

  final String apiUrl = 'http://4.194.81.192:80/industry';
  Future<List<String>>? friendInfoFuture;

  Future<List<String>> _visitFriend(String userId, String token, String friendId, String friendDollName) async {
    List<String> friendInfo = [];
    final Map<String, String> headers = {
      'Authorization': '$token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(
        Uri.parse('$apiUrl/friend_room_get/$userId/$friendId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final friendLevel = data['friend_level'].toString();
        final myDollName = data['my_doll_name'].toString();
        final userLevel = data['user_level'].toString();
        friendInfo = [friendLevel, userLevel, myDollName];
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
    return friendInfo;
  }
  @override
  void initState() {
    super.initState();
    friendInfoFuture = _visitFriend(widget.userId, widget.token, widget.friendId, widget.friendDollName);
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
          title: Text('${widget.friendDollName}의 방', style: TextStyle(color: Colors.black)),
          centerTitle: true,
        ),
        body: FutureBuilder<List<String>> (
          future: friendInfoFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            else if (snapshot.hasError) {
              return Text('오류가 발생했습니다.');
            }
            else {
              String friendLevel = snapshot.data?[0] ?? '';
              String userLevel = snapshot.data?[1] ?? '';
              String myDollName = snapshot.data?[2] ?? '';

              return Center(
                child: Column(
                    children: [
                      SizedBox(height: 150),
                      Row(
                        children: [
                          Image.asset('assets/$userLevel.png', width: 200, height: 200),
                          Image.asset('assets/$friendLevel.png', width: 200, height: 200),
                        ],
                      ),
                      Row (
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              alignment: Alignment.center,
                              width: 200, height: 40,
                              decoration: BoxDecoration(
                                color: Colors.transparent, borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text('$myDollName', style: TextStyle(fontSize: 15, color: Colors.black),)
                          ),
                          Container(
                              alignment: Alignment.center,
                              width: 200, height: 40,
                              decoration: BoxDecoration(
                                color: Colors.transparent, borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text('${widget.friendDollName}', style: TextStyle(fontSize: 15, color: Colors.black),)
                          ),
                        ],
                      ),
                      SizedBox(height: 150),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(fixedSize: Size(300, 50), primary: Colors.orange),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('뒤로 가기', style: TextStyle(fontSize: 20, color: Colors.white))
                      )
                    ]
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

