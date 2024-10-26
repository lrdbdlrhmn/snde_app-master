import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:snde/functions.dart';
import 'package:snde/models/report.dart';
import 'package:snde/models/user.dart';
import 'package:snde/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class PersonInfoPage extends StatefulWidget {
  const PersonInfoPage({Key? key}) : super(key: key);

  @override
  _PersonInfoPageState createState() => _PersonInfoPageState();
}

class _PersonInfoPageState extends State<PersonInfoPage> {
  User? user;
  Report? report;
  bool loading = false;
  bool inited = false;
  var total = 0;
  var trust = 0;

  init() async {
    setState(() {
      loading = true;
    });

    try {
      
      final result = await apiService.get('users/${report!.userId}');

      user = User.fromJson(result['result']['user']);
      total = result['result']['total'];
      trust = result['result']['trust'];
      
    } catch (error) {

      if (ApiService.connection) {
        showToast(t(context, 'unknown_error'));
      } else {
        showToast(t(context, 'check_internet_connection'));
      }
    }
    if (!mounted) return;

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!inited) {
      inited = true;
      report = ModalRoute.of(context)!.settings.arguments as Report;
      init();
    }
    return Scaffold(
      appBar: AppBar(title: Text(report!.firstName), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              width: 100,
              height: 100,
              child: const Icon(FontAwesomeIcons.user, size: 50),
            ),
            const SizedBox(height: 20),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              // padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(report!.firstName),
                  ),
                  SizedBox(height: 10),
                  const Divider(height: 1),
                  TextButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20)),
                    ),
                    onPressed: () => launch('tel: ${report!.phone}'),
                    child: Row(
                      children: [
                        Expanded(child: const FaIcon(FontAwesomeIcons.phone)),
                        Text(report!.phone),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  TextButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20)),
                    ),
                    onPressed: () => launch('tel: ${user!.whatsapp}'),
                    child: Row(
                      children: [
                        Expanded(child: const FaIcon(FontAwesomeIcons.whatsapp)),
                        Text('${user?.whatsapp}'),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(child: Text(t(context, 'total_issues'))),
                        Text('$total'),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(child: Text(t(context, 'trust_percentage'))),
                        Text('$trust%'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
