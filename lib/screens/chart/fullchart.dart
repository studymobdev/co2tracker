import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/footprint/calculate_footprint.dart';
import 'package:flutter_application_1/screens/home/homepage.dart';
import 'package:flutter_application_1/share/loadbar.dart';
import 'package:flutter_application_1/share/const.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/models/myuser.dart';
import 'package:flutter_application_1/services/database.dart';

class FullChartPage extends StatefulWidget {
  const FullChartPage({Key? key}) : super(key: key);

  @override
  State<FullChartPage> createState() => _FullChartPageState();
}

class _FullChartPageState extends State<FullChartPage> {
  var myScore;
  var myhistory;
  var graphSize = 7;
  var assetOptions = [
    "assets/transport/car.png",
    "assets/transport/train.png",
    "assets/materials/can.png",
    "assets/materials/documents.png",
    "assets/materials/clothes.png",
  ];

  String dropdownValue = '7 days';
  double sum = 0;
  double average = 0;

  var items = ['7 days', '30 days', 'All Time'];

  List<FlSpot> myMap = [];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User1?>(context);
    return StreamBuilder<UserData>(
        stream: Database(uid: user?.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData? userData = snapshot.data;
            myScore = userData?.scoreProgress;
            myScore = List<double>.from(myScore);

            myhistory = userData?.chosenOptions;
            myhistory = List.from(myhistory);

            if (dropdownValue == '7 days') {
              graphSize = 7;
              if (myScore.length >= 7) {
                myScore = myScore.sublist(myScore.length - 7);
              }
            }
            if (dropdownValue == '30 days') {
              graphSize = 30;
              if (myScore.length >= 30) {
                myScore = myScore.sublist(myScore.length - 30);
              } else {
                myScore = myScore;
              }
            }
            if (dropdownValue == 'All Time') {
              graphSize = myScore.length;
            }
            var mygoals = List<FlSpot>.generate(graphSize,
                (index) => FlSpot(index + 1, userData!.goal.toDouble()),
                growable: true);

            myMap = [];
            myScore.asMap().forEach((i, x) {
              myMap.insert(i, FlSpot(double.parse((i + 1).toString()), x));
            });
            print(myScore);
            if (!myScore.isEmpty) {
              sum = myScore.fold(0, (p, c) => p + c);
              average = sum / (myScore.length);

              return Scaffold(
                backgroundColor: firstColor,
                appBar: AppBar(
                  title: const Text(
                    'Progress Tracker',
                    style: TextStyle(color: Colors.white),
                  ),
                  centerTitle: true,
                  backgroundColor: firstColor,
                ),
                body: SingleChildScrollView(
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Card(
                        color: secondColor,
                        margin: const EdgeInsets.all(16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(25),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                        "kg${"CO\u2082e"}" ' vs Days', style: TextStyle(fontSize: 20)),
                                    Row(
                                      children: [
                                        const Text('Your Last ', style: TextStyle(fontSize: 14)),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        DropdownButton(
                                            value: dropdownValue,
                                            icon: const Icon(Icons.keyboard_arrow_down),
                                            items: items.map((String items) {
                                              return DropdownMenuItem(
                                                  value: items,
                                                  child: Text(
                                                    items, style: const TextStyle(fontSize: 14),
                                                  ));
                                            }).toList(),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                dropdownValue = newValue!;});
                                            }),
                                      ],
                                    ),
                                  ]),
                              const SizedBox(height: 20,),
                              AspectRatio(
                                aspectRatio: 1,
                                child: LineChart(
                                  LineChartData(
                                      backgroundColor: firstColor,
                                      minY: 0,
                                      minX: 1,
                                      lineBarsData: [
                                        LineChartBarData(
                                            isStepLineChart: true,
                                            spots: mygoals,
                                            isCurved: true,
                                            dotData: FlDotData(show: false),
                                            color: secondColor),
                                        LineChartBarData(
                                          spots: myMap,
                                          isCurved: false,
                                          dotData: FlDotData(show: true),
                                          color: Colors.orange,
                                          barWidth: 3,
                                        ),
                                      ],
                                      titlesData: FlTitlesData(
                                        rightTitles: AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false),
                                        ),
                                        topTitles: AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false),
                                        ),
                                      )),
                                  swapAnimationDuration:
                                      const Duration(milliseconds: 550),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Text('Average score is'),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    average.toStringAsFixed(2) + " kg${"CO\u2082e"}",
                                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        color: secondColor,
                        margin: const EdgeInsets.all(16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        elevation: 10,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(children: [
                            for (var i = 0; i < myhistory.length; i++) ...[
                              Container(
                                decoration: const BoxDecoration(
                                    color: firstColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      myhistory[i]['Date'],
                                      style: const TextStyle(color: secondColor),
                                    ),
                                    Text(
                                      myScore[myScore.length - myhistory.length + i].toStringAsFixed(2) + ' kg${"CO\u2082e"}',
                                      style: const TextStyle(
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    for (var j = 0; j < optionChoices.length; j++) ...[
                                      if (myhistory[i][optionChoices[j]] != null) ...[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 40,
                                              child: Image.asset(assetOptions[j]),
                                            ),
                                            Text(optionChoices[j]),
                                            Row(
                                              children: [
                                                Text(
                                                  myhistory[i][optionChoices[j]].toString(),
                                                  style: TextStyle(
                                                      color: optionChoices[j] !=
                                                                  "Car" &&
                                                              optionChoices[j] != "Train" ? Colors.green : Colors.red),
                                                ),
                                                const SizedBox(width: 2,),
                                                Text(
                                                    optionChoices[j] != "Car" && optionChoices[j] != "Car" ? '\$' : "km")
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10,)
                                      ]
                                    ]
                                  ],
                                ),
                              )
                            ]
                          ]),
                        ),
                      )
                    ],
                  )),
                ),
              );
            } else {
              return Scaffold(
                backgroundColor: firstColor,
                appBar: AppBar(
                  title: const Text(
                    'Progress Tracker',
                    style: TextStyle(color: Colors.white),
                  ),
                  centerTitle: true,
                  backgroundColor: firstColor,
                ),
                body: const Center(
                    child: Text(
                      "No score calculated! Please calculate a score",
                      style: TextStyle(color: secondColor),
                    )),
              );
            }
          } else {
            return const LoadBar();
          }
        });
  }
}
