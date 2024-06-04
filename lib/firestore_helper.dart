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
              totalSpace: doc.data()['total_space'],
              occupiedSpace: doc.data()['occupied_space'],
              emptySpace: doc.data()['empty_space'],
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
  int totalSpace;
  int occupiedSpace;
  int emptySpace;

  MyImageDB({
    required this.id,
    required this.totalSpace,
    required this.occupiedSpace,
    required this.emptySpace,
  });
}
