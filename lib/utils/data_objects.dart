
class DataObjects{
  DataObjects._();
  static Object joinGroup(String groupId,String userId){
    var object={

        "groupId": groupId,
        "userId": userId

    };
    return object;
  }
}