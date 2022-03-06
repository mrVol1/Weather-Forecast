import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weather/api/weather_api.dart';
import 'package:weather/models/weather_daily.dart';
import 'package:weather/screens/city_screen.dart';
import 'package:weather/widgets/bottom_list_view.dart';
import 'package:weather/widgets/city_view.dart';
import 'package:weather/widgets/detail_view.dart';
import 'package:weather/widgets/temp.dart';

class WeatherScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final locationWeather;
  // ignore: use_key_in_widget_constructors
  const WeatherScreen({required this.locationWeather});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<WeatherForecast> forecastObject;
  late String _cityName;

  @override
  void initState() {
    super.initState();
    if (widget.locationWeather != null) {
      forecastObject = Future.value(widget.locationWeather);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('openweathermap.org'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.my_location),
          onPressed: () {
            setState(() {
              forecastObject =
                  WeatherApi().featchWeather(cityName: '', isCity: false);
            });
          },
        ),
        actions: [
          IconButton(
            onPressed: () async {
              Route route =
                  MaterialPageRoute(builder: (context) => const CityScreen());
              var tappedName = await Navigator.push(context, route);
              if (tappedName != null) {
                setState(() {
                  _cityName = tappedName;
                  forecastObject = WeatherApi()
                      .featchWeather(cityName: _cityName, isCity: true);
                });
              }
            },
            icon: const Icon(Icons.location_city),
          ),
        ],
      ),
      body: ListView(
        children: [
          FutureBuilder<WeatherForecast>(
            future: forecastObject,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    const SizedBox(
                      height: 50.0,
                    ),
                    CityView(snapshot: snapshot),
                    const SizedBox(
                      height: 50.0,
                    ),
                    TempView(snapshot: snapshot),
                    const SizedBox(
                      height: 50.0,
                    ),
                    DetailsView(snapshot: snapshot),
                    const SizedBox(
                      height: 50.0,
                    ),
                    BottomListView(snapshot: snapshot),
                  ],
                );
              } else {
                return const Center(
                  child: Text(
                    'City not found\nPlease, enter correct city',
                    style: TextStyle(color: Colors.black87, fontSize: 40.0),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
