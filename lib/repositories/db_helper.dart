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
          CREATE TABLE barang (
            ID_BARANG TEXT PRIMARY KEY,
            ID_KATEGORI TEXT,
            NM_BARANG TEXT,
            HARGA INTEGER,
            STATUS TEXT     
          )''');

    await database.execute('''CREATE TABLE customer (
            ID_CUSTOMER INTEGER PRIMARY KEY AUTOINCREMENT,            
            NM_CUSTOMER TEXT,
            NO_TLP TEXT,
            ALAMAT TEXT,
            EMAIL TEXT,
            STATUS TEXT,
            HARGA_KHUSUS TEXT
          )''');

    await database.execute('''CREATE TABLE h_beli (
            ID_HBELI TEXT PRIMARY KEY,
            NM_SUPPLIER TEXT,
            NM_KARYAWAN TEXT,
            GRANDTOTAL INTEGER,
            QUANTITY_TOTAL INTEGER,
            TANGGAL_BELI TEXT,
            BUKTI_NOTA TEXT,
            KETERANGAN TEXT
            )''');

    await database.execute('''CREATE TABLE h_jual (
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
            REKENING TEXT    
            )''');

    await database.execute('''CREATE TABLE d_beli (
            ID_DBELI INTEGER PRIMARY KEY AUTOINCREMENT,
            ID_HBELI TEXT,
            NM_BARANG TEXT,
            SATUAN TEXT,
            QUANTITY INT,
            HARGA_BARANG INT,
            SUBTOTAL INT
            )''');

    await database.execute('''CREATE TABLE d_jual (
            ID_DJUAL INTEGER PRIMARY KEY AUTOINCREMENT,
            ID_HJUAL TEXT,
            NM_BARANG TEXT,
            SATUAN TEXT,
            QUANTITY INTEGER,
            HARGA_BARANG INTEGER,
            SUBTOTAL INTEGER
            )''');

    await database.execute('''CREATE TABLE hutang (
            ID_HJUAL TEXT PRIMARY KEY,
            NAMA_CUSTOMER TEXT,
            NOMINAL INTEGER,
            TGL_JATUH_TEMPO TEXT,
            STATUS TEXT,
            TGL_BAYAR TEXT,
            NONOTA TEXT
    )''');

    await database.execute('''CREATE TABLE jabatan (
            ID_JABATAN INTEGER PRIMARY KEY AUTOINCREMENT,
            NM_JABATAN TEXT,
            ACCESS TEXT,
            STATUS TEXT    
            )''');

    await database.execute('''CREATE TABLE karyawan (
            ID_KARYAWAN TEXT PRIMARY KEY,
            ID_JABATAN INTEGER,
            NM_KARYAWAN TEXT,
            NO_TLP TEXT,            
            ALAMAT TEXT,
            EMAIL TEXT,
            USERNAME TEXT,
            PASSWORD TEXT,
            STATUS TEXT
            )''');

    await database.execute('''CREATE TABLE kategori (
            ID_KATEGORI INTEGER PRIMARY KEY AUTOINCREMENT,
            NM_KATEGORI TEXT,
            STATUS TEXT    
            )''');

    await database.execute('''CREATE TABLE mh_perusahaan (
            ID_PERUSAHAAN INTEGER PRIMARY KEY AUTOINCREMENT,
            NM_PERUSAHAAN TEXT,
            LOGO TEXT
            )''');

    await database.execute('''CREATE TABLE mh_supplier (
            ID_SUPPLIER TEXT PRIMARY KEY,
            NM_SUPPLIER TEXT,
            NO_TLP TEXT,
            ALAMAT TEXT,
            EMAIL TEXT,
            STATUS TEXT
            )''');

    await database.execute('''CREATE TABLE satuan (
            ID INTEGER PRIMARY KEY AUTOINCREMENT,
            NAMA_SATUAN TEXT        
      )''');

    await database.execute('''CREATE TABLE stok (
            ID_STOK INTEGER PRIMARY KEY AUTOINCREMENT,
            ID_KATEGORI INT,
            NAMA_BARANG TEXT,
            QUANTITY INT,
            HARGA INT,
            STATUS INT
      )''');

    //create index
    await database
        .execute('''CREATE INDEX FK_KATEGORI ON barang (ID_KATEGORI)''');
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

    await database.execute(
        '''INSERT INTO `karyawan` VALUES ('001', '1', 'DUMMY', '08124567', 'DUMMY', 'DUMMY', 'tes', '1b6cb4e23e2b490f1235755a4622469b', '1')''');

    await database.execute(
        '''INSERT INTO stok VALUES ('256', '0', 'ACL', '-726', '25000', '1'),
        ('257', '0', 'ADJUSTING', '7', '150000', '1'),
        ('258', '0', 'ADJUSTING P. CTP MOLIN', '-62', '900000', '1'),
        ('259', '0', 'AMBREE MILD', '0', '155000', '1'),
('260', '0', 'AMBREE REGULAR ', '0', '155000', '1'),
('261', '0', 'AS COUPLE SEK MK8 REG', '0', '9250000', '1'),
('262', '0', 'AS GEARBOX EXENTRIK', '0', '750000', '1'),
('263', '0', 'AS GLUERON', '0', '500000', '1'),
('264', '0', 'ASAH PISAU CTP', '0', '150000', '1'),
('265', '0', 'ASAHAN P. FILTER', '-33', '90000', '1'),
('273', '0', 'BAN BAJA MK8', '8175', '140000', '1'),
('274', '0', 'BAN BAJA MK8 LUBANG 6', '8175', '135000', '1'),
('276', '0', 'BAN BAJA MK9 REGULAR', '-30', '145000', '1'),
('277', '0', 'BAN KAIN', '-5', '130000', '1'),
('278', '0', 'BAN KAIN 22 X 2800', '-480', '135000', '1'),
('279', '0', 'BAN KAIN MILD', '0', '130000', '1'),
('280', '0', 'BAN KAIN REG', '-60', '130000', '1'),
('281', '0', 'BAN KAIN REGULAR', '-60', '130000', '1'),
('282', '0', 'BAN KAIN REGULER', '-60', '130000', '1'),
('284', '0', 'BAN KECHER', '0', '1750000', '1'),
('286', '0', 'BATU ASAH FILTER', '-30', '180000', '1'),
('287', '0', 'BEARING 6203', '0', '55000', '1'),
('288', '0', 'BEARING 62201', '0', '85000', '1'),
('289', '0', 'BELTING  T10 X 900 X 20MM', '0', '365000', '1'),
('290', '0', 'BELTING 1 X 10 X 340', '-40', '90000', '1'),
('291', '0', 'BELTING 160L X 10MM', '0', '80000', '1'),
('292', '0', 'BELTING 270L 20MM', '0', '85000', '1'),
('293', '0', 'BELTING 285L (DOUBLE GIGI)', '0', '120000', '1'),
('294', '0', 'BELTING 420H X 12MM', '-30', '90000', '1'),
('295', '0', 'BELTING 482 H075', '0', '125000', '1'),
('296', '0', 'BELTING A35', '-7', '50000', '1'),
('297', '0', 'BELTING SPZ 487', '-10', '105000', '1'),
('298', '0', 'BELTING T10 1480 X 25', '0', '650000', '1'),
('300', '0', 'BLANKED', '0', '400000', '1'),
('301', '0', 'BRAPH EXCSEATOR', '0', '70000', '1')
        ''');
    await database
        .execute('''INSERT INTO kategori VALUES ('1', 'BESI', 'Non Aktif'),
('2', 'KAIN', 'Non Aktif'),
('3', 'TIMBANGAN', 'Non Aktif'),
('4', 'BAN KAIN', 'Aktif'),
('5', 'BAUT', 'Aktif'),
('6', 'SPRING BAND', 'Aktif'),
('7', 'BAN BAJA', 'Aktif') ''');
  }
}
