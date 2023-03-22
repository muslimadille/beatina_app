// To parse this JSON data, do
//
//     final MiyasarUrlResponse = MiyasarUrlResponseFromJson(jsonString);

import 'dart:convert';

MiyasarUrlResponse MiyasarUrlResponseFromJson(String str) => MiyasarUrlResponse.fromJson(json.decode(str));

String MiyasarUrlResponseToJson(MiyasarUrlResponse data) => json.encode(data.toJson());

class MiyasarUrlResponse {
  MiyasarUrlResponse({
    this.result,
    this.url,
    this.message,
  });

  bool result;
  String url;
  String message;

  factory MiyasarUrlResponse.fromJson(Map<String, dynamic> json) => MiyasarUrlResponse(
    result: json["result"],
    url: json["url"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "url": url,
    "message": message,
  };
}