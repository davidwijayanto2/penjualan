import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:penjualan/screen/utilities/backup_restore/backup_restore_controller.dart';
import 'package:penjualan/utils/common_text.dart';
import 'package:penjualan/utils/common_widgets.dart';
import 'package:penjualan/utils/my_colors.dart';

class BackupRestoreView extends BackupRestoreController {
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
            CommonWidgets.containedButton(
              onPressed: () async {
                await backupDatabase(context);
              },
              text: 'BACKUP',
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
            CommonWidgets.containedButton(
              text: 'RESTORE',
              onPressed: () async {
                await restoreDatabase(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
