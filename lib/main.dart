import 'package:club/modules/club_module.dart';
import 'package:club/modules/reservation_module.dart';
import 'package:club/modules/user_module.dart';
import 'package:club/task.dart';
// import 'package:club/ui/clubs_display_page.dart';
import 'package:club/ui/clubs_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main(){
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (context) => ClubModule()),
        ChangeNotifierProvider(builder: (context) => UserModule()),
        ChangeNotifierProvider(builder: (context) => ReservationModule()),
      ],
      child: ClubsManager(),
    ),
  ));
}

