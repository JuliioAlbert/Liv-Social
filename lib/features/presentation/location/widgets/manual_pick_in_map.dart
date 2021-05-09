import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:liv_social/features/presentation/location/location_cubit.dart';
import 'package:provider/provider.dart';

class ManualPickInMap extends StatelessWidget {
  const ManualPickInMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bloc = context.watch<LocationCubit>();
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: kToolbarHeight,
              child: AppBar(
                title: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 3.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xfff0f0f0)),
                    child:
                        const Text('', style: TextStyle(color: Colors.black))),
                centerTitle: true,
                leading: IconButton(
                  onPressed: () => bloc.onBack(),
                  icon: const Icon(Icons.arrow_back),
                ),
                backgroundColor: Colors.transparent,
                iconTheme: const IconThemeData(color: Colors.black),
                elevation: 0,
              ),
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            height: 80,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                    right: -130,
                    top: -20,
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 3.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black),
                        child: const Text('Location', //TODO: translate
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500)))),
                SvgPicture.asset('assets/icons/location/move_in_map.svg',
                    height: 30.0),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.only(bottom: 30.0),
              width: double.infinity,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40.0, vertical: 5.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 40.0),
                  child: ElevatedButton(
                    onPressed: () => bloc.confirmManualPick(),
                    child: const Text(
                      'Confirm', //TODO: translate
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
