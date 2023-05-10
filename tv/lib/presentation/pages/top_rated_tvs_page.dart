import 'package:core/utils/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/bloc/tv_top_rated_cubit.dart';
import 'package:tv/presentation/bloc/tv_top_rated_state.dart';
import 'package:tv/presentation/widgets/tv_card.dart';
import 'package:flutter/material.dart';

class TopRatedTVsPage extends StatefulWidget {
  static const routeName = '/top-rated-tv';

  const TopRatedTVsPage({super.key});

  @override
  _TopRatedTVsPageState createState() => _TopRatedTVsPageState();
}

class _TopRatedTVsPageState extends State<TopRatedTVsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<TVTopRatedCubit>().fetchTopRatedTVs()
    );
        // Provider.of<TopRatedTVsNotifier>(context, listen: false)
        //     .fetchTopRatedTVs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated TVs'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TVTopRatedCubit, TVTopRatedState>(
          builder: (context, state) {
            if (state.topRatedTVsState == RequestState.Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.topRatedTVsState == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.topRatedTVs[index];
                  return TVCard(tv);
                },
                itemCount: state.topRatedTVs.length,
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