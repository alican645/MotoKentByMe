class ApiConstants {
  static const String baseUrl = 'http://10.0.2.2:8080';
  //static const String baseUrl = 'https://www.friendly-vaughan.104-247-167-18.plesk.page';
  //static const String baseUrl = 'http://192.168.2.78:8080';


  static const String registerEndpoint = '$baseUrl/api/Auth/Register';
  static const String loginEndpoint = '$baseUrl/api/Auth/Login';
  static const String refreshTokenEndpoint = '$baseUrl/api/Auth/RefreshToken';
  static const String revokeEndpoint = '$baseUrl/api/Auth/Revoke';
  static const String revokeAllEndpoint = '$baseUrl/api/Auth/RevokeAll';


  static const String userProfileEndpoint = '$baseUrl/api/UserProfile/GetProfile';
  static const String followEndpoint = '$baseUrl/api/UserProfile/Follow';
  static const String unfollowEndpoint = '$baseUrl/api/UserProfile/Unfollow';
  static const String userFollowerRelationshipEndPoint = '$baseUrl/api/UserProfile/UserFollowerRelationship';
  static const String updateProfileEndpoint = '$baseUrl/api/UserProfile/UpdateProfile';
  static const String addDeviceTokenToUser = '$baseUrl/api/UserProfile/AddDeviceTokenToUser';
  static String searchUserProfiles (String parameter,String userId) {
    return '$baseUrl/api/UserProfile/SearchUserProfile?searchParameter=$parameter&searcherUserId=$userId';
  }


  static const String getUserPhotosEndpoint = '$baseUrl/api/Photo/GetUserPhotos';
  static const String uploadPhotoEndpoint = '$baseUrl/api/Photo/UploadPhoto';

  static const String getAllPostCategories = '$baseUrl/api/PostCategory/GetCategories';
  static const String getAllPostCategoriesFormFile = '$baseUrl/api/PostCategory/GetCategoriesFormFile';

  static const String addPost = '$baseUrl/api/Post/AddPost';
  static const String likePost = '$baseUrl/api/Post/LikePost';
  static const String quotePost = '$baseUrl/api/Post/QuotePost';
  static const String getAllPost = '$baseUrl/api/Post/GetAllPost';
  static const String getPaginatedPosts = '$baseUrl/api/Post/GetPaginatedPosts?page=';
  static String getPaginatedPostsByPageSize(int page,int pageSize){
      return '/api/Post/GetPaginatedPosts?page=$page&pageSize=$pageSize';
  }
  static String getMyFavoritePosts(String userId){
      return '/api/Post/GetFavoritePostsByUserId?userId=$userId';
  }
  static String getPostByPostId(int postId){
      return '$baseUrl/api/Post/GetPostByPostId?id=$postId';
  }
  static String getPaginatedPostsByCategoryId (int page,int categoryId){
    return '$baseUrl/api/Post/GetPaginatedPostsByCategoryId?page=$page&categoryId=$categoryId';
  }


  static const String signalRExploreHubEndpoint = '$baseUrl/exploreHub';
  static const String signalRChatGroupEndpoint = '$baseUrl/chatHub';
  static const String signalRLocationHubEndpoint = '$baseUrl/locationHub';


  static const String createChatGroup = '$baseUrl/api/ChatGroup/CreateChatGroup';
  static const String getAllChatGroups = '$baseUrl/api/ChatGroup/GetAllChatGroups';
  static  String getUserChatGroups (String userId){
    return '$baseUrl/api/ChatGroup/GetUserChatGroups?userId=$userId';
  }
  static  getChatGroupByGroupId(String grupId){
    return '$baseUrl/api/ChatGroup/GetChatGroupByGroupId?groupId=$grupId';
  }

  static const String joinChatGroup = '$baseUrl/api/ChatGroup/JoinGroup';
  static const String leaveChatGroup = '$baseUrl/api/ChatGroup/LeaveGroup';
  static const String senMessageChatGroups = '$baseUrl/api/ChatGroup/SendMessageGroup';
  static  String getMessagesChatGroup (String groupId){
    return '$baseUrl/api/ChatGroup/GetGroupMessagesByGroupId?groupId=$groupId';
    ///api/ChatGroup/GetChatGroupByGroupId?groupId=7477f709-beed-48bf-b8ba-85f32fee0284
  }

  static const String getCustomMarkerItem = '$baseUrl/api/CustomLocationIcon/GetCustomLocationIcons';
  static const String getAllLocations = '$baseUrl/api/Location/GetAllLocations';
  static const String addLocation = '$baseUrl/api/Location/AddLocation';
  static const String addUserLastLocation = '$baseUrl/api/Location/AddUserLastLocation';
  static const String getNearbyUsers = '$baseUrl/api/Location/GetNearbyUsers';


  static const String sendCallForHelp='$baseUrl/api/CallForHelp/SendCallForHelp';



  static  String getAppMarkerIconTokenByUserId (String userId){
    return '$baseUrl/api/AppMarkerIconToken/GetAppMarkerIconTokenByUserId?userId=$userId';
  }
  static const String createAppMarkerIconToken='$baseUrl/api/AppMarkerIconToken/CreateAppMarkerIconToken';
}
//