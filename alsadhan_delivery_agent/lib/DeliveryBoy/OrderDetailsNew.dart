import 'package:flutter/material.dart';

class OrderDetails extends StatefulWidget {
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        color: Colors.yellow,
        home: DefaultTabController(
          length: 3,
          child: new Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              bottom: PreferredSize(
                  child: Container(color: Colors.indigo[900], height: 4.0),
                  preferredSize: Size.fromHeight(4.0)),
              title: Text("Order Details",
                  style: TextStyle(color: Colors.indigo[900]),
                  textAlign: TextAlign.center),
              leading: new IconButton(
                  icon: new Icon(
                    Icons.keyboard_arrow_left,
                    size: 30.0,
                  ),
                  color: Colors.indigo[900],
                  onPressed: () {}),
            ),
            body: new Container(
              padding: new EdgeInsets.all(22.0),
              child: new Center(
                child: new Column(
                  children: <Widget>[
                    new Container(
                      child: new Column(
                        children: <Widget>[
                          new Card(
                            color: Colors.indigo[900],
                            shape: RoundedRectangleBorder(
                              side: new BorderSide(color: Colors.blueGrey[100]),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 2.0,
                            //  margin: new EdgeInsets.all(3.0),
                            child: new Container(
                              height: 130,
                              width: 430,
                              padding: new EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        new Column(
                                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text('Order DateTime',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.0)),
                                            Text('Order Id',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.0)),
                                                                            
                                          ],
                                        ),
                                        new Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            RaisedButton(
                                                shape:
                                                    new RoundedRectangleBorder(
                                                        borderRadius:
                                                            new BorderRadius
                                                                    .circular(
                                                                30.0)),
                                                //  padding: new EdgeInsets.all(5.0),
                                                color: Colors.white,
                                                child: Text(
                                                  "In progress",
                                                  style: new TextStyle(
                                                      fontSize: 12.0,
                                                      color:
                                                          Colors.indigo[900]),
                                                ),
                                                onPressed: () {}),
                                          ],
                                        ),
                                      ],
                                    ),                                    
                                  ),                                
                                   Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            new Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                               Image(
                                        height: 15,
                                        color: Colors.white,
                                        image: AssetImage(
                                            'images/store-loc-icon.png'),
                                      ),                                           
                                            Text('|', 
                                                textAlign: TextAlign.right,                                                
                                                softWrap: true,
                                                style: TextStyle(
                                                  fontSize: 25, color: Colors.white)),
                                            // Icon(Icons.add_location, color: Colors.white, size: 13),
                                            Image(
                                        height: 15,
                                        color: Colors.white,
                                        image: AssetImage(
                                            'images/delivery-loc-icon.png'),
                                      ),    
                                              ],
                                            ),                                            
                                            new Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[                                               
                                                Text('Delivery Address',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .white)),
                                                Text(''),
                                                Text('Delivery Address',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .white)),
                                                
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    new Container(
                      padding: new EdgeInsets.only(top: 10.0),
                      child: new Column(
                        children: <Widget>[
                          new Card(
                            color: Colors.grey[50],
                            shape: RoundedRectangleBorder(
                              side: new BorderSide(color: Colors.blueGrey[100]),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            elevation: 2.0,
                            //  margin: new EdgeInsets.all(3.0),
                            child: new Container(
                              height: 100,
                              width: 340,
                              padding: new EdgeInsets.only(top: 17.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.start,
                                children: <Widget>[
                                  new Column(
                                    children: <Widget>[
                                      Icon(Icons.person_pin,
                                          color: Colors.indigo[900], size: 50)
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      new Text(
                                        'Customer Name',
                                        style: TextStyle(
                                            color: Colors.indigo[900],
                                            letterSpacing: 1.0,
                                            height: 1.5,
                                            fontSize: 20.0),
                                      ),
                                      new Text(
                                        'Contact Number',
                                        style: TextStyle(
                                          letterSpacing: 1.0,
                                            height: 1.5,
                                            color: Colors.indigo[900],
                                            fontSize: 20.0),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    new Container(
                      padding: new EdgeInsets.only(top: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Column(
                            children: <Widget>[
                              new Card(
                                color: Colors.grey[50],
                                shape: RoundedRectangleBorder(
                                  side: new BorderSide(
                                      color: Colors.blueGrey[100]),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                elevation: 2.0,
                                //  margin: new EdgeInsets.all(3.0),
                                child: new Container(
                                  height: 250,
                                  width: 340,
                                  padding: new EdgeInsets.all(15.0),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            new Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text('More Details',
                                                    style: TextStyle(
                                                      letterSpacing: 1.0,
                                            height: 1.5,
                                                        color:
                                                            Colors.indigo[900],
                                                        fontSize: 16.0)),
                                             Padding( padding: EdgeInsets.only(top: 8.0)),
                                                Text('Delivery Date',
                                                    style: TextStyle(
                                                      letterSpacing: 1.0,
                                            height: 1.5,
                                                        color: Colors
                                                            .indigo[900])),
                                                Text('12-23.2334',
                                                    style: TextStyle(
                                                      letterSpacing: 1.0,
                                            height: 1.5,
                                                        color: Colors
                                                            .indigo[900])),
                                              ],
                                            ),
                                            new Column(
                                              children: <Widget>[
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 20.0, left: 82.0)),
                                                new Text('|',
                                                    style: TextStyle(                                                      
                                            height: 1.5,
                                                        color: Colors.indigo,
                                                        fontSize: 40.0)),
                                              ],
                                            ),
                                            new Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                  top: 30.0,
                                                )),
                                                new Text('Slot',
                                                    style: TextStyle(
                                                      letterSpacing: 1.0,
                                            height: 1.5,
                                                        color: Colors
                                                            .indigo[900])),
                                                new Text('slot time',
                                                    style: TextStyle(
                                                      letterSpacing: 1.0,
                                            height: 1.5,
                                                        color: Colors
                                                            .indigo[900])),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),                                      
                                      Container(
                                        padding: EdgeInsets.only(top: 12.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            new Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text('Billing Details',
                                                    style: TextStyle(
                                                      letterSpacing: 1.0,
                                            height: 1.5,
                                                        color:
                                                            Colors.indigo[900],
                                                        fontSize: 16)),
                                               Padding(padding: EdgeInsets.only(top: 8.0)),
                                                Text('Amount',
                                                    style: TextStyle(
                                                      letterSpacing: 1.0,
                                            height: 1.5,
                                                        color: Colors
                                                            .indigo[900])),
                                                Text('Delivery Fee',
                                                    style: TextStyle(
                                                      letterSpacing: 1.0,
                                            height: 1.5,
                                                        color: Colors
                                                            .indigo[900])),
                                                Text('Payment Mode',
                                                    style: TextStyle(
                                                      letterSpacing: 1.0,
                                            height: 1.5,
                                                        color: Colors
                                                            .indigo[900])),
                                                Text('Status',
                                                    style: TextStyle(
                                                      letterSpacing: 1.0,
                                            height: 1.5,
                                                        color: Colors
                                                            .indigo[900])),
                                              ],
                                            ),
                                            new Column(),
                                            new Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                Padding(padding: EdgeInsets.only(top:17.0)),
                                                Text(''),
                                                Text('976.00',
                                                    style: TextStyle(
                                                      letterSpacing: 1.0,
                                            height: 1.5,
                                                        color: Colors
                                                            .indigo[900])),
                                                Text('Free',
                                                    style: TextStyle(
                                                      letterSpacing: 1.0,
                                            height: 1.5,
                                                        color: Colors
                                                            .indigo[900])),
                                                Text('Cash on Delivery',
                                                    style: TextStyle(
                                                      letterSpacing: 1.0,
                                            height: 1.5,
                                                        color: Colors
                                                            .indigo[900])),
                                                Text('Accepted',
                                                    style: TextStyle(
                                                      letterSpacing: 1.0,
                                            height: 1.5,
                                                        color: Colors
                                                            .indigo[900])),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: new TabBar(
              tabs: [
                Tab(
                  child: Image(
                    height: 30,
                    image: AssetImage('images/assigend-order.png'),
                  ),
                ),
                Tab(
                  child: Image(
                    height: 30,
                    image: AssetImage('images/home-icon.png'),
                  ),
                ),
                Tab(
                  child: Image(
                    height: 30,
                    image: AssetImage('images/date-icon.png'),
                  ),
                ),
              ],
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorPadding: EdgeInsets.all(5.0),
              indicatorColor: Colors.indigo[900],
              onTap: (tabIndex) {
                // if (tabIndex == 0) {
                //   apiConnector
                //       .deliveryOrdersAPICAllCalling(deliveryAgentId)
                //       .then((response) {
                //     deliveryAgentOrdersModel = response;
                //   });
                // } else if (tabIndex == 1) {
                //   getAllNotifications(context);
                // } else if (tabIndex == 2) {
                //   localData.addBoolToSF(LocalData.ISLOGIN, false);
                //   localData.addIntToSF(LocalData.LOGINID, 0);
                //   //localData.clearAllLocalDta();
                //   Navigator.of(context).pushReplacement(
                //       new MaterialPageRoute(builder: (context) => LoginScreen()));
                // }

                // print("---tabIndex ----- " + tabIndex.toString());
              },
            ),
            backgroundColor: Colors.white,
          ),
        ));
  }
}
