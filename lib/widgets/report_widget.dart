import 'package:flutter/material.dart';
import 'package:snde/constants.dart';
import 'package:snde/functions.dart';
import 'package:snde/models/report.dart';
import 'package:snde/services/auth_service.dart';
import 'package:snde/services/store_service.dart';

class ReportWidget extends StatefulWidget {
  final Report report;
  final Function onRemove;
  final String userType;
  const ReportWidget(
      {Key? key,
      required this.report,
      required this.onRemove,
      required this.userType})
      : super(key: key);

  @override
  _ReportWidgetState createState() => _ReportWidgetState();
}

class _ReportWidgetState extends State<ReportWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 200,
      padding: const EdgeInsets.only(bottom:15),
      child: GestureDetector(
        onTap: () =>
            Navigator.pushNamed(context, '/show', arguments: widget.report),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: widget.report.id.isEmpty ? Colors.blue[300]! : reportStatusColor(widget.report.status), width: 1.5),
              boxShadow: [BoxShadow(color: Colors.black87.withOpacity(.2))],borderRadius: BorderRadius.circular(12)),
          // margin: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${AuthService.of(context).reportTypes[widget.report.reportType]}',
                      style: const TextStyle(fontSize: 21),
                    ),
                    Row(
                      children: [
                        // Text(
                        //     '${t(context, 'view_report.state')}: ${widget.report.stateName}',
                        //     style: const TextStyle(
                        //         fontSize: 13, color: Colors.black45)),
                        // const Text('  '),
                        // Text(
                        //     '${t(context, 'view_report.city')}: ${widget.report.cityName}',
                        //     style: const TextStyle(
                        //         fontSize: 13, color: Colors.black45)),
                        // const Text('  '),
                        Text(
                            '${t(context, 'view_report.region')}: ${widget.report.regionName}',
                            style: const TextStyle(
                                fontSize: 13, color: Colors.black45)),
                      ],
                    )
                  ],
                ),
              ),
              if(widget.report.createdAt.isNotEmpty && widget.report.createdAt != 'null')
                Text(formatDate(widget.report.createdAt),
                    style: const TextStyle(fontSize: 13, color: Colors.black45)),
            ],
          ),
        ),
      ),
    );
  }
}
