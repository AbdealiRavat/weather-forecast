// ignore_for_file: must_be_immutable, invalid_use_of_protected_member

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:weather_app/components/forecast_card.dart';
import 'package:weather_app/components/weather_card.dart';
import 'package:weather_app/controller/location_list_controller.dart';
import 'package:weather_app/controller/weather_controller.dart';

import '../components/toast.dart';
import 'saved_locations_screen.dart';

class HomeScreen extends StatefulWidget {
  String? cityName;
  HomeScreen({
    super.key,
    this.cityName,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController animationController;

  WeatherController weatherController = Get.put(WeatherController());
  LocationListController locationListController = Get.put(LocationListController());

  fetchWeather() async {
    String cityName = widget.cityName == null ? await weatherController.getCurrentLocation() : widget.cityName.toString();
    // String cityName = widget.cityName == null ? 'dubai' : widget.cityName.toString();
    try {
      await weatherController.getWeather(cityName).then((value) {
        if (widget.cityName != null) {
          locationListController.locationHumidty.value.add(weatherController.humidity.toString());
          locationListController.locationTemp.value.add(weatherController.temperature.toString());
          locationListController.locationWeather.value.add(weatherController.weather.toString());
          locationListController.locationWind.value.add(weatherController.finalSpeed.toString());
          locationListController.locationIcon.value.add(weatherController.icon.toString());
        }
      });
    } catch (e) {
      locationListController.locationList.removeLast();
      print(locationListController.locationList.length);
      ScaffoldMessenger.of(context).showSnackBar(Toast('No Such Location Found'));
      // throw e.toString();
    }
  }

  @override
  initState() {
    super.initState();
    fetchWeather();

    animationController = AnimationController(vsync: this, duration: const Duration(seconds: 5));
    animationController.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light),
        child: Container(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(weatherController.getbackgroundPath(widget.cityName.toString())),
                  fit: BoxFit.cover,
                  opacity: 0.45),
              color: Colors.black
              //     gradient: LinearGradient(colors: [Color(0xff302b63), Color(0xff24243e)], begin: Alignment.topLeft),
              ),
          child: Obx(() => weatherController.name.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.w,
                  ),
                  children: [
                    myAppbar(() async {
                      setState(() {
                        animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200));
                        animationController.forward();
                      });
                      Timer(const Duration(milliseconds: 500), () {
                        Get.to(() => const SavedLocationsScreen());
                      });
                    }, animationController),
                    SizedBox(
                      height: 50.h,
                    ),
                    Text(
                      weatherController.formattedDate.value,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 40.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Updated ', style: TextStyle(fontSize: 15.sp, color: Colors.white)),
                        Text(weatherController.formattedTime.value, style: TextStyle(fontSize: 15.sp, color: Colors.white)),
                      ],
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Lottie.asset(
                      weatherController.getLottiePath(weatherController.icon.value),
                      width: 95.w,
                      height: 95.h,
                    ),
                    Text(
                      weatherController.weather.value,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          double.parse(weatherController.temperature.value).round().toString(),
                          style: TextStyle(fontSize: 80.sp, fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                        Text(
                          '\u00B0\u1D9C',
                          style: TextStyle(fontSize: 40.sp, color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 28.h,
                    ),
                    Obx(() => weatherController.weatherData.value.main != null
                        ? WeatherCard(value: weatherController.weatherData.value)
                        : Container()),
                    SizedBox(
                      height: 20.h,
                    ),
                    Obx(() => weatherController.forecastData.value.city != null
                        ? ForecastCard(
                            forecastData: weatherController.finalForecasts.value,
                          )
                        : Container()),
                    SizedBox(
                      height: 15.h,
                    ),
                    Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                        margin: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                            color: const Color(0xff535353).withOpacity(0.7), borderRadius: BorderRadius.circular(20.r)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'Lowest',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  'Highest',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            SfLinearGauge(
                              minimum: -20,
                              maximum: 50,
                              minorTickStyle: LinearTickStyle(length: 5, color: Colors.white),
                              majorTickStyle: LinearTickStyle(length: 10, color: Colors.white),
                              axisLabelStyle: TextStyle(color: Colors.white),
                              showLabels: false,
                              markerPointers: [
                                LinearShapePointer(
                                  height: 8.h,
                                  width: 5.w,
                                  position: LinearElementPosition.inside,
                                  animationType: LinearAnimationType.ease,
                                  shapeType: LinearShapePointerType.triangle,
                                  value: weatherController.weatherData.value.main!.tempMin.toDouble(),
                                  color: Colors.white,
                                ),
                                LinearShapePointer(
                                  height: 8.h,
                                  width: 8.w,
                                  position: LinearElementPosition.cross,
                                  animationType: LinearAnimationType.ease,
                                  shapeType: LinearShapePointerType.circle,
                                  value: weatherController.weatherData.value.main!.temp.toDouble(),
                                  color: Colors.white,
                                ),
                                LinearShapePointer(
                                  height: 8.h,
                                  width: 5.w,
                                  position: LinearElementPosition.outside,
                                  animationType: LinearAnimationType.ease,
                                  shapeType: LinearShapePointerType.invertedTriangle,
                                  value: weatherController.weatherData.value.main!.tempMax.toDouble(),
                                  color: Colors.white,
                                ),
                              ],
                              ranges: <LinearGaugeRange>[
                                LinearGaugeRange(
                                  shaderCallback: (bounds) => LinearGradient(
                                          colors: [Color(0xff0d9dc9), Color(0xff0DC9AB), Color(0xffFFC93E), Color(0xffF45656)])
                                      .createShader(bounds),
                                  startValue: -20,
                                  endValue: 50,
                                  position: LinearElementPosition.cross,
                                  // color: Color(0xff0d9dc9)
                                ),
                                // LinearGaugeRange(
                                //     startValue: -10,
                                //     endValue: 10,
                                //     position: LinearElementPosition.outside,
                                //     color: Color(0xff0DC9AB)),
                                // LinearGaugeRange(
                                //     startValue: 10,
                                //     endValue: 20,
                                //     position: LinearElementPosition.outside,
                                //     color: Color(0xffFFC93E)),
                                // LinearGaugeRange(
                                //     startValue: 20,
                                //     endValue: 35,
                                //     position: LinearElementPosition.outside,
                                //     color: Color(0xffffffff)),
                                // LinearGaugeRange(
                                //     startValue: 20,
                                //     endValue: 100,
                                //     position: LinearElementPosition.outside,
                                //     color: Color(0xffF45656)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  weatherController.weatherData.value.main!.tempMin.toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  weatherController.weatherData.value.main!.tempMax.toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        )),
                    SizedBox(
                      height: 15.h,
                    ),
                  ],
                )),
        ),
      ),
    );
  }

  Widget myAppbar(onTap, animationController) {
    return Container(
      margin: EdgeInsets.only(top: 65.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Image.asset(
                'assets/location.png',
                height: 25.h,
                color: Colors.white,
              ),
              SizedBox(
                width: 5.w,
              ),
              Obx(() => Text(
                    weatherController.name.value,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 18.sp),
                  )),
            ],
          ),
          InkWell(
            onTap: onTap,
            child: Lottie.asset('assets/lottie/menu-bar.json', width: 35.w, height: 35.h, controller: animationController
                // fit: BoxFit.fill,
                ),
          ),
        ],
      ),
    );
  }
}
