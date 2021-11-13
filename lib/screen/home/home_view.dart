import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:penjualan/routing/navigator.dart';
import 'package:penjualan/screen/home/home_controller.dart';
import 'package:penjualan/utils/common_text.dart';
import 'package:penjualan/utils/common_widgets.dart';
import 'package:penjualan/utils/my_colors.dart';

class HomeView extends HomeController {
  @override
  Widget build(BuildContext context) {
    return CommonWidgets.baseFormContainer(
      color: MyColors.themeColor1,
      context: context,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: MyColors.white,
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: MyColors.themeColor1,
            ),
            backgroundColor: MyColors.themeColor1,
            title: CommonText.text(
              text: 'Main Menu',
              style: CommonText.title(
                color: MyColors.white,
              ),
            ),
          ),
          body: _homeBody(),
        ),
      ),
    );
  }

  _homeBody() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _menuTransaksi(),
            CommonWidgets.horizontalDivider(),
            _menuMaster(),
            CommonWidgets.horizontalDivider(),
            _menuLaporan(),
            CommonWidgets.horizontalDivider(),
            _menuUtility(),
            CommonWidgets.horizontalDivider(),
            _menuLogout(),
            CommonWidgets.horizontalDivider(),
          ],
        ),
      ),
    );
  }

  _menuTransaksi() {
    return ExpandablePanel(
      theme: ExpandableThemeData(
        iconColor: MyColors.themeColor1,
        collapseIcon: FontAwesomeIcons.chevronUp,
        expandIcon: FontAwesomeIcons.chevronDown,
        iconPadding: EdgeInsets.only(top: 8),
        iconSize: 15,
        headerAlignment: ExpandablePanelHeaderAlignment.center,
      ),
      header: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            Icon(
              FontAwesomeIcons.moneyBillAlt,
              size: 18,
              color: MyColors.black,
            ),
            SizedBox(
              width: 12,
            ),
            CommonText.text(
              text: 'Transaksi',
              style: CommonText.body1(
                color: MyColors.black,
              ),
            ),
          ],
        ),
      ),
      collapsed: Container(),
      expanded: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.circle,
                      size: 18,
                      color: MyColors.black,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    CommonText.text(
                      text: 'Penjualan',
                      style: CommonText.body1(
                        color: MyColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.circle,
                      size: 18,
                      color: MyColors.black,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    CommonText.text(
                      text: 'Pembelian',
                      style: CommonText.body1(
                        color: MyColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _menuMaster() {
    return ExpandablePanel(
      theme: ExpandableThemeData(
        iconColor: MyColors.themeColor1,
        collapseIcon: FontAwesomeIcons.chevronUp,
        expandIcon: FontAwesomeIcons.chevronDown,
        iconPadding: EdgeInsets.only(top: 8),
        iconSize: 15,
        headerAlignment: ExpandablePanelHeaderAlignment.center,
      ),
      header: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            Icon(
              FontAwesomeIcons.database,
              size: 18,
              color: MyColors.black,
            ),
            SizedBox(
              width: 12,
            ),
            CommonText.text(
              text: 'Master',
              style: CommonText.body1(
                color: MyColors.black,
              ),
            ),
          ],
        ),
      ),
      collapsed: Container(),
      expanded: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.circle,
                      size: 18,
                      color: MyColors.black,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    CommonText.text(
                      text: 'Kategori',
                      style: CommonText.body1(
                        color: MyColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            InkWell(
              onTap: () => goToMasterCustomer(context: context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.circle,
                      size: 18,
                      color: MyColors.black,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    CommonText.text(
                      text: 'Customer',
                      style: CommonText.body1(
                        color: MyColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            InkWell(
              onTap: () {
                goToMasterBarang(context: context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.circle,
                      size: 18,
                      color: MyColors.black,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    CommonText.text(
                      text: 'Barang',
                      style: CommonText.body1(
                        color: MyColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.circle,
                      size: 18,
                      color: MyColors.black,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    CommonText.text(
                      text: 'Satuan',
                      style: CommonText.body1(
                        color: MyColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _menuLaporan() {
    return ExpandablePanel(
      theme: ExpandableThemeData(
        iconColor: MyColors.themeColor1,
        collapseIcon: FontAwesomeIcons.chevronUp,
        expandIcon: FontAwesomeIcons.chevronDown,
        iconPadding: EdgeInsets.only(top: 8),
        iconSize: 15,
        headerAlignment: ExpandablePanelHeaderAlignment.center,
      ),
      header: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            Icon(
              FontAwesomeIcons.calendarAlt,
              size: 18,
              color: MyColors.black,
            ),
            SizedBox(
              width: 12,
            ),
            CommonText.text(
              text: 'Laporan',
              style: CommonText.body1(
                color: MyColors.black,
              ),
            ),
          ],
        ),
      ),
      collapsed: Container(),
      expanded: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.circle,
                      size: 18,
                      color: MyColors.black,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    CommonText.text(
                      text: 'Stok Keluar',
                      style: CommonText.body1(
                        color: MyColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.circle,
                      size: 18,
                      color: MyColors.black,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    CommonText.text(
                      text: 'Stok Masuk',
                      style: CommonText.body1(
                        color: MyColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.circle,
                      size: 18,
                      color: MyColors.black,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    CommonText.text(
                      text: 'Pembelian',
                      style: CommonText.body1(
                        color: MyColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.circle,
                      size: 18,
                      color: MyColors.black,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    CommonText.text(
                      text: 'Penjualan',
                      style: CommonText.body1(
                        color: MyColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.circle,
                      size: 18,
                      color: MyColors.black,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    CommonText.text(
                      text: 'Piutang',
                      style: CommonText.body1(
                        color: MyColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _menuUtility() {
    return ExpandablePanel(
      theme: ExpandableThemeData(
        iconColor: MyColors.themeColor1,
        collapseIcon: FontAwesomeIcons.chevronUp,
        expandIcon: FontAwesomeIcons.chevronDown,
        iconPadding: EdgeInsets.only(top: 8),
        iconSize: 15,
        headerAlignment: ExpandablePanelHeaderAlignment.center,
      ),
      header: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            Icon(
              FontAwesomeIcons.tools,
              size: 18,
              color: MyColors.black,
            ),
            SizedBox(
              width: 12,
            ),
            CommonText.text(
              text: 'Utilities',
              style: CommonText.body1(
                color: MyColors.black,
              ),
            ),
          ],
        ),
      ),
      collapsed: Container(),
      expanded: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.circle,
                      size: 18,
                      color: MyColors.black,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    CommonText.text(
                      text: 'Backup & Restore',
                      style: CommonText.body1(
                        color: MyColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _menuLogout() {
    return InkWell(
      onTap: () {
        logoutDialog();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            Icon(
              FontAwesomeIcons.signOutAlt,
              size: 18,
              color: Colors.red,
            ),
            SizedBox(
              width: 12,
            ),
            CommonText.text(
              text: 'Logout',
              style: CommonText.body1(
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
