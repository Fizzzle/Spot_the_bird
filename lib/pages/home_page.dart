import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:spot_the_bird/bloc/location_cubit.dart';
import 'package:spot_the_bird/pages/add_bird_page.dart';


class MapScreen extends StatefulWidget {
  MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

    LatLng? _lastLocation;

  @override
  void initState() {
    super.initState();

      final state = context.read<LocationCubit>().state;
      if (state is LocationLoaded) {
        _lastLocation = LatLng(state.latitude, state.longtitude);
      }
  }

  Future<void> _pickImageAndCreatePost ({required LatLng latLong}) async {

    File? image;

    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 40);

    if(pickedFile != null) {
      image = File(pickedFile.path);

       Navigator.push(context, MaterialPageRoute(builder: (context) => AddBirdPage(latLng: latLong, image: image)));
    } else {
      print('Need image bro');
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LocationCubit, LocationState>(
        listener: (previousState, currentState) {
          if(currentState is LocationLoaded) {

            _lastLocation = LatLng(currentState.latitude, currentState.longtitude);
              _mapController.move(
                LatLng(currentState.latitude, currentState.longtitude),
                14,
              );
          }
        },
        child: 
          FlutterMap(
            mapController: _mapController,
          options: MapOptions(
            onLongPress: (tapPosition , latLngClick) {

              //todo Pick Image and go to AddBirdScreen

              _pickImageAndCreatePost(latLong: latLngClick);

            },
            initialCenter: _lastLocation ?? LatLng(0, 0),
            initialZoom: 15.3,
            maxZoom: 17,
            minZoom: 3.5,
          ), 
          
          children: [
            TileLayer( // Bring your own tiles
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // For demonstration only
              subdomains: ['a','b','c',],
              retinaMode: true,
              // And many more recommended properties!
            ),
          ],
        ),
      ),
    );
  }
}

