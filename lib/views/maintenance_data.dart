// ignore_for_file: avoid_print

import 'package:ccs_sis/models/maintenanceModel.dart';
import 'package:ccs_sis/models/newItemModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MaintenanceData extends StatefulWidget {
  const MaintenanceData({
    Key? key,
    required this.itemId,
  }) : super(key: key);
  final String itemId;

  @override
  _MaintenanceDataState createState() => _MaintenanceDataState();
}

class _MaintenanceDataState extends State<MaintenanceData> {
  late String itemCode;
  late TextEditingController _diagnostic;
  late TextEditingController _status;
  late TextEditingController _repairedBy;

  User? user = FirebaseAuth.instance.currentUser;
  String? _diagnosticErr;
  String? _statusErr;
  String? _repairedByErr;

  String checkType = "daily";

  @override
  void initState() {
    itemCode = widget.itemId;
    _diagnostic = TextEditingController();
    _status = TextEditingController();
    _repairedBy = TextEditingController();

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
                controller: _diagnostic,
                autofocus: false,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  label: const Text("Diagnose"),
                  errorText: _diagnosticErr,
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: TextFormField(
                controller: _status,
                autofocus: false,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  label: const Text("Status"),
                  errorText: _statusErr,
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: TextFormField(
                controller: _repairedBy,
                autofocus: false,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  label: const Text("Repaired by"),
                  errorText: _repairedByErr,
                ),
              ),
            ),
            Flexible(
              flex: 5,
              child: OutlinedButton(
                onPressed: () async {
                  // validate

                  setState(() {
                    _diagnosticErr =
                        (_diagnostic.text.isEmpty) ? "Required" : null;
                    _statusErr = (_status.text.isEmpty) ? "Required" : null;
                    _repairedByErr =
                        (_repairedBy.text.isEmpty) ? "Required" : null;
                  });
                  print("Item: $itemCode");
                  NewItemModel checkItemModel = NewItemModel();

                  Item? checkItemExistance =
                      await checkItemModel.getById(itemCode);

                  if ((_diagnosticErr == null ||
                          _statusErr == null ||
                          _repairedByErr == null) &&
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
                  } else if (_diagnosticErr == null &&
                      _statusErr == null &&
                      _repairedByErr == null) {
                    DateTime date = DateTime.now();

                    MaintenanceItem item = MaintenanceItem(
                      date: date.toString(),
                      itemId: itemCode,
                      diagnose: _diagnostic.text,
                      status: _status.text,
                      repairedBy: _repairedBy.text,
                      scanBy: user!.displayName,
                    );

                    MaintenanceModel model = MaintenanceModel();

                    showDialog(
                        context: context,
                        builder: (context) {
                          return const AlertDialog(
                            title: Text("Saving"),
                          );
                        });

                    await model.insert(item);

                    await Future.delayed(
                      const Duration(seconds: 2),
                    );

                    Navigator.pop(context);

                    await showDialog(
                        context: context,
                        builder: (context) {
                          return const AlertDialog(
                            title: Text("Saved"),
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
