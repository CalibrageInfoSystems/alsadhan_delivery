// To parse this JSON data, do
//
//     final updateStatusTyprModel = updateStatusTyprModelFromJson(jsonString);

import 'dart:convert';

UpdateStatusTyprModel updateStatusTyprModelFromJson(String str) => UpdateStatusTyprModel.fromJson(json.decode(str));

String updateStatusTyprModelToJson(UpdateStatusTyprModel data) => json.encode(data.toJson());

class UpdateStatusTyprModel {
    Result result;
    bool isSuccess;
    int affectedRecords;
    String endUserMessage;
    List<dynamic> validationErrors;
    dynamic exception;

    UpdateStatusTyprModel({
        this.result,
        this.isSuccess,
        this.affectedRecords,
        this.endUserMessage,
        this.validationErrors,
        this.exception,
    });

    factory UpdateStatusTyprModel.fromJson(Map<String, dynamic> json) => UpdateStatusTyprModel(
        result: json["Result"] == null ? null : Result.fromJson(json["Result"]),
        isSuccess: json["IsSuccess"] == null ? null : json["IsSuccess"],
        affectedRecords: json["AffectedRecords"] == null ? null : json["AffectedRecords"],
        endUserMessage: json["EndUserMessage"] == null ? null : json["EndUserMessage"],
        validationErrors: json["ValidationErrors"] == null ? null : List<dynamic>.from(json["ValidationErrors"].map((x) => x)),
        exception: json["Exception"],
    );

    Map<String, dynamic> toJson() => {
        "Result": result == null ? null : result.toJson(),
        "IsSuccess": isSuccess == null ? null : isSuccess,
        "AffectedRecords": affectedRecords == null ? null : affectedRecords,
        "EndUserMessage": endUserMessage == null ? null : endUserMessage,
        "ValidationErrors": validationErrors == null ? null : List<dynamic>.from(validationErrors.map((x) => x)),
        "Exception": exception,
    };
}

class Result {
    int id;
    String code;
    int userId;
    double totalPrice;
    int storeId;
    String address;
    String landmark;
    String cityName;
    String postalCode;
    int statusTypeId;
    String comments;
    DateTime deliveryDate;
    String timeSlot;
    int createdByUserId;
    DateTime createdDate;
    int updatedByUserId;
    DateTime updatedDate;
    int deliveryAgentId;

    Result({
        this.id,
        this.code,
        this.userId,
        this.totalPrice,
        this.storeId,
        this.address,
        this.landmark,
        this.cityName,
        this.postalCode,
        this.statusTypeId,
        this.comments,
        this.deliveryDate,
        this.timeSlot,
        this.createdByUserId,
        this.createdDate,
        this.updatedByUserId,
        this.updatedDate,
        this.deliveryAgentId,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["Id"] == null ? null : json["Id"],
        code: json["Code"] == null ? null : json["Code"],
        userId: json["UserId"] == null ? null : json["UserId"],
        totalPrice: json["TotalPrice"] == null ? null : json["TotalPrice"].toDouble(),
        storeId: json["StoreId"] == null ? null : json["StoreId"],
        address: json["Address"] == null ? null : json["Address"],
        landmark: json["Landmark"] == null ? null : json["Landmark"],
        cityName: json["CityName"] == null ? null : json["CityName"],
        postalCode: json["PostalCode"] == null ? null : json["PostalCode"],
        statusTypeId: json["StatusTypeId"] == null ? null : json["StatusTypeId"],
        comments: json["Comments"] == null ? null : json["Comments"],
        deliveryDate: json["DeliveryDate"] == null ? null : DateTime.parse(json["DeliveryDate"]),
        timeSlot: json["TimeSlot"] == null ? null : json["TimeSlot"],
        createdByUserId: json["CreatedByUserId"] == null ? null : json["CreatedByUserId"],
        createdDate: json["CreatedDate"] == null ? null : DateTime.parse(json["CreatedDate"]),
        updatedByUserId: json["UpdatedByUserId"] == null ? null : json["UpdatedByUserId"],
        updatedDate: json["UpdatedDate"] == null ? null : DateTime.parse(json["UpdatedDate"]),
        deliveryAgentId: json["DeliveryAgentId"] == null ? null : json["DeliveryAgentId"],
    );

    Map<String, dynamic> toJson() => {
        "Id": id == null ? null : id,
        "Code": code == null ? null : code,
        "UserId": userId == null ? null : userId,
        "TotalPrice": totalPrice == null ? null : totalPrice,
        "StoreId": storeId == null ? null : storeId,
        "Address": address == null ? null : address,
        "Landmark": landmark == null ? null : landmark,
        "CityName": cityName == null ? null : cityName,
        "PostalCode": postalCode == null ? null : postalCode,
        "StatusTypeId": statusTypeId == null ? null : statusTypeId,
        "Comments": comments == null ? null : comments,
        "DeliveryDate": deliveryDate == null ? null : deliveryDate.toIso8601String(),
        "TimeSlot": timeSlot == null ? null : timeSlot,
        "CreatedByUserId": createdByUserId == null ? null : createdByUserId,
        "CreatedDate": createdDate == null ? null : createdDate.toIso8601String(),
        "UpdatedByUserId": updatedByUserId == null ? null : updatedByUserId,
        "UpdatedDate": updatedDate == null ? null : updatedDate.toIso8601String(),
        "DeliveryAgentId": deliveryAgentId == null ? null : deliveryAgentId,
    };
}
