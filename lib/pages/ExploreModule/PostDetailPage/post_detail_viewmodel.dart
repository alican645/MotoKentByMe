import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/constants/data_objects.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/models/complaint_reason_model.dart';
import 'package:moto_kent/models/paginated_comments_model.dart';
import 'package:moto_kent/models/post_comment_model.dart';
import 'package:moto_kent/models/post_model.dart';
import 'package:moto_kent/services/api_service_impl.dart';

class PostDetailViewmodel extends ChangeNotifier {
  PostModel? _postModel;
  PostModel? get postModel => _postModel;
  final ApiServiceImpl _dio = ApiServiceImpl();

  List<ComplaintReasonModel> _list = [];
  List<ComplaintReasonModel> get list => _list;

  bool _isFollow = false;
  bool get isFollow => _isFollow;

  final List<PostCommentModel> _comments = [];
  List<PostCommentModel> get comments => _comments;
  void addCommentToList(PostCommentModel model) {
    _comments.insert(0, model);
    notifyListeners();
  }

  int _currentPageComment = 1;
  int get currentPageComment => _currentPageComment;

  int _totalPagesComment = 1;
  int get totalPagesComment => _totalPagesComment;

  bool _isLoadingComment = false;
  bool get isLoadingComment => _isLoadingComment;

  // post detay ekranı ilk yüklendiğinde
  Future<void> getPostByPostId(int postId) async {
    _postModel = null;
    notifyListeners();
    String? userId = await LocalStorageImpl().getValue<String>("user_id");
    var response =
        await _dio.getRequest(ApiConstants.getPostByPostId(postId, userId!));
    if (response.statusCode == 200) {
      _postModel = PostModel.fromJson(response.data);
      notifyListeners();
    }
  }

  // post detay erkanındaki like ve dislike butonuna basıldığında
  Future<void> returnPostByPostId(int postId) async {
    notifyListeners();
    String? userId = await LocalStorageImpl().getValue<String>("user_id");
    var response =
        await _dio.getRequest(ApiConstants.getPostByPostId(postId, userId!));
    if (response.statusCode == 200) {
      _postModel = PostModel.fromJson(response.data);
      notifyListeners();
    }
  }

  Future<void> likePost(Object data) async {
    var response = await _dio.postRequest(ApiConstants.likePost, data);
    if (response.statusCode == 200) {
      returnPostByPostId((data as Map<String, dynamic>)["postId"]);
    }
  }

  Future<void> votePost(Object data) async {
    var response = await _dio.postRequest(ApiConstants.votePost, data);
    if (response.statusCode == 200) {
      returnPostByPostId((data as Map<String, dynamic>)["postId"]);
    }
  }

  Future<void> favoritePost(Object data) async {
    var response = await _dio.postRequest(ApiConstants.favoritePost, data);
    if (response.statusCode == 200) {
      returnPostByPostId((data as Map<String, dynamic>)["postId"]);
    }
  }

  Future<Response> followOrUnfollowUser(Object object, bool isFollow) async {
    String endpoint =
        isFollow ? ApiConstants.followEndpoint : ApiConstants.unfollowEndpoint;
    var response = await _dio.postRequest(endpoint, object);
    return response;
  }

  Future<void> followerRelationshipEndPoint(Object object) async {
    var response = await _dio.postRequest(
        ApiConstants.userFollowerRelationshipEndPoint, object);
    if (response.statusCode == 200) {
      if (response.data is Map<String, dynamic>) {
        if ((response.data as Map<String, dynamic>)["relationship"] == true) {
          _isFollow = true;
          notifyListeners();
        } else {
          _isFollow = false;
          notifyListeners();
        }
      }
    }
  }

  Future<Response> startPrivateConversation(String userId2) async {
    String? userId = await LocalStorageImpl().getValue<String>("user_id");
    var response = await _dio.postRequest(
        ApiConstants.createPrivateConversation,
        DataObjects.privateConversationObject(userId!, userId2));
    return response;
  }

  Future<Response> sharePost(Object requestBody) async {
    var result = await _dio.postRequest(ApiConstants.sharePost, requestBody);
    return result;
  }

  Future<void> fetchComplaintReason() async {
    var response = await _dio.getRequest(ApiConstants.getAllComplaintReasons);
    if (response.data is List) {
      _list = (response.data as List)
          .map(
            (e) => ComplaintReasonModel.fromJson(e),
          )
          .toList();
    }
  }

  Future<Response> addComplaint(Object data) async {
    var response = await _dio.postRequest(ApiConstants.addComplaint, data);
    return response;
  }

  // Tüm postları getir
  Future<void> fetchCommentList(int postid) async {
    if (_isLoadingComment || _currentPageComment > _totalPagesComment) return;

    _isLoadingComment = true;
    notifyListeners();

    try {
      var response = await _dio.getRequest(
          ApiConstants.getPaginatedComments(postid, _currentPageComment));
      var model = PaginatedCommentsModel.fromJson(response.data);
      _comments.addAll(model.items!);
      _currentPageComment++;
      _totalPagesComment = model.totalPages!;
    } catch (e) {
      log("PaginatedComments", error: e.toString());
    } finally {
      _isLoadingComment = false;
      notifyListeners();
    }
  }

  Future<Response> addComment(Object data) async {
    try {
      var response = await _dio.postRequest(ApiConstants.addPostComment, data);
      return response;
    } catch (ex) {
      log("AddComment", error: ex.toString());
      throw Exception(ex);
    }
  }

  // Pagination ve post listesini sıfırla
  void resetPagination() {
    _currentPageComment = 1;
    _totalPagesComment = 1;
    _comments.clear();
    notifyListeners();
  }
}
