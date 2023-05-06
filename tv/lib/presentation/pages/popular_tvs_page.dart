import 'package:core/utils/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/bloc/tv_popular_cubit.dart';
import 'package:tv/presentation/bloc/tv_popular_state.dart';
import 'package:tv/presentation/widgets/tv_card.dart';
import 'package:flutter/material.dart';

class PopularTvsPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-tv';

  const PopularTvsPage({super.key});

  @override
  _PopularTvsPageState createState() => _PopularTvsPageState();
}

class _PopularTvsPageState extends State<PopularTvsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<TVPopularCubit>().fetchPopularTVs()
    );
        // Provider.of<PopularTVsNotifier>(context, listen: false)
        //     .fetchPopularTVs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular TVs'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        // child: Consumer<PopularTVsNotifier>(
        //   builder: (context, data, child) {
        child: BlocBuilder<TVPopularCubit, TVPopularState>(
          builder: (context, state) {
            if (state.popularTVsState == RequestState.Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.popularTVsState == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.popularTVs[index];
                  return TVCard(tv);
                },
                itemCount: state.popularTVs.length,
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