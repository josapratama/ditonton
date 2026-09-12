import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_series.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_tv_series_event.dart';
part 'watchlist_tv_series_state.dart';

class WatchlistTVSeriesBloc
    extends Bloc<WatchlistTVSeriesEvent, WatchlistTVSeriesState> {
  final GetWatchlistTVSeries getWatchlistTVSeries;

  WatchlistTVSeriesBloc({required this.getWatchlistTVSeries})
      : super(WatchlistTVSeriesEmpty()) {
    on<FetchWatchlistTVSeries>(_onFetchWatchlistTVSeries);
  }

  Future<void> _onFetchWatchlistTVSeries(
    FetchWatchlistTVSeries event,
    Emitter<WatchlistTVSeriesState> emit,
  ) async {
    emit(WatchlistTVSeriesLoading());
    final result = await getWatchlistTVSeries.execute();
    result.fold(
      (failure) => emit(WatchlistTVSeriesError(failure.message)),
      (data) => emit(WatchlistTVSeriesLoaded(data)),
    );
  }
}
