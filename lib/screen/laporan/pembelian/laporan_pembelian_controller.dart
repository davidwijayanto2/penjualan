import 'dart:io';

import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:penjualan/model/pembelian.dart';
import 'package:penjualan/model/stok.dart';
import 'package:penjualan/model/stok_masuk.dart';
import 'package:penjualan/repositories/db_helper.dart';
import 'package:penjualan/screen/laporan/pembelian/laporan_pembelian_view.dart';
import 'package:penjualan/screen/laporan/stok_masuk/laporan_stok_masuk_view.dart';
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

class LaporanPembelian extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LaporanPembelianView();
}

abstract class LaporanPembelianController extends State<LaporanPembelian> {
  final debouncer =
      Debouncer<String>(Duration(milliseconds: 250), initialValue: '');
  final TextEditingController searchController = TextEditingController();
  String? filterStartDate;
  String? filterEndDate;
  String? filterPeriode;
  List<HBeli>? listPembelian = <HBeli>[];
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
        "SELECT DISTINCT strftime('%Y',TANGGAL_BELI) as tahun FROM h_beli ORDER BY tahun ASC");

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
          "SELECT ID_HBELI,BUKTI_NOTA,TANGGAL_BELI,NM_SUPPLIER,GRANDTOTAL FROM h_beli WHERE BUKTI_NOTA like ? OR lower(NM_SUPPLIER) like ? OR GRANDTOTAL like ? ORDER BY TANGGAL_BELI DESC, BUKTI_NOTA DESC",
          ["%$text%", "%$text%", "%$text%"]);
      resultTotal = await db?.rawQuery(
          "SELECT IFNULL(SUM(GRANDTOTAL),0) as JUMLAH FROM h_beli WHERE BUKTI_NOTA like ? OR lower(NM_SUPPLIER) like ? OR GRANDTOTAL like ? ORDER BY TANGGAL_BELI DESC, BUKTI_NOTA DESC",
          ["%$text%", "%$text%", "%$text%"]);
      print(result);
    } else if (filterStart != null && filterEnd != null) {
      result = await db?.rawQuery(
          "SELECT ID_HBELI,BUKTI_NOTA,TANGGAL_BELI,NM_SUPPLIER,GRANDTOTAL FROM h_beli WHERE date(TANGGAL_BELI) BETWEEN ? AND ? ORDER BY TANGGAL_BELI DESC, BUKTI_NOTA DESC",
          [
            "$filterStart",
            "$filterEnd",
          ]);
      resultTotal = await db?.rawQuery(
          "SELECT IFNULL(SUM(GRANDTOTAL),0) as JUMLAH FROM h_beli WHERE date(TANGGAL_BELI) BETWEEN ? AND ? ORDER BY TANGGAL_BELI DESC, BUKTI_NOTA DESC",
          [
            "$filterStart",
            "$filterEnd",
          ]);
    } else if (year != null && month != null) {
      if (year != '0' && month != '0') {
        result = await db?.rawQuery(
            "SELECT ID_HBELI,BUKTI_NOTA,TANGGAL_BELI,NM_SUPPLIER,GRANDTOTAL FROM h_beli WHERE strftime('%Y',TANGGAL_BELI) = ? AND strftime('%m', TANGGAL_BELI) = ? ORDER BY TANGGAL_BELI DESC, BUKTI_NOTA DESC",
            [
              "$year",
              "$month",
            ]);
        resultTotal = await db?.rawQuery(
            "SELECT IFNULL(SUM(GRANDTOTAL),0) as JUMLAH FROM h_beli WHERE strftime('%Y',TANGGAL_BELI) = ? AND strftime('%m', TANGGAL_BELI) = ? ORDER BY TANGGAL_BELI DESC, BUKTI_NOTA DESC",
            [
              "$year",
              "$month",
            ]);
      } else if (year != '0' && month == '0') {
        result = await db?.rawQuery(
            "SELECT ID_HBELI,BUKTI_NOTA,TANGGAL_BELI,NM_SUPPLIER,GRANDTOTAL FROM h_beli WHERE strftime('%Y',TANGGAL_BELI) = ? ORDER BY TANGGAL_BELI DESC, BUKTI_NOTA DESC",
            [
              "$year",
            ]);
        resultTotal = await db?.rawQuery(
            "SELECT IFNULL(SUM(GRANDTOTAL),0) as JUMLAH FROM h_beli WHERE strftime('%Y',TANGGAL_BELI) = ? ORDER BY TANGGAL_BELI DESC, BUKTI_NOTA DESC",
            [
              "$year",
            ]);
      } else if (year == '0' && month != '0') {
        result = await db?.rawQuery(
            "SELECT ID_HBELI,BUKTI_NOTA,TANGGAL_BELI,NM_SUPPLIER,GRANDTOTAL FROM h_beli WHERE strftime('%m', TANGGAL_BELI) = ? ORDER BY TANGGAL_BELI DESC, BUKTI_NOTA DESC",
            [
              "$month",
            ]);
        resultTotal = await db?.rawQuery(
            "SELECT IFNULL(SUM(GRANDTOTAL),0) as JUMLAH FROM h_beli WHERE strftime('%m', TANGGAL_BELI) = ? ORDER BY TANGGAL_BELI DESC, BUKTI_NOTA DESC",
            [
              "$month",
            ]);
      }
    } else {
      result = await db?.rawQuery(
          "SELECT ID_HBELI,BUKTI_NOTA,TANGGAL_BELI,NM_SUPPLIER,GRANDTOTAL FROM h_beli ORDER BY TANGGAL_BELI DESC, BUKTI_NOTA DESC");
      resultTotal = await db
          ?.rawQuery("SELECT IFNULL(SUM(GRANDTOTAL),0) as JUMLAH FROM h_beli");
    }

    // if ((result?.length ?? 0) > 0) {
    setState(() {
      listPembelian = List<HBeli>.from(result.map((map) => HBeli.fromMap(map)));
      total = resultTotal[0]['JUMLAH'];
    });
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

  getDetailPembelian(int index) async {
    Database? db = await DatabaseHelper.instance.database;

    var result;
    print(listPembelian![index].idHbeli);
    if (listPembelian != null) {
      if (listPembelian![index].dBeliList == null) {
        result = await db?.rawQuery("SELECT * FROM d_beli WHERE ID_HBELI = ?",
            [listPembelian![index].idHbeli]);
        listPembelian![index].dBeliList =
            List<Dbeli>.from(result.map((map) => Dbeli.fromMap(map)));
      }
    }
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

        for (int i = 0; i < listPembelian!.length; i++) {
          await getDetailPembelian(i);
          indexRow = i > 0 ? (indexRow + 2) : (indexRow + 1);
          sheet.setRowHeightInPixels(indexRow, 22);
          range = sheet.getRangeByIndex(indexRow, 1, indexRow, 2);
          range.merge();
          range.setText('Supplier :');
          range.cellStyle = globalStyle;
          range.cellStyle.hAlign = HAlignType.right;
          range.cellStyle.vAlign = VAlignType.center;

          range = sheet.getRangeByIndex(indexRow, 3);
          range.setText(listPembelian![i].nmSupplier);
          range.cellStyle = globalStyle;
          range.cellStyle.hAlign = HAlignType.left;
          range.cellStyle.vAlign = VAlignType.center;

          range = sheet.getRangeByIndex(indexRow, 7);
          range.setText("Karayawan :");
          range.cellStyle = globalStyle;
          range.cellStyle.hAlign = HAlignType.right;
          range.cellStyle.vAlign = VAlignType.center;

          range = sheet.getRangeByIndex(indexRow, 8);
          range.setText(listPembelian![i].nmKaryawan);
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
          range.setText(listPembelian![i].nonota);
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
                listPembelian![i].tglTransaksi ?? '',
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

          for (int d = 0; d < (listPembelian![i].dBeliList ?? []).length; d++) {
            indexRow = indexRow + 1;
            sheet.setRowHeightInPixels(indexRow, 22);
            var dbelilist = listPembelian![i].dBeliList![d];
            range = sheet.getRangeByIndex(indexRow, 1);
            range.setText(indexDetail.toString());
            range.cellStyle = globalStyle;
            range.cellStyle.hAlign = HAlignType.center;
            range.cellStyle.vAlign = VAlignType.center;
            range.cellStyle.borders.left.lineStyle = LineStyle.thick;
            range.cellStyle.borders.right.lineStyle = LineStyle.thick;

            range = sheet.getRangeByIndex(indexRow, 2, indexRow, 4);
            range.merge();
            range.setText("${dbelilist.nmBarang}");
            range.cellStyle = globalStyle;
            range.cellStyle.hAlign = HAlignType.left;
            range.cellStyle.vAlign = VAlignType.center;
            range.cellStyle.borders.right.lineStyle = LineStyle.thick;

            range = sheet.getRangeByIndex(indexRow, 5);
            range.setNumber((dbelilist.quantity ?? 0).toDouble());
            range.cellStyle = globalStyle;
            range.cellStyle.hAlign = HAlignType.right;
            range.cellStyle.vAlign = VAlignType.center;
            range.cellStyle.borders.right.lineStyle = LineStyle.thick;

            range = sheet.getRangeByIndex(indexRow, 6);
            range.setText("${dbelilist.satuan}");
            range.cellStyle = globalStyle;
            range.cellStyle.hAlign = HAlignType.center;
            range.cellStyle.vAlign = VAlignType.center;
            range.cellStyle.borders.right.lineStyle = LineStyle.thick;

            range = sheet.getRangeByIndex(indexRow, 7);
            range.setNumber((dbelilist.hargaBarang ?? 0).toDouble());
            range.cellStyle = globalStyle;
            range.cellStyle.numberFormat = "#,##0";
            range.cellStyle.hAlign = HAlignType.right;
            range.cellStyle.vAlign = VAlignType.center;
            range.cellStyle.borders.right.lineStyle = LineStyle.thick;

            range = sheet.getRangeByIndex(indexRow, 8);
            range.setNumber((dbelilist.subtotal ?? 0).toDouble());
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
          range.setNumber((listPembelian![i].grandTotal ?? 0).toDouble());
          range.cellStyle = globalStyle;
          range.numberFormat = '#,##0';
          range.cellStyle.indent = 1;
          range.cellStyle.hAlign = HAlignType.right;
          range.cellStyle.vAlign = VAlignType.center;
          range.cellStyle.borders.all.lineStyle = LineStyle.thick;
        }

        final path = await ExternalPath.getExternalStorageDirectories();
        final List<int> bytes = workbook.saveAsStream();
        File('${path[0]}/Detail Pembelian.xlsx').writeAsBytes(bytes);
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
