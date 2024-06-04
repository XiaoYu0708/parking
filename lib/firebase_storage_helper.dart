import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageHelper {
  final storageRef = FirebaseStorage.instance.ref();
  late List allImages = [];

  getAllImages(parkingName, path) async {
    final listResult =
        await storageRef.child('yolov8/$parkingName/$path/images').listAll();

    for (var item in listResult.items) {
      String itemFullPath = item.fullPath;
      String imageUrl = await storageRef.child(itemFullPath).getDownloadURL();
      allImages.add(MyImage(
        name: path,
        fullPath: item.fullPath,
        imageUrl: imageUrl,
      ));
    }
  }
}

class MyImage {
  String name;
  String fullPath;
  String imageUrl;

  MyImage({
    required this.name,
    required this.fullPath,
    required this.imageUrl,
  });
}
