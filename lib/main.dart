// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:light/light.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription<int>? _lightEvents;
  double luxValue = 100;
  double sliderValue = 100;
  double maxSliderValue = 3000;

  void onData(int value) async {
    print("value in onData: $value");
    setState(() {
      luxValue = value.toDouble();
      if (luxValue < maxSliderValue) {
        sliderValue = luxValue;
      }
    });
  }

  void startListening() {
    try {
      _lightEvents = Light().lightSensorStream.listen(onData);
    } catch (exception) {
      print(exception);
    }
  }

  void stopListening() {
    _lightEvents?.cancel();
  }

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      startListening();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _getRadialGauge(),
            Slider(
              value: sliderValue,
              min: 0,
              max: maxSliderValue,
              onChanged: (value) {
                setState(() {
                  sliderValue = value;
                  luxValue = sliderValue;
                });
              },
            ),
            // LuxChart(
            //   chartValue: luxValue,
            // )
          ],
        ),
      ),
    );
  }

  Widget _getRadialGauge() {
    return SfRadialGauge(
      title: const GaugeTitle(
        text: 'Lux Meter',
        textStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
      axes: <RadialAxis>[
        RadialAxis(
          minimum: 0,
          maximum: 2000,
          ranges: <GaugeRange>[
            GaugeRange(
              startValue: 0,
              endValue: 300,
              color: Colors.red,
              startWidth: 10,
              endWidth: 10,
            ),
            GaugeRange(
              startValue: 300,
              endValue: 1000,
              color: Colors.orange,
              startWidth: 10,
              endWidth: 10,
            ),
            GaugeRange(
              startValue: 1000,
              endValue: 2000,
              color: Colors.green,
              startWidth: 10,
              endWidth: 10,
            ),
          ],
          pointers: <GaugePointer>[NeedlePointer(value: luxValue)],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              widget: Container(
                child: Text(
                  luxValue.toStringAsFixed(1),
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              angle: 90,
              positionFactor: 0.5,
            ),
          ],
        ),
      ],
    );
  }
}
