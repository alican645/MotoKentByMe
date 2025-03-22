import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/models/paginated_posts_model.dart';
import 'package:moto_kent/models/post_model.dart';
import 'package:moto_kent/services/api_service_impl.dart';
import 'package:moto_kent/services/iapi_service.dart';

class MyPostViewmodel extends ChangeNotifier {
  final IApiService _dio = ApiServiceImpl();

  int _currentPage = 1;
  int get currentPage => _currentPage;

  int _totalPages = 1;
  int get totalPages => _totalPages;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final List<PostModel> _posts = [];
  List<PostModel> get posts => _posts;

  // Tüm postları getir
  Future<void> fetchFavoritePostList() async {
    String? userId = await LocalStorageImpl().getValue<String>("user_id");
    if (_isLoading || _currentPage > _totalPages) return;

    _isLoading = true;
    notifyListeners();

    try {
      var response = await _dio.getRequest(
          ApiConstants.getPaginatedPostUserId(10, _currentPage, userId!));
      var model = PaginatedPostsModel.fromJson(response.data);
      _posts.addAll(model.items!);
      _currentPage++;
      _totalPages = model.totalPages!;
    } catch (e) {
      print('Hata: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Pagination ve post listesini sıfırla
  void resetPagination() {
    _currentPage = 1;
    _totalPages = 1;
    _posts.clear();
    fetchFavoritePostList();
    notifyListeners();
  }
}
