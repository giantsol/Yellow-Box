
import 'package:yellow_box/ui/App.dart';

class ShowMiniBox {
  final _miniBoxRepository = dependencies.miniBoxRepository;

  Future<bool> invoke() {
    return _miniBoxRepository.showMiniBox();
  }
}