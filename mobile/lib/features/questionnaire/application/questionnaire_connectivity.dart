import 'package:flutter/foundation.dart';

abstract interface class QuestionnaireConnectivity implements Listenable {
  bool get available;
  Future<void> initialize();
}

class AlwaysAvailableConnectivity extends ChangeNotifier
    implements QuestionnaireConnectivity {
  @override
  bool get available => true;
  @override
  Future<void> initialize() async {}
}
