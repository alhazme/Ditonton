import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/utils/state_enum.dart';
import 'package:core/styles/text_styles.dart';
import 'package:core/styles/colors.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/bloc/tv_detail_cubit.dart';
import 'package:tv/presentation/bloc/tv_detail_state.dart';
import 'package:tv/presentation/provider/tv_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class TVDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail-tv';

  final int id;
  TVDetailPage({required this.id});

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
      body: BlocBuilder<TVDetailCubit, TVDetailState>(
          builder: (context, state) {
            if (state.tvDetailState == RequestState.Loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.tvDetailState == RequestState.Loaded) {
              final tvDetail = state.tvDetail;
              final tvRecommendations = state.tvRecommendations;
              final isAddedToWatchlist = state.isAddedtoWatchlist;
            return SafeArea(
              child: TVDetailContent(
                tvDetail!,
                tvRecommendations,
                isAddedToWatchlist,
              ),
            );
          } else {
            return Text(state.message, style: TextStyle(
                color: Colors.white
            ),);
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

  TVDetailContent(this.tv, this.recommendations, this.isAddedWatchlist);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
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
                              onPressed: () async {
                                if (!isAddedWatchlist) {
                                  await context.read<TVDetailCubit>().addWatchlist(tv);
                                  // await Provider.of<TVDetailNotifier>(
                                  //     context,
                                  //     listen: false)
                                  //     . addTVWatchlist(tv);
                                } else {
                                  await context.read<TVDetailCubit>().removeFromWatchlist(tv.id);
                                  // await Provider.of<TVDetailNotifier>(
                                  //     context,
                                  //     listen: false)
                                  //     .removeTVFromWatchlist(tv);
                                }

                                final watchlistMessage = context.read<TVDetailCubit>().state.watchlistMessage;
                                if (watchlistMessage.isNotEmpty) {
                                  if (watchlistMessage == TVDetailCubit
                                      .watchlistAddSuccessMessage
                                      || watchlistMessage == TVDetailCubit
                                          .watchlistRemoveSuccessMessage
                                  ) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(watchlistMessage)));
                                  } else {
                                    showDialog(context: context, builder: (context) {
                                      return AlertDialog(
                                        content: Text(watchlistMessage),
                                      );
                                    });
                                  }
                                }
                                // final message =
                                //     Provider.of<TVDetailNotifier>(context,
                                //         listen: false)
                                //         .watchlistMessage;
                                //
                                // if (message == TVDetailNotifier.watchlistAddSuccessMessage
                                //     || message == TVDetailNotifier.watchlistRemoveSuccessMessage
                                // ) {
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
                                      ? Icon(Icons.check)
                                      : Icon(Icons.add),
                                  Text('Watchlist'),
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
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tv.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tv.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            Container(
                              key: Key('tv_recommendations_loaded'),
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
                                          TVDetailPage.ROUTE_NAME,
                                          arguments: tv.id,
                                        );
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                        child: CachedNetworkImage(
                                          key: Key('tv_recommendations_loaded_image'),
                                          imageUrl:
                                          'https://image.tmdb.org/t/p/w500${tv.posterPath}',
                                          placeholder: (context, url) =>
                                              Center(
                                                child:
                                                CircularProgressIndicator(),
                                              ),
                                          errorWidget:
                                              (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: recommendations.length,
                              ),
                            )
                            // Consumer<TVDetailNotifier>(
                            //   builder: (context, data, child) {
                            //     if (data.recommendationState ==
                            //         RequestState.Loading) {
                            //       return Center(
                            //         child: CircularProgressIndicator(
                            //           key: Key('tv_recommendations_loading'),
                            //         ),
                            //       );
                            //     } else if (data.recommendationState ==
                            //         RequestState.Error) {
                            //       return Text(data.message);
                            //     } else if (data.recommendationState ==
                            //         RequestState.Loaded) {
                            //       return Container(
                            //         key: Key('tv_recommendations_loaded'),
                            //         height: 150,
                            //         child: ListView.builder(
                            //           scrollDirection: Axis.horizontal,
                            //           itemBuilder: (context, index) {
                            //             final tv = recommendations[index];
                            //             return Padding(
                            //               padding: const EdgeInsets.all(4.0),
                            //               child: InkWell(
                            //                 onTap: () {
                            //                   Navigator.pushReplacementNamed(
                            //                     context,
                            //                     TVDetailPage.ROUTE_NAME,
                            //                     arguments: tv.id,
                            //                   );
                            //                 },
                            //                 child: ClipRRect(
                            //                   borderRadius: BorderRadius.all(
                            //                     Radius.circular(8),
                            //                   ),
                            //                   child: CachedNetworkImage(
                            //                     key: Key('tv_recommendations_loaded_image'),
                            //                     imageUrl:
                            //                     'https://image.tmdb.org/t/p/w500${tv.posterPath}',
                            //                     placeholder: (context, url) =>
                            //                         Center(
                            //                           child:
                            //                           CircularProgressIndicator(),
                            //                         ),
                            //                     errorWidget:
                            //                         (context, url, error) =>
                            //                         Icon(Icons.error),
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
                            //         key: Key('tv_recommendations_empty'),
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
              icon: Icon(Icons.arrow_back),
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
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }
}