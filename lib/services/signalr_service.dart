import 'package:flutter/cupertino.dart';
import 'package:moto_kent/constants/api_constants.dart';
import 'package:moto_kent/pages/ExploreModule/ExplorePage/explore_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:signalr_netcore/signalr_client.dart';

class SignalRService {
  late HubConnection _connection;
  final BuildContext context;

  SignalRService(this.context);

  /// Gelen veriyi işlemek için bir callback
  VoidCallback? onReceivePost;



  Future<void> initializeSignalR() async {
    _connection = HubConnectionBuilder()
        .withUrl(ApiConstants.signalRExploreHubEndpoint) // Sunucu URL'sini değiştirin
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
    _connection.on("ReceivePost", (arguments)  {
      if (arguments != null && arguments.isNotEmpty) {

         context.read<ExploreViewmodel>().showNewPostBtnFun();
      }
    });

    try {
      await _connection.start();
      debugPrint("SignalR bağlantısı başarılı.");
    } catch (e) {
      debugPrint("SignalR bağlantı hatası: $e");
    }
  }


  void dispose() {
    _connection.stop();
  }
}
