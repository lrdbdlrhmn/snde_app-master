import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:snde/functions.dart';
import 'package:snde/services/api_service.dart';
import 'package:snde/services/auth_service.dart';
import 'package:snde/widgets/input_decoration_widget.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  ChangePasswordPageState createState() => ChangePasswordPageState();
}

class ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();

  String _password = '';
  String _current_password = '';
  bool _loading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _loading = true;
    });

    try {
      final result = await apiService.put('users/update?password=$_password&current_password=$_current_password', body: {
          'password': _password,
          'current_password': _current_password,
      });
      if (result['result']['status'] == 'ok') {
        showToast(t(context, 'password_changed'), color: Colors.green);
        return Navigator.pop(context);
      }
      throw result['result']['error'];
    } catch (error) {
      showToast(t(context, '$error'));
      if(error == 'invalid_password'){
        showToast(t(context, 'invalid_password'));
      }else if(ApiService.connection){
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
        appBar: AppBar(title: Text(t(context, 'change_password')), centerTitle: true),
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
                            text: t(context, 'current_password'), icon: FontAwesomeIcons.lock),
                        onChanged: (value) => setState(() {
                          _current_password = value;
                        }),
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return t(context, 'enter_current_password');
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
        ),
      ),
    );
  }
}
