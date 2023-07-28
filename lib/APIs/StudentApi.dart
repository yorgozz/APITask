// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StudentApi extends StatelessWidget {
  StudentApi({super.key});

  TextEditingController textEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            child: Text("jibon kellon"),
            onPressed: () async {
              var response = await http
                  .get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
              var decodedResponse = jsonDecode(response.body);

              var result = decodedResponse as List;
              final finalResponse =
                  result.map((map) => PostModel.fromJson(map)).toList();

              for (int i = 0; i < finalResponse.length; i++) {
                print(finalResponse[i].title);
              }
            },
          ),
          SizedBox(
            height: 30,
          ),
          TextFormField(
            controller: textEditingController,
          ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
            child: Text("jib wehde"),
            onPressed: () async {
              await getPostById(textEditingController.text);
            },
          ),
        ],
      ),
    ));
  }

  getPostById(String postId) async {
    try {
      var response = await http
          .get(Uri.parse("https://jsonplaceholder.typicode.com/posts/$postId"));
      var decodedResponse = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw decodedResponse["message"];
      }

      final finalResponse = PostModel.fromJson(decodedResponse);

      print(finalResponse.toString());
    } catch (e) {
      print(e);
    }
  }
}

PostModel postModelFromJson(String str) => PostModel.fromJson(json.decode(str));

String postModelToJson(PostModel data) => json.encode(data.toJson());

class PostModel {
  final int? userId;
  final int? id;
  final String? title;
  final String? body;

  PostModel({
    this.userId,
    this.id,
    this.title,
    this.body,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        userId: json["userId"],
        id: json["id"],
        title: json["title"],
        body: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "title": title,
        "body": body,
      };

  @override
  String toString() {
    return 'PostModel(userId: $userId, id: $id, title: $title, body: $body)';
  }
}
