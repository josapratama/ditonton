import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/bloc/tv_series_search_bloc.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TVSeriesSearchPage extends StatelessWidget {
  static const routeName = '/search-tv-series';

  const TVSeriesSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) {
                context.read<TVSeriesSearchBloc>().add(
                  OnTVSeriesQueryChanged(query),
                );
              },
              decoration: const InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            Text('Search Result', style: kHeading6),
            BlocBuilder<TVSeriesSearchBloc, TVSeriesSearchState>(
              builder: (context, state) {
                if (state is TVSeriesSearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TVSeriesSearchLoaded) {
                  final result = state.result;
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final tvSeries = result[index];
                        return TVSeriesCard(tvSeries);
                      },
                      itemCount: result.length,
                    ),
                  );
                } else if (state is TVSeriesSearchError) {
                  return Expanded(child: Center(child: Text(state.message)));
                } else {
                  return const Expanded(child: SizedBox.shrink());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
