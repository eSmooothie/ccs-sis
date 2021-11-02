// ignore_for_file: avoid_print

import 'package:ccs_sis/views/scan_borrow_item.dart';
import 'package:ccs_sis/views/scan_update_status_item.dart';
import 'package:flutter/material.dart';

class UpdateItem extends StatelessWidget {
  const UpdateItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
          ),
          OutlinedButton(
            onPressed: () {
              print("Borrow Item");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ScanBorrowItem(),
                ),
              );
            },
            child: const Text(
              "Borrow Item",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            style: OutlinedButton.styleFrom(
              fixedSize: const Size(200, 75),
              side: const BorderSide(color: Colors.black),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          OutlinedButton(
            onPressed: () {
              print("Update Item Status");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const UpdateStatusItem(),
                ),
              );
            },
            child: const Text(
              "Update Item Status",
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
    );
  }
}
