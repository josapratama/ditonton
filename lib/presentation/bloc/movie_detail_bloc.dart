import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(MovieDetailState.initial()) {
    on<FetchMovieDetail>(_onFetchMovieDetail);
    on<AddMovieToWatchlist>(_onAddMovieToWatchlist);
    on<RemoveMovieFromWatchlist>(_onRemoveMovieFromWatchlist);
    on<LoadMovieWatchlistStatus>(_onLoadMovieWatchlistStatus);
  }

  Future<void> _onFetchMovieDetail(
    FetchMovieDetail event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(state.copyWith(movieState: RequestState.loading));

    final detailResult = await getMovieDetail.execute(event.id);
    final recommendationResult =
        await getMovieRecommendations.execute(event.id);

    detailResult.fold(
      (failure) =>
          emit(state.copyWith(movieState: RequestState.error, message: failure.message)),
      (movie) {
        emit(state.copyWith(
          movieState: RequestState.loading,
          movie: movie,
          recommendationState: RequestState.loading,
        ));
        recommendationResult.fold(
          (failure) => emit(state.copyWith(
            recommendationState: RequestState.error,
            message: failure.message,
          )),
          (recommendations) => emit(state.copyWith(
            movieState: RequestState.loaded,
            recommendations: recommendations,
            recommendationState: RequestState.loaded,
          )),
        );
      },
    );
  }

  Future<void> _onAddMovieToWatchlist(
    AddMovieToWatchlist event,
    Emitter<MovieDetailState> emit,
  ) async {
    final result = await saveWatchlist.execute(event.movie);
    result.fold(
      (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
      (message) => emit(state.copyWith(watchlistMessage: message)),
    );
    add(LoadMovieWatchlistStatus(event.movie.id));
  }

  Future<void> _onRemoveMovieFromWatchlist(
    RemoveMovieFromWatchlist event,
    Emitter<MovieDetailState> emit,
  ) async {
    final result = await removeWatchlist.execute(event.movie);
    result.fold(
      (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
      (message) => emit(state.copyWith(watchlistMessage: message)),
    );
    add(LoadMovieWatchlistStatus(event.movie.id));
  }

  Future<void> _onLoadMovieWatchlistStatus(
    LoadMovieWatchlistStatus event,
    Emitter<MovieDetailState> emit,
  ) async {
    final result = await getWatchListStatus.execute(event.id);
    emit(state.copyWith(isAddedToWatchlist: result));
  }
}

enum RequestState { empty, loading, loaded, error }
