import 'dart:convert';
import 'package:alsadhan_delivery_agent/Notification/notificationScreen.dart';
import 'package:alsadhan_delivery_agent/models/AllNotificationModel.dart';
import 'package:alsadhan_delivery_agent/models/DeliveryAgentOrdersModel.dart';
import 'package:alsadhan_delivery_agent/models/OrdersCountModel.dart';
import 'package:alsadhan_delivery_agent/models/UpdateStatusTyprModel.dart';
import 'package:alsadhan_delivery_agent/models/UserInfoModel.dart';

import 'package:alsadhan_delivery_agent/services/api_constants.dart';
import 'package:alsadhan_delivery_agent/widgets/Validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:alsadhan_delivery_agent/models/DeliveryOrder.dart';
import 'package:toast/toast.dart';

var datamsg = "";

class ApiConnector {
  Future<DeliveryAgentOrdersModel> deliveryOrdersAPICAllCalling(
      int loginID) async {
    DeliveryAgentOrdersModel deliveryAgentOrders =
        new DeliveryAgentOrdersModel();

    final signUpAPI = BASEURL + DELIVERYAGENTORDERSURL;
    final headers = {'Content-Type': 'application/json'};

    Map<String, dynamic> body = {
      "DeliveryAgentId": loginID,
      "StoreId": null,
      "StatusTypeId": null,
      "FromDate": DateTime.now()
          .subtract(Duration(days: 7, hours: 23, minutes: 59, seconds: 00))
          .toString(),
      "ToDate": DateTime.now().toString()
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    print('DELIVERYAGENTORDER Request body -->> :' + jsonBody);

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
      print('DELIVERYAGENTORDER responce -- >> ' + userresponce.toString());
    } else {
      print('status code not 200 -- >>');
    }
    return deliveryAgentOrders;
  }

  Future<int> sendfirebasetokentoserverapicall(
      int loginID, String deviceToken) async {
    final sendFirebaseURL = BASEURL + SENDFIREBASETOKENURL;
    final headers = {'Content-Type': 'application/json'};

    Map<String, dynamic> body = {"UserId": loginID, "DeviseToken": deviceToken};

    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    print('sendfirebasetokentoserverapicall Request body -->> :' + jsonBody);

    Response response = await post(
      sendFirebaseURL,
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
      print('SENDFIREBASETOKENURL response -- >> ' + userresponce.toString());
    } else {
      print('status code not 200 -- >>');
    }
    return statusCode;
  }

  Future<DeliveryOrder> getOrderDetails(String orderid) async {
    final uri = BASEURL + DELIVERYORDERDETAIL + '/' + orderid;
    print('API call :' + uri);
    DeliveryOrder storesModel = new DeliveryOrder();
    final headers = {'Content-Type': 'application/json'};
    Response response = await get(
      uri,
      headers: headers,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;

    if (statusCode == 200) {
      var userresponce = json.decode(responseBody);
      storesModel = DeliveryOrder.fromJson(userresponce);

      print('::: SgetOrderDetails :::: Success : 200');
      print('::: getOrderDetails:::: ' + userresponce.toString());

      return storesModel;
    } else {
      print('::: getOrderDetails :::: error : ');
      return null;
    }
  }

  Future<UserInfoModel> getUserInfo(int id) async {
    final uri = BASEURL + USERINFOURL + id.toString();
    print('API call :' + uri);
    UserInfoModel userInfoModel = new UserInfoModel();
    final headers = {'Content-Type': 'application/json'};
    Response response = await get(
      uri,
      headers: headers,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;

    if (statusCode == 200) {
      var userresponce = json.decode(responseBody);
      userInfoModel = UserInfoModel.fromJson(userresponce);

      print('::: userInfoModel :::: Success : 200');
      print('::: userInfoModel :::: ' + userresponce.toString());

      return userInfoModel;
    } else {
      print('::: userInfoModel :::: error : ');
      return null;
    }
  }

    Future<int> readSingleNotificationsAPICall(int loginID , int notificationID) async {
    var url = BASEURL + READSINGLENOTIFICATIONS + loginID.toString() + "/" + notificationID.toString();
    print('API :' + url);
    Response res = await get(url);
    int statusCode = res.statusCode;
    String responseBody = res.body;
    if (statusCode == 200) {
      Map<String, dynamic> parsedMAP = json.decode(responseBody);

      print('--- readSingleNotificationsAPICall response -->>>>   ' + responseBody);

      parsedMAP.toString();
      return statusCode;
    } else {
      return null;
    }
  }


  Future<int> markAllReadNotificationsAPICall(int loginID) async {
    var url = BASEURL + READ_ALLNOTIFICATIONS + loginID.toString();
    print('API :' + url);
    Response res = await get(url);
    int statusCode = res.statusCode;
    String responseBody = res.body;
    if (statusCode == 200) {
      Map<String, dynamic> parsedMAP = json.decode(responseBody);

      print('--- markAllReadNotificationsAPI -->>>>   ' + responseBody);

      parsedMAP.toString();
      return statusCode;
    } else {
      return null;
    }
  }

  Future<int> getAllNotificationsApi(BuildContext context) async {
    int code = 101;
    bool isNetworkavailable = await Validator.isNetAvailable();
    if (isNetworkavailable) {
      AllNotificationModel allNotificationModel = new AllNotificationModel();
      final notificationApi = BASEURL + GETALLNOTIFICATIONS_URL;
      final headers = {'Content-Type': 'application/json'};

      Map<String, dynamic> body = {
        "UserId": userID,
        "IsPagination": true,
        "PageIndex": 3,
        "PageSize": 4
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
        allNotificationModel = AllNotificationModel.fromJson(userresponce);
        print('status code 200 -- >> ' + userresponce.toString());

        if (userresponce["IsSuccess"] == true) {
          print("----  ListResult >>>" +
              userresponce["ListResult"][0].toString());
          // setState(() {
          //   print("----  ListResult >>>" + userresponce["ListResult"][0].toString());

          // });
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

  Future<List> getUnReadNotifications(int deleveryAgentID) async {
    final getUnReadNotificationsURL =
        BASEURL + UNREADNOTIFICATIONS + deleveryAgentID.toString();
    print('getUnReadNotifications API call :' + getUnReadNotificationsURL);

    final headers = {'Content-Type': 'application/json'};
    Response response = await get(
      getUnReadNotificationsURL,
      headers: headers,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;

    if (statusCode == 200) {
      var userresponce = json.decode(responseBody);

      print('::: SgetOrderDetails :::: Success : 200');
      print('::: getUnReadNotifications :::: ' + userresponce.toString());

      return userresponce["ListResult"];
    } else {
      print('::: getUnReadNotifications :::: error : ');
      return null;
    }
  }

  Future<OrdersCountModel> getOrdersCountAPICall(int deleveryAgentID) async {
    final getUnReadNotificationsURL =
        BASEURL + ORDERSCOUNTURL + deleveryAgentID.toString();
    OrdersCountModel ordersCountModel = new OrdersCountModel();
    print('getOrdersCount API call :' + getUnReadNotificationsURL);

    final headers = {'Content-Type': 'application/json'};
    Response response = await get(
      getUnReadNotificationsURL,
      headers: headers,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;

    if (statusCode == 200) {
      var userresponce = json.decode(responseBody);

      ordersCountModel = OrdersCountModel.fromJson(userresponce);

      print('::: getOrdersCount :::: Success : 200');
      print('::: getOrdersCount Response :::: ' + ordersCountModel.toString());

      return ordersCountModel;
    } else {
      print('::: getOrdersCount :::: error : ');
      return null;
    }
  }

  Future<UpdateStatusTyprModel> updateStatusAPI(int orderID, int statusTypeID,
      int updatedByUserId, String updatedDate) async {
    String updateStatusAPI = BASEURL + UPDATEORDERSTATUSURL;
    UpdateStatusTyprModel updateStatusTyprModel = new UpdateStatusTyprModel();
    final headers = {'Content-Type': 'application/json'};

    Map<String, dynamic> body = {
      "OrderId": orderID,
      "StatusTypeId": statusTypeID,
      "Comments": "",
      "UpdatedByUserId": updatedByUserId,
      "UpdatedDate": updatedDate
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    print('updateStatusAPI Request body -->> :' + jsonBody);

    Response response = await post(
      updateStatusAPI,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );

    int statusCode = response.statusCode;

    String responseBody = response.body;

    Map<String, dynamic> parsedMAP = json.decode(responseBody);

    print('RES :' + responseBody);

    if (statusCode == 200) {
      print('status code 200');
      var userresponce = json.decode(responseBody);
      updateStatusTyprModel = UpdateStatusTyprModel.fromJson(parsedMAP);
      print('updateStatusAPI -- >> ' + userresponce.toString());

      return updateStatusTyprModel;
    } else {
      print('status code not 200 -- >>');
    }
    return null;
  }

  // Future<DeliveryAgentOrdersModel> ordersbyStoresAPICAll(
  //     int loginID) async {
  //   DeliveryAgentOrdersModel deliveryAgentOrders =
  //       new DeliveryAgentOrdersModel();

  //   final ordersbyStoreAPI = BASEURL + ORDERSBYSTORESURL;
  //   final headers = {'Content-Type': 'application/json'};

  //   Map<String, dynamic> body = {
  //     "DeliveryAgentId": loginID,
  //     "StoreId": null,
  //     "StatusTypeId": null,
  //     "FromDate": DateTime.now()
  //         .subtract(Duration(days: 7, hours: 23, minutes: 59, seconds: 00))
  //         .toString(),
  //     "ToDate": DateTime.now().toString()
  //   };
  //   String jsonBody = json.encode(body);
  //   final encoding = Encoding.getByName('utf-8');

  //   print('ORDERSBYSTORESURL Request body -->> :' + jsonBody);

  //   Response response = await post(
  //     ordersbyStoreAPI,
  //     headers: headers,
  //     body: jsonBody,
  //     encoding: encoding,
  //   );

  //   int statusCode = response.statusCode;

  //   String responseBody = response.body;

  //   print('ORDERSBYSTORESURL :' + responseBody);

  //   if (statusCode == 200) {
  //     print('status code 200');
  //     var userresponce = json.decode(responseBody);

  //     deliveryAgentOrders = DeliveryAgentOrdersModel.fromJson(userresponce);
  //     print('ORDERSBYSTORESURL response -- >> ' + userresponce.toString());
  //   } else {
  //     print('ORDERSBYSTORESURL status code not 200 -- >>' + statusCode.toString());
  //   }
  //   return deliveryAgentOrders;
  // }
}
