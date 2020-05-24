
import 'dart:async';

import 'package:rxdart/subjects.dart';
import 'package:yellow_box/entity/ChildScreenKey.dart';

class ChildScreenRepository {
  final BehaviorSubject<ChildScreenKey> _currentChildScreenKey = BehaviorSubject();

  ChildScreenRepository() {
    _currentChildScreenKey.value = ChildScreenKey.HOME;
  }

  Stream<ChildScreenKey> observeCurrentChildScreenKey() {
    return _currentChildScreenKey;
  }

  void setCurrentChildScreenKey(ChildScreenKey key) {
    _currentChildScreenKey.value = key;
  }
}