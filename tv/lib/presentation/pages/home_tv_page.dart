import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/utils/constants.dart';
import 'package:core/utils/state_enum.dart';
import 'package:core/styles/text_styles.dart';
import 'package:core/utils/routes.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/bloc/tv_list_cubit.dart';
import 'package:tv/presentation/bloc/tv_list_state.dart';
import 'package:flutter/material.dart';

class HomeTVPage extends StatefulWidget {
  static const ROUTE_NAME = '/tvshow';

  const HomeTVPage({super.key});

  @override
  _HomeTVPageState createState() => _HomeTVPageState();
}

class _HomeTVPageState extends State<HomeTVPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TVListCubit>()
        ..fetchNowPlayingTVs()
        ..fetchPopularTVs()
        ..fetchTopRatedTVs();
      //   () => Provider.of<TVListNotifier>(context, listen: false)
      // ..fetchNowPlayingTVs()
      // ..fetchPopularTVs()
      // ..fetchTopRatedTVs());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
			key: const Key('home_scaffold'),
      drawer: Drawer(
        key: const Key('home_drawer'),
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png', package: 'ditonton'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              key: const Key('movie_drawer_list_title'),
              leading: const Icon(Icons.movie),
              title: const Text('Movies'),
              onTap: () {
                Navigator.pushNamed(context, HOME_ROUTE);
              },
            ),
            ListTile(
              key: const Key('tv_drawer_list_title'),
              leading: const Icon(Icons.tv),
              title: const Text('TV Show'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              key: const Key('watchlist_drawer_list_title'),
              leading: const Icon(Icons.save_alt),
              title: const Text('Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WATCHLIST_ROUTE);
              },
            ),
            ListTile(
              key: const Key('about_drawer_list_title'),
              onTap: () {
                Navigator.pushNamed(context, ABOUT_ROUTE);
              },
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, TV_SEARCH_ROUTE);
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Now Playing',
                style: kHeading6,
              ),
              BlocBuilder<TVListCubit, TVListState>(
                  builder: (context, state) {
                    final nowPlayingState = state.nowPlayingTVState;
                    if (nowPlayingState == RequestState.Loading) {
                      return const Center(
                        key: Key('now_playing_progress_indicator'),
                        child: CircularProgressIndicator(),
                      );
                    } else if (nowPlayingState == RequestState.Loaded) {
                      return TVList(
                          key: const Key('now_playing_tvs'),
													tvs: state.nowPlayingTVs);
                    } else {
                      return const Text('Failed');
                    }
                  }
              ),
              // Consumer<TVListNotifier>(builder: (context, data, child) {
              //   final state = data.nowPlayingTVsState;
              //   if (state == RequestState.Loading) {
              //     return Center(
              //       child: CircularProgressIndicator(),
              //     );
              //   } else if (state == RequestState.Loaded) {
              //     return TVList(data.nowPlayingTVs);
              //   } else {
              //     return Text('Failed');
              //   }
              // }),
              _buildSubHeading(
                title: 'Popular',
                onTap: () => Navigator.pushNamed(context, TVS_POPULAR_ROUTE),
              ),
              BlocBuilder<TVListCubit, TVListState>(
                  builder: (context, state) {
                    final popularTVsState = state.popularTVsState;
                    if (popularTVsState == RequestState.Loading) {
                      return const Center(
                        key: Key('popular_progress_indicator'),
                        child: CircularProgressIndicator(),
                      );
                    } else if (popularTVsState == RequestState.Loaded) {
                      return TVList(
												key: const Key('popular_tvs'),
												tvs: state.popularTVs);
                    } else {
                      return const Text('Failed');
                    }
                  }
              ),
              // Consumer<TVListNotifier>(builder: (context, data, child) {
              //   final state = data.popularTVsState;
              //   if (state == RequestState.Loading) {
              //     return Center(
              //       child: CircularProgressIndicator(),
              //     );
              //   } else if (state == RequestState.Loaded) {
              //     return TVList(data.popularTVs);
              //   } else {
              //     return Text('Failed');
              //   }
              // }),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () => Navigator.pushNamed(context, TVS_TOP_RATED_ROUTE),
              ),
              BlocBuilder<TVListCubit, TVListState>(
                builder: (context, state) {
                  final topRatedTVsState = state.topRatedTVsState;
                  if (topRatedTVsState == RequestState.Loading) {
                    return const Center(
											key: Key('top_rated_progress_indicator'),
                      child: CircularProgressIndicator(),
                    );
                  } else if (topRatedTVsState == RequestState.Loaded) {
                    return TVList(
											key: const Key('top_rated_tvs'),
											tvs: state.topRatedTVs
										);
                  } else {
                    return const Text('Failed');
                  }
                }
            ),
              // Consumer<TVListNotifier>(builder: (context, data, child) {
              //   final state = data.topRatedTVsState;
              //   if (state == RequestState.Loading) {
              //     return Center(
              //       child: CircularProgressIndicator(),
              //     );
              //   } else if (state == RequestState.Loaded) {
              //     return TVList(data.topRatedTVs);
              //   } else {
              //     return Text('Failed');
              //   }
              // }),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class TVList extends StatelessWidget {
  final List<TV> tvs;

  const TVList({
		super.key, 
		required this.tvs
	});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = tvs[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TV_DETAIL_ROUTE,
                  arguments: tv.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvs.length,
      ),
    );
  }
}