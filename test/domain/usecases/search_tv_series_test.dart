import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late SearchTVSeries usecase;
  late MockTVSeriesRepository mockTVSeriesRepository;

  setUp(() {
    mockTVSeriesRepository = MockTVSeriesRepository();
    usecase = SearchTVSeries(mockTVSeriesRepository);
  });

  final tTVSeries = <TVSeries>[];
  final tQuery = 'breaking bad';

  test('should get a list of tv series based on the query', () async {
    // arrange
    when(mockTVSeriesRepository.searchTVSeries(tQuery))
        .thenAnswer((_) async => Right(tTVSeries));
    // act
    final result = await usecase.execute(tQuery);
    // assert
    expect(result, Right(tTVSeries));
  });
}
