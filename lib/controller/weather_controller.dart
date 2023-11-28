// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_app/models/forecast_model.dart';
import 'package:weather_app/models/weather_model.dart';

class WeatherController extends GetxController {
  static String BASE_URL = 'https://api.openweathermap.org/data/2.5/';
  static String apiKey = '7cbbebc44d68e712f02b3e14cee28ce3';

  DateTime timeStamp = DateTime.now();
  Rx<WeatherModel> weatherData = WeatherModel().obs;
  Rx<WeatherModel> weatherListData = WeatherModel().obs;
  Rx<ForecastModel> forecastData = ForecastModel().obs;
  RxString name = ''.obs;
  RxString formattedDate = ''.obs;
  RxString formattedTime = ''.obs;
  RxString icon = ''.obs;
  RxString weather = ''.obs;
  RxString temperature = ''.obs;
  RxString humidity = ''.obs;
  RxString feelsLike = ''.obs;
  String speed = '';
  String windSpeed = '';
  RxString finalSpeed = ''.obs;
  List<dynamic> forecasts = [];
  RxList<dynamic> filteredForecasts = [].obs;
  RxList<dynamic> finalForecasts = [].obs;

  Future getWeather(String cityName) async {
    final response = await http.get(Uri.parse('${BASE_URL}weather?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      WeatherModel model = WeatherModel.fromJson(json.decode(response.body));
      name.value = model.name!;
      timeStamp = DateTime.fromMillisecondsSinceEpoch(model.dt!.toInt() * 1000);
      formattedDate.value = DateFormat('EE d').format(timeStamp);
      formattedTime.value = DateFormat('dd/MM/yyy hh:mm a').format(timeStamp);
      icon.value = model.weather![0].icon!.toString();
      weather.value = model.weather![0].main!.toString();
      temperature.value = model.main!.temp.toString();
      humidity.value = model.main!.humidity.toString();
      feelsLike.value = model.main!.feelsLike.toString();

      speed = model.wind!.speed.toString();
      windSpeed = ((double.parse(speed.toString()) * 3600) / 1000).toString();
      finalSpeed.value = windSpeed.substring(0, windSpeed.indexOf('.'));

      weatherData(model);
      finalForecasts.clear();
      await getWeatherForecast(model.coord!.lat, model.coord!.lon);
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future getWeatherList(String cityName) async {
    final response = await http.get(Uri.parse('${BASE_URL}weather?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      WeatherModel model = WeatherModel.fromJson(json.decode(response.body));

      weatherListData(model);
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future getCurrentLocation() async {
    LocationPermission locationPermission = await Geolocator.checkPermission();

    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
    }
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    String? cityName = placemarks[0].locality;

    return cityName ?? '';
  }

  Future getWeatherForecast(lat, long) async {
    final response = await http.get(Uri.parse('${BASE_URL}forecast?lat=$lat&lon=$long&cnt=32&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      ForecastModel model = ForecastModel.fromJson(json.decode(response.body));

      forecastData(model);
      forecasts = json.decode(response.body)['list'];
      filteredForecasts.value = filterForecast(forecasts);
      for (var forecast in filteredForecasts) {
        finalForecasts.add(forecast);
      }
    }
  }

  List<dynamic> filterForecast(List<dynamic> forecasts) {
    // This will display weather forecast for time 12:00 PM
    return forecasts.where((forecast) {
      final DateTime dateTime = DateTime.parse(forecast['dt_txt']);
      return dateTime.hour == 12 && dateTime.minute == 0;
    }).toList();
  }

  String getLottiePath(String icon) {
    final iconPaths = {
      '01d': '01d',
      '01n': '01n',
      '02d': '02d',
      '02n': '02n',
      '03d': '0304dn',
      '03n': '0304dn',
      '04d': '0304dn',
      '04n': '0304dn',
      '09d': '09dn10d',
      '09n': '09dn10d',
      '10d': '09dn10d',
      '10n': '10n',
      '11d': '11dn',
      '11n': '11dn',
      '13d': '13dn',
      '13n': '13dn',
      '50d': '50dn',
      '50n': '50dn',
    };
    return 'assets/lottie/${iconPaths[icon] ?? '01d'}.json';
  }

  String getbackgroundPath(String img) {
    final imgPaths = {
      'London': 'wallpaper2.jpg',
      'Paris': 'wallpaper.jpg',
      'New York': 'wallpaper3.jpg',
      'Mumbai': 'wallpaper4.jpg',
    };
    return 'assets/${imgPaths[img] ?? 'wallpaper0.jpg'}';
  }
}
