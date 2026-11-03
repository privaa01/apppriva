import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/features/navigation/data/destination_catalog.dart';

void main() {
  test(
    'closed catalog rejects unknowns and result without temporary precondition',
    () {
      for (final access in [false, true]) {
        expect(
          destinationAllowed('/arbitrary', privateAccess: access),
          isFalse,
        );
        expect(destinationAllowed('/results', privateAccess: access), isFalse);
        for (final route in destinations) {
          final expected = route.access != DestinationAccess.private || access;
          expect(
            destinationAllowed(
              route.path,
              privateAccess: access,
              hasResult: true,
            ),
            expected,
            reason: route.path,
          );
        }
      }
      expect(
        destinationFor('/tips/passwords')!.section,
        NavigationSection.tips,
      );
      expect(
        destinationFor('/results')!.section,
        NavigationSection.questionnaire,
      );
      expect(destinationFor('/signin')!.section, isNull);
    },
  );
}
