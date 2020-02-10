
import 'dart:async';

import 'package:rxdart/subjects.dart';
import 'package:yellow_box/entity/ChildScreenKey.dart';

class ChildScreenRepository {
  final _currentChildScreenKey = BehaviorSubject<ChildScreenKey>.seeded(ChildScreenKey.HOME);

  Stream<ChildScreenKey> observeCurrentChildScreenKey() {
    return _currentChildScreenKey.distinct();
  }

  void setCurrentChildScreenKey(ChildScreenKey key) {
    _currentChildScreenKey.value = key;
  }
}