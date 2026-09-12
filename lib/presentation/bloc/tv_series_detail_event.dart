part of 'tv_series_detail_bloc.dart';

abstract class TVSeriesDetailEvent extends Equatable {
  const TVSeriesDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchTVSeriesDetail extends TVSeriesDetailEvent {
  final int id;
  const FetchTVSeriesDetail(this.id);

  @override
  List<Object> get props => [id];
}

class AddTVSeriesToWatchlist extends TVSeriesDetailEvent {
  final TVSeriesDetail tvSeries;
  const AddTVSeriesToWatchlist(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class RemoveTVSeriesFromWatchlist extends TVSeriesDetailEvent {
  final TVSeriesDetail tvSeries;
  const RemoveTVSeriesFromWatchlist(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class LoadTVSeriesWatchlistStatus extends TVSeriesDetailEvent {
  final int id;
  const LoadTVSeriesWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}
