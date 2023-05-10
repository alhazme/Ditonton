
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/utils/constants.dart';
import 'package:core/styles/text_styles.dart';
import 'package:core/utils/routes.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/bloc/movie_home_cubit.dart';
import 'package:movie/presentation/bloc/movie_home_state.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';

class HomeMoviePage extends StatefulWidget {
  static const routeName = '/home';

  const HomeMoviePage({super.key});

  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MovieHomeCubit>()
        ..fetchNowPlayingMovies()
        ..fetchPopularMovies()
        ..fetchTopRatedMovies();
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
                backgroundImage: AssetImage('assets/circle-g.png', package: 'core'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              key: const Key('movie_drawer_list_title'),
              leading: const Icon(Icons.movie),
              title: const Text('Movies'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              key: const Key('tv_drawer_list_title'),
              leading: const Icon(Icons.tv),
              title: const Text('TV Shows'),
              onTap: () {
                Navigator.pushNamed(context, tvShowRoute);
              },
            ),
            ListTile(
              key: const Key('watchlist_drawer_list_title'),
              leading: const Icon(Icons.save_alt),
              title: const Text('Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, watchlistRoute);
              },
            ),
            ListTile(
              key: const Key('about_drawer_list_title'),
              onTap: () {
                Navigator.pushNamed(context, aboutRoute);
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
              Navigator.pushNamed(context, movieSearchRoute);
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
              BlocBuilder<MovieHomeCubit, MovieHomeState>(
                  builder: (context, state) {
                    final nowPlayingState = state.nowPlayingState;
                    if (nowPlayingState == RequestState.Loading) {
                      return const Center(
                        key: Key('now_playing_progress_indicator'),
                        child: CircularProgressIndicator(),
                      );
                    } else if (nowPlayingState == RequestState.Loaded) {
                      return MovieList(
                          key: const Key('now_playing_movies'),
                          movies: state.nowPlayingMovies
                      );
                    } else {
                      return const Text('Failed');
                    }
                  }
              ),
              _buildSubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, moviesPopularRoute),
              ),
              BlocBuilder<MovieHomeCubit, MovieHomeState>(
                  builder: (context, state) {
                    final popularMoviesState = state.popularMoviesState;
                    if (popularMoviesState == RequestState.Loading) {
                      return const Center(
                        key: Key('popular_progress_indicator'),
                        child: CircularProgressIndicator(),
                      );
                    } else if (popularMoviesState == RequestState.Loaded) {
                      return MovieList(
                          key: const Key('popular_movies'),
                          movies: state.popularMovies
                      );
                    } else {
                      return const Text('Failed');
                    }
                  }
              ),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, moviesTopRatedRoute),
              ),
              BlocBuilder<MovieHomeCubit, MovieHomeState>(
                  builder: (context, state) {
                    final topRatedMoviesState = state.topRatedMoviesState;
                    if (topRatedMoviesState == RequestState.Loading) {
                      return const Center(
                        key: Key('top_rated_progress_indicator'),
                        child: CircularProgressIndicator(),
                      );
                    } else if (topRatedMoviesState == RequestState.Loaded) {
                      return MovieList(
												key: const Key('top_rated_movies'),
												movies: state.topRatedMovies
                      );
                    } else {
                      return const Text('Failed');
                    }
                  }
              ),
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

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  const MovieList({
		super.key, 
		required this.movies
	});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              key: const Key('movie_item'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  movieDetailRoute,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageURL${movie.posterPath}',
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
