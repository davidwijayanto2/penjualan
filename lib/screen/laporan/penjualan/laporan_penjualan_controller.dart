import 'dart:io';

import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:penjualan/model/penjualan.dart';
import 'package:penjualan/model/stok.dart';
import 'package:penjualan/model/stok_keluar.dart';
import 'package:penjualan/repositories/db_helper.dart';
import 'package:penjualan/screen/laporan/penjualan/laporan_penjualan_view.dart';
import 'package:penjualan/screen/laporan/stok_keluar/laporan_stok_keluar_view.dart';
import 'package:penjualan/utils/common_dialog.dart';
import 'package:penjualan/utils/common_widgets.dart';
import 'package:penjualan/utils/custom_datetime_picker.dart';
import 'package:penjualan/utils/date_formatter.dart';
import 'package:penjualan/utils/string_formatter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class LaporanPenjualan extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LaporanPenjualanView();
}

abstract class LaporanPenjualanController extends State<LaporanPenjualan> {
  final debouncer =
      Debouncer<String>(Duration(milliseconds: 250), initialValue: '');
  final TextEditingController searchController = TextEditingController();
  String? filterStartDate;
  String? filterEndDate;
  String? filterPeriode;
  List<HJual>? listPenjualan = <HJual>[];
  String? yearPicked = '0';
  String? monthPicked = '0';
  List<String>? listYear;
  List<String>? listMonth = [
    '0',
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12'
  ];
  int total = 0;

  @override
  void initState() {
    searchController.addListener(() {
      if (mounted) {
        debouncer.value = searchController.text.trim().toLowerCase();
      }
    });
    debouncer.values.listen((text) {
      if (mounted) {
        fetchDataStokKeluar(text: text);
      }
    });
    initDate();
    setScheduleDateText();
    fetchDataStokKeluar();
    fetchYearMonth();
    super.initState();
  }

  fetchYearMonth() async {
    Database? db = await DatabaseHelper.instance.database;

    var resultYear = await db?.rawQuery(
        "SELECT DISTINCT strftime('%Y',TGL_TRANSAKSI) as tahun FROM h_jual ORDER BY tahun ASC");

    if ((resultYear?.length ?? 0) > 0) {
      setState(() {
        listYear = List<String>.from(resultYear!.map((map) => map['tahun']));
      });
      listYear?.insert(0, '0');
    }
  }

  initDate() {
    filterStartDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    filterEndDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  fetchDataStokKeluar(
      {String? text,
      String? filterStart,
      String? filterEnd,
      String? month,
      String? year}) async {
    Database? db = await DatabaseHelper.instance.database;

    var result, resultTotal;
    if (text != null && text != '') {
      result = await db?.rawQuery(
          "SELECT ID_HJUAL, NONOTA,TGL_TRANSAKSI,NM_CUSTOMER,GRANDTOTAL FROM h_jual WHERE NONOTA like ? OR lower(NM_CUSTOMER) like ? OR GRANDTOTAL like ? ORDER BY TGL_TRANSAKSI DESC, ID_HJUAL DESC",
          ["%$text%", "%$text%", "%$text%"]);
      resultTotal = await db?.rawQuery(
          "SELECT IFNULL(SUM(GRANDTOTAL),0) as JUMLAH FROM h_jual WHERE NONOTA like ? OR lower(NM_CUSTOMER) like ? OR GRANDTOTAL like ? ORDER BY TGL_TRANSAKSI DESC, ID_HJUAL DESC",
          ["%$text%", "%$text%", "%$text%"]);
      print(result);
    } else if (filterStart != null && filterEnd != null) {
      result = await db?.rawQuery(
          "SELECT ID_HJUAL, NONOTA,TGL_TRANSAKSI,NM_CUSTOMER,GRANDTOTAL FROM h_jual WHERE date(TGL_TRANSAKSI) BETWEEN ? AND ? ORDER BY TGL_TRANSAKSI DESC, ID_HJUAL DESC",
          [
            "$filterStart",
            "$filterEnd",
          ]);
      resultTotal = await db?.rawQuery(
          "SELECT IFNULL(SUM(GRANDTOTAL),0) as JUMLAH FROM h_jual WHERE date(TGL_TRANSAKSI) BETWEEN ? AND ? ORDER BY TGL_TRANSAKSI DESC, ID_HJUAL DESC",
          [
            "$filterStart",
            "$filterEnd",
          ]);
    } else if (year != null && month != null) {
      if (year != '0' && month != '0') {
        result = await db?.rawQuery(
            "SELECT ID_HJUAL, NONOTA,TGL_TRANSAKSI,NM_CUSTOMER,GRANDTOTAL FROM h_jual WHERE strftime('%Y',TGL_TRANSAKSI) = ? AND strftime('%m', TGL_TRANSAKSI) = ? ORDER BY TGL_TRANSAKSI DESC, ID_HJUAL DESC",
            [
              "$year",
              "$month",
            ]);
        resultTotal = await db?.rawQuery(
            "SELECT IFNULL(SUM(GRANDTOTAL),0) as JUMLAH FROM h_jual WHERE strftime('%Y',TGL_TRANSAKSI) = ? AND strftime('%m', TGL_TRANSAKSI) = ? ORDER BY TGL_TRANSAKSI DESC, ID_HJUAL DESC",
            [
              "$year",
              "$month",
            ]);
      } else if (year != '0' && month == '0') {
        result = await db?.rawQuery(
            "SELECT ID_HJUAL, NONOTA,TGL_TRANSAKSI,NM_CUSTOMER,GRANDTOTAL FROM h_jual WHERE strftime('%Y',TGL_TRANSAKSI) = ? ORDER BY TGL_TRANSAKSI DESC, ID_HJUAL DESC",
            [
              "$year",
            ]);
        resultTotal = await db?.rawQuery(
            "SELECT IFNULL(SUM(GRANDTOTAL),0) as JUMLAH FROM h_jual WHERE strftime('%Y',TGL_TRANSAKSI) = ? ORDER BY TGL_TRANSAKSI DESC, ID_HJUAL DESC",
            [
              "$year",
            ]);
      } else if (year == '0' && month != '0') {
        result = await db?.rawQuery(
            "SELECT ID_HJUAL, NONOTA,TGL_TRANSAKSI,NM_CUSTOMER,GRANDTOTAL FROM h_jual WHERE strftime('%m', TGL_TRANSAKSI) = ? ORDER BY TGL_TRANSAKSI DESC, ID_HJUAL DESC",
            [
              "$month",
            ]);
        resultTotal = await db?.rawQuery(
            "SELECT IFNULL(SUM(GRANDTOTAL),0) as JUMLAH FROM h_jual WHERE strftime('%m', TGL_TRANSAKSI) = ? ORDER BY TGL_TRANSAKSI DESC, ID_HJUAL DESC",
            [
              "$month",
            ]);
      }
    } else {
      result = await db?.rawQuery(
          "SELECT ID_HJUAL, NONOTA,TGL_TRANSAKSI,NM_CUSTOMER,GRANDTOTAL FROM h_jual ORDER BY TGL_TRANSAKSI DESC, ID_HJUAL DESC");
      resultTotal = await db
          ?.rawQuery("SELECT IFNULL(SUM(GRANDTOTAL),0) as JUMLAH FROM h_jual");
    }

    // if ((result?.length ?? 0) > 0) {
    setState(() {
      listPenjualan = List<HJual>.from(result.map((map) => HJual.fromMap(map)));
      total = resultTotal[0]['JUMLAH'];
    });
  }

  getDetailPenjualan(int index) async {
    Database? db = await DatabaseHelper.instance.database;

    var result;
    if (listPenjualan != null) {
      if (listPenjualan![index].dJualList == null) {
        result = await db?.rawQuery("SELECT * FROM d_jual WHERE ID_HJUAL = ?",
            [listPenjualan![index].idHjual]);
        listPenjualan![index].dJualList =
            List<DJual>.from(result.map((map) => DJual.fromMap(map)));
      }
    }
  }

  showDialogDelete(_idHjual) {
    PopupDialog(
      context: context,
      titleText: 'Hapus Data',
      subtitleText: 'Apakah Anda yakin akan menghapus data ini?',
      icon: FontAwesomeIcons.exclamationCircle,
      iconColor: Colors.red,
      rightButtonAction: (_) async {
        Navigator.pop(context);
        deletePenjualan(_idHjual);
      },
      rightButtonColor: Colors.red,
    );
  }

  Future<void> onPressDate() async {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    var picked = await CustomDateRangePicker.show(
        context: context,
        initialFirstdate: DateTime.parse(filterStartDate!),
        initialLastDate: DateTime.parse(filterEndDate!),
        firstDate:
            DateTime.parse(DateFormat('2010-01-01').format(DateTime.now())),
        lastDate: DateTime.parse("2100-01-01"));
    if (picked != null) {
      var formattedPicked1 = DateFormat('yyyy-MM-dd').format(picked[0]);
      var formattedPicked2 = picked.length < 2
          ? DateFormat('yyyy-MM-dd').format(picked[0])
          : DateFormat('yyyy-MM-dd').format(picked[1]);
      if (formattedPicked1 != filterStartDate ||
          formattedPicked2 != filterEndDate)
        setState(() {
          filterStartDate = DateFormat('yyyy-MM-dd').format(picked[0]);
          if (picked.length < 2)
            filterEndDate = DateFormat('yyyy-MM-dd').format(picked[0]);
          else
            filterEndDate = DateFormat('yyyy-MM-dd').format(picked[1]);
          setScheduleDateText();
          fetchDataStokKeluar(
              filterStart: filterStartDate, filterEnd: filterEndDate);
        });
    } else {
      setState(() {
        filterStartDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        filterEndDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        setScheduleDateText();
        fetchDataStokKeluar();
      });
    }
  }

  deletePenjualan(_idHjual) async {
    Database? db = await DatabaseHelper.instance.database;

    await db?.rawDelete("DELETE FROM h_jual WHERE ID_HJUAL = ?", [_idHjual]);

    fetchDataStokKeluar();
  }

  void setScheduleDateText() {
    initializeDateFormatting('id', null);
    var startDate = DateTime.parse(filterStartDate!);
    var endDate = DateTime.parse(filterEndDate!);
    filterPeriode = DateFormat('dd ').format(startDate) +
        DateFormat.MMM('id').format(startDate) +
        DateFormat(' yyyy').format(startDate) +
        ' - ' +
        DateFormat('dd ').format(endDate) +
        DateFormat.MMM('id').format(endDate) +
        DateFormat(' yyyy').format(endDate);
  }

  exportToExcel() async {
    if (await Permission.storage.request().isGranted) {
      final dialog = loadingDialog(context);
      final Workbook workbook = new Workbook();
      try {
        final Worksheet sheet = workbook.worksheets[0];
        sheet.showGridlines = false;
        Style globalStyle = getXLSGlobalStyle(workbook);
        int indexDetail = 1;
        int indexRow = 1;
        Range range;
        sheet.setColumnWidthInPixels(1, 18);
        sheet.setColumnWidthInPixels(2, 46);
        sheet.setColumnWidthInPixels(3, 132);
        sheet.setColumnWidthInPixels(4, 67);
        sheet.setColumnWidthInPixels(5, 37);
        sheet.setColumnWidthInPixels(6, 56);
        sheet.setColumnWidthInPixels(7, 89);
        sheet.setColumnWidthInPixels(8, 125);

        for (int i = 0; i < listPenjualan!.length; i++) {
          await getDetailPenjualan(i);
          indexRow = i > 0 ? (indexRow + 2) : (indexRow + 1);
          sheet.setRowHeightInPixels(indexRow, 22);
          range = sheet.getRangeByIndex(indexRow, 1, indexRow, 2);
          range.merge();
          range.setText('Tuan/ Toko :');
          range.cellStyle = globalStyle;
          range.cellStyle.hAlign = HAlignType.right;
          range.cellStyle.vAlign = VAlignType.center;

          range = sheet.getRangeByIndex(indexRow, 3);
          range.setText(listPenjualan![i].nmCustomer);
          range.cellStyle = globalStyle;
          range.cellStyle.hAlign = HAlignType.left;
          range.cellStyle.vAlign = VAlignType.center;

          range = sheet.getRangeByIndex(indexRow, 7);
          range.setText("Kota :");
          range.cellStyle = globalStyle;
          range.cellStyle.hAlign = HAlignType.right;
          range.cellStyle.vAlign = VAlignType.center;

          range = sheet.getRangeByIndex(indexRow, 8);
          range.setText(listPenjualan![i].kota);
          range.cellStyle = globalStyle;
          range.cellStyle.hAlign = HAlignType.left;
          range.cellStyle.vAlign = VAlignType.center;

          indexRow = indexRow + 1;
          sheet.setRowHeightInPixels(indexRow, 22);
          range = sheet.getRangeByIndex(indexRow, 1, indexRow, 2);
          range.merge();
          range.setText('Nomor Nota :');
          range.cellStyle = globalStyle;
          range.cellStyle.hAlign = HAlignType.right;
          range.cellStyle.vAlign = VAlignType.center;

          range = sheet.getRangeByIndex(indexRow, 3);
          range.merge();
          range.setText(listPenjualan![i].nonota);
          range.cellStyle = globalStyle;
          range.cellStyle.hAlign = HAlignType.left;
          range.cellStyle.vAlign = VAlignType.center;

          range = sheet.getRangeByIndex(indexRow, 6, indexRow, 7);
          range.merge();
          range.setText("Tanggal :");
          range.cellStyle = globalStyle;
          range.cellStyle.hAlign = HAlignType.right;
          range.cellStyle.vAlign = VAlignType.center;

          range = sheet.getRangeByIndex(indexRow, 8);
          range.setText(
            DateFormatter.toNumberDateText(
              context,
              DateTime.parse(
                listPenjualan![i].tglTransaksi ?? '',
              ),
            ),
          );
          range.cellStyle = globalStyle;
          range.cellStyle.hAlign = HAlignType.left;
          range.cellStyle.vAlign = VAlignType.center;

          indexRow = indexRow + 1;
          sheet.setRowHeightInPixels(indexRow, 22);
          range = sheet.getRangeByIndex(indexRow, 1);
          range.setText('No');
          range.cellStyle = globalStyle;
          range.cellStyle.hAlign = HAlignType.center;
          range.cellStyle.vAlign = VAlignType.center;
          range.cellStyle.borders.all.lineStyle = LineStyle.thick;

          range = sheet.getRangeByIndex(indexRow, 2, indexRow, 4);
          range.merge();
          range.setText('Nama Barang');
          range.cellStyle = globalStyle;
          range.cellStyle.hAlign = HAlignType.left;
          range.cellStyle.vAlign = VAlignType.center;
          range.cellStyle.borders.all.lineStyle = LineStyle.thick;

          range = sheet.getRangeByIndex(indexRow, 5);
          range.setText('Qty');
          range.cellStyle = globalStyle;
          range.cellStyle.hAlign = HAlignType.right;
          range.cellStyle.vAlign = VAlignType.center;
          range.cellStyle.borders.all.lineStyle = LineStyle.thick;

          range = sheet.getRangeByIndex(indexRow, 6);
          range.setText('Satuan');
          range.cellStyle = globalStyle;
          range.cellStyle.hAlign = HAlignType.center;
          range.cellStyle.vAlign = VAlignType.center;
          range.cellStyle.borders.all.lineStyle = LineStyle.thick;

          range = sheet.getRangeByIndex(indexRow, 7);
          range.setText('Harga');
          range.cellStyle = globalStyle;
          range.cellStyle.hAlign = HAlignType.right;
          range.cellStyle.vAlign = VAlignType.center;
          range.cellStyle.borders.all.lineStyle = LineStyle.thick;

          range = sheet.getRangeByIndex(indexRow, 8);
          range.setText('Subtotal');
          range.cellStyle = globalStyle;
          range.cellStyle.indent = 1;
          range.cellStyle.hAlign = HAlignType.right;
          range.cellStyle.vAlign = VAlignType.center;
          range.cellStyle.borders.all.lineStyle = LineStyle.thick;

          for (int d = 0; d < (listPenjualan![i].dJualList ?? []).length; d++) {
            indexRow = indexRow + 1;
            sheet.setRowHeightInPixels(indexRow, 22);
            var djualist = listPenjualan![i].dJualList![d];
            range = sheet.getRangeByIndex(indexRow, 1);
            range.setText(indexDetail.toString());
            range.cellStyle = globalStyle;
            range.cellStyle.hAlign = HAlignType.center;
            range.cellStyle.vAlign = VAlignType.center;
            range.cellStyle.borders.left.lineStyle = LineStyle.thick;
            range.cellStyle.borders.right.lineStyle = LineStyle.thick;

            range = sheet.getRangeByIndex(indexRow, 2, indexRow, 4);
            range.merge();
            range.setText("${djualist.nmBarang}");
            range.cellStyle = globalStyle;
            range.cellStyle.hAlign = HAlignType.left;
            range.cellStyle.vAlign = VAlignType.center;
            range.cellStyle.borders.right.lineStyle = LineStyle.thick;

            range = sheet.getRangeByIndex(indexRow, 5);
            range.setNumber((djualist.quantity ?? 0).toDouble());
            range.cellStyle = globalStyle;
            range.cellStyle.hAlign = HAlignType.right;
            range.cellStyle.vAlign = VAlignType.center;
            range.cellStyle.borders.right.lineStyle = LineStyle.thick;

            range = sheet.getRangeByIndex(indexRow, 6);
            range.setText("${djualist.satuan}");
            range.cellStyle = globalStyle;
            range.cellStyle.hAlign = HAlignType.center;
            range.cellStyle.vAlign = VAlignType.center;
            range.cellStyle.borders.right.lineStyle = LineStyle.thick;

            range = sheet.getRangeByIndex(indexRow, 7);
            range.setNumber((djualist.hargaBarang ?? 0).toDouble());
            range.cellStyle = globalStyle;
            range.cellStyle.numberFormat = "#,##0";
            range.cellStyle.hAlign = HAlignType.right;
            range.cellStyle.vAlign = VAlignType.center;
            range.cellStyle.borders.right.lineStyle = LineStyle.thick;

            range = sheet.getRangeByIndex(indexRow, 8);
            range.setNumber((djualist.subtotal ?? 0).toDouble());
            range.cellStyle = globalStyle;
            range.cellStyle.numberFormat = "#,##0";
            range.cellStyle.indent = 1;
            range.cellStyle.hAlign = HAlignType.right;
            range.cellStyle.vAlign = VAlignType.center;
            range.cellStyle.borders.right.lineStyle = LineStyle.thick;

            indexDetail++;
          }

          indexRow = indexRow + 1;
          sheet.setRowHeightInPixels(indexRow, 22);
          range = sheet.getRangeByIndex(indexRow, 1, indexRow, 6);
          range.merge();
          range.cellStyle = globalStyle;
          range.cellStyle.borders.all.lineStyle = LineStyle.thick;

          range = sheet.getRangeByIndex(indexRow, 7);
          range.setText('Grand Total');
          range.cellStyle = globalStyle;
          range.cellStyle.hAlign = HAlignType.right;
          range.cellStyle.vAlign = VAlignType.center;
          range.cellStyle.borders.all.lineStyle = LineStyle.thick;

          range = sheet.getRangeByIndex(indexRow, 8);
          range.setNumber((listPenjualan![i].grandTotal ?? 0).toDouble());
          range.cellStyle = globalStyle;
          range.numberFormat = '#,##0';
          range.cellStyle.indent = 1;
          range.cellStyle.hAlign = HAlignType.right;
          range.cellStyle.vAlign = VAlignType.center;
          range.cellStyle.borders.all.lineStyle = LineStyle.thick;
        }

        final path = await ExternalPath.getExternalStorageDirectories();
        final List<int> bytes = workbook.saveAsStream();
        File('${path[0]}/Detail Penjualan.xlsx').writeAsBytes(bytes);
      } catch (e) {
        print(e);
        Fluttertoast.showToast(
            msg: 'Terjadi kesalahan saat export. Silahkan coba lagi');
        dialog.dismiss();
        workbook.dispose();
      } finally {
        dialog.dismiss();
        workbook.dispose();
        Fluttertoast.showToast(msg: 'Export berhasil');
      }
    }
  }

  Style getXLSGlobalStyle(Workbook workbook) {
    Style globalStyle = workbook.styles.add('style');
    globalStyle.fontName = 'Arial';
    globalStyle.fontSize = 7;
    globalStyle.borders.all.lineStyle = LineStyle.none;
    globalStyle.wrapText = true;

    return globalStyle;
  }
}
