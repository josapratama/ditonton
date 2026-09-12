part of 'movie_list_bloc.dart';

// Now Playing States
abstract class NowPlayingMoviesState extends Equatable {
  const NowPlayingMoviesState();

  @override
  List<Object> get props => [];
}

class NowPlayingMoviesEmpty extends NowPlayingMoviesState {}

class NowPlayingMoviesLoading extends NowPlayingMoviesState {}

class NowPlayingMoviesLoaded extends NowPlayingMoviesState {
  final List<Movie> movies;
  const NowPlayingMoviesLoaded(this.movies);

  @override
  List<Object> get props => [movies];
}

class NowPlayingMoviesError extends NowPlayingMoviesState {
  final String message;
  const NowPlayingMoviesError(this.message);

  @override
  List<Object> get props => [message];
}

// Popular Movies States
abstract class PopularMoviesState extends Equatable {
  const PopularMoviesState();

  @override
  List<Object> get props => [];
}

class PopularMoviesEmpty extends PopularMoviesState {}

class PopularMoviesLoading extends PopularMoviesState {}

class PopularMoviesLoaded extends PopularMoviesState {
  final List<Movie> movies;
  const PopularMoviesLoaded(this.movies);

  @override
  List<Object> get props => [movies];
}

class PopularMoviesError extends PopularMoviesState {
  final String message;
  const PopularMoviesError(this.message);

  @override
  List<Object> get props => [message];
}

// Top Rated Movies States
abstract class TopRatedMoviesState extends Equatable {
  const TopRatedMoviesState();

  @override
  List<Object> get props => [];
}

class TopRatedMoviesEmpty extends TopRatedMoviesState {}

class TopRatedMoviesLoading extends TopRatedMoviesState {}

class TopRatedMoviesLoaded extends TopRatedMoviesState {
  final List<Movie> movies;
  const TopRatedMoviesLoaded(this.movies);

  @override
  List<Object> get props => [movies];
}

class TopRatedMoviesError extends TopRatedMoviesState {
  final String message;
  const TopRatedMoviesError(this.message);

  @override
  List<Object> get props => [message];
}
