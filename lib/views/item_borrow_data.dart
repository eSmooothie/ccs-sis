// ignore_for_file: avoid_print

import 'package:ccs_sis/models/borrowItemModel.dart';
import 'package:ccs_sis/models/newItemModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BorrowItemData extends StatefulWidget {
  const BorrowItemData({
    Key? key,
    required this.itemId,
  }) : super(key: key);
  final String itemId;

  @override
  _BorrowItemDataState createState() => _BorrowItemDataState();
}

class _BorrowItemDataState extends State<BorrowItemData> {
  late String itemCode;
  late TextEditingController _borrowedBy;
  late TextEditingController _location;
  late TextEditingController _reason;

  User? user = FirebaseAuth.instance.currentUser;
  String? _borrowedErr;
  String? _locationErr;
  String? _reasonErr;

  String checkType = "daily";

  @override
  void initState() {
    itemCode = widget.itemId;
    _borrowedBy = TextEditingController();
    _location = TextEditingController();
    _reason = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 5,
              child: Text(
                itemCode,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24.0,
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: TextFormField(
                controller: _borrowedBy,
                autofocus: false,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  label: const Text("Borrowed by"),
                  errorText: _borrowedErr,
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: TextFormField(
                controller: _location,
                autofocus: false,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  label: const Text("Location"),
                  errorText: _locationErr,
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: TextFormField(
                controller: _reason,
                autofocus: false,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  label: const Text("Reason"),
                  errorText: _reasonErr,
                ),
              ),
            ),
            Flexible(
              flex: 5,
              child: OutlinedButton(
                onPressed: () async {
                  // validate

                  setState(() {
                    _borrowedErr =
                        (_borrowedBy.text.isEmpty) ? "Required" : null;
                    _locationErr = (_location.text.isEmpty) ? "Required" : null;
                    _reasonErr = (_reason.text.isEmpty) ? "Required" : null;
                  });
                  print("Item: $itemCode");
                  NewItemModel checkItemModel = NewItemModel();

                  Item? checkItemExistance =
                      await checkItemModel.getById(itemCode);

                  if ((_borrowedErr == null ||
                          _locationErr == null ||
                          _reasonErr == null) &&
                      checkItemExistance == null) {
                    // display error
                    await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Item does not exist"),
                            content: Text("ID: $itemCode"),
                          );
                        });
                  } else if (_borrowedErr == null &&
                      _locationErr == null &&
                      _reasonErr == null) {
                    DateTime date = DateTime.now();

                    BorrowItem item = BorrowItem(
                      date: date.toString(),
                      itemId: itemCode,
                      borrwedBy: _borrowedBy.text,
                      location: _location.text,
                      reason: _reason.text,
                      scanBy: user!.displayName,
                    );

                    BorrowItemModel model = BorrowItemModel();
                    model.insert(item);

                    await showDialog(
                        context: context,
                        builder: (context) {
                          return const AlertDialog(
                            title: Text("Success"),
                          );
                        });

                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  "Save",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  fixedSize: const Size(200, 75),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
