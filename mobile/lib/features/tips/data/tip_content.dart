import 'dart:convert';

/// Public, versioned educational material. It never contains reader/account data.
class TipContent {
  TipContent._(
    this.categoryId,
    this.title,
    this.description,
    this.panelTitle,
    this.recommendations,
    this.example,
    this.explanation,
    this.advice,
    this.clarification,
    this.sourceIds,
  );

  static const ids = ['passwords', 'sharing', 'links', 'profiles'];
  static const catalogTitles = {
    'passwords': 'Contraseñas seguras',
    'sharing': 'Cuida lo que subes',
    'links': 'Enlaces sospechosos',
    'profiles': 'Perfiles falsos',
  };
  final String categoryId,
      title,
      description,
      panelTitle,
      explanation,
      advice,
      clarification;
  final List<String> recommendations, sourceIds;
  final Map<String, dynamic> example;
  String get catalogTitle => catalogTitles[categoryId]!;
  String get path => '/tips/$categoryId';

  static TipContent parse(String id, Map<String, dynamic> data) {
    Never invalid() => throw const FormatException('Contenido no disponible.');
    void keys(Map<dynamic, dynamic> map, Set<String> expected) {
      if (map.length != expected.length || !map.keys.every(expected.contains)) {
        invalid();
      }
    }

    String text(dynamic value, {bool empty = false}) {
      if (value is! String || (!empty && value.trim().isEmpty)) invalid();
      return value;
    }

    List<String> strings(dynamic value, {int? count}) {
      if (value is! List ||
          value.isEmpty ||
          (count != null && value.length != count)) {
        invalid();
      }
      return List<String>.unmodifiable(value.map((e) => text(e)));
    }

    if (!ids.contains(id)) invalid();
    try {
      if (utf8.encode(jsonEncode(data)).length > 32768) invalid();
    } on JsonUnsupportedObjectError {
      invalid();
    }
    keys(data, {
      'schemaVersion',
      'contentVersion',
      'categoryId',
      'status',
      'catalogTitle',
      'description',
      'title',
      'panelTitle',
      'recommendations',
      'example',
      'explanation',
      'advice',
      'clarification',
      'editorialReview',
    });
    if (data['schemaVersion'] is! int ||
        data['schemaVersion'] != 1 ||
        data['contentVersion'] != 'tips-1.0.0' ||
        data['categoryId'] != id ||
        data['status'] != 'approved' ||
        data['catalogTitle'] != catalogTitles[id]) {
      invalid();
    }
    final raw = data['example'];
    if (raw is! Map<String, dynamic>) invalid();
    final example = Map<String, dynamic>.from(raw as Map);
    const variants = {
      'passwords': {'kind', 'label', 'fictionalLabel', 'value', 'caption'},
      'sharing': {'kind', 'label', 'fictionalLabel', 'body', 'caption'},
      'links': {
        'kind',
        'label',
        'fictionalLabel',
        'body',
        'address',
        'caption',
      },
      'profiles': {
        'kind',
        'label',
        'fictionalLabel',
        'name',
        'handle',
        'signals',
        'avatar',
      },
    };
    keys(example, variants[id]!);
    final kind = const {
      'passwords': 'password',
      'sharing': 'post',
      'links': 'message',
      'profiles': 'profile',
    }[id];
    if (example['kind'] != kind || example['label'] != 'Ejemplo') invalid();
    for (final key in example.keys) {
      if (key == 'signals') {
        example[key] = strings(example[key], count: 3);
      } else {
        text(example[key]);
      }
    }
    if (id == 'links' && example['address'] != 'www.premio-regalo.example') {
      invalid();
    }
    if (id == 'profiles' && example['avatar'] != 'person') invalid();
    final review = data['editorialReview'];
    if (review is! Map) invalid();
    keys(review, {'version', 'approvedOn', 'sourceIds'});
    if (review['version'] != '1.0.0' || review['approvedOn'] != '2026-11-04') {
      invalid();
    }
    final sources = strings(review['sourceIds']);
    if (!sources.every(
      const {'N1', 'F4', 'G1', 'F1', 'F2a', 'F3a', 'R1', 'R2', 'H1'}.contains,
    )) {
      invalid();
    }
    final clarification = text(data['clarification'], empty: true);
    if (id == 'profiles' && clarification.trim().isEmpty) {
      invalid();
    }
    return TipContent._(
      id,
      text(data['title']),
      text(data['description']),
      text(data['panelTitle']),
      strings(data['recommendations'], count: 3),
      Map<String, dynamic>.unmodifiable(example),
      text(data['explanation']),
      text(data['advice']),
      clarification,
      sources,
    );
  }
}
