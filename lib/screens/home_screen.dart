// ignore_for_file: must_be_immutable, invalid_use_of_protected_member

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/components/forecast_card.dart';
import 'package:weather_app/components/weather_card.dart';
import 'package:weather_app/controller/weather_controller.dart';

import 'saved_locations_screen.dart';

class HomeScreen extends StatefulWidget {
  String? cityName;
  HomeScreen({super.key, this.cityName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController animationController;

  WeatherController weatherController = Get.put(WeatherController());

  fetchWeather() async {
    String cityName = widget.cityName == null ? await weatherController.getCurrentLocation() : widget.cityName.toString();
    try {
      await weatherController.getWeather(cityName);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
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
          decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/wallpaper.jpg'), fit: BoxFit.cover, opacity: 0.45),
              color: Colors.black
              //     gradient: LinearGradient(colors: [Color(0xff302b63), Color(0xff24243e)]   , begin: Alignment.topLeft),
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
