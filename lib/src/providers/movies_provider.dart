import 'dart:async';
import 'dart:convert';

import 'package:movies/src/models/actors_model.dart';
import 'package:movies/src/models/movie_model.dart';
import 'package:http/http.dart' as http;

class MoviesProvider {
  String _apikey = '6c34759e07de8f26cb52f8a5b6305376';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _pupolaresPage = 0;
  bool _chargingData = false;

  List<Movie> _populares = new List();
  
  final _popularesStreamController = StreamController<List<Movie>>.broadcast();
  Function(List<Movie>) get popularesSink => _popularesStreamController.sink.add;
  Stream <List<Movie>> get popularesStream => _popularesStreamController.stream;

  void disposeStreams() {
    _popularesStreamController?.close();
  }

  Future<List<Movie>> getNowPlaying() async{
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apikey,
      'language': _language
    });

    return await processRequest(url);
  }

  Future<List<Movie>> getPopular() async {

    if (_chargingData) return [];

    _chargingData = true;
    _pupolaresPage++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key':  _apikey,
      'language': _language,
      'page'  : _pupolaresPage.toString()
    });

    final resp = await processRequest(url);
    _populares.addAll(resp);
    popularesSink(_populares);

    _chargingData = false;

    return resp;
  }

  Future<List<Movie>> searchMovies(String query) async{
    final url = Uri.https(_url, '3/search/movie', {
      'api_key'   : _apikey,
      'language'  : _language,
      'query'     : query,
    });

    return await processRequest(url);
  }

  Future<List<Actor>> getCast(String movieId) async{
    final url = Uri.https(_url, '3/movie/$movieId/credits', {
      'api_key': _apikey,
      'language': _language
    });

    final response = await http.get(url);
    final decodedData =  json.decode(response.body);

    final cast = new Cast.fromJsonList(decodedData['cast']);

    return cast.actors;
  }

  Future<List<Movie>> processRequest(Uri url) async{
    final response = await http.get(url);
    final decodedData = json.decode(response.body);

    final movies = new Movies.fromJsonList(decodedData['results']);

    return movies.items;
  }
}