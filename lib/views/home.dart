// ignore_for_file: avoid_print

import 'package:ccs_sis/helper/google_signin.dart';
import 'package:ccs_sis/views/item_check.dart';
import 'package:ccs_sis/views/item_update.dart';
import 'package:ccs_sis/views/login.dart';
import 'package:ccs_sis/views/maintenance.dart';
import 'package:ccs_sis/views/new_item.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

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
        leading: Container(
          padding: const EdgeInsets.all(5.0),
          child: CircleAvatar(
            radius: 15,
            backgroundImage: NetworkImage(user!.photoURL!),
          ),
        ),
        title: Text(
          "${user.displayName}",
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              final provider =
                  Provider.of<GoogleSingInProvider>(context, listen: false);
              provider.googleLogout();
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
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
          const SizedBox(
            height: 40.0,
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () {
                    print("Check Item");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ItemCheck(),
                      ),
                    );
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UpdateItem(),
                      ),
                    );
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Maintenance(),
                      ),
                    );
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NewItem(),
                      ),
                    );
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
        ],
      ),
    );
  }
}
