import 'package:alsadhan_delivery_agent/DeliveryBoy/DeliveryBoyScreen.dart';
import 'package:alsadhan_delivery_agent/Notification/allNotificationScreen.dart';
import 'package:alsadhan_delivery_agent/Notification/notid.dart';
import 'package:alsadhan_delivery_agent/localdb/LocalDb.dart';
import 'package:alsadhan_delivery_agent/services/api_service.dart';
import 'package:alsadhan_delivery_agent/widgets/appDrawer.dart';
import 'package:flutter/material.dart';

int unreadNotifications = 0;
LocalData localData = new LocalData();
ApiConnector apiConnector = new ApiConnector();

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    localData.getIntToSF(LocalData.LOGINID).then((id) {
      apiConnector.getUnReadNotifications(id).then((response) {
        // print('::: unread notifications -->>  ' + response.toString());
        if (response != null) {
          setState(() {
            unreadNotifications = response.length == null ? 0 : response.length;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.indigo[900]),
        backgroundColor: Colors.white,
        bottom: PreferredSize(
            child: Container(color: Colors.indigo[900], height: 4.0),
            preferredSize: Size.fromHeight(4.0)),
        centerTitle: true,
        title: Text("Delivery",
            style: TextStyle(color: Colors.black), textAlign: TextAlign.center),
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
      body: new Container(
        padding: new EdgeInsets.all(32.0),
        child: new Center(
          child: new Column(
            children: <Widget>[
              new Container(
                padding:
                    new EdgeInsets.only(top: 32.0, bottom: 32.0, right: 90.0),
                child: new Column(
                  children: <Widget>[
                    new Text(
                      'Create New \n Order !',
                      style: TextStyle(fontSize: 30),
                    ),
                  ],
                ),
              ),
              new Container(
                //padding: new EdgeInsets.only(left: 25, top: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                                          child: new Column(
                        children: <Widget>[
                          new Card(
                            color: Colors.blueGrey[50],
                            shape: RoundedRectangleBorder(
                                side: new BorderSide(color: Colors.blueGrey[100]),
                                borderRadius: BorderRadius.circular(15.0)),
                            elevation: 2.0,
                            margin: new EdgeInsets.all(5.0),
                            child: Container(
                              height: 100,
                              width: 130,
                              padding: new EdgeInsets.all(10.0),
                              
                                child: new Column(
                                  children: <Widget>[
                                    // new Icon(Icons.bookmark_border,
                                    // size: 40),

                                    Image(
                                      height: 40,
                                      image: AssetImage(
                                          'images/assigned-orders.png'),
                                    ),

                                    SizedBox(height: 10),

                                    new Text('Assigned orders'),
                                  ],
                                ),
                              
                            ),
                          )
                        ],
                      ),
                      onTap: (){
                        Navigator.of(context).pushReplacement(
                                    new MaterialPageRoute(
                                        builder: (context) =>
                                            DeliveryBoyScreen(1)));
                      },
                    ),
                    GestureDetector(
                                          child: new Column(
                        children: <Widget>[
                          new Card(
                            color: Colors.blueGrey[50],
                            shape: RoundedRectangleBorder(
                              side: new BorderSide(color: Colors.blueGrey[100]),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 2.0,
                            margin: new EdgeInsets.all(8.0),
                            child: new Container(
                              height: 100,
                              width: 130,
                              padding: new EdgeInsets.all(15.0),
                              child: new Column(
                                children: <Widget>[
                                  // new Icon(Icons.beenhere,
                                  //     color: Colors.red[500], size: 40),
                                  Image(
                                    height: 40,
                                    image: AssetImage('images/self-assigned.png'),
                                  ),

                                  SizedBox(height: 10),
                                  new Text('Self Assigned'),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      onTap: (){
                        Navigator.of(context).pushReplacement(
                                    new MaterialPageRoute(
                                        builder: (context) =>
                                            DeliveryBoyScreen(1)));
                      },
                    ),
                  ],
                ),
              ),
              Spacer(),
              new Container(
                decoration: BoxDecoration(),
                width: 300,
                height: 50,
                child: new RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    // padding: new EdgeInsets.all(20.0),
                    color: Colors.indigo[700],
                    child: Text(
                      "Self Assign Request",
                      style: new TextStyle(fontSize: 14.0, color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                                    new MaterialPageRoute(
                                        builder: (context) =>
                                            DeliveryBoyScreen(1)));

                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
