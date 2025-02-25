import 'package:moto_kent/models/about_item_model.dart';

class AboutTitleModel {
  int? id;
  String? title;
  List<AboutItemModel>? aboutItems;

  AboutTitleModel({this.id, this.title, this.aboutItems});

  AboutTitleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    if (json['aboutItems'] != null) {
      aboutItems = <AboutItemModel>[];
      json['aboutItems'].forEach((v) {
        aboutItems!.add(AboutItemModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    if (aboutItems != null) {
      data['aboutItems'] = aboutItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
