import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/components/forecast_comp.dart';

class ForecastCard extends StatefulWidget {
  List? forecastData;
  ForecastCard({
    super.key,
    required this.forecastData,
  });

  @override
  State<ForecastCard> createState() => _ForecastCardState();
}

class _ForecastCardState extends State<ForecastCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        // height: 150.h,
        alignment: Alignment.center,
        constraints: BoxConstraints(maxHeight: 150.h, maxWidth: 345.w),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(color: Color(0xff535353).withOpacity(0.7), borderRadius: BorderRadius.circular(20.r)),
        child: ListView.builder(
            itemCount: widget.forecastData!.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              DateTime timeStamp = DateTime.parse(widget.forecastData![index]["dt_txt"]);
              String formattedDate = DateFormat('EE d').format(timeStamp);

              String temperature = double.parse(widget.forecastData![index]['main']['temp'].toString()).round().toString();
              String speed = widget.forecastData![index]["wind"]['speed'].toString();
              String windSpeed = ((double.parse(speed.toString()) * 3600) / 1000).round().toString();
              String icon = widget.forecastData![index]["weather"][0]['icon'].toString();

              return ForecastComponent(date: formattedDate, icon: icon, temp: temperature, speed: windSpeed);
            }));
  }
}
