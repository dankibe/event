import 'package:club/modals/club_modal.dart';
import 'package:club/modules/club_module.dart';
import 'package:club/modules/reservation_module.dart';
import 'package:club/modules/user_module.dart';
import 'package:club/ui/toremove/add_reservation_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClubDetailPage extends StatelessWidget {
  final String clubKey;

  ClubDetailPage({
    this.clubKey
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (context) => ClubModule()),
        ChangeNotifierProvider(builder: (context) => UserModule()),
        ChangeNotifierProvider(builder: (context) => ReservationModule()),
      ],  
      child: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            // club Name and Image
            clubLabel(context),
            ClubDetailBody(clubKey:clubKey),
          ],
        ),
      ),
    );
  }

  Widget clubLabel(BuildContext context) {
    return Consumer<ClubModule>(
      builder: (context, clubModule, _){
      ClubModal _club = clubModule.getClub(clubKey);
      return Container(
        height: MediaQuery.of(context).size.height*.3,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          // fit: StackFit.expand,
          children: <Widget>[
            // Club image
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage(_club.image), fit: BoxFit.cover)
              ),
            ),

            // Club name
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(30))
                ),
                child: Text(
                  _club.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25
                  ),
                ),
              ),
            ),
          ],
        ),
      );
      }
    );
  }
}

class ClubDetailBody extends StatefulWidget {

  final String clubKey;

  ClubDetailBody({
    this.clubKey
  });


  @override
  _ClubDetailBodyState createState() => _ClubDetailBodyState();
}

class _ClubDetailBodyState extends State<ClubDetailBody> with SingleTickerProviderStateMixin {
  

  TabController _tabController;

  TextStyle tabTitleStyle(){
    return TextStyle(
      color: Colors.black
    );
  }

    @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height*.7,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          TabBar(
            controller: _tabController,
            tabs: <Widget>[
              Tab(child: Text("Reservation", style: tabTitleStyle(),),),
              Tab(child: Text("Reviews", style: tabTitleStyle(),),),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                // Add Reservation Tab
                AddReservationUI(clubKey: widget.clubKey),

                // Reviews Tab
                Container(child: Center(child: Text("Reviews"),),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}