part of 'watchlist_tv_series_bloc.dart';

abstract class WatchlistTVSeriesEvent extends Equatable {
  const WatchlistTVSeriesEvent();

  @override
  List<Object> get props => [];
}

class FetchWatchlistTVSeries extends WatchlistTVSeriesEvent {}
