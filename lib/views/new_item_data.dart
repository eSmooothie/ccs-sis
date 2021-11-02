// ignore_for_file: avoid_print

import 'package:ccs_sis/models/newItemModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NewItemData extends StatefulWidget {
  const NewItemData({
    Key? key,
    required this.itemId,
  }) : super(key: key);
  final String itemId;
  @override
  _NewItemDataState createState() => _NewItemDataState();
}

class _NewItemDataState extends State<NewItemData> {
  late String itemCode;
  late TextEditingController _desc;
  late TextEditingController _mre;
  late TextEditingController _loc;

  User? user = FirebaseAuth.instance.currentUser;
  String? _descErr;
  String? _mreErr;
  String? _locErr;
  @override
  void initState() {
    itemCode = widget.itemId;
    _desc = TextEditingController();
    _loc = TextEditingController();
    _mre = TextEditingController();
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
                controller: _desc,
                autofocus: false,
                decoration: InputDecoration(
                  icon: const Icon(
                    FontAwesomeIcons.scroll,
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  label: const Text("Description"),
                  errorText: _descErr,
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: TextField(
                controller: _mre,
                decoration: InputDecoration(
                  icon: const Icon(FontAwesomeIcons.userAlt),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  label: const Text("MRE"),
                  errorText: _mreErr,
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: TextField(
                controller: _loc,
                decoration: InputDecoration(
                  icon: const Icon(FontAwesomeIcons.mapMarkerAlt),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  label: const Text("Location"),
                  errorText: _locErr,
                ),
              ),
            ),
            Flexible(
              flex: 5,
              child: OutlinedButton(
                onPressed: () async {
                  // validate

                  setState(() {
                    _descErr = (_desc.text.isEmpty) ? "Required" : null;
                    _mreErr = (_mre.text.isEmpty) ? "Required" : null;
                    _locErr = (_loc.text.isEmpty) ? "Required" : null;
                  });

                  if (_descErr == null && _mreErr == null && _locErr == null) {
                    print("Item: $itemCode");
                    print("Desc: ${_desc.text}");
                    print("MRE: ${_mre.text}");
                    print("Loc: ${_loc.text}");
                    print("User: ${user!.displayName}");
                    DateTime date = DateTime.now();
                    NewItemModel newItemData = NewItemModel();
                    // send to gsheet
                    Item newItem = Item(
                        code: itemCode,
                        desc: _desc.text,
                        mre: _mre.text,
                        location: _loc.text,
                        scanBy: user!.displayName,
                        date: date.toString());

                    // print(newItem.toString());
                    newItemData.insert(newItem);

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
