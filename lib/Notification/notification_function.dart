import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:tagha_tailor/Views/services/server_key.dart';
import 'package:tagha_tailor/model/notification_model.dart';

class NotificationService {
  String userImage = "";

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late AndroidNotificationChannel channel;

  bool isFlutterLocalNotificationsInitialized = false;

  Future<void> setupFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    isFlutterLocalNotificationsInitialized = true;
  }

  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);
    await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveBackgroundNotificationResponse: (payload) {});
  }

  String generateRandomId() {
    final random = Random();
    final buffer = StringBuffer();

    for (int i = 0; i < 10; i++) {
      buffer.write(random.nextInt(10));
    }

    return buffer.toString();
  }

  Future<void> sendNotificationToMultipleUsers({
    required String type,
    required String id,
    required String message,
    required BuildContext context,
    required String image,
  }) async {
    try {
      // DocumentReference documentReference = FirebaseFirestore.instance.collection(
      //     "Users").doc(id);

      DocumentReference docreference =
          FirebaseFirestore.instance.collection("Users").doc(id);
      DocumentSnapshot docsnapshot = await docreference.get();

      if (docsnapshot.exists) {
        Map<String, dynamic>? data =
            docsnapshot.data() as Map<String, dynamic>?;

        String deviceToken = data?['deviceToken'] ?? " no  device token";
        String userIds = data?['id'] ?? "no id";
        String name = data?["name"] ?? "Fardeen";
        String randomId = generateRandomId();

        userImage = image;

        print(deviceToken);

        await sendNotification(
            type, randomId, context, deviceToken, message, name, image);
        await saveNotificationInUserDocument(
            userIds: userIds, messages: type, name: 'name');
      }
// Show success message and clear controllers
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Notifications sent successfully",
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          duration: Duration(seconds: 3),
        ),
      );

      // Clear controllers
      // bodyController.clear();
    } catch (e) {
      print('Error fetching device tokens: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${"Error:"} $e'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void firebaseInit(String image) {
    FirebaseMessaging.onMessage.listen((message) async {
      if (kDebugMode) {
        print(message.notification!.title.toString());
        print(message.notification!.body.toString());
      }
      await showNotification(message, image);
    });
  }

  Future<void> sendNotification(
      String type,
      String notificationId,
      BuildContext context,
      String deviceToken,
      String message,
      String name,
      String image) async {
    GetServerKey getServerKey = GetServerKey();
    String accessToken = await getServerKey.getServerKeyToken();

    const String projectID =
        'looktwice-22b74'; // Replace with your actual project ID
    final String serverKey = accessToken;
    var notificationData = {
      'message': {
        'token': deviceToken,
        'notification': {
          'title': name,
          'body': message,
          'image': image, // Add custom photo URL
        },
        'android': {
          'notification': {
            'notification_count': 23,
            'image': image, // Add custom photo URL for Android
          },
        },
        'apns': {
          'payload': {
            'aps': {
              'alert': {
                'title': name,
                'body': message,
              },
              'mutable-content': 1, // This enables the rich notification
            },
          },
          'fcm_options': {
            'image': image // Add custom photo URL for iOS
          },
        },
        'data': {
          'type': type,
          'id': notificationId,
        }
      }
    };
    try {
      await http.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/$projectID/messages:send'),
        body: jsonEncode(notificationData),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $serverKey'
        },
      ).then((value) {
        if (kDebugMode) {
          print(value.body.toString());
        }
      }).onError((error, stackTrace) {
        if (kDebugMode) {
          print(error);
        }
      });
    } catch (e) {
      print('Error sending notification: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Error sending notification: $e",
            style: TextStyle(color: Colors.white, fontSize: 12.sp),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> saveNotificationInUserDocument({
    required String userIds,
    required String messages,
    required String name,
  }) async {
    try {
      final notificationRef =
          FirebaseFirestore.instance.collection('Notification');
      // Create a document with the notificationId
      DocumentReference notificationDocRef =
          notificationRef.doc(userIds).collection("notification").doc();

      NotificationModel notification = NotificationModel(
        id: notificationDocRef.id, // Use the document ID as the unique ID
        title: name,
        body: messages,
        // Add other properties based on your model
      );

      await notificationDocRef.set(
        notification.toMap(),
      );
    } catch (e) {
      print('Error saving notification in user document: $e');
      // Handle the error accordingly
    }
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      print('Token refreshed: $event');
    });
  }

  Future<void> showNotification(RemoteMessage message, String imageUrl) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      message.notification?.android?.channelId ?? 'default_channel_id',
      message.notification?.android?.channelId ?? 'Default Channel',
      importance: Importance.max,
      showBadge: true,
      playSound: true,
    );

    // Validate and download the image
    ByteArrayAndroidBitmap? largeIcon;
    if (imageUrl.isNotEmpty &&
        Uri.tryParse(imageUrl)?.hasAbsolutePath == true) {
      try {
        final String largeIconPath =
            await _downloadAndSaveFile(imageUrl, 'largeIcon');
        largeIcon = await _fileToByteArrayAndroidBitmap(largeIconPath);
      } catch (e) {
        print('Error downloading image: $e');
      }
    } else {
      print('Invalid image URL: $imageUrl');
    }

    // Define the style information
    BigPictureStyleInformation? bigPictureStyleInformation;
    if (largeIcon != null) {
      bigPictureStyleInformation = BigPictureStyleInformation(
        largeIcon,
        largeIcon: largeIcon,
        contentTitle: message.notification?.title,
        summaryText: message.notification?.body,
      );
    }

    // Define Android notification details
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: 'your channel description',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      ticker: 'ticker',
      icon: '@mipmap/ic_launcher',
      styleInformation: bigPictureStyleInformation,
    );

    // Define iOS notification details
    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    // Create the notification details object
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    // Display the notification
    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title,
        message.notification?.body,
        notificationDetails,
      );
    });
  }

// Function to download and save the image file
  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return filePath;
    } else {
      throw Exception('Failed to download image');
    }
  }

// Function to convert a file to a ByteArrayAndroidBitmap
  Future<ByteArrayAndroidBitmap> _fileToByteArrayAndroidBitmap(
      String filePath) async {
    final File file = File(filePath);
    final bytes = await file.readAsBytes();
    final String base64String = base64Encode(bytes);
    return ByteArrayAndroidBitmap.fromBase64String(base64String);
  }

  // Future<void> showNotification(RemoteMessage message,String image) async {
  //   AndroidNotificationChannel channel = AndroidNotificationChannel(
  //     message.notification!.android!.channelId.toString(),
  //     message.notification!.android!.channelId.toString(),
  //     importance: Importance.max,
  //     showBadge: true,
  //     playSound: true,
  //   //  sound: const RawResourceAndroidNotificationSound('jetsons_doorbell')
  //   );
  //
  //   AndroidNotificationDetails androidNotificationDetails =
  //   AndroidNotificationDetails(
  //     channel.id.toString(), channel.name.toString(),
  //     channelDescription: 'your channel description',
  //     importance: Importance.high,
  //     priority: Priority.high,
  //     playSound: true,
  //     ticker: 'ticker',
  //        icon: '@mipmap/logo'
  //       // sound: channel.sound
  //      //  sound: RawResourceAndroidNotificationSound('jetsons_doorbell')
  //     //  icon: largeIconPath
  //   );
  //
  //   const DarwinNotificationDetails darwinNotificationDetails =
  //   DarwinNotificationDetails(
  //       presentAlert: true, presentBadge: true, presentSound: true);
  //
  //   NotificationDetails notificationDetails = NotificationDetails(
  //       android: androidNotificationDetails, iOS: darwinNotificationDetails);
  //
  //   Future.delayed(Duration.zero, () {
  //     _flutterLocalNotificationsPlugin.show(
  //       0,
  //       message.notification!.title.toString(),
  //       message.notification!.body.toString(),
  //       notificationDetails,
  //     );
  //   });
  // }
  Future forgroundMessage(String image) async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    firebaseInit(image);
  }

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('user granted permission');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('user granted provisional permission');
      }
    } else {
      //appsetting.AppSettings.openNotificationSettings();
      if (kDebugMode) {
        print('user denied permission');
      }
    }
  }
}
