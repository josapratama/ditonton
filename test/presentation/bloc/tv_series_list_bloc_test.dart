import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_on_air_tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_series_list_bloc_test.mocks.dart';

@GenerateMocks([GetOnAirTVSeries, GetPopularTVSeries, GetTopRatedTVSeries])
void main() {
  late MockGetOnAirTVSeries mockGetOnAirTVSeries;
  late MockGetPopularTVSeries mockGetPopularTVSeries;
  late MockGetTopRatedTVSeries mockGetTopRatedTVSeries;

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
    mockGetOnAirTVSeries = MockGetOnAirTVSeries();
    mockGetPopularTVSeries = MockGetPopularTVSeries();
    mockGetTopRatedTVSeries = MockGetTopRatedTVSeries();
  });

  // ===================== OnAirTVSeriesBloc =====================
  group('OnAirTVSeriesBloc', () {
    test('initial state is OnAirTVSeriesEmpty', () {
      expect(
        OnAirTVSeriesBloc(getOnAirTVSeries: mockGetOnAirTVSeries).state,
        isA<OnAirTVSeriesEmpty>(),
      );
    });

    blocTest<OnAirTVSeriesBloc, OnAirTVSeriesState>(
      'emits [Loading, Loaded] when FetchOnAirTVSeries succeeds',
      build: () {
        when(mockGetOnAirTVSeries.execute())
            .thenAnswer((_) async => Right(tTVSeriesList));
        return OnAirTVSeriesBloc(getOnAirTVSeries: mockGetOnAirTVSeries);
      },
      act: (bloc) => bloc.add(FetchOnAirTVSeries()),
      expect: () => [
        OnAirTVSeriesLoading(),
        OnAirTVSeriesLoaded(tTVSeriesList),
      ],
    );

    blocTest<OnAirTVSeriesBloc, OnAirTVSeriesState>(
      'emits [Loading, Error] when FetchOnAirTVSeries fails',
      build: () {
        when(mockGetOnAirTVSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return OnAirTVSeriesBloc(getOnAirTVSeries: mockGetOnAirTVSeries);
      },
      act: (bloc) => bloc.add(FetchOnAirTVSeries()),
      expect: () => [
        OnAirTVSeriesLoading(),
        const OnAirTVSeriesError('Server Failure'),
      ],
    );
  });

  // ===================== PopularTVSeriesBloc =====================
  group('PopularTVSeriesBloc', () {
    test('initial state is PopularTVSeriesEmpty', () {
      expect(
        PopularTVSeriesBloc(getPopularTVSeries: mockGetPopularTVSeries).state,
        isA<PopularTVSeriesEmpty>(),
      );
    });

    blocTest<PopularTVSeriesBloc, PopularTVSeriesState>(
      'emits [Loading, Loaded] when FetchPopularTVSeries succeeds',
      build: () {
        when(mockGetPopularTVSeries.execute())
            .thenAnswer((_) async => Right(tTVSeriesList));
        return PopularTVSeriesBloc(getPopularTVSeries: mockGetPopularTVSeries);
      },
      act: (bloc) => bloc.add(FetchPopularTVSeries()),
      expect: () => [
        PopularTVSeriesLoading(),
        PopularTVSeriesLoaded(tTVSeriesList),
      ],
    );

    blocTest<PopularTVSeriesBloc, PopularTVSeriesState>(
      'emits [Loading, Error] when FetchPopularTVSeries fails',
      build: () {
        when(mockGetPopularTVSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return PopularTVSeriesBloc(getPopularTVSeries: mockGetPopularTVSeries);
      },
      act: (bloc) => bloc.add(FetchPopularTVSeries()),
      expect: () => [
        PopularTVSeriesLoading(),
        const PopularTVSeriesError('Server Failure'),
      ],
    );
  });

  // ===================== TopRatedTVSeriesBloc =====================
  group('TopRatedTVSeriesBloc', () {
    test('initial state is TopRatedTVSeriesEmpty', () {
      expect(
        TopRatedTVSeriesBloc(
                getTopRatedTVSeries: mockGetTopRatedTVSeries)
            .state,
        isA<TopRatedTVSeriesEmpty>(),
      );
    });

    blocTest<TopRatedTVSeriesBloc, TopRatedTVSeriesState>(
      'emits [Loading, Loaded] when FetchTopRatedTVSeries succeeds',
      build: () {
        when(mockGetTopRatedTVSeries.execute())
            .thenAnswer((_) async => Right(tTVSeriesList));
        return TopRatedTVSeriesBloc(
            getTopRatedTVSeries: mockGetTopRatedTVSeries);
      },
      act: (bloc) => bloc.add(FetchTopRatedTVSeries()),
      expect: () => [
        TopRatedTVSeriesLoading(),
        TopRatedTVSeriesLoaded(tTVSeriesList),
      ],
    );

    blocTest<TopRatedTVSeriesBloc, TopRatedTVSeriesState>(
      'emits [Loading, Error] when FetchTopRatedTVSeries fails',
      build: () {
        when(mockGetTopRatedTVSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return TopRatedTVSeriesBloc(
            getTopRatedTVSeries: mockGetTopRatedTVSeries);
      },
      act: (bloc) => bloc.add(FetchTopRatedTVSeries()),
      expect: () => [
        TopRatedTVSeriesLoading(),
        const TopRatedTVSeriesError('Server Failure'),
      ],
    );
  });
}
