import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app_flutter/api_Services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app_flutter/detailsPage.dart';
import 'dart:ui';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather APP',
      theme: ThemeData(
        primaryColor: Color(0xFFDAEDFB),
        scaffoldBackgroundColor: Color(0xFFDAEDFB),
        // Background color for scaffold
      ),
      home: WeatherApp(),
    );
  }
}

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  final WeatherService weatherService = WeatherService();
  Map<String, dynamic>? weatherData;
  String city = "Kolkata";
  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  void fetchWeatherData({String? cityName}) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final data = await weatherService.fetchWeather(cityName ?? city);
      setState(() {
        weatherData = data;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load weather data: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

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

  String getText(String description) {
    if (description.contains('rain')) {
      return 'rain';
    } else if (description.contains('cloud')) {
      return 'cloud';
    } else if (description.contains('sunny')) {
      return 'sunny';
    } else {
      return 'Unknown'; // You need to return a String in all cases
    }
  }

  Gradient getWeatherGradient(String description) {
    if (description.contains("rain")) {
      return LinearGradient(
        colors: [
          Colors.blueAccent.withOpacity(0.3),
          Colors.lightBlue.withOpacity(0.3),
          Colors.purple
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (description.contains("cloud")) {
      return LinearGradient(
        colors: [
          Colors.deepPurpleAccent.withOpacity(0.3),
          Colors.blue.withOpacity(0.3),
          Colors.blue
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (description.contains("sunny")) {
      return RadialGradient(
        colors: [
          Colors.deepOrange.withOpacity(0.5),
          Colors.orange,
          Colors.purple
        ],
        center: Alignment.topLeft,
        radius: 0.75,
      );
    } else {
      return LinearGradient(
        colors: [
          Colors.lightBlue,
          Colors.blue.withOpacity(0.3),
          Colors.purpleAccent
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
  }

  void showCityInputDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enter City Name", style: TextStyle(fontSize: 18)),
          content: TextField(
            onChanged: (value) {
              city = value;
            },
            decoration: InputDecoration(
                hintText: "City Name", hintStyle: TextStyle(fontSize: 12)),
          ),
          actions: [
            TextButton(
              child: Text("Get Weather"),
              onPressed: () {
                fetchWeatherData(cityName: city);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : weatherData == null || weatherData!['list'] == null
                  ? Center(child: Text('No data available'))
                  : SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.all(10),
                      child: Stack(
                        children: [
                          Container(
                            child: Column(
                              children: [
                                SizedBox(height : 20),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          fetchWeatherData();
                                        },
                                        icon: Icon(
                                          Icons.refresh,
                                          color: Colors.blue.withOpacity(0.6),
                                        )),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: Colors.blueGrey,
                                        ),
                                        SizedBox(
                                          width: width * 0.01,
                                        ),
                                        FittedBox(
                                          child: FittedBox(
                                              child: Text(
                                            '$city',
                                            style:
                                                GoogleFonts.anton(fontSize: 20),
                                          )),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.search,
                                        color: Colors.lightBlueAccent
                                            .withOpacity(0.7),
                                      ),
                                      onPressed: () =>
                                          showCityInputDialog(context),
                                    )
                                  ],
                                ),
                                SizedBox(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Text(
                                        DateFormat.EEEE()
                                            .format(DateTime.now()),
                                        style: TextStyle(
                                            color:
                                                Colors.grey.withOpacity(0.7)),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * 0.01,
                                    ),
                                    Text('|',
                                        style: TextStyle(
                                            color:
                                                Colors.grey.withOpacity(0.7))),
                                    SizedBox(
                                      width: width * 0.01,
                                    ),
                                    Container(
                                      child: Text(
                                        DateFormat.yMMMd()
                                            .format(DateTime.now()),
                                        style: TextStyle(
                                            color:
                                                Colors.grey.withOpacity(0.7)),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * 0.01,
                                    ),
                                    Container(
                                      child: Text(
                                          DateFormat.Hm()
                                              .format(DateTime.now()),
                                          style: TextStyle(
                                              color: Colors.grey
                                                  .withOpacity(0.7))),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.all(30),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: [
                                              Colors.deepPurpleAccent,
                                              Color(0xFF5A92F9)
                                                  .withOpacity(0.5),
                                              Colors.blueAccent
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 5.0, sigmaY: 5.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                                '${weatherData!['list'][0]['main']['temp'].round()}°C',
                                                style: GoogleFonts.righteous(
                                                  color: Colors.white
                                                      .withOpacity(0.8),
                                                  fontSize: 80,
                                                  fontWeight: FontWeight.bold,
                                                  shadows: [

                                                    Shadow(
                                                      offset: Offset(-1.0, 1.0),
                                                      blurRadius: 3.0,
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 255),
                                                    ),
                                                  ],
                                                )),
                                            Container(
                                              padding: EdgeInsets.only(right: 50),
                                              child: Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: FittedBox(
                                                    fit: BoxFit.contain,
                                                    child: Text(
                                                      weatherData!['list'][0]
                                                              ['weather'][0]
                                                          ['description'],
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white
                                                              .withOpacity(
                                                                  0.3)),
                                                    ),

                                                  )),
                                            ),
                                            SizedBox(width: 20,),
                                          ],
                                        ),
                                      ),
                                    ),
                                    height: height * 0.3,
                                    width: width,
                                  ),
                                ),
                                Card(
                                  color: Colors.white,
                                  elevation: 10,
                                  child: Container(
                                    decoration: BoxDecoration(),
                                    padding: EdgeInsets.all(10),
                                    height: height * 0.15,
                                    width: width,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            Icon(
                                              getWeatherIcon(
                                                  weatherData!['list'][0]
                                                          ['weather'][0]
                                                      ['description']),
                                              color: Colors.lightBlue,
                                            ),
                                            Text(
                                                weatherData!['list'][0]
                                                        .containsKey('rain')
                                                    ? '${weatherData!['list'][0]['rain']['3h']}%'
                                                    : 'N/A',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text('Perception',
                                                style: TextStyle(
                                                    color: Colors.grey
                                                        .withOpacity(0.7))),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Icon(Icons.egg, color: Colors.blue),
                                            Text(
                                                '${weatherData!['list'][0]['main']['humidity'].round()}%',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                              'Humidity',
                                              style: TextStyle(
                                                  color: Colors.grey
                                                      .withOpacity(0.7)),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Icon(Icons.speed,
                                                color: Colors.lightBlue),
                                            Text(
                                                '${weatherData!['list'][0]['wind']['speed'].round()} km/h',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text('Wind Speed',
                                                style: TextStyle(
                                                    color: Colors.grey
                                                        .withOpacity(0.7))),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Today'),
                                    Text('5-Day Forecast'),
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                Container(
                                  height: height * 0.3,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 5, // Limiting to 5 days
                                    itemBuilder: (context, index) {
                                      final item = weatherData!['list']
                                          [index * 8]; // 8 data points per day
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailsPage(item: item)));
                                        },
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal:
                                                  5.0), // Add horizontal margin

                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            gradient: getWeatherGradient(
                                                item['weather'][0]
                                                    ['description']),
                                          ),
                                          width: width * 0.2,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  DateFormat.E().format(
                                                      DateTime.parse(
                                                          item['dt_txt'])),
                                                  style: TextStyle(
                                                      color: Colors.white
                                                          .withOpacity(0.6),
                                                      fontSize: 18),
                                                ),
                                                SizedBox(height: 10),
                                                Image.network(
                                                  'https://openweathermap.org/img/w/${item['weather'][0]['icon']}.png',
                                                  width: 80,
                                                  height: 80,
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  '${item['main']['temp'].round()}°C',
                                                  style: GoogleFonts.lateef(
                                                      fontSize: 20,
                                                      color: Colors.white
                                                          .withOpacity(0.6),
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: height / 2.5,
                            left: -15,
                            child: Container(
                              width: width * 0.5, // Fixed width
                              height: height * 0.5, // Fixed height
                              child: Image.network(
                                'https://openweathermap.org/img/w/${weatherData!['list'][0]['weather'][0]['icon']}.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      )),
    );
  }
}
