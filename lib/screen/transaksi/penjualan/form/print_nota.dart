import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:penjualan/model/penjualan.dart';
import 'package:penjualan/utils/common_widgets.dart';
import 'package:penjualan/utils/date_formatter.dart';
import 'package:penjualan/utils/string_formatter.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:penjualan/utils/common_helper.dart';

class PrintNota extends StatelessWidget {
  final List<HJual> hJualList;

  const PrintNota(this.hJualList, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar:
            CommonWidgets.customAppBar(context, titleText: 'Nota Penjualan'),
        body: PdfPreview(
          build: (format) => _generatePdf(format, hJualList),
        ),
      ),
    );
  }

  rowItem(int index, pw.Font? ttf) {
    return pw.Row(
      children: [
        pw.Container(
          padding: pw.EdgeInsets.fromLTRB(2, 2, 2, 2),
          width: CommonHelpers.convertMMtoPx(mm: 4),
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
                right: pw.BorderSide(),
              ),
            ),
            alignment: pw.Alignment.centerLeft,
            child: pw.Text(
              hJualList[index].nmBarang ?? '-',
              style: pw.TextStyle(
                fontSize: 7,
                font: ttf,
              ),
            ),
          ),
        ),
        pw.Container(
          padding: pw.EdgeInsets.fromLTRB(2, 2, 2, 2),
          width: CommonHelpers.convertMMtoPx(mm: 10),
          decoration: pw.BoxDecoration(
            border: pw.Border(
              right: pw.BorderSide(),
            ),
          ),
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            dJualList[index].quantity.toString(),
            style: pw.TextStyle(
              fontSize: 7,
              font: ttf,
            ),
          ),
        ),
        pw.Container(
          padding: pw.EdgeInsets.fromLTRB(2, 2, 2, 2),
          width: CommonHelpers.convertMMtoPx(mm: 12),
          decoration: pw.BoxDecoration(
            border: pw.Border(
              right: pw.BorderSide(),
            ),
          ),
          alignment: pw.Alignment.center,
          child: pw.Text(
            dJualList[index].satuan ?? '-',
            style: pw.TextStyle(
              fontSize: 7,
              font: ttf,
            ),
          ),
        ),
        pw.Container(
          padding: pw.EdgeInsets.fromLTRB(2, 2, 2, 2),
          width: CommonHelpers.convertMMtoPx(mm: 20),
          decoration: pw.BoxDecoration(
            border: pw.Border(
              right: pw.BorderSide(),
            ),
          ),
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            thousandSeparator(dJualList[index].hargaBarang, separator: '.'),
            style: pw.TextStyle(
              fontSize: 7,
              font: ttf,
            ),
          ),
        ),
        pw.Container(
          padding: pw.EdgeInsets.fromLTRB(2, 2, 2, 2),
          width: CommonHelpers.convertMMtoPx(mm: 32),
          decoration: pw.BoxDecoration(
            border: pw.Border(
              right: pw.BorderSide(),
            ),
          ),
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            thousandSeparator(dJualList[index].subtotal, separator: '.'),
            style: pw.TextStyle(
              fontSize: 7,
              font: ttf,
            ),
          ),
        )
      ],
    );
  }

  Future<Uint8List> _generatePdf(
      PdfPageFormat format, List<HJual> hJualList) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_4, compress: true);
    final ttf = await fontFromAssetBundle('assets/fonts/arial/arial.ttf');

    pdf.addPage(
      pw.Page(
        pageFormat: format.landscape,
        build: (context) {
          return pw.Container(
            padding: pw.EdgeInsets.fromLTRB(
              CommonHelpers.convertMMtoPx(mm: 25),
              CommonHelpers.convertMMtoPx(mm: 6),
              CommonHelpers.convertMMtoPx(mm: 25),
              CommonHelpers.convertMMtoPx(mm: 13),
            ),
            child: pw.ListView.builder(
              itemBuilder: (context, index) {
                return index == 0
                    ? pw.Column(
                        children: [
                          pw.Row(
                            children: [
                              pw.Container(
                                padding: pw.EdgeInsets.fromLTRB(2, 2, 2, 6),
                                width: CommonHelpers.convertMMtoPx(mm: 4),
                                decoration: pw.BoxDecoration(
                                  border: pw.Border(
                                    top: pw.BorderSide(),
                                    left: pw.BorderSide(),
                                    bottom: pw.BorderSide(),
                                    right: pw.BorderSide(width: 0.5),
                                  ),
                                ),
                                alignment: pw.Alignment.topCenter,
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
                                  padding: pw.EdgeInsets.fromLTRB(2, 2, 2, 6),
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border(
                                      top: pw.BorderSide(),
                                      bottom: pw.BorderSide(),
                                      right: pw.BorderSide(),
                                    ),
                                  ),
                                  alignment: pw.Alignment.topLeft,
                                  child: pw.Text(
                                    'Nama Barang',
                                    style: pw.TextStyle(
                                      fontSize: 7,
                                      font: ttf,
                                    ),
                                  ),
                                ),
                              ),
                              pw.Container(
                                padding: pw.EdgeInsets.fromLTRB(2, 2, 2, 6),
                                width: CommonHelpers.convertMMtoPx(mm: 10),
                                decoration: pw.BoxDecoration(
                                  border: pw.Border(
                                    top: pw.BorderSide(),
                                    bottom: pw.BorderSide(),
                                    right: pw.BorderSide(),
                                  ),
                                ),
                                alignment: pw.Alignment.topRight,
                                child: pw.Text(
                                  'Qty',
                                  style: pw.TextStyle(
                                    fontSize: 7,
                                    font: ttf,
                                  ),
                                ),
                              ),
                              pw.Container(
                                padding: pw.EdgeInsets.fromLTRB(2, 2, 2, 6),
                                width: CommonHelpers.convertMMtoPx(mm: 12),
                                decoration: pw.BoxDecoration(
                                  border: pw.Border(
                                    top: pw.BorderSide(),
                                    bottom: pw.BorderSide(),
                                    right: pw.BorderSide(),
                                  ),
                                ),
                                alignment: pw.Alignment.topCenter,
                                child: pw.Text(
                                  'Satuan',
                                  style: pw.TextStyle(
                                    fontSize: 7,
                                    font: ttf,
                                  ),
                                ),
                              ),
                              pw.Container(
                                padding: pw.EdgeInsets.fromLTRB(2, 2, 2, 6),
                                width: CommonHelpers.convertMMtoPx(mm: 20),
                                decoration: pw.BoxDecoration(
                                  border: pw.Border(
                                    top: pw.BorderSide(),
                                    bottom: pw.BorderSide(),
                                    right: pw.BorderSide(),
                                  ),
                                ),
                                alignment: pw.Alignment.topRight,
                                child: pw.Text(
                                  'Harga',
                                  style: pw.TextStyle(
                                    fontSize: 7,
                                    font: ttf,
                                  ),
                                ),
                              ),
                              pw.Container(
                                padding: pw.EdgeInsets.fromLTRB(2, 2, 2, 6),
                                width: CommonHelpers.convertMMtoPx(mm: 32),
                                decoration: pw.BoxDecoration(
                                  border: pw.Border(
                                    top: pw.BorderSide(),
                                    bottom: pw.BorderSide(),
                                    right: pw.BorderSide(),
                                  ),
                                ),
                                alignment: pw.Alignment.topRight,
                                child: pw.Text(
                                  'Subtotal',
                                  style: pw.TextStyle(
                                    fontSize: 7,
                                    font: ttf,
                                  ),
                                ),
                              )
                            ],
                          ),
                          rowItem(index, ttf),
                        ],
                      )
                    : index == dJualList.length - 1
                        ? pw.Column(
                            children: [
                              rowItem(index, ttf),
                              pw.Row(
                                children: [
                                  pw.Expanded(
                                    child: pw.Container(
                                      padding:
                                          pw.EdgeInsets.fromLTRB(2, 2, 2, 6),
                                      height: 16,
                                      decoration: pw.BoxDecoration(
                                        border: pw.Border(
                                          top: pw.BorderSide(),
                                          left: pw.BorderSide(),
                                          bottom: pw.BorderSide(),
                                          right: pw.BorderSide(),
                                        ),
                                      ),
                                      alignment: pw.Alignment.topCenter,
                                    ),
                                  ),
                                  pw.Container(
                                    padding: pw.EdgeInsets.fromLTRB(2, 2, 2, 6),
                                    width: CommonHelpers.convertMMtoPx(mm: 20),
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border(
                                        top: pw.BorderSide(),
                                        bottom: pw.BorderSide(),
                                        right: pw.BorderSide(),
                                      ),
                                    ),
                                    alignment: pw.Alignment.topRight,
                                    child: pw.Text(
                                      'Grand Total',
                                      style: pw.TextStyle(
                                        fontSize: 7,
                                        font: ttf,
                                      ),
                                    ),
                                  ),
                                  pw.Container(
                                    padding: pw.EdgeInsets.fromLTRB(2, 2, 2, 6),
                                    width: CommonHelpers.convertMMtoPx(mm: 32),
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border(
                                        top: pw.BorderSide(),
                                        bottom: pw.BorderSide(),
                                        right: pw.BorderSide(),
                                      ),
                                    ),
                                    alignment: pw.Alignment.topRight,
                                    child: pw.Text(
                                      thousandSeparator(hJual.grandTotal,
                                          separator: '.'),
                                      style: pw.TextStyle(
                                        fontSize: 7,
                                        font: ttf,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          )
                        : rowItem(index, ttf);
              },
              itemCount: hJualList.length,
            ),
          );
        },
      ),
    );

    return pdf.save();
  }
}
