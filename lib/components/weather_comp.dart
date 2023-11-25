// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeatherComponent extends StatelessWidget {
  String icon;
  // IconData icon;
  String text;
  String value;
  WeatherComponent({super.key, required this.icon, required this.text, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      child: Column(
        children: [
          Image.asset(
            icon,
            height: 30.h,
            color: Colors.white,
          ),
          // Icon(
          //   icon,
          //   size: 32.w,
          //   color: Colors.white,
          // ),
          SizedBox(
            height: 8.h,
          ),
          Text(
            text,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w300, color: Colors.white),
          ),
          SizedBox(
            height: 3.h,
          ),
          Text(
            value,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.white),
          )
        ],
      ),
    );
  }
}
