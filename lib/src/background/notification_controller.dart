import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// This class controls the notifications.
///
/// It is a singleton, so that there is only one listener
class NotificationController {
  static NotificationController _controller;

  /// Get the controller, create if none exists.
  static NotificationController get controller {
    if (_controller == null) {
      _controller = NotificationController();
    }
    return _controller;
  }

  NotificationController() {
    _listen();
  }

  /// Begins listening to Firebase messages.
  ///
  /// This message is implicitly called whenever an instance of
  /// [NotificationController] is created. Awaits [Firebase.initializeApp] before
  /// listening to notifications.
  void _listen() async {
    await Firebase.initializeApp();

    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
            alert: true,
            announcement: false,
            badge: true,
            carPlay: false,
            // ?
            criticalAlert: false,
            provisional: false,
            sound: true);
    print('User granted permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }
}
