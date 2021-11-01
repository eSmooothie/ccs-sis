import 'package:ccs_sis/helper/google_signin.dart';
import 'package:ccs_sis/views/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong!"),
            );
          } else if (snapshot.hasData) {
            return const MainPage();
          } else {
            return const Login();
          }
        });
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(user!.photoURL!),
            ),
            Container(
              margin: EdgeInsets.only(left: 15.0),
              child: Text("${user.displayName}"),
            ),
          ],
        ),
        leadingWidth: 200,
        actions: [
          IconButton(
            onPressed: () {
              final provider =
                  Provider.of<GoogleSingInProvider>(context, listen: false);
              provider.googleLogout();
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Text(
                    "CCS",
                    style: TextStyle(
                      fontSize: 64.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text("SIMPLE INVENTORY SYSTEM"),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 40.0,
          ),
          Expanded(
            flex: 2,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      print("Check Item");
                    },
                    child: const Text(
                      "Check Item",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      fixedSize: const Size(200, 75),
                      side: const BorderSide(color: Colors.black),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      print("Update Item");
                    },
                    child: const Text(
                      "Update Item",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      fixedSize: const Size(200, 75),
                      side: const BorderSide(color: Colors.black),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      print("Maintenance");
                    },
                    child: const Text(
                      "Maintenance",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      fixedSize: const Size(200, 75),
                      side: const BorderSide(color: Colors.black),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      print("Scan new item");
                    },
                    child: const Text(
                      "Scan new item",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      fixedSize: const Size(200, 75),
                      side: const BorderSide(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
