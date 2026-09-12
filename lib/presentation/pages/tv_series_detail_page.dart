import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/presentation/bloc/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TVSeriesDetailPage extends StatefulWidget {
  static const routeName = '/detail-tv-series';

  final int id;
  const TVSeriesDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  _TVSeriesDetailPageState createState() => _TVSeriesDetailPageState();
}

class _TVSeriesDetailPageState extends State<TVSeriesDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TVSeriesDetailBloc>().add(FetchTVSeriesDetail(widget.id));
      context.read<TVSeriesDetailBloc>().add(
        LoadTVSeriesWatchlistStatus(widget.id),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TVSeriesDetailBloc, TVSeriesDetailState>(
        builder: (context, state) {
          if (state.tvSeriesState == RequestState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.tvSeriesState == RequestState.loaded) {
            final tvSeries = state.tvSeries!;
            return SafeArea(
              child: TVSeriesDetailContent(
                tvSeries,
                state.recommendations,
                state.isAddedToWatchlist,
              ),
            );
          } else if (state.tvSeriesState == RequestState.error) {
            return Text(state.message);
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class TVSeriesDetailContent extends StatelessWidget {
  final TVSeriesDetail tvSeries;
  final List<TVSeries> recommendations;
  final bool isAddedWatchlist;

  const TVSeriesDetailContent(
    this.tvSeries,
    this.recommendations,
    this.isAddedWatchlist, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tvSeries.posterPath}',
          width: screenWidth,
          placeholder: (_, __) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (_, __, ___) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (_, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tvSeries.name, style: kHeading5),
                            BlocConsumer<
                              TVSeriesDetailBloc,
                              TVSeriesDetailState
                            >(
                              listenWhen: (prev, curr) =>
                                  prev.watchlistMessage !=
                                      curr.watchlistMessage &&
                                  curr.watchlistMessage.isNotEmpty,
                              listener: (context, state) {
                                final message = state.watchlistMessage;
                                if (message ==
                                        TVSeriesDetailBloc
                                            .watchlistAddSuccessMessage ||
                                    message ==
                                        TVSeriesDetailBloc
                                            .watchlistRemoveSuccessMessage) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(message)),
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (_) =>
                                        AlertDialog(content: Text(message)),
                                  );
                                }
                              },
                              builder: (context, state) {
                                return FilledButton(
                                  onPressed: () {
                                    if (!state.isAddedToWatchlist) {
                                      context.read<TVSeriesDetailBloc>().add(
                                        AddTVSeriesToWatchlist(tvSeries),
                                      );
                                    } else {
                                      context.read<TVSeriesDetailBloc>().add(
                                        RemoveTVSeriesFromWatchlist(tvSeries),
                                      );
                                    }
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      state.isAddedToWatchlist
                                          ? const Icon(Icons.check)
                                          : const Icon(Icons.add),
                                      const Text('Watchlist'),
                                    ],
                                  ),
                                );
                              },
                            ),
                            Text(_showGenres(tvSeries.genres)),
                            Text(
                              '${tvSeries.numberOfSeasons} Season(s) · ${tvSeries.numberOfEpisodes} Episode(s)',
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tvSeries.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (_, __) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tvSeries.voteAverage}'),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text('Overview', style: kHeading6),
                            Text(tvSeries.overview),
                            const SizedBox(height: 16),
                            Text('Seasons', style: kHeading6),
                            _buildSeasonList(tvSeries.seasons),
                            const SizedBox(height: 16),
                            Text('Recommendations', style: kHeading6),
                            BlocBuilder<
                              TVSeriesDetailBloc,
                              TVSeriesDetailState
                            >(
                              builder: (context, state) {
                                if (state.recommendationState ==
                                    RequestState.loading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state.recommendationState ==
                                    RequestState.error) {
                                  return Text(state.message);
                                } else if (state.recommendationState ==
                                    RequestState.loaded) {
                                  return SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final tv = state.recommendations[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                TVSeriesDetailPage.routeName,
                                                arguments: tv.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                    Radius.circular(8),
                                                  ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${tv.posterPath}',
                                                placeholder: (_, __) =>
                                                    const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                errorWidget: (_, __, ___) =>
                                                    const Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: state.recommendations.length,
                                    ),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        height: 4,
                        width: 48,
                        child: ColoredBox(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            },
            minChildSize: 0.25,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSeasonList(List<Season> seasons) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: seasons.length,
        itemBuilder: (_, index) {
          final season = seasons[index];
          return SizedBox(
            width: 100,
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: season.posterPath != null
                        ? CachedNetworkImage(
                            imageUrl:
                                'https://image.tmdb.org/t/p/w500${season.posterPath}',
                            height: 120,
                            width: 100,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => ColoredBox(
                              color: kGrey,
                              child: const SizedBox(
                                height: 120,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ),
                            errorWidget: (_, __, ___) =>
                                const Icon(Icons.error),
                          )
                        : ColoredBox(
                            color: kGrey,
                            child: const SizedBox(
                              height: 120,
                              width: 100,
                              child: Icon(Icons.tv, color: Colors.white54),
                            ),
                          ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    season.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }
    if (result.isEmpty) return result;
    return result.substring(0, result.length - 2);
  }
}
