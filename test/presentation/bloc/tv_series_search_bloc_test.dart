import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series_search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_series_search_bloc_test.mocks.dart';

@GenerateMocks([SearchTVSeries])
void main() {
  late MockSearchTVSeries mockSearchTVSeries;

  final tQuery = 'breaking bad';
  final tTVSeries = TVSeries(
    backdropPath: 'backdropPath',
    firstAirDate: '2008-01-20',
    genreIds: [18, 80],
    id: 1,
    name: 'Breaking Bad',
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'Breaking Bad',
    overview: 'overview',
    popularity: 369.594,
    posterPath: '/poster.jpg',
    voteAverage: 8.9,
    voteCount: 11000,
  );
  final tTVSeriesList = <TVSeries>[tTVSeries];

  setUp(() {
    mockSearchTVSeries = MockSearchTVSeries();
  });

  test('initial state should be TVSeriesSearchEmpty', () {
    expect(
      TVSeriesSearchBloc(searchTVSeries: mockSearchTVSeries).state,
      isA<TVSeriesSearchEmpty>(),
    );
  });

  blocTest<TVSeriesSearchBloc, TVSeriesSearchState>(
    'emits [Loading, Loaded] when search succeeds',
    build: () {
      when(mockSearchTVSeries.execute(tQuery))
          .thenAnswer((_) async => Right(tTVSeriesList));
      return TVSeriesSearchBloc(searchTVSeries: mockSearchTVSeries);
    },
    act: (bloc) => bloc.add(OnTVSeriesQueryChanged(tQuery)),
    expect: () => [
      TVSeriesSearchLoading(),
      TVSeriesSearchLoaded(tTVSeriesList),
    ],
  );

  blocTest<TVSeriesSearchBloc, TVSeriesSearchState>(
    'emits [Loading, Error] when search fails',
    build: () {
      when(mockSearchTVSeries.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return TVSeriesSearchBloc(searchTVSeries: mockSearchTVSeries);
    },
    act: (bloc) => bloc.add(OnTVSeriesQueryChanged(tQuery)),
    expect: () => [
      TVSeriesSearchLoading(),
      const TVSeriesSearchError('Server Failure'),
    ],
  );
}
