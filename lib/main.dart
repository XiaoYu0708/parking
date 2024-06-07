import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:parking/parking_item.dart';
import 'firebase_options.dart';
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
      home: const MainPage(),
    );
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
        title: const Text('停車場'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset("assets/images/main_map.png"),
            ),
          ),
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
          return ListTile(
            title: Text(value),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (builder) => MyParking(name: value),
                ),
              );
            },
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
        title: Text(widget.name),
      ),
      body: myImages.value != []
          ? ValueListenableBuilder(
              valueListenable: myImages,
              builder: (BuildContext context, value, Widget? child) {
                return ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(value[index].id),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (builder) => ParkingItem(
                              parkName: widget.name,
                              image: value[index],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                  itemCount: myImages.value.length,
                );
              },
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

    setState(() {});

    super.didChangeDependencies();
  }
}
