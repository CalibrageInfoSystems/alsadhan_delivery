import 'package:alsadhan_delivery_agent/Notification/allNotificationScreen.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'NavigationService.dart';

GetIt locator=GetIt.instance;

void setupLocator(){
  locator.registerLazySingleton(()=>NavigationService());
  locator.registerLazySingleton(()=>NotificationScreen());
}
