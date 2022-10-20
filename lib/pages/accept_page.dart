import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:snde/functions.dart';
import 'package:snde/models/report.dart';
import 'package:snde/models/user.dart';
import 'package:snde/services/api_service.dart';
import 'package:snde/services/auth_service.dart';
import 'package:snde/widgets/input_decoration_widget.dart';

const Map<String, Map<String, String>> actions = {
  'ar': {
    'solved_before': 'تم العمل على المشكلة سابقا',
    'work_on_it': 'اسناد المهمة لأحد التقنيين',
  },
  'en': {
    'solved_before': 'The problem has already been fixed',
    'work_on_it': 'Assign the task to a technician',
  },
  'fr': {
    'solved_before': 'Le problème a déjà été résolu',
    'work_on_it': 'Confier la tâche à un agent',
  },
};

class AcceptPage extends StatefulWidget {
  const AcceptPage({Key? key}) : super(key: key);

  @override
  AcceptPageState createState() => AcceptPageState();
}

class AcceptPageState extends State<AcceptPage> {
  final _formKey = GlobalKey<FormState>();

  bool _inited = false;
  Report? _report;
  String? _technicalId;
  String? _action;
  bool _loading = false;

  Future<void> _accept() async {
    _formKey.currentState!.validate();
    print(_action!.isEmpty);
    if (_action == null || _action == '') {
      
      showToast(t(context, 'accept_page.select_action'), color: Colors.red);
      return;
    }
    if (_action == 'work_on_it' &&
        (_technicalId == null || _technicalId == '')) {
      showToast(t(context, 'accept_page.select_technical'), color: Colors.red);
      return;
    }
    
    setState(() {
      _loading = true;
    });

    try {
      final result = await apiService.patch('reports/${_report?.id}', body: {
        'report': {'action': _action ?? '', 'technical_id': _technicalId ?? ''}
      });
      if (result['result']['status'] == 'ok') {
        showToast(_action == 'work_on_it' ? t(context, 'accept_page.signed_to_technical') : t(context, 'accept_page.report_status_updated'), color: Colors.green);
        AuthService.of(context).removeNotification(_report);
        Navigator.popUntil(context, (route) => route.isFirst);
      } else if (result['result']['message'] == 'taken') {
        showToast(t(context, 'accept_page.report_taken'), color: Colors.red);
      } else if (result['result']['message'] == 'no_technical') {
        showToast(t(context, 'accept_page.no_technical'), color: Colors.red);
      } else {
        throw result['result']['message'];
      }
    } catch (error) {
      print('error ${error}');
      showToast(t(context, 'unknown_error'));
    }
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

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar:
            AppBar(title: Text('${_report?.reportType}'), centerTitle: true),
        body: Consumer<AuthService>(builder: (context, model, child) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 150,
                  ),
                  const SizedBox(height: 40),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<String>(
                          value: _action,
                          isExpanded: true,
                          decoration: inputDecorationWidget(
                              text: t(context, 'accept_page.select')),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return t(context, 'accept_page.select_action');
                            }
                            return null;
                          },
                          onChanged: (String? data) {
                            setState(() {
                              _action = data;
                            });
                          },
                          items: actions[ApiService.language]!.entries.map<DropdownMenuItem<String>>(
                              (MapEntry<String, String> item) {
                            return DropdownMenuItem<String>(
                              value: item.key,
                              child: Text(item.value),
                            );
                          }).toList(),
                        ),
                        if (_action == 'work_on_it') ...[
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: _technicalId,
                            isExpanded: true,
                            decoration:
                                inputDecorationWidget(text: t(context, 'accept_page.choose_technical')),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return t(context, 'accept_page.select_technical');
                              }
                              return null;
                            },
                            onChanged: (String? data) {
                              setState(() {
                                _technicalId = data;
                              });
                            },
                            items: model.technicals
                                .map<DropdownMenuItem<String>>((user) {
                              return DropdownMenuItem<String>(
                                value: user.id,
                                child:
                                    Text('${user.firstName} ${user.lastName}'),
                              );
                            }).toList(),
                          )
                        ],
                        const SizedBox(height: 20),
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: SizedBox(
                            width: 150,
                            height: 55,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(0)),
                              onPressed: _loading ? null : _accept,
                              child: _loading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(t(context, 'send')),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
