part of 'tv_series_list_bloc.dart';

// On Air TV Series States
abstract class OnAirTVSeriesState extends Equatable {
  const OnAirTVSeriesState();

  @override
  List<Object> get props => [];
}

class OnAirTVSeriesEmpty extends OnAirTVSeriesState {}

class OnAirTVSeriesLoading extends OnAirTVSeriesState {}

class OnAirTVSeriesLoaded extends OnAirTVSeriesState {
  final List<TVSeries> tvSeries;
  const OnAirTVSeriesLoaded(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class OnAirTVSeriesError extends OnAirTVSeriesState {
  final String message;
  const OnAirTVSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

// Popular TV Series States
abstract class PopularTVSeriesState extends Equatable {
  const PopularTVSeriesState();

  @override
  List<Object> get props => [];
}

class PopularTVSeriesEmpty extends PopularTVSeriesState {}

class PopularTVSeriesLoading extends PopularTVSeriesState {}

class PopularTVSeriesLoaded extends PopularTVSeriesState {
  final List<TVSeries> tvSeries;
  const PopularTVSeriesLoaded(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class PopularTVSeriesError extends PopularTVSeriesState {
  final String message;
  const PopularTVSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

// Top Rated TV Series States
abstract class TopRatedTVSeriesState extends Equatable {
  const TopRatedTVSeriesState();

  @override
  List<Object> get props => [];
}

class TopRatedTVSeriesEmpty extends TopRatedTVSeriesState {}

class TopRatedTVSeriesLoading extends TopRatedTVSeriesState {}

class TopRatedTVSeriesLoaded extends TopRatedTVSeriesState {
  final List<TVSeries> tvSeries;
  const TopRatedTVSeriesLoaded(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class TopRatedTVSeriesError extends TopRatedTVSeriesState {
  final String message;
  const TopRatedTVSeriesError(this.message);

  @override
  List<Object> get props => [message];
}
