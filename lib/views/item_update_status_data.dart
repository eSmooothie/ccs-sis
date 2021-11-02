// ignore_for_file: avoid_print

import 'package:ccs_sis/models/newItemModel.dart';
import 'package:ccs_sis/models/updateStatusItemModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpdateStatusItemData extends StatefulWidget {
  const UpdateStatusItemData({
    Key? key,
    required this.itemId,
  }) : super(key: key);
  final String itemId;

  @override
  _UpdateStatusItemDataState createState() => _UpdateStatusItemDataState();
}

class _UpdateStatusItemDataState extends State<UpdateStatusItemData> {
  late String itemCode;
  late TextEditingController _transferTo;
  late TextEditingController _newLocation;

  User? user = FirebaseAuth.instance.currentUser;
  String? _transferToErr;
  String? _newLocationErr;

  String checkType = "daily";

  @override
  void initState() {
    itemCode = widget.itemId;
    _transferTo = TextEditingController();
    _newLocation = TextEditingController();

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
                controller: _transferTo,
                autofocus: false,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  label: const Text("Transfer to"),
                  errorText: _transferToErr,
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: TextFormField(
                controller: _newLocation,
                autofocus: false,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  label: const Text("New Location"),
                  errorText: _newLocationErr,
                ),
              ),
            ),
            Flexible(
              flex: 5,
              child: OutlinedButton(
                onPressed: () async {
                  // validate

                  setState(() {
                    _transferToErr =
                        (_transferTo.text.isEmpty) ? "Required" : null;
                    _newLocationErr =
                        (_newLocation.text.isEmpty) ? "Required" : null;
                  });
                  print("Item: $itemCode");
                  NewItemModel checkItemModel = NewItemModel();

                  Item? checkItemExistance =
                      await checkItemModel.getById(itemCode);

                  if ((_transferToErr == null || _newLocationErr == null) &&
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
                  } else if (_transferToErr == null &&
                      _newLocationErr == null) {
                    DateTime date = DateTime.now();

                    UpdateStatusItem item = UpdateStatusItem(
                      date: date.toString(),
                      itemId: itemCode,
                      mre: checkItemExistance!.mre,
                      transferMRE: _transferTo.text,
                      location: _newLocation.text,
                      scanBy: user!.displayName,
                    );

                    UpdateStatusItemModel model = UpdateStatusItemModel();
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
