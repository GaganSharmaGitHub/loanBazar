import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:loan_bazaar/firebase/dbtools.dart';
import 'package:loan_bazaar/models/banner.dart' as b;
import 'package:url_launcher/url_launcher.dart';

class BannerCarousel extends StatelessWidget {
  const BannerCarousel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<b.Banner>>(
        stream: DBtools().bannerstream(),
        builder: (context, snapshot) {
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          }
          return CarouselSlider(
            options: CarouselOptions(
                height: 200.0, autoPlay: true, enlargeCenterPage: true),
            items: snapshot.data.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  _launchURL() async {
                    try {
                      var url = i.link;
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    } catch (e) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('$e'),
                      ));
                    }
                  }

                  return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: InkWell(
                        onTap: _launchURL,
                        child: Image.network(
                          '${i.image}',
                        ),
                      ));
                },
              );
            }).toList(),
          );
        });
  }
}
