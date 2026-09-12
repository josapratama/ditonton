import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:equatable/equatable.dart';

part 'tv_series_search_event.dart';
part 'tv_series_search_state.dart';

class TVSeriesSearchBloc
    extends Bloc<TVSeriesSearchEvent, TVSeriesSearchState> {
  final SearchTVSeries searchTVSeries;

  TVSeriesSearchBloc({required this.searchTVSeries})
      : super(TVSeriesSearchEmpty()) {
    on<OnTVSeriesQueryChanged>(_onTVSeriesQueryChanged);
  }

  Future<void> _onTVSeriesQueryChanged(
    OnTVSeriesQueryChanged event,
    Emitter<TVSeriesSearchState> emit,
  ) async {
    emit(TVSeriesSearchLoading());
    final result = await searchTVSeries.execute(event.query);
    result.fold(
      (failure) => emit(TVSeriesSearchError(failure.message)),
      (data) => emit(TVSeriesSearchLoaded(data)),
    );
  }
}
