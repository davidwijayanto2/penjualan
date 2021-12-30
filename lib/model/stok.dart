class Stok {
  int? idStok;
  int? idKategori;
  String? nmKategori;
  String? namaBarang;
  int? quantity;
  int? harga;
  int? status;

  Stok({
    this.idStok,
    this.idKategori,
    this.nmKategori,
    this.namaBarang,
    this.harga,
    this.status,
  });

  Stok.fromMap(Map<String, dynamic> map)
      : idStok = map['ID_STOK'],
        idKategori = map['ID_KATEGORI'] == '' ? 0 : map['ID_KATEGORI'],
        nmKategori = map['NM_KATEGORI'],
        namaBarang = map['NAMA_BARANG'],
        harga = map['HARGA'],
        quantity = map['QUANTITY'] as int,
        status = map['STATUS'];
}
