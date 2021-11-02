// ignore_for_file: file_names

import 'package:ccs_sis/helper/gsheet_info.dart';
import 'package:gsheets/gsheets.dart';

class MaintenanceModel extends GoogleSheet {
  // ignore: unused_field
  late Worksheet? _worksheet;
  late GSheets _gSheet;
  late Spreadsheet _spreadsheet;

  @override
  Future<void> init() async {
    _gSheet = GSheets(credentials);
    _spreadsheet = await _gSheet.spreadsheet(spreadSheetId);

    _worksheet = _spreadsheet.worksheetByTitle('MAINTENANCE');
  }

  // get all
  Future<List<MaintenanceItem>> getAllItems() async {
    await init();
    final items = await _worksheet!.values.map.allRows(fromRow: 2);

    return items!.map((json) => MaintenanceItem.fromGsheets(json)).toList();
  }

  // get by id
  Future<MaintenanceItem?> getById(String id) async {
    await init();
    final map = await _worksheet!.values.map.rowByKey(
      id,
      fromColumn: 1,
    );

    return map == null ? null : MaintenanceItem.fromGsheets(map);
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
  Future<bool> insert(MaintenanceItem item) async {
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

  Future<bool> delete(MaintenanceItem item) => deleteById(item.date);
}

class MaintenanceItem {
  final String date;
  final String itemId;
  final String diagnose;
  final String status;
  final String repairedBy;
  final String? scanBy;

  MaintenanceItem({
    required this.date,
    required this.itemId,
    required this.diagnose,
    required this.status,
    required this.repairedBy,
    required this.scanBy,
  });

  factory MaintenanceItem.fromGsheets(Map<String, dynamic> json) {
    return MaintenanceItem(
        date: json['DATE'],
        itemId: json['ITEM_ID'],
        diagnose: json['DIAGNOSE'],
        status: json['STATUS'],
        repairedBy: json['REPAIRED_BY'],
        scanBy: json['SCAN_BY']);
  }

  Map<String, dynamic> toGsheets() {
    return {
      'DATE': date,
      'ITEM_ID': itemId,
      'DIAGNOSE': diagnose,
      'STATUS': status,
      'REPAIRED_BY': repairedBy,
      'SCAN_BY': scanBy
    };
  }

  @override
  String toString() =>
      'Product{date: $date, item: $itemId, diagnose: $diagnose, status: $status, repaired by: $repairedBy, scan by: $scanBy}';
}
