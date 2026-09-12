part of 'tv_series_search_bloc.dart';

abstract class TVSeriesSearchEvent extends Equatable {
  const TVSeriesSearchEvent();

  @override
  List<Object> get props => [];
}

class OnTVSeriesQueryChanged extends TVSeriesSearchEvent {
  final String query;
  const OnTVSeriesQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}
