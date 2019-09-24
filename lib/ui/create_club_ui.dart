import 'dart:io';

import 'package:club/modals/club_modal.dart';
import 'package:club/modules/club_module.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:provider/provider.dart';

class ClubCreate extends StatefulWidget {
  @override
  _ClubCreateState createState() => _ClubCreateState();
}

class _ClubCreateState extends State<ClubCreate> {
  Geolocator _geolocator = Geolocator();

  Position _userLocation;

  TextEditingController _clubNameController = TextEditingController();
  TextEditingController _clubLocationLabelController = TextEditingController();
  TextEditingController _clubLatitudeController = TextEditingController();
  TextEditingController _clubLongitudeController = TextEditingController();
  File _imageChoosen;


  @override
  Widget build(BuildContext context) {
    
    return ChangeNotifierProvider<ClubModule>(
      builder: (context) => ClubModule(),
      child: Consumer<ClubModule>(
        builder: (context, clubModule, _){
          return KeyboardAvoider(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // name
                  TextField(
                    controller: _clubNameController,
                    decoration: InputDecoration(
                      labelText: 'Club Name:'
                    ),
                  ),

                  
                  

                  // location label
                  TextField(
                    controller: _clubLocationLabelController,
                    decoration: InputDecoration(
                      labelText: 'Position Label:'
                    ),
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            // position latitude
                            TextField(
                              controller: _clubLatitudeController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Position Latitude:'
                              ),
                            ),

                            // position latitude
                            TextField(
                              controller: _clubLongitudeController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Position Longitude:'
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10,),
                      MaterialButton(
                        height: 90,
                        color: Colors.grey,
                        onPressed: (){
                          _geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((position){
                            setState(() {
                              _clubLatitudeController.text = position.latitude.toString();  
                              _clubLongitudeController.text = position.longitude.toString();
                            });
                          });
                        },
                        child: Text('Pick\ncurrent location', textAlign: TextAlign.center,),
                      ),
                    
                    ],
                  ),
                  SizedBox(height: 10,),

                  // image
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: (){
                          ImagePicker.pickImage(source: ImageSource.gallery).then((value){
                            setState(() {
                              _imageChoosen = value;
                            });
                          });
                        },
                        child: Text("Pick image"),
                      ),
                      SizedBox(width: 10,),
                      _imageChoosen == null ? Container() : Image.file(_imageChoosen, height: 150,),
                    ],
                  ),

                  SizedBox(height: 12,),
                  MaterialButton(
                    color: Colors.blue,
                    minWidth: 300,
                    child: Text("Create"),
                    onPressed: (){
                      
                      // 
                      // upload image first
                      clubModule.uploadImage(_imageChoosen).then((url){
                        ClubModal _newClub = ClubModal(
                          name: _clubNameController.text,
                          position: LatLng(double.parse(_clubLatitudeController.text), double.parse(_clubLongitudeController.text)),
                          locationLabel: _clubLocationLabelController.text,
                          image: url,
                        );

                        clubModule.createClub(_newClub);

                      });

                      Navigator.pop(context);

                    },
                  ),

                ],
              ),
            ),
          );
        },
      ),
    );
    
  }
}