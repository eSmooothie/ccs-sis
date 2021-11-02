// ignore_for_file: file_names

import 'package:ccs_sis/helper/gsheet_info.dart';
import 'package:gsheets/gsheets.dart';

class CheckItemModel extends GoogleSheet {
  // ignore: unused_field
  late Worksheet? _worksheet;
  late GSheets _gSheet;
  late Spreadsheet _spreadsheet;

  Future<void> init() async {
    _gSheet = GSheets(credentials);
    _spreadsheet = await _gSheet.spreadsheet(spreadSheetId);

    _worksheet = _spreadsheet.worksheetByTitle('ITEM_CHECK');
  }

  // get all
  Future<List<CheckItem>> getAllItems() async {
    await init();
    final items = await _worksheet!.values.map.allRows(fromRow: 2);

    return items!.map((json) => CheckItem.fromGsheets(json)).toList();
  }

  // get by id
  Future<CheckItem?> getById(String id) async {
    await init();
    final map = await _worksheet!.values.map.rowByKey(
      id,
      fromColumn: 1,
    );

    return map == null ? null : CheckItem.fromGsheets(map);
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
  Future<bool> insert(CheckItem item) async {
    await init();
    return _worksheet!.values.map.insertRowByKey(
      item.date,
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

  Future<bool> delete(CheckItem item) => deleteById(item.date);
}

class CheckItem {
  final String date;
  final String itemId;
  final String status;
  final String? scanBy;
  final String checkType;

  CheckItem({
    required this.date,
    required this.itemId,
    required this.status,
    required this.scanBy,
    required this.checkType,
  });

  factory CheckItem.fromGsheets(Map<String, dynamic> json) {
    return CheckItem(
      date: json['DATE'],
      itemId: json['ITEM_ID'],
      status: json['STATUS'],
      scanBy: json['SCAN_BY'],
      checkType: json['TYPE'],
    );
  }

  Map<String, dynamic> toGsheets() {
    return {
      'DATE': date,
      'ITEM_ID': itemId,
      'STATUS': status,
      'SCAN_BY': scanBy,
      'TYPE': checkType,
    };
  }

  @override
  String toString() =>
      'Product{date: $date, item: $itemId, status: $status, scan by: $scanBy, type: $checkType}';
}
