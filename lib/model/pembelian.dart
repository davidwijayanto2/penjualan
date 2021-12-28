class HBeli {
  String? idHbeli;
  String? tglTransaksi;
  String? nmKaryawan;
  String? nmSupplier;
  int? quantityTotal;
  int? grandTotal;
  String? nonota;
  String? keterangan;

  HBeli({
    this.idHbeli,
    this.tglTransaksi,
    this.nmKaryawan,
    this.nmSupplier,
    this.quantityTotal,
    this.grandTotal,
    this.nonota,
    this.keterangan,
  });

  HBeli.fromMap(Map<String, dynamic> map)
      : idHbeli = map['ID_HBELI'],
        tglTransaksi = map['TANGGAL_BELI'],
        nmKaryawan = map['NM_KARYAWAN'],
        nmSupplier = map['NM_SUPPLIER'],
        quantityTotal = map['QUANTITY_TOTAL'],
        grandTotal = map['GRANDTOTAL'],
        nonota = map['BUKTI_NOTA'],
        keterangan = map['KETERANGAN'];
}

class Dbeli {
  int? idDbeli;
  String? idHbeli;
  String? nmBarang;
  String? satuan;
  int? quantity;
  int? hargaBarang;
  int? subtotal;

  Dbeli({
    this.idDbeli,
    this.idHbeli,
    this.nmBarang,
    this.satuan,
    this.quantity,
    this.hargaBarang,
    this.subtotal,
  });

  Dbeli.fromMap(Map<String, dynamic> map)
      : idDbeli = map['ID_DBELI'],
        idHbeli = map['ID_HBELI'],
        nmBarang = map['NM_BARANG'],
        satuan = map['SATUAN'],
        quantity = map['QUANTITY'],
        hargaBarang = map['HARGA_BARANG'],
        subtotal = map['SUBTOTAL'];
}
