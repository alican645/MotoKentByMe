class ApiConstants {
  //static const String baseUrl = 'http://10.0.2.2:8080';
  static const String baseUrl =
      'https://www.friendly-vaughan.104-247-167-18.plesk.page';
  //static const String baseUrl = 'http://192.168.2.78:8080';

  static const String registerEndpoint = '$baseUrl/api/Auth/Register';
  static const String loginEndpoint = '$baseUrl/api/Auth/Login';
  static const String refreshTokenEndpoint = '$baseUrl/api/Auth/RefreshToken';
  static const String revokeEndpoint = '$baseUrl/api/Auth/Revoke';
  static const String revokeAllEndpoint = '$baseUrl/api/Auth/RevokeAll';
  static const String changePassword = '$baseUrl/api/Auth/ChangePassword';
  static const String changeEmail = '$baseUrl/api/Auth/ChangeEmail';

  static String getMyProfile(String user) {
    return "$baseUrl/api/UserProfile/GetMyProfile?userId=$user";
  }

  static String getMyEditableProfileData(String user) {
    return "$baseUrl/api/UserProfile/GetMyEditableProfileData?userId=$user";
  }

  static String getProfile(String targetUser, String user) {
    return '$baseUrl/api/UserProfile/GetProfile?targetUserId=$targetUser&userId=$user';
  }

  static String getUserConnections(String userId) {
    return '$baseUrl/api/UserProfile/GetUserConnections?userId=$userId';
  }

  static const String followEndpoint = '$baseUrl/api/UserProfile/Follow';
  static const String unfollowEndpoint = '$baseUrl/api/UserProfile/Unfollow';
  static const String userFollowerRelationshipEndPoint =
      '$baseUrl/api/UserProfile/UserFollowerRelationship';
  static const String updateProfileEndpoint =
      '$baseUrl/api/UserProfile/UpdateProfile';
  static const String addDeviceTokenToUser =
      '$baseUrl/api/UserProfile/AddDeviceTokenToUser';
  static String searchUserProfiles(String parameter, String userId) {
    return '$baseUrl/api/UserProfile/SearchUserProfile?searchParameter=$parameter&searcherUserId=$userId';
  }

  static String searchChatGroups(String parameter, String userId) {
    return '$baseUrl/api/ChatGroup/SearchChatGroup?parameter=$parameter&userId=$userId';
  }

  static const String getUserPhotosEndpoint =
      '$baseUrl/api/Photo/GetUserPhotos';
  static const String uploadPhotoEndpoint = '$baseUrl/api/Photo/UploadPhoto';

  static const String getAllPostCategories =
      '$baseUrl/api/PostCategory/GetCategories';
  static const String getAllPostCategoriesFormFile =
      '$baseUrl/api/PostCategory/GetCategoriesFormFile';

  static const String addPost = '$baseUrl/api/Post/AddPost';
  static const String votePost = '$baseUrl/api/Post/VotePost';
  static const String sharePost = '$baseUrl/api/SharedPost/SharePost';
  //static const String sharePost = '$baseUrl/api/Post/SharePost';
  static const String likePost = '$baseUrl/api/Post/LikePost';

  static const String getAbouts = '$baseUrl/api/Abouts/GetAboutTitles';

  static String getPaginatedComments(int postId, int page) {
    return '$baseUrl/api/Post/GetPaginatedComments?postId=$postId&page=$page';
  }

  static const String addPostComment = '$baseUrl/api/Post/AddPostComment';
  static const String quotePost = '$baseUrl/api/Post/QuotePost';
  static const String favoritePost = '$baseUrl/api/Post/FavoritePost';
  static const String getAllPost = '$baseUrl/api/Post/GetAllPost';

  static String getPaginatedPostsByPageSize(
      int page, int pageSize, String userId) {
    return '/api/Post/GetPaginatedPosts?pageSize=$pageSize&page=$page&userId=$userId';
  }

  static String getPaginatedPostsByCategory(
      {int? turkeyProvince, int? postCategoryEnum, int? page, int? pageSize}) {
    if (turkeyProvince != null && postCategoryEnum != null) {
      return '/api/Post/GetPaginatedPostsByCategory?illerEnum=$turkeyProvince&postCategoryEnum=$postCategoryEnum&pageSize=$pageSize&page=$page';
    }
    if (turkeyProvince != null) {
      return '/api/Post/GetPaginatedPostsByCategory?illerEnum=$turkeyProvince&pageSize=$pageSize&page=$page';
    }
    if (postCategoryEnum != null) {
      return '/api/Post/GetPaginatedPostsByCategory?postCategoryEnum=$postCategoryEnum&pageSize=$pageSize&page=$page';
    } else {
      return '/api/Post/GetPaginatedPostsByCategory?pageSize=$pageSize&page=$page';
    }
  }

  static String getPaginatedPostsByCategoryId(int page, int categoryId) {
    return '$baseUrl/api/SharedPost/GetPaginatedPostsByCategoryId?page=$page&categoryId=$categoryId';
  }

  static String getPaginatedFavoritePostsByUserId(
      int pageSize, int page, String userId) {
    return '/api/Post/GetPaginatedFavoritePostsByUserId?userId=$userId&page=$page&pageSize=$pageSize';
  }

  static String getPaginatedPostUserId(int pageSize, int page, String userId) {
    return '/api/Post/GetPaginatedPostUserId?userId=$userId&page=$page&pageSize=$pageSize';
  }

  static String getPostByPostId(int postId, String userId) {
    return '$baseUrl/api/Post/GetPostByPostId?id=$postId&userId=$userId';
  }

  static String GetPaginatedPostsByCategoryId(int page, int categoryId) {
    return '$baseUrl/api/SharedPost/GetPaginatedPostsByCategoryId?page=$page&categoryId=$categoryId';
  }

  static const String signalRExploreHubEndpoint = '$baseUrl/exploreHub';
  static const String signalRChatGroupEndpoint = '$baseUrl/chatHub';
  static const String signalRPrivateConversationHub =
      '$baseUrl/privateConversationHub';
  static const String signalRLocationHubEndpoint = '$baseUrl/locationHub';

  static const String createChatGroup =
      '$baseUrl/api/ChatGroup/CreateChatGroup';
  //static const String getAllChatGroups = '$baseUrl/api/ChatGroup/GetAllChatGroups';
  static String getUserChatGroups(String userId) {
    return '$baseUrl/api/ChatGroup/GetUserChatGroups?userId=$userId';
  }

  static String getUserChatGroups2(String userId) {
    return '$baseUrl/api/ChatGroup/GetUserChatGroups2?userId=$userId';
  }

  static String getAllChatGroups(String userId) {
    return '$baseUrl/api/ChatGroup/GetAllChatGroups?userId=$userId';
  }

  static getChatGroupByGroupId(int grupId, String userId) {
    return '$baseUrl/api/ChatGroup/GetChatGroupByGroupId?groupId=$grupId&userId=$userId';
  }

  static const String leaveChatGroup = '$baseUrl/api/ChatGroup/LeaveGroup';
  static const String removeUser = '$baseUrl/api/ChatGroup/RemoveUser';
  static const String senMessageChatGroups =
      '$baseUrl/api/ChatGroup/SendMessageGroup';
  static String getMessagesChatGroup(int groupId, String userId) {
    return '$baseUrl/api/ChatGroup/GetGroupMessagesByGroupId?groupId=$groupId&userId=$userId';
  }

  static String getPaginatedGroupMessagesByGrouId(int groupId, String userId) {
    return '$baseUrl/api/ChatGroup/api/ChatGroup/GetPaginatedGroupMessagesByGrouId?groupId=$groupId&userId=$userId';
  }

  static String getPrivateMessagesByPrivateConversationId(
      String user1, String user2) {
    return '$baseUrl/api/PrivateConversation/GetPrivateMessagesByPrivateConversationId?user1Id=$user1&user2Id=$user2';
  }

  static String getMyPrivateConversationByUserId(String user) {
    return '$baseUrl/api/PrivateConversation/GetMyPrivateConversationByUserId?userId=$user';
  }

  static const String groupJoinRequest =
      '$baseUrl/api/JoinGroupRequest/GroupJoinRequest';
  static const String acceptGroupJoinRequest =
      '$baseUrl/api/JoinGroupRequest/AcceptGroupJoinRequest';
  static String getAllJoinRequestByGroupId(int chatGroupUniqueId) {
    return '$baseUrl/api/JoinGroupRequest/GetAllJoinRequestByGroupId?chatGroupId=$chatGroupUniqueId';
  }

  static String getAllJoinRequestByAdminId(String userId) {
    return '$baseUrl/api/JoinGroupRequest/GetAllJoinRequestByAdminId?adminId=$userId';
  }

  static String getAllNotificationByAdminId(String userId) {
    return '$baseUrl/api/JoinGroupRequest/GetAllNotification?adminId=$userId';
  }

  static const String operationDone =
      '$baseUrl/api/Notifications/OperationDone';
  static const String createUserRating =
      '$baseUrl/api/UserRatings/CreateUserRating';

  static String getCustomMarkerItem(String userId) =>
      '$baseUrl/api/CustomLocationIcon/GetCustomLocationIcons?userId=$userId';

  static const String getAllLocations = '$baseUrl/api/Location/GetAllLocations';

  static String getAllLocationsByCategoryId(int categoryId) {
    return '$baseUrl/api/Location/GetAllLocationsByCategoryId?categoryId=$categoryId';
  }

  static const String addLocation = '$baseUrl/api/Location/AddLocation';
  static const String resetMap = '$baseUrl/api/Location/ResetMap';
  static const String addUserLastLocation =
      '$baseUrl/api/Location/AddUserLastLocation';
  static const String getNearbyUsers = '$baseUrl/api/Location/GetNearbyUsers';

  static const String sendCallForHelp =
      '$baseUrl/api/CallForHelp/SendCallForHelp';

  static String getAllLocations2(String userId, double minLat, double minLng,
      double maxLat, double maxLng) {
    return "${ApiConstants.getAllLocations}?userId=$userId&minLat=$minLat&minLng$minLng=&maxLat=$maxLat&maxLng=$maxLng";
  }

  static String getAppMarkerIconTokenByUserId(String userId) {
    return '$baseUrl/api/AppMarkerIconToken/GetAppMarkerIconTokenByUserId?userId=$userId';
  }

  //
  static const String createAppMarkerIconToken =
      '$baseUrl/api/AppMarkerIconToken/CreateAppMarkerIconToken';
  static const String getAppMarkerCoinPriceAndCountList =
      '$baseUrl/api/AppMarkerIconToken/GetAppMarkerCoinPriceAndCountList';
  static const String addAppMarkerCoinPriceAndCount =
      '$baseUrl/api/AppMarkerIconToken/AddAppMarkerCoinPriceAndCount';
  static const String createPrivateConversation =
      '$baseUrl/api/PrivateConversation/CreateOrFecthPrivateConversation';
  static const String sendMessageToUser =
      '$baseUrl/api/PrivateConversation/SendMessageToUser';

  static const String getAllComplaintReasons =
      "$baseUrl/api/Complaint/GetAllComplaintReasons";
  static const String addComplaint = "$baseUrl/api/Complaint/AddComplaint";
  static const String addComplaintChatGroup =
      "$baseUrl/api/Complaint/AddComplaintChatGroup";

  static const String getAllCurrentBanner =
      "$baseUrl/api/Banner/GetAllCurrentBanner";
}
//