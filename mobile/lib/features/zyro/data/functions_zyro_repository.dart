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
    try {
      final result = await functions
          .httpsCallable('zyroRespond')
          .call(buildZyroPayload(requestId, message, context));
      return parseZyroReply(requestId, result.data);
    } on ZyroFailure {
      rethrow;
    } on FirebaseFunctionsException catch (error) {
      final kind = switch (error.code) {
        'resource-exhausted' => ZyroFailureKind.limited,
        'permission-denied' ||
        'unauthenticated' ||
        'failed-precondition' => ZyroFailureKind.denied,
        _ => ZyroFailureKind.unavailable,
      };
      throw ZyroFailure(kind);
    } catch (_) {
      throw const ZyroFailure(ZyroFailureKind.invalidResponse);
    }
  }
}

Map<String, Object?> buildZyroPayload(
  String requestId,
  String message,
  List<ZyroMessage> context,
) {
  final selected = <ZyroMessage>[];
  var characters = 0;
  for (final item in context.reversed) {
    if (selected.length == 8 || characters + item.text.length > 6000) break;
    selected.add(item);
    characters += item.text.length;
  }
  return {
    'schemaVersion': 1,
    'requestId': requestId,
    'message': message,
    'context': selected.reversed
        .map(
          (item) => {
            'role': item.role == ZyroRole.user ? 'user' : 'zyro',
            'text': item.text,
          },
        )
        .toList(),
  };
}

ZyroReply parseZyroReply(String requestId, Object? value) {
  if (value is! Map) {
    throw const ZyroFailure(ZyroFailureKind.invalidResponse);
  }
  final data = Map<String, dynamic>.from(value);
  const required = {
    'schemaVersion',
    'requestId',
    'kind',
    'message',
    'steps',
    'retryable',
    'policyVersion',
  };
  const optional = {'guideId', 'guideRevision'};
  if (!data.keys.toSet().containsAll(required) ||
      data.keys.any(
        (key) => !required.contains(key) && !optional.contains(key),
      ) ||
      data['schemaVersion'] != 1 ||
      data['requestId'] != requestId ||
      !const {'guide', 'general', 'limit'}.contains(data['kind']) ||
      data['message'] is! String ||
      data['steps'] is! List ||
      (data['steps'] as List).any((step) => step is! String) ||
      data['retryable'] is! bool ||
      data['policyVersion'] != 'zyro-policy-1' ||
      (data['guideId'] != null && data['guideId'] is! String) ||
      (data['guideRevision'] != null && data['guideRevision'] is! String)) {
    throw const ZyroFailure(ZyroFailureKind.invalidResponse);
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
    steps: (data['steps'] as List).cast<String>(),
    guideId: data['guideId'] as String?,
    guideRevision: data['guideRevision'] as String?,
  );
}
