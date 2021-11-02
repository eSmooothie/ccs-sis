// ignore_for_file: file_names

import 'package:ccs_sis/helper/gsheet_info.dart';
import 'package:gsheets/gsheets.dart';

class NewItemModel extends GoogleSheet {
  // ignore: unused_field
  late Worksheet? _worksheet;
  late GSheets _gSheet;
  late Spreadsheet _spreadsheet;

  @override
  Future<void> init() async {
    _gSheet = GSheets(credentials);
    _spreadsheet = await _gSheet.spreadsheet(spreadSheetId);

    _worksheet = _spreadsheet.worksheetByTitle('ITEM_LIST');
  }

  // get all
  Future<List<Item>> getAllItems() async {
    await init();
    final items = await _worksheet!.values.map.allRows(fromRow: 2);

    return items!.map((json) => Item.fromGsheets(json)).toList();
  }

  // get by id
  Future<Item?> getById(String id) async {
    await init();
    final map = await _worksheet!.values.map.rowByKey(
      id,
      fromColumn: 1,
    );

    return map == null ? null : Item.fromGsheets(map);
  }

  // update
  Future<bool> updateData({
    required String id,
    required String columnKey,
    required String value,
    bool eager = false,
  }) async {
    await init();
    return _worksheet!.values.insertValueByKeys(
      value,
      columnKey: columnKey,
      rowKey: id,
      eager: eager,
    );
  }

  // insert
  Future<bool> insert(Item item) async {
    await init();
    return _worksheet!.values.map.insertRowByKey(
      item.code,
      item.toGsheets(),
      appendMissing: true,
    );
  }

  Future<bool> deleteById(String id) async {
    await init();
    final index = await _worksheet!.values.rowIndexOf(id);
    if (index > 0) {
      return _worksheet!.deleteRow(index);
    }
    return false;
  }

  Future<bool> delete(Item item) => deleteById(item.code);
}

class Item {
  final String code;
  final String desc;
  final String mre;
  final String location;
  final String? scanBy;
  final String date;

  Item({
    required this.code,
    required this.desc,
    required this.mre,
    required this.location,
    required this.scanBy,
    required this.date,
  });

  factory Item.fromGsheets(Map<String, dynamic> json) {
    return Item(
      code: json['ITEM_ID'],
      desc: json['DESCRIPTION'],
      mre: json['MRE'],
      location: json['LOCATION'],
      scanBy: json['SCAN_BY'],
      date: json['DATE'],
    );
  }

  Map<String, dynamic> toGsheets() {
    return {
      'ITEM_ID': code,
      'DESCRIPTION': desc,
      'MRE': mre,
      'LOCATION': location,
      'SCAN_BY': scanBy,
      'DATE': date,
    };
  }

  @override
  String toString() =>
      'Product{code: $code, desc: $desc, mre: $mre, location: $location, scan by: $scanBy, date: $date}';
}
