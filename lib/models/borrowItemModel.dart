// ignore_for_file: file_names

import 'package:ccs_sis/helper/gsheet_info.dart';
import 'package:gsheets/gsheets.dart';

class BorrowItemModel extends GoogleSheet {
  // ignore: unused_field
  late Worksheet? _worksheet;
  late GSheets _gSheet;
  late Spreadsheet _spreadsheet;

  @override
  Future<void> init() async {
    _gSheet = GSheets(credentials);
    _spreadsheet = await _gSheet.spreadsheet(spreadSheetId);

    _worksheet = _spreadsheet.worksheetByTitle('ITEM_UPDATE_BORROW');
  }

  // get all
  Future<List<BorrowItem>> getAllItems() async {
    await init();
    final items = await _worksheet!.values.map.allRows(fromRow: 2);

    return items!.map((json) => BorrowItem.fromGsheets(json)).toList();
  }

  // get by id
  Future<BorrowItem?> getById(String id) async {
    await init();
    final map = await _worksheet!.values.map.rowByKey(
      id,
      fromColumn: 1,
    );

    return map == null ? null : BorrowItem.fromGsheets(map);
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
  Future<bool> insert(BorrowItem item) async {
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

  Future<bool> delete(BorrowItem item) => deleteById(item.date);
}

class BorrowItem {
  final String date;
  final String itemId;
  final String borrwedBy;
  final String location;
  final String reason;
  final String? scanBy;

  BorrowItem({
    required this.date,
    required this.itemId,
    required this.borrwedBy,
    required this.location,
    required this.reason,
    required this.scanBy,
  });

  factory BorrowItem.fromGsheets(Map<String, dynamic> json) {
    return BorrowItem(
      date: json['DATE'],
      itemId: json['ITEM_ID'],
      borrwedBy: json['BORROWED_BY'],
      location: json['LOCATION'],
      reason: json['REASON'],
      scanBy: json['SCAN_BY'],
    );
  }

  Map<String, dynamic> toGsheets() {
    return {
      'DATE': date,
      'ITEM_ID': itemId,
      'BORROWED_BY': borrwedBy,
      'LOCATION': location,
      'REASON': reason,
      'SCAN_BY': scanBy,
    };
  }

  @override
  String toString() =>
      'Product{date: $date, item: $itemId, borrowed_by: $borrwedBy, location: $location, reason: $reason, scan by: $scanBy}';
}
