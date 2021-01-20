import 'package:movieinfo/modal/movie_response.dart';
import 'package:rxdart/rxdart.dart';

import '../repository/repository.dart';

class SearchBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<MovieResponse> _subject =
      BehaviorSubject<MovieResponse>();

  search(String value) async {
    MovieResponse response = await _repository.search(value);
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<MovieResponse> get subject => _subject;
}

final searchBloc = SearchBloc();
