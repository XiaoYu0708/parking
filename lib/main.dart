import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:parking/parking_item.dart';
import 'package:widget_zoom/widget_zoom.dart';
import 'firebase_options.dart';
import 'firebase_storage_helper.dart';
import 'firestore_helper.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  runApp(const MyApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const Loading(),
    );
  }
}

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  final PageController _pageController = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          controller: _pageController,
          children: const [
            Icon(
              Icons.car_repair,
              size: 100,
            ),
            Hero(
              tag: 'titleIcon',
              child: Icon(
                Icons.local_parking,
                size: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(const Duration(milliseconds: 500)).then(
      (_) {
        _pageController
            .animateToPage(
              1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.linear,
            )
            .then(
              (_) => Future.delayed(const Duration(milliseconds: 500)).then(
                (_) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (builder) => const MainPage()),
                    (_) => false,
                  );
                },
              ),
            );
      },
    );
    super.initState();
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: Hero(
                tag: 'titleIcon',
                child: Icon(
                  Icons.local_parking,
                  size: 30,
                ),
              ),
            ),
            Text('停車場'),
          ],
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          WidgetZoom(
            heroAnimationTag: 'tag',
            zoomWidget: Image.asset(
              'assets/images/main_map.png',
            ),
          ),
          const Divider(),
          const Parking(),
        ],
      ),
    );
  }
}

class Parking extends StatefulWidget {
  const Parking({super.key});

  @override
  State<Parking> createState() => _ParkingState();
}

class _ParkingState extends State<Parking> {
  List<dynamic> data = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...data.map((value) {
          return Card(
            child: ListTile(
              leading: Hero(
                tag: value,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 48, 102, 176),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.local_parking,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
              title: Text(value),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (builder) => MyParking(name: value),
                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://raw.githubusercontent.com/XiaoYu0708/XiaoYu0708/main/parking.json',
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          data = json.decode(response.body)['data'];
        });
      } else {
        throw Exception('Failed to load data');
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void didChangeDependencies() {
    fetchData();
    super.didChangeDependencies();
  }
}

class MyParking extends StatefulWidget {
  final String name;

  const MyParking({
    super.key,
    required this.name,
  });

  @override
  State<MyParking> createState() => _MyParkingState();
}

class _MyParkingState extends State<MyParking> {
  ValueNotifier<List> myImages = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          leading: Hero(
            tag: widget.name,
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 48, 102, 176),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Icon(
                Icons.local_parking,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          title: Text(widget.name),
        ),
      ),
      body: myImages.value.isNotEmpty
          ? ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                WidgetZoom(
                  heroAnimationTag: 'tag',
                  zoomWidget: Image.asset(
                    'assets/images/${widget.name}.png',
                  ),
                ),
                const Divider(),
                ValueListenableBuilder(
                  valueListenable: myImages,
                  builder: (BuildContext context, value, Widget? child) {
                    return Column(
                      children: [
                        ...myImages.value.map((value) {
                          return Card(
                            child: ListTile(
                              leading: Image.network(value.imageUrl!),
                              title: Text(value.id),
                              subtitle: Text("剩餘車位：${value.emptySpace}"),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (builder) => ParkingItem(
                                      parkName: widget.name,
                                      image: value,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                      ],
                    );
                  },
                ),
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
    FirestoreHelper firestoreHelper = FirestoreHelper();

    await firestoreHelper.getData(path: widget.name);

    myImages.value = firestoreHelper.images;

    for (var value in myImages.value) {
      value.imageUrl = await getFirebaseStorage(value.id);
    }

    setState(() {});

    super.didChangeDependencies();
  }

  Future<String> getFirebaseStorage(id) async {
    FirebaseStorageHelper firebaseStorageHelper = FirebaseStorageHelper();

    await firebaseStorageHelper.getAllImages(widget.name, id);

    return firebaseStorageHelper.allImages[myImages.value.length - 1].imageUrl;
  }
}
