import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_comic_reader/model/comic.dart';
import 'package:flutter_comic_reader/screens/chapter_screen.dart';
import 'package:flutter_comic_reader/state/state_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp(
      name: 'comic_reader_flutter',
      options: !kIsWeb && Platform.isAndroid
          ? const FirebaseOptions(
              apiKey: 'AIzaSyB2TdGbFuL-plTPdLyAsnxReGu3citniyc',
              appId: 'IOS KEY',
              messagingSenderId: '89108969198',
              projectId: 'phuongdd-cb33d',
              databaseURL: 'https://phuongdd-cb33d-default-rtdb.firebaseio.com',
            )
          : const FirebaseOptions(
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/chapters': (context) => const ChapterScreen(),
      },
      // debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Comic Reader', app: app),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.app})
      : super(key: key);

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
  late DatabaseReference _bannerRef, _conmicRef;

  @override
  void initState() {
    super.initState();
    final FirebaseDatabase _database = FirebaseDatabase(app: widget.app);
    _bannerRef = _database.reference().child('Banners');
    _conmicRef = _database.reference().child('Comic');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF44A3E),
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
      ),
      body: FutureBuilder<List<String>>(
        future: getBanners(_bannerRef),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CarouselSlider(
                    items: snapshot.data
                        ?.map((e) => Builder(
                              builder: (context) {
                                return Image.network(e, fit: BoxFit.cover);
                              },
                            ))
                        .toList(),
                    options: CarouselOptions(
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 1,
                        initialPage: 0,
                        height: MediaQuery.of(context).size.height / 3)),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        color: Color(0xFFFF44A3E),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            'New COMIC',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.black,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(''),
                        ),
                      ),
                    ),
                  ],
                ),
                FutureBuilder(
                  future: getComic(_conmicRef),
                  builder: (context, snapshot) {
                    if (snapshot.hasError)
                      return Center(child: Text('${snapshot.error}'));
                    else if (snapshot.hasData) {
                      List<Comic> comics = [];
                      snapshot.data?.forEach((item) {
                        var comic =
                            Comic.fromJson(json.decode(json.encode(item)));
                        comics.add(comic);
                      });
                      return Expanded(
                        child: GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8,
                            padding: const EdgeInsets.all(4.0),
                            mainAxisSpacing: 1.0,
                            children: comics.map((comic) {
                              return GestureDetector(
                                onTap: () {
                                  // context.read(comicSelected).state;
                                  Navigator.pushNamed(context, '/chapters');
                                },
                                child: Card(
                                  elevation: 12,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.network(
                                        comic.image,
                                        fit: BoxFit.cover,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            color: const Color(0xAA434343),
                                            padding: const EdgeInsets.all(8),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    '${comic.name}',
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList()),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ],
            );
          } else if (snapshot.hasError)
            return Center(child: Text('${snapshot.error}'));
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<List<String>> getBanners(DatabaseReference bannerRef) async {
    return bannerRef.once().then((event) =>
        (event.snapshot.value as List<dynamic>).cast<String>().toList());
  }

  Future<List<dynamic>> getComic(DatabaseReference comicRef) async {
    return comicRef
        .once()
        .then((event) => (event.snapshot.value as List<dynamic>));
  }
}
