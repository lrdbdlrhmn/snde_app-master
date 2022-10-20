import 'dart:io';

import 'package:localstorage/localstorage.dart';
import 'package:snde/constants.dart';
import 'package:snde/functions.dart';
import 'package:snde/models/city.dart';
import 'package:snde/models/region.dart';
import 'package:snde/models/report.dart';
import 'package:snde/models/state.dart';
import 'package:snde/services/api_service.dart';
import 'package:snde/services/auth_service.dart';

const databaseKey = 'snde_local_database';
const newReportKey = 'new_report';
const reportsKey = 'reports';
const statesKey = 'states';
const citiesKey = 'cities';
const regionsKey = 'regions';
const reportTypesKey = 'report_types_key';
const cacheReportsKey = 'cache_reports_key';

class StorageService {
  final LocalStorage storage = LocalStorage(databaseKey);
  static bool sending = false;

  Future<void> init() async {
    await storage.ready;
  }

  setNewReportValue(String key, String value) {
    final report = newReport;
    report[key] = value;
    storage.setItem(newReportKey, report);
  }

  setReports(List reports) {
    storage.setItem(reportsKey, reports);
  }

  setCities(List cities) {
    storage.setItem(citiesKey, cities);
  }

  setStates(List states) {
    storage.setItem(statesKey, states);
  }

  setRegions(List regions) {
    storage.setItem(regionsKey, regions);
  }

  setReportTypes(Map<String, String> types) {
    storage.setItem(reportTypesKey, types);
  }

  List<StateModel> get states {
    List<StateModel> states = [];
    final statesJson = storage.getItem(statesKey);
    if (isNN(statesJson)) {
      statesJson.forEach((v) => states.add(StateModel.fromJson(v)));
    }
    return states;
  }

  List<City> get cities {
    List<City> cities = [];
    final citiesJson = storage.getItem(citiesKey);
    if (isNN(citiesJson)) {
      citiesJson.forEach((v) => cities.add(City.fromJson(v)));
    }
    return cities;
  }

  List<Region> get regions {
    List<Region> regions = [];
    final regionsJson = storage.getItem(regionsKey);
    if (isNN(regionsJson)) {
      regionsJson.forEach((v) => regions.add(Region.fromJson(v)));
    }
    return regions;
  }

  List<Map<String, String>> get cacheReports {
    List<Map<String, String>> cReports = [];
    final cReportsJson = storage.getItem(cacheReportsKey);
    if (isNN(cReportsJson)) {
      cReportsJson.forEach((item) {
        cReports.add((item as Map<dynamic, dynamic>)
            .map((key, value) => MapEntry('$key', '$value')));
      });
    }
    print(cReports);
    return cReports;
  }

  setCacheReport(AuthService model) {
    final cReports = cacheReports;
    final r = newReport;
    r['uuid'] = uuid.v4();
    final state =
        model.states.where((element) => element.id == r['state_id']).first;
    final city =
        model.cities.where((element) => element.id == r['city_id']).first;
    final region =
        model.regions.where((element) => element.id == r['region_id']).first;
    r['state_name'] = ApiService.language == 'ar' ? state.name : state.nameFr;
    r['city_name'] = ApiService.language == 'ar' ? city.name : city.nameFr;
    r['region_name'] =
        ApiService.language == 'ar' ? region.name : region.nameFr;
    cReports.add(r);
    storage.setItem(cacheReportsKey, cReports);
    clearNewReport();
  }

  clearNewReport() {
    storage.setItem(newReportKey, {});
  }

  removeCacheReport(String uuid) {
    final cReports = cacheReports;
    final re = cReports.where((element) => element['uuid'] == uuid);
    if (re.isEmpty) return;
    cReports.remove(re.first);
    storage.setItem(cacheReportsKey, cReports);
  }

  Map<String, String> get reportTypes {
    Map<String, String> types = {};
    final typesJson = storage.getItem(reportTypesKey);
    if (isNN(typesJson)) {
      types = (typesJson as Map<dynamic, dynamic>)
          .map((key, value) => MapEntry('$key', '$value'));
    }
    return types;
  }

  List<Report> get reports {
    List<Report> reports = [];
    final reportsJson = storage.getItem(reportsKey);
    if (isNN(reportsJson)) {
      reportsJson.forEach((v) => reports.add(Report.fromJson(v)));
    }
    return reports;
  }

  Map<String, String> get newReport {
    Map<String, String> newReport = {};
    final newReportJson = storage.getItem(newReportKey);
    if (isNN(newReportJson)) {
      newReport = (newReportJson as Map<dynamic, dynamic>)
          .map((key, value) => MapEntry('$key', '$value'));
    }
    return newReport;
  }

  String? newReportItem(Map<String, String> report, String key) {
    if (report.containsKey(key)) {
      return report[key];
    }
    return null;
  }

  sendReports() async {
    if (sending) {
      return;
    }
    final cReports = cacheReports;
    if (cReports.isEmpty) {
      sending = false;
      return;
    }
    sending = true;
    for (var i = 0; i < cReports.length; i++) {
      var report = cReports[i];
      String image = report['image'] ?? '';
      String stateId = report['state_id'] ?? '';
      String cityId = report['city_id'] ?? '';
      String regionId = report['region_id'] ?? '';
      String reportType = report['report_type'] ?? '';
      String latlng = report['latlng'] ?? '';
      if (image.isEmpty ||
          reportType.isEmpty ||
          stateId.isEmpty ||
          cityId.isEmpty ||
          regionId.isEmpty) {
        removeCacheReport(report['uuid']?.toString() ?? '');
        continue;
      }
      try {
        final result =
            await apiService.upload(File(image), url: 'reports', body: {
          'report_type': reportType,
          'state_id': stateId,
          'city_id': cityId,
          'region_id': regionId,
          'latlng': latlng
        });
        if (result['result']['status'] == 'ok') {
          final r = result['result']['result'];
          r['state_name'] = report['state_name'];
          r['city_name'] = report['city_name'];
          r['region_name'] = report['region_name'];
          setNewReport(r);
          removeCacheReport(report['uuid']?.toString() ?? '');
        }
      } catch (err) {}
      print(cacheReports);
      sending = false;
    }
  }

  setNewReport(Map report) {
    final sReports = storage.getItem(reportsKey);
    sReports.insert(0, report);
    setReports(sReports);
  }
}

final StorageService storageService = StorageService();
