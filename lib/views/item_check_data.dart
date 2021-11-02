import 'package:ccs_sis/models/checkItemModel.dart';
import 'package:ccs_sis/models/newItemModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CheckItemData extends StatefulWidget {
  const CheckItemData({
    Key? key,
    required this.itemId,
  }) : super(key: key);
  final String itemId;

  @override
  _CheckItemDataState createState() => _CheckItemDataState();
}

class _CheckItemDataState extends State<CheckItemData> {
  late String itemCode;
  late TextEditingController _status;

  User? user = FirebaseAuth.instance.currentUser;
  String? _statusErr;

  String checkType = "daily";

  @override
  void initState() {
    itemCode = widget.itemId;
    _status = TextEditingController();

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
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.all(10.0),
                child: DropdownButton(
                    value: checkType,
                    isExpanded: true,
                    hint: const Text("Type"),
                    icon: const Icon(FontAwesomeIcons.angleDown),
                    underline: Container(
                      color: Colors.transparent,
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        checkType = value!;
                      });
                    },
                    items: const <DropdownMenuItem<String>>[
                      DropdownMenuItem(
                        child: Text("Daily"),
                        value: "daily",
                      ),
                      DropdownMenuItem(
                        child: Text("Monthly"),
                        value: "sonthly",
                      ),
                      DropdownMenuItem(
                        child: Text("Semestral"),
                        value: "semestral",
                      ),
                    ]),
              ),
            ),
            Flexible(
              flex: 5,
              child: OutlinedButton(
                onPressed: () async {
                  // validate

                  setState(() {
                    _statusErr = (_status.text.isEmpty) ? "Required" : null;
                  });
                  // ignore: avoid_print
                  print("Item: $itemCode");
                  NewItemModel checkItemModel = NewItemModel();

                  Item? checkItemExistance =
                      await checkItemModel.getById(itemCode);

                  if (_statusErr == null && checkItemExistance == null) {
                    // display error
                    await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Item does not exist"),
                            content: Text("ID: $itemCode"),
                          );
                        });
                  } else if (_statusErr == null) {
                    DateTime date = DateTime.now();

                    CheckItem item = CheckItem(
                      date: date.toString(),
                      itemId: itemCode,
                      status: _status.text,
                      scanBy: user!.displayName,
                      checkType: checkType,
                    );

                    CheckItemModel model = CheckItemModel();
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
