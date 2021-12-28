import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:penjualan/model/pembelian.dart';
import 'package:penjualan/repositories/db_helper.dart';
import 'package:penjualan/utils/common_text.dart';
import 'package:penjualan/utils/common_widgets.dart';
import 'package:penjualan/utils/my_colors.dart';
import 'package:penjualan/utils/string_formatter.dart';
import 'package:sqflite/sqflite.dart';

class SelectSupplier extends StatefulWidget {
  final ValueChanged<HBeli> onSelected;

  SelectSupplier(this.onSelected);

  @override
  _SelectSupplierState createState() => _SelectSupplierState(this.onSelected);
}

class _SelectSupplierState extends State<SelectSupplier> {
  final ValueChanged<HBeli> onSelected;
  List<HBeli> supplierList = [];

  _SelectSupplierState(this.onSelected);

  bool _isFetching = false;

  final TextEditingController textController = TextEditingController();

  final debouncer =
      Debouncer<String>(Duration(milliseconds: 250), initialValue: '');

  _getData({String? query}) async {
    Database? db = await DatabaseHelper.instance.database;

    var result;
    if (query != null && query != '') {
      result = await db?.rawQuery(
          "SELECT DISTINCT NM_SUPPLIER FROM h_beli WHERE lower(NM_SUPPLIER) like ?",
          ["%$query%"]);
    } else {
      result = await db?.rawQuery("SELECT DISTINCT NM_SUPPLIER FROM h_beli");
    }

    // if ((result?.length ?? 0) > 0) {
    setState(() {
      supplierList = List<HBeli>.from(result.map((map) => HBeli.fromMap(map)));
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
            text: "Select Supplier:",
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
                          supplierList.clear();
                          _getData();
                        });
                      else {
                        supplierList.clear();
                        _getData();
                      }
                    },
                  ),
                  placeholder: 'Nama Supplier',
                  placeholderStyle: CommonText.body1(color: MyColors.gray),
                  onChanged: (val) {
                    supplierList.clear();
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
                  if (supplierList.isEmpty) {
                    onSelected(
                      HBeli(
                          nmSupplier: textController.text.trim().toUpperCase()),
                    );
                  } else {
                    onSelected(supplierList.first);
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
                  itemCount: supplierList.length,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  separatorBuilder: (context, index) {
                    return CommonWidgets.horizontalDivider();
                  },
                  itemBuilder: (c, i) => _item(supplierList[i]),
                ),
        ),
      ],
    );
  }

  _item(HBeli supplier) {
    return ListTile(
      onTap: () => onSelected(supplier),
      title: CommonText.text(
        text: supplier.nmSupplier ?? '',
        style: CommonText.body1(color: MyColors.black),
      ),
    );
  }
}
