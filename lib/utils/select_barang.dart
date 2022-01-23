/*
 * homy-app-dev
 * select_agency_name.dart
 * Created by Bahri Rizaldi on 16/04/2020 15:22
 *
 */

import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:penjualan/model/customer.dart';
import 'package:penjualan/model/stok.dart';
import 'package:penjualan/repositories/db_helper.dart';
import 'package:penjualan/utils/common_text.dart';
import 'package:penjualan/utils/common_widgets.dart';
import 'package:penjualan/utils/my_colors.dart';
import 'package:penjualan/utils/string_formatter.dart';
import 'package:sqflite/sqflite.dart';

class SelectBarang extends StatefulWidget {
  final ValueChanged<Stok> onSelected;
  final Customer? customer;
  SelectBarang(this.onSelected, {this.customer});

  @override
  _SelectBarangState createState() =>
      _SelectBarangState(this.onSelected, this.customer);
}

class _SelectBarangState extends State<SelectBarang> {
  final ValueChanged<Stok> onSelected;
  final Customer? customer;
  List<Stok> stokList = [];

  _SelectBarangState(this.onSelected, this.customer);

  bool _isFetching = false;

  final TextEditingController textController = TextEditingController();

  final debouncer =
      Debouncer<String>(Duration(milliseconds: 250), initialValue: '');

  _getData({String? query}) async {
    Database? db = await DatabaseHelper.instance.database;

    var result;

    if (query != null && query != '') {
      if (customer?.hargaKhusus == 'YA') {
        result = await db?.rawQuery(
            "SELECT g.ID_STOK,g.NM_BARANG AS 'NAMA_BARANG', g.QUANTITY as 'QUANTITY', g.HARGA_BARANG as 'HARGA' FROM(SELECT s.ID_STOK,ID_KATEGORI,dj.NM_BARANG,s.QUANTITY,dj.HARGA_BARANG,s.STATUS from d_jual dj, h_jual hj, stok s WHERE dj.NM_BARANG= s.NAMA_BARANG AND dj.ID_HJUAL = hj.ID_HJUAL AND hj.NM_CUSTOMER = ? GROUP BY NM_BARANG UNION SELECT * FROM stok) AS g WHERE UPPER(g.NM_BARANG) LIKE ? GROUP BY g.ID_STOK",
            [widget.customer?.nmCustomer, "%$query%"]);
      } else {
        result = await db?.rawQuery(
            "SELECT stok.ID_STOK,stok.ID_KATEGORI,stok.NAMA_BARANG,stok.QUANTITY, stok.HARGA,stok.status,kategori.NM_KATEGORI FROM stok LEFT JOIN kategori ON stok.ID_KATEGORI = kategori.ID_KATEGORI WHERE stok.STATUS = 1 AND lower(stok.NAMA_BARANG) like ?",
            ["%$query%"]);
      }
    } else {
      if (customer?.hargaKhusus == 'YA') {
        result = await db?.rawQuery(
            "SELECT g.ID_STOK,g.NM_BARANG AS 'NAMA_BARANG', g.QUANTITY as 'QUANTITY', g.HARGA_BARANG as 'HARGA' FROM(SELECT s.ID_STOK,ID_KATEGORI,dj.NM_BARANG,s.QUANTITY,dj.HARGA_BARANG,s.STATUS from d_jual dj, h_jual hj, stok s WHERE dj.NM_BARANG= s.NAMA_BARANG AND dj.ID_HJUAL = hj.ID_HJUAL AND hj.NM_CUSTOMER = ? GROUP BY NM_BARANG UNION SELECT * FROM stok) AS g GROUP BY g.ID_STOK",
            [widget.customer?.nmCustomer]);
      } else {
        result = await db?.rawQuery(
            "SELECT stok.ID_STOK,stok.ID_KATEGORI,stok.NAMA_BARANG,stok.QUANTITY, stok.HARGA,stok.status,kategori.NM_KATEGORI FROM stok LEFT JOIN kategori ON stok.ID_KATEGORI = kategori.ID_KATEGORI WHERE stok.STATUS = 1");
      }
    }

    // if ((result?.length ?? 0) > 0) {
    setState(() {
      stokList = List<Stok>.from(result.map((map) => Stok.fromMap(map)));
    });
  }

  @override
  void initState() {
    _getData();
    debouncer.values.listen((text) {
      if (mounted) _getData(query: text);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          child: CommonText.text(
            text: "Select barang:",
            style: CommonText.body1(
              color: MyColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        CommonWidgets.horizontalDivider(),
        Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
              Expanded(
                child: CupertinoTextField(
                  textCapitalization: TextCapitalization.sentences,
                  controller: textController,
                  style: CommonText.body1(color: MyColors.black),
                  autofocus: true,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: MyColors.dementialGray,
                      width: 1.0,
                    ),
                    color: MyColors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  suffix: IconButton(
                    icon: Icon(
                      textController.text.length > 0
                          ? FontAwesomeIcons.timesCircle
                          : FontAwesomeIcons.search,
                      color: textController.text.length > 0
                          ? MyColors.textGray
                          : MyColors.themeColor1,
                    ),
                    onPressed: () {
                      if (textController.text.length > 0)
                        setState(() {
                          textController.text = "";
                          stokList.clear();
                          _getData();
                        });
                      else {
                        stokList.clear();
                        _getData();
                      }
                    },
                  ),
                  placeholder: 'Nama Barang',
                  placeholderStyle: CommonText.body1(color: MyColors.gray),
                  onChanged: (val) {
                    stokList.clear();
                    debouncer.value = val;
                    // EasyDebounce.debounce(
                    //   'debounce',
                    //   Duration(milliseconds: 500),
                    //   () => _getData(query: val),
                    // );
                  },
                ),
              ),
              SizedBox(
                width: 10,
              ),
              CommonWidgets.outlinedIconButton(
                icon: FontAwesomeIcons.check,
                onPressed: () {
                  if (stokList.isEmpty) {
                    onSelected(
                      Stok(
                        namaBarang: textController.text.trim().toUpperCase(),
                      ),
                    );
                  } else {
                    onSelected(stokList.first);
                  }
                },
              ),
            ],
          ),
        ),
        CommonWidgets.horizontalDivider(),
        Expanded(
          child: _isFetching
              ? CircularProgressIndicator.adaptive(
                  backgroundColor: MyColors.textGray,
                  strokeWidth: 2.5,
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(MyColors.silver),
                )
              : ListView.separated(
                  itemCount: stokList.length,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  separatorBuilder: (context, index) {
                    return CommonWidgets.horizontalDivider();
                  },
                  itemBuilder: (c, i) => _item(stokList[i]),
                ),
        ),
      ],
    );
  }

  _item(Stok stok) {
    return ListTile(
      onTap: () => onSelected(stok),
      title: CommonText.text(
        text: stok.namaBarang ?? '',
        style: CommonText.body1(color: MyColors.black),
      ),
      subtitle: CommonText.text(
        text:
            "${formatMoney(value: (stok.harga ?? 0))} | Qty : ${stok.quantity.toString()}",
        style: CommonText.body1(
          color: MyColors.textGray,
        ),
      ),
    );
  }
}
