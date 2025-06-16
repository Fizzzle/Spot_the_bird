import 'dart:io';

class BirdPostModel {
  final String birdName;
  final String birdDescription;
  final double latitude;
  final double longtitude;
  final File image;

  BirdPostModel({required this.birdName, required this.birdDescription, required this.latitude, required this.longtitude, required this.image});
}