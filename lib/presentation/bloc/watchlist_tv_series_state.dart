part of 'watchlist_tv_series_bloc.dart';

abstract class WatchlistTVSeriesState extends Equatable {
  const WatchlistTVSeriesState();

  @override
  List<Object> get props => [];
}

class WatchlistTVSeriesEmpty extends WatchlistTVSeriesState {}

class WatchlistTVSeriesLoading extends WatchlistTVSeriesState {}

class WatchlistTVSeriesLoaded extends WatchlistTVSeriesState {
  final List<TVSeries> tvSeries;
  const WatchlistTVSeriesLoaded(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class WatchlistTVSeriesError extends WatchlistTVSeriesState {
  final String message;
  const WatchlistTVSeriesError(this.message);

  @override
  List<Object> get props => [message];
}
