import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:penjualan/model/pembelian.dart';
import 'package:penjualan/model/penjualan.dart';
import 'package:penjualan/utils/common_text.dart';
import 'package:penjualan/utils/common_widgets.dart';
import 'package:penjualan/utils/date_formatter.dart';
import 'package:penjualan/utils/my_colors.dart';
import 'package:penjualan/utils/string_formatter.dart';
import 'package:intl/intl.dart';

import 'bakcup_selected_controller.dart';

class BackupSelectedView extends BackupSelectedController {
  @override
  Widget build(BuildContext context) {
    return CommonWidgets.baseFormContainer(
      context: context,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: CommonWidgets.noAppBar(
            systemUiOverlayStyle: SystemUiOverlayStyle.dark,
          ),
          backgroundColor: MyColors.white,
          body: _transaksiPenjualanBody(),
        ),
      ),
    );
  }

  _transaksiPenjualanBody() {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 36,
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: CupertinoTextField(
              controller: searchController,
              placeholder: 'Ketik teks filter disini',
              placeholderStyle: CommonText.body1(color: MyColors.gray),
              style: CommonText.body1(color: MyColors.black),
              onSubmitted: (_text) {
                text = _text;
                fetchData();
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          CommonWidgets.horizontalDivider(),
          ExpandablePanel(
            theme: ExpandableThemeData(
              iconColor: MyColors.themeColor1,
              collapseIcon: FontAwesomeIcons.chevronUp,
              expandIcon: FontAwesomeIcons.chevronDown,
              iconPadding: EdgeInsets.only(top: 15, right: 15),
              iconSize: 15,
              headerAlignment: ExpandablePanelHeaderAlignment.top,
            ),
            header: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: CommonText.text(
                    text: 'Filter',
                    style: CommonText.body1(color: MyColors.themeColor1))),
            collapsed: Container(),
            expanded: Container(
                child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: CommonWidgets.textIconButton(
                    height: 36,
                    suffixIcon: Icon(
                      FontAwesomeIcons.calendarAlt,
                      color: MyColors.themeColor1,
                      size: 20,
                    ),
                    text: filterPeriode,
                    onPressed: onPressDate,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: DropdownButton<String>(
                    value: backupPicked,
                    icon: Icon(Icons.arrow_drop_down),
                    isExpanded: true,
                    iconSize: 24,
                    elevation: 16,
                    style: CommonText.body1(color: MyColors.black),
                    underline: Container(
                      height: 1,
                      color: MyColors.gray,
                    ),
                    onChanged: (String? data) {
                      setState(() {
                        backupPicked = data;
                        fetchData();
                      });
                    },
                    items: (listBackup ?? []).map((data) {
                      return DropdownMenuItem<String>(
                        value: data,
                        child: Text(
                          data,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                // SizedBox(
                //   height: 15,
                // ),
                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: 15),
                //   child: Row(
                //     children: [
                //       Expanded(
                //         child: DropdownButton<String>(
                //           value: monthPicked,
                //           icon: Icon(Icons.arrow_drop_down),
                //           isExpanded: true,
                //           iconSize: 24,
                //           elevation: 16,
                //           style: CommonText.body1(color: MyColors.black),
                //           underline: Container(
                //             height: 1,
                //             color: MyColors.gray,
                //           ),
                //           onChanged: (String? data) {
                //             setState(() {
                //               monthPicked = data;
                //               month = monthPicked;
                //               year = yearPicked;
                //               fetchData();
                //             });
                //           },
                //           items: (listMonth ?? []).map((data) {
                //             return DropdownMenuItem<String>(
                //               value: data,
                //               child: Text(
                //                 (data == '0' ? 'Bulan' : data),
                //               ),
                //             );
                //           }).toList(),
                //         ),
                //       ),
                //       SizedBox(
                //         width: 15,
                //       ),
                //       Expanded(
                //         child: DropdownButton<String>(
                //           value: yearPicked,
                //           icon: Icon(Icons.arrow_drop_down),
                //           isExpanded: true,
                //           iconSize: 24,
                //           elevation: 16,
                //           style: CommonText.body1(color: MyColors.black),
                //           underline: Container(
                //             height: 1,
                //             color: MyColors.gray,
                //           ),
                //           onChanged: (String? data) {
                //             setState(() {
                //               yearPicked = data;
                //               month = monthPicked;
                //               year = yearPicked;
                //               fetchData();
                //             });
                //           },
                //           items: (listYear ?? []).map((data) {
                //             return DropdownMenuItem<String>(
                //               value: data,
                //               child: Text(
                //                 (data == '0' ? 'Tahun' : data),
                //               ),
                //             );
                //           }).toList(),
                //         ),
                //       )
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: CommonWidgets.outlinedButton(
                          onPressed: () {
                            // monthPicked = '0';
                            // yearPicked = '0';
                            searchController.text = '';
                            filterStartDate =
                                DateFormat('yyyy-MM-dd').format(DateTime.now());
                            filterEndDate =
                                DateFormat('yyyy-MM-dd').format(DateTime.now());
                            setScheduleDateText();
                            text = null;
                            // month = null;
                            // year = null;
                            filterStart = null;
                            filterEnd = null;
                            fetchData();
                          },
                          text: 'Reset',
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        child: CommonWidgets.containedButton(
                          onPressed: () {
                            backupData();
                          },
                          text: 'Backup',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            )),
          ),
          CommonWidgets.horizontalDivider(),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(bottom: 30, left: 15, right: 15),
              itemCount: backupPicked == 'Penjualan'
                  ? listPenjualan?.length
                  : listPembelian?.length,
              itemBuilder: (BuildContext context, int index) {
                return backupPicked == 'Penjualan'
                    ? _itemPenjualan(index, listPenjualan?[index])
                    : _itemPembelian(index, listPembelian?[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  _itemPenjualan(int index, HJual? hJual) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText.text(
                  text: "NONOTA: ${hJual?.nonota}",
                  style: CommonText.body1(
                    color: MyColors.textGray,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                CommonText.text(
                  text: "${hJual?.nmCustomer}",
                  style: CommonText.body1(
                    color: MyColors.black,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                CommonText.text(
                  text:
                      "${DateFormatter.toLongDateText(context, DateTime.parse(hJual?.tglTransaksi ?? '00000/00/00'))} | ${formatMoney(value: (hJual?.grandTotal ?? 0))}",
                  style: CommonText.body1(
                    color: MyColors.themeColor1,
                  ),
                ),
              ],
            ),
          ),
          CommonWidgets.horizontalDivider(),
        ],
      ),
    );
  }

  _itemPembelian(int index, HBeli? hBeli) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText.text(
                  text: "NONOTA: ${hBeli?.nonota}",
                  style: CommonText.body1(
                    color: MyColors.textGray,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                CommonText.text(
                  text: "${hBeli?.nmSupplier}",
                  style: CommonText.body1(
                    color: MyColors.black,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                CommonText.text(
                  text:
                      "${DateFormatter.toLongDateText(context, DateTime.parse(hBeli?.tglTransaksi ?? '00000/00/00'))} | ${formatMoney(value: (hBeli?.grandTotal ?? 0))}",
                  style: CommonText.body1(
                    color: MyColors.themeColor1,
                  ),
                ),
              ],
            ),
          ),
          CommonWidgets.horizontalDivider(),
        ],
      ),
    );
  }
}
