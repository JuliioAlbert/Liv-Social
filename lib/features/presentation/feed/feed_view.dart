import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liv_social/features/presentation/feed/feed_cubit.dart';

class FeedView extends StatelessWidget {
  const FeedView({Key? key}) : super(key: key);

  static Widget create(BuildContext context) {
    return BlocProvider(
      create: (context) => FeedCubit(),
      child: const FeedView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: const Text('FEED'),
    );
  }
}
