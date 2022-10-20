import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:snde/functions.dart';
import 'package:snde/models/city.dart';
import 'package:snde/models/region.dart';
import 'package:snde/models/state.dart';
import 'package:snde/services/api_service.dart';
import 'package:snde/services/auth_service.dart';
import 'package:snde/widgets/input_decoration_widget.dart';

class FilteringWidget extends StatefulWidget {
  final Function(String)? onChange;
  FilteringWidget({Key? key, this.onChange}) : super(key: key);

  @override
  _FilteringWidgetState createState() => _FilteringWidgetState();
}

class _FilteringWidgetState extends State<FilteringWidget> {
  AuthService? modal;
  String? _regionId;
  String? _stateId;
  String? _cityId;
  String _sortBy = 'desc';
  String _startDate = '';
  String _endDate = '';

  void onChange() {
    String filtering =
        'start_date=$_startDate&end_date=$_endDate&region_id=${_regionId ?? ''}&order_by=$_sortBy&reload=true';
    if(widget.onChange == null){
      modal?.init(filteringValue: filtering, refresh: true);
    }else{
      widget.onChange!(filtering);
    }
  }

  @override
  Widget build(BuildContext context) {
    modal ??= AuthService.of(context);
    final cities =
              modal!.cities.where((item) => item.stateId == _stateId).toList();
    final regions = modal!.regions
              .where(
                  (item) => item.cityId == _cityId && item.stateId == _stateId)
              .toList();
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          Row(
            children: [
               Expanded( child:
                        DropdownButtonFormField<String>(
                          value: _stateId,
                          isExpanded: true,
                          decoration: inputDecorationWidget(
                              text: t(context, 'new_report.select_state'), padding: 5),
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
                             onChange();
                          },
                          items: modal!.states.map<DropdownMenuItem<String>>(
                              (StateModel state) {
                            return DropdownMenuItem<String>(
                              value: state.id,
                              child: Text(ApiService.language == 'ar'
                                  ? state.name
                                  : state.nameFr),
                            );
                          }).toList(),
                        ),
              ),
              
               SizedBox(width: 10),
                    Expanded(
                      child: 
                        DropdownButtonFormField<String>(
                          value: _cityId,
                          isExpanded: true,
                          decoration: inputDecorationWidget(
                              text: t(context, 'new_report.select_city'), padding: 5),
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
                            onChange();
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
              ),
             
          ],
          ),
                         SizedBox(height: 10),

          Row(
            children: [
 
              Expanded(child: 
                        DropdownButtonFormField<String>(
                          value: _regionId,
                          isExpanded: true,
                          decoration: inputDecorationWidget(
                              text: t(context, 'new_report.select_region'), padding: 5),
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
                            onChange();
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
                    ),
              // const SizedBox(height: 10),
               SizedBox(width: 10),
              Expanded(
                // width: MediaQuery.of(context).size.width * 0.49,
                child: DropdownButtonFormField<String>(
                  // value: _regionId,
                  isExpanded: true,
                  decoration: inputDecorationWidget(
                      text: t(context, 'sort_by'), padding: 5),
                  onChanged: (String? data) {
                    _sortBy = data!;
                    onChange();
                  },
                  items: [
                    DropdownMenuItem<String>(
                      value: 'desc',
                      child: Text(t(context, 'order_desc')),
                    ),
                    DropdownMenuItem<String>(
                      value: 'asc',
                      child: Text(t(context, 'order_asc')),
                    ),
                    if (modal?.user?.userType != 'user')
                      DropdownMenuItem<String>(
                        value: 'score',
                        child: Text(t(context, 'trust_percentage')),
                      ),
                  ],
                ),
              ),
           
            ],
          ),
                         SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                  child: OutlinedButton(
                      onPressed: () => _pickDate('start'),
                      child: Text(_startDate.isNotEmpty
                          ? _startDate.split(' ').first
                          : t(context, 'from')))),
              const SizedBox(width: 10),
              Expanded(
                  child: OutlinedButton(
                      onPressed: () => _pickDate('end'),
                      child: Text(_endDate.isNotEmpty
                          ? _endDate.split(' ').first
                          : t(context, 'to')))),
            ],
          ),
        ],
      ),
    );
  }

  _pickDate(String period) async {
    DateTime selectedDate = DateTime.now();
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(selectedDate.year + 2),
    );
    String datetime = '';
    if (selected != null) {
      datetime = "${selected.year}-${selected.month}-${selected.day} ${period == 'start' ? '00:00:00' : '23:59:59'}";
    }

    if (period == 'start') {
      _startDate = datetime;
    } else {
      _endDate = datetime;
    }
    onChange();
  }
}
