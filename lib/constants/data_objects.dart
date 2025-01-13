
class DataObjects{
  DataObjects._();
  static Object joinGroup(String groupId,String userId){
    var object={

        "groupId": groupId,
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
  static Object quotePost(int postId,String userId){
    var object={
      "quotedPostId": postId,
      "userId": userId
    };
    return object;
  }


}