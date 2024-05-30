import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageHelper{
  final storageRef = FirebaseStorage.instance.ref();

  getAllImages() async {
    final listResult = await storageRef.child('images').listAll();

    List myItemsFullPath = [];

    for (var item in listResult.items) {
      String itemFullPath = item.fullPath;
      String imageUrl = await storageRef.child(itemFullPath).getDownloadURL();
      myItemsFullPath.add(imageUrl);
    }

    return myItemsFullPath;
  }

  getAllVideos() async{
    final listResult = await storageRef.child('videos').listAll();

    List myItemsFullPath = [];

    for (var item in listResult.items) {
      String itemFullPath = item.fullPath;
      String videoUrl = await storageRef.child(itemFullPath).getDownloadURL();
      myItemsFullPath.add(videoUrl);
    }

    return myItemsFullPath;
  }
}