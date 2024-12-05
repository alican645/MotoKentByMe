

import 'package:flutter/cupertino.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/models/chat_group_model.dart';
import 'package:moto_kent/pages/ExplorePage/explore_viewmodel.dart';
import 'package:moto_kent/pages/GroupsPage/groups_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:signalr_netcore/signalr_client.dart';


class SignalRService2 {
  late HubConnection _connection;
  final BuildContext context;

  SignalRService2(this.context);

  /// Gelen veriyi işlemek için bir callback
  VoidCallback? onReceivePost;



  Future<void> initializeSignalR() async {
    _connection = HubConnectionBuilder()
        .withUrl(ApiConstants.signalRChatGroupEndpoint) // Sunucu URL'sini değiştirin
        .build();

    // Bağlantı kapandığında çağrılacak geri çağırım
    _connection.onclose(({Exception? error}) {
      if (error != null) {
        print("SignalR bağlantısı kapandı: ${error.toString()}");
      } else {
        print("SignalR bağlantısı kapandı.");
      }
    });

    // Gelen post verisini dinle
    _connection.on("ChatGroup", (arguments) async  {
      if (arguments != null && arguments.isNotEmpty) {
        // final Map<String, dynamic> postJson =
        // arguments[0] as Map<String, dynamic>;
        // final post = ChatGroupModel.fromJson(postJson);
        // print("Post Alındı: ");
        await context.read<ChatGroupsViewmodel>().fetchChatGropsList();
      }
    });

    try {
      await _connection.start();
      print("SignalR bağlantısı başarılı.");
    } catch (e) {
      print("SignalR bağlantı hatası: $e");
    }
  }

  // /// SignalR hub'a PostModel nesnesi gönder
  // Future<void> sendPost(PostModel post) async {
  //   if (_connection.state == HubConnectionState.Connected) {
  //     try {
  //       await _connection.invoke("SendPost", args: [post.toJson()]);
  //       print("Post gönderildi: ${post.postContentTitle}");
  //     } catch (e) {
  //       print("Post gönderme hatası: $e");
  //     }
  //   } else {
  //     print("SignalR bağlantısı aktif değil.");
  //   }
  // }

  void dispose() {
    _connection.stop();
  }
}