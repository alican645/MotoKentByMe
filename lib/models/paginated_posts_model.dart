import 'package:moto_kent/models/post_model.dart';

class PaginatedPostsModel {
  int? currentPage;
  int? totalPages;
  int? pageSize;
  int? totalItems;
  bool? hasPreviousPage;
  bool? hasNextPage;
  List<PostModel>? items;

  PaginatedPostsModel(
      {this.currentPage,
        this.totalPages,
        this.pageSize,
        this.totalItems,
        this.hasPreviousPage,
        this.hasNextPage,
        this.items});

  PaginatedPostsModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    pageSize = json['pageSize'];
    totalItems = json['totalItems'];
    hasPreviousPage = json['hasPreviousPage'];
    hasNextPage = json['hasNextPage'];
    if (json['items'] != null) {
      items = <PostModel>[];
      json['items'].forEach((v) {
        items!.add(PostModel.fromJson(v));
      });
    }
  }
}