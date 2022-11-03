import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:snde/constants.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String publicUrl = '$baseUrl/public';

  static bool connection = true;
  static String language = 'ar';
  static Map<String, String> headers = {
    //'api-key': 'XQd0e4n887CciZnk7h8Puo56sci26ay0cmy8DaRDesixelZvicRBgt2ZsPte',
    'Authorization': '',
    //'client-source': 'apis',
    //'app-v': appVersion,
    'app-language-x': ApiService.language
  };


  static setAccessToken(String? accessToken) {
    headers['Authorization'] = 'Bearer $accessToken';
  }

  static setLanguage(String? new_language) {
    language = new_language!;
    headers['app-language-x'] = new_language;
  }

  Future<Map<dynamic, dynamic>> get(String url) async {
    http.Response response = await http.get(_url(url), headers: headers);

    final result = json.decode(response.body);
    return {'code': response.statusCode,'result': result};
  }

  Future<Map<dynamic, dynamic>> delete(String? url) async {
    http.Response response = await http.delete(_url(url), headers: headers);

    final result = json.decode(response.body);
    return {'code': response.statusCode, 'result': result};
  }

  Future<dynamic> post(String? url,
      {required Map<String, dynamic> body}) async {
    http.Response response = await http.post(
      _url(url),
      body: json.encode(body),
      encoding: Encoding.getByName('utf8'),
      headers: {
        ...headers,
        'Content-Type': 'application/json',
      },
    );

    final result = json.decode(response.body);
    return {
      'code': response.statusCode,
      'result': result,
      'headers': response.headers
    };
  }

  Future<dynamic> put(String? url,
      {required Map<String, dynamic> body}) async {
    http.Response response = await http.put(
      _url(url),
      body: json.encode(body),
      encoding: Encoding.getByName('utf8'),
      headers: {
        ...headers,
        'Content-Type': 'application/json',
      },
    );

    final result = json.decode(response.body);
    return {
      //'code': response.statusCode,
      'result': result,
      //'headers': response.headers
    };
  }

  Future<dynamic> patch(String? url, {Map<String, dynamic>? body}) async {
    http.Response response = await http.patch(
      _url(url),
      body: json.encode(body),
      encoding: Encoding.getByName('utf8'),
      headers: {...headers, 'Content-Type': 'application/json'},
    );
    final result = json.decode(response.body);
    return {'code': response.statusCode, 'result': result};
  }

  upload(File imageFile, {String? url, Map<String, String>? body}) async {
    // open a bytestream
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = _url(url);

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('image', stream, length,
        filename: basename(imageFile.path));

    // add file to multipart
    request.files.add(multipartFile);
    request.fields.addAll(body ?? {});
    request.headers.addAll(headers);

    // send
    var response = await request.send();
    print(response.statusCode);

    // listen for response
    final responsive = await response.stream.transform(utf8.decoder).first;
    print(responsive);
    return {'code': response.statusCode, 'result': json.decode(responsive)};
  }

  Uri _url(String? url) {
    return Uri.parse('$baseUrl/${url ?? ''}');
  }
}

final ApiService apiService = ApiService();
