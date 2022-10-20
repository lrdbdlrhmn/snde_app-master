import 'package:flutter/material.dart';
import 'package:snde/functions.dart';
import 'package:snde/services/api_service.dart';
import 'package:snde/services/pdf_api.dart';
import 'package:snde/services/pdf_invoice.dart';
import 'package:snde/widgets/button_widget.dart';
import 'package:snde/widgets/title_widget.dart';

class PdfPage extends StatefulWidget {
  @override
  _PdfPageState createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  var data = null;
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          padding: EdgeInsets.all(32),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TitleWidget(
                  icon: Icons.picture_as_pdf,
                  text: 'Generate Invoice',
                ),
                const SizedBox(height: 48),
                ButtonWidget(
                  text: 'Invoice PDF',
                  onClicked: () async {
                      try {
                        //doc = await PDFDocument.fromURL('$baseUrl/invoice/$_code.pdf');
                        final res = await apiService.get('invoice/12007065');
                        final result = res['result'];
                        final user = result['user'];
                        final header_with_details = result['header_with_details'];
                        final invoice_ref = result['invoice_ref'];
                        final data = [
                          '45 25 0 63 - 80001515',
                          'http://www.snde.mr',
                          header_with_details['centre'],
                          header_with_details['dateFact'],
                          user['nom'],
                          invoice_ref,
                          user['abnAdresse'],
                        ]; 
                      } catch (error) {
                        showToast(t(context, 'no_result'));
                      }
                      List<String> titles_ar = <String>[
                        //'الشركة الوطنية للماء',
                        'لإصلاح الأعطاب والاستعلامات الاتصال بالأرقام',
                        'الموقع الألكترونى',
                        'شهر الكشف على العداد',
                        'الزبون',
                        'عقد الإشتراك',
                        'العنوان'
                      ];
                          List<String> titles_fr = <String>[
                          'Dépannage nuits et jours',
                          'Site Web',
                          'Centre',
                          'Mois de relève',
                          'Client',
                          'Réf Abonnement',
                          'Adresse'
                  ];
                    final pdfFile = await PdfInvoice.generate(titles_fr,data,titles_ar);

                    PdfApi.openFile(pdfFile);
                  },
                ),
              ],
            ),
          ),
        ),
      );
}
