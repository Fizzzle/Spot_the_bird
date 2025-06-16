import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:spot_the_bird/bloc/bird_post_cubit.dart';
import 'package:spot_the_bird/main.dart';
import 'package:spot_the_bird/model/bird_post_model.dart';

class AddBirdPage extends StatefulWidget {

  final LatLng latLng; 
  final File? image;
  const AddBirdPage({super.key, required this.latLng, this.image});

  @override
  State<AddBirdPage> createState() => _AddBirdPageState();
}

class _AddBirdPageState extends State<AddBirdPage> {

  final _formKey = GlobalKey<FormState>();

  late final FocusNode _descriptionFocusNode;

  String? name;
  String? description;


  @override
  void initState() {
    _descriptionFocusNode = FocusNode();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _submit (BirdPostModel birdPostModel, BuildContext context) async {

    if(!_formKey.currentState!.validate()) {
      //! invalid
      return;
    }

    _formKey.currentState!.save();
       //save to cubit 

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Bird Spot"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
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
              10.verticalSpace,
          
              
              
              Container(child: Text("${widget.latLng.latitude} - ${widget.latLng.longitude}", style: TextStyle(fontSize: 12.sp),),),
                        10.verticalSpace,
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Enter bird name",
                  hintStyle: TextStyle(color: Colors.black26,)
                ),


                textInputAction: TextInputAction.next,
                onSaved: (value){
                  name = value!.trim();
                },

                onFieldSubmitted: (_){
                  //
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  
                },


                validator: (value) {
                  if(value!.isEmpty) {
                    return "Please write";
                  } 
                  if(value!.length < 2){
                    return "Bro this is not name";
                  }
                  return null;
                },
              ),
              
                        10.verticalSpace,
              TextFormField(
                focusNode: _descriptionFocusNode,

                decoration: InputDecoration(
                  hintText: "Enter bird description",
                  hintStyle: TextStyle(color: Colors.black26,)
                ),




                textInputAction: TextInputAction.done,


                onSaved: (value){
                  description = value!.trim();
                },
                validator: (value) {
                  if(value!.isEmpty) {
                    return "Please write";
                  } 
                  if(value!.length < 2){
                    return "Bro this is not description";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(onPressed: (){

          final BirdPostModel birdPostModel = BirdPostModel(birdName: name ?? 'no name', birdDescription: description ?? 'no description', latitude: widget.latLng.latitude, longtitude: widget.latLng.longitude, image: widget.image!);
            context.read<BirdPostCubit>().addBirdPost(birdPostModel);
          
          _submit(birdPostModel, context);
          // Navigator.of(context).pop();

      }, child: Text("Submit", style: TextStyle(fontSize: 20.sp),),),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}