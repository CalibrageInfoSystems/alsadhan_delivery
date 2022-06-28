import 'dart:convert';
import 'dart:wasm';

import 'package:alsadhan_delivery_agent/localdb/LocalDb.dart';
import 'package:alsadhan_delivery_agent/models/message.dart';
import 'package:alsadhan_delivery_agent/services/api_constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:progress_dialog/progress_dialog.dart';

LocalData localData;
String userID;
ProgressDialog progressDialog;
int pageIndex = 0;
int totalCount = 0;
var _datamsg = "";

class MessagingWidget extends StatefulWidget {
  @override
  _MessagingWidgetState createState() => _MessagingWidgetState();
}

class _MessagingWidgetState extends State<MessagingWidget> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final List<Message> messages = [];
  bool isLoading = false;
  var listResultResponse = [];
  @override
  void initState() {
    super.initState();
  localData = new LocalData();
    localData.getStringValueSF(LocalData.USER_ID).then((_userID) {
      userID = _userID;
      pageIndex = 0;
      totalCount = 0;
      listResultResponse = [];
      getAllNotifications();
    });

    _firebaseMessaging.getToken().then((token){
      print("------>token is " + token);
    });
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final notification = message['notification'];
        setState(() {
          messages.add(Message(
              title: notification['title'], body: notification['body']));
        });
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MessagingWidget()));
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MessagingWidget()));

        final notification = message['data'];
        setState(() {
          messages.add(Message(
            title: '${notification['title']}',
            body: '${notification['body']}',
          ));
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MessagingWidget()));
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          title: new Text('Notifications'),
        ),
        body: ListView(  
                  children: messages.map(buildMessage).toList(),  
                ),
      ),
    );
  }

  Widget buildMessage(Message message) => ListTile(
        title: Text(message.title),
        subtitle: Text(message.body),
      );

  Future<Void> getAllNotifications() async {
    print('UserID -->> ' + userID);

    // progressDialog.show();
    final uri = BASEURL + GETALLNOTIFICATIONS_URL;

    print(' ---- GetAllNotifications  API :' + uri);
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      "UserId": 9,
      "IsPagination": true,
      "PageIndex": 3,
      "PageSize": 4
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');
    print(' Post OBJ :' + jsonBody);
    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );
    int statusCode = response.statusCode;
    String responseBody = response.body;
    print(' Res Body :' + responseBody);
    // progressDialog.dismiss();
    if (statusCode == 200) {
      Map<String, dynamic> parsedMAP = json.decode(responseBody);

      setState(() {
        //listResultResponse = parsedMAP["listResult"] as List;
        var item = parsedMAP["listResult"] as List;
        if (item.length < 10) {
          print(' ---------- pagination completed');
        }
        listResultResponse.addAll(parsedMAP["listResult"]);
        totalCount = parsedMAP["affectedRecords"];
        //  if (totalCount >  listResultResponse.length) {
        //    listResultResponse.addAll(parsedMAP["listResult"]);
        //  }
        print('--->>> listResultResponse.length' +
            listResultResponse.length.toString());
        print('--->>> total count' + totalCount.toString());
        isLoading = false;
        if (listResultResponse == null ||
            listResultResponse.length == null ||
            listResultResponse.length == 0) {
          _datamsg = 'No Data Available';
        }
      });
    } else {
      // pr.dismiss();

    }
  }
  
}