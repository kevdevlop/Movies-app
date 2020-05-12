import 'package:flutter/material.dart';
import 'package:movies/src/models/movie_model.dart';

class MoviesHorizontalWidget extends StatelessWidget {
  final List<Movie> movies;
  final Function nextPage;

  MoviesHorizontalWidget({@required this.movies, @required this.nextPage});

  final pageController = new PageController(
    initialPage: 1,
    viewportFraction: 0.3
  );

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    pageController.addListener( () {
      if (pageController.position.pixels >= pageController.position.maxScrollExtent - 200) {
        //Cargar siguientes resultados
        nextPage();
      }
    });

    return Container(
      height: _screenSize.height * 0.25,
      child: PageView.builder(
        pageSnapping: false,
        controller: pageController,
        itemCount: movies.length,
        itemBuilder: (context, index) => card(context, movies[index]),
      ),
    );
  }

  Widget card(BuildContext context, Movie movie) {
    movie.uId = '${movie.id}-poster';

    final cardMovie = Container(
      margin: EdgeInsets.only(right: 10.0),
      child: Column(
        children: <Widget>[
          Hero(
            tag: movie.uId ,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(movie.getPosterImg()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 140,
              ),
            ),
          ),
          SizedBox(height: 5.0,),
          Text(
            movie.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );

    return GestureDetector(
      child: cardMovie,
      onTap: () {
        Navigator.pushNamed(context, "movie_detail", arguments: movie);
      },
    );
  }
}