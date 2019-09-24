import 'dart:io';

import 'package:club/modals/club_modal.dart';
import 'package:club/modals/event_model.dart';
import 'package:club/modules/club_module.dart';
import 'package:club/modules/event_module.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:provider/provider.dart';

class EventCreate extends StatefulWidget {
  final String clubId;
  EventCreate({this.clubId});
  
  @override
  _EventCreateState createState() => _EventCreateState();
}

class _EventCreateState extends State<EventCreate> {

  TextEditingController _eventTitleController = TextEditingController();
  TextEditingController _eventDescriptionController = TextEditingController();
  DateTime _date = DateTime(2020);
  File _imageChoosen;


  @override
  Widget build(BuildContext context) {
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<EventModule>(builder: (context) => EventModule()),
        ChangeNotifierProvider<ClubModule>(builder: (context) => ClubModule()),
      ],
      child: Consumer<EventModule>(
        builder: (context, eventModule, _){
          return KeyboardAvoider(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // name
                  TextField(
                    controller: _eventTitleController,
                    decoration: InputDecoration(
                      labelText: 'Event Title:'
                    ),
                  ),

                  
                  

                  // location label
                  TextField(
                    controller: _eventDescriptionController,
                    decoration: InputDecoration(
                      labelText: 'Event Description:'
                    ),
                  ),

                  // TODO: pick date


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
                      eventModule.uploadImage(_imageChoosen).then((url){

                        ClubModule _clubModule = Provider.of<ClubModule>(context);
                      
                        Future<ClubModal> _clubFuture = _clubModule.futureClub(widget.clubId);

                        _clubFuture.then((_club){
                          EventModel _newEvent = EventModel(
                            title: _eventTitleController.text,
                            description: _eventDescriptionController.text,
                            date: _date,
                            image: url,
                            club: _club.ref
                          );

                          eventModule.addEvent = _newEvent;
                        });

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