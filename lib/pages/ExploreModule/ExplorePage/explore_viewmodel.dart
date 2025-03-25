import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/init/Helpers/local_storage_impl.dart';
import 'package:moto_kent/models/baanner_model.dart';
import 'package:moto_kent/models/paginated_posts_model.dart';
import 'package:moto_kent/models/post_model.dart';
import 'package:moto_kent/services/api_service_impl.dart';

class ExploreViewmodel extends ChangeNotifier {
  final LocalStorageImpl _localStorage = LocalStorageImpl();

  final List<dynamic> _postCategoryModelList = [];
  List<dynamic> get postCategoryModelList => _postCategoryModelList;

  String? _selectedCategoryName;
  String? get selectedCategoryName => _selectedCategoryName;

  final List<PostModel> _posts = [];
  List<PostModel> get posts => _posts;

  List<BannerModel> _banners = [];
  List<BannerModel> get banners => _banners;

  int _notificationCount = 0;
  int get notificationCount => _notificationCount;
  void resetNotification() {
    _notificationCount = 0;
    notifyListeners();
  }

  int _currentPage = 1;
  int get currentPage => _currentPage;

  int _totalPages = 1;
  int get totalPages => _totalPages;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isAllOrByCategory =
      true; // true: tüm postlar, false: kategoriye göre postlar
  bool get isAllOrByCategory => _isAllOrByCategory;

  int? _selectedCategoryId; // Seçili kategori ID
  int? get selectedCategoryId => _selectedCategoryId;

  bool _showNewPostBtn = false;
  bool get showNewPostBtn => _showNewPostBtn;
  // Yeni post butonunu göster/gizle

  int? _categoryId;
  int? get categoryId => _categoryId;

  void showNewPostBtnFun() {
    _showNewPostBtn = true;
    notifyListeners();
  }

  void dontShowNewPostBtnFun() {
    _showNewPostBtn = false;
    notifyListeners();
  }

  final ApiServiceImpl _dio = ApiServiceImpl();

  Future<void> fetchAllCurrentBanner() async {
    var response = await _dio.getRequest(ApiConstants.getAllCurrentBanner);
    _banners = (response.data as List)
        .map((item) => BannerModel.fromJson(item))
        .toList();
    notifyListeners();
  }

  // Pagination ve post listesini sıfırla
  void resetPagination() {
    _currentPage = 1;
    _totalPages = 1;
    _posts.clear();
    _isAllOrByCategory = true; // Tüm postlara dönecek
    _selectedCategoryName = null;
    _selectedCategoryId = null; // Seçili kategori kaldırılacak
    _showNewPostBtn = false; // Yeni post düğmesi gizlenecek
    notifyListeners();
  }

  // Tüm postları getir
  Future<void> fetchPostList() async {
    if (_isLoading || _currentPage > _totalPages) return;

    _isLoading = true;
    //resetPagination();
    notifyListeners();

    try {
      String? userId = await _localStorage.getValue<String>("user_id");
      var response = await _dio.getRequest(
          ApiConstants.getPaginatedPostsByPageSize(_currentPage, 5, userId!));
      var model = PaginatedPostsModel.fromJson(response.data);
      _notificationCount = model.totalNotificationCount!;
      _posts.addAll(model.items!);
      _currentPage++;
      _totalPages = model.totalPages!;
    } catch (e) {
      log("fetchPost", error: e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPostList2({int? category, int? city}) async {
    //resetPagination();
    resetNotification();
    if (_isLoading || _currentPage > _totalPages) return;

    _isLoading = true;
    notifyListeners();

    try {
      var response = await _dio.getRequest(
          ApiConstants.getPaginatedPostsByCategory(
              page: _currentPage,
              pageSize: 5,
              postCategoryEnum: category,
              turkeyProvince: city));
      var model = PaginatedPostsModel.fromJson(response.data);
      _posts.addAll(model.items!);
      _currentPage++;
      _totalPages = model.totalPages!;
    } catch (e) {
      log("fetchPost2", error: e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Belirli kategoriye göre postları getir
  Future<void> fetchPostListByCategoryId(int categoryId) async {
    if (_isLoading || _currentPage > _totalPages) return;

    _isLoading = true;
    notifyListeners();

    try {
      var response = await _dio.getRequest(
          ApiConstants.getPaginatedPostsByCategoryId(_currentPage, categoryId));
      var model = PaginatedPostsModel.fromJson(response.data);
      _posts.addAll(model.items!);
      _currentPage++;
      _totalPages = model.totalPages!;
    } catch (e) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Kategori veya tüm postları getir
  Future<void> fetchAllOrCategoryId() async {
    if (_isAllOrByCategory) {
      await fetchPostList();
    } else if (_selectedCategoryId != null) {
      await fetchPostListByCategoryId(_selectedCategoryId!);
    }
  }
}
