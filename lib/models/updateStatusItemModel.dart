// ignore_for_file: file_names

import 'package:ccs_sis/helper/gsheet_info.dart';
import 'package:gsheets/gsheets.dart';

class UpdateStatusItemModel extends GoogleSheet {
  // ignore: unused_field
  late Worksheet? _worksheet;
  late GSheets _gSheet;
  late Spreadsheet _spreadsheet;

  @override
  Future<void> init() async {
    _gSheet = GSheets(credentials);
    _spreadsheet = await _gSheet.spreadsheet(spreadSheetId);

    _worksheet = _spreadsheet.worksheetByTitle('ITEM_UPDATE_STATUS');
  }

  // get all
  Future<List<UpdateStatusItem>> getAllItems() async {
    await init();
    final items = await _worksheet!.values.map.allRows(fromRow: 2);

    return items!.map((json) => UpdateStatusItem.fromGsheets(json)).toList();
  }

  // get by id
  Future<UpdateStatusItem?> getById(String id) async {
    await init();
    final map = await _worksheet!.values.map.rowByKey(
      id,
      fromColumn: 1,
    );

    return map == null ? null : UpdateStatusItem.fromGsheets(map);
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
  Future<bool> insert(UpdateStatusItem item) async {
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

  Future<bool> delete(UpdateStatusItem item) => deleteById(item.date);
}

class UpdateStatusItem {
  final String date;
  final String itemId;
  final String mre;
  final String transferMRE;
  final String location;
  final String? scanBy;

  UpdateStatusItem({
    required this.date,
    required this.itemId,
    required this.mre,
    required this.transferMRE,
    required this.location,
    required this.scanBy,
  });

  factory UpdateStatusItem.fromGsheets(Map<String, dynamic> json) {
    return UpdateStatusItem(
      date: json['DATE'],
      itemId: json['ITEM_ID'],
      mre: json['MRE'],
      transferMRE: json['TRANSFER_MRE_TO'],
      location: json['LOCATION'],
      scanBy: json['SCAN_BY'],
    );
  }

  Map<String, dynamic> toGsheets() {
    return {
      'DATE': date,
      'ITEM_ID': itemId,
      'MRE': mre,
      'TRANSFER_MRE_TO': transferMRE,
      'LOCATION': location,
      'SCAN_BY': scanBy,
    };
  }

  @override
  String toString() =>
      'Product{date: $date, item: $itemId, MRE: $mre, TRANSFER_MRE_TO: $transferMRE, LOCATION: $location, scan by: $scanBy}';
}
