import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:penjualan/model/customer.dart';
import 'package:penjualan/model/kategori.dart';
import 'package:penjualan/model/pembelian.dart';
import 'package:penjualan/model/penjualan.dart';
import 'package:penjualan/model/satuan.dart';
import 'package:penjualan/model/stok.dart';
import 'package:penjualan/repositories/db_helper.dart';
import 'package:penjualan/utils/common_dialog.dart';
import 'package:penjualan/utils/date_formatter.dart';
import 'package:penjualan/utils/select_barang.dart';
import 'package:penjualan/utils/string_formatter.dart';
import 'package:sqflite/sqflite.dart';
import 'detail_beli_view.dart';

class DetailBeli extends StatefulWidget {
  final Dbeli? editDBeli;
  DetailBeli({this.editDBeli});
  @override
  State<StatefulWidget> createState() => DetailBeliView();
}

abstract class DetailBeliController extends State<DetailBeli> {
  final formKey = GlobalKey<FormBuilderState>();

  final TextEditingController quantityController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  final TextEditingController subtotalController = TextEditingController();

  bool onError = false;

  List<Dbeli>? dbeliList = <Dbeli>[];
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
    if (widget.editDBeli != null) {
      Database? db = await DatabaseHelper.instance.database;

      var result = await db?.rawQuery(
          "SELECT * FROM STOK WHERE NAMA_BARANG = ?",
          [widget.editDBeli?.nmBarang ?? '']);
      setState(() {
        if ((result?.length ?? 0) > 0) {
          barang = Stok.fromMap(result![0]);
        } else {
          barang = Stok(namaBarang: widget.editDBeli?.nmBarang ?? '');
        }
        idSatuan = listSatuan!
            .where((element) =>
                element.nmSatuan == (widget.editDBeli?.satuan ?? ''))
            .first
            .idSatuan;
        quantityController.text =
            thousandSeparator(widget.editDBeli?.quantity ?? 0, separator: '.');
        hargaController.text = thousandSeparator(
            widget.editDBeli?.hargaBarang ?? 0,
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
        Dbeli(
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
