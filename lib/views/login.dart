import 'package:ccs_sis/helper/google_signin.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 1,
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
          const SizedBox(
            height: 160,
          ),
          Flexible(
            flex: 5,
            child: Container(
              child: OutlinedButton.icon(
                onPressed: () {
                  final provider =
                      Provider.of<GoogleSingInProvider>(context, listen: false);
                  provider.googleLogin();
                },
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(18.0),
                    fixedSize: const Size(250, 75)),
                icon: const Icon(
                  FontAwesomeIcons.google,
                  color: Colors.red,
                ),
                label: const Text("Continue with Google"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
