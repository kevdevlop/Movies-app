import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movies/src/models/movie_model.dart';


class CardSwipper extends StatelessWidget {
  final List<Movie> items;

  CardSwipper({@required this.items});

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: new Swiper(
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.5,
        itemBuilder: (BuildContext context, int index) {

          items[index].uId = '${items[index].id}-card'; //Setting uniq id to id duplicated error

          return Hero(
            tag: items[index].uId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(items[index].getPosterImg()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
        itemCount: items.length,
        layout: SwiperLayout.STACK,
        onTap: (index) {
          Navigator.pushNamed(context, "movie_detail", arguments: items[index]);
        },
      ),
    );
  }
}