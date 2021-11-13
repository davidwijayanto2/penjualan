class User {
  String? idKaryawan;
  int? idJabatan;
  String? nmKaryawan;
  String? noTelp;
  String? alamat;
  String? email;
  String? username;
  String? status;

  User({
    this.idKaryawan,
    this.idJabatan,
    this.nmKaryawan,
    this.noTelp,
    this.alamat,
    this.email,
    this.username,
    this.status,
  });
  User.fromMap(Map<String, dynamic> map)
      : idKaryawan = map['ID_KARYAWAN'],
        idJabatan = map['ID_JABATAN'],
        nmKaryawan = map['NM_KARYAWAN'],
        noTelp = map['NO_TLP'],
        alamat = map['ALAMAT'],
        email = map['EMAIL'],
        username = map['USERNAME'],
        status = map['STATUS'];
}
