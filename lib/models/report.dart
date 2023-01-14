class Report {
  String id;
  String reportType;
  String latlng;
  String status;
  String stateName;
  String cityName;
  String regionName;
  String firstName;
  String technicalName;
  String phone;
  String userId;
  String image;
  String description = '';
  String createdAt;

  Report(
      {this.id = '',
      this.reportType = '',
      this.latlng = '',
      this.stateName = '',
      this.cityName = '',
      this.regionName = '',
      this.status = '',
      this.firstName = '',
      this.phone = '',
      this.technicalName = '',
      this.userId = '',
      this.description = '',
      this.createdAt = '',
      this.image = ''});

  Report.fromJson(Map<String, dynamic> region)
      : id = region['id']?.toString() ?? '',
        reportType = region['report_type'] ?? '',
        latlng = region['latlng']?.toString() ?? '',
        status = region['status'] ?? '',
        stateName = region['state_name'] ?? '',
        cityName = region['city_name'] ?? '',
        regionName = region['region_name'] ?? '',
        firstName = region['first_name'] ?? '',
        phone = region['phone']?.toString() ?? '',
        technicalName = region['technical_name'] ?? '',
        userId = region['user_id']?.toString() ?? '',
        description = region['description'] ?? '',
        image = region['image'] ?? '',
        createdAt = region['created_at'] ?? '';
}
