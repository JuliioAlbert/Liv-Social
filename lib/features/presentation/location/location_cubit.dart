import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:liv_social/features/data/models/place.dart';
import 'package:liv_social/features/domain/usecases/get_location.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit(
    this._locationUseCase,
  ) : super(LocationInitialState());

  final GetLocationUseCase _locationUseCase;
  LatLng? centralLocation;
  List<Place> _placesFound = [];
  late GoogleMapController _mapController;

  bool showManualPick = false;

  List<Place> get placesDestinationFound => _placesFound;

  void initialize() async {
    centralLocation = await _locationUseCase.getCurrentLocation();
    emit(LocationLoadedState());
  }

  void updateCurrentLocation(LatLng center) async {
    centralLocation = center;
  }

  void initMapa(GoogleMapController controller) async {
    _mapController = controller;
  }

  void confirmManualPick() async {
    final positionPlace = await _locationUseCase.getAddress(centralLocation!);
    emit(LocationConfirmManualPick(
        Place(positionPlace, null, centralLocation!)));
  }

  void searchLocation(String query) async {
    try {
      _placesFound =
          await _locationUseCase.searchPlace(query, centralLocation!);
      emit(LocationSearchSuccessState(_placesFound));
    } catch (e) {
      emit(LocationSearchErrorState());
    }
  }

  void changeManualPickInMap() {
    showManualPick = true;
    emit(LocationShowManualPickState());
  }

  void onBack() {
    if (showManualPick) {
      showManualPick = false;
      emit(LocationShowSearchBarState());
    }
  }
}

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object> get props => [];
}

class LocationInitialState extends LocationState {}

class LocationLoadedState extends LocationState {}

class LocationShowManualPickState extends LocationState {}

class LocationShowSearchBarState extends LocationState {}

class LocationSearchSuccessState extends LocationState {
  final List<Place> placesFound;

  const LocationSearchSuccessState(this.placesFound);

  @override
  List<Object> get props => [placesFound];
}

class LocationSearchErrorState extends LocationState {}

class LocationConfirmManualPick extends LocationState {
  final Place place;

  LocationConfirmManualPick(this.place);

  @override
  List<Object> get props => [place];
}
