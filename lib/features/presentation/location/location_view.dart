import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:liv_social/features/presentation/common/spin_loading_indicator.dart';
import 'package:liv_social/features/presentation/location/location_cubit.dart';
import 'package:liv_social/features/presentation/location/widgets/search_field_bar.dart';

class LocationView extends StatelessWidget {
  const LocationView({Key? key}) : super(key: key);

  static Widget create(BuildContext context) {
    return BlocProvider(
      create: (context) => LocationCubit(context.read())..initialize(),
      child: const LocationView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: _HomeMap());
  }
}

class _HomeMap extends StatelessWidget {
  const _HomeMap({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<LocationCubit>();

    return BlocConsumer<LocationCubit, LocationState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return bloc.centralLocation != null
            ? Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                          target: bloc.centralLocation!, zoom: 15),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      onMapCreated: bloc.initMapa,
                      compassEnabled: false,
                      onCameraMove: (cameraPosition) {
                        bloc.updateCurrentLocation(cameraPosition.target);
                      },
                    ),
                  ),
                  const Positioned(
                    top: 0,
                    child: SearchFieldBar(),
                  ),
                ],
              )
            : Container(
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.center,
                child: const SpinLoadingIndicator(),
              );
      },
    );
  }
}
