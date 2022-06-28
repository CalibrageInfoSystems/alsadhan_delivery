// To parse this JSON data, do
//
//     final ordersCountModel = ordersCountModelFromJson(jsonString);

import 'dart:convert';

OrdersCountModel ordersCountModelFromJson(String str) => OrdersCountModel.fromJson(json.decode(str));

String ordersCountModelToJson(OrdersCountModel data) => json.encode(data.toJson());

class OrdersCountModel {
    Result result;
    bool isSuccess;
    int affectedRecords;
    String endUserMessage;
    List<dynamic> validationErrors;
    dynamic exception;

    OrdersCountModel({
        this.result,
        this.isSuccess,
        this.affectedRecords,
        this.endUserMessage,
        this.validationErrors,
        this.exception,
    });

    factory OrdersCountModel.fromJson(Map<String, dynamic> json) => OrdersCountModel(
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
    int inTransit;
    int delivered;
    int cancelled;
    int received;
    int collectedFromStore;

    Result({
        this.inTransit,
        this.delivered,
        this.cancelled,
        this.received,
        this.collectedFromStore,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        inTransit: json["InTransit"] == null ? null : json["InTransit"],
        delivered: json["Delivered"] == null ? null : json["Delivered"],
        cancelled: json["Cancelled"] == null ? null : json["Cancelled"],
        received: json["Received"] == null ? null : json["Received"],
        collectedFromStore: json["CollectedFromStore"] == null ? null : json["CollectedFromStore"],
    );

    Map<String, dynamic> toJson() => {
        "InTransit": inTransit == null ? null : inTransit,
        "Delivered": delivered == null ? null : delivered,
        "Cancelled": cancelled == null ? null : cancelled,
        "Received": received == null ? null : received,
        "CollectedFromStore": collectedFromStore == null ? null : collectedFromStore,
    };
}
