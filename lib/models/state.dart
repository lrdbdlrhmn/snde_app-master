class StateModel {
  String id;
  String name;
  String nameFr;

  StateModel({this.id = '', this.name = '', this.nameFr = ''});

  StateModel.fromJson(Map<String, dynamic> state)
      : id = state['id'].toString(),
        nameFr = state['name_fr'],
        name = state['name'];
}
