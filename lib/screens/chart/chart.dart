import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/home/homepage.dart';
import 'package:flutter_application_1/share/loadbar.dart';
import 'package:flutter_application_1/share/const.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/models/myuser.dart';
import 'package:flutter_application_1/services/database.dart';

class LineChartPage extends StatefulWidget {
  const LineChartPage({Key? key}) : super(key: key);

  @override
  State<LineChartPage> createState() => _LineChartPageState();
}

class _LineChartPageState extends State<LineChartPage> {
  var myScore;
  List<FlSpot> myMap = [];
  // var myArray = [];
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
            if (myScore.length < 1) {
              return const SizedBox(
                width: 150,
                child: Text('No score calculated yet!'),
              );
            } else {
              if (myScore.length >= 7) {
                myScore = myScore.sublist(myScore.length - 7);
              }
              myMap = [];
              myScore.asMap().forEach((i, x) {
                myMap.insert(i, FlSpot(double.parse((i + 1).toString()), x));
              });
              return AspectRatio(
                aspectRatio: 1.5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LineChart(
                    LineChartData(
                        maxX: 7,
                        backgroundColor: firstColor,
                        minY: 0,
                        minX: 1,
                        lineBarsData: [
                          LineChartBarData(
                              spots: [
                                FlSpot(1, userData!.goal.toDouble()),
                                FlSpot(2, userData.goal.toDouble()),
                                FlSpot(3, userData.goal.toDouble()),
                                FlSpot(4, userData.goal.toDouble()),
                                FlSpot(5, userData.goal.toDouble()),
                                FlSpot(6, userData.goal.toDouble()),
                                FlSpot(7, userData.goal.toDouble())
                              ],
                              isStepLineChart: false,
                              isCurved: true,
                              dotData: FlDotData(show: false),
                              color: secondColor),
                          LineChartBarData(
                              spots: myMap,
                              isCurved: false,
                              dotData: FlDotData(show: true),
                              color: Colors.orange),
                        ],
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            axisNameWidget: const Text(
                              'kgCO2e',
                              style: TextStyle(height: -0.5),
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        )),
                    swapAnimationDuration: const Duration(milliseconds: 550),
                  ),
                ),
              );
            }
          } else {
            return const LoadBar();
          }
        });
  }
}
