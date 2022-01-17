import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:penjualan/model/pembelian.dart';
import 'package:penjualan/utils/common_widgets.dart';
import 'package:penjualan/utils/date_formatter.dart';
import 'package:penjualan/utils/my_colors.dart';
import 'package:penjualan/utils/string_formatter.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:penjualan/utils/common_helper.dart';

class PrintLaporanPembelian extends StatelessWidget {
  final List<HBeli> hBeliList;
  final String total;

  const PrintLaporanPembelian(this.hBeliList, this.total, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar:
            CommonWidgets.customAppBar(context, titleText: 'Nota Pembelian'),
        body: PdfPreview(
          build: (format) => _generatePdf(format, hBeliList),
        ),
      ),
    );
  }

  rowItem(List<HBeli> listBeli, int index, pw.Font? ttf, context) {
    return pw.Row(
      children: [
        pw.Container(
          padding: pw.EdgeInsets.fromLTRB(2, 2, 2, 2),
          width: CommonHelpers.convertMMtoPx(mm: 6),
          decoration: pw.BoxDecoration(
            border: pw.Border(
              left: pw.BorderSide(),
              right: pw.BorderSide(width: 0.5),
            ),
          ),
          alignment: pw.Alignment.centerLeft,
          child: pw.Text(
            (index + 1).toString(),
            style: pw.TextStyle(
              fontSize: 7,
              font: ttf,
            ),
          ),
        ),
        pw.Expanded(
          child: pw.Container(
            padding: pw.EdgeInsets.fromLTRB(2, 2, 2, 2),
            decoration: pw.BoxDecoration(
              border: pw.Border(
                right: pw.BorderSide(width: 0.5),
              ),
            ),
            alignment: pw.Alignment.centerLeft,
            child: pw.Text(
              listBeli[index].nonota ?? '-',
              style: pw.TextStyle(
                fontSize: 7,
                font: ttf,
              ),
            ),
          ),
        ),
        pw.Container(
          padding: pw.EdgeInsets.fromLTRB(2, 2, 2, 2),
          width: CommonHelpers.convertMMtoPx(mm: 15),
          decoration: pw.BoxDecoration(
            border: pw.Border(
              right: pw.BorderSide(width: 0.5),
            ),
          ),
          alignment: pw.Alignment.center,
          child: pw.Text(
            DateFormatter.toNumberDateText(
                context, DateTime.parse(listBeli[index].tglTransaksi ?? '-')),
            style: pw.TextStyle(
              fontSize: 7,
              font: ttf,
            ),
          ),
        ),
        pw.Expanded(
          child: pw.Container(
            padding: pw.EdgeInsets.fromLTRB(2, 2, 2, 2),
            decoration: pw.BoxDecoration(
              border: pw.Border(
                right: pw.BorderSide(width: 0.5),
              ),
            ),
            alignment: pw.Alignment.centerLeft,
            child: pw.Text(
              listBeli[index].nmSupplier ?? '-',
              style: pw.TextStyle(
                fontSize: 7,
                font: ttf,
              ),
            ),
          ),
        ),
        pw.Container(
          padding: pw.EdgeInsets.fromLTRB(2, 2, 2, 2),
          width: CommonHelpers.convertMMtoPx(mm: 16),
          decoration: pw.BoxDecoration(
            border: pw.Border(
              right: pw.BorderSide(),
            ),
          ),
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            thousandSeparator(listBeli[index].grandTotal, separator: '.'),
            style: pw.TextStyle(
              fontSize: 7,
              font: ttf,
            ),
          ),
        ),
      ],
    );
  }

  Future<Uint8List> _generatePdf(
      PdfPageFormat format, List<HBeli> hBeliList) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_4, compress: true);
    final ttf = await fontFromAssetBundle('assets/fonts/arial/arial.ttf');
    // var listjual = <HJual>[], listPageJual = <List<HJual>>[];
    // List<pw.Widget> listPage = [];
    // int i = 0;
    // bool flag = false;
    // while (!flag) {
    //   if (i < hJualList.length) {
    //     if (i > 0 && i % 32 == 0) {
    //       listPageJual.add(listjual);
    //     } else {
    //       listjual.add(hJualList[i]);
    //     }
    //     i++;
    //   } else {
    //     listPageJual.add(listjual);
    //     flag = true;
    //   }
    // }
    // for (List<HJual> listHjual in listPageJual) {
    //   listPage.add(pw.Container(
    //     padding: pw.EdgeInsets.fromLTRB(
    //       CommonHelpers.convertMMtoPx(mm: 25),
    //       CommonHelpers.convertMMtoPx(mm: 6),
    //       CommonHelpers.convertMMtoPx(mm: 25),
    //       CommonHelpers.convertMMtoPx(mm: 13),
    //     ),
    //     child: pw.ListView.builder(
    //       itemBuilder: (context, index) {
    //         return index == 0
    //             ? pw.Column(
    //                 children: [
    //                   pw.Row(
    //                     children: [
    //                       pw.Container(
    //                         padding: pw.EdgeInsets.fromLTRB(2, 2, 2, 6),
    //                         width: CommonHelpers.convertMMtoPx(mm: 4),
    //                         decoration: pw.BoxDecoration(
    //                           border: pw.Border(
    //                             top: pw.BorderSide(),
    //                             left: pw.BorderSide(),
    //                             bottom: pw.BorderSide(width: 0.5),
    //                             right: pw.BorderSide(width: 0.5),
    //                           ),
    //                         ),
    //                         alignment: pw.Alignment.centerLeft,
    //                         child: pw.Text(
    //                           'No',
    //                           style: pw.TextStyle(
    //                             fontSize: 7,
    //                             font: ttf,
    //                           ),
    //                         ),
    //                       ),
    //                       pw.Expanded(
    //                         child: pw.Container(
    //                           padding: pw.EdgeInsets.fromLTRB(2, 2, 2, 6),
    //                           decoration: pw.BoxDecoration(
    //                             border: pw.Border(
    //                               top: pw.BorderSide(),
    //                               bottom: pw.BorderSide(width: 0.5),
    //                               right: pw.BorderSide(width: 0.5),
    //                             ),
    //                           ),
    //                           alignment: pw.Alignment.centerLeft,
    //                           child: pw.Text(
    //                             'Nomor Nota',
    //                             style: pw.TextStyle(
    //                               fontSize: 7,
    //                               font: ttf,
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                       pw.Container(
    //                         padding: pw.EdgeInsets.fromLTRB(2, 2, 2, 6),
    //                         width: CommonHelpers.convertMMtoPx(mm: 15),
    //                         decoration: pw.BoxDecoration(
    //                           border: pw.Border(
    //                             top: pw.BorderSide(),
    //                             bottom: pw.BorderSide(width: 0.5),
    //                             right: pw.BorderSide(width: 0.5),
    //                           ),
    //                         ),
    //                         alignment: pw.Alignment.center,
    //                         child: pw.Text(
    //                           'Tanggal',
    //                           style: pw.TextStyle(
    //                             fontSize: 7,
    //                             font: ttf,
    //                           ),
    //                         ),
    //                       ),
    //                       pw.Expanded(
    //                         child: pw.Container(
    //                           padding: pw.EdgeInsets.fromLTRB(2, 2, 2, 6),
    //                           width: CommonHelpers.convertMMtoPx(mm: 12),
    //                           decoration: pw.BoxDecoration(
    //                             border: pw.Border(
    //                               top: pw.BorderSide(),
    //                               bottom: pw.BorderSide(width: 0.5),
    //                               right: pw.BorderSide(width: 0.5),
    //                             ),
    //                           ),
    //                           alignment: pw.Alignment.centerLeft,
    //                           child: pw.Text(
    //                             'Customer',
    //                             style: pw.TextStyle(
    //                               fontSize: 7,
    //                               font: ttf,
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                       pw.Container(
    //                         padding: pw.EdgeInsets.fromLTRB(2, 2, 2, 6),
    //                         width: CommonHelpers.convertMMtoPx(mm: 20),
    //                         decoration: pw.BoxDecoration(
    //                           border: pw.Border(
    //                             top: pw.BorderSide(),
    //                             bottom: pw.BorderSide(width: 0.5),
    //                             right: pw.BorderSide(),
    //                           ),
    //                         ),
    //                         alignment: pw.Alignment.centerRight,
    //                         child: pw.Text(
    //                           'Grand Total',
    //                           style: pw.TextStyle(
    //                             fontSize: 7,
    //                             font: ttf,
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                   rowItem(listHjual, index, ttf, context),
    //                 ],
    //               )
    //             : index == listHjual.length - 1
    //                 ? pw.Column(
    //                     children: [
    //                       rowItem(listHjual, index, ttf, context),
    //                       pw.Row(
    //                         children: [
    //                           pw.Container(
    //                             padding: pw.EdgeInsets.fromLTRB(2, 2, 2, 6),
    //                             width: CommonHelpers.convertMMtoPx(mm: 4),
    //                             decoration: pw.BoxDecoration(
    //                               border: pw.Border(
    //                                 top: pw.BorderSide(width: 0.5),
    //                                 left: pw.BorderSide(),
    //                                 bottom: pw.BorderSide(),
    //                                 right: pw.BorderSide(width: 0.5),
    //                               ),
    //                             ),
    //                             alignment: pw.Alignment.centerLeft,
    //                             child: pw.Text(
    //                               'a',
    //                               style: pw.TextStyle(
    //                                 fontSize: 7,
    //                                 font: ttf,
    //                                 color: PdfColors.white,
    //                               ),
    //                             ),
    //                           ),
    //                           pw.Expanded(
    //                             child: pw.Container(
    //                               padding: pw.EdgeInsets.fromLTRB(2, 2, 2, 6),
    //                               decoration: pw.BoxDecoration(
    //                                 border: pw.Border(
    //                                   top: pw.BorderSide(width: 0.5),
    //                                   bottom: pw.BorderSide(),
    //                                   right: pw.BorderSide(width: 0.5),
    //                                 ),
    //                               ),
    //                               alignment: pw.Alignment.centerLeft,
    //                               child: pw.Text(
    //                                 'a',
    //                                 style: pw.TextStyle(
    //                                   fontSize: 7,
    //                                   font: ttf,
    //                                   color: PdfColors.white,
    //                                 ),
    //                               ),
    //                             ),
    //                           ),
    //                           pw.Container(
    //                             padding: pw.EdgeInsets.fromLTRB(2, 2, 2, 6),
    //                             width: CommonHelpers.convertMMtoPx(mm: 15),
    //                             decoration: pw.BoxDecoration(
    //                               border: pw.Border(
    //                                 top: pw.BorderSide(width: 0.5),
    //                                 bottom: pw.BorderSide(),
    //                                 right: pw.BorderSide(width: 0.5),
    //                               ),
    //                             ),
    //                             alignment: pw.Alignment.center,
    //                             child: pw.Text(
    //                               'a',
    //                               style: pw.TextStyle(
    //                                 fontSize: 7,
    //                                 font: ttf,
    //                                 color: PdfColors.white,
    //                               ),
    //                             ),
    //                           ),
    //                           pw.Expanded(
    //                             child: pw.Container(
    //                               padding: pw.EdgeInsets.fromLTRB(2, 2, 2, 6),
    //                               decoration: pw.BoxDecoration(
    //                                 border: pw.Border(
    //                                   top: pw.BorderSide(width: 0.5),
    //                                   bottom: pw.BorderSide(),
    //                                   right: pw.BorderSide(width: 0.5),
    //                                 ),
    //                               ),
    //                               alignment: pw.Alignment.centerRight,
    //                               child: pw.Text(
    //                                 'Grand Total',
    //                                 style: pw.TextStyle(
    //                                   fontSize: 7,
    //                                   font: ttf,
    //                                 ),
    //                               ),
    //                             ),
    //                           ),
    //                           pw.Container(
    //                             padding: pw.EdgeInsets.fromLTRB(2, 2, 2, 6),
    //                             width: CommonHelpers.convertMMtoPx(mm: 20),
    //                             decoration: pw.BoxDecoration(
    //                               border: pw.Border(
    //                                 top: pw.BorderSide(width: 0.5),
    //                                 bottom: pw.BorderSide(),
    //                                 right: pw.BorderSide(),
    //                               ),
    //                             ),
    //                             alignment: pw.Alignment.centerRight,
    //                             child: pw.Text(
    //                               total,
    //                               style: pw.TextStyle(
    //                                 fontSize: 7,
    //                                 font: ttf,
    //                               ),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ],
    //                   )
    //                 : rowItem(listHjual, index, ttf, context);
    //       },
    //       itemCount: listHjual.length,
    //     ),
    //   ));
    // }
    pdf.addPage(
      pw.MultiPage(
        maxPages: 999,
        pageFormat: format.landscape,
        build: (context) {
          return [
            pw.Container(
              padding: pw.EdgeInsets.fromLTRB(
                CommonHelpers.convertMMtoPx(mm: 25),
                CommonHelpers.convertMMtoPx(mm: 6),
                CommonHelpers.convertMMtoPx(mm: 25),
                CommonHelpers.convertMMtoPx(mm: 13),
              ),
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    for (int index = 0; index < hBeliList.length; index++)
                      index == 0
                          ? pw.Column(
                              children: [
                                pw.Row(
                                  children: [
                                    pw.Container(
                                      padding:
                                          pw.EdgeInsets.fromLTRB(2, 2, 2, 6),
                                      width: CommonHelpers.convertMMtoPx(mm: 6),
                                      decoration: pw.BoxDecoration(
                                        border: pw.Border(
                                          top: pw.BorderSide(),
                                          left: pw.BorderSide(),
                                          bottom: pw.BorderSide(width: 0.5),
                                          right: pw.BorderSide(width: 0.5),
                                        ),
                                      ),
                                      alignment: pw.Alignment.centerLeft,
                                      child: pw.Text(
                                        'No',
                                        style: pw.TextStyle(
                                          fontSize: 7,
                                          font: ttf,
                                        ),
                                      ),
                                    ),
                                    pw.Expanded(
                                      child: pw.Container(
                                        padding:
                                            pw.EdgeInsets.fromLTRB(2, 2, 2, 6),
                                        decoration: pw.BoxDecoration(
                                          border: pw.Border(
                                            top: pw.BorderSide(),
                                            bottom: pw.BorderSide(width: 0.5),
                                            right: pw.BorderSide(width: 0.5),
                                          ),
                                        ),
                                        alignment: pw.Alignment.centerLeft,
                                        child: pw.Text(
                                          'Nomor Nota',
                                          style: pw.TextStyle(
                                            fontSize: 7,
                                            font: ttf,
                                          ),
                                        ),
                                      ),
                                    ),
                                    pw.Container(
                                      padding:
                                          pw.EdgeInsets.fromLTRB(2, 2, 2, 6),
                                      width:
                                          CommonHelpers.convertMMtoPx(mm: 15),
                                      decoration: pw.BoxDecoration(
                                        border: pw.Border(
                                          top: pw.BorderSide(),
                                          bottom: pw.BorderSide(width: 0.5),
                                          right: pw.BorderSide(width: 0.5),
                                        ),
                                      ),
                                      alignment: pw.Alignment.center,
                                      child: pw.Text(
                                        'Tanggal',
                                        style: pw.TextStyle(
                                          fontSize: 7,
                                          font: ttf,
                                        ),
                                      ),
                                    ),
                                    pw.Expanded(
                                      child: pw.Container(
                                        padding:
                                            pw.EdgeInsets.fromLTRB(2, 2, 2, 6),
                                        width:
                                            CommonHelpers.convertMMtoPx(mm: 12),
                                        decoration: pw.BoxDecoration(
                                          border: pw.Border(
                                            top: pw.BorderSide(),
                                            bottom: pw.BorderSide(width: 0.5),
                                            right: pw.BorderSide(width: 0.5),
                                          ),
                                        ),
                                        alignment: pw.Alignment.centerLeft,
                                        child: pw.Text(
                                          'Supplier',
                                          style: pw.TextStyle(
                                            fontSize: 7,
                                            font: ttf,
                                          ),
                                        ),
                                      ),
                                    ),
                                    pw.Container(
                                      padding:
                                          pw.EdgeInsets.fromLTRB(2, 2, 2, 6),
                                      width:
                                          CommonHelpers.convertMMtoPx(mm: 16),
                                      decoration: pw.BoxDecoration(
                                        border: pw.Border(
                                          top: pw.BorderSide(),
                                          bottom: pw.BorderSide(width: 0.5),
                                          right: pw.BorderSide(),
                                        ),
                                      ),
                                      alignment: pw.Alignment.centerRight,
                                      child: pw.Text(
                                        'Grand Total',
                                        style: pw.TextStyle(
                                          fontSize: 7,
                                          font: ttf,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                rowItem(hBeliList, index, ttf, context),
                              ],
                            )
                          : index == hBeliList.length - 1
                              ? pw.Column(
                                  children: [
                                    rowItem(hBeliList, index, ttf, context),
                                    pw.Row(
                                      children: [
                                        pw.Container(
                                          padding: pw.EdgeInsets.fromLTRB(
                                              2, 2, 2, 6),
                                          width: CommonHelpers.convertMMtoPx(
                                              mm: 6),
                                          decoration: pw.BoxDecoration(
                                            border: pw.Border(
                                              top: pw.BorderSide(width: 0.5),
                                              left: pw.BorderSide(),
                                              bottom: pw.BorderSide(),
                                              right: pw.BorderSide(width: 0.5),
                                            ),
                                          ),
                                          alignment: pw.Alignment.centerLeft,
                                          child: pw.Text(
                                            'a',
                                            style: pw.TextStyle(
                                              fontSize: 7,
                                              font: ttf,
                                              color: PdfColors.white,
                                            ),
                                          ),
                                        ),
                                        pw.Expanded(
                                          child: pw.Container(
                                            padding: pw.EdgeInsets.fromLTRB(
                                                2, 2, 2, 6),
                                            decoration: pw.BoxDecoration(
                                              border: pw.Border(
                                                top: pw.BorderSide(width: 0.5),
                                                bottom: pw.BorderSide(),
                                                right:
                                                    pw.BorderSide(width: 0.5),
                                              ),
                                            ),
                                            alignment: pw.Alignment.centerLeft,
                                            child: pw.Text(
                                              'a',
                                              style: pw.TextStyle(
                                                fontSize: 7,
                                                font: ttf,
                                                color: PdfColors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        pw.Container(
                                          padding: pw.EdgeInsets.fromLTRB(
                                              2, 2, 2, 6),
                                          width: CommonHelpers.convertMMtoPx(
                                              mm: 15),
                                          decoration: pw.BoxDecoration(
                                            border: pw.Border(
                                              top: pw.BorderSide(width: 0.5),
                                              bottom: pw.BorderSide(),
                                              right: pw.BorderSide(width: 0.5),
                                            ),
                                          ),
                                          alignment: pw.Alignment.center,
                                          child: pw.Text(
                                            'a',
                                            style: pw.TextStyle(
                                              fontSize: 7,
                                              font: ttf,
                                              color: PdfColors.white,
                                            ),
                                          ),
                                        ),
                                        pw.Expanded(
                                          child: pw.Container(
                                            padding: pw.EdgeInsets.fromLTRB(
                                                2, 2, 2, 6),
                                            decoration: pw.BoxDecoration(
                                              border: pw.Border(
                                                top: pw.BorderSide(width: 0.5),
                                                bottom: pw.BorderSide(),
                                                right:
                                                    pw.BorderSide(width: 0.5),
                                              ),
                                            ),
                                            alignment: pw.Alignment.centerRight,
                                            child: pw.Text(
                                              'Grand Total',
                                              style: pw.TextStyle(
                                                fontSize: 7,
                                                font: ttf,
                                              ),
                                            ),
                                          ),
                                        ),
                                        pw.Container(
                                          padding: pw.EdgeInsets.fromLTRB(
                                              2, 2, 2, 6),
                                          width: CommonHelpers.convertMMtoPx(
                                              mm: 16),
                                          decoration: pw.BoxDecoration(
                                            border: pw.Border(
                                              top: pw.BorderSide(width: 0.5),
                                              bottom: pw.BorderSide(),
                                              right: pw.BorderSide(),
                                            ),
                                          ),
                                          alignment: pw.Alignment.centerRight,
                                          child: pw.Text(
                                            total,
                                            style: pw.TextStyle(
                                              fontSize: 7,
                                              font: ttf,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : rowItem(hBeliList, index, ttf, context)
                  ]),
            )
          ];
        },
      ),
    );

    return pdf.save();
  }
}
