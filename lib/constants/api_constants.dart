class ApiConstants {
  static const String baseUrl = 'http://10.0.2.2:8080';
  //static const String baseUrl = 'http://192.168.2.78:8080';


  static const String registerEndpoint = '$baseUrl/api/Auth/Register';
  static const String loginEndpoint = '$baseUrl/api/Auth/Login';
  static const String refreshTokenEndpoint = '$baseUrl/api/Auth/RefreshToken';
  static const String revokeEndpoint = '$baseUrl/api/Auth/Revoke';
  static const String revokeAllEndpoint = '$baseUrl/api/Auth/RevokeAll';


  static const String userProfileEndpoint = '$baseUrl/api/UserProfile/GetProfile';
  static const String updateProfileEndpoint = '$baseUrl/api/UserProfile/UpdateProfile';


  static const String getUserPhotosEndpoint = '$baseUrl/api/Photo/GetUserPhotos';
  static const String uploadPhotoEndpoint = '$baseUrl/api/Photo/UploadPhoto';

  static const String getAllPostCategories = '$baseUrl/api/PostCategory/GetCategories';
  static const String getAllPostCategoriesFormFile = '$baseUrl/api/PostCategory/GetCategoriesFormFile';

  static const String addPost = '$baseUrl/api/Post/AddPost';
  static const String getAllPost = '$baseUrl/api/Post/GetAllPost';
  static const String getPaginatedPosts = '$baseUrl/api/Post/GetPaginatedPosts?page=';
  static String getPaginatedPostsByCategoryId (int page,int categoryId){
    return '$baseUrl/api/Post/GetPaginatedPostsByCategoryId?page=$page&categoryId=$categoryId';
  }



  static const String signalRExploreHubEndpoint = '$baseUrl/exploreHub';
  static const String signalRChatGroupEndpoint = '$baseUrl/chatGroupHub';


  static const String createChatGroup = '$baseUrl/api/ChatGroup/CreateChatGroup';
  static const String getAllChatGroups = '$baseUrl/api/ChatGroup/GetAllChatGroups';
  static const String joinChatGroups = '$baseUrl/api/ChatGroup/JoinGroup';
}
