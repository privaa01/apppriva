import 'package:cloud_functions/cloud_functions.dart';

import '../domain/zyro_message.dart';
import 'zyro_repository.dart';

class FunctionsZyroRepository implements ZyroRepository {
  FunctionsZyroRepository(this.functions);
  final FirebaseFunctions functions;
  @override
  Future<ZyroReply> respond({
    required String requestId,
    required String message,
    required List<ZyroMessage> context,
  }) async {
    final contextStart = context.length > 8 ? context.length - 8 : 0;
    final result = await functions.httpsCallable('zyroRespond').call(
      <String, Object?>{
        'schemaVersion': 1,
        'requestId': requestId,
        'message': message,
        'context': context
            .skip(contextStart)
            .map(
              (m) => {
                'role': m.role == ZyroRole.user ? 'user' : 'zyro',
                'text': m.text,
              },
            )
            .toList(),
      },
    );
    final data = Map<String, dynamic>.from(result.data as Map);
    if (data['requestId'] != requestId ||
        data['message'] is! String ||
        data['steps'] is! List) {
      throw const FormatException();
    }
    final kind = switch (data['kind']) {
      'guide' => ZyroKind.guide,
      'limit' => ZyroKind.limit,
      _ => ZyroKind.general,
    };
    return ZyroReply(
      requestId: requestId,
      text: data['message'] as String,
      kind: kind,
      steps: (data['steps'] as List).whereType<String>().take(6).toList(),
    );
  }
}
