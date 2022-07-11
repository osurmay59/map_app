part of 'map_bloc.dart';

class MapState extends Equatable {
  final Set<Marker> newMarkers;
  final bool isMapInited;

  const MapState({this.isMapInited = false, Set<Marker>? markers})
      : newMarkers = markers ?? const {};

  MapState copyWith({
    Set<Marker>? myMarkers,
    bool? isMapInitialized,
  }) =>
      MapState(
        isMapInited: isMapInitialized ?? isMapInited,
        markers: myMarkers ?? this.newMarkers,
      );

  @override
  List<Object> get props => [isMapInited, newMarkers];
}
