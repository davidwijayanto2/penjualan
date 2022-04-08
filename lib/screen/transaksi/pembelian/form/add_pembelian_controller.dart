import 'dart:io';

import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:penjualan/model/customer.dart';
import 'package:penjualan/model/kategori.dart';
import 'package:penjualan/model/pembelian.dart';
import 'package:penjualan/model/penjualan.dart';
import 'package:penjualan/model/stok.dart';
import 'package:penjualan/repositories/db_helper.dart';
import 'package:penjualan/repositories/local_storage.dart';
import 'package:penjualan/routing/router_const.dart';
import 'package:penjualan/utils/common_dialog.dart';
import 'package:penjualan/utils/date_formatter.dart';
import 'package:penjualan/utils/select_barang.dart';
import 'package:penjualan/utils/select_customer.dart';
import 'package:penjualan/utils/select_supplier.dart';
import 'package:penjualan/utils/string_formatter.dart';
import 'package:sqflite/sqflite.dart';
import 'add_pembelian_view.dart';

class AddPembelian extends StatefulWidget {
  final HBeli? editHbeli;
  AddPembelian({this.editHbeli});
  @override
  State<StatefulWidget> createState() => AddPembelianView();
}

abstract class AddPembelianController extends State<AddPembelian> {
  final formKey = GlobalKey<FormBuilderState>();
  final discountDebouncer =
      Debouncer<String>(Duration(milliseconds: 250), initialValue: '');
  final dibayarDebouncer =
      Debouncer<String>(Duration(milliseconds: 250), initialValue: '');
  final TextEditingController noNotaController = TextEditingController();

  final TextEditingController keteranganController = TextEditingController();
  final TextEditingController kotaController = TextEditingController();
  final TextEditingController keterangan2Controller = TextEditingController();
  final TextEditingController totalController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController grandTotalController = TextEditingController();
  final TextEditingController dibayarkanController = TextEditingController();
  final TextEditingController sisaController = TextEditingController();

  bool onError = false;
  bool showFormBarang = false;
  List<Dbeli>? dbeliList = <Dbeli>[];
  int? kategori = 0;
  int quantityTotal = 0;
  String dateTextStr = '';
  DateTime datePicked = DateTime.now();
  HBeli? supllier;
  List<Kategori>? listKategori;

  @override
  void initState() {
    initForm();

    super.initState();
  }

  initForm() async {
    fetchKategori();
    if (widget.editHbeli != null) {
      fetchDataDbeli();
      Database? db = await DatabaseHelper.instance.database;
      var result = await db?.rawQuery(
          "SELECT DISTINCT NM_SUPPLIER FROM H_BELI WHERE upper(NM_SUPPLIER)=?",
          [widget.editHbeli?.nmSupplier ?? '']);
      if ((result?.length ?? 0) > 0) {
        supllier = HBeli.fromMap(result![0]);
      } else {
        supllier = HBeli(nmSupplier: widget.editHbeli?.nmSupplier ?? '');
      }
      setState(() {
        datePicked = DateTime.parse(widget.editHbeli?.tglTransaksi ?? '');
        dateTextStr = DateFormatter.toLongDateText(
            context, DateTime.parse(widget.editHbeli?.tglTransaksi ?? ''));
        noNotaController.text = widget.editHbeli?.nonota ?? '';
        keteranganController.text = widget.editHbeli?.keterangan ?? '';
        calculateTotal();
      });
    } else {
      setState(() {
        dateTextStr = DateFormatter.toLongDateText(context, DateTime.now());
      });
    }
  }

  fetchDataDbeli() async {
    Database? db = await DatabaseHelper.instance.database;
    var result;
    result = await db?.rawQuery(
        "SELECT * FROM d_beli WHERE ID_HBELI = ?", [widget.editHbeli!.idHbeli]);
    dbeliList = List<Dbeli>.from(result.map((map) => Dbeli.fromMap(map)));
  }

  fetchKategori() async {
    Database? db = await DatabaseHelper.instance.database;

    var result = await db?.rawQuery("SELECT * FROM KATEGORI");

    if ((result?.length ?? 0) > 0) {
      setState(() {
        listKategori =
            List<Kategori>.from(result!.map((map) => Kategori.fromMap(map)));
        listKategori?.insert(
            0, Kategori(idKategori: 0, nmKategori: '', status: ''));
      });
    }
  }

  showDialogSupplier(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    return popupDialogAutoComplete(
      context,
      selectWidget: SelectSupplier(
        (supplier) {
          setState(() {
            this.supllier = supplier;
          });
          Navigator.of(context, rootNavigator: true).pop();
        },
      ),
    );
  }

  calculateTotal() {
    var total = 0, grandTotal = 0;
    for (int i = 0; i < (dbeliList ?? []).length; i++) {
      total = total + (dbeliList?[i].subtotal ?? 0);
    }
    grandTotal = total;
    totalController.text = thousandSeparator(total, separator: '.');
    grandTotalController.text = thousandSeparator(grandTotal, separator: '.');
    calculateQtyTotal();
  }

  calculateSisa() {
    if (grandTotalController.text.trim().isNotEmpty &&
        dibayarkanController.text.trim().isNotEmpty) {
      var grandTotal =
          int.parse(extractNumber(value: grandTotalController.text));
      sisaController.text = thousandSeparator(
          grandTotal -
              int.parse(extractNumber(value: dibayarkanController.text)),
          separator: '.');
    }
  }

  calculateSubtotal({required Dbeli dbeli}) {
    setState(() {
      dbeli.subtotal = (dbeli.hargaBarang ?? 0) * (dbeli.quantity ?? 0);
      calculateQtyTotal();
    });
  }

  calculateQtyTotal() {
    var qty = 0;
    dbeliList?.forEach((dbeli) {
      qty = qty + (dbeli.quantity ?? 0);
    });
    quantityTotal = qty;
  }

  showDialogDelete(Dbeli dbeli) {
    PopupDialog(
      context: context,
      titleText: 'Hapus Data',
      subtitleText: 'Apakah Anda yakin akan menghapus data ini?',
      icon: FontAwesomeIcons.exclamationCircle,
      iconColor: Colors.red,
      rightButtonAction: (_) async {
        Navigator.pop(context);
        dbeliList?.remove(dbeli);
        calculateSubtotal(dbeli: dbeli);
        calculateTotal();
      },
      rightButtonColor: Colors.red,
    );
  }

  HBeli getHbeliFromForm() {
    var user = LocalStorage.userLogin();
    return HBeli(
      idHbeli: null,
      tglTransaksi: DateFormatter.dateTimeToDBFormat(datePicked),
      nmKaryawan: user?.nmKaryawan ?? '',
      nmSupplier: supllier?.nmSupplier ?? '',
      quantityTotal: quantityTotal,
      grandTotal: grandTotalController.text.isEmpty
          ? 0
          : int.parse(extractNumber(value: grandTotalController.text)),
      nonota: noNotaController.text.trim(),
      keterangan: keteranganController.text.trim(),
    );
  }

  bool validateForm() {
    bool flag = true;
    if (!formKey.currentState!.validate()) flag = false;
    if (supllier == null) flag = false;
    if ((dbeliList ?? <Dbeli>[]).isEmpty) flag = false;
    return flag;
  }

  Future<void> submitForm() async {
    if (validateForm()) {
      Database? db = await DatabaseHelper.instance.database;
      var user = LocalStorage.userLogin();
      if (widget.editHbeli != null) {
        await db?.rawUpdate(
            'UPDATE h_beli set TANGGAL_BELI = ?, NM_KARYAWAN = ?, NM_SUPPLIER = ?, QUANTITY_TOTAL = ?, GRANDTOTAL = ?, BUKTI_NOTA = ?, KETERANGAN = ? WHERE ID_HBELI = ?',
            [
              DateFormatter.dateTimeToDBFormat(datePicked),
              user?.nmKaryawan ?? '',
              supllier?.nmSupplier ?? '',
              quantityTotal,
              int.parse(extractNumber(value: grandTotalController.text)),
              noNotaController.text.trim(),
              keteranganController.text.trim(),
              widget.editHbeli?.idHbeli ?? '',
            ]).then((value) async {
          await db.rawDelete('DELETE FROM d_beli WHERE ID_HBELI = ?',
              [widget.editHbeli?.idHbeli]);
          Batch batch = db.batch();
          dbeliList?.forEach((dbeli) {
            batch.insert('d_beli', {
              'ID_HBELI': widget.editHbeli?.idHbeli ?? '',
              'NM_BARANG': dbeli.nmBarang,
              'SATUAN': dbeli.satuan,
              'QUANTITY': dbeli.quantity,
              'HARGA_BARANG': dbeli.hargaBarang,
              'SUBTOTAL': dbeli.subtotal,
            });
          });
          batch.commit();
          Fluttertoast.showToast(msg: 'Transaction has been saved');
          Navigator.pop(context);
        }).catchError((onError) {
          Fluttertoast.showToast(msg: 'Error when store to database');
        });
      } else {
        var res = await db?.rawQuery(
            "SELECT MAX(substr(ID_HBELI,1,4)) || '/' as ID_HBELI FROM h_beli WHERE strftime('%m',TANGGAL_BELI) = ? AND strftime('%Y',TANGGAL_BELI) = ?",
            [
              DateFormatter.getMonth(DateTime.now()),
              DateFormatter.getYear(DateTime.now())
            ]);

        List<HBeli> hbelilist =
            List<HBeli>.from((res ?? []).map((map) => HBeli.fromMap(map)));
        String idHbeli = '';
        String platformCode = Platform.isIOS ? 'IO' : 'AR';
        if (hbelilist[0].idHbeli != null) {
          HBeli hbeli = hbelilist.first;
          var id = hbeli.idHbeli?.split('/');
          idHbeli = (int.parse(id![0]) + 1).toString().padLeft(4, '0') +
              '/' +
              DateFormatter.getMonth(DateTime.now()) +
              '/' +
              DateFormatter.getYear(DateTime.now()) +
              platformCode;
        } else {
          idHbeli = '0001' +
              '/' +
              DateFormatter.getMonth(DateTime.now()) +
              '/' +
              DateFormatter.getYear(DateTime.now()) +
              platformCode;
        }

        await db?.rawInsert('INSERT INTO h_beli VALUES(?,?,?,?,?,?,?,?)', [
          idHbeli,
          supllier?.nmSupplier ?? '',
          user?.username ?? '',
          int.parse(extractNumber(value: grandTotalController.text)),
          quantityTotal,
          DateFormatter.dateTimeToDBFormat(datePicked),
          noNotaController.text.trim(),
          keteranganController.text.trim(),
        ]).then((value) async {
          Batch batch = db.batch();
          dbeliList?.forEach((dbeli) {
            batch.insert('d_beli', {
              'ID_HBELI': idHbeli,
              'NM_BARANG': dbeli.nmBarang,
              'SATUAN': dbeli.satuan,
              'QUANTITY': dbeli.quantity,
              'HARGA_BARANG': dbeli.hargaBarang,
              'SUBTOTAL': dbeli.subtotal,
            });
          });
          batch.commit();
          Fluttertoast.showToast(msg: 'Transaction has been saved');
          Navigator.pop(context);
        }).catchError((onError) {
          Fluttertoast.showToast(msg: 'Error when store to database');
        });
      }
    } else {
      setState(() {
        onError = true;
      });
    }
  }

  addDbeliList(Dbeli dbeli, int? _index) {
    setState(() {
      if (_index != null) {
        if (dbeliList?[_index].nmBarang != dbeli.nmBarang) {
          int index = (dbeliList ?? <Dbeli>[])
              .indexWhere((element) => element.nmBarang == dbeli.nmBarang);
          if (index > -1) {
            (dbeliList ?? <Dbeli>[])[index].quantity =
                ((dbeliList ?? <Dbeli>[])[index].quantity ?? 0) +
                    (dbeli.quantity ?? 0);
            calculateSubtotal(dbeli: (dbeliList ?? <Dbeli>[])[index]);
            dbeliList?.removeAt(_index);
          } else {
            // (djualList ?? <DJual>[]).insert(_index, djual);
            dbeliList?[_index] = dbeli;
            calculateSubtotal(dbeli: (dbeliList ?? <Dbeli>[])[_index]);
          }
        } else {
          dbeliList?[_index] = dbeli;
          calculateSubtotal(dbeli: (dbeliList ?? <Dbeli>[])[_index]);
        }
      } else {
        int index = (dbeliList ?? <Dbeli>[])
            .indexWhere((element) => element.nmBarang == dbeli.nmBarang);
        if (index > -1) {
          (dbeliList ?? <Dbeli>[])[index].quantity =
              ((dbeliList ?? <Dbeli>[])[index].quantity ?? 0) +
                  (dbeli.quantity ?? 0);
          calculateSubtotal(dbeli: (dbeliList ?? <Dbeli>[])[index]);
        } else {
          (dbeliList ?? <Dbeli>[]).add(dbeli);
        }
      }
    });
  }
}
