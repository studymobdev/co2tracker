import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/models/myuser.dart';

class Database {
  final String? uid;
  Database({required this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference petCollection =
      FirebaseFirestore.instance.collection('pets');

  Future updUsersData(
      String? name,
      String? email,
      num? goal,
      String? petNickName,
      num? score,
      String? petTypeList,
      Object? waterHeight,
      Object? scoreProgress,
      Object? recommendationList,
      String? lastTimeCalculation,
      int? killCounter,
      Object? pickedOptions) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'email': email,
      'goal': goal,
      'petName': petNickName,
      'score': score,
      'petType': petTypeList,
      'waterHeight': waterHeight,
      'scoreProgress': scoreProgress,
      'recoList': recommendationList,
      'lastCalcTime': lastTimeCalculation,
      'killCount': killCounter,
      'pickedOptions': pickedOptions,
    });
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        name: snapshot.get('name'),
        email: snapshot.get('email'),
        goal: snapshot.get('goal'),
        petName: snapshot.get('petName'),
        score: snapshot.get('score'),
        petType: snapshot.get('petType'),
        waterHeight: snapshot.get('waterHeight'),
        scoreProgress: snapshot.get('scoreProgress'),
        recoList: snapshot.get('recoList'),
        lastCalcTime: snapshot.get('lastCalcTime'),
        killCount: snapshot.get('killCount'),
        chosenOptions: snapshot.get('pickedOptions'));
  }

  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
