import 'dart:convert';

import 'package:alsadhan_delivery_agent/DeliveryBoy/CreateNewOrder.dart';
import 'package:alsadhan_delivery_agent/DeliveryBoy/OrderDetailsNew.dart';
import 'package:alsadhan_delivery_agent/DeliveryBoy/OrderDetailsScreen.dart';
import 'package:alsadhan_delivery_agent/Notification/allNotificationScreen.dart';
import 'package:alsadhan_delivery_agent/profile/ProfileScrren.dart';
import 'package:alsadhan_delivery_agent/localdb/LocalDb.dart';

import 'package:alsadhan_delivery_agent/models/AllNotificationModel.dart';
import 'package:alsadhan_delivery_agent/models/DeliveryAgentOrdersModel.dart';
import 'package:alsadhan_delivery_agent/models/MyordersModel.dart';
import 'package:alsadhan_delivery_agent/models/OrdersCountModel.dart';
import 'package:alsadhan_delivery_agent/models/message.dart';
import 'package:alsadhan_delivery_agent/services/api_constants.dart';
import 'package:alsadhan_delivery_agent/services/api_service.dart';
import 'package:alsadhan_delivery_agent/widgets/Validator.dart';
import 'package:alsadhan_delivery_agent/widgets/appDrawer.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart' as Datetime;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:toast/toast.dart';

bool isArabic = false;
String hintText;
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
ScrollController _scrollController;
TextEditingController searchTextController = new TextEditingController();
int unreadNotifications = 0;
int tripsCount = 0;
int deviveredCount = 0;
int cancelledCount = 0;

OrdersCountModel ordersCountModel = new OrdersCountModel();

class DeliveryBoyScreen extends StatefulWidget {
  DeliveryBoyScreen(int tabIndex);
  @override
  _DeliveryBoyScreenState createState() => _DeliveryBoyScreenState();
}

class _DeliveryBoyScreenState extends State<DeliveryBoyScreen> {
  String userid;
  var listResultResponse = [];
  Status selectedStatus;
  DateTime pickedDate;
  DateTime todate;
  TimeOfDay time;

  String searchingString = isArabic == true ? "جلب البيانات" : 'Fetching Data';
  var formatter = new Datetime.DateFormat('dd-MM-yyyy HH:mm aa');
  var formatternew = new Datetime.DateFormat('dd-MM-yyyy');
  bool noOrdersrightnow = false;
  int _trips = 0, _pastTrips = 0, _canceledTrips = 0;

  

  void initState() {
    super.initState();
    pickedDate = DateTime.now();
    todate = DateTime.now();
    // time = TimeOfDay.now();

    listResultResponse = [];
    deliveryAgentOrdersModel = new DeliveryAgentOrdersModel();
    ordersCountModel = new OrdersCountModel();

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

      apiConnector.deliveryOrdersAPICAllCalling(id).then((response) {
        setState(() {
          deliveryAgentOrdersModel = response;
        });
      });

      apiConnector.getUnReadNotifications(id).then((response) {
        // print('::: unread notifications -->>  ' + response.toString());
        if (response != null) {
          setState(() {
            unreadNotifications = response.length;
          });
        } else {
          unreadNotifications = 0;
        }
      });

      apiConnector.getOrdersCountAPICall(deliveryAgentId).then((response) {
        print(':::::::::::::: getOrdersCount response -->>  ' +
            response.toString());
        if (response != null) {
          setState(() {
            ordersCountModel = response;
            _trips = ordersCountModel.result.received == null
                ? 0
                : ordersCountModel.result.received;
            _pastTrips = ordersCountModel.result.delivered == null
                ? 0
                : ordersCountModel.result.delivered;
            _canceledTrips = ordersCountModel.result.cancelled == null
                ? 0
                : ordersCountModel.result.cancelled;
            // _pastTrips = ordersCountModel.result.received
          });
        }
        setState(() {
          print('::: getOrdersCount -->>  ' +
              ordersCountModel.result.cancelled.toString());
        });
      });
    });

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

    _firebaseMessaging.getToken().then((token) {
      print("------>device token is --  " + token.toString());

      apiConnector
          .sendfirebasetokentoserverapicall(deliveryAgentId, token)
          .then((responses) {});
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final notification = message['notification'];
        setState(() {
          apiConnector.getUnReadNotifications(deliveryAgentId).then((response) {
            // print('::: unread notifications -->>  ' + response.toString());
            if (response != null) {
              setState(() {
                unreadNotifications = response.length;
              });
            } else {
              unreadNotifications = 0;
            }
          });
          messages.add(Message(
              title: notification['title'], body: notification['body']));
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    content: ListTile(
                      title: Text('New Notification'),
                      subtitle: Text(removeAllHtmlTags(messages[0].title)),
                    ),
                    actions: <Widget>[
                      FlatButton(
                          child: Text('ok'),
                          onPressed: () => Navigator.of(context).pop()),
                    ],
                  ));
          // Navigator.of(context).push(new MaterialPageRoute(
          //           builder: (context) => NotificationScreen()));
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

        Navigator.of(context).push(
            new MaterialPageRoute(builder: (context) => NotificationScreen()));

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
        Navigator.of(context).push(
            new MaterialPageRoute(builder: (context) => NotificationScreen()));
      },
    );

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme:
          ThemeData(primaryIconTheme: IconThemeData(color: Colors.indigo[900])),
      debugShowCheckedModeBanner: false,
      color: Colors.yellow,
      home: DefaultTabController(
        length: 3,
        child: new Scaffold(
          appBar: AppBar(
            bottom: PreferredSize(
                child: Container(color: Colors.indigo[900], height: 4.0),
                preferredSize: Size.fromHeight(4.0)),
            flexibleSpace: Container(
              decoration: BoxDecoration(color: Colors.white),
            ),
            title: new Text(''),
            actions: <Widget>[
              new Stack(
                children: <Widget>[
                  new IconButton(
                      icon: Icon(Icons.notifications_none, size: 35),
                      onPressed: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (context) => NotificationScreen()));
                      }),
                  unreadNotifications != 0
                      ? new Positioned(
                          right: 10,
                          top: 8,
                          child: new Container(
                            padding: EdgeInsets.all(2),
                            decoration: new BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 15,
                              minHeight: 14,
                            ),
                            child: Text(
                              '$unreadNotifications',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : new Container()
                ],
              ),
            ],
          ),
          drawer: AppDrawer(),
          body: Container(
            child: Column(
              children: <Widget>[
                // Container(
                //     margin: EdgeInsets.all(5),
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(3),
                //         border: Border.all(color: Colors.blue[900])),
                //     height: 50,
                //     child: new ListTile(
                //       // leading: new Icon(Icons.search),
                //       title: new TextField(
                //         controller: searchTextController,
                //         decoration: new InputDecoration(
                //             hintText: 'Search', border: InputBorder.none),
                //         // onChanged: onSearchTextChanged,
                //       ),
                //       trailing: new IconButton(
                //         icon: new Icon(
                //           Icons.search,
                //           color: Colors.blue[900],
                //         ),
                //         onPressed: () {},
                //       ),
                //     )),
                // SizedBox(height: 1),
                Divider(height: 10),
                Container(
                  //padding: new EdgeInsets.only(left: 25, top: 50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                          child: new Column(
                            children: <Widget>[
                              // Padding(
                              //   padding: const EdgeInsets.only(
                              //       left: 1.0, right: 100.0),
                              //   child: Text(
                              //     "From Date:",
                              //     style: TextStyle(
                              //         fontSize: 15.0,
                              //         fontWeight: FontWeight.bold),
                              //   ),
                              // ),
                              Card(
                                // color: Colors.blueGrey[50],
                                shape: RoundedRectangleBorder(
                                    side: new BorderSide(
                                        color: Colors.blueGrey[100]),
                                    borderRadius: BorderRadius.circular(10.0)),
                                elevation: 2.0,
                                // margin: new EdgeInsets.all(5.0),
                                child: Container(
                                  width: 170,
                                  padding: new EdgeInsets.all(5.0),
                                  child: new Row(
                                    children: <Widget>[
                                      Icon(Icons.date_range,
                                          color: Colors.indigo[900]),
                                          Text("From"),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            "${pickedDate.day}- ${pickedDate.month}- ${pickedDate.year}"),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          onTap: _pickfromDate),
                      GestureDetector(
                          child: new Column(
                            children: <Widget>[
                              // Padding(
                              //   padding: const EdgeInsets.only(
                              //       left: 1.0, right: 100.0),
                              //   child: Text(
                              //     "To Date:",
                              //     style: TextStyle(
                              //         fontSize: 15.0,
                              //         fontWeight: FontWeight.bold),
                              //   ),
                              // ),
                              Card(
                                // color: Colors.blueGrey[50],
                                shape: RoundedRectangleBorder(
                                    side: new BorderSide(
                                        color: Colors.blueGrey[100]),
                                    borderRadius: BorderRadius.circular(10.0)),
                                elevation: 2.0,
                                // margin: new EdgeInsets.all(5.0),
                                child: Container(
                                  width: 170,
                                  padding: new EdgeInsets.all(5.0),
                                  child: new Row(
                                    children: <Widget>[
                                      Icon(Icons.date_range,
                                          color: Colors.indigo[900]),
                                      Text("To"),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "${todate.day}- ${todate.month}- ${todate.year}",
                                          style: TextStyle(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          onTap: _picktoDate),
                    ],
                  ),
                ),
                Container(
                  padding:
                      new EdgeInsets.only(left: 19.0, top: 10.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                          child: new Column(children: <Widget>[
                        Card(
                          // color: Colors.blueGrey[50],
                          shape: RoundedRectangleBorder(
                              side: new BorderSide(color: Colors.blueGrey[100]),
                              borderRadius: BorderRadius.circular(10.0)),
                          elevation: 2.0,
                          // margin: new EdgeInsets.all(5.0),
                          child: Container(
                            height: 40,
                            width: 200,
                            padding: new EdgeInsets.only(left: 11.0),
                            child: new Row(
                              children: <Widget>[
                                DropdownButton<Status>(
                                  underline: SizedBox(),
                                  hint: Text("   Select Status"),
                                  value: selectedStatus,
                                  items: Status.getStatus.map((Status st) {
                                    return DropdownMenuItem<Status>(
                                      value: st,
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            st.name,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (Status value) {
                                    setState(() {
                                      selectedStatus = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ])),
                      Card(
                        color: Colors.blueGrey[50],
                        shape: RoundedRectangleBorder(
                            side: new BorderSide(color: Colors.blueGrey[100]),
                            borderRadius: BorderRadius.circular(15.0)),
                        elevation: 2.0,
                        // margin: new EdgeInsets.all(5.0),
                        child: Container(
                          height: 35,
                          // width: 100,
                          // padding: new EdgeInsets.all(10.0),
                          child: new Row(
                            children: <Widget>[
                              FlatButton(
                                  child: Text('Go'),
                                  onPressed: () =>
                                      deliveryAPICAllCalling(deliveryAgentId)
                                          .then((response) {                                            
                                            print(response);
                                        setState(() {
                                          deliveryAgentOrdersModel = response;
                                        });
                                      })
                                      ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 100,
                            width: 100,
                            child: Stack(
                              children: <Widget>[
                                Center(
                                  child: new Image.asset(
                                    'images/current-trips.png',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                      "Received" + "\n" + _trips.toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            height: 100,
                            width: 100,
                            child: Stack(
                              children: <Widget>[
                                Center(
                                  child: new Image.asset(
                                    'images/past-trips.png',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                      "Delivered" +
                                          "\n" +
                                          _pastTrips.toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                          ),
                          // Container(
                          //   height: 120,
                          //   width: 120,
                          //   child: Image(
                          //     height: 100,
                          //     image: AssetImage('images/past-trips.png'),
                          //   ),
                          // ),
                          SizedBox(width: 10),
                          Container(
                            height: 100,
                            width: 100,
                            child: Stack(
                              children: <Widget>[
                                Center(
                                  child: new Image.asset(
                                    'images/cancelled-trips.png',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                      "Cancelled" +
                                          "\n" +
                                          _canceledTrips.toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                          ),
                          // Container(
                          //   height: 120,
                          //   width: 120,
                          //   child: Image(
                          //     height: 100,
                          //     image: AssetImage('images/cancelled-trips.png'),
                          //   ),
                          // ),
                          Divider(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Divider(),
                deliveryAgentOrdersModel.listResult == null
                    ? Container()
                    : deliveryAgentScreen(),
              ],
            ),
          ),
          backgroundColor: Colors.white,
          bottomNavigationBar: Container(
            color: Colors.grey[100],
            child: new TabBar(
              tabs: [
                Tab(
                  child: Image(
                    height: 30,
                    image: AssetImage('images/assigend-order.png'),
                  ),
                ),
                // Tab(
                //   child: Image(
                //     height: 30,
                //     image: AssetImage('images/home-icon.png'),
                //   ),
                // ),
                Tab(
                    child: Icon(
                  Icons.home,
                  color: Colors.indigo[900],
                  size: 35,
                )),
                Tab(
                  child: Image(
                    height: 30,
                    image: AssetImage('images/customer-icon.png'),
                  ),
                ),
              ],
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorPadding: EdgeInsets.all(5.0),
              indicatorColor: Colors.white,
              onTap: (tabIndex) {
                if (tabIndex == 1) {
                  apiConnector
                      .deliveryOrdersAPICAllCalling(deliveryAgentId)
                      .then((response) {
                    deliveryAgentOrdersModel = response;
                  });
                } else if (tabIndex == 0) {
                  //getAllNotifications(context);
                  Navigator.of(context).pushReplacement(
                      new MaterialPageRoute(builder: (context) => Dashboard()));
                } else if (tabIndex == 2) {
                  // localData.addBoolToSF(LocalData.ISLOGIN, false);
                  // localData.addIntToSF(LocalData.LOGINID, 0);
                  // //localData.clearAllLocalDta();
                  Navigator.of(context).pushReplacement(new MaterialPageRoute(
                      builder: (context) => ProfileScreen()));
                }

                print("---tabIndex ----- " + tabIndex.toString());
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<int> getAllNotifications(BuildContext context) async {
    int code = 101;
    bool isNetworkavailable = await Validator.isNetAvailable();
    if (isNetworkavailable) {
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

      print('RES :' + responseBody);

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
    } else {
      Toast.show("please check internet connection", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
    return code;
  }

  Widget deliveryAgentScreen() {
    //Padding(padding: EdgeInsets.all(10));
    return deliveryAgentOrdersModel.listResult == null
        ? Center(
            child: Text('Data ..'),
          )
        : Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  controller: _scrollController,
                  itemCount: deliveryAgentOrdersModel == null ||
                          deliveryAgentOrdersModel.listResult == null
                      ? 0
                      : deliveryAgentOrdersModel.listResult.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: InkWell(
                        onTap: () {
                          deliveryAgentOrdersModel
                                      .listResult[index].statusTypeId ==
                                  4
                              ? Text("")
                              : Navigator.of(context).push(
                                  new MaterialPageRoute(
                                      builder: (context) =>
                                          OrderDetailViewScreen(
                                              order: deliveryAgentOrdersModel
                                                  .listResult[index])));
                        },
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      // mainAxisAlignment:
                                      //     MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Container(
                                          child: new Text(
                                            formatternew.format(
                                                    deliveryAgentOrdersModel
                                                        .listResult[index]
                                                        .deliveryDate) +
                                                "  " +
                                                deliveryAgentOrdersModel
                                                    .listResult[index].timeSlot,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: Colors.indigo[900]),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 50,
                                        ),
                                        Card(
                                          color: deliveryAgentOrdersModel
                                                      .listResult[index]
                                                      .statusTypeId ==
                                                  1
                                              ? Colors.blueAccent
                                              : deliveryAgentOrdersModel
                                                          .listResult[index]
                                                          .statusTypeId ==
                                                      2
                                                  ? Colors.purpleAccent
                                                  : deliveryAgentOrdersModel
                                                              .listResult[index]
                                                              .statusTypeId ==
                                                          3
                                                      ? Colors.tealAccent[700]
                                                      : deliveryAgentOrdersModel
                                                                  .listResult[
                                                                      index]
                                                                  .statusTypeId ==
                                                              4
                                                          ? Colors.redAccent
                                                          : deliveryAgentOrdersModel
                                                                      .listResult[
                                                                          index]
                                                                      .statusTypeId ==
                                                                  6
                                                              ? Colors
                                                                  .deepOrangeAccent
                                                              : Colors
                                                                  .redAccent,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                top: 4,
                                                bottom: 4),
                                            child: new Text(
                                                deliveryAgentOrdersModel
                                                            .listResult[index]
                                                            .status
                                                            .toLowerCase() ==
                                                        'collected from store'
                                                    ? 'Collected'
                                                    : deliveryAgentOrdersModel
                                                        .listResult[index]
                                                        .status,
                                                textAlign: TextAlign.right,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      color: Colors.grey,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          deliveryAgentOrdersModel
                                              .listResult[index].code,
                                          style: TextStyle(
                                              color: Colors.indigo[900]),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      color: Colors.grey,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Image(
                                          height: 18,
                                          image: AssetImage(
                                              'images/store-loc-icon.png'),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          deliveryAgentOrdersModel
                                              .listResult[index].storeName1,
                                          style: TextStyle(
                                              color: Colors.indigo[900]),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: 2,
                                        height: 15,
                                        color: Colors.indigo[700],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Image(
                                          height: 18,
                                          image: AssetImage(
                                              'images/delivery-loc-icon.png'),
                                        ),
                                        SizedBox(width: 8),
                                        Container(
                                          child: Text(
                                            deliveryAgentOrdersModel
                                                .listResult[index]
                                                .shippingAddress,
                                            overflow: TextOverflow.fade,

                                            softWrap: false,
                                            // overflow: TextOverflow.clip,
                                            // softWrap: true,

                                            style: TextStyle(
                                                color: Colors.indigo[900]),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          );
    // );
  }

  mainDate(DateTime date) {
    var formatter = new Datetime.DateFormat('d MMMM y');
    String dates = formatter.format(date);
    print(dates); // something like 2013-04-20
    return dates;
  }

  var condts = {
    0: Container(),
    1: Center(),
    2: Row(),
    3: Column(),
    4: Stack(),
  };

  String getnameofthebuttun(int statusTypeId, int id) {
    String _buttontext = '';
    if (statusTypeId == 1 && id == null) {
      _buttontext = 'Self Assign';
    } else if (statusTypeId == 6 && id == deliveryAgentId) {
      _buttontext = "Collect from Store";
    } else if (statusTypeId == 2 && id == deliveryAgentId) {
      _buttontext = "in Transist";
    } else if (statusTypeId == 3 && id == deliveryAgentId) {
      _buttontext = "Delivered";
    }
    return _buttontext;
  }

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    print("-- >> " + htmlText.replaceAll(exp, ''));

    return htmlText.replaceAll(exp, '');
  }

  Future<dynamic> myBackgroundMessageHandlers(
      Map<String, dynamic> message) async {
    print("_backgroundMessageHandler");
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
      print("_backgroundMessageHandler data: ${data}");
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
      print("_backgroundMessageHandler notification: ${notification}");
    }
    return Future<void>.value();
  }

  _pickfromDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: pickedDate,
    );
    if (date != null)
      setState(() {
        pickedDate = date;
      });
  }

  _picktoDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: todate,
    );
    if (date != null)
      setState(() {
        todate = date;
      });
  }

  Future<DeliveryAgentOrdersModel> deliveryAPICAllCalling(int loginID) async {
    DeliveryAgentOrdersModel deliveryAgentOrders =
        new DeliveryAgentOrdersModel();

    final signUpAPI = BASEURL + DELIVERYAGENTORDERSURL;
    final headers = {'Content-Type': 'application/json'};
    var count = deliveryAgentOrders.affectedRecords.toString();
    Map<String, dynamic> body = {
      "DeliveryAgentId": loginID,
      "StoreId": null,
      "StatusTypeId": selectedStatus.id,
      "FromDate": pickedDate.toString(),
      "ToDate": todate.toString()
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    print('Print Response :' + jsonBody);

    Response response = await post(
      signUpAPI,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );

    int statusCode = response.statusCode;

    String responseBody = response.body;

    print('RES :' + responseBody);

    if (statusCode == 200) {
      print('status code 200');
      var userresponce = json.decode(responseBody);

      deliveryAgentOrders = DeliveryAgentOrdersModel.fromJson(userresponce);
      print('DELIVERYAGENTORDER From Date responce -- >> ' + userresponce.toString());
      print('Count--------->'+ deliveryAgentOrders.affectedRecords.toString());
    } else {
      print('status code not 200 -- >>');      
    }    
    return deliveryAgentOrders;
  }
}

class Status {
  final int id;
  final String name;

  Status(this.id, this.name);

  static List<Status> getStatus = <Status>[
    Status(1, 'Picking'),
    Status(2, 'InTransit'),
    Status(3, 'Delivered'),
    Status(4, 'Cancelled'),
    Status(5, 'Received'),
    Status(6, 'CollectedFromStore'),
  ];
}
