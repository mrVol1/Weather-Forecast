import 'dart:convert';
import 'dart:developer';
import 'package:weather/models/weather_daily.dart';
import 'package:weather/utilites/constans.dart';
import 'package:http/http.dart' as http;
import 'package:weather/utilites/location.dart';

class WeatherApi {
  Future<WeatherForecast> featchWeather(
      {required String cityName, required bool isCity}) async {
    Location location = Location();
    await location.getCurrentLocation();

    Map<String, String> parametrs;

    if (isCity == true) {
      var queryParametrs = {
        'APPID': Constans.WEATHER_APP_ID,
        'units': 'metric',
        'q': cityName,
      };
      parametrs = queryParametrs;
    } else {
      var queryParametrs = {
        'APPID': Constans.WEATHER_APP_ID,
        'units': 'metric',
        'lat': location.latitude.toString(),
        'lon': location.longitude.toString(),
      };
      parametrs = queryParametrs;
    }

    var uri = Uri.https(Constans.WEATHER_BASE_URL_DOMAIN,
        Constans.WEATHER_FORECAST_PATH, parametrs);

    log('request: ${uri.toString()}');

    var response = await http.get(uri);

    print('response: ${response.body}');

    if (response.statusCode == 200) {
      return WeatherForecast.fromJson(
        json.decode(response.body),
      );
    } else {
      return Future.error('Error response');
    }
  }
}
