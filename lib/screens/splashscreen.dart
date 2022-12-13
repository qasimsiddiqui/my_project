import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:keto_app/screens/welcome_screen.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final _messaging;

  void registerNotification() async {
    _messaging = await FirebaseMessaging.instance;
    // 1. Instantiate Firebase Messaging
    final String? deviceToken = await _messaging.getToken();
    print(deviceToken);
    // 2. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print("message recieved");
        print(message.notification!.body);
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  // For handling notification when the app is in terminated state
  checkForInitialMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      print("message recieved");
      print(initialMessage.notification!.body);
      // For displaying the notification as an overlay

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    registerNotification();
    checkForInitialMessage();
    Future.delayed(Duration(seconds: 5)).then((value) => Navigator.push(
        context, MaterialPageRoute(builder: (context) => Welcome())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrangeAccent,
      body: Center(
        child: Container(
          height: 200,
          width: 200,
          child: LottieBuilder.asset('assets/animation/loading-animation.json'),
        ),
      ),
    );
  }
}
