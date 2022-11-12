import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snde/constants.dart';
import 'package:snde/functions.dart';
import 'package:snde/models/User.dart';
import 'package:snde/models/city.dart';
import 'package:snde/models/region.dart';
import 'package:snde/models/report.dart';
import 'package:snde/models/state.dart';
import 'package:snde/services/api_service.dart';
import 'package:snde/services/storage_service.dart';

class AuthService extends ChangeNotifier {
  static String? notificationId;
  bool hasError = false;
  bool hasData = false;
  bool isAuthenticated = false;
  bool versionExpired = false;

  User? user;
  List<City> cities = [];
  List<StateModel> states = [];
  List<Region> regions = [];
  List<Report> notifications = [];
  List<User> technicals = [];
  SharedPreferences? prefs;
  Map<String, String> reportTypes = {};
  bool isNotFirst = true;
  String filtering = '';

  Future<void> firstInit() async {
    states = storageService.states;
    cities = storageService.cities;
    regions = storageService.regions;
    reportTypes = storageService.reportTypes;
    prefs ??= await SharedPreferences.getInstance();
    isNotFirst = prefs?.getBool('snde_not_first_time') ?? false;
    prefs?.setBool('snde_not_first_time', true);
  }

  void init({bool refresh = false, autoReload = false, String? filteringValue}) async {
    if (refresh) {
      hasData = false;
      hasError = false;
      notifyListeners();
    }

    if(filteringValue != null){
      filtering = filteringValue;
    }else if(refresh || autoReload){
      filtering = 'reload=true';
    }

    try {
      prefs ??= await SharedPreferences.getInstance();
      final loginUser = prefs?.getString(LOGIN_KEY);

      final userJson = json.decode('$loginUser');
      if (isNN(loginUser) && isNN(userJson)) {
        login(userJson);
      } else {
        logout();
      }

      Map<dynamic, dynamic> result = await apiService.get('?$filtering');

      if (result['code'] == 401){
        logout();
        resetData();
        throw 'SERVER ERROR'; 
      }
      if (result['code'] != 200) throw 'SERVER ERROR';

      result = result['result']['result'];
      resetData();

      if (isNN(result['user'])) {
        login({
          ...result['user'],
          'access_token': userJson != null
              ? userJson['access_token']
              : ApiService.headers['Authorization']
        });
        if (isNN(result['notifications'])) {
          result['notifications']
              .forEach((v) => notifications.add(Report.fromJson(v)));
        }

        if (isNN(result['technicals'])) {
          result['technicals'].forEach((v) => technicals.add(User.fromJson(v)));
        }
      }else{
        logout();
      }
      if (isNN(result['cities'])) {
         cities = [];
        result['cities'].forEach((v) => cities.add(City.fromJson(v)));
        storageService.setCities(result['cities']);
      }

      if (isNN(result['states'])) {
        states = [];
        result['states'].forEach((v) => states.add(StateModel.fromJson(v)));
        storageService.setStates(result['states']);
      }

      if (isNN(result['regions'])) {
        regions = [];
        result['regions'].forEach((v) => regions.add(Region.fromJson(v)));
        storageService.setRegions(result['regions']);
      }

      if (isNN(result['report_types'])) {
        reportTypes = (result['report_types'] as Map<dynamic, dynamic>)
            .map((key, value) => MapEntry('$key', '$value'));
        storageService.setReportTypes(reportTypes);
      }

      hasData = true;
      hasError = false;
    } catch (err) {
      //showToast(t(context, '$err/${err?? ''}'));
      print('error: $err');
      if (!autoReload) {
        hasData = false;
        hasError = true;
      }
    }

    notifyListeners();
  }

  static AuthService of(BuildContext context) =>
      Provider.of<AuthService>(context, listen: false);

  void resetData() {
    notifications = [];
    technicals = [];
    reportTypes = {};
  }

  void login(userLogin) {
    user = User.fromJson(userLogin);

    ApiService.setAccessToken(user?.accessToken);

    prefs?.setString(LOGIN_KEY, json.encode(user?.toJson));
    isAuthenticated = true;

    notifyListeners();
  }

  static void loginViaHeaderToken(
      BuildContext context, String headerToken, user) {
    final String accessToken = headerToken.toString();
    if (accessToken == '' || accessToken.isEmpty) {
      new Exception('لم يتم تسجيل الدخول بالطريقة الصحيح');
    }
    AuthService.of(context).login({...user, 'access_token': accessToken});
    AuthService.of(context).init(refresh: true);
    showToast('تم تسجيل الدخول', color: Colors.green);
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  void logout() {
    prefs?.remove(LOGIN_KEY);

    isAuthenticated = false;
    ApiService.setAccessToken('');

    user = null;

    notifyListeners();
  }

    void delete() {
    Map<dynamic, dynamic> res;
    Future<Map<dynamic, dynamic>> result = apiService.delete('delete_account');
    result.then((value) => {
      res = value
    } );
    
    prefs?.remove(LOGIN_KEY);

    isAuthenticated = false;
    ApiService.setAccessToken('');

    user = null;

    notifyListeners();
  }

  void removeNotification(Report? notification) {
    notifications.remove(notification);
    notifyListeners();
  }
}
