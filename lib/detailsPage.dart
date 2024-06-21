import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailsPage extends StatelessWidget {
  final Map<String, dynamic> item;

  DetailsPage({required this.item});

  IconData getWeatherIcon(String description) {
    if (description.contains("rain")) {
      return Icons.umbrella_outlined;
    } else if (description.contains("cloud")) {
      return Icons.cloud;
    } else if (description.contains("sunny")) {
      return Icons.wb_sunny;
    } else {
      return Icons.wb_cloudy;
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final date = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back)),
      body: Stack(
        children: [
          // Blurred background container
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height: height * 0.4,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.withOpacity(0.8),
                    Colors.blueGrey.withOpacity(0.3),
                    Colors.lightBlue,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 50),
                    child: Text(
                      '5-Day Forecasts',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: height,
          ),
          // Main container positioned halfway in and halfway out
          Positioned(
            left: width * 0.1,
            right: width * 0.1,
            top: height * 0.2,
            child: Card(
              color: Colors.white,
              elevation: 7,
              child: Container(
                padding: EdgeInsets.all(5),
                height: height * 0.4,
                width: width * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.network(
                          'https://openweathermap.org/img/w/${item['weather'][0]['icon']}.png',
                          fit: BoxFit.contain,
                          width: 150,
                          height: 150,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat.yMMMd().format(date),
                              style: TextStyle(
                                color: Colors.grey.withOpacity(0.6),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '${item['main']['temp'].round()}/°C',
                              style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                              DateFormat.E()
                                  .format(DateTime.parse(item['dt_txt'])),
                              style: TextStyle(
                                  color: Colors.grey.withOpacity(0.6),
                                  fontSize: 18),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Icon(
                              getWeatherIcon(item['weather'][0]['description']),
                              color: Colors.lightBlue,
                            ),
                            Text(
                              item.containsKey('rain')
                                  ? '${item['rain']['3h']}%'
                                  : 'N/A',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text('Precipitation',
                                style: TextStyle(
                                    color: Colors.grey.withOpacity(0.7))),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.egg, color: Colors.blue),
                            Text(
                              '${item['main']['humidity'].round()}%',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Humidity',
                              style: TextStyle(
                                  color: Colors.grey.withOpacity(0.7)),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.speed, color: Colors.lightBlue),
                            Text(
                              '${item['wind']['speed'].round()} km/h',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text('Wind Speed',
                                style: TextStyle(
                                    color: Colors.grey.withOpacity(0.7))),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
