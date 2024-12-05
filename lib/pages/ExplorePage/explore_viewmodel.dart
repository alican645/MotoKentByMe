import 'package:flutter/material.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/models/category_form_file_model.dart';
import 'package:moto_kent/models/paginated_posts_model.dart';
import 'package:moto_kent/models/post_model.dart';
import 'package:moto_kent/services/dio_service_3.dart';

// class ExploreViewmodel extends ChangeNotifier {
//   List<dynamic> _postCategoryModelList = [];
//   List<dynamic> get postCategoryModelList => _postCategoryModelList;
//
//   final List<PostModel> _posts = [];
//   List<PostModel> get posts => _posts;
//
//   int _currentPage = 1;
//   int get currentPage =>_currentPage ;
//   void changeCurrentPage(int value){
//     _currentPage=value;
//     notifyListeners();
//   }
//
//   int _totalPages=1;
//   int get totalPages=>_totalPages;
//
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;
//
//
//
//   final DioService3 _dio = DioService3();
//
//   Future<void> fetchPostCategoryList() async {
//     var response = await _dio.getRequest(ApiConstants.getAllPostCategoriesFormFile);
//     _postCategoryModelList=response.data.map((item) => CategoryFormFileModel.fromJson(item)).toList();
//     notifyListeners();
//   }
//
//   void resetPagination() {
//     _currentPage = 1;
//     _totalPages = 1;
//     _posts.clear();
//     notifyListeners();
//   }
//
//
//   bool _isAllOrByCategory=true;
//   bool get isAllOrByCategory=>_isAllOrByCategory;
//   void changeisAllOrByCategory(){
//     _isAllOrByCategory=!_isAllOrByCategory;
//     notifyListeners();
//   }
//
//   Future<void> fetchAllOrCategoryId() async{
//     if(_isAllOrByCategory){
//       fetchPostList();
//     }else{
//       fetchPostListByCategoryId(categoryID);
//     }
//
//   }
//
//
//   Future<void> fetchPostList() async {
//     _isAllOrByCategory=true;
//     if (isLoading || _currentPage > _totalPages) return;
//     _isLoading = true;
//     notifyListeners();
//
//     try{
//       var response=await _dio.getRequest('${ApiConstants.getPaginatedPosts}$_currentPage');
//       var model = PaginatedPostsModel.fromJson(response.data);
//       _posts.addAll(model.items!);
//       _currentPage++;
//       _totalPages = model.totalPages!;
//     }catch(e){
//       print('Hata: $e');
//     }finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//
//   int categoryID=0;
//   Future<void> fetchPostListByCategoryId(int categoryId) async{
//     _isAllOrByCategory=false;
//     categoryID=categoryId;
//     if (isLoading || _currentPage > _totalPages) return;
//     _isLoading = true;
//     notifyListeners();
//
//     try{
//       var response=await _dio.getRequest(ApiConstants.getPaginatedPostsByCategoryId(_currentPage, categoryId));
//       var model = PaginatedPostsModel.fromJson(response.data);
//       _posts.addAll(model.items!);
//       _currentPage++;
//       _totalPages = model.totalPages!;
//     }catch(e){
//       print('Hata: $e');
//     }finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//
//
//
//   bool _showNewPostBtn=false;
//   bool get showNewPostBtn=>_showNewPostBtn;
//   void changeShowNewPostBtn(){
//     _showNewPostBtn=!_showNewPostBtn;
//     notifyListeners();
//   }
// }

class ExploreViewmodel extends ChangeNotifier {
  List<dynamic> _postCategoryModelList = [];
  List<dynamic> get postCategoryModelList => _postCategoryModelList;

  final List<PostModel> _posts = [];
  List<PostModel> get posts => _posts;

  int _currentPage = 1;
  int get currentPage => _currentPage;

  int _totalPages = 1;
  int get totalPages => _totalPages;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isAllOrByCategory = true; // true: tüm postlar, false: kategoriye göre postlar
  bool get isAllOrByCategory => _isAllOrByCategory;

  int? _selectedCategoryId; // Seçili kategori ID
  int? get selectedCategoryId => _selectedCategoryId;

  bool _showNewPostBtn = false;
  bool get showNewPostBtn => _showNewPostBtn;

  final DioService3 _dio = DioService3();

  // Kategori listesini getir
  Future<void> fetchPostCategoryList() async {
    var response = await _dio.getRequest(ApiConstants.getAllPostCategoriesFormFile);
    _postCategoryModelList =
        response.data.map((item) => CategoryFormFileModel.fromJson(item)).toList();
    notifyListeners();
  }

  // Pagination ve post listesini sıfırla
  void resetPagination() {
    _currentPage = 1;
    _totalPages = 1;
    _posts.clear();
    _isAllOrByCategory = true; // Tüm postlara dönecek
    _selectedCategoryId = null; // Seçili kategori kaldırılacak
    _showNewPostBtn = false; // Yeni post düğmesi gizlenecek
    notifyListeners();
  }

  // Tüm postları getir
  Future<void> fetchPostList() async {
    if (_isLoading || _currentPage > _totalPages) return;

    _isLoading = true;
    notifyListeners();

    try {
      var response = await _dio.getRequest('${ApiConstants.getPaginatedPosts}$_currentPage');
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

  // Belirli kategoriye göre postları getir
  Future<void> fetchPostListByCategoryId(int categoryId) async {
    if (_isLoading || _currentPage > _totalPages) return;

    _isLoading = true;
    notifyListeners();

    try {
      var response =
      await _dio.getRequest(ApiConstants.getPaginatedPostsByCategoryId(_currentPage, categoryId));
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

  // Kategori veya tüm postları getir
  Future<void> fetchAllOrCategoryId() async {
    if (_isAllOrByCategory) {
      await fetchPostList();
    } else if (_selectedCategoryId != null) {
      await fetchPostListByCategoryId(_selectedCategoryId!);
    }
  }

  // Kategori değişimi
  void changeCategory(int? categoryId) {
    resetPagination();
    _isAllOrByCategory = categoryId == null;
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  // Yeni post butonunu göster/gizle
  void changeShowNewPostBtn() {
    _showNewPostBtn = !_showNewPostBtn;
    notifyListeners();
  }
}
