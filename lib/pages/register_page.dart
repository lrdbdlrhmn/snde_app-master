import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:snde/functions.dart';
import 'package:snde/services/api_service.dart';
import 'package:snde/services/auth_service.dart';
import 'package:snde/widgets/input_decoration_widget.dart';
//import 'package:snde/widgets/input_prefix_icon_widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String _firstName = '';
  String _lastName = '';
  String _phone = '';
  String _email = '';
  String _whatsapp = '';
  String _nni = '';
  String _password = '';
  String _passwordConfirm = '';
  bool _loading = false;
  bool _agree = false;
  Map<String, String> messages = {};

  Future<void> _register() async {
    messages = {};
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_password != _passwordConfirm) {
      messages['confirm_password'] = t(context, 'register_page.passwords_not_equal');
      _formKey.currentState!.validate();
      return;
    }

    int nni = int.parse(_nni);
    if (nni.toString().length != 10 || nni % 97 != 1) {
      messages['nni'] = t(context, 'register_page.invalid_nni');
      _formKey.currentState!.validate();
      return;
    }

    int phone = int.parse(_phone);
    if (phone.toString().length != 8 || !isPhone(phone)) {
      messages['phone'] = t(context, 'register_page.invalid_phone');
      _formKey.currentState!.validate();
      return;
    }

    if (!_agree) {
      showToast(t(context, 'register_page.check_terms'));
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final res = await apiService.post('register', body: {
        //'user': {
          'first_name': _firstName,
          'last_name': _lastName,
          'phone': _phone,
          'email': _email,
          'whatsapp': _whatsapp,
          'nni': _nni,
          'password': _password,
          'notification_id': AuthService.notificationId ?? ''
        //}
      });
      var result = res['result'];
      var status = result['result']['status'];
      //showToast(t(context, '$status/${status ?? ''}'));
      if (result['result']['status'] == 'ok') {
        AuthService.loginViaHeaderToken(context,
            result['result']['headers']['authorization'], result['result']['result']);
      } else {
        //messages.addEntries((result['result']['message']
              //  as Map<dynamic, dynamic>)
          //  .entries
            //.map((entry) =>
            //    MapEntry('${entry.key}', '${(entry.value as List).first}')));
        //_formKey.currentState!.validate();
        //showToast(t(context, '$_firstName/${_firstName ?? ''}'));
      }
    } catch (error) {
      
      ///showToast(t(context, '$error/${error ?? ''}'));
      if(ApiService.connection){
        showToast(t(context, 'unknown_error'));
      }else{
        showToast(t(context, 'check_internet_connection'));
      }
    }
    if (!mounted) return;

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Text(t(context, 'register')), centerTitle: true),
        body: Container(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 150,
                  ),
                  SizedBox(height: 40),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          decoration: inputDecorationWidget(
                              text: t(context, 'name'), icon: FontAwesomeIcons.userCircle),
                          onChanged: (value) => setState(() {
                            _firstName = value;
                          }),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return t(context, 'register_page.enter_first_name');
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          decoration: inputDecorationWidget(
                              text: t(context, 'last_name'),
                              icon: FontAwesomeIcons.userCircle),
                          onChanged: (value) => setState(() {
                            _lastName = value;
                          }),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return t(context, 'register_page.enter_last_name');
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          decoration: inputDecorationWidget(
                              text: t(context, 'phone'), icon: FontAwesomeIcons.phone),
                          keyboardType: TextInputType.phone,
                          onChanged: (value) => setState(() {
                            _phone = value;
                          }),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return t(context, 'register_page.enter_phone');
                            }
                            if (messages.containsKey('phone')) {
                              return messages['phone'];
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          decoration: inputDecorationWidget(
                              text: t(context, 'nni'),
                              icon: FontAwesomeIcons.user),
                          keyboardType: TextInputType.phone,
                          onChanged: (value) => setState(() {
                            _nni = value;
                          }),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return t(context, 'register_page.enter_nni');
                            }
                            if (messages.containsKey('nni')) {
                              return messages['nni'];
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          decoration: inputDecorationWidget(
                              text: t(context, 'email'),
                              icon: FontAwesomeIcons.at),
                          onChanged: (value) => setState(() {
                            _email = value;
                          }),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (messages.containsKey('email')) {
                              return messages['email'];
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          decoration: inputDecorationWidget(
                              text: t(context, 'whatsapp'),
                              icon: FontAwesomeIcons.whatsapp),
                          keyboardType: TextInputType.phone,
                          onChanged: (value) => setState(() {
                            _whatsapp = value;
                          }),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          decoration: inputDecorationWidget(
                              text: t(context, 'password'), icon: FontAwesomeIcons.lock),
                          onChanged: (value) => setState(() {
                            _password = value;
                          }),
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return t(context, 'register_page.enter_password');
                            }
                            if (messages.containsKey('password')) {
                              return messages['password'];
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          decoration: inputDecorationWidget(
                              text: t(context, 'confirm_password'),
                              icon: FontAwesomeIcons.lock),
                          onChanged: (value) => setState(() {
                            _passwordConfirm = value;
                          }),
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return t(context, 'register_page.enter_confirm_password');
                            }

                            if (messages.containsKey('confirm_password')) {
                              return messages['confirm_password'];
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: Checkbox(
                                value: _agree,
                                onChanged: (value) {
                                  setState(() {
                                    _agree = value ?? false;
                                  });
                                },
                              ),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/terms'),
                              child: Text(
                                t(context, 'register_page.readed_terms'),
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
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
                              onPressed: _loading ? null : _register,
                              child: _loading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(t(context, 'register')),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
