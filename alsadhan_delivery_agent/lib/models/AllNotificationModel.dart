// To parse this JSON data, do
//
//     final allNotificationModel = allNotificationModelFromJson(jsonString);

import 'dart:convert';

AllNotificationModel allNotificationModelFromJson(String str) => AllNotificationModel.fromJson(json.decode(str));

String allNotificationModelToJson(AllNotificationModel data) => json.encode(data.toJson());

class AllNotificationModel {
    List<ListResult> listResult;
    bool isSuccess;
    int affectedRecords;
    String endUserMessage;
    List<dynamic> validationErrors;
    dynamic exception;

    AllNotificationModel({
        this.listResult,
        this.isSuccess,
        this.affectedRecords,
        this.endUserMessage,
        this.validationErrors,
        this.exception,
    });

    factory AllNotificationModel.fromJson(Map<String, dynamic> json) => AllNotificationModel(
        listResult: json["ListResult"] == null ? null : List<ListResult>.from(json["ListResult"].map((x) => ListResult.fromJson(x))),
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

class ListResult {
    int id;
    int orderId;
    int userId;
    String desc;
    bool isRead;
    int notificationTypeId;
    bool isActive;
    int createdByUserId;
    DateTime createdDate;
    int updatedByUserId;
    DateTime updatedDate;

    ListResult({
        this.id,
        this.orderId,
        this.userId,
        this.desc,
        this.isRead,
        this.notificationTypeId,
        this.isActive,
        this.createdByUserId,
        this.createdDate,
        this.updatedByUserId,
        this.updatedDate,
    });

    factory ListResult.fromJson(Map<String, dynamic> json) => ListResult(
        id: json["Id"] == null ? null : json["Id"],
        orderId: json["OrderId"] == null ? null : json["OrderId"],
        userId: json["UserId"] == null ? null : json["UserId"],
        desc: json["Desc"] == null ? null : json["Desc"],
        isRead: json["IsRead"] == null ? null : json["IsRead"],
        notificationTypeId: json["NotificationTypeId"] == null ? null : json["NotificationTypeId"],
        isActive: json["IsActive"] == null ? null : json["IsActive"],
        createdByUserId: json["CreatedByUserId"] == null ? null : json["CreatedByUserId"],
        createdDate: json["CreatedDate"] == null ? null : DateTime.parse(json["CreatedDate"]),
        updatedByUserId: json["UpdatedByUserId"] == null ? null : json["UpdatedByUserId"],
        updatedDate: json["UpdatedDate"] == null ? null : DateTime.parse(json["UpdatedDate"]),
    );

    Map<String, dynamic> toJson() => {
        "Id": id == null ? null : id,
        "OrderId": orderId == null ? null : orderId,
        "UserId": userId == null ? null : userId,
        "Desc": desc == null ? null : desc,
        "IsRead": isRead == null ? null : isRead,
        "NotificationTypeId": notificationTypeId == null ? null : notificationTypeId,
        "IsActive": isActive == null ? null : isActive,
        "CreatedByUserId": createdByUserId == null ? null : createdByUserId,
        "CreatedDate": createdDate == null ? null : createdDate.toIso8601String(),
        "UpdatedByUserId": updatedByUserId == null ? null : updatedByUserId,
        "UpdatedDate": updatedDate == null ? null : updatedDate.toIso8601String(),
    };
}
