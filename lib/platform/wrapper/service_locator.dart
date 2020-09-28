import 'package:get_it/get_it.dart';
import 'package:seekyouapp/platform/wrapper/system_service.dart';

GetIt locator = GetIt();
void setupLocator() {
  locator.registerSingleton(TelAndSmsService());
}
