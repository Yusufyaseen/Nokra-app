import 'dart:io';

// import 'package:shared_preferences/shared_preferences.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xs;
import 'package:path_provider/path_provider.dart';

class Excel {
  Future<bool> isExist() async {
    final path = (await getApplicationSupportDirectory()).path;
    bool a = await File("$path/data.xlsx").exists();
    return a;
  }

  Future<void> create() async {
    final path = (await getApplicationSupportDirectory()).path;
    bool a = await isExist();
    if (!a) {
      xs.Workbook workbook = xs.Workbook();
      // sheet.getRangeByName('B1').setNumber(44);
      // final xs.Range range1 = sheet.getRangeByName('A2:A5');
      // range1.setText('This is Long Text using AutoFit Columns and Rows');
      // range1.cellStyle.wrapText = false;
      // sheet.getRangeByName('A5').setDateTime(DateTime(2020, 12, 12, 1, 10, 20));
      final List<int> bytes = workbook.saveAsStream();
      final filename = "$path/data.xlsx";
      await File(filename).writeAsBytes(bytes);
      workbook.dispose();
    }
  }

  Future<void> addToExcel(List x, List y, List z, List long, List lat,List speed) async {
    await create();
    xs.Workbook workbook = xs.Workbook();
    xs.Worksheet sheet = workbook.worksheets[0];
    final path = (await getApplicationSupportDirectory()).path;
    xs.Style globalStyle = workbook.styles.add('style');
    globalStyle.fontSize = 12;
    globalStyle.bold = true;
    globalStyle.wrapText = true;
    sheet.getRangeByName('A${1}').setText("x");
    sheet.getRangeByName('B${1}').setText("y");
    sheet.getRangeByName('C${1}').setText("z");
    sheet.getRangeByName('D${1}').setText("longitude");
    sheet.getRangeByName('E${1}').setText("latitude");
    sheet.getRangeByName('F${1}').setText("speed");
    sheet.getRangeByName('G${1}').setText("timestamp");
    sheet.getRangeByName('A${1}').cellStyle = globalStyle;
    sheet.getRangeByName('B${1}').cellStyle = globalStyle;
    sheet.getRangeByName('C${1}').cellStyle = globalStyle;
    sheet.getRangeByName('D${1}').cellStyle = globalStyle;
    sheet.getRangeByName('E${1}').cellStyle = globalStyle;
    sheet.getRangeByName('F${1}').cellStyle = globalStyle;
    sheet.getRangeByName('G${1}').cellStyle = globalStyle;

    for (int i = 2; i < x.length + 2; i++) {
      sheet
          .getRangeByName('A$i')
          .setNumber(double.parse((x[i - 2]).toStringAsFixed(2)));
      sheet
          .getRangeByName('B$i')
          .setNumber(double.parse((y[i - 2]).toStringAsFixed(2)));
      sheet
          .getRangeByName('C$i')
          .setNumber(double.parse((z[i - 2]).toStringAsFixed(2)));
      sheet.getRangeByName('D$i').setNumber(long[i - 2]);
      sheet.getRangeByName('E$i').setNumber(lat[i - 2]);
      sheet.getRangeByName('F$i').setNumber(speed[i - 2]);
      sheet.getRangeByName('E$i').cellStyle.wrapText = true;
      sheet.getRangeByName('F$i').cellStyle.wrapText = true;
      sheet.getRangeByName('G$i').cellStyle.wrapText = true;
    }

    final List<int> bytes = workbook.saveAsStream();
    final filename = "$path/data.xlsx";
    await File(filename).writeAsBytes(bytes);
    workbook.dispose();
  }

  Future<void> open() async {
    final path = (await getApplicationSupportDirectory()).path;
    final filename = "$path/data.xlsx";
    OpenFile.open(filename);
  }
}
