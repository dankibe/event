
import 'package:club/modules/club_module.dart';
import 'package:club/ui/toremove/club_item_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ClubsGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ClubModule>(
      builder: (context, clubModule, _){
        return Container(
          margin: EdgeInsets.only(top: 30),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          width: double.infinity,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: .8,
            ),
            scrollDirection: Axis.vertical,
            itemCount: clubModule.clubsCount,
            itemBuilder: (BuildContext context, int index){
              return new ClubItemCard(clubKey: clubModule.clubs[index].key,);
            },
          ),
    
        );
      }
    );
  }
}

