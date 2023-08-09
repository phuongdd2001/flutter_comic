import 'package:flutter/material.dart';
import 'package:flutter_comic_reader/state/state_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';

class ChapterScreen extends StatelessWidget {
  const ChapterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Consumer(
    //     builder: (context, watch, _) {
    //    return Scaffold(
    //     appBar: AppBar(
    //       backgroundColor: Color(0xFFF44A3E),
    //       title: Center(
    //         child: Text(
    //           '${context.read(comicSelected).state.name.toUpperCase()}',
    //           style: TextStyle(color: Colors.white),
    //         ),
    //       ),
    //     ),
    //   );
    // });
    return Consumer(builder: (context, watch, _) {
      var comic = context.watch(comicSelected).state;
      // print(comic);
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFF44A3E),
          title: Center(
            child: Text(
              // '${comic.name.toUpperCase()}',
              'hehe',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        body: comic.characters != null && comic.characters.length > 0
            ? Padding(
                padding: const EdgeInsets.all(8),
                child: ListView.builder(
                    itemCount: comic.characters.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: Column(
                          children: [
                            ListTile(
                              title: Text('${comic.characters[index].name}'),
                            ),
                            Divider(
                              thickness: 1,
                            )
                          ],
                        ),
                      );
                    }),
              )
            : Center(child: Text('We are translating this comic')),
      );
    });
  }
}
