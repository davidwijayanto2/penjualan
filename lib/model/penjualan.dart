class HJual {
  String? idHjual;
  String? tglTransaksi;
  String? nmKaryawan;
  String? nmCustomer;
  int? quantityTotal;
  int? grandTotal;
  int? dibayarkan;
  int? sisa;
  String? nonota;
  String? keterangan;
  String? kota;
  int? potongan;
  String? rekening;

  HJual({
    this.idHjual,
    this.tglTransaksi,
    this.nmKaryawan,
    this.nmCustomer,
    this.quantityTotal,
    this.grandTotal,
    this.dibayarkan,
    this.sisa,
    this.nonota,
    this.keterangan,
    this.kota,
    this.potongan,
    this.rekening,
  });

  HJual.fromMap(Map<String, dynamic> map)
      : idHjual = map['ID_HJUAL'],
        tglTransaksi = map['TGL_TRANSAKSI'],
        nmKaryawan = map['NM_KARYAWAN'],
        nmCustomer = map['NM_CUSTOMER'],
        quantityTotal = map['QUANTITY_TOTAL'],
        grandTotal = map['GRANTOTAL'],
        dibayarkan = map['DIBAYARKAN'],
        sisa = map['SISA'],
        nonota = map['NONOTA'],
        keterangan = map['KETERANGAN'],
        kota = map['KOTA'],
        potongan = map['POTONGAN'],
        rekening = map['REKENING'];
}

class Djual {
  int? idDjual;
  String? idHjual;
  String? nmBarang;
  String? satuan;
  String? quantity;
  String? hargaBarang;
  String? subtotal;

  Djual.fromMap(Map<String, dynamic> map)
      : idDjual = map['ID_DJUAL'],
        idHjual = map['ID_HJUAL'],
        nmBarang = map['NM_BARANG'],
        satuan = map['SATUAN'],
        quantity = map['QUANTITY'],
        hargaBarang = map['HARGA_BARANG'],
        subtotal = map['SUBTOTAL'];
}
