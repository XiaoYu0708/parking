import 'package:flutter/material.dart';
import 'firebase_storage_helper.dart';

class ParkingItem extends StatefulWidget {
  final String parkName;
  final dynamic image;

  const ParkingItem({
    super.key,
    required this.parkName,
    required this.image,
  });

  @override
  State<ParkingItem> createState() => _ParkingItemState();
}

class _ParkingItemState extends State<ParkingItem> {
  FirebaseStorageHelper firebaseStorageHelper = FirebaseStorageHelper();
  ValueNotifier<List> myImages = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.image.id),
      ),
      body: myImages.value.isNotEmpty
          ? ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                ValueListenableBuilder(
                  valueListenable: myImages,
                  builder: (BuildContext context, value, Widget? child) {
                    return Column(
                      children: [
                        Image.network(
                          value[myImages.value.length - 1].imageUrl,
                        ),
                      ],
                    );
                  },
                ),
                Text("總車位：${widget.image.totalSpace.toString()}"),
                Text("已停放：${widget.image.occupiedSpace.toString()}"),
                Text("剩餘車位：${widget.image.emptySpace.toString()}"),
              ],
            )
          : const Center(
              child: Text('載入中...'),
            ),
    );
  }

  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies

    await firebaseStorageHelper.getAllImages(widget.parkName, widget.image.id);

    myImages.value = firebaseStorageHelper.allImages;

    setState(() {});

    super.didChangeDependencies();
  }
}
