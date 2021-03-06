import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:penjualan/model/penjualan.dart';
import 'package:penjualan/routing/navigator.dart';
import 'package:penjualan/screen/transaksi/penjualan/penjualan_controller.dart';
import 'package:penjualan/utils/common_text.dart';
import 'package:penjualan/utils/common_widgets.dart';
import 'package:penjualan/utils/date_formatter.dart';
import 'package:penjualan/utils/my_colors.dart';
import 'package:penjualan/utils/string_formatter.dart';

class PenjualanView extends PenjualanController {
  @override
  Widget build(BuildContext context) {
    return CommonWidgets.baseFormContainer(
      context: context,
      child: SafeArea(
        child: Scaffold(
            appBar: CommonWidgets.noAppBar(
              systemUiOverlayStyle: SystemUiOverlayStyle.dark,
            ),
            backgroundColor: MyColors.white,
            body: _transaksiPenjualanBody(),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: FloatingActionButton(
              backgroundColor: MyColors.themeColor1,
              child: Icon(
                FontAwesomeIcons.plus,
                size: 24,
              ),
              onPressed: () {
                goToAddTransaksiPenjualan(
                    context: context,
                    afterOpen: (value) {
                      fetchDataPenjualan();
                    });
              },
            )),
      ),
    );
  }

  _transaksiPenjualanBody() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
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
              onSubmitted: (text) {
                fetchDataPenjualan(text: text);
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          CommonWidgets.horizontalDivider(),
          SizedBox(
            height: 10,
          ),
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
          CommonWidgets.horizontalDivider(),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(bottom: 50, left: 15, right: 15),
              itemCount: listPenjualan?.length,
              itemBuilder: (BuildContext context, int index) {
                return _item(index, listPenjualan?[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  _item(int index, HJual? hJual) {
    return Container(
      child: Column(
        children: [
          ExpandablePanel(
            theme: ExpandableThemeData(
              iconColor: MyColors.themeColor1,
              collapseIcon: FontAwesomeIcons.chevronUp,
              expandIcon: FontAwesomeIcons.chevronDown,
              iconPadding: EdgeInsets.only(top: 15),
              iconSize: 15,
              headerAlignment: ExpandablePanelHeaderAlignment.top,
            ),
            header: Container(
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
                  SizedBox(
                    height: 8,
                  ),
                  CommonText.text(
                    text: "Keterangan: ${hJual?.keterangan ?? '-'}",
                    style: CommonText.body1(
                      color: MyColors.textGray,
                    ),
                  ),
                ],
              ),
            ),
            collapsed: Container(),
            expanded: Container(
              padding: EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () => showDialogDelete(hJual?.idHjual),
                    child: CommonText.text(
                      text: 'Delete',
                      style: CommonText.body1(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  InkWell(
                    onTap: () {
                      goToAddTransaksiPenjualan(
                          context: context,
                          editHJual: hJual,
                          afterOpen: (value) {
                            fetchDataPenjualan();
                          });
                    },
                    child: CommonText.text(
                      text: 'View',
                      style: CommonText.body1(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          CommonWidgets.horizontalDivider(),
        ],
      ),
    );
  }
}
