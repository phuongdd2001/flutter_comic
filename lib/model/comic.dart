import 'package:flutter_comic_reader/model/chapters.dart';

class Comic {
  dynamic category, name, image;
  late List<Chapters> chapters;

  Comic(
      {this.category,
      List<Chapters> this.chapters = const [],
      this.image,
      this.name});

  Comic.fromJson(Map<String, dynamic> json) {
    category = json['Category'];
    if (json['Chapters'] != null) {
      List<Chapters> chapters = [];
      json['Chapters'].forEach((v) {
        chapters.add(new Chapters.fromJson(v));
      });
    }
    image = json['Image'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Category'] = category;
    if (chapters != null) {
      data['chapters'] = chapters.map((e) => e.toJson()).toList() ?? [];
    }
    data['Image'] = image;
    data['Name'] = name;
    return data;
  }
}
