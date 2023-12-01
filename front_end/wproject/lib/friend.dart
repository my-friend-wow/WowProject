import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'visit.dart';

class FriendListPage extends StatefulWidget {
  final String userId;
  final String token;

  const FriendListPage({Key? key, required this.userId, required this.token}) : super(key : key);

  @override
  State<FriendListPage> createState() => _FriendListPageState();
}

class _FriendListPageState extends State<FriendListPage> {

  final String apiUrl = 'http://4.194.81.192:80/industry';
  Future<List<dynamic>>? friendListFuture;

  Future<List<dynamic>> _NearbyFriendsList(String userId, String token) async{
    List<dynamic> friendList = [];
    final Map<String, String> headers = {
      'Authorization': '$token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(
        Uri.parse('$apiUrl/friend_get/$userId'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        friendList = json.decode(response.body);
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
    return friendList;

  }

  @override
  void initState() {
    super.initState();
    friendListFuture = _NearbyFriendsList(widget.userId, widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('친구 목록 보기', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: friendListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          else if (snapshot.hasError) {
            return Text('오류가 발생했습니다.');
          }
          else {
            return Column(
              children: [
                SizedBox(height: 50),
                Container(
                  height: 500,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orange),
                  ),
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('${snapshot.data![index]['doll_name']}'),
                        subtitle: Text('${snapshot.data![index]['user_id']}'),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.orange),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => VisitFriendRoomPage(
                                  userId: widget.userId, token: widget.token,
                                  friendId: '${snapshot.data![index]['user_id']}', friendDollName: '${snapshot.data![index]['doll_name']}')
                              ),
                            );
                          },
                          child: Text('${snapshot.data![index]['doll_name']}의 방'),
                        ),
                      );
                      },
                  ),
                ),
                SizedBox(height: 50),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(fixedSize: Size(300, 50), primary: Colors.orange),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('뒤로 가기', style: TextStyle(fontSize: 20, color: Colors.white))
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
