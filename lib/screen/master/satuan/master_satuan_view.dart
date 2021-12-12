import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:penjualan/model/satuan.dart';
import 'package:penjualan/routing/navigator.dart';
import 'package:penjualan/screen/master/satuan/master_satuan_controller.dart';
import 'package:penjualan/utils/common_text.dart';
import 'package:penjualan/utils/common_widgets.dart';
import 'package:penjualan/utils/my_colors.dart';

class MasterSatuanView extends MasterSatuanController {
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
            body: _masterSatuanBody(),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: FloatingActionButton(
              backgroundColor: MyColors.themeColor1,
              child: Icon(
                FontAwesomeIcons.plus,
                size: 24,
              ),
              onPressed: () {
                goToAddMasterSatuan(
                    context: context,
                    afterOpen: (value) {
                      fetchDataSatuan();
                    });
              },
            )),
      ),
    );
  }

  _masterSatuanBody() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 36,
            child: CupertinoTextField(
              controller: searchController,
              placeholder: 'Ketik teks filter di sini',
              placeholderStyle: CommonText.body1(color: MyColors.gray),
              style: CommonText.body1(color: MyColors.black),
              onSubmitted: (text) {
                fetchDataSatuan(text: text);
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
              itemCount: listSatuan?.length,
              itemBuilder: (BuildContext context, int index) {
                return _item(index, listSatuan?[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  _item(int index, Satuan? satuan) {
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
                    text: "ID: ${satuan?.idSatuan}",
                    style: CommonText.body1(
                      color: MyColors.textGray,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  CommonText.text(
                    text: "${satuan?.nmSatuan}",
                    style: CommonText.title(
                      color: MyColors.black,
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
                    onTap: () => showDialogDelete(satuan?.idSatuan),
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
                    onTap: () {},
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
