import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:penjualan/screen/utilities/backup_restore/backup_restore_controller.dart';
import 'package:penjualan/screen/utilities/backup_restore_sebagian/backup_restore_sebagian_controller.dart';
import 'package:penjualan/utils/common_text.dart';
import 'package:penjualan/utils/common_widgets.dart';
import 'package:penjualan/utils/my_colors.dart';

class BackupRestoreSebagianView extends BackupRestoreSebagianController {
  @override
  Widget build(BuildContext context) {
    return CommonWidgets.baseFormContainer(
      context: context,
      child: SafeArea(
        child: Scaffold(
          appBar: CommonWidgets.customAppBar(context,
              titleText: 'Backup & Restore Database'),
          backgroundColor: MyColors.white,
          body: _loginBody(),
        ),
      ),
    );
  }

  _loginBody() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 15,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText.text(
              text: "Backup Database",
              style: CommonText.title(
                color: MyColors.black,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            CommonWidgets.textIconButton(
              height: 36,
              suffixIcon: Icon(
                FontAwesomeIcons.calendarAlt,
                color: MyColors.themeColor1,
                size: 20,
              ),
              text: filterPeriode,
              onPressed: onPressDate,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: CommonWidgets.containedButton(
                    onPressed: () {
                      backupDatabasePenjualan();
                    },
                    text: 'BACKUP PENJUALAN',
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: CommonWidgets.containedButton(
                    onPressed: () {
                      backupDatabasePembelian();
                    },
                    text: 'BACKUP PEMBELIAN',
                  ),
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            CommonText.text(
              text: "Restore Database",
              style: CommonText.title(
                color: MyColors.black,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: CommonWidgets.containedButton(
                    text: 'RESTORE PENJUALAN',
                    onPressed: () {
                      restoreDatabasePenjualan();
                    },
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: CommonWidgets.containedButton(
                    text: 'RESTORE PEMBELIAN',
                    onPressed: () {
                      restoreDatabasePembelian();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            CommonText.text(
              text: "Restore Master",
              style: CommonText.title(
                color: MyColors.black,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            CommonWidgets.containedButton(
              text: 'RESTORE MASTER',
              onPressed: () {
                restoreDatabaseMaster();
              },
            ),
          ],
        ),
      ),
    );
  }
}
