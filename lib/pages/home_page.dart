import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:launch_review/launch_review.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:snde/constants.dart';
import 'package:snde/functions.dart';
import 'package:snde/models/User.dart';
import 'package:snde/models/region.dart';
import 'package:snde/models/report.dart';
import 'package:snde/services/api_service.dart';
import 'package:snde/services/auth_service.dart';
import 'package:snde/services/notification_service.dart';
import 'package:snde/theme.dart';
import 'package:snde/widgets/filtering_widget.dart';
import 'package:snde/widgets/input_decoration_widget.dart';
import 'package:snde/widgets/report_widget.dart';

class HomePage extends StatefulWidget {
  final AuthService authService;

  const HomePage({Key? key, required this.authService}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String notificationTitle = 'No Title';
  String notificationBody = 'No Body';
  String notificationData = 'No Data';

  @override
  void initState() {
    final firebaseMessaging = FCM();
    firebaseMessaging.setNotifications();

    firebaseMessaging.streamCtlr.stream.listen(_changeData);
    firebaseMessaging.bodyCtlr.stream.listen(_changeBody);
    firebaseMessaging.titleCtlr.stream.listen(_changeTitle);

    super.initState();
  }

  _changeData(String msg) => setState(() => notificationData = msg);

  _changeBody(String msg) => setState(() => notificationBody = msg);

  _changeTitle(String msg) => setState(() => notificationTitle = msg);

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Consumer<AuthService>(builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Sighaya'),
            centerTitle: true,
          ),
          drawer: _buildDrawer(model),
          body: Column(
            children: [
              if (!model.hasData && !model.hasError && model.isNotFirst)
                const LinearProgressIndicator(),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          width: 200,
                        ),
                        const SizedBox(height: 40),
                        if (model.isAuthenticated)
                          if (model.user!.userType != 'user') ...[
                            FilteringWidget(),
                            const SizedBox(height: 20),
                            ..._buildNotifications(model: model),
                          ] else
                            ..._homeWidget(model: model)
                        else
                          ..._loginWidget(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  List<Widget> _homeWidget({AuthService? model}) {
    return [
      SizedBox(
        height: 55,
        width: 220,
        child: ElevatedButton.icon(
          icon: FaIcon(FontAwesomeIcons.creditCard),
          onPressed: () => Navigator.of(context).pushNamed('/balance'),
          label: Text(t(context, 'check_balance')),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(accentColor),
              elevation: MaterialStateProperty.all(0)),
        ),
      ),
      const SizedBox(height: 20),
      SizedBox(
        height: 55,
        width: 220,
        child: ElevatedButton.icon(
          icon: const FaIcon(FontAwesomeIcons.exclamationTriangle),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(accentColor),
              elevation: MaterialStateProperty.all(0)),
          onPressed: () => Navigator.of(context).pushNamed('/new_report'),
          label: Text(t(context, 'report_problem')),
        ),
      ),
      const SizedBox(height: 20),
      SizedBox(
        height: 55,
        width: 220,
        child: ElevatedButton.icon(
          icon: const FaIcon(FontAwesomeIcons.listOl),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(accentColor),
              elevation: MaterialStateProperty.all(0)),
          onPressed: () => Navigator.of(context).pushNamed('/my_reports'),
          label: Text(t(context, 'prev_problems')),
        ),
      ),
    ];
  }

  List<Widget> _loadingWiget() {
    return [
      const CircularProgressIndicator(),
    ];
  }

  List<Widget> _errorWidget({AuthService? authService}) {
    return [
      Text(
        t(context, 'unknown_error'),
        style: const TextStyle(
          fontSize: 18,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 20),
      ElevatedButton.icon(
        icon: const FaIcon(FontAwesomeIcons.sync),
        style: ButtonStyle(elevation: MaterialStateProperty.all(0)),
        onPressed: () => authService?.init(refresh: true),
        label: Text(t(context, 'refresh')),
      ),
    ];
  }

  List<Widget> _loginWidget() {
    return [
      Text(
        t(context, 'welcome'),
        style: const TextStyle(
          fontSize: 18,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 20),
      Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 55,
              child: ElevatedButton(
                style: ButtonStyle(elevation: MaterialStateProperty.all(0)),
                onPressed: () => Navigator.of(context).pushNamed('/login'),
                child: Text(t(context, 'login')),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: SizedBox(
              height: 55,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(accentColor),
                    elevation: MaterialStateProperty.all(0)),
                onPressed: () => Navigator.of(context).pushNamed('/register'),
                child: Text(t(context, 'register')),
              ),
            ),
          ),
        ],
      ),
    ];
  }

  // manager widget
  List<Widget> _buildNotifications({AuthService? model}) {
    if (model!.notifications.isEmpty) {
      return [
        Text(t(context, 'no_notifications'),
            textAlign: TextAlign.center, style: TextStyle(fontSize: 20))
      ];
    }
    return model.notifications
        .map((report) => ReportWidget(
            report: report,
            onRemove: (r) => model.removeNotification(r),
            userType: model.user!.userType))
        .toList();
  }

  void onDrawerPressed() {
    Scaffold.of(context).openDrawer();
  }

  Widget _buildDrawer(AuthService service) {
    return SizedBox(
      width: 300,
      child: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 200,
              child: DrawerHeader(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.all(0),
                child: const Center(
                  child: Text(
                    'Sighaya',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: ListView(
                  padding: EdgeInsets.all(0),
                  children: [
                    const SizedBox(height: 10),
                    if (service.isAuthenticated) ...[
                      _buildDrawerItem(
                        icon: FontAwesomeIcons.userAlt,
                        text: t(context, 'my_account'),
                        onTap: () => Navigator.of(context)
                            .popAndPushNamed('/my_account'),
                      ),
                      const Divider(),
                      _buildDrawerItem(
                        icon: FontAwesomeIcons.listAlt,
                        text: t(context, 'prev_problems'),
                        onTap: () => Navigator.of(context)
                            .popAndPushNamed('/my_reports'),
                      ),

                      const Divider(),
                      _buildDrawerItem(
                        icon: FontAwesomeIcons.creditCard,
                        text: t(context, 'check_balance'),
                        onTap: () =>
                            Navigator.of(context).popAndPushNamed('/balance'),
                      ),

                      const Divider(),
                      _buildDrawerItem(
                        icon: FontAwesomeIcons.exclamationTriangle,
                        text: t(context, 'report_problem'),
                        onTap: () => Navigator.of(context)
                            .popAndPushNamed('/new_report'),
                      ),
                      //  icon: FaIcon(FontAwesomeIcons.creditCard),
                      // onPressed: () => Navigator.of(context).pushNamed('/balance'),
                      // label: Text(t(context, 'check_balance')),
                      //  onPressed: () => Navigator.of(context).pushNamed('/new_report'),
                      // label: Text(t(context, 'report_problem')),
                      const Divider(),
                    ],
                    _buildDrawerItem(
                      icon: FontAwesomeIcons.language,
                      text: t(context, 'change_language'),
                      onTap: () => Navigator.popAndPushNamed(
                          context, '/change_language'),
                    ),
                    const Divider(),
                    _buildDrawerItem(
                      icon: FontAwesomeIcons.book,
                      text: t(context, 'terms'),
                      onTap: () => Navigator.popAndPushNamed(context, '/terms'),
                    ),
                    const Divider(),
                    _buildDrawerItem(
                      icon: FontAwesomeIcons.star,
                      text: t(context, 'rate_app'),
                      onTap: _rateApp,
                    ),
                    const Divider(),
                    _buildDrawerItem(
                      icon: FontAwesomeIcons.share,
                      text: t(context, 'share_app'),
                      onTap: _shareApp,
                    ),
                    if (service.isAuthenticated) ...[
                      const Divider(),
                      _buildDrawerItem(
                        icon: FontAwesomeIcons.signOutAlt,
                        text: t(context, 'logout'),
                        onTap: _logout,
                      ),
                    ],
                    if (service.isAuthenticated) ...[
                      const Divider(),
                      _buildDrawerItem(
                        icon: FontAwesomeIcons.trash,
                        text: t(context, 'delete'),
                        onTap: _delete,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      {required IconData icon, required String text, void Function()? onTap}) {
    return ListTile(
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FaIcon(icon),
        ],
      ),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      onTap: onTap,
    );
  }

  void _logout() {
    Navigator.pop(context);
    showAlertDialog(context, t(context, 'confirm'),
        t(context, 'confirm_logout'), AuthService.of(context).logout);
  }

  void _delete() {
    Navigator.pop(context);
    showAlertDialog(context, t(context, 'confirm'),
        t(context, 'confirm_delete'), AuthService.of(context).delete);
  }

  _shareApp() {
    Navigator.pop(context);
    var size = MediaQuery.of(context).size;
    var appPlayUrl =
        'https://play.google.com/store/apps/details?id=$packageName';
    var appStoreUrl = 'https://apps.apple.com/mr/app/id$appId';
    Share.share(
      'تطبيق SNDE - SNDE APP: \n\nANDROID - هواتف اندرويد:\n$appPlayUrl\nIOS - هواتف آيفون:\n$appStoreUrl',
      sharePositionOrigin: Rect.fromLTWH(0, 0, size.width, size.height / 2),
    );
  }

  _rateApp() {
    Navigator.pop(context);
    LaunchReview.launch(androidAppId: packageName, iOSAppId: appId);
  }
}
