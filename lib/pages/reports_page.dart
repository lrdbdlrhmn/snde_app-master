import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:snde/functions.dart';
import 'package:snde/models/report.dart';
import 'package:snde/services/api_service.dart';
import 'package:snde/services/auth_service.dart';
import 'package:snde/services/storage_service.dart';
import 'package:snde/widgets/filtering_widget.dart';
import 'package:snde/widgets/report_widget.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({Key? key}) : super(key: key);

  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  bool _loading = true;
  List<Report> reports = [];
  List<Report> cacheReports = [];
  String filtering = '';
  late Timer timer;
  
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if(mounted){
        setState(() {});
      }
    });
    _init();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  Future<void> _init() async {
    setState(() {
      _loading = true;
    });

    try {
      final result = await apiService.get('reports?$filtering');
      reports = [];
      storageService.setReports(result['result']['reports']);
    } catch (error) {
      if(ApiService.connection){
        showToast(t(context, 'unknown_error'));
        //showToast(t(context, '$error'));
      }else{
        showToast(t(context, 'check_internet_connection'));
      }
    }
    if (!mounted) return;
    setState(() {
      _loading = false;
    });
  }

  _onChange(String filteringValue){
    filtering = filteringValue;
    _init();
  }

  @override
  Widget build(BuildContext context) {
    final model = AuthService.of(context);
    cacheReports = storageService.cacheReports.map((e) => Report.fromJson(e)).toList();
    reports = storageService.reports;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(t(context, 'prev_problems')),
          centerTitle: true,
        ),
        body: Column(
          children: [
            if(_loading)
              const LinearProgressIndicator(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildStatus(
                                  color: Colors.black, text: t(context, 'new')),
                              const SizedBox(width: 14),
                              _buildStatus(
                                  color: Colors.orange,
                                  text: t(context, 'technical')),
                              const SizedBox(width: 14),
                              _buildStatus(
                                  color: Colors.red, text: t(context, 'fake')),
                              const SizedBox(width: 14),
                              _buildStatus(
                                  color: Colors.green, text: t(context, 'solved')),
                            ],
                          ),
                          const SizedBox(height: 20),
                          FilteringWidget(onChange: _onChange,),
                          const SizedBox(height: 20),
                          if (cacheReports.isNotEmpty) ...[
                            const Icon(FontAwesomeIcons.times,
                                size: 25, color: Colors.red),
                                const SizedBox(height: 10),
                            ...cacheReports
                                .map((report) => ReportWidget(
                                    report: report,
                                    onRemove: (r) => null,
                                    userType: model.user!.userType))
                                .toList(),
                                const SizedBox(height: 15),
                            const Icon(FontAwesomeIcons.check,
                                size: 25, color: Colors.green),
                                const SizedBox(height: 10),
                          ],
                          if (reports.isEmpty && !_loading)
                            Center(child: Text(t(context, 'no_problem'))),
                          ...reports
                              .map((report) => ReportWidget(
                                  report: report,
                                  onRemove: (r) => model.removeNotification(r),
                                  userType: model.user!.userType))
                              .toList()
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatus({required Color color, required String text}) {
    return Row(
      children: [
        Container(color: color, width: 14, height: 14),
        const SizedBox(width: 3),
        Text(
          text,
          style: const TextStyle(fontSize: 14),
        )
      ],
    );
  }
}
