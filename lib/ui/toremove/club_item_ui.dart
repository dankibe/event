
import 'package:club/modals/club_modal.dart';
import 'package:club/modules/club_module.dart';
import 'package:club/ui/toremove/club_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClubItemCard extends StatelessWidget {

  final String clubKey;

  ClubItemCard({
    this.clubKey,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ClubModule>(
      builder: (context, clubModule, _){
        ClubModal _club = clubModule.getClub(clubKey);
        return InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> ClubDetailPage(clubKey: clubKey)));
          },
          child: Card(
            color: Color.fromRGBO(218, 219, 255, 1),
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                      image: DecorationImage(image: AssetImage(_club.image), fit: BoxFit.cover)
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: EdgeInsets.only(right: 4),
                            child: Center(child: Text(_club.name)),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(4.1.toString()),
                              Text(
                                _club.locationLabel,
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                                textAlign: TextAlign.end,
                              ),
                              Text(
                                "2 Km way",
                                style: TextStyle(
                                  fontSize: 11
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )

              ],
            )
          ),
        );
      }
    );
  }
}