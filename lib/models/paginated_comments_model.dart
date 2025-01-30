import 'package:moto_kent/models/post_comment_model.dart';

class PaginatedCommentsModel {
  int? currentPage;
  int? totalPages;
  int? pageSize;
  int? totalItems;
  bool? hasPreviousPage;
  bool? hasNextPage;
  List<PostCommentModel>? items;

  PaginatedCommentsModel(
      {this.currentPage,
        this.totalPages,
        this.pageSize,
        this.totalItems,
        this.hasPreviousPage,
        this.hasNextPage,
        this.items});

  PaginatedCommentsModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    pageSize = json['pageSize'];
    totalItems = json['totalItems'];
    hasPreviousPage = json['hasPreviousPage'];
    hasNextPage = json['hasNextPage'];
    if (json['items'] != null) {
      items = <PostCommentModel>[];
      json['items'].forEach((v) {
        items!.add(PostCommentModel.fromJson(v));
      });
    }
  }
}