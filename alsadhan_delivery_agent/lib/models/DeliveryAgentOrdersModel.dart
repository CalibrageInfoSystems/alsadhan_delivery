// To parse this JSON data, do
//
//     final deliveryAgentOrdersModel = deliveryAgentOrdersModelFromJson(jsonString);

import 'dart:convert';

DeliveryAgentOrdersModel deliveryAgentOrdersModelFromJson(String str) => DeliveryAgentOrdersModel.fromJson(json.decode(str));

String deliveryAgentOrdersModelToJson(DeliveryAgentOrdersModel data) => json.encode(data.toJson());

class DeliveryAgentOrdersModel {
    List<ListResultAgent> listResult;
    bool isSuccess;
    int affectedRecords;
    String endUserMessage;
    List<dynamic> validationErrors;
    dynamic exception;

    DeliveryAgentOrdersModel({
        this.listResult,
        this.isSuccess,
        this.affectedRecords,
        this.endUserMessage,
        this.validationErrors,
        this.exception,
    });

    factory DeliveryAgentOrdersModel.fromJson(Map<String, dynamic> json) => DeliveryAgentOrdersModel(
        listResult: json["ListResult"] == null ? null : List<ListResultAgent>.from(json["ListResult"].map((x) => ListResultAgent.fromJson(x))),
        isSuccess: json["IsSuccess"] == null ? null : json["IsSuccess"],
        affectedRecords: json["AffectedRecords"] == null ? null : json["AffectedRecords"],
        endUserMessage: json["EndUserMessage"] == null ? null : json["EndUserMessage"],
        validationErrors: json["ValidationErrors"] == null ? null : List<dynamic>.from(json["ValidationErrors"].map((x) => x)),
        exception: json["Exception"],
    );

    Map<String, dynamic> toJson() => {
        "ListResult": listResult == null ? null : List<dynamic>.from(listResult.map((x) => x.toJson())),
        "IsSuccess": isSuccess == null ? null : isSuccess,
        "AffectedRecords": affectedRecords == null ? null : affectedRecords,
        "EndUserMessage": endUserMessage == null ? null : endUserMessage,
        "ValidationErrors": validationErrors == null ? null : List<dynamic>.from(validationErrors.map((x) => x)),
        "Exception": exception,
    };
}

class ListResultAgent {
    int id;
    String code;
    int userId;
    String customerName;
    String customerContactNumber;
    double totalPrice;
    int storeId;
    String storeName1;
    String storeName2;
    StoreCityName storeCityName;
    StoreLandmark storeLandmark;
    String address;
    String landmark;
    CityName cityName;
    PostalCode postalCode;
    String shippingAddress;
    int statusTypeId;
    String status;
    String comments;
    int createdByUserId;
    DateTime createdDate;
    int updatedByUserId;
    DateTime updatedDate;
    int deliveryAgentId;
    String deliveryAgentName;
    String deliveryAgentContactNumber;
    DateTime deliveryDate;
    String timeSlot;
    String buttonName;

    ListResultAgent({
        this.id,
        this.code,
        this.userId,
        this.customerName,
        this.customerContactNumber,
        this.totalPrice,
        this.storeId,
        this.storeName1,
        this.storeName2,
        this.storeCityName,
        this.storeLandmark,
        this.address,
        this.landmark,
        this.cityName,
        this.postalCode,
        this.shippingAddress,
        this.statusTypeId,
        this.status,
        this.comments,
        this.createdByUserId,
        this.createdDate,
        this.updatedByUserId,
        this.updatedDate,
        this.deliveryAgentId,
        this.deliveryAgentName,
        this.deliveryAgentContactNumber,
        this.deliveryDate,
        this.timeSlot,
        this.buttonName,
    });

    factory ListResultAgent.fromJson(Map<String, dynamic> json) {
      
      return ListResultAgent(
        id: json["Id"] == null ? null : json["Id"],
        code: json["Code"] == null ? null : json["Code"],
        userId: json["UserId"] == null ? null : json["UserId"],
        customerName: json["CustomerName"] == null ? null : json["CustomerName"],
        customerContactNumber: json["CustomerContactNumber"] == null ? null : json["CustomerContactNumber"],
        totalPrice: json["TotalPrice"] == null ? null : json["TotalPrice"].toDouble(),
        storeId: json["StoreId"] == null ? null : json["StoreId"],
        storeName1: json["StoreName1"] == null ? null : json["StoreName1"],
        storeName2: json["StoreName2"] == null ? null : json["StoreName2"],
        storeCityName: json["StoreCityName"] == null ? null : storeCityNameValues.map[json["StoreCityName"]],
        storeLandmark: json["StoreLandmark"] == null ? null : storeLandmarkValues.map[json["StoreLandmark"]],
        address: json["Address"] == null ? null : json["Address"],
        landmark: json["Landmark"] == null ? null : json["Landmark"],
        cityName: json["CityName"] == null ? null : cityNameValues.map[json["CityName"]],
        postalCode: json["PostalCode"] == null ? null : postalCodeValues.map[json["PostalCode"]],
        shippingAddress: json["ShippingAddress"] == null ? null : json["ShippingAddress"],
        statusTypeId: json["StatusTypeId"] == null ? null : json["StatusTypeId"],
        status: json["Status"] == null ? null : json["Status"],
        comments: json["Comments"] == null ? null : json["Comments"],
        createdByUserId: json["CreatedByUserId"] == null ? null : json["CreatedByUserId"],
        createdDate: json["CreatedDate"] == null ? null : DateTime.parse(json["CreatedDate"]),
        updatedByUserId: json["UpdatedByUserId"] == null ? null : json["UpdatedByUserId"],
        updatedDate: json["UpdatedDate"] == null ? null : DateTime.parse(json["UpdatedDate"]),
        deliveryAgentId: json["DeliveryAgentId"] == null ? null : json["DeliveryAgentId"],
        deliveryAgentName: json["DeliveryAgentName"] == null ? null : json["DeliveryAgentName"],
        deliveryAgentContactNumber: json["DeliveryAgentContactNumber"] == null ? null : json["DeliveryAgentContactNumber"],
        deliveryDate: json["DeliveryDate"] == null ? null : DateTime.parse(json["DeliveryDate"]),
        timeSlot: json["TimeSlot"] == null ? null : json["TimeSlot"],

    );
    }

    String butoonName() => getButtonName(0,0);

     String getButtonName(int statusTypeId, int id){

    return "Naveen";

    }

    Map<String, dynamic> toJson() => {
        "Id": id == null ? null : id,
        "Code": code == null ? null : code,
        "UserId": userId == null ? null : userId,
        "CustomerName": customerName == null ? null : customerName,
        "CustomerContactNumber": customerContactNumber == null ? null : customerContactNumber,
        "TotalPrice": totalPrice == null ? null : totalPrice,
        "StoreId": storeId == null ? null : storeId,
        "StoreName1": storeName1 == null ? null : storeName1,
        "StoreName2": storeName2 == null ? null : storeName2,
        "StoreCityName": storeCityName == null ? null : storeCityNameValues.reverse[storeCityName],
        "StoreLandmark": storeLandmark == null ? null : storeLandmarkValues.reverse[storeLandmark],
        "Address": address == null ? null : address,
        "Landmark": landmark == null ? null : landmark,
        "CityName": cityName == null ? null : cityNameValues.reverse[cityName],
        "PostalCode": postalCode == null ? null : postalCodeValues.reverse[postalCode],
        "ShippingAddress": shippingAddress == null ? null : shippingAddress,
        "StatusTypeId": statusTypeId == null ? null : statusTypeId,
        "Status": status == null ? null : status,
        "Comments": comments == null ? null : comments,
        "CreatedByUserId": createdByUserId == null ? null : createdByUserId,
        "CreatedDate": createdDate == null ? null : createdDate.toIso8601String(),
        "UpdatedByUserId": updatedByUserId == null ? null : updatedByUserId,
        "UpdatedDate": updatedDate == null ? null : updatedDate.toIso8601String(),
        "DeliveryAgentId": deliveryAgentId == null ? null : deliveryAgentId,
        "DeliveryAgentName": deliveryAgentName == null ? null : deliveryAgentNameValues.reverse[deliveryAgentName],
        "DeliveryAgentContactNumber": deliveryAgentContactNumber == null ? null : deliveryAgentContactNumber,
        "DeliveryDate": deliveryDate == null ? null : deliveryDate.toIso8601String(),
        "TimeSlot": timeSlot == null ? null : timeSlot,

    };

  getbuttunname(int i, int j) {}

  _getbuttunname(int i, int j) {}
}

enum CityName { SAUDI_ARABIA }

final cityNameValues = EnumValues({
    "Saudi Arabia": CityName.SAUDI_ARABIA
});

enum DeliveryAgentName { FARHAT_MIKEE }

final deliveryAgentNameValues = EnumValues({
    "farhat mikee": DeliveryAgentName.FARHAT_MIKEE
});

enum PostalCode { POSTAL_CODE }

final postalCodeValues = EnumValues({
    "Postal code": PostalCode.POSTAL_CODE
});

enum StoreCityName { RIYADH, SOUDHI123 }

final storeCityNameValues = EnumValues({
    "Riyadh": StoreCityName.RIYADH,
    "soudhi123": StoreCityName.SOUDHI123
});

enum StoreLandmark { NEAR_MORE_SUPERMARE, TETS, NULL, NEAR_SPAR }

final storeLandmarkValues = EnumValues({
    "near more supermare": StoreLandmark.NEAR_MORE_SUPERMARE,
    "near spar": StoreLandmark.NEAR_SPAR,
    "NULL": StoreLandmark.NULL,
    "tets": StoreLandmark.TETS
});

class EnumValues<T> {
    Map<String, T> map;
    Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        if (reverseMap == null) {
            reverseMap = map.map((k, v) => new MapEntry(v, k));
        }
        return reverseMap;
    }
}
