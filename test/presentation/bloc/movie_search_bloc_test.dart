import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/presentation/bloc/movie_search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_search_bloc_test.mocks.dart';

@GenerateMocks([SearchMovies])
void main() {
  late MockSearchMovies mockSearchMovies;

  final tQuery = 'spiderman';
  final tMovie = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview: 'overview',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final tMovieList = <Movie>[tMovie];

  setUp(() {
    mockSearchMovies = MockSearchMovies();
  });

  test('initial state should be MovieSearchEmpty', () {
    expect(
      MovieSearchBloc(searchMovies: mockSearchMovies).state,
      isA<MovieSearchEmpty>(),
    );
  });

  blocTest<MovieSearchBloc, MovieSearchState>(
    'emits [Loading, Loaded] when search succeeds',
    build: () {
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Right(tMovieList));
      return MovieSearchBloc(searchMovies: mockSearchMovies);
    },
    act: (bloc) => bloc.add(OnMovieQueryChanged(tQuery)),
    expect: () => [
      MovieSearchLoading(),
      MovieSearchLoaded(tMovieList),
    ],
  );

  blocTest<MovieSearchBloc, MovieSearchState>(
    'emits [Loading, Error] when search fails',
    build: () {
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return MovieSearchBloc(searchMovies: mockSearchMovies);
    },
    act: (bloc) => bloc.add(OnMovieQueryChanged(tQuery)),
    expect: () => [
      MovieSearchLoading(),
      const MovieSearchError('Server Failure'),
    ],
  );
}
