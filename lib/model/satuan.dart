class Satuan {
  int? idSatuan;
  String? nmSatuan;

  Satuan({
    this.idSatuan,
    this.nmSatuan,
  });

  Satuan.fromMap(Map<String, dynamic> map)
      : idSatuan = map['ID'],
        nmSatuan = map['NAMA_SATUAN'];
}
