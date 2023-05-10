import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/bloc/tv_detail_cubit.dart';
import 'package:tv/presentation/bloc/tv_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TVDetailPage extends StatefulWidget {
  static const routeName = '/detail-tv';

  final int id;
  const TVDetailPage({super.key, required this.id});

  @override
  _TVDetailPageState createState() => _TVDetailPageState();
}

class _TVDetailPageState extends State<TVDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TVDetailCubit>()
        ..fetchTVDetail(widget.id)
        ..loadWatchlistStatus(widget.id);
      // Provider.of<TVDetailNotifier>(context, listen: false)
      //     .fetchTVDetail(widget.id);
      // Provider.of<TVDetailNotifier>(context, listen: false)
      //     .loadTVWatchlistStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TVDetailCubit, TVDetailState>(
				listener: (context, state) {
				  if (state.watchlistMessage.isNotEmpty) {
						if (state.watchlistMessage == TVDetailCubit.watchlistAddSuccessMessage
							|| state.watchlistMessage == TVDetailCubit.watchlistRemoveSuccessMessage
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
					if (state.tvDetailState == RequestState.Loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.tvDetailState == RequestState.Loaded) {
            return SafeArea(
              child: TVDetailContent(
                state.tvDetail!,
                state.tvRecommendations,
                state.isAddedtoWatchlist,
              ),
            );
          } else if (state.tvDetailState == RequestState.Error) {
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
        },
      ),
    );
  }
}

class TVDetailContent extends StatelessWidget {
  final TVDetail tv;
  final List<TV> recommendations;
  final bool isAddedWatchlist;

  const TVDetailContent(
		this.tv, 
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
          imageUrl: '$baseImageURL${tv.posterPath}',
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
                              tv.name,
                              style: kHeading5,
                            ),
                            ElevatedButton(
															key: const Key('watchlist_button'),
                              onPressed: () async {
                                if (!isAddedWatchlist) {
                                  await context.read<TVDetailCubit>().addWatchlist(tv);
                                } else {
                                  await context.read<TVDetailCubit>().removeFromWatchlist(tv.id);
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
                              _showGenres(tv.genres),
                            ),
                            Text(
                              "${tv.numberOfEpisodes} Episodes - ${tv.numberOfSeasons} Seasons",
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tv.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tv.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tv.overview,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
														_recommendationTVsWidget(recommendations),
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



  Widget _recommendationTVsWidget(List<TV> recommendations) {
    if (recommendations.isNotEmpty) {
      return SizedBox(
				key: const Key('tv_recommendations_loaded'),
				height: 150,
				child: ListView.builder(
					scrollDirection: Axis.horizontal,
					itemBuilder: (context, index) {
						final tv = recommendations[index];
						return Padding(
							padding: const EdgeInsets.all(4.0),
							child: InkWell(
								onTap: () {
									Navigator.pushReplacementNamed(
										context,
										TVDetailPage.routeName,
										arguments: tv.id,
									);
								},
								child: ClipRRect(
									borderRadius: const BorderRadius.all(
										Radius.circular(8),
									),
									child: CachedNetworkImage(
										key: const Key('tv_recommendations_loaded_image'),
										imageUrl:
										'$baseImageURL${tv.posterPath}',
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
			);
    } else {
      return
        Container(
          key: const Key('tv_recommendations_empty'),
        )
      ;
    }
  }
}