import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:snde/services/pdf_api.dart';
class PdfInvoice {
    List<String> headers = <String>[
      'Description',
      'Date',
      'Quantity',
      'Unit Price',
      'VAT',
      'Total'
    ];


  static Future<File> generate(titles_fr,data,titles_ar) async {
  final pdf = Document();


    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(titles_fr,data,titles_ar),
        SizedBox(height: 3 * PdfPageFormat.cm),

        //buildInvoice(invoice,headers),
        //Divider(),
        //buildInvoice(invoice,headers),
        //Divider(),
        //buildTotal(invoice),
      ],
      //footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static Widget buildHeader(titles_fr,data,titles_ar) => Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 50,
                width: 50,
                child: Column(children: [
                  //image
                ]),
              ),
            ],
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildInvoiceInfo(titles_fr,data,titles_ar),
              //Divider(),
              //buildInvoiceInfo(titles_fr,data,titles_ar),
              //Divider(),
              //buildInvoiceInfo(titles_fr,data,titles_ar),
              //Divider(),
            ],
          ),
        ],
      );


  static Widget buildInvoiceInfo(titles_fr,data,titles_ar) {
    


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles_fr.length, (index) {
        final title_fr = titles_fr[index];
        final value = data[index];
        final title_ar = titles_ar[index];

        return buildText(title_fr: title_fr, value: value,title_ar: title_ar, width: 200);
      }),
    );
  }
/*
  static Widget buildInvoice(invoice,headers) {

    final data = invoice.items.map((item) {
      final total = item.unitPrice * item.quantity * (1 + item.vat);

      return [
        item.description,
        item.description,
        '${item.quantity}',
        '\$ ${item.unitPrice}',
        '${item.vat} %',
        '\$ ${total.toStringAsFixed(2)}',
      ];
    }).toList();

    return Table.fromTextArray(
      headerCount: 2,
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(invoice) {
    final netTotal = invoice.items
        .map((item) => item.unitPrice * item.quantity)
        .reduce((item1, item2) => item1 + item2);
    final vatPercent = invoice.items.first.vat;
    final vat = netTotal * vatPercent;
    final total = netTotal + vat;

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title_fr: 'Net total',
                  value: netTotal,
                  title_ar: 'Net total',
                  unite: true,
                ),
                buildText(
                  title_fr: 'Net total',
                  value: netTotal,
                  title_ar: 'Net total',
                  unite: true,
                ),
                Divider(),
                buildText(
                  title_fr: 'Total amount due',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: netTotal,
                  title_ar: 'Net total',
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }
*/
  static buildText({
    required String title_fr,

    required String value,
    required String title_ar,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title_fr, style: style)),
          Text(value, style: unite ? style : null),
          Expanded(child: Text(title_ar, style: style)),
        ],
      ),
    );
  }
}
