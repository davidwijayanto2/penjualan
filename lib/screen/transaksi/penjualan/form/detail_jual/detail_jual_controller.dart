import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:penjualan/model/customer.dart';
import 'package:penjualan/model/kategori.dart';
import 'package:penjualan/model/penjualan.dart';
import 'package:penjualan/model/satuan.dart';
import 'package:penjualan/model/stok.dart';
import 'package:penjualan/repositories/db_helper.dart';
import 'package:penjualan/utils/common_dialog.dart';
import 'package:penjualan/utils/date_formatter.dart';
import 'package:penjualan/utils/select_barang.dart';
import 'package:penjualan/utils/string_formatter.dart';
import 'package:sqflite/sqflite.dart';

import 'detail_jual_view.dart';

class DetailJual extends StatefulWidget {
  final DJual? editDJual;
  DetailJual({this.editDJual});
  @override
  State<StatefulWidget> createState() => DetailJualView();
}

abstract class DetailJualController extends State<DetailJual> {
  final formKey = GlobalKey<FormBuilderState>();

  final TextEditingController quantityController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  final TextEditingController subtotalController = TextEditingController();

  bool onError = false;

  List<DJual>? djualList = <DJual>[];
  int? kategori = 0;
  int? idSatuan = 0;
  Stok? barang;
  List<Kategori>? listKategori;
  List<Satuan>? listSatuan;

  @override
  void initState() {
    initForm();

    super.initState();
  }

  initForm() async {
    fetchKategori();
    fetchSatuan();
    if (widget.editDJual != null) {
      Database? db = await DatabaseHelper.instance.database;

      var result = await db?.rawQuery(
          "SELECT * FROM STOK WHERE NAMA_BARANG = ?",
          [widget.editDJual?.nmBarang ?? '']);
      setState(() {
        if ((result?.length ?? 0) > 0) {
          barang = Stok.fromMap(result![0]);
        } else {
          barang = Stok(namaBarang: widget.editDJual?.nmBarang ?? '');
        }
        idSatuan = listSatuan!
            .where((element) =>
                element.nmSatuan == (widget.editDJual?.satuan ?? ''))
            .first
            .idSatuan;
        quantityController.text =
            thousandSeparator(widget.editDJual?.quantity ?? 0, separator: '.');
        hargaController.text = thousandSeparator(
            widget.editDJual?.hargaBarang ?? 0,
            separator: '.');
        calculateSubtotal(
          harga: hargaController.text.isEmpty
              ? 0
              : int.parse(
                  extractNumber(
                    value: hargaController.text,
                  ),
                ),
          qty: quantityController.text.isEmpty
              ? 0
              : int.parse(
                  extractNumber(
                    value: quantityController.text,
                  ),
                ),
        );
      });
    } else {}
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

  fetchSatuan() async {
    Database? db = await DatabaseHelper.instance.database;

    var result = await db?.rawQuery("SELECT * FROM SATUAN");

    if ((result?.length ?? 0) > 0) {
      setState(
        () {
          listSatuan =
              List<Satuan>.from(result!.map((map) => Satuan.fromMap(map)));
          listSatuan?.insert(
            0,
            Satuan(idSatuan: 0, nmSatuan: ''),
          );
        },
      );
    }
  }

  bool validateForm() {
    bool flag = true;
    if (!formKey.currentState!.validate()) flag = false;

    if (idSatuan == 0) flag = false;
    if (quantityController.text.isEmpty) flag = false;
    if (hargaController.text.isEmpty) flag = false;

    return flag;
  }

  submitForm() async {
    if (validateForm()) {
      print('sdfs');
      // Database? db = await DatabaseHelper.instance.database;
      Navigator.pop(
        context,
        DJual(
          nmBarang: barang?.namaBarang ?? '',
          quantity: int.parse(extractNumber(value: quantityController.text)),
          hargaBarang: int.parse(extractNumber(value: hargaController.text)),
          subtotal: int.parse(extractNumber(value: subtotalController.text)),
          satuan: listSatuan!
              .where((element) => element.idSatuan == idSatuan)
              .first
              .nmSatuan,
        ),
      );
    } else {
      setState(() {
        onError = true;
      });
    }
  }

  showDialogBarang(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    return popupDialogAutoComplete(
      context,
      selectWidget: SelectBarang(
        (barang) {
          print(barang.namaBarang);
          setState(() {
            this.barang = barang;
            kategori = barang.idKategori ?? 0;
            hargaController.text =
                thousandSeparator(barang.harga ?? 0, separator: '.');
            calculateSubtotal(
              harga: hargaController.text.isEmpty
                  ? 0
                  : int.parse(
                      extractNumber(
                        value: hargaController.text,
                      ),
                    ),
              qty: quantityController.text.isEmpty
                  ? 0
                  : int.parse(
                      extractNumber(
                        value: quantityController.text,
                      ),
                    ),
            );
          });
          Navigator.of(context, rootNavigator: true).pop();
          // _getAgencyInfo();
        },
      ),
    );
  }

  calculateSubtotal({required int harga, required int qty}) {
    setState(() {
      subtotalController.text = thousandSeparator(harga * qty, separator: '.');
    });
  }
}
