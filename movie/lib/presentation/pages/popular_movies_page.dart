import 'package:core/utils/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/bloc/movie_popular_cubit.dart';
import 'package:movie/presentation/bloc/movie_popular_state.dart';
import 'package:movie/presentation/widget/movie_card.dart';
import 'package:flutter/material.dart';

class PopularMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-movie';

  const PopularMoviesPage({super.key});

  @override
  _PopularMoviesPageState createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
      context.read<MoviePopularCubit>().fetchPopularMovies()
    );
        // Provider.of<PopularMoviesNotifier>(context, listen: false)
        //     .fetchPopularMovies());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<MoviePopularCubit, MoviePopularState>(
          builder: (context, state) {
        // child: Consumer<PopularMoviesNotifier>(
        //   builder: (context, data, child) {
            if (state.popularMoviesState == RequestState.Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.popularMoviesState == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.popularMovies[index];
                  return MovieCard(movie);
                },
                itemCount: state.popularMovies.length,
              );
            } else {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            }
          },
        ),
      ),
    );
  }
}
