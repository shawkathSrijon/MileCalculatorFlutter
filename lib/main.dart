import 'package:flutter/material.dart';
import 'package:mile_calculator/HomeScreen.dart';
import 'package:mile_calculator/user_location.dart';
import 'package:provider/provider.dart';
import 'MileCalculationBrain.dart';

void main() {
  runApp(const MileCalculator());
}

class MileCalculator extends StatelessWidget {
  const MileCalculator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserLocation>(
      create: (context) => MileCalculationBrain().locationStream,
      initialData: UserLocation(0.00, 0.00, 0.00),
      child: MaterialApp(
        home: HomeScreen(),
      ),
    );
  }
}

