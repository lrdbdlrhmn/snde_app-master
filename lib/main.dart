import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:snde/constants.dart';
import 'package:snde/pages/accept_page.dart';
import 'package:snde/pages/account_page.dart';
import 'package:snde/pages/change_language_page.dart';
import 'package:snde/pages/change_password_page.dart';
import 'package:snde/pages/check_balance_page.dart';
import 'package:snde/pages/forgot_password_page.dart';
import 'package:snde/pages/home_page.dart';
import 'package:snde/pages/login_page.dart';
import 'package:snde/pages/new_report_page.dart';
import 'package:snde/pages/person_info_page.dart';
import 'package:snde/pages/register_page.dart';
import 'package:snde/pages/reports_page.dart';
import 'package:snde/pages/terms_page.dart';
import 'package:snde/pages/view_pdf.dart';
import 'package:snde/pages/view_report_page.dart';
import 'package:snde/services/api_service.dart';
import 'package:snde/services/auth_service.dart';
import 'package:snde/services/storage_service.dart';
import 'package:snde/services/store_service.dart';
import 'package:snde/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final AuthService authService = AuthService();
  final StoreService storeService = StoreService();
  try {
    await storageService.init();
    await authService.firstInit();
    authService.init();
    storeService.initLanguage();
  } catch (err) {}
  OneSignal.shared.setAppId(OSNotificationId);
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  OneSignal.shared.promptLocationPermission();
  OneSignal.shared
      .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
    AuthService.notificationId = changes.to.userId;
  });
  OneSignal.shared.getDeviceState().then((value) {
    AuthService.notificationId = value!.userId;
  });

  OneSignal.shared.setNotificationWillShowInForegroundHandler((event) {
    // event.notification.additionalData['new_report'];
    if(authService.user?.userType == 'manager'){
      authService.init(refresh: true);
    }
  });

  OneSignal.shared
      .setSubscriptionObserver((OSSubscriptionStateChanges changes) async {
    AuthService.notificationId = changes.to.userId;
  });
  

  Timer.periodic(const Duration(seconds: 20), (timer) {
    if (authService.isAuthenticated && ApiService.connection) {
      authService.init(autoReload: true);
    }
  });

  //InternetConnectionChecker().checkInterval = const Duration(seconds: 3);
  var listener = InternetConnectionChecker().onStatusChange.listen((status) {
    switch (status) {
      case InternetConnectionStatus.connected:
        if(!ApiService.connection){
          authService.init(refresh: true);
        }
        ApiService.connection = true;
        if(authService.isAuthenticated){
          storageService.sendReports();
        }
        break;
      case InternetConnectionStatus.disconnected:
        ApiService.connection = false;
        break;
    }
  });

  runApp(SndeApp(authService: authService, storeService: storeService));
}

class SndeApp extends StatelessWidget {
  final AuthService authService;
  final StoreService storeService;
  const SndeApp(
      {Key? key, required this.authService, required this.storeService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(create: (_) => authService),
        ChangeNotifierProvider<StoreService>(create: (_) => storeService),
      ],
      builder: (context, child) {
        return Consumer<StoreService>(builder: (context, model, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'SNDE',
            localizationsDelegates: [
              FlutterI18nDelegate(
                translationLoader: FileTranslationLoader(
                  fallbackFile: model.language,
                  forcedLocale: Locale(model.language),
                  useCountryCode: false,
                  useScriptCode: false,
                ),
              ),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate
            ],
            supportedLocales: const [Locale('ar'), Locale('en'), Locale('fr')],
            locale: Locale(model.language),
            theme: theme,
            initialRoute: '/',
            routes: {
              '/': (context) => HomePage(authService: authService),
              '/login': (context) => const LoginPage(),
              '/register': (context) => const RegisterPage(),
              '/new_report': (context) => const NewReportPage(),
              '/my_reports': (context) => const ReportsPage(),
              '/balance': (context) => const CheckBalancePage(),
              '/accept': (context) => const AcceptPage(),
              '/show': (context) => const ViewReportPage(),
              '/terms': (context) => TermsPage(),
              '/change_language': (context) => const ChangeLanguagePage(),
              '/my_account': (context) => const AccountPage(),
              '/person_info': (context) => const PersonInfoPage(),
              '/view_pdf': (context) => ViewPdf(),
              //'/view_invoice': (context) => PdfInvoice(),
              '/change_password': (context) => const ChangePasswordPage(),
              '/forgot_password': (context) => const ForgotPasswordPage(),
            },
          );
        });
      },
    );
  }
}
