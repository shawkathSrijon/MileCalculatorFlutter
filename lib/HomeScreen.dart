import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mile_calculator/MileCalculationBrain.dart';
import 'package:mile_calculator/user_location.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //MileCalculationBrain brain = MileCalculationBrain();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mile Calculator'),
      ),
      body: ChangeNotifierProvider(
        create: (context) {

        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Latitude: ${Provider.of<UserLocation>(context).latitude.toString()}',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Longitude: ${Provider.of<UserLocation>(context).longitude.toString()}',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Speed: ${Provider.of<UserLocation>(context).speed.toString()}',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Total Distance: ${MileCalculationBrain().totalDistance.toString()}',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
