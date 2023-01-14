import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:active_storage/active_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:snde/constants.dart';
import 'package:snde/functions.dart';
import 'package:snde/models/city.dart';
import 'package:snde/models/region.dart';
import 'package:snde/models/state.dart';
import 'package:snde/services/api_service.dart';
import 'package:snde/services/auth_service.dart';
import 'package:snde/services/storage_service.dart';
import 'package:snde/services/store_service.dart';
import 'package:snde/widgets/input_decoration_widget.dart';
// import 'package:location/location.dart';

class NewReportPage extends StatefulWidget {
  const NewReportPage({Key? key}) : super(key: key);

  @override
  NewReportPageState createState() => NewReportPageState();
}

class NewReportPageState extends State<NewReportPage> {
  final _formKey = GlobalKey<FormState>();
  String? _reportType;
  String? _stateId;
  String? _cityId;
  String? _regionId;
  String _description = '';
  String latlng = '';
  File? image;
  bool _loading = false;
  late Position _currentPosition;
  @override
  void initState() {
    super.initState();
    final report = storageService.newReport;
    _reportType = storageService.newReportItem(report, 'report_type');
    _stateId = storageService.newReportItem(report, 'state_id');
    _cityId = storageService.newReportItem(report, 'city_id');
    _regionId = storageService.newReportItem(report, 'region_id');
    latlng = storageService.newReportItem(report, 'latlng') ?? '';
    String imagePath = storageService.newReportItem(report, 'image') ?? '';
    if (imagePath.isNotEmpty) {
      image = File(imagePath);
    }

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) => _getCurrentLocation());
  }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (image == null) {
      showToast(t(context, 'new_report.take_photo'));
      return;
    }

    //if (latlng.isEmpty) {
      showToast(t(context, 'new_report.allow_location'));
      latlng = await _getCurrentLocation();
      onChange('latlng', latlng);
    //}

    setState(() {
      _loading = true;
    });

    try {
      final result =
          await apiService.upload(File(image!.path), url: 'reports', body: {
        'report_type': _reportType!,
        'state_id': _stateId!,
        'city_id': _cityId!,
        'region_id': _regionId!,
        'description': _description,
        'latlng': latlng
      });
      
      if (result['result']['status'] == 'ok') {
        showToast(t(context, 'new_report.report_sent'), color: Colors.green);
        final r = result['result']['result'];
        final model = AuthService.of(context);
        final state = model.states
            .where((element) => element.id == _stateId.toString())
            .first;
        final city =
            model.cities.where((element) => element.id == _cityId).first;
        final region =
            model.regions.where((element) => element.id == _regionId).first;
        r['state_name'] =
            ApiService.language == 'ar' ? state.name : state.nameFr;
        r['city_name'] = ApiService.language == 'ar' ? city.name : city.nameFr;
        r['region_name'] =
            ApiService.language == 'ar' ? region.name : region.nameFr;
        storageService.setNewReport(r);
        storageService.clearNewReport();
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } catch (error) {
      //showToast(t(context, '$error/${error ?? ''}'));
      print('error:${error}');
      if (!ApiService.connection) {
        showToast(t(context, '$error/${error ?? ''}'));
        storageService.setCacheReport(AuthService.of(context));
        showToast(t(context, 'report_saved_for_later'), color: Colors.green);
        Navigator.popUntil(context, (route) => route.isFirst);
      } else {
        showToast(t(context, 'unknown_error'));
      }
    }

    setState(() {
      _loading = false;
    });
  }

  void onChange(String key, String value) {
    storageService.setNewReportValue(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
            title: Text(t(context, 'report_problem')), centerTitle: true),
        body: Consumer<AuthService>(builder: (_, model, child) {
          final cities =
              model.cities.where((item) => item.stateId == _stateId).toList();
          final regions = model.regions
              .where(
                  (item) => item.cityId == _cityId && item.stateId == _stateId)
              .toList();
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
                          value: _reportType,
                          isExpanded: true,
                          decoration: inputDecorationWidget(
                              text: t(context, 'new_report.select_r')),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return t(
                                  context, 'new_report.select_report_type');
                            }
                            return null;
                          },
                          onChanged: (String? data) {
                            setState(() {
                              _reportType = data;
                            });
                            onChange('report_type', '$data');
                          },
                          items: model.reportTypes.entries
                              .map<DropdownMenuItem<String>>(
                                  (MapEntry<String, String> entry) {
                            return DropdownMenuItem<String>(
                              value: entry.key,
                              child: Text(entry.value,
                                  style: const TextStyle(), softWrap: true),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: _stateId,
                          isExpanded: true,
                          decoration: inputDecorationWidget(
                              text: t(context, 'new_report.select_state')),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return t(
                                  context, 'new_report.error_select_state');
                            }
                            return null;
                          },
                          onChanged: (String? data) {
                            setState(() {
                              _stateId = data;
                              _cityId = null;
                              _regionId = null;
                            });
                            onChange('state_id', '$data');
                          },
                          items: model.states.map<DropdownMenuItem<String>>(
                              (StateModel state) {
                            return DropdownMenuItem<String>(
                              value: state.id,
                              child: Text(ApiService.language == 'ar'
                                  ? state.name
                                  : state.nameFr),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: _cityId,
                          isExpanded: true,
                          decoration: inputDecorationWidget(
                              text: t(context, 'new_report.select_city')),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return t(context, 'new_report.error_select_city');
                            }
                            return null;
                          },
                          onChanged: (String? data) {
                            setState(() {
                              _cityId = data;
                              _regionId = null;
                            });
                            onChange('city_id', '$data');
                          },
                          items:
                              cities.map<DropdownMenuItem<String>>((City city) {
                            return DropdownMenuItem<String>(
                              value: city.id,
                              child: Text(ApiService.language == 'ar'
                                  ? city.name
                                  : city.nameFr),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: _regionId,
                          isExpanded: true,
                          decoration: inputDecorationWidget(
                              text: t(context, 'new_report.select_region')),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return t(
                                  context, 'new_report.error_select_region');
                            }
                            return null;
                          },
                          onChanged: (String? data) {
                            setState(() {
                              _regionId = data;
                            });
                            onChange('region_id', '$data');
                          },
                          items: regions
                              .map<DropdownMenuItem<String>>((Region region) {
                            return DropdownMenuItem<String>(
                              value: region.id,
                              child: Text(ApiService.language == 'ar'
                                  ? region.name
                                  : region.nameFr),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          decoration: inputDecorationWidget(
                              text: t(context, 'description')),
                          onChanged: (value) => setState(() {
                            _description = value;
                          }),
                          keyboardType: TextInputType.text,
                          minLines: 3,
                          maxLines: 8,
                        ),
                        const SizedBox(height: 10),
                        if (image != null) ...[
                          Image.file(File(image!.path),
                              width: 100, height: 100),
                          const SizedBox(height: 10),
                        ],
                        SizedBox(
                          // alignment: Alignment.center,
                          // padding: const EdgeInsets.symmetric(vertical: 16.0),
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton.icon(
                            icon: FaIcon(FontAwesomeIcons.camera),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.grey),
                                elevation: MaterialStateProperty.all(0)),
                            onPressed: _loading
                                ? null
                                : () => _choosePicture(ImageSource.camera),
                            label: Text(t(context, 'new_report.select_image')),
                          ),
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
                              onPressed: _loading ? null : _send,
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

  void _choosePicture(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    try {
      final xfile = await _picker.pickImage(source: source);
      image = await compressAndGetFile(new File(xfile!.path));
      onChange('image', '${image?.path}');
    } catch (err) {
      print('error: ${err}');
    }
    setState(() {});
  }
  Future<String> _getCurrentLocation() async {
    try {
        Position position = await _determinePosition();
        setState(() {
          _currentPosition = position;
        });
        
        latlng = "${_currentPosition.latitude},${_currentPosition.longitude}";
        onChange('latlng', latlng);
        return latlng;
    } catch (e) {
      showToast(t(context, 'unknown_error'));
      return 'unknown_error';
      
    }


    
  }
  Future<Position> _determinePosition() async {
        LocationPermission permission;
    permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            // Permissions are denied, next time you could try
            // requesting permissions again (this is also where
            // Android's shouldShowRequestPermissionRationale
            // returned true. According to Android guidelines
            // your App should show an explanatory UI now.
            return Future.error('Location permissions are denied');
          }
        }
    if (permission == LocationPermission.deniedForever) {
          // Permissions are denied forever, handle appropriately.
          return Future.error(
              'Location permissions are permanently denied, we cannot request permissions.');
        }
    // When we reach here, permissions are granted and we can
        // continue accessing the position of the device.
        return await Geolocator.getCurrentPosition();
      }

  Future<String> get_user_location() async {
    //showToast(t(context, 'new_report.allow_location'));
    Geolocator
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.best, forceAndroidLocationManager: true)
      .then((Position position) {
        setState(() {
          _currentPosition = position;
        });

          latlng = "${_currentPosition.latitude},${_currentPosition.longitude}";
      onChange('latlng', latlng);

      }).catchError((e) {
        print(e);

      });
    return latlng;
  }

  void _upload() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("اختر مصدر الصورة"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextButton(
                  child: Text("معرض الصور"),
                  onPressed: () {
                    Navigator.pop(context);
                    _choosePicture(ImageSource.gallery);
                  },
                ),
                TextButton(
                  child: Text("التقاط صورة"),
                  onPressed: () {
                    Navigator.pop(context);
                    _choosePicture(ImageSource.camera);
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
