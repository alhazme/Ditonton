import 'package:core/utils/state_enum.dart';
import 'package:core/styles/text_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/bloc/tv_search_cubit.dart';
import 'package:tv/presentation/bloc/tv_search_state.dart';
import 'package:tv/presentation/widgets/tv_card.dart';
import 'package:flutter/material.dart';

class SearchTVPage extends StatelessWidget {
  static const routeName = '/search-tv';

  const SearchTVPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              key: const Key('search_textfield'),
              onSubmitted: (query) {
                context.read<TVSearchCubit>().fetchTVSearch(query);
                // Provider.of<TVSearchNotifier>(context, listen: false)
                //     .fetchTVSearch(query);
              },
              decoration: const InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            BlocBuilder<TVSearchCubit, TVSearchState>(
              builder: (context, state) {
                if (state.state == RequestState.Loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state.state == RequestState.Loaded) {
                  final result = state.searchResult;
                  return Expanded(
                    key: const Key('loaded_container'),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final tv = result[index];
                        return TVCard(tv);
                      },
                      itemCount: result.length,
                    ),
                  );
                } else {
                  return Expanded(
                    key: const Key('error_container'),
                    child: Container(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
