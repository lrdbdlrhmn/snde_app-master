import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:snde/functions.dart';
import 'package:snde/services/api_service.dart';
import 'package:snde/services/auth_service.dart';
import 'package:snde/widgets/input_decoration_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String _phone = '';
  String _password = '';
  bool _loading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _loading = true;
    });

    try {

      
      final result = await apiService.post('login', body: {

          'phone': _phone,
          'password': _password,
          'notification_id': AuthService.notificationId ?? ''

      });


      var success = result['result']['result']['status'];

      if (success == 'ok') {
        var authorization = result['result']['result']['headers']['authorization'];
        var user = result['result']['result']['result'];

        AuthService.loginViaHeaderToken(context,
           authorization ,user );
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } catch (error) {
      //
      if(ApiService.connection){
         showToast(t(context, 'unknown_error'));

      }else{
        showToast(t(context, 'check_internet_connection'));
      }

    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Text(t(context, 'login')), centerTitle: true),
        body: Center(
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
                      TextFormField(
                        decoration: inputDecorationWidget(
                            text: t(context, 'phone'), icon: FontAwesomeIcons.phone),
                        onChanged: (value) => setState(() {
                          _phone = value;
                        }),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return t(context, 'enter_phone');
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
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
                            return t(context, 'enter_password');
                          }
                          return null;
                        },
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
                            onPressed: _loading ? null : _login,
                            child: _loading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(t(context, 'login')),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                elevation: MaterialStateProperty.all(0), backgroundColor: MaterialStateProperty.all(Colors.transparent), foregroundColor: MaterialStateProperty.all(Colors.black)),
                            onPressed: () => Navigator.pushNamed(context, '/forgot_password'),
                            child: Text(t(context, 'forgot_password')),
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
    );
  }
}
