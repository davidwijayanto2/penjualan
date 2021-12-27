class StokKeluar {
  String? nmBarang;
  int? jumlah;

  StokKeluar({
    this.nmBarang,
    this.jumlah,
  });

  StokKeluar.fromMap(Map<String, dynamic> map)
      : nmBarang = map['NAMA_BARANG'],
        jumlah = map['JUMLAH'];
}
