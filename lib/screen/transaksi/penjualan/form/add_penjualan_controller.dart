import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:penjualan/model/customer.dart';
import 'package:penjualan/model/kategori.dart';
import 'package:penjualan/model/penjualan.dart';
import 'package:penjualan/model/stok.dart';
import 'package:penjualan/repositories/db_helper.dart';
import 'package:penjualan/repositories/local_storage.dart';
import 'package:penjualan/utils/common_dialog.dart';
import 'package:penjualan/utils/date_formatter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:penjualan/utils/select_customer.dart';
import 'package:penjualan/utils/string_formatter.dart';
import 'package:sqflite/sqflite.dart';

import 'add_penjualan_view.dart';

class AddPenjualan extends StatefulWidget {
  final HJual? editHJual;
  AddPenjualan({this.editHJual});
  @override
  State<StatefulWidget> createState() => AddPenjualanView();
}

abstract class AddPenjualanController extends State<AddPenjualan> {
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
  List<DJual>? djualList = <DJual>[];
  int? kategori = 0;
  int quantityTotal = 0;
  String dateTextStr = '';
  DateTime datePicked = DateTime.now();
  Customer? customer;
  List<Kategori>? listKategori;

  @override
  void initState() {
    initForm();

    super.initState();
  }

  initForm() async {
    fetchKategori();
    if (widget.editHJual != null) {
      fetchDataDjual();
      Database? db = await DatabaseHelper.instance.database;
      var result = await db?.rawQuery(
          "SELECT * FROM CUSTOMER WHERE upper(nm_customer)=?",
          [widget.editHJual?.nmCustomer ?? '']);
      if ((result?.length ?? 0) > 0) {
        customer = Customer.fromMap(result![0]);
      } else {
        customer = Customer(nmCustomer: widget.editHJual?.nmCustomer ?? '');
      }
      setState(() {
        dateTextStr = DateFormatter.toLongDateText(
            context, DateTime.parse(widget.editHJual?.tglTransaksi ?? ''));
        noNotaController.text = widget.editHJual?.nonota ?? '';
        keteranganController.text = widget.editHJual?.keterangan ?? '';
        keterangan2Controller.text = widget.editHJual?.rekening ?? '';
        discountController.text = thousandSeparator(
            widget.editHJual?.potongan ?? '0',
            separator: '.');
        dibayarkanController.text = thousandSeparator(
            widget.editHJual?.dibayarkan ?? '0',
            separator: '.');

        calculateTotal();
      });
    } else {
      setState(() {
        dateTextStr = DateFormatter.toLongDateText(context, DateTime.now());
      });
    }
    discountController.addListener(() {
      if (mounted) {
        discountDebouncer.value = discountController.text.trim().toLowerCase();
      }
    });
    discountDebouncer.values.listen((text) {
      if (mounted) {
        calculateTotal();
      }
    });
    dibayarkanController.addListener(() {
      if (mounted) {
        dibayarDebouncer.value = dibayarkanController.text.trim().toLowerCase();
      }
    });
    dibayarDebouncer.values.listen((text) {
      if (mounted) {
        calculateSisa();
      }
    });
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

  fetchDataDjual() async {
    Database? db = await DatabaseHelper.instance.database;
    var result;
    result = await db?.rawQuery(
        "SELECT * FROM d_jual WHERE ID_HJUAL = ?", [widget.editHJual!.idHjual]);
    djualList = List<DJual>.from(result.map((map) => DJual.fromMap(map)));
  }

  bool validateForm() {
    bool flag = true;
    if (!formKey.currentState!.validate()) flag = false;
    if (customer == null) flag = false;
    if ((djualList ?? <DJual>[]).isEmpty) flag = false;
    if (dibayarkanController.text.trim().isEmpty) flag = false;
    return flag;
  }

  submitForm() async {
    if (validateForm()) {
      Database? db = await DatabaseHelper.instance.database;
      var user = LocalStorage.userLogin();
      if (widget.editHJual != null) {
        await db?.rawUpdate(
            'UPDATE h_jual set TGL_TRANSAKSI = ?, NM_KARYAWAN = ?, NM_CUSTOMER = ?, QUANTITY_TOTAL = ?, GRANDTOTAL = ?, DIBAYARKAN = ?, SISA = ?, NONOTA = ?, KETERANGAN = ?, KOTA = ?, POTONGAN = ?, REKENING = ? WHERE ID_HJUAL = ?',
            [
              DateFormatter.dateTimeToDBFormat(datePicked),
              user?.nmKaryawan ?? '',
              customer?.nmCustomer ?? '',
              quantityTotal,
              int.parse(extractNumber(value: grandTotalController.text)),
              int.parse(extractNumber(value: dibayarkanController.text)),
              int.parse(extractNumber(value: sisaController.text)),
              noNotaController.text.trim(),
              keteranganController.text.trim(),
              kotaController.text.trim(),
              int.parse(extractNumber(value: discountController.text)),
              keterangan2Controller.text.trim(),
              widget.editHJual?.idHjual ?? '',
            ]).then((value) async {
          if (customer?.idCustomer == null) {
            await db.rawInsert(
                'INSERT INTO customer(NM_CUSTOMER,NO_TLP,ALAMAT,EMAIL,STATUS,HARGA_KHUSUS) VALUES(?,?,?,?,?,?)',
                [
                  customer?.nmCustomer ?? '',
                  '',
                  '',
                  '',
                  '',
                  'TIDAK',
                ]);
          }
          await db.rawDelete('DELETE FROM d_jual WHERE ID_HJUAL = ?',
              [widget.editHJual?.idHjual]);
          Batch batch = db.batch();
          djualList?.forEach((djual) async {
            batch.insert('d_jual', {
              'ID_HJUAL': widget.editHJual?.idHjual ?? '',
              'NM_BARANG': djual.nmBarang,
              'SATUAN': djual.satuan,
              'QUANTITY': djual.quantity,
              'HARGA_BARANG': djual.hargaBarang,
              'SUBTOTAL': djual.subtotal,
            });
            var result = await db.rawQuery(
                "SELECT * FROM stok WHERE NAMA_BARANG = ?", [djual.nmBarang]);
            if (result.isEmpty) {
              batch.insert('stok', {
                'ID_KATEGORI': '0',
                'NAMA_BARANG': djual.nmBarang,
                'QUANTITY': 0,
                'HARGA': djual.hargaBarang,
                'STATUS': '1',
              });
            }
          });
          batch.commit();
          Fluttertoast.showToast(msg: 'Transaction has been saved');
          Navigator.pop(context);
        }).catchError((onError) {
          Fluttertoast.showToast(msg: 'Error when store to database');
        });
      } else {
        var res = await db?.rawQuery(
            "SELECT * FROM h_jual WHERE strftime('%m',TGL_TRANSAKSI) = ? AND strftime('%Y',TGL_TRANSAKSI) = ? ORDER BY ID_HJUAL DESC LIMIT 1",
            [
              DateFormatter.getMonth(DateTime.now()),
              DateFormatter.getYear(DateTime.now())
            ]);

        List<HJual> hjuallist =
            List<HJual>.from((res ?? []).map((map) => HJual.fromMap(map)));
        String idHjual = '';
        if (hjuallist.length > 0) {
          HJual hjual = hjuallist.first;
          var id = hjual.idHjual?.split('/');
          idHjual = (int.parse(id![0]) + 1).toString().padLeft(4, '0') +
              '/' +
              DateFormatter.getMonth(DateTime.now()) +
              '/' +
              DateFormatter.getYear(DateTime.now());
        } else {
          idHjual = '0001' +
              '/' +
              DateFormatter.getMonth(DateTime.now()) +
              '/' +
              DateFormatter.getYear(DateTime.now());
        }

        await db?.rawInsert(
            'INSERT INTO h_jual VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)', [
          idHjual,
          DateFormatter.dateTimeToDBFormat(datePicked),
          user?.nmKaryawan ?? '',
          customer?.nmCustomer ?? '',
          quantityTotal,
          int.parse(extractNumber(value: grandTotalController.text)),
          int.parse(extractNumber(value: dibayarkanController.text)),
          int.parse(extractNumber(value: sisaController.text)),
          noNotaController.text.trim(),
          keteranganController.text.trim(),
          kotaController.text.trim(),
          discountController.text.isEmpty
              ? '0'
              : int.parse(extractNumber(value: discountController.text)),
          keterangan2Controller.text.trim(),
        ]).then((value) async {
          if (customer?.idCustomer == null) {
            await db.rawInsert(
                'INSERT INTO customer(NM_CUSTOMER,NO_TLP,ALAMAT,EMAIL,STATUS,HARGA_KHUSUS) VALUES(?,?,?,?,?,?)',
                [
                  customer?.nmCustomer ?? '',
                  '',
                  '',
                  '',
                  '',
                  'TIDAK',
                ]);
          }
          Batch batch = db.batch();
          djualList?.forEach((djual) async {
            batch.insert('d_jual', {
              'ID_HJUAL': idHjual,
              'NM_BARANG': djual.nmBarang,
              'SATUAN': djual.satuan,
              'QUANTITY': djual.quantity,
              'HARGA_BARANG': djual.hargaBarang,
              'SUBTOTAL': djual.subtotal,
            });
            var result = await db.rawQuery(
                "SELECT * FROM stok WHERE NAMA_BARANG = ?", [djual.nmBarang]);
            if (result.isEmpty) {
              batch.insert('stok', {
                'ID_KATEGORI': '0',
                'NAMA_BARANG': djual.nmBarang,
                'QUANTITY': 0,
                'HARGA': djual.hargaBarang,
                'STATUS': '1',
              });
            }
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

  addDjualList(DJual djual, int? _index) {
    setState(() {
      if (_index != null) {
        if (djualList?[_index].nmBarang != djual.nmBarang) {
          int index = (djualList ?? <DJual>[])
              .indexWhere((element) => element.nmBarang == djual.nmBarang);
          if (index > -1) {
            (djualList ?? <DJual>[])[index].quantity =
                ((djualList ?? <DJual>[])[index].quantity ?? 0) +
                    (djual.quantity ?? 0);
            calculateSubtotal(djual: (djualList ?? <DJual>[])[index]);
            djualList?.removeAt(_index);
          } else {
            // (djualList ?? <DJual>[]).insert(_index, djual);
            djualList?[_index] = djual;
            calculateSubtotal(djual: (djualList ?? <DJual>[])[_index]);
          }
        } else {
          djualList?[_index] = djual;
          calculateSubtotal(djual: (djualList ?? <DJual>[])[_index]);
        }
      } else {
        int index = (djualList ?? <DJual>[])
            .indexWhere((element) => element.nmBarang == djual.nmBarang);
        if (index > -1) {
          (djualList ?? <DJual>[])[index].quantity =
              ((djualList ?? <DJual>[])[index].quantity ?? 0) +
                  (djual.quantity ?? 0);
          calculateSubtotal(djual: (djualList ?? <DJual>[])[index]);
        } else {
          (djualList ?? <DJual>[]).add(djual);
        }
      }
    });
  }

  showDialogCustomer(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    return popupDialogAutoComplete(
      context,
      selectWidget: SelectCustomer(
        (customer) {
          setState(() {
            this.customer = customer;
          });
          Navigator.of(context, rootNavigator: true).pop();
        },
      ),
    );
  }

  calculateTotal() {
    var total = 0, grandTotal = 0;
    for (int i = 0; i < (djualList ?? []).length; i++) {
      total = total + (djualList?[i].subtotal ?? 0);
    }
    grandTotal = total -
        int.parse(discountController.text.isEmpty
            ? '0'
            : extractNumber(value: discountController.text));
    totalController.text = thousandSeparator(total, separator: '.');
    grandTotalController.text = thousandSeparator(grandTotal, separator: '.');
    calculateSisa();
    calculateQtyTotal();
  }

  calculateSisa() {
    if (dibayarkanController.text.trim().isNotEmpty) {
      var grandTotal =
          int.parse(extractNumber(value: grandTotalController.text));
      sisaController.text = thousandSeparator(
          grandTotal -
              int.parse(extractNumber(value: dibayarkanController.text)),
          separator: '.');
    }
  }

  calculateSubtotal({required DJual djual}) {
    setState(() {
      djual.subtotal = (djual.hargaBarang ?? 0) * (djual.quantity ?? 0);
      calculateQtyTotal();
    });
  }

  calculateQtyTotal() {
    var qty = 0;
    djualList?.forEach((djual) {
      qty = qty + (djual.quantity ?? 0);
    });
    quantityTotal = qty;
  }

  showDialogDelete(DJual djual) {
    PopupDialog(
      context: context,
      titleText: 'Hapus Data',
      subtitleText: 'Apakah Anda yakin akan menghapus data ini?',
      icon: FontAwesomeIcons.exclamationCircle,
      iconColor: Colors.red,
      rightButtonAction: (_) async {
        Navigator.pop(context);
        djualList?.remove(djual);
        calculateSubtotal(djual: djual);
        calculateTotal();
      },
      rightButtonColor: Colors.red,
    );
  }

  HJual getHjualFromForm() {
    var user = LocalStorage.userLogin();
    return HJual(
      idHjual: null,
      tglTransaksi: DateFormatter.dateTimeToDBFormat(datePicked),
      nmKaryawan: user?.nmKaryawan ?? '',
      nmCustomer: customer?.nmCustomer ?? '',
      quantityTotal: quantityTotal,
      grandTotal: grandTotalController.text.isEmpty
          ? 0
          : int.parse(extractNumber(value: grandTotalController.text)),
      dibayarkan: dibayarkanController.text.isEmpty
          ? 0
          : int.parse(extractNumber(value: dibayarkanController.text)),
      sisa: sisaController.text.isEmpty
          ? 0
          : int.parse(extractNumber(value: sisaController.text)),
      nonota: noNotaController.text.trim(),
      keterangan: keteranganController.text.trim(),
      kota: kotaController.text.trim(),
      potongan: discountController.text.isEmpty
          ? 0
          : int.parse(extractNumber(value: discountController.text)),
      rekening: keterangan2Controller.text.trim(),
    );
  }
}
