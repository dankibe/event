import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club/modals/club_modal.dart';
import 'package:club/modals/preoder_modal.dart';
import 'package:club/modals/product_modal.dart';
import 'package:club/modals/reservation_modal.dart';
import 'package:club/modals/table_modal.dart';
import 'package:club/modules/club_module.dart';
import 'package:club/modules/reservation_module.dart';
import 'package:club/modules/user_module.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class Task extends StatefulWidget {
  @override
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<Task> {

  List<ProductModal> _productsRezzy = [
    ProductModal(id:'1', name: 'drink 1', price: 200),
    ProductModal(id:'2', name: 'drink 2', price: 340),
    ProductModal(id:'3', name: 'drink 3', price: 600),
    ProductModal(id:'4', name: 'drink 4', price: 800),
    ProductModal(id:'5', name: 'drink 5', price: 1000),
  ];



  ClubModal _addClub(){
    return ClubModal(
      id: '1',
      name: 'new',
      image: 'https://images.freeimages.com/images/small-previews/280/clubbing-in-london-1-1519219.jpg',
      position: LatLng(-1.290500, 36.823028),
      locationLabel: "Koinange St, Nairobi",
      tables: [
        TableModal(id: '1', maxNoChairs: 6, minNoChairs: 3, reserveCostPerChair: 50),
        TableModal(id: '2', maxNoChairs: 4, minNoChairs: 2, reserveCostPerChair: 50),
        TableModal(id: '3', maxNoChairs: 2, reserveCostPerChair: 50),
        TableModal(id: '4', maxNoChairs: 4, minNoChairs: 2, reserveCostPerChair: 50),
      ],
      products: _productsRezzy,
    );
  }

  ReservationModal _addReservation(_userModule, _clubModule){
    return ReservationModal(
      user: _userModule.users[0],
      club: _clubModule.clubs[0].ref,
      table: _clubModule.clubs[0].tables[2],
      noChairs: 2,
      dateTimeBooked: DateTime.now(),
      reserveDateTime: DateTime(2019, 9),
      preoderModal:  PreoderModal(
        id: '1',
        orderItems: [
          OderItemModal(product: _clubModule.clubs[0].products[0], quantity: 2),
          OderItemModal(product: _clubModule.clubs[0].products[2], quantity: 1),
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////////////////////
    /// Getting backend
    final clubModule = Provider.of<ClubModule>(context);
    final userModule = Provider.of<UserModule>(context);
    final reservationModule = Provider.of<ReservationModule>(context);

    List<ClubModal> _clubs = clubModule.clubs;
    Set<Marker> _makers = clubModule.markers;
    List<ReservationModal> _reservation = reservationModule.reservations;


    List<Widget> _markersHolder(){
      List<Widget> lst=[];
      _makers.forEach((item){
        lst.add(
          ListTile(
            title: Text(item.markerId.toString()),
            subtitle: Text(item.position.toString()),
          )
        );
      });
      return lst;
    }

    List<Widget> _clubsHolder(List<ClubModal> clubz){
      List<Widget> lst=[];
      clubz.forEach((ClubModal item){
        lst.add(
          ListTile(
            onTap: (){
              clubModule.deleteClub = item.id;
            },
            leading: Image.network(item.image),
            title: Text(item.name.toString()),
            subtitle: Text(item.position.toString()),
          )
        );
      });
      return lst;
    }

    List<Widget> _reservationHolder(List<ReservationModal> res){
      List<Widget> lst=[];
      res.forEach((item){
        lst.add(
          Card(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('User'),
                    Text(item.user.username.toString()),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('club'),
                    Text(item.club.documentID.toString()),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('state'),
                    Text(item.state.toString()),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('tabel'),
                    Text(item.table.id.toString()),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('No. chairs'),
                    Text(item.noChairs.toString()),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Date'),
                    Text(item.reserveDateTime.toString()),
                  ],
                ),
              ],
            )
          )
        );
      });
      return lst;
    }


    return Scaffold(
      drawer: Drawer(
        child: Container(),
      ),
      body: ListView(
        children: <Widget>[
          // List of Map markers
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('List of Map Markers', style: TextStyle(fontSize: 25),),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: _markersHolder(),
              ),

            ],
          ),

          // List of clubs
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('List of Clubs', style: TextStyle(fontSize: 25),),
                  RaisedButton(
                    child: Text("Add"),
                    onPressed: () {
                      clubModule.addClub = _addClub();
                    },
                  ),
                ],
              ),
              StreamBuilder(
                stream: Firestore.instance.collection('clubs').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Text('Fetching.......');
                      break;
                    case ConnectionState.none:
                      return Text('Check your connection');
                      break;
                    default:
                    
                    return Column(mainAxisSize: MainAxisSize.min, children: _clubsHolder(clubModule.convertToClubModal(snapshot.data.documents)),);
                  }
                  
                },
              ),
              
            ],
          ),

          // List of reservation
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('List of Reservations', style: TextStyle(fontSize: 25),),
                  RaisedButton(
                    child: Text("Add"),
                    onPressed: () {
                      reservationModule.addReservation = _addReservation(userModule ,clubModule);
                    },
                  ),
                ],
              ),
              
              StreamBuilder(
                stream: Firestore.instance.collection('reservations').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                  
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Text('Fetching.......');
                      break;
                      case ConnectionState.none:
                      return Container();
                      break;
                    default:
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: _reservationHolder(reservationModule.convertToReservationModal(snapshot.data.documents)),
                      );
                  }
                  
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}