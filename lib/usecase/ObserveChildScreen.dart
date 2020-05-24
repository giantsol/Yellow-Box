
import 'package:yellow_box/entity/ChildScreenKey.dart';
import 'package:yellow_box/ui/App.dart';

class ObserveChildScreen {
  final _childScreenRepository = dependencies.childScreenRepository;

  Stream<ChildScreenKey> invoke() {
    return _childScreenRepository.observeCurrentChildScreenKey();
  }
}