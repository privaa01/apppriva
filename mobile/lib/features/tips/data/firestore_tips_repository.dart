import 'package:cloud_firestore/cloud_firestore.dart';

import 'tip_content.dart';
import 'tips_repository.dart';

typedef TipsDocumentReader = Future<Map<String, dynamic>?> Function(String id);
typedef TipsServerDocumentReader = Future<Map<String, dynamic>?> Function(
  String collection,
  String id,
  GetOptions options,
);

class FirestoreTipsRepository implements TipsRepository {
  FirestoreTipsRepository(FirebaseFirestore database)
    : this.withServerReader(
        (collection, id, options) async =>
            (await database.collection(collection).doc(id).get(options)).data(),
      );
  FirestoreTipsRepository.withReader(TipsDocumentReader reader)
    : this.withServerReader((collection, id, options) => reader(id));
  FirestoreTipsRepository.withServerReader(this.read);
  final TipsServerDocumentReader read;
  @override
  Future<TipContent> loadDetail(String id) async {
    if (!TipContent.ids.contains(id)) {
      throw const TipsFailure(TipsFailureKind.unavailable);
    }
    try {
      final data = await read(
        'educational_tips',
        id,
        const GetOptions(source: Source.server),
      ).timeout(const Duration(seconds: 15));
      if (data == null) throw const FormatException();
      return TipContent.parse(id, data);
    } on FormatException {
      throw const TipsFailure(TipsFailureKind.unavailable);
    } on FirebaseException catch (error) {
      throw TipsFailure(
        error.code == 'permission-denied'
            ? TipsFailureKind.unavailable
            : TipsFailureKind.error,
      );
    } on TipsFailure {
      rethrow;
    } catch (_) {
      throw const TipsFailure(TipsFailureKind.error);
    }
  }

  @override
  Future<List<TipContent>> loadCatalog() =>
      Future.wait(TipContent.ids.map(loadDetail)).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw const TipsFailure(TipsFailureKind.error),
      );
}
