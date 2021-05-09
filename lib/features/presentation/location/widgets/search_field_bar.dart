import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:liv_social/core/localization/keys.dart';
import 'package:liv_social/features/data/models/place.dart';
import 'package:liv_social/features/presentation/location/location_cubit.dart';
import 'package:provider/provider.dart';

class SearchFieldBar extends StatelessWidget {
  const SearchFieldBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bloc = context.watch<LocationCubit>();
    return SizedBox(
      width: size.width,
      height: size.height - 25,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: size.height * .9,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey, width: .4)),
              boxShadow: [
                BoxShadow(
                    blurRadius: 7,
                    color: Colors.black45,
                    spreadRadius: 4,
                    offset: Offset(-4, -4))
              ],
              color: Colors.white,
            ),
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppBar(
                  title: const Text('Location', // TODO: translate
                      style: TextStyle(color: Colors.black)),
                  centerTitle: true,
                  leading: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  backgroundColor: Colors.transparent,
                  iconTheme: const IconThemeData(color: Colors.black),
                  elevation: 0,
                ),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 20.0, right: 30.0),
                        child: const _DestinationLocationField(),
                      ),
                      ...bloc.placesDestinationFound.map(
                        (place) => _SugerationPlace(
                            place: place,
                            onTap: () => Navigator.of(context).pop(place)),
                      ),
                      const _PickInMapOption(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SugerationPlace extends StatelessWidget {
  const _SugerationPlace({
    Key? key,
    required this.place,
    required this.onTap,
  }) : super(key: key);
  final Place place;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => onTap(),
        child: Container(
          width: double.infinity,
          height: 40,
          padding: const EdgeInsets.only(
              left: 8.0, top: 5.0, bottom: 3.0, right: 8.0),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.transparent, width: 0),
              bottom: BorderSide(color: Colors.grey, width: .3),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 30.0,
                child: SvgPicture.asset('assets/icons/location/clock.svg',
                    height: 25.0),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(child: Text(place.name!)),
                      Expanded(
                          child: Text(place.address,
                              overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PickInMapOption extends StatelessWidget {
  const _PickInMapOption({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<LocationCubit>();
    return GestureDetector(
      onTap: () => bloc.changeManualPickInMap(),
      child: Container(
        height: 50,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.transparent, width: 0),
            bottom: BorderSide(color: Colors.grey, width: .3),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                width: 30.0,
                child: SvgPicture.asset('assets/icons/location/move_in_map.svg',
                    height: 25.0),
              ),
              const SizedBox(width: 10.0),
              const Text('Set on map', // TODO: translate
                  style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}

class _DestinationLocationField extends HookWidget {
  const _DestinationLocationField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();
    final bloc = context.watch<LocationCubit>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: searchController,
                autofocus: false,
                onTap: () {},
                onSubmitted: (text) => bloc.searchLocation(text),
                textAlignVertical: TextAlignVertical.center,
                textInputAction: TextInputAction.done,
                style: const TextStyle(color: Color(0xff545253), fontSize: 14),
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 0.1)),
                  focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 0.1)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: Colors.transparent, width: 0.1),
                  ),
                  contentPadding: const EdgeInsets.all(0),
                  alignLabelWithHint: true,
                  hintText: 'Location', //TODO: translate
                  isDense: true,
                  hintStyle:
                      const TextStyle(color: Color(0xff545253), fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
