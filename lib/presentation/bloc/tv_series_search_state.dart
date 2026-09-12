part of 'tv_series_search_bloc.dart';

abstract class TVSeriesSearchState extends Equatable {
  const TVSeriesSearchState();

  @override
  List<Object> get props => [];
}

class TVSeriesSearchEmpty extends TVSeriesSearchState {}

class TVSeriesSearchLoading extends TVSeriesSearchState {}

class TVSeriesSearchLoaded extends TVSeriesSearchState {
  final List<TVSeries> result;
  const TVSeriesSearchLoaded(this.result);

  @override
  List<Object> get props => [result];
}

class TVSeriesSearchError extends TVSeriesSearchState {
  final String message;
  const TVSeriesSearchError(this.message);

  @override
  List<Object> get props => [message];
}
