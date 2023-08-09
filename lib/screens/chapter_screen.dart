import 'package:flutter/material.dart';
import 'package:flutter_comic_reader/model/comic.dart';
import 'package:provider/provider.dart';

class ChapterScreen extends StatelessWidget {
  const ChapterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Comic>(
        builder: (context, watch, _) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xFFF44A3E),
              title: Center(
                child: Text(
                  '${watch.name.toUpperCase()}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            body: watch.chapters != null && watch.chapters.length > 0
                ? Padding(
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                  itemCount: watch.chapters.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: Column(
                        children: [
                          ListTile(
                            title: Text('${watch.chapters[index].name}'),
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
