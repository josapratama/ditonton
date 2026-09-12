import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/presentation/bloc/watchlist_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_movie_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
  });

  test('initial state should be WatchlistMovieEmpty', () {
    expect(
      WatchlistMovieBloc(getWatchlistMovies: mockGetWatchlistMovies).state,
      isA<WatchlistMovieEmpty>(),
    );
  });

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'emits [Loading, Loaded] when FetchWatchlistMovies succeeds',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Right([testWatchlistMovie]));
      return WatchlistMovieBloc(getWatchlistMovies: mockGetWatchlistMovies);
    },
    act: (bloc) => bloc.add(FetchWatchlistMovies()),
    expect: () => [
      WatchlistMovieLoading(),
      WatchlistMovieLoaded([testWatchlistMovie]),
    ],
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'emits [Loading, Error] when FetchWatchlistMovies fails',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
      return WatchlistMovieBloc(getWatchlistMovies: mockGetWatchlistMovies);
    },
    act: (bloc) => bloc.add(FetchWatchlistMovies()),
    expect: () => [
      WatchlistMovieLoading(),
      const WatchlistMovieError("Can't get data"),
    ],
  );
}
