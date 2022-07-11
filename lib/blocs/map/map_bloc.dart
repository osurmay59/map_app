import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../constants/api.dart';
import '../../models/vehicle.dart';
import 'package:http/http.dart' as http;

import '../../themes/camberwell-flats.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final Set<Marker> _markers = {};

  GoogleMapController? _mapController;

  BitmapDescriptor? iconArrow;

  List<Vehicle> locationList = [];
  late Vehicle selectedLocation;

  Set<Marker>? myMarkers = {};

  MapBloc() : super(const MapState()) {
    on<OnMapInitializedEvent>(_onInitializeMap);
    on<OnMakerEvent>(_onMarkerEvent);

    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/icon-arrow.png")
        .then((onValue) {
      iconArrow = onValue;
    });

    Timer.periodic(const Duration(seconds: 10), (timer) async {
      Uri url =
          Uri.https(ApiConstants.BASE_URL, '/api/vehicles/with_last_position');

      const accessToken = ApiConstants.ACCESS_TOKEN;

      final res = await http
          .get(url, headers: {'Authorization': 'Bearer $accessToken'});

      final List decodedRes = json.decode(res.body);

      locationList =
          decodedRes.map((location) => Vehicle.fromMap(location)).toList();
      add(OnMakerEvent(locationList));
    });
    List<Vehicle?> searchVehicleLocation(String query) {
      List<Vehicle?> deviceListFiltered = locationList
          .where((location) => location.vehicleName
              .toLowerCase()
              .startsWith(query.toLowerCase()))
          .toList();

      return deviceListFiltered;
    }
  }

  void _onMarkerEvent(OnMakerEvent event, Emitter<MapState> emit) {
    myMarkers = <Marker>{};
    if (locationList.isNotEmpty) {
      for (var vehicle in locationList) {
        myMarkers!.add(Marker(
            rotation: vehicle.heading,
            markerId: MarkerId(vehicle.vehicleId.toString()),
            position: LatLng(vehicle.gpsLat, vehicle.gpsLng),
            icon: iconArrow ?? BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(
              title: vehicle.vehicleName,
              snippet:
                  "Latitude: ${vehicle.gpsLat}  Longitude: ${vehicle.gpsLng}  Last Speed: ${vehicle.speed}",
            )));
      }
    }

    emit(state.copyWith(myMarkers: myMarkers));
  }

  void _onInitializeMap(OnMapInitializedEvent event, Emitter<MapState> emit) {
    _mapController = event.controller;
    _mapController!.setMapStyle(jsonEncode(camberwellFlats));
    emit(state.copyWith(isMapInitialized: true));
  }
}
