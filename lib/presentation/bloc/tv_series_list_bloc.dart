import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_on_air_tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:equatable/equatable.dart';

part 'tv_series_list_event.dart';
part 'tv_series_list_state.dart';

class OnAirTVSeriesBloc extends Bloc<TVSeriesListEvent, OnAirTVSeriesState> {
  final GetOnAirTVSeries getOnAirTVSeries;

  OnAirTVSeriesBloc({required this.getOnAirTVSeries})
      : super(OnAirTVSeriesEmpty()) {
    on<FetchOnAirTVSeries>(_onFetchOnAirTVSeries);
  }

  Future<void> _onFetchOnAirTVSeries(
    FetchOnAirTVSeries event,
    Emitter<OnAirTVSeriesState> emit,
  ) async {
    emit(OnAirTVSeriesLoading());
    final result = await getOnAirTVSeries.execute();
    result.fold(
      (failure) => emit(OnAirTVSeriesError(failure.message)),
      (data) => emit(OnAirTVSeriesLoaded(data)),
    );
  }
}

class PopularTVSeriesBloc
    extends Bloc<TVSeriesListEvent, PopularTVSeriesState> {
  final GetPopularTVSeries getPopularTVSeries;

  PopularTVSeriesBloc({required this.getPopularTVSeries})
      : super(PopularTVSeriesEmpty()) {
    on<FetchPopularTVSeries>(_onFetchPopularTVSeries);
  }

  Future<void> _onFetchPopularTVSeries(
    FetchPopularTVSeries event,
    Emitter<PopularTVSeriesState> emit,
  ) async {
    emit(PopularTVSeriesLoading());
    final result = await getPopularTVSeries.execute();
    result.fold(
      (failure) => emit(PopularTVSeriesError(failure.message)),
      (data) => emit(PopularTVSeriesLoaded(data)),
    );
  }
}

class TopRatedTVSeriesBloc
    extends Bloc<TVSeriesListEvent, TopRatedTVSeriesState> {
  final GetTopRatedTVSeries getTopRatedTVSeries;

  TopRatedTVSeriesBloc({required this.getTopRatedTVSeries})
      : super(TopRatedTVSeriesEmpty()) {
    on<FetchTopRatedTVSeries>(_onFetchTopRatedTVSeries);
  }

  Future<void> _onFetchTopRatedTVSeries(
    FetchTopRatedTVSeries event,
    Emitter<TopRatedTVSeriesState> emit,
  ) async {
    emit(TopRatedTVSeriesLoading());
    final result = await getTopRatedTVSeries.execute();
    result.fold(
      (failure) => emit(TopRatedTVSeriesError(failure.message)),
      (data) => emit(TopRatedTVSeriesLoaded(data)),
    );
  }
}
