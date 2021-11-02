import 'package:ccs_sis/helper/google_signin.dart';
import 'package:ccs_sis/views/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  /// initialize firebase
  ///
  /// You must setup your app to firebase first in order to
  /// utilize the firebase packages
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSingInProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Meet Up',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Home(),
      ),
    );
  }
}
