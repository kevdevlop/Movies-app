import 'package:flutter/material.dart';

import 'package:movies/src/pages/home_page.dart';
import 'package:movies/src/pages/movie_detail_page.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Películas',
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      routes: {
        '/'               : (BuildContext context) => HomePage(),
        'movie_detail'    : (BuildContext context) => MovieDetailPage()
      },
    );
  }
}