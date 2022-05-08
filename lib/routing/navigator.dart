import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:penjualan/model/customer.dart';
import 'package:penjualan/model/penjualan.dart';
import 'package:penjualan/model/pembelian.dart';
import 'package:penjualan/model/kategori.dart';
import 'package:penjualan/model/stok.dart';
import 'package:penjualan/model/satuan.dart';
import 'package:penjualan/routing/router_const.dart';
import 'package:penjualan/screen/laporan/pembelian/print_laporan.dart';
import 'package:penjualan/screen/laporan/penjualan/print_laporan.dart';
import 'package:penjualan/screen/master/barang/form/add_master_barang_controller.dart';
import 'package:penjualan/screen/master/customer/form/add_master_customer_controller.dart';
import 'package:penjualan/screen/master/kategori/form/add_master_kategori_controller.dart';
import 'package:penjualan/screen/master/satuan/form/add_master_satuan_controller.dart';
import 'package:penjualan/screen/transaksi/pembelian/form/detail_beli/detail_beli_controller.dart';
import 'package:penjualan/screen/transaksi/pembelian/form/print_nota_beli.dart';
import 'package:penjualan/screen/transaksi/pembelian/form/print_nota_beli_logo.dart';
import 'package:penjualan/screen/transaksi/penjualan/form/add_penjualan_controller.dart';
import 'package:penjualan/screen/transaksi/penjualan/form/detail_jual/detail_jual_controller.dart';
import 'package:penjualan/screen/transaksi/pembelian/form/add_pembelian_controller.dart';
import 'package:penjualan/screen/transaksi/penjualan/form/print_nota.dart';

import '../screen/transaksi/penjualan/form/print_nota_logo.dart';

goToHome(BuildContext context) async {
  Navigator.pushNamed(context, homeRoute);
}

replaceToHome(BuildContext context) async {
  Navigator.pushNamedAndRemoveUntil(context, homeRoute, (route) => false);
}

goToLogin(BuildContext context) async {
  Navigator.pushNamed(context, loginRoute);
}

replaceToLogin(BuildContext context) {
  Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route) => false);
}

goToMasterBarang<R>({
  required BuildContext context,
  FutureOr<R> Function(dynamic)? afterOpen,
}) {
  if (afterOpen != null) {
    Navigator.pushNamed(context, masterBarangRoute).then(afterOpen);
  } else {
    Navigator.pushNamed(context, masterBarangRoute);
  }
}

goToAddMasterBarang<R>({
  required BuildContext context,
  Stok? editStok,
  FutureOr<R> Function(dynamic)? afterOpen,
}) {
  if (afterOpen != null) {
    Navigator.pushNamed(context, addMasterBarangRoute,
        arguments: AddMasterBarang(
          editStok: editStok,
        )).then(afterOpen);
  } else {
    Navigator.pushNamed(context, addMasterBarangRoute,
        arguments: AddMasterBarang(
          editStok: editStok,
        ));
  }
}

goToMasterCustomer<R>({
  required BuildContext context,
  FutureOr<R> Function(dynamic)? afterOpen,
}) {
  if (afterOpen != null) {
    Navigator.pushNamed(context, masterCustomerRoute).then(afterOpen);
  } else {
    Navigator.pushNamed(context, masterCustomerRoute);
  }
}

goToAddMasterCustomer<R>({
  required BuildContext context,
  Customer? editCustomer,
  FutureOr<R> Function(dynamic)? afterOpen,
}) {
  if (afterOpen != null) {
    Navigator.pushNamed(context, addMasterCustomerRoute,
        arguments: AddMasterCustomer(
          editCustomer: editCustomer,
        )).then(afterOpen);
  } else {
    Navigator.pushNamed(context, addMasterCustomerRoute,
        arguments: AddMasterCustomer(
          editCustomer: editCustomer,
        ));
  }
}

goToMasterKategori<R>({
  required BuildContext context,
  FutureOr<R> Function(dynamic)? afterOpen,
}) {
  if (afterOpen != null) {
    Navigator.pushNamed(context, masterKategoriRoute).then(afterOpen);
  } else {
    Navigator.pushNamed(context, masterKategoriRoute);
  }
}

goToAddMasterKategori<R>({
  required BuildContext context,
  Kategori? editKategori,
  FutureOr<R> Function(dynamic)? afterOpen,
}) {
  if (afterOpen != null) {
    Navigator.pushNamed(context, addMasterKategoriRoute,
        arguments: AddMasterKategori(
          editKategori: editKategori,
        )).then(afterOpen);
  } else {
    Navigator.pushNamed(context, addMasterKategoriRoute,
        arguments: AddMasterKategori(
          editKategori: editKategori,
        ));
  }
}

goToMasterSatuan<R>({
  required BuildContext context,
  FutureOr<R> Function(dynamic)? afterOpen,
}) {
  if (afterOpen != null) {
    Navigator.pushNamed(context, masterSatuanRoute).then(afterOpen);
  } else {
    Navigator.pushNamed(context, masterSatuanRoute);
  }
}

goToAddMasterSatuan<R>({
  required BuildContext context,
  Satuan? editsatuan,
  FutureOr<R> Function(dynamic)? afterOpen,
}) {
  if (afterOpen != null) {
    Navigator.pushNamed(context, addMasterSatuanRoute,
        arguments: AddMasterSatuan(
          editSatuan: editsatuan,
        )).then(afterOpen);
  } else {
    Navigator.pushNamed(context, addMasterSatuanRoute,
        arguments: AddMasterSatuan(
          editSatuan: editsatuan,
        ));
  }
}

goToTransaksiPenjualan<R>({
  required BuildContext context,
  FutureOr<R> Function(dynamic)? afterOpen,
}) {
  if (afterOpen != null) {
    Navigator.pushNamed(context, penjualanRoute).then(afterOpen);
  } else {
    Navigator.pushNamed(context, penjualanRoute);
  }
}

goToAddTransaksiPenjualan<R>({
  required BuildContext context,
  HJual? editHJual,
  FutureOr<R> Function(dynamic)? afterOpen,
}) {
  if (afterOpen != null) {
    Navigator.pushNamed(context, addPenjualanRoute,
        arguments: AddPenjualan(
          editHJual: editHJual,
        )).then(afterOpen);
  } else {
    Navigator.pushNamed(context, addPenjualanRoute,
        arguments: AddPenjualan(
          editHJual: editHJual,
        ));
  }
}

goToAddDetailJual<R>({
  required BuildContext context,
  DJual? editDJual,
  Customer? customer,
  FutureOr<R> Function(dynamic)? afterOpen,
}) {
  if (afterOpen != null) {
    Navigator.pushNamed(context, detailJualRoute,
        arguments: DetailJual(
          editDJual: editDJual,
          customer: customer,
        )).then(afterOpen);
  } else {
    Navigator.pushNamed(context, detailJualRoute,
        arguments: DetailJual(
          editDJual: editDJual,
          customer: customer,
        ));
  }
}

goToTransaksiPembelian<R>({
  required BuildContext context,
  FutureOr<R> Function(dynamic)? afterOpen,
}) {
  if (afterOpen != null) {
    Navigator.pushNamed(context, pembelianRoute).then(afterOpen);
  } else {
    Navigator.pushNamed(context, pembelianRoute);
  }
}

goToAddTransaksiPembelian<R>({
  required BuildContext context,
  HBeli? editHBeli,
  FutureOr<R> Function(dynamic)? afterOpen,
}) {
  if (afterOpen != null) {
    Navigator.pushNamed(context, addPembelianRoute,
        arguments: AddPembelian(
          editHbeli: editHBeli,
        )).then(afterOpen);
  } else {
    Navigator.pushNamed(context, addPembelianRoute,
        arguments: AddPembelian(
          editHbeli: editHBeli,
        ));
  }
}

goToAddDetailBeli<R>({
  required BuildContext context,
  Dbeli? editDBeli,
  FutureOr<R> Function(dynamic)? afterOpen,
}) {
  if (afterOpen != null) {
    Navigator.pushNamed(context, detailBeliRoute,
        arguments: DetailBeli(
          editDBeli: editDBeli,
        )).then(afterOpen);
  } else {
    Navigator.pushNamed(context, detailBeliRoute,
        arguments: DetailBeli(
          editDBeli: editDBeli,
        ));
  }
}

goToPrintNota<R>({
  required BuildContext context,
  required HJual hJual,
  required List<DJual> dJualList,
  FutureOr<R> Function(dynamic)? afterOpen,
}) {
  if (afterOpen != null) {
    Navigator.pushNamed(context, printNotaRoute,
        arguments: PrintNota(
          hJual,
          dJualList,
        )).then(afterOpen);
  } else {
    Navigator.pushNamed(context, printNotaRoute,
        arguments: PrintNota(
          hJual,
          dJualList,
        ));
  }
}

goToPrintNotaLogo<R>({
  required BuildContext context,
  required HJual hJual,
  required List<DJual> dJualList,
  FutureOr<R> Function(dynamic)? afterOpen,
}) {
  if (afterOpen != null) {
    Navigator.pushNamed(context, printNotaLogoRoute,
        arguments: PrintNotaLogo(
          hJual,
          dJualList,
        )).then(afterOpen);
  } else {
    Navigator.pushNamed(context, printNotaLogoRoute,
        arguments: PrintNotaLogo(
          hJual,
          dJualList,
        ));
  }
}

goToPrintNotaBeli<R>({
  required BuildContext context,
  required HBeli hBeli,
  required List<Dbeli> dBeliList,
  FutureOr<R> Function(dynamic)? afterOpen,
}) {
  if (afterOpen != null) {
    Navigator.pushNamed(context, printNotaBeliRoute,
        arguments: PrintNotaBeli(
          hBeli,
          dBeliList,
        )).then(afterOpen);
  } else {
    Navigator.pushNamed(context, printNotaBeliRoute,
        arguments: PrintNotaBeli(
          hBeli,
          dBeliList,
        ));
  }
}

goToPrintNotaBeliLogo<R>({
  required BuildContext context,
  required HBeli hBeli,
  required List<Dbeli> dBeliList,
  FutureOr<R> Function(dynamic)? afterOpen,
}) {
  if (afterOpen != null) {
    Navigator.pushNamed(context, printNotaBeliLogoRoute,
        arguments: PrintNotaBeliLogo(
          hBeli,
          dBeliList,
        )).then(afterOpen);
  } else {
    Navigator.pushNamed(context, printNotaBeliLogoRoute,
        arguments: PrintNotaBeliLogo(
          hBeli,
          dBeliList,
        ));
  }
}

goToLaporanStokKeluar<R>({
  required BuildContext context,
  FutureOr<R> Function(dynamic)? afterOpen,
}) {
  if (afterOpen != null) {
    Navigator.pushNamed(context, laporanStokKeluarRoute).then(afterOpen);
  } else {
    Navigator.pushNamed(context, laporanStokKeluarRoute);
  }
}

goToLaporanStokMasuk<R>({
  required BuildContext context,
  FutureOr<R> Function(dynamic)? afterOpen,
}) {
  if (afterOpen != null) {
    Navigator.pushNamed(context, laporanStokMasukRoute).then(afterOpen);
  } else {
    Navigator.pushNamed(context, laporanStokMasukRoute);
  }
}

goToLaporanPenjualan<R>({
  required BuildContext context,
  FutureOr<R> Function(dynamic)? afterOpen,
}) {
  if (afterOpen != null) {
    Navigator.pushNamed(context, laporanPenjualanRoute).then(afterOpen);
  } else {
    Navigator.pushNamed(context, laporanPenjualanRoute);
  }
}

goToBackupRestore<R>({
  required BuildContext context,
  FutureOr<R> Function(dynamic)? afterOpen,
}) {
  if (afterOpen != null) {
    Navigator.pushNamed(context, backupRestoreRoute).then(afterOpen);
  } else {
    Navigator.pushNamed(context, backupRestoreRoute);
  }
}

goToBackupRestoreSebagian<R>({
  required BuildContext context,
  FutureOr<R> Function(dynamic)? afterOpen,
}) {
  if (afterOpen != null) {
    Navigator.pushNamed(context, backupRestoreSebagianRoute).then(afterOpen);
  } else {
    Navigator.pushNamed(context, backupRestoreSebagianRoute);
  }
}

goToLaporanPembelian<R>({
  required BuildContext context,
  FutureOr<R> Function(dynamic)? afterOpen,
}) {
  if (afterOpen != null) {
    Navigator.pushNamed(context, laporanPembelianRoute).then(afterOpen);
  } else {
    Navigator.pushNamed(context, laporanPembelianRoute);
  }
}

goToPrintLaporanPenjualan<R>({
  required BuildContext context,
  required String total,
  required List<HJual> hJualList,
  FutureOr<R> Function(dynamic)? afterOpen,
}) {
  if (afterOpen != null) {
    Navigator.pushNamed(context, printLaporanPenjualanRoute,
        arguments: PrintLaporanPenjualan(
          hJualList,
          total,
        )).then(afterOpen);
  } else {
    Navigator.pushNamed(context, printLaporanPenjualanRoute,
        arguments: PrintLaporanPenjualan(
          hJualList,
          total,
        ));
  }
}

goToPrintLaporanPembelian<R>({
  required BuildContext context,
  required String total,
  required List<HBeli> hBeliList,
  FutureOr<R> Function(dynamic)? afterOpen,
}) {
  if (afterOpen != null) {
    Navigator.pushNamed(context, printLaporanPembelianRoute,
        arguments: PrintLaporanPembelian(
          hBeliList,
          total,
        )).then(afterOpen);
  } else {
    Navigator.pushNamed(context, printLaporanPembelianRoute,
        arguments: PrintLaporanPembelian(
          hBeliList,
          total,
        ));
  }
}

goToAccount<R>({
  required BuildContext context,
  FutureOr<R> Function(dynamic)? afterOpen,
}) {
  if (afterOpen != null) {
    Navigator.pushNamed(context, accountRoute).then(afterOpen);
  } else {
    Navigator.pushNamed(context, accountRoute);
  }
}

goToBackupSelected<R>({
  required BuildContext context,
  FutureOr<R> Function(dynamic)? afterOpen,
}) {
  if (afterOpen != null) {
    Navigator.pushNamed(context, backupSelectedRoute).then(afterOpen);
  } else {
    Navigator.pushNamed(context, backupSelectedRoute);
  }
}
