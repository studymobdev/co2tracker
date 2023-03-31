import 'package:animations/animations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/home/homepage.dart';
import 'package:flutter_application_1/screens/mypet/mypet.dart';
import 'package:flutter_application_1/screens/news/news.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var aqi,pm2,co2,n02,o3,co;

  inter() async{
   final response = await http.get(Uri.parse('https://api.waqi.info/feed/geo:43.2220;76.8512/?token=18efe65c10b57597c3a29bcaf93ff42971fc6c78'));
   // print(response.body);

   Notes note = Notes.fromJson(jsonDecode(response.body));
   aqi = note.data?.aqi;
   pm2 = note.data?.iaqi?.pm25;
   co2 = note.data?.iaqi?.so2;
   n02 =note.data?.iaqi?.no2;
   o3 = 20;
   co = note.data?.iaqi?.co;
 }
  int currentIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    Home(),
    AirQuality(aqi: 60 , pM2_5: 57, sO2: 2.2 , nO2: 0.4, o3: 10, cO: 0.4, cityName: 'Almaty'),
    MyPetPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    String deviceToken = await getDeviceToken();
    print("#### PRINT DEVICE TOKEN ####");
    print(deviceToken);
    print("#############################");
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) {
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 19, 123, 180),
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
            FadeThroughTransition(
          fillColor: firstColor,
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        ),
        child: _widgetOptions.elementAt(currentIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(0, 35, 59, 37),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Color.fromARGB(238, 248, 240, 227),),
            label: 'Home',),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.location_city,
              color: Color.fromARGB(238, 248, 240, 227),
            ), label: 'Air Index',),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.pets,
              color: Color.fromARGB(238, 248, 240, 227),
            ),
            label: 'My Pet',
          ),
        ],
        unselectedItemColor: const Color.fromARGB(238, 248, 240, 227),
        unselectedLabelStyle: const TextStyle(color: Color.fromARGB(0, 35, 59, 37)),
        currentIndex: currentIndex,
        selectedItemColor: Colors.orange,
        onTap: _onItemTapped,
      ),
    );
  }

  Future getDeviceToken() async {
    FirebaseMessaging _firebaseMessage = FirebaseMessaging.instance;
    String? deviceToken = await _firebaseMessage.getToken();
    return (deviceToken == null) ? "" : deviceToken;
  }
}


class Notes {
  String? status;
  Data? data;

  Notes({this.status, this.data});

  Notes.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? aqi;
  int? idx;
  City? city;
  String? dominentpol;
  Iaqi? iaqi;
  Time? time;
  Debug? debug;

  Data(
      {this.aqi,
        this.idx,
        this.city,
        this.dominentpol,
        this.iaqi,
        this.time,
        this.debug});

  Data.fromJson(Map<String, dynamic> json) {
    aqi = json['aqi'];
    idx = json['idx'];

    city = json['city'] != null ? new City.fromJson(json['city']) : null;
    dominentpol = json['dominentpol'];
    iaqi = json['iaqi'] != null ? new Iaqi.fromJson(json['iaqi']) : null;
    time = json['time'] != null ? new Time.fromJson(json['time']) : null;
    debug = json['debug'] != null ? new Debug.fromJson(json['debug']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['aqi'] = this.aqi;
    data['idx'] = this.idx;
    if (this.city != null) {
      data['city'] = this.city!.toJson();
    }
    data['dominentpol'] = this.dominentpol;
    if (this.iaqi != null) {
      data['iaqi'] = this.iaqi!.toJson();
    }
    if (this.time != null) {
      data['time'] = this.time!.toJson();
    }
    if (this.debug != null) {
      data['debug'] = this.debug!.toJson();
    }
    return data;
  }
}


class City {
  List<double>? geo;
  String? name;
  String? url;
  String? location;

  City({this.geo, this.name, this.url, this.location});

  City.fromJson(Map<String, dynamic> json) {
    geo = json['geo'].cast<double>();
    name = json['name'];
    url = json['url'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['geo'] = this.geo;
    data['name'] = this.name;
    data['url'] = this.url;
    data['location'] = this.location;
    return data;
  }
}

class Iaqi {
  Co? co;
  Dew? dew;
  Dew? h;
  Co? no2;
  Dew? p;
  O3? pm25;
  Co? so2;
  Dew? t;
  Co? w;

  Iaqi(
      {this.co,
        this.dew,
        this.h,
        this.no2,
        this.p,
        this.pm25,
        this.so2,
        this.t,
        this.w});

  Iaqi.fromJson(Map<String, dynamic> json) {
    co = json['co'] != null ? new Co.fromJson(json['co']) : null;
    dew = json['dew'] != null ? new Dew.fromJson(json['dew']) : null;
    h = json['h'] != null ? new Dew.fromJson(json['h']) : null;
    no2 = json['no2'] != null ? new Co.fromJson(json['no2']) : null;
    p = json['p'] != null ? new Dew.fromJson(json['p']) : null;
    pm25 = json['pm25'] != null ? new O3.fromJson(json['pm25']) : null;
    so2 = json['so2'] != null ? new Co.fromJson(json['so2']) : null;
    t = json['t'] != null ? new Dew.fromJson(json['t']) : null;
    w = json['w'] != null ? new Co.fromJson(json['w']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.co != null) {
      data['co'] = this.co!.toJson();
    }
    if (this.dew != null) {
      data['dew'] = this.dew!.toJson();
    }
    if (this.h != null) {
      data['h'] = this.h!.toJson();
    }
    if (this.no2 != null) {
      data['no2'] = this.no2!.toJson();
    }
    if (this.p != null) {
      data['p'] = this.p!.toJson();
    }
    if (this.pm25 != null) {
      data['pm25'] = this.pm25!.toJson();
    }
    if (this.so2 != null) {
      data['so2'] = this.so2!.toJson();
    }
    if (this.t != null) {
      data['t'] = this.t!.toJson();
    }
    if (this.w != null) {
      data['w'] = this.w!.toJson();
    }
    return data;
  }
}

class Co {
  double? v;

  Co({this.v});

  Co.fromJson(Map<String, dynamic> json) {
    v = json['v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['v'] = this.v;
    return data;
  }
}

class Dew {
  int? v;

  Dew({this.v});

  Dew.fromJson(Map<String, dynamic> json) {
    v = json['v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['v'] = this.v;
    return data;
  }
}

class Time {
  String? s;
  String? tz;
  int? v;
  String? iso;

  Time({this.s, this.tz, this.v, this.iso});

  Time.fromJson(Map<String, dynamic> json) {
    s = json['s'];
    tz = json['tz'];
    v = json['v'];
    iso = json['iso'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['s'] = this.s;
    data['tz'] = this.tz;
    data['v'] = this.v;
    data['iso'] = this.iso;
    return data;
  }
}

class O3 {
  int? avg;
  String? day;
  int? max;
  int? min;

  O3({this.avg, this.day, this.max, this.min});

  O3.fromJson(Map<String, dynamic> json) {
    avg = json['avg'];
    day = json['day'];
    max = json['max'];
    min = json['min'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avg'] = this.avg;
    data['day'] = this.day;
    data['max'] = this.max;
    data['min'] = this.min;
    return data;
  }
}

class Debug {
  String? sync;

  Debug({this.sync});

  Debug.fromJson(Map<String, dynamic> json) {
    sync = json['sync'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sync'] = this.sync;
    return data;
  }
}
