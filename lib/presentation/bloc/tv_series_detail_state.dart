part of 'tv_series_detail_bloc.dart';

class TVSeriesDetailState extends Equatable {
  final TVSeriesDetail? tvSeries;
  final RequestState tvSeriesState;
  final List<TVSeries> recommendations;
  final RequestState recommendationState;
  final String message;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  const TVSeriesDetailState({
    required this.tvSeries,
    required this.tvSeriesState,
    required this.recommendations,
    required this.recommendationState,
    required this.message,
    required this.isAddedToWatchlist,
    required this.watchlistMessage,
  });

  factory TVSeriesDetailState.initial() {
    return const TVSeriesDetailState(
      tvSeries: null,
      tvSeriesState: RequestState.empty,
      recommendations: [],
      recommendationState: RequestState.empty,
      message: '',
      isAddedToWatchlist: false,
      watchlistMessage: '',
    );
  }

  TVSeriesDetailState copyWith({
    TVSeriesDetail? tvSeries,
    RequestState? tvSeriesState,
    List<TVSeries>? recommendations,
    RequestState? recommendationState,
    String? message,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return TVSeriesDetailState(
      tvSeries: tvSeries ?? this.tvSeries,
      tvSeriesState: tvSeriesState ?? this.tvSeriesState,
      recommendations: recommendations ?? this.recommendations,
      recommendationState: recommendationState ?? this.recommendationState,
      message: message ?? this.message,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
        tvSeries,
        tvSeriesState,
        recommendations,
        recommendationState,
        message,
        isAddedToWatchlist,
        watchlistMessage,
      ];
}
