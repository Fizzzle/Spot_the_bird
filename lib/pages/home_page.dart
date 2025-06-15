import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:spot_the_bird/bloc/location_cubit.dart';


class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LocationCubit, LocationState>(
        builder: (context, state) {


          if(state is LocationLoaded)
         { 
          return FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(state.latitude, state.longtitude),
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
            MarkerLayer(markers: [
              Marker(point: LatLng(state.latitude, state.longtitude), child: Icon(Icons.face),),
            ])
          ],
        );}

        if(state is LocationError){
          return Center(child: ElevatedButton(
          onPressed: () {
            context.read<LocationCubit>().getLocation();
          }, 
          child: Text('Retry')
          ),);
        }

        return Center(child: CircularProgressIndicator(),);
                } 
      ),
    );
  }
}