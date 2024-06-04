import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:parking/parking_item.dart';
import 'firebase_options.dart';
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
        const Parking(),
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
          NavigationDestination(
              icon: Icon(Icons.local_parking), label: 'Parking'),
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
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            title: const Text("Khare_testvideo"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (builder) =>
                      const MyParking(name: "Khare_testvideo"),
                ),
              );
            },
          ),
          ListTile(
            title: const Text("Khare_testvideo2"),
            onTap: () {},
          ),
        ],
      ),
    );
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
