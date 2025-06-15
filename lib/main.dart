import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spot_the_bird/bloc/location_cubit.dart';
import 'package:spot_the_bird/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocationCubit>(
      create: (context) => LocationCubit()..getLocation(),

      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Color(0xFFF6F0F0),
          colorScheme: ColorScheme.light().copyWith(
            primary: Color(0xFF4A4947),
            secondary: Color(0xFFD8D2C2),
          )
        ),
        home:MapScreen(),
      ),
    );
  }
}
