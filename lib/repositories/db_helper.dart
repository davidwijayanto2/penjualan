import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database?> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await createDatabase();
    return _database;
  }

  createDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String dbpath = join(documentsDirectory.path, "db_ko_stefan");
    print('dbpath: ' + dbpath);
    return await openDatabase(dbpath, version: 1, onCreate: populateDb);
  }

  void populateDb(Database database, int version) async {
    await database.execute('''
          CREATE TABLE barang(
            ID_BARANG TEXT PRIMARY KEY,
            ID_KATEGORI TEXT,
            NM_BARANG TEXT,
            HARGA INTEGER,
            STATUS TEXT,            
          )''');

    await database.execute('''CREATE TABLE customer(
            ID_CUSTOMER INTEGER PRIMARY KEY AUTOINCREMENT,            
            NM_CUSTOMER TEXT,
            NO_TLP TEXT,
            ALAMAT TEXT,
            EMAIL TEXT,
            STATUS TEXT,
            HARGA_KHUSUS TEXT,
          )''');

    await database.execute('''CREATE TABLE h_beli(
            ID_HBELI TEXT PRIMARY KEY,
            NM_SUPPLIER TEXT,
            NM_KARYAWAN TEXT,
            GRANDTOTAL INTEGER,
            QUANTITY_TOTAL INTEGER,
            TANGGAL_BELI TEXT,
            BUKTI_NOTA TEXT,
            KETERANGAN TEXT
            )''');

    await database.execute('''CREATE TABLE h_jual(
            ID_HJUAL TEXT PRIMARY KEY,
            TGL_TRANSAKSI TEXT,
            NM_KARYAWAN TEXT,
            NM_CUSTOMER TEXT,
            QUANTITY_TOTAL INTEGER,
            GRANDTOTAL INTEGER,
            DIBAYARKAN INTEGER,
            SISA INTEGER,
            NONOTA TEXT,
            KETERANGAN TEXT,
            KOTA TEXT,
            POTONGAN INTEGER,
            REKENING TEXT,            
            )''');

    await database.execute('''CREATE TABLE d_beli(
            ID_DBELI INTEGER PRIMARY KEY AUTOINCREMENT,
            ID_HBELI TEXT,
            NM_BARANG TEXT,
            SATUAN TEXT,
            QUANTITY INT,
            HARGA_BARANG INT,
            SUBTOTAL INT,
            )''');

    await database.execute('''CREATE TABLE d_jual(
            ID_DJUAL INTEGER PRIMARY KEY AUTOINCREMENT,
            ID_HJUAL TEXT,
            NM_BARANG TEXT,
            SATUAN TEXT,
            QUANTITY INTEGER,
            HARGA_BARANG INTEGER,
            SUBTOTAL INTEGER,
            )''');

    await database.execute('''CREATE TABLE hutang(
            ID_HJUAL TEXT PRIMARY KEY,
            NAMA_CUSTOMER TEXT,
            NOMINAL INTEGER,
            TGL_JATUH_TEMPO TEXT,
            STATUS TEXT,
            TGL_BAYAR TEXT,
            NONOTA TEXT,
    )''');

    await database.execute('''CREATE TABLE jabatan(
            ID_JABATAN INTEGER PRIMARY KEY AUTOINCREMENT,
            NM_JABATAN TEXT,
            ACCESS TEXT,
            STATUS TEXT,            
            )''');

    await database.execute('''CREATE TABLE karyawan(
            ID_KARYAWAN TEXT PRIMARY KEY,
            ID_JABATAN INTEGER,
            NM_KARYAWAN TEXT,
            NO_TLP TEXT,            
            ALAMAT TEXT,
            EMAIL TEXT,
            USERNAME TEXT,
            PASSWORD TEXT,
            STATUS TEXT,
            )''');

    await database.execute('''CREATE TABLE kategori(
            ID_KATEGORI INTEGER PRIMARY KEY AUTOINCREMENT,
            NM_KATEGORI TEXT,
            STATUS TEXT,            
            )''');

    await database.execute('''CREATE TABLE mh_perusahaan(
            ID_PERUSAHAAN INTEGER PRIMARY KEY AUTOINCREMENT,
            NM_PERUSAHAAN TEXT,
            LOGO TEXT,
            )''');

    await database.execute('''CREATE TABLE mh_supplier(
            ID_SUPPLIER TEXT PRIMARY KEY,
            NM_SUPPLIER TEXT,
            NO_TLP TEXT,
            ALAMAT TEXT,
            EMAIL TEXT,
            STATUS TEXT,
            )''');

    await database.execute('''CREATE TABLE satuan(
            ID INTEGER PRIMARY KEY AUTOINCREMENT,
            NAMA_SATUAN TEXT,            
      )''');

    await database.execute('''CREATE TABLE stok(
            ID_STOK INTEGER PRIMARY KEY AUTOINCREMENT,
            ID_KATEGORI INT,
            NAMA_BARANG TEXT,
            QUANTITY INT,
            HARGA INT,
            STATUS INT,            
      )''');

    //create index
    await database
        .execute('''CREATE INDEX FK_DBELI_BARANG ON barang (ID_KATEGORI)''');
    await database
        .execute('''CREATE INDEX NM_CUSTOMER ON customer (NM_CUSTOMER)''');
    await database
        .execute('''CREATE INDEX FK_SUPPLIER ON h_beli (NM_SUPPLIER)''');
    await database
        .execute('''CREATE INDEX FK_KARYAWAN_NAME ON h_beli (NM_KARYAWAN)''');
    await database
        .execute('''CREATE INDEX FK_KARYAWAN ON h_jual (NM_KARYAWAN)''');
    await database
        .execute('''CREATE INDEX FK_CUSTOMER ON h_jual (NM_CUSTOMER)''');
    await database
        .execute('''CREATE INDEX FK_DBELI_BARANG ON d_beli (SATUAN)''');
    await database.execute('''CREATE INDEX FK_HBELI ON d_beli (ID_HBELI)''');
    await database.execute('''CREATE INDEX FK_ID_HJUAL ON d_jual (ID_HJUAL)''');
    await database.execute('''CREATE INDEX FK_ID_BARANG ON d_jual (SATUAN)''');
    await database
        .execute('''CREATE INDEX NM_KARYAWAN ON karyawan (NM_KARYAWAN)''');
    await database
        .execute('''CREATE INDEX NM_SUPPLIER ON mh_supplier (NM_SUPPLIER)''');
  }
}
