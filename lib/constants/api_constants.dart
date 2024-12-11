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
  static String getPaginatedPostsByPageSize(int page,int pageSize){
      return '/api/Post/GetPaginatedPosts?page=$page&pageSize=$pageSize';
  }
  static String getPaginatedPostsByCategoryId (int page,int categoryId){
    return '$baseUrl/api/Post/GetPaginatedPostsByCategoryId?page=$page&categoryId=$categoryId';
  }


  static const String signalRExploreHubEndpoint = '$baseUrl/exploreHub';
  static const String signalRChatGroupEndpoint = '$baseUrl/chatHub';


  static const String createChatGroup = '$baseUrl/api/ChatGroup/CreateChatGroup';
  static const String getAllChatGroups = '$baseUrl/api/ChatGroup/GetAllChatGroups';
  static  String getUserChatGroups (String userId){
    return '$baseUrl/api/ChatGroup/GetUserChatGroups?userId=$userId';
  }
  static const String joinChatGroups = '$baseUrl/api/ChatGroup/JoinGroup';
  static const String senMessageChatGroups = '$baseUrl/api/ChatGroup/SendMessageGroup';
  static  String getMessagesChatGroup (String groupId){
    return '$baseUrl/api/ChatGroup/GetGroupMessagesByGroupId?groupId=$groupId';
  }

  static const String getCustomMarkerItem = '$baseUrl/api/CustomLocationIcon/GetCustomLocationIcons';


}
//