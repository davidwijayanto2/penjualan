class StokMasuk {
  String? nmBarang;
  int? jumlah;

  StokMasuk({
    this.nmBarang,
    this.jumlah,
  });

  StokMasuk.fromMap(Map<String, dynamic> map)
      : nmBarang = map['NAMA_BARANG'],
        jumlah = map['JUMLAH'];
}
