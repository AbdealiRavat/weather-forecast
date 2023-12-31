// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controller/weather_controller.dart';

class LocationListTile extends StatelessWidget {
  String icon;
  int index;
  void Function()? onTap;
  void Function()? onLongPress;
  String cityName;
  String weather;
  String humidity;
  String wind;
  String temp;
  LocationListTile({
    super.key,
    required this.icon,
    required this.index,
    required this.onTap,
    required this.onLongPress,
    required this.cityName,
    required this.weather,
    required this.humidity,
    required this.wind,
    required this.temp,
  });

  WeatherController weatherController = Get.put(WeatherController());
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        height: 150.h,
        margin: EdgeInsets.symmetric(
          vertical: 8.w,
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white.withOpacity(0.28), const Color(0xffaaa5a5).withOpacity(0.28)],
            ),
            borderRadius: BorderRadius.circular(24.r)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      cityName.capitalizeFirst.toString(),
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 24.sp),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    index == 0
                        ? Image.asset(
                            'assets/location.png',
                            height: 20.h,
                            color: Colors.white,
                          )
                        : SizedBox(),
                  ],
                ),
                Text(
                  weather,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16.sp),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Row(
                  children: [
                    Text(
                      'Humidity ',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w200, fontSize: 16.sp),
                    ),
                    Text(
                      '$humidity%',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16.sp),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Wind ',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w200, fontSize: 16.sp),
                    ),
                    Text(
                      '${wind}km/h',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16.sp),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  weatherController.getLottiePath(icon),
                  width: 55.w,
                  height: 55.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      double.parse(temp).round().toString(),
                      style: TextStyle(fontSize: 48.sp, fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                    Text(
                      '\u00B0\u1D9C',
                      style: TextStyle(fontSize: 24.sp, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
