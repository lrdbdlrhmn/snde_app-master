class City {
  String id;
  String name;
  String nameFr;
  String stateId;

  City({this.id = '', this.name = '', this.nameFr = '', this.stateId = ''});

  City.fromJson(Map<String, dynamic> city)
      : id = '${city['id']}',
        name = city['name'],
        nameFr = city['name_fr'],
        stateId = '${city['state_id']}';
}
