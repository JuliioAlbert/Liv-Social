import 'package:flutter/material.dart';

class SpinLoadingIndicator extends StatelessWidget {
  const SpinLoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Center(
        child: Image.asset('assets/icons/general/spin_loading.gif',
            height: 45.0, fit: BoxFit.contain),
      ),
    );
  }
}
