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

//     await database.execute(
//         '''INSERT INTO stok VALUES ('256', '0', 'ACL', '-726', '25000', '1'),
//         ('257', '0', 'ADJUSTING', '7', '150000', '1'),
//         ('258', '0', 'ADJUSTING P. CTP MOLIN', '-62', '900000', '1'),
//         ('259', '0', 'AMBREE MILD', '0', '155000', '1'),
// ('260', '0', 'AMBREE REGULAR ', '0', '155000', '1'),
// ('261', '0', 'AS COUPLE SEK MK8 REG', '0', '9250000', '1'),
// ('262', '0', 'AS GEARBOX EXENTRIK', '0', '750000', '1'),
// ('263', '0', 'AS GLUERON', '0', '500000', '1'),
// ('264', '0', 'ASAH PISAU CTP', '0', '150000', '1'),
// ('265', '0', 'ASAHAN P. FILTER', '-33', '90000', '1'),
// ('273', '0', 'BAN BAJA MK8', '8175', '140000', '1'),
// ('274', '0', 'BAN BAJA MK8 LUBANG 6', '8175', '135000', '1'),
// ('276', '0', 'BAN BAJA MK9 REGULAR', '-30', '145000', '1'),
// ('277', '0', 'BAN KAIN', '-5', '130000', '1'),
// ('278', '0', 'BAN KAIN 22 X 2800', '-480', '135000', '1'),
// ('279', '0', 'BAN KAIN MILD', '0', '130000', '1'),
// ('280', '0', 'BAN KAIN REG', '-60', '130000', '1'),
// ('281', '0', 'BAN KAIN REGULAR', '-60', '130000', '1'),
// ('282', '0', 'BAN KAIN REGULER', '-60', '130000', '1'),
// ('284', '0', 'BAN KECHER', '0', '1750000', '1'),
// ('286', '0', 'BATU ASAH FILTER', '-30', '180000', '1'),
// ('287', '0', 'BEARING 6203', '0', '55000', '1'),
// ('288', '0', 'BEARING 62201', '0', '85000', '1'),
// ('289', '0', 'BELTING  T10 X 900 X 20MM', '0', '365000', '1'),
// ('290', '0', 'BELTING 1 X 10 X 340', '-40', '90000', '1'),
// ('291', '0', 'BELTING 160L X 10MM', '0', '80000', '1'),
// ('292', '0', 'BELTING 270L 20MM', '0', '85000', '1'),
// ('293', '0', 'BELTING 285L (DOUBLE GIGI)', '0', '120000', '1'),
// ('294', '0', 'BELTING 420H X 12MM', '-30', '90000', '1'),
// ('295', '0', 'BELTING 482 H075', '0', '125000', '1'),
// ('296', '0', 'BELTING A35', '-7', '50000', '1'),
// ('297', '0', 'BELTING SPZ 487', '-10', '105000', '1'),
// ('298', '0', 'BELTING T10 1480 X 25', '0', '650000', '1'),
// ('300', '0', 'BLANKED', '0', '400000', '1'),
// ('301', '0', 'BRAPH EXCSEATOR', '0', '70000', '1')
//         ''');
//     await database
//         .execute('''INSERT INTO kategori VALUES ('1', 'BESI', 'Non Aktif'),
// ('2', 'KAIN', 'Non Aktif'),
// ('3', 'TIMBANGAN', 'Non Aktif'),
// ('4', 'BAN KAIN', 'Aktif'),
// ('5', 'BAUT', 'Aktif'),
// ('6', 'SPRING BAND', 'Aktif'),
// ('7', 'BAN BAJA', 'Aktif') ''');

//     await database.execute(
//         '''INSERT INTO `customer` VALUES ('2', 'BAPAK HAJI KHAIRUL ANWAR', '', '', '', '1', 'TIDAK'),
// ('3', 'BAPAK SUBARI', '', '', '', '', 'TIDAK'),
// ('4', 'BAPAK JEFRY', '', '', '', '', 'TIDAK'),
// ('5', 'BAPAK ANANG', '', '', '', '', 'TIDAK'),
// ('6', 'BAPAK SALMAN', '', '', '', '', 'TIDAK'),
// ('7', 'BAPAK TOMY', '', '', '', '', 'TIDAK'),
// ('8', 'PT ONGKO WIJOYO', '', '', '', '', 'TIDAK'),
// ('9', 'P.R RAJAWALI', '', '', '', '', 'TIDAK'),
// ('10', 'PT ROCK INTERNATIONAL', '', '', '', '', 'TIDAK'),
// ('11', 'PT CAHAYA PRO', '', '', '', '', 'TIDAK'),
// ('12', 'PT TIGA BOLA', '', '', '', '', 'TIDAK')''');

//     await database.execute(
//         '''INSERT INTO `h_beli` VALUES ('0001/12/2020', 'IBU PUDJI', 'tes', '29200000', '0', '2020-12-26 00:00:00', '', ''),
// ('00010/01/2021', 'IBU PUDJI', 'tes', '27200000', '0', '2021-01-25 00:00:00', '', ''),
// ('0002/01/2021', 'BAPAK ALFAN', 'tes', '759550000', '0', '2021-01-14 00:00:00', '', ''),
// ('0002/12/2020', 'IBU PUDJI', 'tes', '21500000', '0', '2020-12-30 00:00:00', '', ''),
// ('0003/01/2021', 'IBU PAULA', 'tes', '184228000', '0', '2021-01-15 00:00:00', '', ''),
// ('0004/01/2021', 'IBU PUDJI', 'tes', '17200000', '0', '2021-01-05 00:00:00', '', ''),
// ('0005/01/2021', 'IBU PUDJI', 'tes', '19000000', '0', '2021-01-05 00:00:00', '', ''),
// ('0006/01/2021', 'IBU PUDJI', 'tes', '41500000', '0', '2021-01-11 00:00:00', '', ''),
// ('0007/01/2021', 'IBU PUDJI', 'tes', '9000000', '0', '2021-01-12 00:00:00', '', ''),
// ('0008/01/2021', 'IBU PUDJI', 'tes', '19000000', '0', '2021-01-12 00:00:00', '', ''),
// ('0009/01/2021', 'IBU PUDJI', 'tes', '19000000', '0', '2021-01-21 00:00:00', '', ''),
// ('0010/01/2021', 'IBU PUDJI', 'tes', '38000000', '0', '2021-01-27 00:00:00', '', '')''');

//     await database.execute(
//         '''INSERT INTO `h_jual` VALUES ('0001/01/2021', '2021-01-01 00:00:00', 'tes', 'Bapak Haji Fahmi', '0', '5670000', '5670000', '0', '7291/01/2021', '', 'Pamekasan', '0', ''),
// ('0001/02/2021', '2021-02-13 00:00:00', 'tes', 'BAPAK TOMY', '0', '20070000', '20070000', '0', '7672/II/2021', '', 'MALANG', '0', ''),
// ('0001/07/2020', '2020-07-01 00:00:00', 'tes', 'BAPAK JEFRY', '0', '1650000', '1650000', '0', '7107/VII/2020', '', 'SOPPENG', '0', ''),
// ('0002/01/2021', '2021-01-01 00:00:00', 'tes', 'Bapak Tomy', '0', '16570000', '16570000', '0', '1849/I/2021', '', '', '0', ''),
// ('0002/02/2021', '2021-02-13 00:00:00', 'tes', 'PR CEMERLANG JAYA ABADI', '0', '9150000', '9150000', '0', '7673/II/2021', '', 'SIDOARJO', '0', ''),
// ('0002/07/2020', '2020-07-01 00:00:00', 'tes', 'BAPAK ERWAN/PR PUTRA JAYA CM', '0', '2850000', '2850000', '0', '7108/VII/2020', 'LUNAS', 'SIDOARJO', '0', ''),
// ('0003/01/2021', '2021-01-02 00:00:00', 'tes', 'BAPK HAJI MUNTAHA', '0', '13500000', '13500000', '0', '7292/01/2021', '', '', '0', '')''');

//     await database.execute(
//         '''INSERT INTO `d_jual` VALUES ('267', '0001/01/2021', 'Pisau Cigarette', 'PCS', '20', '14000', '280000'),
// ('268', '0001/01/2021', 'Silicont', 'PCS', '10', '75000', '750000'),
// ('269', '0001/01/2021', 'CARNITURE 22 X 2800', 'PCS', '20', '135000', '2700000'),
// ('270', '0001/01/2021', 'Gerinda Pisau Filter', 'SET', '3', '180000', '540000'),
// ('271', '0001/01/2021', 'Garnitur 22 x 2489', 'PCS', '10', '130000', '1300000'),
// ('272', '0001/01/2021', 'Travel', '', '1', '100000', '100000'),
// ('2868', '0001/02/2021', 'GARNITUR REGULAR', 'PCS', '50', '130000', '6500000'),
// ('2869', '0001/02/2021', 'TOBACCO', 'PCS', '30', '140000', '4200000'),
// ('2870', '0001/02/2021', 'SPRING BAND', 'SET', '5', '140000', '700000'),
// ('2871', '0001/02/2021', 'TEFLON', 'PCS', '2', '600000', '1200000'),
// ('2872', '0001/02/2021', 'PISAU CTP MILD', 'SET', '2', '850000', '1700000'),
// ('2873', '0001/02/2021', 'PISAU CIGARETE', 'PCS', '20', '14000', '280000'),
// ('2874', '0001/02/2021', 'PISAU FILTER', 'PCS', '20', '17000', '340000'),
// ('2875', '0001/02/2021', 'ROUND BELT KECIL', 'PCS', '5', '70000', '350000'),
// ('2876', '0001/02/2021', 'ROUND BELT BESAR', 'PCS', '5', '90000', '450000'),
// ('2877', '0001/02/2021', 'SPRING LEAGER', 'SET', '4', '450000', '1800000'),
// ('2878', '0001/02/2021', 'VAN BELT M25', 'PCS', '5', '45000', '225000'),
// ('2879', '0001/02/2021', 'PLAT BELT 1740X12', 'PCS', '5', '150000', '750000'),
// ('2880', '0001/02/2021', 'PLAT BELT 1470 X 25', 'PCS', '5', '175000', '875000'),
// ('2881', '0001/02/2021', 'TONGPIS REGULAR', 'PCS', '1', '700000', '700000'),
// ('75', '0001/07/2020', 'TIMMING BELT 187 L', 'PCS', '10', '45000', '450000'),
// ('76', '0001/07/2020', 'TIMMING BELT 345 L', 'PCS', '10', '65000', '650000'),
// ('77', '0001/07/2020', 'TIMMING BELT 285 L', 'PCS', '5', '55000', '275000'),
// ('78', '0001/07/2020', 'TIMMING BELT 255 L', 'PCS', '5', '55000', '275000'),
// ('273', '0002/01/2021', 'Garnitur Reg', 'PCS', '40', '130000', '5200000'),
// ('274', '0002/01/2021', 'Ban Baja', 'PCS', '30', '140000', '4200000'),
// ('275', '0002/01/2021', 'ACL', 'PCS', '20', '25000', '500000'),
// ('276', '0002/01/2021', 'Pisau Cigaret', 'PCS', '20', '14000', '280000'),
// ('277', '0002/01/2021', 'Pisau Filter', 'PCS', '20', '17000', '340000'),
// ('278', '0002/01/2021', 'Nilon', 'PCS', '20', '90000', '1800000'),
// ('279', '0002/01/2021', 'R. Belt Besar', 'PCS', '5', '90000', '450000'),
// ('280', '0002/01/2021', 'R. Belt Kecil', 'PCS', '5', '70000', '350000'),
// ('281', '0002/01/2021', 'Teflon', 'PCS', '2', '600000', '1200000'),
// ('282', '0002/01/2021', 'T. Belt 367', 'PCS', '5', '65000', '325000'),
// ('283', '0002/01/2021', 'P. CTP MCD', 'SET', '2', '850000', '1700000'),
// ('284', '0002/01/2021', 'T. Belt 187', 'PCS', '5', '45000', '225000'),
// ('2882', '0002/02/2021', 'CARNITURE 19X2489', 'PCS', '40', '130000', '5200000'),
// ('2883', '0002/02/2021', 'NILON 3150 X 12.5', 'PCS', '20', '90000', '1800000'),
// ('2884', '0002/02/2021', 'P.CTP REGULAR', 'SET', '1', '750000', '750000'),
// ('2885', '0002/02/2021', 'P.CTP MILD', 'SET', '1', '850000', '850000'),
// ('2886', '0002/02/2021', 'HEATHER MAKER', 'PCS', '1', '300000', '300000'),
// ('2887', '0002/02/2021', 'HEATHER WR', 'PCS', '1', '250000', '250000'),
// ('70', '0002/07/2020', 'TIMMING BELT 187 L', 'PCS', '10', '45000', '450000'),
// ('71', '0002/07/2020', 'TIMMING BELT 345 L', 'PCS', '10', '65000', '650000'),
// ('72', '0002/07/2020', 'TIMMING BELT 285 L', 'PCS', '5', '55000', '275000'),
// ('73', '0002/07/2020', 'TIMMING BELT 255 L', 'PCS', '5', '55000', '275000'),
// ('79', '0002/07/2020', 'PISAU CIGARETTE', 'PCS', '100', '12500', '1250000'),
// ('80', '0002/07/2020', 'PISAU FILTER', 'PCS', '100', '16000', '1600000'),
// ('285', '0003/01/2021', 'CUT OFF', 'UNIT', '1', '13500000', '13500000')''');
//     await database.execute('''INSERT INTO `satuan` VALUES ('2', 'PCS'),
// ('3', 'KG'),
// ('4', 'SET'),
// ('5', 'UNIT'),
// ('6', 'METER'),
// ('7', 'KALENG'),
// ('8', 'ROLL'),
// ('9', 'PACK'),
// ('10', 'KOTAK'),
// ('11', 'BOX')''');
  }
}
