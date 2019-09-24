import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club/modals/club_modal.dart';
import 'package:club/modals/event_model.dart';
import 'package:club/modals/product_modal.dart';
import 'package:club/modals/reservation_modal.dart';
import 'package:club/modals/table_modal.dart';
import 'package:club/modules/club_module.dart';
import 'package:club/modules/event_module.dart';
import 'package:club/modules/reservation_module.dart';
import 'package:club/ui/create_event.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ClubDetail extends StatefulWidget {
  final String clubId;
  ClubDetail({this.clubId});

  @override
  _ClubDetailState createState() => _ClubDetailState();
}

class _ClubDetailState extends State<ClubDetail> with SingleTickerProviderStateMixin{


  // ClubModal _club = ClubModal(name: '', position: LatLng(0,0), locationLabel: '');
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (context) => ClubModule(),),
        ChangeNotifierProvider(builder: (context) => ReservationModule(),),
      ],
      child: Consumer<ClubModule>(
        builder: (context, clubModule, _){
          ClubModal _club = clubModule.getClub(widget.clubId);
         
          return Scaffold(
            appBar: AppBar(
              title: Text(_club.name),
              bottom: TabBar(
                controller: _tabController,
                tabs: <Widget>[
                  // Tab(text: 'Tables',),
                  // Tab(text: 'Products',),
                  Tab(text: 'sales',),
                ],
              ),
            ),
            drawer: clubDetailDrawer(context, widget.clubId),
            // body: ClubReservations(widget.clubId),
            body: TabBarView(
              controller: _tabController,
              children: <Widget>[
                // ClubTables(widget.clubId),
                // ClubProducts(widget.clubId),
                ClubReservations(widget.clubId),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ClubTables extends StatefulWidget {
  final String clubId;
  ClubTables(this.clubId);

  @override
  _ClubTablesState createState() => _ClubTablesState();
}

class _ClubTablesState extends State<ClubTables> {
  TextEditingController _labelController;

  TextEditingController _maxNoChairsController;

  TextEditingController _minNoChairsController;

  TextEditingController _reserveCostPerChairController;

  List<TableModal> _tables =[];

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController();
    _maxNoChairsController = TextEditingController();
    _minNoChairsController = TextEditingController();
    _reserveCostPerChairController = TextEditingController();
  }

  @override
  void dispose() {
    _labelController.dispose();
    _maxNoChairsController.dispose();
    _minNoChairsController.dispose();
    _reserveCostPerChairController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => ClubModule(),
      child: Consumer<ClubModule>(
        builder: (context, clubModule, _){
          ClubModal _club = clubModule.getClub(widget.clubId);
            _tables= _club.tables;
          return Scaffold(
          appBar: AppBar(title: Text("Tickets"),),
          drawer: clubDetailDrawer(context, widget.clubId),
          floatingActionButton: CircleAvatar(
            child: IconButton(
              onPressed: (){
                showModalBottomSheet(
                  context: context,
                  builder: (context){
                    return Column(
                      children: <Widget>[
                        // label 
                        TextField(
                          controller: _labelController,
                          decoration: InputDecoration(labelText: 'Ticket Type'),
                        ),
                        // Max no chairs 
                        TextField(
                          controller: _maxNoChairsController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText:  'No. of Tickets'),
                        ),
                        // Max no chairs 

                        TextField(
                          controller: _reserveCostPerChairController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: 'Ticket cost'),
                        ),
                        SizedBox(height: 15,),
                        RaisedButton(
                          child: Text('create'),
                          onPressed: (){
                            Navigator.pop(context);
                            TableModal _newTable = TableModal(
                              label: _labelController.text,
                              maxNoChairs: int.parse(_maxNoChairsController.text),
                              minNoChairs: int.parse(_minNoChairsController.text),
                              reserveCostPerChair: double.parse(_reserveCostPerChairController.text),
                            );
                            _tables.add(_newTable);
                            clubModule.updateTables(clubId: widget.clubId, tables: _tables);
                            
                          },
                        ),
                      ],
                    );
                  }
                );
              },
              icon: Icon(Icons.add),
            ),
          ),  

          ////////////////
          body: ListView.builder(
            itemCount: _tables.length,
            itemBuilder: (BuildContext context, int index){
              Row _row({String key, String value}){
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(key),
                    Text(value),
                  ],
                );
              }
              return Card(
                child: Column(
                  children: <Widget>[
                    _row(key: 'Ticket type:', value: _tables[index].label.toString()),
                    _row(key: ' No. of Tickets', value: _tables[index].maxNoChairs.toString()),
                    _row(key: 'Ticket cost (Ksh.)', value: _tables[index].reserveCostPerChair.toString()),
                  ],
                ),
              );
            },
          )  
        );
       }
      ),
    );
  }
}

class ClubProducts extends StatefulWidget {
  final String clubId;
  ClubProducts(this.clubId);

  @override
  _ClubProductsState createState() => _ClubProductsState();
}

class _ClubProductsState extends State<ClubProducts> {
  TextEditingController _nameController;

  TextEditingController _priceController;

  List<ProductModal> _products =[];

  File _imageChoosen;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _priceController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => ClubModule(),
      child: Consumer<ClubModule>(
        builder: (context, clubModule, _){
          ClubModal _club = clubModule.getClub(widget.clubId);
                _products= _club.products;
            
          return Scaffold(
            appBar: AppBar(title: Text("Company Docs"),),
            drawer: clubDetailDrawer(context, widget.clubId),
            floatingActionButton: CircleAvatar(
              child: IconButton(
                onPressed: (){
                  showModalBottomSheet(
                    context: context,
                    builder: (context){
                      return Column(
                        children: <Widget>[
                          // name 
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(labelText: 'Company Name'),
                          ),
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(labelText: 'Company location'),
                          ),
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(labelText: 'Company email'),
                          ),
                          // price 
                          TextField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: 'Company Phone number'),
                          ),
                          SizedBox(height: 15,),

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
                                child: Text("Company certificate"),
                              ),
                              SizedBox(width: 10,),
                              _imageChoosen == null ? Container() : Image.file(_imageChoosen, height: 150,),
                            ],
                          ),
                          
                          MaterialButton(
                          color: Colors.blue,
                          minWidth: 300,
                            child: Text('create'),
                            onPressed: (){
                              Navigator.pop(context);
                              clubModule.uploadImage(_imageChoosen).then((url){
                                ProductModal _newProduct = ProductModal(
                                  name: _nameController.text,
                                  price: double.parse(_priceController.text),
                                  image: url,
                                );
                                _products.add(_newProduct);
                                clubModule.updateProducts(clubId: widget.clubId, products: _products);

                              });
                              
                            },
                          ),
                        ],
                      );
                    }
                  );
                },
                icon: Icon(Icons.add),
              ),
            ),  

          ////////////////
          body: GridView.builder(
            gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: _products.length,
            itemBuilder: (BuildContext context, int index){
              return SizedBox(
                  height: 170,
                  width: 170,
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // product image
                        Expanded(
                          child: _products[index].image == null ? Container() : Image.network(_products[index].image,  fit: BoxFit.cover,),
                        ),
                        // name
                        Text(_products[index].name.toString()),
                        // price
                        Text(_products[index].price.toString()),
                      ],
                    ),
                  ),
                );
            },
          )  
        );
       }
      ),
    );
  }
}

class ClubGallery extends StatefulWidget {
  final String clubId;
  ClubGallery(this.clubId);

  @override
  _ClubGalleryState createState() => _ClubGalleryState();
}

class _ClubGalleryState extends State<ClubGallery> {

  File _imageChoosen;

  List<String> _gallery;


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => ClubModule(),
      child: Consumer<ClubModule>(
        builder: (context, clubModule, _){
          ClubModal _club = clubModule.getClub(widget.clubId);
          _club.gallery == null ? _gallery = <String>[] : _gallery = _club.gallery;
            
          return Scaffold(
            appBar: AppBar(title: Text("Posters"),),
            drawer: clubDetailDrawer(context, widget.clubId),
            floatingActionButton: CircleAvatar(
              child: IconButton(
                onPressed: (){
                  showModalBottomSheet(
                    context: context,
                    builder: (context){
                      return Column(
                        children: <Widget>[
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
                          
                          MaterialButton(
                          color: Colors.blue,
                          minWidth: 300,
                            child: Text('create'),
                            onPressed: (){
                              Navigator.pop(context);
                              clubModule.uploadImage(_imageChoosen).then((url){
                                _gallery.add(url);
                                clubModule.updateGallery(gallery: _gallery, clubId: widget.clubId);
                              });
                              
                            },
                          ),
                        ],
                      );
                    }
                  );
                },
                icon: Icon(Icons.add),
              ),
            ),  

          ////////////////
          body: GridView.builder(
            gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: _gallery.length,
            itemBuilder: (BuildContext context, int index){
              return SizedBox(
                  height: 170,
                  width: 170,
                  child: Card(
                    child: _gallery[index] == null ? Container() : Image.network(_gallery[index],  fit: BoxFit.cover,),
                        
                  ),
                );
            },
          )  
        );
       }
      ),
    );
  }
}

class ClubReservations extends StatefulWidget {
  final String clubId;

  ClubReservations(this.clubId);
  @override
  _ClubReservationsState createState() => _ClubReservationsState();
}

class _ClubReservationsState extends State<ClubReservations> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ReservationModule>(
      builder: (context, reservationModule, _){
        List<ReservationModal> _reservations = reservationModule.currenClubReservation(widget.clubId);

        return ListView.builder(
          itemCount: _reservations.length,
          itemBuilder: (BuildContext context, int index){
            Row _row(key, value){
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(key.toString()),
                  Text(value.toString()),
                ],
              );
            }
            return Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _row('User', _reservations[index].user.username),
                  _row('DateBooked', _reservations[index].dateTimeBooked),
                  _row('ResercationDate', _reservations[index].reserveDateTime),
                  _row('Table', _reservations[index].table.label),
                  _row('No. of Chairs', _reservations[index].noChairs),
                ],
              ),
            );
          },
        );
      },
    );
  }
}


class ClubEvents extends StatefulWidget {
  final String clubId;

  ClubEvents(this.clubId);
  @override
  _ClubEventsState createState() => _ClubEventsState();
}

class _ClubEventsState extends State<ClubEvents> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => EventModule(),
      child: Consumer<EventModule>(
        builder: (context, eventsModule, _){
          List<EventModel> _events = eventsModule.currenClubEvents(widget.clubId);

          return Scaffold(
            appBar: AppBar(title: Text('Events'),),
            drawer: clubDetailDrawer(context, widget.clubId),
            body: ListView.builder(
              itemCount: _events.length,
              itemBuilder: (BuildContext context, int index){
                Row _row(key, value){
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(key.toString()),
                      Text(value.toString()),
                    ],
                  );
                }
                return Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _row('Title', _events[index].title),
                      _row('venue', _events[index].club.toString()),
                      _row('date', _events[index].date.toString()),
                      _row('poster', _events[index].image.toString()),
                    ],
                  ),
                );
              },
            ),
            floatingActionButton: CircleAvatar(
                child: IconButton(
                  onPressed: (){
                    showModalBottomSheet(
                      context: context,
                      builder: (context){
                        return EventCreate(clubId: widget.clubId,);
                      }
                    );
                  },
                  icon: Icon(Icons.add),
                ),
              ),  
          );
        },
      ),
    );
  }
}

Drawer clubDetailDrawer (context, clubId,){
  return Drawer(
    child: Column(
      children: <Widget>[
        ListTile(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ClubProducts(clubId)));
          },
          title: Text('Company Docs'),
        ),
        Divider(),
        ListTile(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ClubTables(clubId)));
          },
          title: Text('Tickets'),
        ),
        Divider(),
        ListTile(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ClubEvents(clubId)));
          },
          title: Text('Events'),
        ),
        Divider(),
        ListTile(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ClubGallery(clubId)));
          },
          title: Text('Gallery'),
        ),
        Divider(),
      ],
    ),
  );
}