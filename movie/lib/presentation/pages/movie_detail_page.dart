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
  static const ROUTE_NAME = '/detail-movie';

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
      // Provider.of<MovieDetailNotifier>(context, listen: false)
      //     .fetchMovieDetail(widget.id);
      // Provider.of<MovieDetailNotifier>(context, listen: false)
      //     .loadWatchlistStatus(widget.id);
    });
		// print("initState is called");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<MovieDetailCubit, MovieDetailState>(
				listener: (context, state) {
					print("state.watchlistMessage ${state.watchlistMessage}");
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
                state.isAddedtoWatchlist
                //provider.movieRecommendations,
                //provider.isAddedToWatchlist,
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
      // body: Consumer<MovieDetailNotifier>(
      //   builder: (context, provider, child) {
      //     if (provider.movieState == RequestState.Loading) {
      //       return Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     } else if (provider.movieState == RequestState.Loaded) {
      //       final movie = provider.movie;
      //       return SafeArea(
      //         child: DetailContent(
      //           movie,
      //           provider.movieRecommendations,
      //           provider.isAddedToWatchlist,
      //         ),
      //       );
      //     } else {
      //       return Text(provider.message);
      //     }
      //   },
      // ),
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
          imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
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
																	print("addWatchlist is called");
                                  await context.read<MovieDetailCubit>().addWatchlist(movie);
                                  // await Provider.of<MovieDetailNotifier>(
                                  //         context,
                                  //         listen: false)
                                  //     .addWatchlist(movie);
                                } else {
																	print("removeFromWatchlist is called");
                                  await context.read<MovieDetailCubit>().removeFromWatchlist(movie.id);
                                  // await Provider.of<MovieDetailNotifier>(
                                  //         context,
                                  //         listen: false)
                                  //     .removeFromWatchlist(movie);
                                }
                                // final watchlistMessage = context.read<MovieDetailCubit>().state.watchlistMessage;
                                // if (watchlistMessage.isNotEmpty) {
                                //   if (watchlistMessage == MovieDetailCubit
                                //       .watchlistAddSuccessMessage
                                //       || watchlistMessage == MovieDetailCubit
                                //           .watchlistRemoveSuccessMessage
                                //   ) {
                                //     ScaffoldMessenger.of(context).showSnackBar(
                                //         SnackBar(
                                //             content: Text(watchlistMessage)));
                                //   } else {
                                //     showDialog(
                                //         context: context, builder: (context) {
                                //       return AlertDialog(
                                //         content: Text(watchlistMessage),
                                //       );
                                //     });
                                //   }
                                // }
                                // final message =
                                //     Provider.of<MovieDetailNotifier>(context,
                                //             listen: false)
                                //         .watchlistMessage;
                                //
                                // if (message ==
                                //         MovieDetailNotifier
                                //             .watchlistAddSuccessMessage ||
                                //     message ==
                                //         MovieDetailNotifier
                                //             .watchlistRemoveSuccessMessage) {
                                //   ScaffoldMessenger.of(context).showSnackBar(
                                //       SnackBar(content: Text(message)));
                                // } else {
                                //   showDialog(
                                //       context: context,
                                //       builder: (context) {
                                //         return AlertDialog(
                                //           content: Text(message),
                                //         );
                                //       });
                                // }
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
                            // Consumer<MovieDetailNotifier>(
                            //   builder: (context, data, child) {
                            //     if (data.recommendationState ==
                            //         RequestState.Loading) {
                            //       return Center(
                            //         child: CircularProgressIndicator(
                            //           key: Key('movie_recommendations_loading'),
                            //         ),
                            //       );
                            //     } else if (data.recommendationState ==
                            //         RequestState.Error) {
                            //       return Text(data.message);
                            //     } else if (data.recommendationState ==
                            //         RequestState.Loaded) {
                            //       return Container(
                            //         key: Key('movie_recommendations_loaded'),
                            //         height: 150,
                            //         child: ListView.builder(
                            //           scrollDirection: Axis.horizontal,
                            //           itemBuilder: (context, index) {
                            //             final movie = recommendations[index];
                            //             return Padding(
                            //               padding: const EdgeInsets.all(4.0),
                            //               child: InkWell(
                            //                 onTap: () {
                            //                   Navigator.pushReplacementNamed(
                            //                     context,
                            //                     MovieDetailPage.ROUTE_NAME,
                            //                     arguments: movie.id,
                            //                   );
                            //                 },
                            //                 child: ClipRRect(
                            //                   borderRadius: BorderRadius.all(
                            //                     Radius.circular(8),
                            //                   ),
                            //                   child: CachedNetworkImage(
                            //                     key: Key('movie_recommendations_loaded_image'),
                            //                     imageUrl:
                            //                         'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                            //                     placeholder: (context, url) =>
                            //                         Center(
                            //                       child:
                            //                           CircularProgressIndicator(),
                            //                     ),
                            //                     errorWidget:
                            //                         (context, url, error) =>
                            //                             Icon(Icons.error),
                            //                   ),
                            //                 ),
                            //               ),
                            //             );
                            //           },
                            //           itemCount: recommendations.length,
                            //         ),
                            //       );
                            //     } else {
                            //       return Container(
                            //         key: Key('movie_recommendations_empty'),
                            //       );
                            //     }
                            //   },
                            // ),
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
                  onTap: () {
                    Navigator.pushReplacementNamed(
                      context,
                      MovieDetailPage.ROUTE_NAME,
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
                      '$BASE_IMAGE_URL${movie.posterPath}',
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
