import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FirestoreHelper {
  late FirebaseFirestore db;
  late List images = [];

  FirestoreHelper() {
    db = FirebaseFirestore.instance;
  }

  //此不會覆蓋舊檔案，將新增一個隨機 id 的文件
  //data : Map<String, dynamic> -> {
  //       "first": "Ada",
  //       "last": "Lovelace",
  //       "born": 1815
  //     };
  //path : String -> 'users'
  addData({required Map<String, dynamic> data, required String path}) {
    db.collection(path).add(data).then((DocumentReference doc) {
      debugPrint('DocumentSnapshot added with ID: ${doc.id}');
    }, onError: (e) {
      debugPrint("Error completing: $e");
    });
  }

  getData({required path}) async {
    await db.collection(path).get().then(
      (event) {
        for (var doc in event.docs) {
          images.add(
            MyImageDB(
              id: doc.id,
              total_space: doc.data()['total_space'],
              occupied_space: doc.data()['occupied_space'],
              empty_space: doc.data()['empty_space'],
            ),
          );
        }
      },
      onError: (e) {
        debugPrint("Error completing: $e");
      },
    );
  }
}

class MyImageDB {
  String id;
  int total_space;
  int occupied_space;
  int empty_space;

  MyImageDB({
    required this.id,
    required this.total_space,
    required this.occupied_space,
    required this.empty_space,
  });
}
