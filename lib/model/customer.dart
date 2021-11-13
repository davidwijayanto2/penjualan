class Customer {
  int? idCustomer;
  String? nmCustomer;
  String? noTelp;
  String? alamat;
  String? email;
  String? status;
  String? hargaKhusus;

  Customer({
    this.idCustomer,
    this.nmCustomer,
    this.noTelp,
    this.alamat,
    this.email,
    this.status,
    this.hargaKhusus,
  });

  Customer.fromMap(Map<String, dynamic> map)
      : idCustomer = map['ID_CUSTOMER'],
        nmCustomer = map['NM_CUSTOMER'],
        noTelp = map['NO_TLP'],
        alamat = map['ALAMAT'],
        email = map['EMAIL'],
        status = map['STATUS'],
        hargaKhusus = map['HARGA_KHUSUS'];
}
