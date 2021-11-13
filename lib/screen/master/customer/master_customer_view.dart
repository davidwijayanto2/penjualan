import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:penjualan/model/customer.dart';
import 'package:penjualan/model/stok.dart';
import 'package:penjualan/routing/navigator.dart';
import 'package:penjualan/screen/master/barang/master_barang_controller.dart';
import 'package:penjualan/screen/master/customer/master_customer_controller.dart';
import 'package:penjualan/utils/common_text.dart';
import 'package:penjualan/utils/common_widgets.dart';
import 'package:penjualan/utils/my_colors.dart';
import 'package:penjualan/utils/string_formatter.dart';

class MasterCustomerView extends MasterCustomerController {
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
            body: _masterBarangBody(),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: FloatingActionButton(
              backgroundColor: MyColors.themeColor1,
              child: Icon(
                FontAwesomeIcons.plus,
                size: 24,
              ),
              onPressed: () {
                goToAddMasterBarang(
                    context: context,
                    afterOpen: (value) {
                      fetchDataCustomer();
                    });
              },
            )),
      ),
    );
  }

  _masterBarangBody() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 36,
            child: CupertinoTextField(
              controller: searchController,
              placeholder: 'Ketik teks filter disini',
              placeholderStyle: CommonText.body1(color: MyColors.gray),
              style: CommonText.body1(color: MyColors.black),
              onSubmitted: (text) {
                fetchDataCustomer(text: text);
              },
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
              padding: EdgeInsets.only(bottom: 50),
              itemCount: listCustomer?.length,
              itemBuilder: (BuildContext context, int index) {
                return _item(index, listCustomer?[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  _item(int index, Customer? customer) {
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
                    text: "ID: ${customer?.idCustomer}",
                    style: CommonText.body1(
                      color: MyColors.textGray,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  CommonText.text(
                    text: "${customer?.nmCustomer}",
                    style: CommonText.title(
                      color: MyColors.black,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  CommonText.text(
                    text: "${customer?.alamat}",
                    style: CommonText.body1(
                      color: MyColors.textGray,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  CommonText.text(
                    text:
                        "Email: ${customer?.email} | Telp: ${customer?.noTelp}",
                    style: CommonText.body1(
                      color: MyColors.themeColor1,
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
                    onTap: () => showDialogDelete(customer?.idCustomer),
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
                      goToAddMasterCustomer(
                        context: context,
                        afterOpen: (value) {
                          fetchDataCustomer();
                        },
                        editCustomer: customer,
                      );
                    },
                    child: CommonText.text(
                      text: 'Edit',
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
