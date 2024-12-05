
import 'package:get_it/get_it.dart';
import 'package:moto_kent/services/api_service.dart';


final locator = GetIt.instance;

void setupLocator(){
  locator.registerLazySingleton<ApiService>(() => ApiService(),);

}