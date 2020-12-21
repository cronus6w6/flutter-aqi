import 'dart:convert';
import 'package:http/http.dart' as http;

import 'station.dart';

Future<List<Station>> fetchAQI() async {
  final response = await http.get(
      'https://data.epa.gov.tw/api/v1/aqx_p_432?format=json&limit=1000&api_key=d060280a-e98c-47bd-a8b5-91a1dbc87583&sort=County');

  print('response gotten');
  if (response.statusCode == 200) {
    var res = jsonDecode(response.body);

    List<Station> stations = List<Station>();
    List<dynamic> stationsInJson = res['records'];
    stationsInJson.forEach((station) {
      print(station['SiteName']);
      stations.add(Station.fromJson(station));
    });

    return stations;
  } else {
    print('status code:${response.statusCode}');
    throw Exception('Failed to load data');
  }
}
