
class DataObjects{
  DataObjects._();
  static Object joinGroup(int groupId,String userId){
    var object={

        "chatGroupId": groupId,
        "userId": userId

    };
    return object;
  }

    static Object groupJoinRequest(int groupId,String userId){
    var object={

        "chatGroupId": groupId,
        "userId": userId

    };
    return object;
  }

  static Object likePost(int postId,String userId,bool isLike){
    var object={
      "postId": postId,
      "userId": userId,
      "isLike": isLike
    };
    return object;
  }
  static Object favoritePost(int postId,String userId){
    var object={
      "postId": postId,
      "userId": userId
    };
    return object;
  }
  static Object onlyUserIdObject(String userId){
    var object={
      "userId": userId
    };
    return object;
  }
  static Object privateConversationObject(String userId1,String userId2){
    var object={
      "user1Id": userId1,
      "user2Id": userId2
    };
    return object;
  }


}