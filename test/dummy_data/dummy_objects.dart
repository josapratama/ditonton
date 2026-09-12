import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/data/models/tv_series_table.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

final testTVSeries = TVSeries(
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  firstAirDate: '2021-09-17',
  genreIds: [18, 80],
  id: 1396,
  name: 'Breaking Bad',
  originCountry: ['US'],
  originalLanguage: 'en',
  originalName: 'Breaking Bad',
  overview:
      'When Walter White, a New Mexico chemistry teacher, is diagnosed with Stage III cancer and given a prognosis of only two years left to live.',
  popularity: 369.594,
  posterPath: '/ggFHVNu6YYI5L9pCfOacjizRGt.jpg',
  voteAverage: 8.9,
  voteCount: 11000,
);

final testTVSeriesList = [testTVSeries];

final testTVSeriesDetail = TVSeriesDetail(
  backdropPath: 'backdropPath',
  firstAirDate: '2021-09-17',
  genres: [Genre(id: 1, name: 'Drama')],
  id: 1,
  name: 'name',
  numberOfEpisodes: 62,
  numberOfSeasons: 5,
  originalName: 'originalName',
  overview: 'overview',
  popularity: 369.594,
  posterPath: 'posterPath',
  seasons: [
    Season(
      airDate: '2008-01-20',
      episodeCount: 7,
      id: 3572,
      name: 'Season 1',
      overview: 'season overview',
      posterPath: '/poster.jpg',
      seasonNumber: 1,
    ),
  ],
  status: 'Ended',
  tagline: 'tagline',
  type: 'Scripted',
  voteAverage: 8.9,
  voteCount: 11000,
);

final testWatchlistTVSeries = TVSeries.watchlist(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTVSeriesTable = TVSeriesTable(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTVSeriesMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'name': 'name',
};
