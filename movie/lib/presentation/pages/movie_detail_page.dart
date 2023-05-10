import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/bloc/movie_detail_cubit.dart';
import 'package:movie/presentation/bloc/movie_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MovieDetailPage extends StatefulWidget {
  static const routeName = '/detail-movie';

  final int id;
  const MovieDetailPage({super.key, required this.id});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MovieDetailCubit>()
          ..fetchMovieDetail(widget.id)
          ..loadWatchlistStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<MovieDetailCubit, MovieDetailState>(
				listener: (context, state) {
				  if (state.watchlistMessage.isNotEmpty) {
						if (state.watchlistMessage == MovieDetailCubit.watchlistAddSuccessMessage
							|| state.watchlistMessage == MovieDetailCubit.watchlistRemoveSuccessMessage
						) {
							ScaffoldMessenger.of(context).showSnackBar(
								SnackBar(content: Text(state.watchlistMessage))
							);
						} else {
							showDialog(
									context: context, builder: (context) {
								return AlertDialog(
									content: Text(state.watchlistMessage),
								);
							});
						}
					}
				},
				listenWhen: (oldState, newState) {
					return oldState.watchlistMessage != newState.watchlistMessage
						&& newState.watchlistMessage.isNotEmpty;
				},
        builder: (context, state) {
          if (state.movieDetailState == RequestState.Loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.movieDetailState == RequestState.Loaded) {
            return SafeArea(
              child: DetailContent(
                state.movieDetail!,
                state.movieRecommendations,
                state.isAddedtoWatchlist,
              ),
          	);
					} else if (state.movieDetailState == RequestState.Error) {
            return Center(
							child: Text(
								state.message, 
								style: const TextStyle(
									color: Colors.white
								),
							),
						);
					} else {
            return Container();
          }
        }
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final MovieDetail movie;
  final List<Movie> recommendations;
  final bool isAddedWatchlist;

  const DetailContent(
		this.movie, 
		this.recommendations, 
		this.isAddedWatchlist, 
		{
			super.key
		}
	);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: '$baseImageURL${movie.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              key: const Key('watchlist_button'),
                              onPressed: () async {
                                if (!isAddedWatchlist) {
                                  await context.read<MovieDetailCubit>().addWatchlist(movie);
                                } else {
                                  await context.read<MovieDetailCubit>().removeFromWatchlist(movie.id);
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? const Icon(Icons.check)
                                      : const Icon(Icons.add),
                                  const Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(
                              _showGenres(movie.genres),
                            ),
                            Text(
                              _showDuration(movie.runtime),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: movie.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${movie.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              movie.overview,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            _recommendationMoviesWidget(recommendations)
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _recommendationMoviesWidget(List<Movie> recommendations) {
    if (recommendations.isNotEmpty) {
      return
        SizedBox(
          key: const Key('movie_recommendations_loaded'),
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final movie = recommendations[index];
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: InkWell(
									key: const Key('movie_recommendation_item'),
                  onTap: () {
                    Navigator.pushReplacementNamed(
                      context,
                      MovieDetailPage.routeName,
                      arguments: movie.id,
                    );
                  },
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                    child: CachedNetworkImage(
                      key: const Key('movie_recommendations_loaded_image'),
                      imageUrl:
                      '$baseImageURL${movie.posterPath}',
                      placeholder: (context, url) =>
                          const Center(
                            child:
                            CircularProgressIndicator(),
                          ),
                      errorWidget:
                          (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
              );
            },
            itemCount: recommendations.length,
          ),
        )
      ;
    } else {
      return
        Container(
          key: const Key('movie_recommendations_empty'),
        )
      ;
    }
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
