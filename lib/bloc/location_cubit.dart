import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {

  LocationCubit() : super(LocationInitial());

Future<void> getLocation() async {
  LocationPermission permission = await Geolocator.checkPermission();

  // Если не дали — просим
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  // Если отказали или навсегда отказали
  if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
    emit(LocationError());
    return;
  }

  emit(LocationLoading());

  try {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    emit(LocationLoaded(position.latitude, position.longitude));
  } catch (error) {
    print('Ошибка при получении позиции: $error');
    emit(LocationError());
  }
}


}