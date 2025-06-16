import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:spot_the_bird/bloc/bird_post_cubit.dart';
import 'package:spot_the_bird/bloc/location_cubit.dart';
import 'package:spot_the_bird/model/bird_post_model.dart';
import 'package:spot_the_bird/pages/add_bird_page.dart';

class MapPage extends StatefulWidget {
  MapPage({super.key});

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
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

  Future<void> _pickImageAndCreatePost({required LatLng latLong}) async {
    File? image;

    final picker = ImagePicker();

    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 40);

    if (pickedFile != null) {
      image = File(pickedFile.path);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  AddBirdPage(latLng: latLong, image: image)));
    } else {
      print('Need image bro');
    }
  }

  List<Marker> _buildMarkers(
      BuildContext context, List<BirdPostModel> birdPostsModel) {
    List<Marker> markers = [];

    birdPostsModel.forEach((post) {
      markers.add(
        Marker(
          width: 55.r,
          height: 55.r,
          point: LatLng(post.latitude, post.longtitude),
          child: Container(
            child: Icon(
              Icons.mark_chat_unread,
            ),
          ),
        ),
      );
    });

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LocationCubit, LocationState>(
        listener: (previousState, currentState) {
          if (currentState is LocationLoaded) {
            _lastLocation =
                LatLng(currentState.latitude, currentState.longtitude);
            _mapController.move(
              LatLng(currentState.latitude, currentState.longtitude),
              14,
            );
          }
        },
        child: BlocBuilder<BirdPostCubit, BirdPostState>(
          buildWhen: (previous, current) => (previous.status != current.status),
          builder: (context, birdPostState) {
            return FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                onLongPress: (_, latLngClick) {
                  //todo Pick Image and go to AddBirdScreen

                  _pickImageAndCreatePost(latLong: latLngClick);
                },
                initialCenter: _lastLocation ?? LatLng(0, 0),
                initialZoom: 15.3,
                maxZoom: 17,
                minZoom: 3.5,
              ),
              children: [
                TileLayer(
                  // Bring your own tiles
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // For demonstration only
                  subdomains: [
                    'a',
                    'b',
                    'c',
                  ],
                  retinaMode: true,
                  // And many more recommended properties!
                ),
                MarkerLayer(
                    markers:
                        _buildMarkers(context, birdPostState.birdPostsModel)),
              ],
            );
          },
        ),
      ),
    );
  }
}
