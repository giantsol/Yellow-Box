
import 'package:yellow_box/entity/ChildScreenKey.dart';
import 'package:yellow_box/ui/App.dart';

class SetChildScreen {
  final _childScreenRepository = dependencies.childScreenRepository;

  void invoke(ChildScreenKey key) {
    _childScreenRepository.setCurrentChildScreenKey(key);
  }
}