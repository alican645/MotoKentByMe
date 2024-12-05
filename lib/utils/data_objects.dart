
class DataObjects{
  DataObjects._();
  static Object joinGroup(String groupId,String userId){
    var object={

        "groupId": groupId,
        "userId": userId

    };
    return object;
  }

  static Object getUserChatGroups(String userId){
    var object={
      "userId": userId
    };
    return object;
  }
}