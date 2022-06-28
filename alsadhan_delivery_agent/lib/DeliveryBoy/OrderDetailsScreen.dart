import 'dart:convert';

import 'package:alsadhan_delivery_agent/DeliveryBoy/DeliveryBoyScreen.dart';
import 'package:alsadhan_delivery_agent/localdb/LocalDb.dart';
import 'package:alsadhan_delivery_agent/models/DeliveryAgentOrdersModel.dart';
import 'package:alsadhan_delivery_agent/models/DeliveryOrder.dart';
import 'package:alsadhan_delivery_agent/models/UpdateStatusTyprModel.dart';
import 'package:alsadhan_delivery_agent/services/api_constants.dart';

import 'package:alsadhan_delivery_agent/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart' as Datetime;
import 'package:toast/toast.dart';

bool isArabic = false;
int deliveryAgentId = 0;
UpdateStatusTyprModel updateStatusTyprModel;

class OrderDetailViewScreen extends StatefulWidget {
  ListResultAgent order;
  int deliveryAgentId = 0;
  int customerID = 0;

  OrderDetailViewScreen({this.order});

  @override
  _OrderDetailViewScreenState createState() => _OrderDetailViewScreenState();
}

class _OrderDetailViewScreenState extends State<OrderDetailViewScreen> {
  LocalData localData = new LocalData();
  UpdateStatusTyprModel updateStatusTyprModel = new UpdateStatusTyprModel();
  ApiConnector apiConnector;
  DeliveryOrder orderDetails;
  var formatter = new Datetime.DateFormat('dd-MM-yyyy HH:mm aa');
  var formatternew = new Datetime.DateFormat('dd-MM-yyyy');
  double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();

    print("---- >>> " + this.widget.order.statusTypeId.toString());
    apiConnector = new ApiConnector();
    apiConnector
        .getOrderDetails(this.widget.order.id.toString())
        .then((orderDetailsfromapi) {
      setState(() {
        orderDetails = orderDetailsfromapi;

        for (var i = 0; i < orderDetails.listResult.length; i++) {
          totalPrice = totalPrice + orderDetails.listResult[i].price;
        }
        print("------>>....... totalll -- " + totalPrice.toString());
      });
    });

    localData.isarabic().then((iseng) {
      setState(() {
        print('************ is Arabic : ' + isArabic.toString());
        isArabic = iseng;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                Colors.blueAccent,
                Colors.blueAccent,
                Colors.indigo[900]
              ])),
        ),
        title: new Text(isArabic == true ? "تفاصيل الطلب " : 'Order Details'),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pushReplacement(new MaterialPageRoute(
                builder: (context) => DeliveryBoyScreen(1)));
          },
        ),
        backgroundColor: Colors.indigo[900],
      ),
      body: Container(
        width: double.infinity,
        color: Colors.grey[200],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: InkWell(
                onTap: () {},
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
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                    child: Row(
                                  children: <Widget>[
                                    // Icon(Icons.date_range, color: Colors.indigo[900], ),
                                    Text(
                                      formatternew.format(
                                              this.widget.order.deliveryDate) +
                                          "  " +
                                          this.widget.order.timeSlot,
                                      textAlign: TextAlign.left,
                                      style:
                                          TextStyle(color: Colors.indigo[900]),
                                    ),
                                  ],
                                )),
                                SizedBox(
                                  width: 50,
                                ),
                                Card(
                                  color: this.widget.order.statusTypeId == 1
                                      ? Colors.blueAccent
                                      : this.widget.order.statusTypeId == 2
                                          ? Colors.purpleAccent
                                          : this.widget.order.statusTypeId == 3
                                              ? Colors.tealAccent[700]
                                              : this
                                                          .widget
                                                          .order
                                                          .statusTypeId ==
                                                      4
                                                  ? Colors.redAccent
                                                  : this
                                                              .widget
                                                              .order
                                                              .statusTypeId ==
                                                          6
                                                      ? Colors.deepOrangeAccent
                                                      : Colors.redAccent,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, top: 4, bottom: 4),
                                    child: new Text(
                                        this
                                                    .widget
                                                    .order
                                                    .status
                                                    .toLowerCase() ==
                                                'collected from store'
                                            ? 'Collected'
                                            : this.widget.order.status,
                                        textAlign: TextAlign.right,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.grey,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  this.widget.order.code,
                                  style: TextStyle(color: Colors.indigo[900]),
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.grey,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Image(
                                  height: 18,
                                  image:
                                      AssetImage('images/store-loc-icon.png'),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  this.widget.order.storeName2,
                                  style: TextStyle(color: Colors.indigo[900]),
                                ),
                              ],
                            ),
                            // Divider(
                            //   color: Colors.grey,
                            // ),
                            // SizedBox(
                            //   height: 15,
                            // ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 2,
                                height: 15,
                                color: Colors.indigo[900],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Image(
                                  height: 18,
                                  image: AssetImage(
                                      'images/delivery-loc-icon.png'),
                                ),
                                SizedBox(width: 8),
                                Container(
                                  child: Text(
                                    this.widget.order.shippingAddress,
                                    overflow: TextOverflow.fade,

                                    softWrap: false,
                                    // overflow: TextOverflow.clip,
                                    // softWrap: true,

                                    style: TextStyle(color: Colors.indigo[900]),
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
            ),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Text(isArabic == true ? "معلومات الطلب " : 'Order Info ',
                  //     style: TextStyle(color: Colors.blue)),

                  Container(
                      child: this.widget.order.deliveryAgentName == null
                          ? Divider()
                          : Card(
                              elevation: 8,
                              margin: EdgeInsets.all(5),
                              child: Container(
                                margin: EdgeInsets.all(10),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.person,
                                          color: Colors.indigo[900],
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          this.widget.order.deliveryAgentName,
                                          style: TextStyle(
                                              color: Colors.indigo[700]),
                                        )
                                      ],
                                    ),
                                    Divider(),
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.phone_android,
                                          color: Colors.indigo[900],
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          this
                                              .widget
                                              .order
                                              .deliveryAgentContactNumber,
                                          style: TextStyle(
                                              color: Colors.indigo[700]),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ))
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      isArabic == true ? "معلومات المنتجات " : 'Products Info',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.indigo[900]),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Text("Total Price: " + totalPrice.toStringAsFixed(2) + " SAR", textAlign: TextAlign.end,style: TextStyle(color: Colors.indigo[900])),
                  )
                ],
              ),
              
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: orderDetails == null
                        ? 0
                        : orderDetails.listResult.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                        child: Card(
                          elevation: 6,
                          margin: EdgeInsets.all(2),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text(
                                  orderDetails.listResult[index].name1,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(color: Colors.indigo[900]),
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(isArabic == true
                                            ? "السعر : "
                                            : 'Price : ' +
                                                orderDetails
                                                    .listResult[index].price
                                                    .toStringAsFixed(2)),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text((isArabic == true
                                                ? "كمية : "
                                                : 'Quantity : ') +
                                            orderDetails
                                                .listResult[index].quantity
                                                .toString()),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(isArabic == true
                                            ? "مجموع : "
                                            : 'Total : '),
                                        Text(
                                          (orderDetails.listResult[index]
                                                          .quantity *
                                                      orderDetails
                                                          .listResult[index]
                                                          .price)
                                                  .toStringAsFixed(2) +
                                              ' SAR',
                                          style: TextStyle(
                                              color: Colors.indigo[700]),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(height: 10)
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Visibility(
                    child: RaisedButton(
                      color: Colors.blue[600],
                      child: Text(
                          this.widget.order.statusTypeId == 1
                              ? "Collected"
                              : this.widget.order.statusTypeId == 2
                                  ? "Delivered"
                                  : this.widget.order.statusTypeId == 6
                                      ? "in Transist"
                                      : "",
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        int statusTypeID = this.widget.order.statusTypeId == 1
                            ? 6
                            : this.widget.order.statusTypeId == 2
                                ? 3
                                : this.widget.order.statusTypeId == 6 ? 2 : 0;

                        apiConnector
                            .updateStatusAPI(
                                this.widget.order.id,
                                statusTypeID,
                                this.widget.order.userId,
                                DateTime.now().toString())
                            .then((response) {
                          updateStatusTyprModel = response;

                          if (updateStatusTyprModel.isSuccess == true) {
                            Toast.show(
                                updateStatusTyprModel.endUserMessage, context,
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.CENTER);
                            Navigator.of(context).pushReplacement(
                                new MaterialPageRoute(
                                    builder: (context) =>
                                        DeliveryBoyScreen(1)));
                          }
                        });
                      },
                    ),
                    visible: this.widget.order.statusTypeId == 3 ||
                            this.widget.order.statusTypeId == 5
                        ? false
                        : true,
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Visibility(
                    child: RaisedButton(
                      color: this.widget.order.statusTypeId == 1 || this.widget.order.statusTypeId == 2 ||
                              this.widget.order.statusTypeId == 6
                          ? Colors.red[600]
                          : Colors.grey[400],
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        this.widget.order.statusTypeId == 1 || this.widget.order.statusTypeId == 2 ||
                                this.widget.order.statusTypeId == 6
                            ? apiConnector
                                .updateStatusAPI(
                                    this.widget.order.id,
                                    4,
                                    this.widget.order.userId,
                                    DateTime.now().toString())
                                .then((response) {
                                updateStatusTyprModel = response;
                                if (updateStatusTyprModel.isSuccess == true) {
                                  Toast.show(
                                      updateStatusTyprModel.endUserMessage,
                                      context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.CENTER);
                                  Navigator.of(context).pushReplacement(
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              DeliveryBoyScreen(1)));
                                }
                              })
                            : Container();
                      },
                    ),
                    visible: this.widget.order.statusTypeId == 3 ||
                            this.widget.order.statusTypeId == 5 
                        ? false
                        : true,

                    // visible: this.widget.order.statusTypeId == 1 || this.widget.order.statusTypeId == 2  ? true : false,
                  ),
                ))
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<int> selfAssignAPICAllCalling(int updatedByUserId) async {
    int code = 101;
    String selfAssignAPI = BASEURL + SELFASSIGENURL;
    final headers = {'Content-Type': 'application/json'};

    Map<String, dynamic> body = {
      "OrderId": this.widget.order.id,
      "DeliveryAgentId": this.widget.order.deliveryAgentId,
      "UpdatedByUserId": this.widget.order.userId,
      "UpdatedDate": DateTime.now().toString()
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
      deliveryAgentOrdersModel =
          DeliveryAgentOrdersModel.fromJson(userresponce);
      print('status code 200 -- >> ' + userresponce.toString());

      if (userresponce["IsSuccess"] == true) {
        apiConnector
            .deliveryOrdersAPICAllCalling(deliveryAgentId)
            .then((response) {
          deliveryAgentOrdersModel = response;
        });

        print(
            "----  ListResult >>>" + userresponce["ListResult"][0].toString());
      } else {}
    } else {
      print('status code not 200 -- >>');
    }
    return code;
  }

  mainDate(DateTime date) {
    var formatter = new Datetime.DateFormat('d MMMM y');
    String dates = formatter.format(date);
    print(dates); // something like 2013-04-20
    return dates;
  }
}
