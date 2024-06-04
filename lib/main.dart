import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:parking/video_play.dart';
import 'firebase_options.dart';
import 'firebase_storage_helper.dart';
import 'firestore_helper.dart';

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
      home: const Menu(),
    );
  }
}

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int bottomNavigationBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('停車場'),
        centerTitle: true,
      ),
      body: [
        const Map(),
        const MyParking(),
      ][bottomNavigationBarIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: bottomNavigationBarIndex,
        onDestinationSelected: (value) {
          setState(() {
            bottomNavigationBarIndex = value;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.map), label: 'Map'),
          NavigationDestination(icon: Icon(Icons.local_parking), label: 'Parking'),
        ],
      ),
    );
  }
}

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset("assets/images/main_map.png"),
            ),
          ),
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
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class MyParking extends StatefulWidget {
  const MyParking({super.key});

  @override
  State<MyParking> createState() => _MyParkingState();
}

class _MyParkingState extends State<MyParking> {
  ValueNotifier<List> myImages = ValueNotifier([]);
  ValueNotifier<List> myVideos = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                style: ButtonStyle(
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (builder) => const Parking(),
                    ),
                  );
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      color: Colors.grey,
                      height: 130,
                      width: 130,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              TextButton(
                style: ButtonStyle(
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (builder) => const Parking(),
                    ),
                  );
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      color: Colors.grey,
                      height: 130,
                      width: 130,
                    ),
                  ),
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              FirestoreHelper firestoreHelper = FirestoreHelper();

              var data = <String, dynamic>{
                "first": "Ada",
                "last": "Lovelace",
                "born": 1815
              };

              firestoreHelper.addData(data: data, path: 'users');
            },
            child: const Text("新增資料"),
          ),
          ElevatedButton(
            onPressed: () async {
              FirestoreHelper firestoreHelper = FirestoreHelper();

              await firestoreHelper.getData(path: 'users');
            },
            child: const Text("讀取資料"),
          ),
          const Divider(),
          Title(
            color: Colors.black,
            child: const Text('Storage'),
          ),
          ElevatedButton(
            onPressed: () async {
              FirebaseStorageHelper firebaseStorageHelper =
                  FirebaseStorageHelper();
              myImages.value = await firebaseStorageHelper.getAllImages();
            },
            child: const Text('get images'),
          ),
          ElevatedButton(
            onPressed: () async {
              FirebaseStorageHelper firebaseStorageHelper =
                  FirebaseStorageHelper();
              myVideos.value = await firebaseStorageHelper.getAllVideos();
            },
            child: const Text('get videos'),
          ),
          ValueListenableBuilder(
            valueListenable: myImages,
            builder: (BuildContext context, List value, Widget? child) {
              return value != []
                  ? Column(
                      children: [
                        ...value.map((i) {
                          return Column(
                            children: [
                              Image.network(i),
                              const Divider(),
                            ],
                          );
                        }),
                      ],
                    )
                  : const SizedBox();
            },
          ),
          ValueListenableBuilder(
            valueListenable: myVideos,
            builder: (BuildContext context, List value, Widget? child) {
              return value != []
                  ? Column(
                      children: [
                        ...value.map((i) {
                          return Column(
                            children: [
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    title: Text(i),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (builder) => VideoPLay(
                                            videoPath: i,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const Divider(),
                            ],
                          );
                        }),
                      ],
                    )
                  : const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
