import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:tagha_tailor/Views/Auth/Signup.dart';
import 'package:tagha_tailor/firebase_options.dart';
import 'package:tagha_tailor/notification/notification_function.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Handle background message
  NotificationService().showNotification(message,
      "https://firebasestorage.googleapis.com/v0/b/ottawa-ee22e.appspot.com/o/profile_images%2Fprofile_dLWYREF4s3VLEx7KwDAAcc403MI3.jpg?alt=media&token=93fe5e1d-a5e1-47bd-a377-a5583d3ea057");
}

NotificationService notificationService = NotificationService();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initServices() async {
  await notificationService.setupFlutterNotifications();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  notificationService.requestNotificationPermission();
  notificationService.forgroundMessage(notificationService.userImage);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  await initServices();
  FirebaseMessaging.instance.getToken().then((token) {
    print("***********Device Token: $token");
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (BuildContext context, Widget? child) {
        return GetMaterialApp(
          title: 'App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.white,
            ),
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
            ),
            useMaterial3: true,
          ),
          home: const Signup(),
        );
      },
    );
  }
}
