import 'package:core/utils/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/bloc/movie_top_rated_cubit.dart';
import 'package:movie/presentation/bloc/movie_top_rated_state.dart';
import 'package:movie/presentation/provider/top_rated_movies_notifier.dart';
import 'package:movie/presentation/widget/movie_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopRatedMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-movie';

  @override
  _TopRatedMoviesPageState createState() => _TopRatedMoviesPageState();
}

class _TopRatedMoviesPageState extends State<TopRatedMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<MovieTopRatedCubit>().fetchTopRatedMovies()
    );
        // Provider.of<TopRatedMoviesNotifier>(context, listen: false)
        //     .fetchTopRatedMovies());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<MovieTopRatedCubit, MovieTopRatedState>(
          builder: (context, state) {
            if (state.topRatedMoviesState == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.topRatedMoviesState == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.topRatedMovies[index];
                  return MovieCard(movie);
                },
                itemCount: state.topRatedMovies.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            }
          },
        ),
      ),
    );
  }
}
