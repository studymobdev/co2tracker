import "dart:math";
import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/home/homepage.dart';
import 'package:flutter_application_1/share/loadbar.dart';

class RankingsPage extends StatefulWidget {
  const RankingsPage({Key? key}) : super(key: key);

  @override
  State<RankingsPage> createState() => _RankingsPageState();
}

class _RankingsPageState extends State<RankingsPage> {
  var isDescending = false;
  var isKillsDescending = false;
  var allRankingData = [];
  var allKillsData = [];

  Future<void> getData() async {
    late final _collectRefer = FirebaseFirestore.instance
        .collection('users')
        .orderBy('score', descending: isDescending);
    QuerySnapshot _querySnapshot = await _collectRefer.get();
    setState(() {
      allRankingData = _querySnapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<void> getKillsData() async {
    late final _killcollectRef = FirebaseFirestore.instance
        .collection('users')
        .orderBy('killCount', descending: isKillsDescending);
    QuerySnapshot _querySnapshot = await _killcollectRef.get();
    setState(() {
      allKillsData = _querySnapshot.docs.map((doc) => doc.data()).toList();
      // print(allKillsData);
    });
  }

  var scoreText = "Score (kg${"CO\u2082e"})";
  var killsText = "Kills";

  @override
  void initState() {
    getData();
    getKillsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (allRankingData != null && allKillsData != null) {
      return Scaffold(
          backgroundColor: firstColor,
          appBar: AppBar(
            title: Text('Rankings', style: TextStyle(color: Colors.white)),
            centerTitle: true,
            backgroundColor: firstColor,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  color: secondColor,
                  elevation: 10,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: firstColor),
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'User Name',
                                style: TextStyle(color: secondColor),
                              ),
                              InkWell(
                                  child: Text(scoreText,
                                      style: TextStyle(color: secondColor)),
                                  onTap: (() {
                                    setState(() {
                                      isDescending = !isDescending;
                                      isDescending
                                          ? scoreText =
                                              "Score (kg${"CO\u2082e"}) ⬇"
                                          : scoreText =
                                              "Score (kg${"CO\u2082e"}) ⬆";
                                      // print(isDescending);
                                      getData();
                                    });
                                  }))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(9, 0, 9, 0),
                          child: Column(
                            children: [
                              for (var r = 0;
                                  r < allRankingData.length;
                                  r++) ...[
                                if (allRankingData[r]['score'] != 0) ...[
                                  if (allRankingData[r]['name'] ==
                                      username) ...[
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            allRankingData[r]['name'],
                                            style: TextStyle(
                                                color: Colors.orange,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            allRankingData[r]['score']
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.orange,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ]),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ] else ...[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(allRankingData[r]['name']),
                                        Text(allRankingData[r]['score']
                                            .toStringAsFixed(2))
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ]
                                ]
                              ]
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                Card(
                  color: secondColor,
                  elevation: 10,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Color.fromARGB(200, 22, 99, 227),
                              ),
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'User Name',
                                style: TextStyle(color: secondColor),
                              ),
                              InkWell(
                                  child: Text(killsText,
                                      style: TextStyle(color: secondColor)),
                                  onTap: (() {
                                    setState(() {
                                      isKillsDescending = !isKillsDescending;
                                      isKillsDescending
                                          ? killsText = "Kills ⬇"
                                          : killsText = "Kills ⬆";
                                      print(isKillsDescending);
                                      getKillsData();
                                    });
                                  }))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Column(
                            children: [
                              for (var r = 0; r < allKillsData.length; r++) ...[
                                if (allKillsData[r]['name'] == username) ...[
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          allKillsData[r]['name'],
                                          style: TextStyle(
                                              color: Colors.orange,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          allKillsData[r]['killCount']
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.orange,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ]),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ] else ...[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(allKillsData[r]['name']),
                                      Text(allKillsData[r]['killCount']
                                          .toString())
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ]
                                // ]
                              ]
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ));
    } else {
      return LoadBar();
    }
  }
}
