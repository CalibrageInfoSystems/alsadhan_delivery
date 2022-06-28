import 'dart:convert';
import 'package:alsadhan_delivery_agent/DeliveryBoy/DeliveryBoyScreen.dart';
import 'package:alsadhan_delivery_agent/localdb/LocalDb.dart';
import 'package:alsadhan_delivery_agent/models/AllNotificationModel.dart';
import 'package:alsadhan_delivery_agent/models/DeliveryAgentOrdersModel.dart';
import 'package:alsadhan_delivery_agent/models/MyordersModel.dart';
import 'package:alsadhan_delivery_agent/models/message.dart';
import 'package:alsadhan_delivery_agent/services/api_constants.dart';
import 'package:alsadhan_delivery_agent/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart' as Datetime;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:toast/toast.dart';

bool isArabic = false;
int tabIndex = 0;
List<Widget> listScreens;
bool islogin = false;
LocalData localData = new LocalData();
List<Widget> originalList;
Map<int, bool> originalDic;
List<int> listScreensIndex;
DeliveryAgentOrdersModel deliveryAgentOrdersModel =
    new DeliveryAgentOrdersModel();
MyordersModel myOrders = new MyordersModel();
AllNotificationModel allNotificationModel;
Color tabColor = Colors.white;
Color selectedTabColor = Colors.amber;
int deliveryAgentId = 0;
ApiConnector apiConnector = new ApiConnector();
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
final List<Message> messages = [];
bool isLoading = false;
int pageIndex = 0;
int totalCount = 0;
int notificationIndex = 0;
//ScrollController _scrollController;

class NotificationScreen extends StatefulWidget {
  // NotificationScreen(int i);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String userid;
  var listResultResponse = [];

  String searchingString = isArabic == true ? "جلب البيانات" : 'Fetching Data';
  var formatter = new Datetime.DateFormat('dd-MM-yyyy HH:mm aa');
  var formatternew = new Datetime.DateFormat('dd-MM-yyyy');
  bool noOrdersrightnow = false;

  void initState() {
    super.initState();
    listResultResponse = [];
    deliveryAgentOrdersModel = new DeliveryAgentOrdersModel();
    // deliveryAgentOrdersModel = new DeliveryAgentOrdersModel();

    localData.getBoolValuesSF(LocalData.ISLOGIN).then((islogindata) {
      setState(() {
        if (islogindata != null) {
          islogin = islogindata;
        }
      });
    });

    localData.getIntToSF(LocalData.LOGINID).then((id) {
      print(" --- Login ID >>> " + id.toString());
      deliveryAgentId = id;
      pageIndex = 0;
      getAllNotifications(context, pageIndex);
    });

    _firebaseMessaging.getToken().then((token) {
      print("------>token is " + token);
      apiConnector
          .sendfirebasetokentoserverapicall(deliveryAgentId, token)
          .then((responses) {});
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage +++++++: $message");
        final notification = message['notification'];
        messages.add(Message(
              title: notification['title'], body: notification['body']));
              print("-- >> messages " + messages[0].title);

        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  content: ListTile(
                    title: Text('New Notification'),
                    subtitle:
                   // Text(notification),
                        Text(removeAllHtmlTags(messages[0].title)),
                  ),
                  actions: <Widget>[
                    FlatButton(
                        child: Text('ok'),
                        onPressed: () => Navigator.of(context).pop(getAllNotifications(context, 0))),
                  ],
                ));

        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => NotificationScreen()));
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch : $message");
        final notification = message['data'];
        handleRouting(notification);
        Navigator.push(
          context,
            MaterialPageRoute(builder: (context) => NotificationScreen()));
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume++++++++++++: $message");
        final notification = message['data'];
        handleRouting(notification);
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => NotificationScreen()));
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.yellow,
      home: DefaultTabController(
        length: 1,
        child: new Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                    Colors.blue,
                    Colors.blueAccent,
                    Colors.blue[900]
                  ])),
            ),
          title: new Text('All Notifications'),
            backgroundColor: Colors.blue[900],
            leading: new IconButton(
                icon: new Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => DeliveryBoyScreen(0)));
                  // Navigator.of(context).pushReplacement(new MaterialPageRoute(
                  //     builder: (context) => DeliveryBoyScreen(0)));
                }),
          ),
          body: new Container(
            color: Colors.white10,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(8),
                  child: SizedBox(
                    height: 30,
                    width: double.infinity,
                    child: RaisedButton(
                      color: Colors.grey[300],
                      padding: EdgeInsets.all(3),
                      onPressed: () {
                        apiConnector
                            .markAllReadNotificationsAPICall(deliveryAgentId)
                            .then((response) {
                          getAllNotifications(context, 0);
                          Navigator.of(context).push(new MaterialPageRoute(
                            builder: (context) => NotificationScreen()));
                        });
                      },
                      child: Text("Mark as All Read",
                          style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ),
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (!isLoading &&
                          scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent) {
                        pageIndex = pageIndex + 1;
                        if (listResultResponse.length <
                            allNotificationModel.affectedRecords) {
                          getAllNotifications(context, pageIndex);
                        }
                        // start loading data
                        print('--->>> listResultResponse.length' +
                            listResultResponse.length.toString());
                        print('--->>> total count' + totalCount.toString());
                        print('--->>> called Notiification listener');
                        setState(() {
                          isLoading = true;
                        });
                      }
                    },
                    child: ListView.builder(
                        itemCount: listResultResponse == null
                            ? 0
                            : listResultResponse.length,
                        itemBuilder: (BuildContext context, int index) {
                          var acceptButton = GestureDetector(
                            onTap: () {
                              print("--- >> " +
                                  listResultResponse[index].orderId.toString());
                              selfAssignAPICAllCalling(
                                      listResultResponse[index].orderId,
                                      deliveryAgentId,
                                      deliveryAgentId,
                                      DateTime.now().toString(),
                                      listResultResponse[index].id)
                                  .then((apiResponse) {});
                            },
                            child: Container(
                              height: 30,
                              width: 70,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Colors.blue[200],
                                    Colors.blueAccent
                                  ],
                                ),
                              ),
                              padding: const EdgeInsets.all(4.0),
                              child: Center(
                                child: Text(
                                  "Self Assign",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          );

                          var declineButton = GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 30,
                              width: 60,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Colors.blue[200],
                                    Colors.blueAccent
                                  ],
                                ),
                              ),
                              padding: const EdgeInsets.all(4.0),
                              child: Center(
                                child: Text(
                                  "Reject",
                                  //'Decline',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                  //style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 10))
                                ),
                              ),
                            ),
                          );
                          return Card(
                            elevation: 8,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(right: 10.0)),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            // Html(
                                            //   data:
                                            //       listResultResponse[index]
                                            //           .desc,
                                            // ),

                                            // Text('Order Id : '),
                                            // Text(
                                            //   listResultResponse[index]
                                            //       .orderId
                                            //       .toString(),
                                            //   style: TextStyle(
                                            //       color: Colors.blue[900]),
                                            // ),
                                          ],
                                        ),
                                        Text(
                                          removeAllHtmlTags(
                                              listResultResponse[index].desc),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: listResultResponse[index]
                                                          .isRead ==
                                                      false
                                                  ? Colors.blue[900]
                                                  : Colors.grey),
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Visibility(
                                                visible:
                                                    listResultResponse[index]
                                                                .isRead ==
                                                            false
                                                        ? true
                                                        : false,
                                                child: acceptButton),
                                            SizedBox(width: 8),

                                            // Visibility(
                                            // visible: listResultResponse[index]
                                            //                 .isRead == false ? true : false,
                                            // child: declineButton)
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<int> getAllNotifications(BuildContext context, int pageIndex) async {
    int code = 101;
    // bool isNetworkavailable = await Validator.isNetAvailable();
    // if (isNetworkavailable) {
    final notificationApi = BASEURL + GETALLNOTIFICATIONS_URL;
    final headers = {'Content-Type': 'application/json'};

    Map<String, dynamic> body = {
      "UserId": deliveryAgentId,
      "IsPagination": true,
      "PageIndex": pageIndex,
      "PageSize": 10
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    print('Request body -->> :' + jsonBody);
    Response response = await post(
      notificationApi,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );
    int statusCode = response.statusCode;
    code = statusCode;
    String responseBody = response.body;

    print('Notifications respons :' + responseBody);

    if (statusCode == 200) {
      print('status code 200');
      var userresponce = json.decode(responseBody);

      if (userresponce["IsSuccess"] == true) {
        setState(() {
          allNotificationModel = AllNotificationModel.fromJson(userresponce);
          print(' Notifications response -- >> ' + userresponce.toString());
          print(' Notifications Total Count  -- >> ' +
              allNotificationModel.affectedRecords.toString());

          if (allNotificationModel.listResult.length < 10) {
            print(' ---------- pagination completed');
          }
          listResultResponse.addAll(allNotificationModel.listResult);
          print('--->>> listResultResponse.length >>> ' +
              listResultResponse.length.toString());
          isLoading = false;
        });
      } else {}
    } else {
      datamsg = 'No Data Available';
    }
    return code;
  }

  Future<int> selfAssignAPICAllCalling(int orderID, int deliveryAgentId,
      int updatedByUserId, String updatedDate, int notificationID) async {
    int code = 101;
    String selfAssignAPI = BASEURL + SELFASSIGENURL;
    final headers = {'Content-Type': 'application/json'};

    Map<String, dynamic> body = {
      "OrderId": orderID,
      "DeliveryAgentId": deliveryAgentId,
      "UpdatedByUserId": deliveryAgentId,
      "UpdatedDate": updatedDate
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    print('Request body -->> :' + jsonBody);

    Response response = await post(
      selfAssignAPI,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );

    int statusCode = response.statusCode;
    code = statusCode;
    String responseBody = response.body;

    //Map<String, dynamic> parsedMAP = json.decode(responseBody);

    print('RES :' + responseBody);

    if (statusCode == 200) {
      print('status code 200');
      var userresponce = json.decode(responseBody);

      print('deliveryAgentOrdersModel -- >> ' + userresponce.toString());

      apiConnector
          .readSingleNotificationsAPICall(deliveryAgentId, notificationID)
          .then((response) {
        print("-- called readSingleNotificationsAPICall ---->> " +
            response.toString());
        getAllNotifications(context, 0);
      });

      if (userresponce["IsSuccess"] == true) {
        Toast.show(userresponce["EndUserMessage"], context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => DeliveryBoyScreen(1)));
      } else {
        Toast.show(userresponce["EndUserMessage"], context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => DeliveryBoyScreen(1)));
      }
    } else {
      print('status code not 200 -- >>');
    }
    return code;
  }

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    print("-- >> " + htmlText.replaceAll(exp, ''));

    return htmlText.replaceAll(exp, '');
  }

  mainDate(DateTime date) {
    var formatter = new Datetime.DateFormat('d MMMM y');
    String dates = formatter.format(date);
    print(dates); // something like 2013-04-20
    return dates;
  }

  void handleRouting(dynamic notification) {
    switch (notification['title']) {
      case 'first':
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => NotificationScreen()));
        break;
      case 'second':
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => NotificationScreen()));
        break;
    }
  }
}
