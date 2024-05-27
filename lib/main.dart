import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
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
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
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
        const Home(),
        const Parking(),
        const Profile(),
      ][bottomNavigationBarIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: bottomNavigationBarIndex,
        onDestinationSelected: (value) {
          setState(() {
            bottomNavigationBarIndex = value;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.local_parking), label: 'Parking'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    color: Colors.grey,
                    height: 150,
                    width: 150,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    color: Colors.grey,
                    height: 150,
                    width: 150,
                  ),
                ),
              ),
            ],
          )
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

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
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
        ],
      ),
    );
  }
}
