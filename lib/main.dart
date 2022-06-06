import 'package:flutter/material.dart';

import 'package:telephony/telephony.dart';

void main() {
  runApp(const MyApp());
}

onBackgroundMessage(SmsMessage message) {
  debugPrint("onBackgroundMessage called");
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMSAPP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'SMSAPP'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String body = "";
  List messages = [];
  final telephony = Telephony.instance;
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  onMessage(
    SmsMessage message,
  ) async {
    setState(() {
      body = message.body ?? "Error reading message body.";
      print("$body");
    });
  }

  Future<void> initPlatformState() async {
    final bool? result = await telephony.requestSmsPermissions;

    if (result != null && result) {
      telephony.listenIncomingSms(
        onNewMessage: onMessage,
        onBackgroundMessage: onBackgroundMessage,
        listenInBackground: true,
      );
    }

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
                color: Colors.blue,
                onPressed: () {},
                child: const Text("settings")),
            MaterialButton(
                color: Colors.blue,
                onPressed: () {
                  initPlatformState();
                },
                child: const Text("sync")),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void messageList() async {
    List<SmsMessage> messages = await telephony.getInboxSms(
      filter: SmsFilter.where(SmsColumn.ADDRESS).equals("MPESA"),
    );
    // print(SmsColumn.BODY);
  }
}
