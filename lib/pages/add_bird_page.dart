import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:spot_the_bird/main.dart';

class AddBirdPage extends StatefulWidget {

  final LatLng latLng; 
  final File? image;
  const AddBirdPage({super.key, required this.latLng, this.image});

  @override
  State<AddBirdPage> createState() => _AddBirdPageState();
}

class _AddBirdPageState extends State<AddBirdPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Bird Spot"),
        centerTitle: true,
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding:EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 10.h),
            child: Container(
              width: double.infinity,
              height: 200.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),              
                image:(widget.image != null) ? DecorationImage(image: FileImage(widget.image!),fit: BoxFit.cover,) : null,
              ),
            ),
          ),
          
          
          Container(child: Text("${widget.latLng.latitude} - ${widget.latLng.longitude}", style: TextStyle(fontSize: 12.sp),),),

          20.verticalSpace,
          TextField(),
          
        ],
      ),
      floatingActionButton: ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: Text("Submit", style: TextStyle(fontSize: 20.sp),),),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}