import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkHelper {
  NetworkHelper(this.url);
  final String url;

  Future getData() async {
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      String data = response.body;

      return jsonDecode(data);
    } else {
      debugPrint('$response.statusCode');
    }
  }
}

class WeatherModel {


  Future<dynamic> getAQICurrentLocation() async {
    NetworkHelper networkHelper = NetworkHelper(
        'https://api.waqi.info/feed/here/?token=a74f24a68131df1c5681ec9a1b79b50a453ed3ff');
    var aQI = await networkHelper.getData();

    return aQI;
  }

  Future<dynamic> getAQIofCity(String cityName) async {
    // var coordinatesData =
    //     await WeatherModel().getCoordinatesfromCityName(cityName);
    double latitude = 43.2220;
    double longitude = 76.8512;
    NetworkHelper networkHelper = NetworkHelper(
        'https://api.waqi.info/feed/geo:$latitude;$longitude/?token=a74f24a68131df1c5681ec9a1b79b50a453ed3ff');
    var aQI = await networkHelper.getData();

    return aQI;
  }


  String getAirQualityDescription(int aqi) {
    if (aqi >= 0 && aqi <= 50) {
      return 'Good';
    } else if (aqi >= 51 && aqi <= 100) {
      return 'Moderate';
    } else if (aqi >= 101 && aqi <= 150) {
      return 'Poor';
    } else if (aqi >= 151 && aqi <= 200) {
      return 'Unhealthy';
    } else if (aqi >= 201 && aqi <= 300) {
      return 'Very Unhealthy';
    } else {
      return 'Hazardous';
    }
  }

  Color getAirQualityDescriptionColor(int aqi) {
    if (aqi >= 0 && aqi <= 50) {
      return Colors.green;
    } else if (aqi >= 51 && aqi <= 100) {
      return Colors.teal;
    } else if (aqi >= 101 && aqi <= 150) {
      return Colors.orange;
    } else if (aqi >= 151 && aqi <= 200) {
      return Colors.red;
    } else if (aqi >= 201 && aqi <= 300) {
      return Colors.purple;
    } else {
      return Colors.brown;
    }
  }
}
