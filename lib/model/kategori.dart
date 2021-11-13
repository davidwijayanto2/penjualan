class Kategori {
  int? idKategori;
  String? nmKategori;
  String? status;

  Kategori({
    this.idKategori,
    this.nmKategori,
    this.status,
  });

  Kategori.fromMap(Map<String, dynamic> map)
      : idKategori = map['ID_KATEGORI'],
        nmKategori = map['NM_KATEGORI'],
        status = map['STATUS'];
}
