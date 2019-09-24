import 'dart:async';
import 'package:club/modules/club_module.dart';
import 'package:club/modules/user_module.dart';
import 'package:club/ui/toremove/clubs_gridview.dart';
import 'package:club/utils/openable_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class ClubsDisplayPage extends StatefulWidget {
  @override
  _ClubsDisplayPageState createState() => _ClubsDisplayPageState();
}

class _ClubsDisplayPageState extends State<ClubsDisplayPage> with SingleTickerProviderStateMixin {

  OpenableController _clubsOpenableController;

  Completer<GoogleMapController> _mapController = Completer();

  static const LatLng _mapCenter = const LatLng(-1.290500, 36.823028);

  void _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
  }

 

  @override
  void initState() {
    super.initState();
    _clubsOpenableController = OpenableController(
      vsync: this,
      openDuration: const Duration(milliseconds: 300),
    )..addListener(()=> setState((){}));
  }

  @override
  void dispose() {
    _clubsOpenableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
              providers: [
                ChangeNotifierProvider(builder: (context) => ClubModule()),
                ChangeNotifierProvider(builder: (context) => UserModule()),
              ],   
      child: Material(
        child: Consumer<ClubModule>(
          builder: (context, clubModule, _){
            return  Stack(
              children: <Widget>[
                // Map
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    color: Colors.black26,
                    height: MediaQuery.of(context).size.height*.9,
                    child: GoogleMap(
                      mapType: MapType.normal,
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(target: _mapCenter, zoom: 11),
                      markers: clubModule.markers,
                    ),
                  ),
                ),
                // list container
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Transform(
                    transform: Matrix4.translationValues(
                      0, 
                      MediaQuery.of(context).size.height*.65 * (_clubsOpenableController.percentOpen), 
                      0
                    ),
                    child: ClipPath(
                      clipper: ClubListViewClipper(),
                      child: Container(
                        color: Colors.white,
                        height: MediaQuery.of(context).size.height*.85,
                        child: Stack(
                          children: <Widget>[
                            // notch bar
                            Container(
                              color: Color.fromRGBO(135, 140, 255, 1),
                              height: 30,
                            ),
                            Positioned(
                              top: -7,
                              left: MediaQuery.of(context).size.width/2-21,
                              child: InkWell(
                                onTap: (){
                                  _clubsOpenableController.isOpen() ?
                                  _clubsOpenableController.close() :
                                  _clubsOpenableController.open();
                                },
                                child: Icon(
                                  _clubsOpenableController.isOpen() ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                  color: Colors.white, size: 43,
                                ),
                              ),
                            ),

                            // List
                            ClubsGridView(),
                            
                          ],
                        )
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        ),      
      ),
    );
  }
}


class ClubListViewClipper extends CustomClipper<Path>{

  double clipsize = 20;
  double notchHeight = 20;
  @override
  Path getClip(Size size) {
    double width = size.width;
    double height = size.height;


    Path path = Path();

    path.moveTo(0, clipsize+notchHeight);
    path.lineTo(clipsize, notchHeight);

    // notch circular
    // path.lineTo(width/2-30, notchHeight);
    // path.quadraticBezierTo(width/2, -15, width/2+30, notchHeight);

    // notch boxy
    path.lineTo(width/2-30, notchHeight);
    path.lineTo(width/2-13, 0);
    path.lineTo(width/2+13, 0);
    path.lineTo(width/2+30, notchHeight);



    path.lineTo(width-clipsize, notchHeight);
    path.lineTo(width, clipsize+notchHeight);
    path.lineTo(width, height);
    path.lineTo(0, height);

    path.close();



    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
