import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'package:snde/constants.dart';
import 'package:snde/functions.dart';
import 'package:snde/models/report.dart';
import 'package:snde/models/user.dart';
import 'package:snde/services/api_service.dart';
import 'package:snde/services/auth_service.dart';
import 'package:snde/services/store_service.dart';
import 'package:snde/widgets/input_decoration_widget.dart';

class ViewReportPage extends StatefulWidget {
  const ViewReportPage({Key? key}) : super(key: key);

  @override
  ViewReportPageState createState() => ViewReportPageState();
}

class ViewReportPageState extends State<ViewReportPage> {
  final _formKey = GlobalKey<FormState>();

  bool _inited = false;
  Report? _report;
  bool _loading = false;

  Future<void> _closeReport(String? value) async {
    if (value == null || value.isEmpty) {
      showToast(t(context, 'view_report.select_from_menu'));
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final result = await apiService.patch(
          'reports/${_report?.id}/technical_update',
          body: {'status': value});
      if (result['result']['status'] == 'ok') {
        showToast(t(context, 'view_report.sent'), color: Colors.green);
        AuthService.of(context).removeNotification(_report);
        Navigator.pop(context);
      } else if (result['result']['message'] == 'no_report') {
        showToast(t(context, 'view_report.no_report'), color: Colors.red);
      } else if (result['result']['message'] == 'no_status') {
        showToast(t(context, 'view_report.select_status'), color: Colors.red);
      } else {
        throw result['result']['message'];
      }
    } catch (error) {
      showToast(t(context, 'unknown_error'));
    }
    if (!mounted) return;

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_inited) {
      _inited = true;
      _report = ModalRoute.of(context)!.settings.arguments as Report;
    }

    final AuthService model = AuthService.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
            title: Text(t(context, 'view_report.report_details')),
            centerTitle: true),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    _buildLine('${model.reportTypes[_report?.reportType]}',
                        fontSize: 19),
                    if(_report?.createdAt != null && _report?.createdAt != 'null')...[
                    const SizedBox(height: 1),
                    _buildLine(formatDate('${_report?.createdAt}')),
                    ],
                    const SizedBox(height: 1),
                    _buildLine(
                      '${t(context, 'report_status')}: ${t(context, _report?.status)}',
                      textColor: reportStatusColor('${_report?.status}'),
                    ),
                    const SizedBox(height: 1),
                    _buildLine(
                        '${t(context, 'view_report.state')}: ${_report?.stateName}'),
                    const SizedBox(height: 1),
                    _buildLine(
                        '${t(context, 'view_report.city')}: ${_report?.cityName}'),
                    const SizedBox(height: 1),
                    _buildLine(
                        '${t(context, 'view_report.region')}: ${_report?.regionName}'),
                    const SizedBox(height: 1),
                    _buildLine(
                        '${t(context, 'description')}: ${_report?.description}'),
                    const SizedBox(height: 1),
                    if (_report?.technicalName != null &&
                        _report!.technicalName.isNotEmpty && model.user?.userType == 'manager') ...[
                      _buildLine(
                          '${t(context, 'technical_name')}: ${_report?.technicalName}'),
                      const SizedBox(height: 1),
                    ],
                    if(_report?.firstName != null && _report?.firstName != 'null')
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        icon: const FaIcon(FontAwesomeIcons.userAlt),
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15)),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.black),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          elevation: MaterialStateProperty.all(0),
                          textStyle: MaterialStateProperty.all(const TextStyle(
                            fontSize: 16,
                          )),
                          shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero)),
                        ),
                        onPressed: () => Navigator.pushNamed(
                            context, '/person_info',
                            arguments: _report),
                        label: Text('${_report?.firstName}'),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Container(
                      color: Colors.white,
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      alignment: Alignment.center,
                      child: CachedNetworkImage(
                        imageUrl: '$baseUrl/images/${_report?.id}',
                        placeholder: (context, url) => const Center(
                            child: SizedBox(
                                width: 40,
                                height: 40,
                                child: CircularProgressIndicator())),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: _loading
                  ? Container(
                      padding: EdgeInsets.all(10),
                      height: 60,
                      width: 60,
                      child: CircularProgressIndicator())
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //model.user!.userType == 'technical' &&
                        // _report!.status == 'technical'

                        //model.user!.userType == 'manager' &&
                        // _report!.status == 'new'
                        if (model.user!.userType == 'manager' &&
                            _report!.status == 'new') ...[
                          _buildButton(
                              color: Theme.of(context).primaryColor,
                              icon: FontAwesomeIcons.tools,
                              text: t(context, 'view_report.work_on_it'),
                              onTap: () => Navigator.pushNamed(
                                  context, '/accept',
                                  arguments: _report)),
                          // _buildButton(
                          //     color: Colors.red,
                          //     icon: FontAwesomeIcons.minusCircle,
                          //     text: t(context, 'view_report.hide'),
                          //     onTap: (){
                          //       model.removeNotification(_report);
                          //       Navigator.pop(context);
                          //     }),
                        ],
                        if (model.user!.userType == 'technical' &&
                            _report!.status == 'technical') ...[
                          _buildButton(
                              color: Theme.of(context).primaryColor,
                              icon: FontAwesomeIcons.checkCircle,
                              text: t(context, 'solved'),
                              onTap: () => _closeReport('solved')),
                          _buildButton(
                              color: Colors.red,
                              icon: FontAwesomeIcons.exclamationTriangle,
                              text: t(context, 'fake'),
                              onTap: () => _closeReport('fake')),
                        ],
                        if (_report!.latlng.isNotEmpty)
                          _buildButton(
                            color: Colors.green,
                            icon: FontAwesomeIcons.mapMarkerAlt,
                            text: t(context, 'location'),
                            onTap: () {
                              List<String> latlng = _report!.latlng.split(',');
                              MapsLauncher.launchCoordinates(
                                  double.parse(latlng.first),
                                  double.parse(latlng.last));
                            },
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
      {required IconData icon,
      required String text,
      required Color color,
      required void Function() onTap}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        child: ElevatedButton.icon(
          icon: FaIcon(icon),
          style: ButtonStyle(
              padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 15)),
              backgroundColor: MaterialStateProperty.all(color),
              elevation: MaterialStateProperty.all(0),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)))),
          onPressed: onTap,
          label: Text(text),
        ),
      ),
    );
  }

  Widget _buildLine(String value,
      {Color textColor = Colors.black, double fontSize = 16}) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      alignment: Alignment.center,
      child: Text(
        value,
        style: TextStyle(color: textColor, fontSize: fontSize),
      ),
    );
  }
}
