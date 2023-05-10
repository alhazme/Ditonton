import 'dart:convert';
import 'package:core/utils/exception.dart';
import 'package:core/data/models/tv_detail_response.dart';
import 'package:core/data/models/tv_model.dart';
import 'package:core/data/models/tv_response.dart';
import 'package:http/io_client.dart';

import '../../utils/constants.dart';

abstract class TVRemoteDataSource {
  Future<List<TVModel>> getNowPlayingTVs();
  Future<List<TVModel>> getPopularTVs();
  Future<List<TVModel>> getTopRatedTVs();
  Future<TvDetailResponse> getTVDetail(int id);
  Future<List<TVModel>> getTVRecommendations(int id);
  Future<List<TVModel>> searchTVs(String query);
}

class TVRemoteDataSourceImpl implements TVRemoteDataSource {

	final IOClient ioClient;
  // final http.Client client;
  // final SslPinningHelper sslPinningHelper;

  // TVRemoteDataSourceImpl({required this.client, required this.sslPinningHelper});
	TVRemoteDataSourceImpl({
		required this.ioClient
	});

  @override
  Future<List<TVModel>> getNowPlayingTVs() async {
		final response = await ioClient.get(
				Uri.parse('$baseURL/tv/on_the_air?$apiKey'));

		if (response.statusCode == 200) {
			return TVResponse
					.fromJson(json.decode(response.body))
					.tvList;
		} else {
			throw ServerException();
		}
  }

  @override
  Future<List<TVModel>> getPopularTVs() async {
    final response = await ioClient.get(
        Uri.parse('$baseURL/tv/popular?$apiKey'));

    if (response.statusCode == 200) {
      return TVResponse
          .fromJson(json.decode(response.body))
          .tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TVModel>> getTopRatedTVs() async {
    final response = await ioClient.get(
        Uri.parse('$baseURL/tv/top_rated?$apiKey'));

    if (response.statusCode == 200) {
      return TVResponse
          .fromJson(json.decode(response.body))
          .tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvDetailResponse> getTVDetail(int id) async {
    final response =
    await ioClient.get(Uri.parse('$baseURL/tv/$id?$apiKey'));

    if (response.statusCode == 200) {
      return TvDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TVModel>> getTVRecommendations(int id) async {
    final response = await ioClient
        .get(Uri.parse('$baseURL/tv/$id/recommendations?$apiKey'));

    if (response.statusCode == 200) {
      return TVResponse
          .fromJson(json.decode(response.body))
          .tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TVModel>> searchTVs(String query) async {
    final response = await ioClient.get(
        Uri.parse('$baseURL/search/tv?$apiKey&query=$query'));

    if (response.statusCode == 200) {
      return TVResponse
          .fromJson(json.decode(response.body))
          .tvList;
    } else {
      throw ServerException();
    }
  }

  // Future<bool> _isSecure(String url, HttpMethod httpMethod) async {
  //   return await sslPinningHelper.isSecure(url, httpMethod);
  // }

}