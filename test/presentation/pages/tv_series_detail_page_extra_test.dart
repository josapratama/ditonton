import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/bloc/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series_detail_bloc.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTVSeriesDetailBloc
    extends MockBloc<TVSeriesDetailEvent, TVSeriesDetailState>
    implements TVSeriesDetailBloc {}

class FakeTVSeriesDetailEvent extends Fake implements TVSeriesDetailEvent {}

void main() {
  late MockTVSeriesDetailBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeTVSeriesDetailEvent());
  });

  setUp(() {
    mockBloc = MockTVSeriesDetailBloc();
  });

  Widget makeWidget() => BlocProvider<TVSeriesDetailBloc>.value(
    value: mockBloc,
    child: MaterialApp(home: const TVSeriesDetailPage(id: 1)),
  );

  TVSeriesDetailState buildState({
    RequestState tvSeriesState = RequestState.empty,
    RequestState recommendationState = RequestState.empty,
    bool isAddedToWatchlist = false,
    String message = '',
    String watchlistMessage = '',
  }) => TVSeriesDetailState.initial().copyWith(
    tvSeriesState: tvSeriesState,
    tvSeries: tvSeriesState == RequestState.loaded ? testTVSeriesDetail : null,
    recommendations: const <TVSeries>[],
    recommendationState: recommendationState,
    isAddedToWatchlist: isAddedToWatchlist,
    message: message,
    watchlistMessage: watchlistMessage,
  );

  testWidgets('TVSeriesDetailContent shows loading for recommendations', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      buildState(
        tvSeriesState: RequestState.loaded,
        recommendationState: RequestState.loading,
      ),
    );

    await tester.pumpWidget(makeWidget());

    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  testWidgets('TVSeriesDetailContent shows error for recommendations', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      buildState(
        tvSeriesState: RequestState.loaded,
        recommendationState: RequestState.error,
        message: 'Recommendations failed',
      ),
    );

    await tester.pumpWidget(makeWidget());

    expect(find.text('Recommendations failed'), findsOneWidget);
  });

  testWidgets('TVSeriesDetailContent shows empty when recommendations empty', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      buildState(
        tvSeriesState: RequestState.loaded,
        recommendationState: RequestState.empty,
      ),
    );

    await tester.pumpWidget(makeWidget());

    expect(find.byType(SizedBox), findsWidgets);
  });

  testWidgets('Watchlist remove should show snackbar', (tester) async {
    whenListen(
      mockBloc,
      Stream.fromIterable([
        buildState(
          tvSeriesState: RequestState.loaded,
          recommendationState: RequestState.loaded,
          isAddedToWatchlist: false,
          watchlistMessage: TVSeriesDetailBloc.watchlistRemoveSuccessMessage,
        ),
      ]),
      initialState: buildState(
        tvSeriesState: RequestState.loaded,
        recommendationState: RequestState.loaded,
        isAddedToWatchlist: true,
      ),
    );

    await tester.pumpWidget(makeWidget());
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(
      find.text(TVSeriesDetailBloc.watchlistRemoveSuccessMessage),
      findsOneWidget,
    );
  });
}
