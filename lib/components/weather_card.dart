import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:weather_app/components/weather_comp.dart';
import 'package:weather_app/controller/weather_controller.dart';
import 'package:weather_app/models/weather_model.dart';

class WeatherCard extends StatefulWidget {
  WeatherModel? value;
  WeatherCard({super.key, required this.value});

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  @override
  Widget build(BuildContext context) {
    WeatherController weatherController = Get.put(WeatherController());
    return Container(
      height: 100.h,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(vertical: 8.h),
        children: [
          WeatherComponent(icon: 'assets/humidity.png', text: 'HUMIDITY', value: '${widget.value!.main!.humidity}%'),
          WeatherComponent(icon: 'assets/wind.png', text: 'WIND', value: '${weatherController.finalSpeed.value} km/h'),
          WeatherComponent(icon: 'assets/temp.png', text: 'FEELS LIKE', value: '${weatherController.feelsLike.value}\u00B0')
        ],
      ),

      // ListView.builder(
      //     itemCount: weatherInfoModel.length,
      //     scrollDirection: Axis.horizontal,
      //     // physics: NeverScrollableScrollPhysics(),
      //     padding: EdgeInsets.symmetric(vertical: 8.h),
      //     shrinkWrap: true,
      //     itemBuilder: (context, index) {
      //       return WeatherComponent(
      //           icon: weatherInfoModel[index].icon.toString(),
      //           text: weatherInfoModel[index].text.toString(),
      //           value: weatherInfoModel[index].value.toString());
      //     }),
    );
  }
}
