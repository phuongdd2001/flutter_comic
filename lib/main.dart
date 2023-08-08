
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp(
      name: 'comic_reader_flutter',
      options: !kIsWeb && Platform.isAndroid
          ? FirebaseOptions(
              apiKey: 'AIzaSyB2TdGbFuL-plTPdLyAsnxReGu3citniyc',
              appId: 'IOS KEY',
              messagingSenderId: '89108969198',
              projectId: 'phuongdd-cb33d',
              databaseURL: 'https://phuongdd-cb33d-default-rtdb.firebaseio.com',
            )
          : FirebaseOptions(
              apiKey: 'AIzaSyB2TdGbFuL-plTPdLyAsnxReGu3citniyc',
              appId: '1:89108969198:android:15e62492cf76197494a5ff',
              messagingSenderId: '89108969198',
              projectId: 'phuongdd-cb33d',
              databaseURL: 'https://phuongdd-cb33d-default-rtdb.firebaseio.com',
            ));
  runApp(ProviderScope(child: MyApp(app: app)));
}

class MyApp extends StatelessWidget {
  FirebaseApp app;
  MyApp({Key? key, required this.app}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Comic Reader', app: app),
    );
  }
}

class MyHomePage extends StatefulWidget {

  const MyHomePage({Key? key,  required this.title, required this.app }) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final FirebaseApp app;
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late  DatabaseReference _bannerRef;

  @override
  void initState () {
    super.initState();
    final FirebaseDatabase _database = FirebaseDatabase(app: widget.app);
    _bannerRef = _database.reference().child('Banners');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF44A3E),
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
      ),
      body: FutureBuilder<List<String>>(
        future: getBanners(_bannerRef),
        builder: (BuildContext context, snapshot){
          return Column();
        },
      ),
    );
  }

  Future<List<String>> getBanners(DatabaseReference bannerRef) async {
    return bannerRef
        .once()
        .then((event) => event.value.cast<String>().toList());
  }
}
