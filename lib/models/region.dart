class Region {
  String id;
  String name;
  String nameFr;
  String cityId;
  String stateId;

  Region({this.id = '', this.name = '', this.nameFr = '', this.stateId = '', this.cityId = ''});

  Region.fromJson(Map<String, dynamic> region)
      : id = '${region['id']}',
        name = region['name'],
        nameFr = region['name_fr'],
        stateId = '${region['state_id']}',
        cityId = '${region['city_id']}';
}
