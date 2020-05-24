
import 'dart:async';

import 'package:rxdart/rxdart.dart';

extension StreamSubscriptionExtension on StreamSubscription {
  void addTo(CompositeSubscription compositeSubscription) {
    compositeSubscription.add(this);
  }
}