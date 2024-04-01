// ignore: file_names
class User {
  String id;
  String firstName;
  String lastName;
  String phone;
  String email;
  String whatsapp;
  int nni;
  int stateId;
  int cityId;
  int regionId;
  String userType;
  String accessToken;

  User(
      {this.id = '',
        this.firstName = '',
        this.lastName = '',
        this.phone = '',
        this.email = '',
        this.whatsapp = '',
        this.nni = 0,
        this.stateId = 0,
        this.cityId = 0,
        this.regionId = 0,
        this.userType = '',
        this.accessToken = ''});

  User.fromJson(Map<dynamic, dynamic> user)
      : id = '${user['id']}',
        firstName = user['first_name'],
        lastName = user['last_name'],
        phone = user['phone'],
        email = user['email'] ?? '',
        whatsapp = user['whatsapp'] ?? '',
        nni = int.parse('${user['nni'] ?? 0}'),
        stateId = int.parse('${user['state_id'] ?? 0}'),
        cityId = int.parse('${user['city_id'] ?? 0}'),
        regionId = int.parse('${user['region_id'] ?? 0}'),
        userType = '${user['user_type'] ?? ''}',
        accessToken = user['access_token'] ?? '';

  Map<String, String> get toJson => {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'phone': phone,
    'email': email,
    'whatsapp': whatsapp,
    'nni': '$nni',
    'state_id': '$stateId',
    'city_id': '$cityId',
    'region_id': '$stateId',
    'user_type': userType,
    'access_token': accessToken,
  };
}
