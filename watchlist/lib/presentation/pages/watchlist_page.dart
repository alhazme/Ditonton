import 'package:core/utils/utils.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchlist/presentation/bloc/watchlist_cubit.dart';
import 'package:watchlist/presentation/bloc/watchlist_state.dart';
import 'package:watchlist/presentation/widgets/watchlist_card.dart';
import 'package:flutter/material.dart';

class WatchlistPage extends StatefulWidget {
  static const routeName = '/watchlist';

  const WatchlistPage({super.key});

  @override
  _WatchlistPageState createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<WatchlistCubit>().fetchWatchlists()
      // () => Provider.of<WatchlistNotifier>(context, listen: false)
      //   .fetchWatchlists()
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    Future.microtask(() =>
        context.read<WatchlistCubit>().fetchWatchlists()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
				leading: const BackButton(),
        title: const Text('Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchlistCubit, WatchlistState>(
          builder: (context, state) {
            if (state.watchlistState == RequestState.Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.watchlistState == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final watchlist = state.watchlists[index];
                  return WatchlistCard(watchlist);
                },
                itemCount: state.watchlists.length,
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

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
