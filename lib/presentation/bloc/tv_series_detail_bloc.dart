import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_series.dart';
import 'package:ditonton/presentation/bloc/movie_detail_bloc.dart';
import 'package:equatable/equatable.dart';

part 'tv_series_detail_event.dart';
part 'tv_series_detail_state.dart';

class TVSeriesDetailBloc
    extends Bloc<TVSeriesDetailEvent, TVSeriesDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTVSeriesDetail getTVSeriesDetail;
  final GetTVSeriesRecommendations getTVSeriesRecommendations;
  final GetWatchListStatusTVSeries getWatchListStatus;
  final SaveWatchlistTVSeries saveWatchlist;
  final RemoveWatchlistTVSeries removeWatchlist;

  TVSeriesDetailBloc({
    required this.getTVSeriesDetail,
    required this.getTVSeriesRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(TVSeriesDetailState.initial()) {
    on<FetchTVSeriesDetail>(_onFetchTVSeriesDetail);
    on<AddTVSeriesToWatchlist>(_onAddTVSeriesToWatchlist);
    on<RemoveTVSeriesFromWatchlist>(_onRemoveTVSeriesFromWatchlist);
    on<LoadTVSeriesWatchlistStatus>(_onLoadTVSeriesWatchlistStatus);
  }

  Future<void> _onFetchTVSeriesDetail(
    FetchTVSeriesDetail event,
    Emitter<TVSeriesDetailState> emit,
  ) async {
    emit(state.copyWith(tvSeriesState: RequestState.loading));

    final detailResult = await getTVSeriesDetail.execute(event.id);
    final recommendationResult =
        await getTVSeriesRecommendations.execute(event.id);

    detailResult.fold(
      (failure) => emit(
          state.copyWith(tvSeriesState: RequestState.error, message: failure.message)),
      (tvSeries) {
        emit(state.copyWith(
          tvSeriesState: RequestState.loading,
          tvSeries: tvSeries,
          recommendationState: RequestState.loading,
        ));
        recommendationResult.fold(
          (failure) => emit(state.copyWith(
            recommendationState: RequestState.error,
            message: failure.message,
          )),
          (recommendations) => emit(state.copyWith(
            tvSeriesState: RequestState.loaded,
            recommendations: recommendations,
            recommendationState: RequestState.loaded,
          )),
        );
      },
    );
  }

  Future<void> _onAddTVSeriesToWatchlist(
    AddTVSeriesToWatchlist event,
    Emitter<TVSeriesDetailState> emit,
  ) async {
    final result = await saveWatchlist.execute(event.tvSeries);
    result.fold(
      (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
      (message) => emit(state.copyWith(watchlistMessage: message)),
    );
    add(LoadTVSeriesWatchlistStatus(event.tvSeries.id));
  }

  Future<void> _onRemoveTVSeriesFromWatchlist(
    RemoveTVSeriesFromWatchlist event,
    Emitter<TVSeriesDetailState> emit,
  ) async {
    final result = await removeWatchlist.execute(event.tvSeries);
    result.fold(
      (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
      (message) => emit(state.copyWith(watchlistMessage: message)),
    );
    add(LoadTVSeriesWatchlistStatus(event.tvSeries.id));
  }

  Future<void> _onLoadTVSeriesWatchlistStatus(
    LoadTVSeriesWatchlistStatus event,
    Emitter<TVSeriesDetailState> emit,
  ) async {
    final result = await getWatchListStatus.execute(event.id);
    emit(state.copyWith(isAddedToWatchlist: result));
  }
}
