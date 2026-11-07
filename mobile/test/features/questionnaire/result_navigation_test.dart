import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/features/navigation/data/destination_catalog.dart';

void main() {
  test('results exige acceso privado y snapshot completo', () {
    expect(
      destinationAllowed('/results', privateAccess: false, hasResult: true),
      isFalse,
    );
    expect(
      destinationAllowed('/results', privateAccess: true, hasResult: false),
      isFalse,
    );
    expect(
      destinationAllowed('/results', privateAccess: true, hasResult: true),
      isTrue,
    );
  });
}
