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
import 'package:penjualan/repositories/db_helper.dart';
import 'package:penjualan/utils/common_text.dart';
import 'package:penjualan/utils/common_widgets.dart';
import 'package:penjualan/utils/my_colors.dart';
import 'package:penjualan/utils/string_formatter.dart';
import 'package:sqflite/sqflite.dart';

class SelectCustomer extends StatefulWidget {
  final ValueChanged<Customer> onSelected;

  SelectCustomer(this.onSelected);

  @override
  _SelectCustomerState createState() => _SelectCustomerState(this.onSelected);
}

class _SelectCustomerState extends State<SelectCustomer> {
  final ValueChanged<Customer> onSelected;
  List<Customer> customerList = [];

  _SelectCustomerState(this.onSelected);

  bool _isFetching = false;

  final TextEditingController textController = TextEditingController();

  final debouncer =
      Debouncer<String>(Duration(milliseconds: 250), initialValue: '');

  _getData({String? query}) async {
    Database? db = await DatabaseHelper.instance.database;

    var result;
    if (query != null && query != '') {
      result = await db?.rawQuery(
          "SELECT * FROM CUSTOMER WHERE lower(NM_CUSTOMER) like ?",
          ["%$query%"]);
    } else {
      result = await db?.rawQuery("SELECT * FROM CUSTOMER");
    }

    // if ((result?.length ?? 0) > 0) {
    setState(() {
      customerList =
          List<Customer>.from(result.map((map) => Customer.fromMap(map)));
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
            text: "Select customer:",
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
                          customerList.clear();
                          _getData();
                        });
                      else {
                        customerList.clear();
                        _getData();
                      }
                    },
                  ),
                  placeholder: 'Nama Customer',
                  placeholderStyle: CommonText.body1(color: MyColors.gray),
                  onChanged: (val) {
                    customerList.clear();
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
                  if (customerList.isEmpty) {
                    onSelected(
                      Customer(
                          nmCustomer: textController.text.trim().toUpperCase()),
                    );
                  } else {
                    onSelected(customerList.first);
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
                  itemCount: customerList.length,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  separatorBuilder: (context, index) {
                    return CommonWidgets.horizontalDivider();
                  },
                  itemBuilder: (c, i) => _item(customerList[i]),
                ),
        ),
      ],
    );
  }

  _item(Customer customer) {
    return ListTile(
      onTap: () => onSelected(customer),
      title: CommonText.text(
        text: customer.nmCustomer ?? '',
        style: CommonText.body1(color: MyColors.black),
      ),
    );
  }
}
