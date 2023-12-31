// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controller/weather_controller.dart';

class ForecastComponent extends StatelessWidget {
  String date;
  String icon;
  String temp;
  String speed;
  ForecastComponent({super.key, required this.date, required this.icon, required this.temp, required this.speed});

  @override
  Widget build(BuildContext context) {
    WeatherController weatherController = Get.put(WeatherController());
    return SizedBox(
      width: 80.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            date,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.white),
          ),
          SizedBox(
            height: 5.h,
          ),
          Lottie.asset(
            weatherController.getLottiePath(icon),
            width: 40.w,
            height: 40.h,
          ),
          SizedBox(
            height: 8.h,
          ),
          Text(
            '$temp\u00B0',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.white),
          ),
          SizedBox(
            height: 3.h,
          ),
          Text(
            '$speed km/h',
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
