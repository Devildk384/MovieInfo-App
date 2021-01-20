import 'package:flutter/cupertino.dart';
import 'package:movieinfo/modal/cast_response.dart';
import 'package:movieinfo/modal/genre_response.dart';
import 'package:rxdart/rxdart.dart';
import '../repository/repository.dart';

class CastsBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<CastResponse> _subject =
      BehaviorSubject<CastResponse>();
  getCats(int id) async {
    CastResponse response = await _repository.getCasts(id);
    _subject.sink.add(response);
  }

  void drainStream() {
    _subject.value = null;
  }

  @mustCallSuper
  void dispose() async {
    await _subject.drain();
    _subject.close();
  }

  BehaviorSubject<CastResponse> get subject => _subject;
}

final castsBloc = CastsBloc();
