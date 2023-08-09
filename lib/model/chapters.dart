class Chapters {
  late List<String> links;
  late String name;

  Chapters({required this.links, required this.name});

  Chapters.fromJson(Map<String, dynamic> json) {
    if(json['Links'] != null) {
      links = json['Links'].cast<String>();
      name = json['Name'];
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  new Map<String, dynamic>();
    data['Links'] = links;
    data['Name'] = name;
    return data;
  }
}