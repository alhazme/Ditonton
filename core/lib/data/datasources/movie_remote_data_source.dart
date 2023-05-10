import 'dart:convert';
import 'package:core/data/models/movie_detail_response.dart';
import 'package:core/data/models/movie_model.dart';
import 'package:core/data/models/movie_response.dart';
import 'package:core/utils/exception.dart';
import 'package:http/io_client.dart';

import '../../utils/constants.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getNowPlayingMovies();
  Future<List<MovieModel>> getPopularMovies();
  Future<List<MovieModel>> getTopRatedMovies();
  Future<MovieDetailResponse> getMovieDetail(int id);
  Future<List<MovieModel>> getMovieRecommendations(int id);
  Future<List<MovieModel>> searchMovies(String query);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {

	final IOClient ioClient;
  // final http.Client client;
  // final SslPinningHelper sslPinningHelper;

  // MovieRemoteDataSourceImpl({required this.ioClient, required this.sslPinningHelper});
	MovieRemoteDataSourceImpl({
		required this.ioClient
	});

  @override
  Future<List<MovieModel>> getNowPlayingMovies() async {
		final response = await ioClient.get(
				Uri.parse('$baseURL/movie/now_playing?$apiKey'));

		if (response.statusCode == 200) {
			return MovieResponse
					.fromJson(json.decode(response.body))
					.movieList;
		} else {
			throw ServerException();
		}
  }

  @override
  Future<MovieDetailResponse> getMovieDetail(int id) async {
    final response =
    await ioClient.get(Uri.parse('$baseURL/movie/$id?$apiKey'));

    if (response.statusCode == 200) {
      return MovieDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> getMovieRecommendations(int id) async {
    final response = await ioClient
        .get(Uri.parse('$baseURL/movie/$id/recommendations?$apiKey'));

    if (response.statusCode == 200) {
      return MovieResponse
          .fromJson(json.decode(response.body))
          .movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    final response =
    await ioClient.get(Uri.parse('$baseURL/movie/popular?$apiKey'));

    if (response.statusCode == 200) {
      return MovieResponse
          .fromJson(json.decode(response.body))
          .movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies() async {
    final response =
    await ioClient.get(Uri.parse('$baseURL/movie/top_rated?$apiKey'));

    if (response.statusCode == 200) {
      return MovieResponse
          .fromJson(json.decode(response.body))
          .movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    final response = await ioClient
        .get(Uri.parse('$baseURL/search/movie?$apiKey&query=$query'));

    if (response.statusCode == 200) {
      return MovieResponse
          .fromJson(json.decode(response.body))
          .movieList;
    } else {
      throw ServerException();
    }
  }

  // Future<bool> _isSecure(String url, HttpMethod httpMethod) async {
  //   return await sslPinningHelper.isSecure(url, httpMethod);
  // }

}
